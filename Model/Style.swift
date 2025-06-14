//
//  Style.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/18.
//

import SwiftUI
import SwiftData

let defaultItemPosition = [
    "0,-80", // TOPS
    "0,-100", // BOTTOMS
    "0,270" // SHOES
]

@Model
final class Style {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var name: String
    var descriptionText: String?
    
    @Relationship(deleteRule: .nullify) var tops: Item?
    @Relationship(deleteRule: .nullify) var bottoms: Item?
    @Relationship(deleteRule: .nullify) var shoes: Item?
    
    var topsPositionString: String = defaultItemPosition[0]
    var bottomsPositionString: String = defaultItemPosition[1]
    var shoesPositionString: String = defaultItemPosition[2]
    
    var topsPosition: CGPoint {
        get { CGPoint(fromString: topsPositionString) }
        set { topsPositionString = newValue.toString }
    }
    
    var bottomsPosition: CGPoint {
        get { CGPoint(fromString: bottomsPositionString) }
        set { bottomsPositionString = newValue.toString }
    }
    
    var shoesPosition: CGPoint {
        get { CGPoint(fromString: shoesPositionString) }
        set { shoesPositionString = newValue.toString }
    }
    
    init() {
        self.id = UUID()
        self.createdAt = Date()
        self.name = ""
    }
    
    init(name: String, descriptionText: String? = nil) {
        self.id = UUID()
        self.createdAt = Date()
        self.name = name
        self.descriptionText = descriptionText
    }
    
    func getItem(_ type: ItemType) -> Item? {
        switch type {
        case .tops:
            return self.tops
        case .bottoms:
            return self.bottoms
        case .shoes:
            return self.shoes
        }
    }
    
    func updatePosition(for category: ItemType, to position: CGPoint) {
        switch category {
        case .tops:
            self.topsPosition = position
        case .bottoms:
            self.bottomsPosition = position
        case .shoes:
            self.shoesPosition = position
        }
    }
    
    func getPosition(for category: ItemType) -> CGPoint {
        switch category {
        case .tops:
            return self.topsPosition
        case .bottoms:
            return self.bottomsPosition
        case .shoes:
            return self.shoesPosition
        }
    }
    
    func setItem(item: Item) {
        switch item.type {
        case.tops:
            self.tops = item
        case .bottoms:
            self.bottoms = item
        case .shoes:
            self.shoes = item
        }
    }
    
    var formattedCreationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}
