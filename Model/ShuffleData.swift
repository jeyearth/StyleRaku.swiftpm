//
//  ShuffleData.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/14
//  
//

import Foundation

final class ShuffleData {
    
    var topsLock: Bool = false
    var bottomsLock: Bool = false
    var shoesLock: Bool = false
    
    var spring: Bool
    var summer: Bool
    var autumn: Bool
    var winter: Bool
    
    var selectedTops: Item? = nil
    var selectedBottoms: Item? = nil
    var selectedShoes: Item? = nil
    
    var items: [Item] = []
    var filterdTops: [Item] = []
    var filterdBottoms: [Item] = []
    var filterdShoes: [Item] = []
    
    init() {
        self.spring = true
        self.summer = true
        self.autumn = true
        self.winter = true
    }
    
    func getSeason(_ season: Season) -> Bool {
        switch season {
        case .spring:
            return self.spring
        case .summer:
            return self.summer
        case .autumn:
            return self.autumn
        case .winter:
            return self.winter
        }
    }
    
    func toggleSeason(_ season: Season) {
        switch season {
        case .spring:
            self.spring.toggle()
        case .summer:
            self.summer.toggle()
        case .autumn:
            self.autumn.toggle()
        case .winter:
            self.winter.toggle()
        }
        self.setFilterdItems()
    }
    
    func updataData(_ items: [Item]) {
        self.setItems(items)
        self.setFilterdItems()
    }
    
    func setItems(_ items: [Item]) {
        self.items = items
    }
    
    private func resetData() {
        self.filterdTops = []
        self.filterdBottoms = []
        self.filterdShoes = []
    }
    
    func matchSeason(_ item: Item) -> Bool {
        if item.spring && self.spring { return true }
        if item.summer && self.summer { return true }
        if item.autumn && self.autumn { return true }
        if item.winter && self.winter { return true }
        return false
    }
    
    func setFilterdItems() {
        self.resetData()
        
        for item in self.items {
            if self.matchSeason(item) {
                switch item.type {
                case .tops:
                    self.filterdTops.append(item)
                case .bottoms:
                    self.filterdBottoms.append(item)
                case .shoes:
                    self.filterdShoes.append(item)
                }
            }
        }
    }
    
    func doShuffle() {
        if !topsLock {
            guard let selectedTops = getRandomItem(.tops) else { return }
            self.selectedTops = selectedTops
        }
        if !bottomsLock {
            guard let selectedBottoms = getRandomItem(.bottoms) else { return }
            self.selectedBottoms = selectedBottoms
        }
        if !shoesLock {
            guard let selectedShoes = getRandomItem(.shoes) else { return }
            self.selectedShoes = selectedShoes
        }
    }
    
    func getRandomItem(_ type: ItemType) -> Item? {
        
        var targetItems: [Item] = []
        var excludingItem: Item?
        
        switch type {
        case .tops:
            targetItems = filterdTops
            excludingItem = selectedTops
        case .bottoms:
            targetItems = filterdBottoms
            excludingItem = selectedBottoms
        case .shoes:
            targetItems = filterdShoes
            excludingItem = selectedShoes
        }
        
        let availableItems = targetItems.filter { $0.id != excludingItem?.id }
        
        // 空でなければランダムで返す
        return availableItems.randomElement()
    }
    
}
