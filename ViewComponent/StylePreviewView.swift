//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/19.
//

import SwiftUI

struct StylePreviewView: View {
    
    @Binding var selectedStyle: Style?
    @Binding var addItem: Item?
    
    @State var selectedItemType: ItemType?
    
    init(selectedStyle: Binding<Style?>, addItem: Binding<Item?>) {
        self._selectedStyle = selectedStyle
        self._addItem = addItem

        // addItem が nil の場合の処理を追加
        if let item = addItem.wrappedValue {
            selectedStyle.wrappedValue?.setItem(item: item)
        }
    }
    
    // addItemの変更を監視して処理を行う
    private func handleAddItem() {
        if let item = addItem {
            selectedStyle?.setItem(item: item)
            // アイテムをセットした後、addItemをnilに戻す
            self.addItem = nil
        }
    }
    
    // 画像表示用のビューコンポーネント
    @ViewBuilder
    private func itemImageView(size: CGFloat, type: ItemType, image: UIImage, position: CGPoint) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke((self.selectedItemType == type ? Color.accentColor : Color.clear), lineWidth: 3)
                
            )
        //            .position(position)
            .offset(x: position.x - (size / image.size.width) * image.size.width / 2, y: position.y - (size / image.size.width) * image.size.height / 2)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if let unwrap = selectedStyle {
                            unwrap.updatePosition(for: type, to: gesture.location)
                            print(gesture.location)
                        }
                        self.selectedItemType = type
                    }
            )
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "face.smiling")
                Spacer()
                Image(systemName: "arkit")
            }
            Spacer()
            VStack {
//                GeometryReader { geometry in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.blue)
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                        VStack {
//                            Text("親ビューの横幅: \(geometry.size.width)")
//                            Text("親ビューの高さ: \(geometry.size.height)")
//                            Text("親ビューの横幅中心: \(geometry.frame(in: .local).midX)")
//                            Text("親ビューの高さ幅中心: \(geometry.frame(in: .local).midY)")
//                        }
//                    }
//                }
                ZStack {  // VStackをZStackに変更して重ね表示
                    // Face
                    //                if let face = selectedStyle?.face,
                    //                   let faceImage = face.getImage(),
                    //                   let facePosition = selectedStyle?.facePosition {
                    //                    itemImageView(image: faceImage, position: facePosition)
                    //                }
                    
                    // Tops
                    if let tops = selectedStyle?.tops,
                       let topsImage = tops.getSubjectImage(),
                       let topsPosition = selectedStyle?.topsPosition {
                        itemImageView(size: 200, type: tops.type, image: topsImage, position: topsPosition)
                    }
                    
                    // Bottoms
                    if let bottoms = selectedStyle?.bottoms,
                       let bottomsImage = bottoms.getSubjectImage(),
                       let bottomsPosition = selectedStyle?.bottomsPosition {
                        itemImageView(size: 150, type: bottoms.type, image: bottomsImage, position: bottomsPosition)
                    }
                    
                    // Shoes
                    if let shoes = selectedStyle?.shoes,
                       let shoesImage = shoes.getSubjectImage(),
                       let shoesPosition = selectedStyle?.shoesPosition {
                        itemImageView(size: 100, type: shoes.type, image: shoesImage, position: shoesPosition)
                    }
                    
                    // Others
                    //                ForEach(selectedStyle?.others ?? [], id: \.item.id) { itemPosition in
                    //                    if let image = itemPosition.item.getSubjectImage() {
                    //                        itemImageView(image: image, position: itemPosition.position)
                    //                    }
                    //                }
                    
                }
            }
            
            Spacer()
            HStack {
                Image(systemName: "arrow.uturn.left.circle")
                Image(systemName: "arrow.uturn.right.circle")
                Spacer()
                Image(systemName: "person.and.background.dotted")
                Image(systemName: "squareshape.controlhandles.on.squareshape.controlhandles")
            }
        } // VStack
        .padding()
        .onChange(of: addItem) {_, newItem in
            handleAddItem()
        }
    } // body
}

//#Preview {
//    StylePreviewView(selectedStyle: .constant(Style()), addItem: .constant(Item()))
//}
