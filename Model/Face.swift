//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/18.
//

import SwiftUI
import SwiftData

@Model
class Face {
    var id: UUID
    var createdAt: Date
    var image: String
    var descriptionText: String?
    
    init(name: String) {
        self.id = UUID()
        self.createdAt = Date()
        self.image = name
    }
    
}
