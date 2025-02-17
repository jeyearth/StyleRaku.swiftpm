//
//  StylingDetailViewModel.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/17
//  
//

import SwiftUI

// ① ViewModelを作成
class StylingDetailViewModel: ObservableObject {
    @Published var shuffleData = ShuffleData()
    
    var items: [Item] = [] {
        didSet {
            shuffleData.setItems(items)
        }
    }
    
    func setFilterdItems() {
        shuffleData.setFilterdItems()
    }
    
    func updateShuffleData() {
        shuffleData.setItems(items)
        print("updateShuffleData() called from ViewModel")
    }
    
    func updateShuffleData(_ items: [Item]) {
        shuffleData.setItems(items)
        shuffleData.setFilterdItems()
        print("updateShuffleData(items) called from ViewModel")
    }
    
}
