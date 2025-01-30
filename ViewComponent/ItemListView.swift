//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/19.
//

import SwiftUI

struct ItemListView: View {
    var body: some View {
        ZStack {
            Color(.systemGray6)   // 背景色
            
            VStack {
                Text("aaa")
                Spacer()
                HStack {
                    Spacer()
                    AddItemView()
                }
            }
        }
    }
}

#Preview {
    ItemListView()
}
