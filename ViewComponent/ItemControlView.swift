//
//  ItemControlView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/04
//  
//

import SwiftUI

struct ItemControlView: View {
    let moveButtonSize: CGFloat = 40
    
    @Binding var selectedStyle: Style?
    @Binding var selectedItem: Item?
    @State var count: Float
    
    init(selectedStyle: Binding<Style?>, selectedItem: Binding<Item?>) {
        self._selectedStyle = selectedStyle
        self._selectedItem = selectedItem
        self._count = State(initialValue: selectedItem.wrappedValue?.size ?? 100)
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Stepper(value: $count, in: 50...400, step: 1) {
                        Text("Size: \(Int(count))")
                    }
                    .onChange(of: count) { _, newValue in
                        selectedItem?.size = newValue
                    }
                    
                    HStack {
                        Button  {
                            print("do align.horizontal.center")
                        } label: {
                            Image(systemName: "square.3.layers.3d")
                                .font(.title2)
                                .foregroundColor(Color.secondary)
                        }
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
                        Button(action: { print("北ボタンが押されました") }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: moveButtonSize, height: moveButtonSize)
                        }
                        
                        HStack {
                            Button(action: { print("西ボタンが押されました") }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width: moveButtonSize, height: moveButtonSize)
                            }
                            
                            Spacer().frame(width: moveButtonSize + 10) // 中央の空間
                            
                            Button(action: { print("東ボタンが押されました") }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width: moveButtonSize, height: moveButtonSize)
                            }
                        }
                        
                        Button(action: { print("南ボタンが押されました") }) {
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: moveButtonSize, height: moveButtonSize)
                        }
                    }
                }
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
            self.count = selectedItem?.size ?? 150
        }
    }
}

//#Preview {
//    ItemControlView(selectedStyle: .constant(Style()), selectedItemType: .constant(nil))
//}
