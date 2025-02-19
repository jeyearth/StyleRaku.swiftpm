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
    @Binding var draggingItem: Item?
    
    let isShowingSelectedItemView: Bool
    let itemContainerHeight: CGFloat
    
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
                .padding(.vertical, isShowingSelectedItemView ? 10 : 2)
                .padding(.horizontal, 10)
                Spacer()
                VStack {
                    HorizontalImageCardScrollView(
                        selectedItemViewType: $selectedItemViewType,
                        addItem: $addItem,
                        draggingItem: $draggingItem,
                        isShowingSelectedItemView: isShowingSelectedItemView,
                        itemContainerHeight: itemContainerHeight
                    )
                }
//                .frame(height: itemContainerHeight * 1.3)
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
