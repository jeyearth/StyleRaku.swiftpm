//
//  ShuffleControlView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/04
//  
//

import SwiftUI

struct ShuffleControlView: View {
    
    @Binding var selectedStyle: Style?
    @Binding var shuffleData: ShuffleData
    
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
            lockToggleButton(type: .tops, isLocked: $isTopsLock)
            lockToggleButton(type: .bottoms, isLocked: $isBottomsLock)
            lockToggleButton(type: .shoes, isLocked: $isShoesLock)
        }
    }
    
    @ViewBuilder
    private func lockToggleButton(type: ItemType, isLocked: Binding<Bool>) -> some View {
        Toggle(isOn: isLocked) {
            HStack {
                Text(type.rawValue)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: isLocked.wrappedValue ? "lock" : "lock.open")
            }
        }
        .onChange(of: isLocked.wrappedValue) { _, newValue in
            print("\(type.rawValue) lock state changed to \(newValue)")
            switch type {
            case .tops:
                shuffleData.topsLock = newValue
            case .bottoms:
                shuffleData.bottomsLock = newValue
            case .shoes:
                shuffleData.shoesLock = newValue
            default:
                return
            }
        }
    }
    
    //
    // MARK: - SeasonsSettingView
    //
    @ViewBuilder
    private func SeasonsSettingView() -> some View {
        VStack {
            VStack {
                seasonButton(season: .spring, isOn: $isSelectedSpring)
                seasonButton(season: .summer, isOn: $isSelectedSummer)
                seasonButton(season: .autumn, isOn: $isSelectedAutumn)
                seasonButton(season: .winter, isOn: $isSelectedWinter)
            }
        }
    }
    
    @ViewBuilder
    private func seasonButton(season: Season, isOn: Binding<Bool>) -> some View {
        Button {
            isOn.wrappedValue.toggle()
            let seasonSelected = isOn.wrappedValue
            switch season {
            case .spring:
                shuffleData.spring = seasonSelected
            case .summer:
                shuffleData.summer = seasonSelected
            case .autumn:
                shuffleData.autumn = seasonSelected
            case .winter:
                shuffleData.winter = seasonSelected
            }
        } label: {
            HStack {
                if isOn.wrappedValue {
                    Image(systemName: "checkmark")
                }
                Spacer()
                Text(season.rawValue)
            }
            .padding(.vertical, 2)
        }
        .foregroundColor(Color.primary)
    }
    
    //
    // MARK: - ShuffleButton
    //
    
    @ViewBuilder
    private func ShuffleButton() -> some View {
        Button {
            shuffleData.doShuffle()
            print("do shuffle")
            if let selectedTops = shuffleData.selectedTops {
                selectedStyle?.setItem(item: selectedTops)
            }
            if let selectedBottoms = shuffleData.selectedBottoms {
                selectedStyle?.setItem(item: selectedBottoms)
            }
            if let selectedShoes = shuffleData.selectedShoes {
                selectedStyle?.setItem(item: selectedShoes)
            }
            
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
    
}

#Preview {
    ShuffleControlView(selectedStyle: .constant(nil), shuffleData: .constant(ShuffleData()))
}
