//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/18.
//

import SwiftUI
import SwiftData

// Itemリスト表示用のSegmented Control
enum ItemViewType: String, CaseIterable, Identifiable {
    case all = "All"
    case face = "Face"
    case tops = "Tops"
    case bottoms = "Bottoms"
    case shoes = "Shoes"
    case others = "Others"
    
    var id: String { rawValue }
    
    func getSFSymbolName() -> String {
        switch self {
        case.all:
            return "cabinet"
        case .face:
            return "face.smiling"
        case .tops:
            return "tshirt"
        case .bottoms:
            return "person"
        case.shoes:
            return "shoe"
        case .others:
            return "handbag"
        }
    }
}

@Model
final class ItemPosition {
    // MARK: - Properties
    var item: Item
    var positionString: String  // "x,y" 形式で保存
    
    // MARK: - Computed Property for CGPoint conversion
    var position: CGPoint {
        get { CGPoint(fromString: positionString) }
        set { positionString = newValue.toString }
    }
    
    // MARK: - Initializers
    init(item: Item, position: CGPoint) {
        self.item = item
        self.positionString = position.toString
    }
    
    // 文字列で直接位置を指定するイニシャライザ
    init(item: Item, positionString: String) {
        self.item = item
        self.positionString = positionString
    }
    
    // MARK: - Methods
    func updatePosition(to newPosition: CGPoint) {
        self.positionString = newPosition.toString
    }
    
    // 文字列で直接位置を更新するメソッド
    func updatePositionString(to newPositionString: String) {
        self.positionString = newPositionString
    }
}

@Model
final class Style {
    // MARK: - Properties
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var name: String
    var descriptionText: String?
    
    // MARK: - Relationships
    @Relationship(deleteRule: .nullify) var face: Face?
    @Relationship(deleteRule: .nullify) var tops: Item?
    @Relationship(deleteRule: .nullify) var bottoms: Item?
    @Relationship(deleteRule: .nullify) var shoes: Item?
    @Relationship(deleteRule: .cascade) var others: [ItemPosition] = []
    
    // MARK: - Position Properties (Stored as Strings)
    var facePositionString: String = "50,50"
    var topsPositionString: String = "100,-50"
    var bottomsPositionString: String = "100,150"
    var shoesPositionString: String = "100,300"
    
    // MARK: - Computed Properties for CGPoint conversion
    var facePosition: CGPoint {
        get { CGPoint(fromString: facePositionString) }
        set { facePositionString = newValue.toString }
    }
    
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
    
    // MARK: - Initializers
    init() {
        self.id = UUID()
        self.createdAt = Date()
        self.name = ""
    }
    
    init(name: String, face: Face? = nil, descriptionText: String? = nil) {
        self.id = UUID()
        self.createdAt = Date()
        self.name = name
        self.face = face
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
        default :
            return nil
        }
    }
    
    // MARK: - Methods
    func updatePosition(for category: ItemType, to position: CGPoint) {
        switch category {
//        case .face:
//            self.facePosition = position
        case .tops:
            self.topsPosition = position
        case .bottoms:
            self.bottomsPosition = position
        case .shoes:
            self.shoesPosition = position
        case .others:
            break // `others` は別で管理
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
        case .others:
            print(".others!")
            return
        }
    }
    
    func addOtherItem(_ item: Item, position: CGPoint) {
        let itemPosition = ItemPosition(item: item, position: position)
        others.append(itemPosition)
    }
    
    func removeOtherItem(_ item: Item) {
        others.removeAll { $0.item.id == item.id }
    }
    
    // Get all items in the style
    var allItems: [Item] {
        var items: [Item] = []
        if let tops = tops { items.append(tops) }
        if let bottoms = bottoms { items.append(bottoms) }
        if let shoes = shoes { items.append(shoes) }
        items.append(contentsOf: others.map { $0.item })
        return items
    }
    
    // Check if style is complete (has all required components)
    var isComplete: Bool {
        return face != nil && tops != nil && bottoms != nil && shoes != nil
    }
    
    // MARK: - Face Management
    func updateFace(_ newFace: Face) {
        self.face = newFace
    }
    
    // Get the face image name if available
    var faceImageName: String? {
        return face?.image
    }
    
    // Get style creation date formatted
    var formattedCreationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

// MARK: - CGPoint Extensions
extension CGPoint {
    var toString: String {
        return "\(x),\(y)"
    }
    
    init(fromString string: String) {
        let components = string.components(separatedBy: ",")
        let x = Double(components.first ?? "0") ?? 0
        let y = Double(components.last ?? "0") ?? 0
        self.init(x: x, y: y)
    }
}
