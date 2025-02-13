//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/19.
//

import SwiftUI

// 共有するモデル
class SharedItemType: ObservableObject {
    @Published var type: ItemType? = nil
}

struct StylingDetailView: View {
    
    @Binding var selectedStyle: Style?
    @State var addItem: Item?
    
//    @State var draggingItemType = SharedItemType()
    @State var draggingItem: Item? = nil
    
    var body: some View {
        VStack(spacing : 0) {
            Divider()
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // 左側: ItemリストView（6割幅）
                    ZStack {
                        Color(.systemGray6)   // 背景色
                        VStack {
                            HStack {
                                ShuffleControlView()
                                ItemControlView()
                            }
                            .frame(height: geometry.size.height * 0.5)
                            ItemsView(
                                addItem: $addItem,
                                draggingItem: $draggingItem,
                                isShowingSelectedItemView: false,
                                itemContainerHeight: geometry.size.height * 0.33
                            )
                        }
                    }
                    .frame(width: geometry.size.width * 0.65)
                    
                    // 右側: プレビューView（4割幅）
                    StylePreviewView(selectedStyle: $selectedStyle, addItem: $addItem, draggingItem: $draggingItem)
                        .frame(width: geometry.size.width * 0.35)
                }
            }
            .navigationTitle(selectedStyle?.name ?? "Styling Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    StylingDetailView(selectedStyle: .constant(Style()))
}
