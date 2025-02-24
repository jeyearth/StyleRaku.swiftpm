//
//  Item.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/18.
//

import SwiftUI
import SwiftData

enum ItemType: String, CaseIterable, Codable, Identifiable {
    case tops = "Tops"
    case bottoms = "Bottoms"
    case shoes = "Shoes"
    
    var id: String { rawValue }
    
    static func getDefaultSize(_ type: ItemType) -> Float {
        switch type {
        case .tops:
            return 240
        case .bottoms:
            return 160
        case .shoes:
            return 140
        }
    }
}

enum ItemViewType: String, CaseIterable, Identifiable {
    case all = "All"
    case tops = "Tops"
    case bottoms = "Bottoms"
    case shoes = "Shoes"
    
    var id: String { rawValue }
}

enum Season: String {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
}

struct ImageFile: Codable {
    let name: String
}

@Model
final class Item {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var descriptionText: String?
    var type: ItemType
    var spring: Bool
    var summer: Bool
    var autumn: Bool
    var winter: Bool
    var mainImage: String?
    var subjectImage: String?
    var imagesData: [ImageFile] = []
    var images: [String] {
        get { imagesData.map(\.self.name) }
        set { imagesData = newValue.compactMap { ImageFile(name: $0) } as? [ImageFile] ?? [] }
    }
    var size: Float
    
    init() {
        self.id = UUID()
        self.createdAt = Date()
        self.descriptionText = ""
        self.type = ItemType.tops
        self.spring = true
        self.summer = true
        self.autumn = true
        self.winter = true
        self.size = ItemType.getDefaultSize(ItemType.tops)
    }
    
    init(descriptionText: String, type: ItemType) {
        self.id = UUID()
        self.createdAt = Date()
        self.descriptionText = descriptionText
        self.type = type
        self.spring = true
        self.summer = true
        self.autumn = true
        self.winter = true
        self.size = ItemType.getDefaultSize(type)
    }
    
    init(descriptionText: String, type: ItemType, uiImageName: String,  _ spring: Bool, _ summer: Bool, _ autumn: Bool, _ winter: Bool) {
        self.id = UUID()
        self.createdAt = Date()
        self.descriptionText = descriptionText
        self.type = type
        self.size = ItemType.getDefaultSize(type)
        
        self.spring = spring
        self.summer = summer
        self.autumn = autumn
        self.winter = winter
        
        guard let uiImage: UIImage = UIImage(named: uiImageName) else { return }
        self.initImage(uiImage: uiImage)
    }
    
    func initImage(uiImage: UIImage) {
        guard let fileName = self.addImage(inputImage: uiImage) else { return }
        self.setMainImage(fileName)
    }
    
    //
    // Image
    //
    
    func getMainImage() -> UIImage? {
        guard let mainName = self.mainImage else { return nil }
        let main = FileManagerUtil.loadImage(fileName: mainName)
        return main
    }
    
    func getSubjectImage() -> UIImage? {
        guard let subjectName = self.subjectImage else { return nil }
        guard let subjectImage = self.getImage(imageName: subjectName) else { return nil }
        return subjectImage
    }
    
    func getImage(imageName: String) -> UIImage? {
        return FileManagerUtil.loadImage(fileName: imageName)?.resized(Percentage: 0.5)
    }
    
    func getImages() -> [UIImage]? {
        var uiImages: [UIImage] = []
        
        for imageName in self.images {
            guard let uiImage = self.getImage(imageName: imageName) else { continue }
            uiImages.append(uiImage)
        }
        
        if !uiImages.isEmpty {
            return uiImages
        } else {
            return nil
        }
    }
    
    func addImage(inputImage: UIImage) -> String? {
        guard let inputImageName = FileManagerUtil.saveImage(inputImage, fileName: FileManagerUtil.getUniqueImageFileName()) else {
            return nil
        }
        images.append(inputImageName)
        return inputImageName
    }
    
    func addImage(inputImage: UIImage, fileName: String) -> String? {
        guard let inputImageName = FileManagerUtil.saveImage(inputImage, fileName: fileName) else {
            return nil
        }
        images.append(inputImageName)
        return inputImageName
    }
    
    func saveImage(inputImage: UIImage) -> String? {
        guard let imageName = FileManagerUtil.saveImage(inputImage, fileName: FileManagerUtil.getUniqueImageFileName()) else { return nil }
        return imageName
    }
    
    func removeImage(fileName: String) {
        images.removeAll { $0 == fileName }
        FileManagerUtil.deleteImage(fileName: fileName)
    }
    
    func setMainImage(_ fileName: String) {
        if let subject = self.subjectImage {
            FileManagerUtil.deleteImage(fileName: subject)
        }
        
        self.mainImage = fileName
        print("self mainImage: \(self.mainImage ?? "no mainImage")")
        self.setSubjectImage()
    }
    
    func setSubjectImage() {
        guard let main = getMainImage() else { return }
        guard let subject = self.generateSubjectImage(input: main) else { return }
        guard let subjectName = self.saveImage(inputImage: subject) else { return }
        self.subjectImage = subjectName
        print("setSubjectImage")
    }
    
    func generateSubjectImage(input: UIImage) -> UIImage? {
        
        guard let cgImage = input.cgImage else {
            print("Conversion from UIImage to CGImage failed")
            return nil
        }
        
        let ciImage = CIImage(cgImage: cgImage)
        print("Successfully converted to CIImage: \(ciImage)")
        
        let imageHelper = SubjectLiftingHelper()
        guard let outputCIImage = imageHelper.doSubjectLifting(from: ciImage, croppedToInstanceExtent: true) else {
            print("Subject is missing.")
            return nil
        }
        
        guard let outputCGImage = imageHelper.render(ciImage: outputCIImage) as CGImage? else {
            print("Failed to generate CGImage")
            return nil
        }
        
        let outputImage = UIImage(cgImage: outputCGImage, scale: input.scale, orientation: input.imageOrientation)
        
        return outputImage
    }
    
    func deleteItemImages() {
        
        // mainImage
        if let mainImageName = self.mainImage {
            self.removeImage(fileName: mainImageName)
        }
        
        // subjectImage
        if let subjectImageName = self.subjectImage {
            self.removeImage(fileName: subjectImageName)
        }
        
        for imageName in images {
            self.removeImage(fileName: imageName)
        }
        
    }
    
}
