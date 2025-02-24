//
//  Extensions.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/21
//  
//

import SwiftUI

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

extension UIImage {
    func resized(Percentage percentage: CGFloat) -> UIImage? {
        let resizeSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        
        return UIGraphicsImageRenderer(size: resizeSize, format: imageRendererFormat).image
        {
            _ in draw(in: CGRect(origin: .zero, size: resizeSize))
        }
    }
}
