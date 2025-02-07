//
//  ShuffleControlView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/04
//  
//

import SwiftUI

struct ShuffleControlView: View {
    
    @ViewBuilder
    private func ShuffleButton() -> some View {
        Button {
            self.doShuffle()
        } label: {
            Image(systemName: "shuffle")
                .padding([.leading, .trailing], 10)
        }
        .padding(16)
        .foregroundColor(Color.white)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .font(.title3)
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("ShuffleControlView")
                    Spacer()
                    ShuffleButton()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground)) // 背景色を白に設定
            )
        }
        .padding(.top, 10)
        .padding([.leading, .trailing], 10)
        .padding(.bottom, 5)
    }
    
    private func doShuffle() {
        print("do Shuffle!")
    }
    
}

#Preview {
    ShuffleControlView()
}
