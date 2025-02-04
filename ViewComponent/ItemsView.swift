//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/23
//
//

import SwiftUI
import SwiftData

struct ItemsView: View {
    
    @Environment(\.modelContext) private var context
    @Query var items: [Item]
    
    @State private var selectedItemViewType = ItemViewType.all
    
    @Binding var addItem: Item?
    
    let isShowingSelectedItemView: Bool
    
    var body: some View {
        ZStack {
            Color(.systemGray6)   // 背景色
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                Picker("ItemType", selection: $selectedItemViewType) {
                    ForEach(ItemViewType.allCases) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                Spacer()
                VStack {
                    HorizontalImageCardScrollView(selectedItemViewType: $selectedItemViewType, addItem: $addItem, isShowingSelectedItemView: isShowingSelectedItemView)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddItemView()
                }
            }
        }
        
    }
}
//
//#Preview {
//    ItemsView(, addItem: <#Binding<Item?>#>)
//}
