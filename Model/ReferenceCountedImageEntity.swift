//
//  ReferenceCountedImageEntity.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/01/20
//  
//

import SwiftData
import Foundation

@Model
class ReferenceCountedImageEntity {
    var id: UUID = UUID()
    var imagePath: String
    var referenceCount: Int = 0 // 参照カウント

    init(imagePath: String) {
        self.imagePath = imagePath
    }

    func incrementReference() {
        referenceCount += 1
    }

    func decrementReference() -> Bool {
        referenceCount -= 1
        return referenceCount <= 0
    }
}
