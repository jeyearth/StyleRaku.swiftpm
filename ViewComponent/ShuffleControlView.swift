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
    
    @State private var isSelectedSpring: Bool = true
    @State private var isSelectedSummer: Bool = true
    @State private var isSelectedAutumn: Bool = true
    @State private var isSelectedWinter: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    LockButtonView()
                        .padding([.leading, .trailing], 30)
                    Divider()
                        .padding([.leading, .trailing], 30)
                    SeasonsSettingView()
                        .padding([.leading, .trailing], 30)
                    
//                    HStack {
//                        LockButtonView()
//                        SeasonsSettingView()
//                    }
                    
//                    Spacer()
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
    
    //
    // MARK: - LockButtonView
    //
    
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
    
    //
    // MARK: - SeasonsSettingView
    //
    @ViewBuilder
    private func SeasonsSettingView() -> some View {
        VStack {
//            Text("Season")
//                .font(.title)
//                .fontWeight(.bold)
            VStack {
                Button {
                    self.isSelectedSpring.toggle()
                } label: {
                    if self.isSelectedSpring {Image(systemName: "checkmark")}
                    Spacer()
                    Text("Spring")
                }
                .foregroundColor(Color.primary)
                Button {
                    self.isSelectedSummer.toggle()
                } label: {
                    if self.isSelectedSummer {Image(systemName: "checkmark")}
                    Spacer()
                    Text("Summer")
                }
                .foregroundColor(Color.primary)
                Button {
                    self.isSelectedAutumn.toggle()
                } label: {
                    if self.isSelectedAutumn {Image(systemName: "checkmark")}
                    Spacer()
                    Text("Autumn")
                }
                .foregroundColor(Color.primary)
                Button {
                    self.isSelectedWinter.toggle()
                } label: {
                    if self.isSelectedWinter {Image(systemName: "checkmark")}
                    Spacer()
                    Text("Winter")
                }
                .foregroundColor(Color.primary)
            }
        }
    }
    
    //
    // MARK: - ShuffleButton
    //
    
    @ViewBuilder
    private func ShuffleButton() -> some View {
        Button {
            self.doShuffle()
        } label: {
            Image(systemName: "shuffle")
                .padding([.leading, .trailing], 10)
        }
        .padding(10)
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
