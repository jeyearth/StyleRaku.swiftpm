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
    
    @State var count:Int = 0
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Stepper(value: $count, in: 0...10, step: 1) {
                        Text("Size: \(count)")
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
    }
}

#Preview {
    ItemControlView()
}
