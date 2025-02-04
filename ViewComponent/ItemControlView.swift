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
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("ShuffleControlView")
                    Spacer()
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
                .frame(width: 160)
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
