//
//  Extensions.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/21
//  
//

import Foundation

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
