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
    @Binding var selectedItem: Item?
    
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
            .padding(6)
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
            shuffleData.toggleSeason(season)
        } label: {
            HStack {
                if shuffleData.getSeason(season) {
                    Image(systemName: "checkmark")
                }
                Spacer()
                Text(season.rawValue)
            }
            .padding(.vertical, 1)
        }
        .foregroundColor(Color.primary)
    }
    
    //
    // MARK: - ShuffleButton
    //
    
    @ViewBuilder
    private func ShuffleButton() -> some View {
        Button {
            self.executeShuffle()
        } label: {
            Image(systemName: "shuffle")
                .padding([.leading, .trailing], 10)
        }
        .padding(8)
        .foregroundColor(Color.white)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .font(.title3)
    }
    
    private func executeShuffle() {
        print("do shuffle")
        shuffleData.doShuffle()
        if let selectedTops = shuffleData.selectedTops {
            selectedStyle?.setItem(item: selectedTops)
        }
        if let selectedBottoms = shuffleData.selectedBottoms {
            selectedStyle?.setItem(item: selectedBottoms)
        }
        if let selectedShoes = shuffleData.selectedShoes {
            selectedStyle?.setItem(item: selectedShoes)
        }
        
        guard let type = selectedItem?.type else { return }
        guard let item = selectedStyle?.getItem(type) else { return }
        
        selectedItem = item
    }
    
}

#Preview {
    ShuffleControlView(selectedStyle: .constant(nil), shuffleData: .constant(ShuffleData()), selectedItem: .constant(nil))
}
