import SwiftUI
import SwiftData
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
    @Query var items: [Item]
    @Environment(\.dismiss) private var dismiss
    
    let newItemToggle: Bool
    
    @EnvironmentObject private var viewModel: StylingDetailViewModel
    
    @State private var inputItemType: ItemType? = nil
    @State private var inputDescriptionText: String = ""
    @State private var spring: Bool = true
    @State private var summer: Bool = true
    @State private var autumn: Bool = true
    @State private var winter: Bool = true
    
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
            self._spring = State(initialValue: wrappedItem.spring)
            self._summer = State(initialValue: wrappedItem.summer)
            self._autumn = State(initialValue: wrappedItem.autumn)
            self._winter = State(initialValue: wrappedItem.winter)
            
            self._selectedUIImages = State(initialValue: Self.initSelectedUIImages(inputItem: wrappedItem))
            
            if let mainImageName = wrappedItem.mainImage {
                self._favImage = State(initialValue: EditImage(name: mainImageName, uiImage: wrappedItem.getImage(imageName: mainImageName)))
                if let mainImage = wrappedItem.getMainImage() {
                    self._newMainImage = State(initialValue: EditImage(name: mainImageName, uiImage: mainImage))
                }
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
                                inputDescriptionText: $inputDescriptionText,
                                spring: $spring,
                                summer: $summer,
                                autumn: $autumn,
                                winter: $winter
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
            .ignoresSafeArea(.keyboard, edges: .all)
            .navigationTitle(newItemToggle ? "New Item" : "Edit Item")
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
                    .disabled(selectedUIImages.isEmpty || inputItemType == nil)
                }
            } // toolbar
        } // NavigationStack
    } // body
    
    private func saveChanges() {
        guard let inputItemType = inputItemType else { return }
        selectedItem.type = inputItemType
        selectedItem.descriptionText = inputDescriptionText
        selectedItem.spring = self.spring
        selectedItem.summer = self.summer
        selectedItem.autumn = self.autumn
        selectedItem.winter = self.winter
        
        selectedItem.size = ItemType.getDefaultSize(selectedItem.type)
        
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
        if favImage == nil {
            favImage = selectedUIImages.first
        }
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
            selectedItem.removeImage(fileName: fileName)
            if favImage?.name == fileName {
                favImage = nil
            }
        }
        
        if favImage == nil {
            favImage = selectedUIImages.first
        }
        
        for editImage in newImages {
            if !selectedUIImages.contains(editImage) { continue }
            if let uiImage = editImage.uiImage {
                _ = selectedItem.addImage(inputImage: uiImage, fileName: editImage.name)
            }
        }
        
        if let fav = self.favImage {
            selectedItem.setMainImage(fav.name)
        }
        
        viewModel.updateShuffleData(items)
    }
    
    private func resetState() {
        inputItemType = nil
        inputDescriptionText = ""
        spring = true
        summer = true
        autumn = true
        winter = true
        selectedUIImages = []
        newMainImage = nil
        favImage = nil
        newImages = []
    }
}

struct FormSection: View {
    @Binding var inputItemType: ItemType?
    @Binding var inputDescriptionText: String
    @Binding var spring: Bool
    @Binding var summer: Bool
    @Binding var autumn: Bool
    @Binding var winter: Bool
    
    @State var isSelectedSpring: Bool = true
    
    @ViewBuilder
    private func SeasonToggleButton(season: Season, isOn: Binding<Bool>) -> some View {
        Button {
            isOn.wrappedValue.toggle()
        } label: {
            HStack {
                Text(season.rawValue)
                Spacer()
                Image(systemName: isOn.wrappedValue ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    var body: some View {
        Form {
            Picker("Type", selection: $inputItemType) {
                Text("None").tag(nil as ItemType?)
                ForEach(ItemType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type as ItemType?)
                }
            }
            .pickerStyle(.menu)
            
            Menu("Season") {
                SeasonToggleButton(season: .spring, isOn: $spring)
                SeasonToggleButton(season: .summer, isOn: $summer)
                SeasonToggleButton(season: .autumn, isOn: $autumn)
                SeasonToggleButton(season: .winter, isOn: $winter)
            }
            .menuActionDismissBehavior(.disabled)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $inputDescriptionText)
                    .frame(height: 120)
                
                if inputDescriptionText.isEmpty {
                    Text("Description")
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
    @State private var isShowingCamera = false
    
    var body: some View {
        VStack {
            if let mainImage = newMainImage?.uiImage,
               let object = selectedItem.generateSubjectImage(input: mainImage) {
                VStack {
                    Spacer()
                    Image(uiImage: object)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    Button {
                        print("favorite button!")
                        favImage = newMainImage
                        print("next fav: \(favImage?.name ?? "no fav")")
                    } label: {
                        Image(systemName: favImage == newMainImage ? "star.fill" : "star")
                            .font(.title2)
                            .padding(.vertical, 20)
                    }
                }
            } else {
                Spacer()
                Text("No Image")
                    .foregroundColor(.gray)
                Spacer()
            }
            
            HStack {
                PhotosPicker(
                    selection: $selectedPhotos,
                    maxSelectionCount: 5,
                    selectionBehavior: .ordered,
                    matching: .images
                ) {
                    Label("Photo Library", systemImage: "photo.on.rectangle")
                        .labelStyle(IconOnlyLabelStyle())
                        .font(.title2)
                        .padding(.horizontal, 4)
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
                
                Button {
                    isShowingCamera = true
                } label: {
                    Label("Camera", systemImage: "camera")
                        .labelStyle(IconOnlyLabelStyle())
                        .font(.title2)
                        .padding(.horizontal, 4)
                }
            } // HStack
        } // VStack
        .padding()
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraView { image in
                if let image = image {
                    let editImage = EditImage(
                        name: FileManagerUtil.getUniqueImageFileName(),
                        uiImage: image
                    )
                    selectedUIImages.append(editImage)
                    newImages.append(editImage)
                    if newMainImage == nil {
                        newMainImage = editImage
                    }
                }
                isShowingCamera = false
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    var onImagePicked: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                let uiImage = getCorrectOrientationUIImage(uiImage: image)
                parent.onImagePicked(uiImage)
            } else {
                parent.onImagePicked(nil)
            }
        }
        
        private func getCorrectOrientationUIImage(uiImage:UIImage) -> UIImage {
            var editedImage = UIImage()
            let ciContext = CIContext(options: nil)
            
            switch uiImage.imageOrientation {
            case .left:
                guard let orientedCIImage = CIImage(image: uiImage)?.oriented(.left),
                      let cgImage = ciContext.createCGImage(orientedCIImage, from: orientedCIImage.extent) else {
                    return uiImage
                }
                editedImage = UIImage(cgImage: cgImage)
            case .down:
                guard let orientedCIImage = CIImage(image: uiImage)?.oriented(.down),
                      let cgImage = ciContext.createCGImage(orientedCIImage, from: orientedCIImage.extent) else {
                    return uiImage
                }
                editedImage = UIImage(cgImage: cgImage)
            case .right:
                guard let orientedCIImage = CIImage(image: uiImage)?.oriented(.right),
                      let cgImage = ciContext.createCGImage(orientedCIImage, from: orientedCIImage.extent) else {
                    return uiImage
                }
                editedImage = UIImage(cgImage: cgImage)
            default:
                editedImage = uiImage
            }
            
            return editedImage
        }
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
                                .frame(height: 160)
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
        .frame(height: 180)
    }
    
    private func deleteImage(_ editImage: EditImage) {
        if newMainImage == editImage {
            newMainImage = selectedUIImages.first
        }
        selectedUIImages.removeAll { $0.name == editImage.name }
    }
}
