import SwiftUI
import PhotosUI

class EditImage: Identifiable, Equatable {
    var id: String { name }
    var name: String
    var uiImage: UIImage?
    
    init(name: String, uiImage: UIImage? = nil) {
        self.name = name
        self.uiImage = uiImage
    }
    
    static func == (lhs: EditImage, rhs: EditImage) -> Bool {
        return lhs.name == rhs.name
    }
}

struct ItemEditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let newItemToggle: Bool
    
    @State private var inputItemType: ItemType = .others
    @State private var inputDescriptionText: String = ""
    
    @Binding var selectedItem: Item
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedUIImages: [EditImage] = []
    @State private var newMainImage: EditImage?
    @State private var favImage: EditImage?
    @State private var newImages: [EditImage] = []
    
    init(newItemToggle: Bool, selectedItem: Binding<Item>) {
        self.newItemToggle = newItemToggle
        self._selectedItem = selectedItem
        
        if !newItemToggle {
            let wrappedItem = selectedItem.wrappedValue
            
            self._inputItemType = State(initialValue: wrappedItem.type)
            self._inputDescriptionText = State(initialValue: wrappedItem.descriptionText ?? "")
            self._selectedUIImages = State(initialValue: Self.initSelectedUIImages(inputItem: wrappedItem))
            if let mainImage = wrappedItem.getMainImage(),
               let mainImageName = wrappedItem.mainImage {
                self._newMainImage = State(initialValue: EditImage(name: mainImageName, uiImage: mainImage))
            }
            
            if let mainName = wrappedItem.mainImage {
                self._favImage = State(initialValue: EditImage(name: mainName, uiImage: wrappedItem.getImage(imageName: mainName)))
            }
        }
    }
    
    static func initSelectedUIImages(inputItem: Item) -> [EditImage] {
        return inputItem.images.compactMap { imageName in
            let uiImage = inputItem.getImage(imageName: imageName)
            return EditImage(name: imageName, uiImage: uiImage)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    GeometryReader { geometry in
                        HStack(spacing: 16) {
                            FormSection(
                                inputItemType: $inputItemType,
                                inputDescriptionText: $inputDescriptionText
                            )
                            .frame(width: geometry.size.width * 0.6)
                            
                            PreviewSection(
                                newMainImage: $newMainImage,
                                favImage: $favImage,
                                selectedPhotos: $selectedPhotos,
                                selectedUIImages: $selectedUIImages,
                                newImages: $newImages,
                                selectedItem: selectedItem
                            )
                            .frame(width: geometry.size.width * 0.4)
                        }
                    }
                    
                    ItemImagesScrollView(
                        newMainImage: $newMainImage,
                        selectedUIImages: $selectedUIImages
                    )
                }
                .padding()
            }
            .navigationTitle("Item Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(newItemToggle ? "Add" : "Save") {
                        saveChanges()
                        dismiss()
                    }
                    .disabled(inputItemType == .others)
                }
            } // toolbar
        } // NavigationStack
    } // body
    
    private func saveChanges() {
        selectedItem.type = inputItemType
        selectedItem.descriptionText = inputDescriptionText
        
        if favImage == nil {
            favImage = selectedUIImages.first
        }
        
        if newItemToggle {
            addNewItem()
            resetState()
            selectedItem = Item()
        } else {
            updateExistingItem()
            resetState()
        }
        
    }
    
    private func addNewItem() {
        for editImage in selectedUIImages {
            if let uiImage = editImage.uiImage {
                guard let fileName = selectedItem.addImage(inputImage: uiImage, fileName: editImage.name) else { continue }
                if editImage.name == favImage?.name {
                    selectedItem.setMainImage(fileName)
                }
            }
        }
        
        let newItem = selectedItem
        context.insert(newItem)
    }
    
    private func updateExistingItem() {
        // Remove deleted images
        let updatedImageNames = selectedUIImages.map { $0.name }
        let imagesToDelete = selectedItem.images.filter { !updatedImageNames.contains($0) }
        
        for fileName in imagesToDelete {
            FileManagerUtil.deleteImage(fileName: fileName)
            selectedItem.removeImage(fileName: fileName)
        }
        
        // Add new images
        for editImage in newImages {
            if let uiImage = editImage.uiImage {
                _ = selectedItem.addImage(inputImage: uiImage, fileName: editImage.name)
            }
        }
        
        // Update main image if needed
        if let fav = self.favImage {
            selectedItem.setMainImage(fav.name)
        }
        
        try? context.save()
    }
    
    private func resetState() {
        inputItemType = .others
        inputDescriptionText = ""
        selectedUIImages = []
        newMainImage = nil
        favImage = nil
        newImages = []
    }
}

struct FormSection: View {
    @Binding var inputItemType: ItemType
    @Binding var inputDescriptionText: String
    
    var body: some View {
        Form {            
            Picker("Type", selection: $inputItemType) {
                ForEach(ItemType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $inputDescriptionText)
                    .frame(height: 150)
                
                if inputDescriptionText.isEmpty {
                    Text("ここに入力してください。")
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

struct PreviewSection: View {
    @Binding var newMainImage: EditImage?
    @Binding var favImage: EditImage?
    @Binding var selectedPhotos: [PhotosPickerItem]
    @Binding var selectedUIImages: [EditImage]
    @Binding var newImages: [EditImage]
    let selectedItem: Item
    
    var body: some View {
        VStack {
            if let mainImage = newMainImage?.uiImage,
               let object = selectedItem.generateSubjectImage(input: mainImage) {
                VStack {
                    Image(uiImage: object)
                        .resizable()
                        .scaledToFit()
                    
                    Button {
                        print("favorite button!")
                        favImage = newMainImage
                        print("next fav: \(favImage?.name ?? "no fav")")
                    } label: {
                        Image(systemName: favImage == newMainImage ? "star.fill" : "star")
                    }
                }
            } else {
                Text("画像が選択されていません")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            PhotosPicker(
                selection: $selectedPhotos,
                maxSelectionCount: 5,
                selectionBehavior: .ordered,
                matching: .images
            ) {
                Label("Add Photos", systemImage: "photo.on.rectangle")
                    .font(.title2)
            }
            .onChange(of: selectedPhotos) { _, photos in
                Task {
                    for photo in photos {
                        if let data = try? await photo.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            let editImage = EditImage(
                                name: FileManagerUtil.getUniqueImageFileName(),
                                uiImage: uiImage
                            )
                            selectedUIImages.append(editImage)
                            newImages.append(editImage)
                            
                            if newMainImage == nil {
                                newMainImage = editImage
                            }
                        }
                    }
                    selectedPhotos = []
                }
            }
        }
        .padding()
    }
}

struct ItemImagesScrollView: View {
    @Binding var newMainImage: EditImage?
    @Binding var selectedUIImages: [EditImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 15) {
                ForEach(selectedUIImages) { editImage in
                    if let uiImage = editImage.uiImage {
                        VStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(newMainImage == editImage ? Color.accentColor : Color.clear,
                                               lineWidth: 3)
                                )
                                .onTapGesture {
                                    newMainImage = editImage
                                }
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteImage(editImage)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 120)
    }
    
    private func deleteImage(_ editImage: EditImage) {
        if newMainImage == editImage {
            newMainImage = selectedUIImages.first
        }
        selectedUIImages.removeAll { $0.name == editImage.name }
    }
}
