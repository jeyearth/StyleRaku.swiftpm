//
//  FileManagerUtil.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/01/24
//  
//

import UIKit

struct FileManagerUtil {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func getUniqueImageFileName() -> String {
        return UUID().uuidString + ".png"
    }
    
    static func saveImage(_ image: UIImage, fileName: String) -> String? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = image.pngData() {
            do {
                try data.write(to: fileURL)
                return fileURL.lastPathComponent
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        } else {
            print("Failed to generate PNG data.")
            return nil
        }
    }
    
    static func loadImage(fileName: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    static func deleteImage(fileName: String) {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error deleting image: \(error)")
            }
        }
    }
}
