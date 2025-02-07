//
//  ShuffleControlView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/04
//  
//

import SwiftUI

struct ShuffleControlView: View {
    
    @State private var isTopsLock: Bool = false
    @State private var isBottomsLock: Bool = false
    @State private var isShoesLock: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("ShuffleControlView")
                    Spacer()
                    LockButtonView()
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
    
    @ViewBuilder
    private func LockButtonView() -> some View {
        VStack {
            Toggle(isOn: $isTopsLock, label: {
                HStack {
                    Text("Tops")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: self.isTopsLock ? "lock" : "lock.open")
                }
            })
            Toggle(isOn: $isBottomsLock, label: {
                HStack {
                    Text("Bottoms")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: self.isBottomsLock ? "lock" : "lock.open")
                }
            })
            Toggle(isOn: $isShoesLock, label: {
                HStack {
                    Text("Shoes")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: self.isShoesLock ? "lock" : "lock.open")
                }
            })
        }
    }
    
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
    
    private func doShuffle() {
        print("do Shuffle!")
    }
    
}

#Preview {
    ShuffleControlView()
}
