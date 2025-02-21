//
//  ItemControlView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/04
//  
//

import SwiftUI

struct ItemControlView: View {
    private let X: Int = 0
    private let Y: Int = 1
    
    private let nilItemSizeNum: Float = 10
    
    let moveButtonSize: CGFloat = 40
    
    @Binding var selectedStyle: Style?
    @Binding var selectedItem: Item?
    @State var count: Float
    
    init(selectedStyle: Binding<Style?>, selectedItem: Binding<Item?>) {
        self._selectedStyle = selectedStyle
        self._selectedItem = selectedItem
        self._count = State(initialValue: selectedItem.wrappedValue?.size ?? nilItemSizeNum)
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Spacer()
                    VStack {
                        if let item = selectedItem, let subjectImage = item.getSubjectImage() {
                            Image(uiImage: subjectImage)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Spacer()
                    Stepper(value: $count, in: 50...400, step: 1) {
                        if count != nilItemSizeNum {
                            Text("Size: \(Int(count))")
                        } else {
                            Text("Size: -")
                        }
                    }
                    .onChange(of: count) { _, newValue in
                        selectedItem?.size = newValue
                    }
                    
                    HStack {
                        Spacer()
                        Button  {
                            print("do align.horizontal.center")
                            
                            selectedStyle?.topsPosition.x = 0
                            selectedStyle?.bottomsPosition.x = 0
                            selectedStyle?.shoesPosition.x = 0
                        } label: {
                            Image(systemName: "align.horizontal.center")
                                .font(.title2)
                                .foregroundColor(Color.secondary)
                        }
                    }
                    
                    VStack {
                        Button  {
                            self.updatePosition(-1, for: Y, selectedItem: selectedItem)
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: moveButtonSize, height: moveButtonSize)
                        }
                        
                        HStack {
                            Button  {
                                self.updatePosition(-1, for: X, selectedItem: selectedItem)
                            } label: {
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: moveButtonSize, height: moveButtonSize)
                            }
                            
                            Spacer().frame(width: moveButtonSize + 10) // 中央の空間
                            
                            Button  {
                                self.updatePosition(1, for: X, selectedItem: selectedItem)
                            } label: {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width: moveButtonSize, height: moveButtonSize)
                            }
                        }
                        
                        Button  {
                            self.updatePosition(1, for: Y, selectedItem: selectedItem)
                        } label: {
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: moveButtonSize, height: moveButtonSize)
                        }
                    }
                }
                .disabled(selectedItem == nil)
                .frame(width: 180)
                .frame(maxHeight: .infinity)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground)) // 背景色を白に設定
            )
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
        .padding(.bottom, 5)
        .onChange(of: selectedItem) {
            self.count = selectedItem?.size ?? nilItemSizeNum
        }
    }
    
    func updatePosition(_ addNum: CGFloat, for axis: Int, selectedItem: Item?) {
        guard let selectedItem = selectedItem else { return }
        if axis == self.X {
            // X軸
            updatePositionX(addNum, type: selectedItem.type)
        } else if axis == self.Y {
            // Y軸
            updatePositionY(addNum, type: selectedItem.type)
        }
    }
    
    func updatePositionX(_ addNum: CGFloat, type: ItemType) {
        guard let selectedStyle = selectedStyle else { return }
        var position = selectedStyle.getPosition(for: type)
        position.x += addNum
        selectedStyle.updatePosition(for: type, to: position)
    }
    
    func updatePositionY(_ addNum: CGFloat, type: ItemType) {
        guard let selectedStyle = selectedStyle else { return }
        var position = selectedStyle.getPosition(for: type)
        position.y += addNum
        selectedStyle.updatePosition(for: type, to: position)
    }
    
}

//#Preview {
//    ItemControlView(selectedStyle: .constant(Style()), selectedItemType: .constant(nil))
//}
