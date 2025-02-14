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
    
    var items: [Item] = []
    var filterdItems: [Item] = []
    
    init() {
        self.spring = true
        self.summer = true
        self.autumn = true
        self.winter = true
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
    }
    
    func setItems(_ items: [Item]) {
        self.items = items
    }
    
    func setFilterdItems() {
        
    }
    
}
