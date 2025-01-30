////
////  ItemEditView.swift
////  StyleRaku
////
////  Created by Jey Hirano on 2025/01/24
////
////
//
//import SwiftUI
//import PhotosUI
//
//class EditImage {
//    var name: String = ""
//    var uiImage: UIImage?
//    
//    init(name : String, uiImage : UIImage? = nil) {
//        self.name = name
//        self.uiImage = uiImage
//    }
//}
//
//struct ItemEditView: View {
//    
//    @Environment(\.modelContext) private var context
//    
//    let newItemToggle: Bool   // Item追加か編集かの真偽値
//    
//    @State var inputName: String = ""
//    @State var inputItemType: ItemType = .others
//    @State var inputDescriptionText: String = ""
//    
//    @Binding var showingSheet: Bool
//    @Binding var selectedItem: Item
//    
//    @State private var selectedPhotos: [PhotosPickerItem] = []
//    @State private var selectedUIImages: [EditImage] = []
//    @State private var newMainImage: UIImage?
//    
//    @State private var favImage: UIImage?
//    @State private var newImages: [UIImage] = []
//    
//    init(newItemToggle: Bool, showingSheet: Binding<Bool>, selectedItem: Binding<Item>) {
//        self.newItemToggle = newItemToggle
//        self._showingSheet = showingSheet
//        self._selectedItem = selectedItem
//        
//        if !newItemToggle {
//            let wrappedItem = selectedItem.wrappedValue
//            self._inputName = State(initialValue: wrappedItem.name)
//            self._inputItemType = State(initialValue: wrappedItem.type)
//            self._inputDescriptionText = State(initialValue: wrappedItem.descriptionText ?? "")
//            
//            self._selectedUIImages = State(initialValue: self.initSelectedUIImages(inputItem: wrappedItem))
//            self._newMainImage = State(initialValue: wrappedItem.getMainImage())
//        }
//    }
//    
//    func initSelectedUIImages(inputItem: Item) -> [EditImage] {
//        let images = inputItem.images
//        var editImages: [EditImage] = []
//        for image in images {
//            let uiImage = inputItem.getImage(imageName: image)
//            let editImage = EditImage(name: image, uiImage: uiImage)
//            editImages.append(editImage)
//        }
//        return editImages
//    }
//    
//    func addEditImage(uiImage : UIImage) {
//        let editImage = EditImage(name: FileManagerUtil.getUniqueImageFileName(), uiImage: uiImage)
//        self.selectedUIImages.append(editImage)
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color(.systemGray6)   // 背景色
//                VStack {
//                    GeometryReader { geometry in
//                        HStack(spacing: 0) {
//                            // 左側: ItemリストView（6割幅）
//                            Form {
//                                // Name
//                                TextField("name", text: $inputName)
//                                // ItemType
//                                Picker("Type", selection: $inputItemType) {
//                                    ForEach(ItemType.allCases) { type in
//                                        Text(type.rawValue).tag(type)
//                                    }
//                                }
//                                .pickerStyle(.menu)
//                                // Description
//                                ScrollView {
//                                    ZStack(alignment: .topLeading) {
//                                        TextEditor(text: $inputDescriptionText)
//                                            .frame(height: 150)
//                                        if selectedItem.descriptionText?.isEmpty ?? true  {
//                                            Text("ここに入力してください。")
//                                                .foregroundColor(Color(uiColor: .placeholderText))
//                                                .allowsHitTesting(false)
//                                                .padding(7)
//                                                .padding(.top, 2)
//                                        }
//                                    }
//                                }
//                            } // VStack
//                            .frame(width: geometry.size.width * 0.60)
//                            // 右側: プレビューView（4割幅）
//                            VStack {
//                                if let mainImage = self.newMainImage {
//                                    if let object = selectedItem.generateSubjectImage(input: mainImage) {
//                                        VStack {
//                                            Image(uiImage: object)
//                                                .resizable()
//                                                .scaledToFit()
//                                            Button(action: {
//                                                self.favImage = self.newMainImage
//                                            }, label: {
//                                                let isFav = self.favImage == self.newMainImage ? true : false
//                                                Image(systemName: isFav ? "star.fill" : "star")
//                                            })
//                                        }
//                                    } else {
//                                        Text("object が見つかりません。")
//                                    }
//                                } else {
//                                    Text("main Imageが選択されていません。")
//                                }
//                                Spacer()
//                                PhotosPicker(
//                                    selection: $selectedPhotos,
//                                    maxSelectionCount: 5,
//                                    selectionBehavior: .ordered,
//                                    matching: .images
//                                ) {
//                                    Image(systemName: "photo.on.rectangle")
//                                }
//                                .padding(.trailing, 20)
//                                .font(.title2)
//                                .onChange(of: selectedPhotos) {_ ,photos in
//                                    // 複数選択されたアイテムをUIImageに変換してプロパティに格納していく
//                                    Task {
//                                        selectedPhotos = []
//                                        
//                                        for photo in photos {
//                                            guard let data = try await photo.loadTransferable(type: Data.self) else { continue }
//                                            guard let uiImage = UIImage(data: data) else { continue }
////                                            self.selectedUIImages.append(uiImage)
//                                            self.addEditImage(uiImage: uiImage)
//                                            self.newImages.append(uiImage)
//                                        }
//                                        
//                                        if !selectedUIImages.isEmpty {
//                                            if newMainImage == nil {
//                                                self.newMainImage = selectedUIImages[0].uiImage
//                                            }
//                                        }
//                                    }
//                                }
//                            } // VStack
//                            .frame(width: geometry.size.width * 0.40)
//                        } // HStack
//                    } // GeometryReader
//                    
//                    ItemImagesScrollView(newMainImage: $newMainImage, images: $selectedUIImages)
////
////                    if newItemToggle {
////                        ItemImagesScrollView(newMainImage: $newMainImage, images: $selectedUIImages)
////
////                    } else {
////                        // Item ギャラリー
////                        VStack {
////                            ScrollView {
////                                ForEach(selectedItem.images, id: \.self) { imageName in
////                                    HStack {
////                                        if let image = FileManagerUtil.loadImage(fileName: imageName) {
////                                            Image(uiImage: image)
////                                                .resizable()
////                                                .scaledToFit()
////                                        } else {
////                                            Text("no image")
////                                        }
////                                    }
////                                }
////                            }
////                        }
////                    } // if
//                    
//                }
//                .toolbar {
//                    ToolbarItem(placement: .cancellationAction) {
//                        Button("Cancel") {
//                            showingSheet.toggle()
//                        }
//                    }
//                    ToolbarItem(placement: .principal) {
//                        Text("Item Detail")
//                            .fontWeight(.bold)
//                    }
//                    ToolbarItem(placement: .confirmationAction) {
//                        if newItemToggle {
//                            Button("Add") {
//                                print("add!")
//                                self.reflectInput()
////                                self.addNewItem(newItem: self.selectedItem)
//                                showingSheet.toggle()
//                            }
//                        } else {
//                            Button("Save") {
//                                self.reflectInput()
//                                self.saveItem()
//                                showingSheet.toggle()
//                            }
//                        }
//                    }
//                } // VStack
//            }
//        } // NavigationStack
//    }
//    
//    func reflectInput() {
//        self.selectedItem.name = self.inputName
//        self.inputName = ""
//        self.selectedItem.type = self.inputItemType
//        self.inputItemType = ItemType.others
//        self.selectedItem.descriptionText = self.inputDescriptionText
//        self.inputDescriptionText = ""
//    }
//    
////    func addNewItem(newItem: Item) {
////        if self.favImage == nil {
////            self.favImage = self.selectedUIImages.first?.uiImage
////        }
////        for uiImage in selectedUIImages {
////            let fileName = newItem.addImage(inputImage: uiImage)
////            if uiImage == self.favImage, let imageName = fileName {
////                newItem.setMainImage(imageName)
////            }
////        }
////        context.insert(newItem)
////        self.selectedItem = Item()
////        self.favImage = nil
////        self.newImages = []
////    }
//    
//    func saveItem() {
//        print("Saving item...")
////
////        // 1. 現在の画像リスト（ファイル名）を取得
////        let existingImages = selectedItem.images
////
////        // 2. `selectedUIImages` と比較して削除対象を特定
////        let updatedImages = selectedUIImages.compactMap { uiImage in
////            FileManagerUtil.fileName(for: uiImage) // FileManagerUtilでUIImageからファイル名を取得
////        }
////
////        let imagesToDelete = existingImages.filter { !updatedImages.contains($0) }
////
////        // 3. 削除対象の画像をファイルシステムと `selectedItem` から削除
////        for fileName in imagesToDelete {
////            if FileManagerUtil.deleteImage(fileName: fileName) {
////                selectedItem.removeImage(fileName: fileName) // removeImage() は Item のメソッド
////            } else {
////                print("Failed to delete image: \(fileName)")
////            }
////        }
////
////        // 4. 新規画像を保存
////        for uiImage in newImages {
////            _ = selectedItem.addImage(inputImage: uiImage) // 画像を保存して `selectedItem` に追加
////        }
////
////        // 5. `newImages` をリセット
////        newImages.removeAll()
////
////        print("Item saved successfully!")
//    }
//    
//    
////    func saveItem() {
////        print("save !")
////        // selectedUIImagesをitemに追加
////        for uiImage in self.newImages {
////            _ = self.selectedItem.addImage(inputImage: uiImage)
////        }
////
////        self.newImages = []
////
////    }
//    
//}
//
////#Preview {
////    ItemEditView(newItemToggle: true, showingSheet: .constant(true), selectedItem: .constant(Item()))
////}
//
//struct ItemImagesScrollView: View {
//    
//    @Binding var newMainImage: UIImage?
//    @Binding var images: [EditImage]
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: true) {
//            HStack(spacing: 15) {
//                ForEach(images, id: \.self.name) { image in
//                    let isSelected: Bool = (newMainImage == image.uiImage ? true : false)
//                    VStack {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .overlay(RoundedRectangle(cornerRadius: 10)
//                                .stroke((isSelected ? Color.accentColor : Color.clear), lineWidth: 3)
//                            )
//                            .onTapGesture(perform: {
//                                newMainImage = image
//                            })
//                    }
//                    .contextMenu {
//                        Button(role: .destructive) {
//                            self.deleteImage(image: image)
//                            print("Delete!")
//                        } label: {
//                            Label("Delete", systemImage: "trash")
//                        }
//                    }
//                    
//                }
//            } // HStack
//            .padding()
//        } // ScrollView
//    }
//    
//    private func deleteImage(image: UIImage) {
//        // newMainImageが削除対象の場合、nilに設定
//        if newMainImage == image {
//            newMainImage = nil
//        }
//        
//        // 画像を配列から削除
//        if let index = images.firstIndex(of: image) {
//            images.remove(at: index)
//            print("画像を削除しました。")
//        } else {
//            print("削除対象の画像が見つかりませんでした。")
//        }
//        
//    }
//    
//}
