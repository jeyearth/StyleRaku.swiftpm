//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/19.
//

import SwiftUI
import SwiftData

struct StylePreviewView: View {
    @Query var items: [Item]
    
    @Binding var selectedStyle: Style?
    @Binding var addItem: Item?
    @Binding var draggingItem: Item?
    @Binding var selectedItemType: ItemType?
    @Binding var selectedItem: Item?
    @State private var isDropping: Bool = false  // ドロップエリア判定
    
    init(selectedStyle: Binding<Style?>, addItem: Binding<Item?>, draggingItem: Binding<Item?>, selectedItemType: Binding<ItemType?>, selectedItem: Binding<Item?>) {
        self._selectedStyle = selectedStyle
        self._addItem = addItem
        self._draggingItem = draggingItem
        self._selectedItemType = selectedItemType
        self._selectedItem = selectedItem
    }
    
    // 画像表示用のビューコンポーネント
    @ViewBuilder
    private func itemImageView(size: CGFloat, type: ItemType, image: UIImage, position: CGPoint) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke((self.selectedItemType == type ? Color.accentColor : Color.clear), lineWidth: 3)
                    .fill(self.draggingItem?.type == type && self.isDropping ? Color.gray.opacity(0.4) : Color.clear)
            )
//            .position(position)
            .offset(x: position.x, y: position.y)
//            .offset(x: position.x - (size / image.size.width) * image.size.width / 2, y: position.y - (size / image.size.width) * image.size.height / 2)
            .onTapGesture {
                self.selectedItemType = type
                self.selectedItem = selectedStyle?.getItem(type)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if let unwrap = selectedStyle {
                            unwrap.updatePosition(for: type, to: gesture.location)
                        }
                        self.selectedItemType = type
                        print(gesture.location)
                    }
                    .onEnded {_ in 
                        self.selectedItemType = nil
                    }
            )
        
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItemType = nil
                        selectedItem = nil
                    }
                
                // Shoes
                if let shoes = selectedStyle?.shoes,
                   let shoesImage = shoes.getSubjectImage(),
                   let shoesPosition = selectedStyle?.shoesPosition {
                    itemImageView(size: CGFloat(shoes.size), type: shoes.type, image: shoesImage, position: shoesPosition)
                }
                
                // Bottoms
                if let bottoms = selectedStyle?.bottoms,
                   let bottomsImage = bottoms.getSubjectImage(),
                   let bottomsPosition = selectedStyle?.bottomsPosition {
                    itemImageView(size: CGFloat(bottoms.size), type: bottoms.type, image: bottomsImage, position: bottomsPosition)
                }
                
                // Tops
                if let tops = selectedStyle?.tops,
                   let topsImage = tops.getSubjectImage(),
                   let topsPosition = selectedStyle?.topsPosition {
                    itemImageView(size: CGFloat(tops.size), type: tops.type, image: topsImage, position: topsPosition)
                }
            } // ZStack
        } // VStack
        .padding()
//        .overlay(  // 枠線を動的に表示
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(isDropping ? Color.blue : Color.clear, lineWidth: 4)
//        )
        .onDrop(of: ["public.text"], isTargeted: Binding(
            get: { isDropping },
            set: { isDropping = $0 }
        )) { providers in
            providers.first?.loadObject(ofClass: NSString.self) { itemID, _ in
                if let itemID = itemID as? String, let uuid = UUID(uuidString: itemID) {
                    DispatchQueue.main.async {
                        if let droppedItem = findItem(by: uuid) {
                            selectedStyle?.setItem(item: droppedItem)
                        }
                    }
                }
            }
            isDropping = false
            draggingItem = nil
            selectedItemType = nil
            return true
        }
    } // body
    
    private func findItem(by id: UUID) -> Item? {
        return items.first { $0.id == id }
    }
    
}

//#Preview {
//    StylePreviewView(selectedStyle: .constant(Style()), addItem: .constant(Item()))
//}
