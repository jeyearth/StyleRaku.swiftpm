//
//  StylingDetailView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/19.
//

import SwiftUI
import SwiftData

class SharedItemType: ObservableObject {
    @Published var type: ItemType? = nil
}

struct StylingDetailView: View {
    @Environment(\.modelContext) private var context
    @Query var items: [Item]
    
    @EnvironmentObject var viewModel: StylingDetailViewModel
    
    @Binding var selectedStyle: Style?
    @State var addItem: Item?
    
    @State var draggingItem: Item? = nil
    @State var selectedItemType: ItemType?
    @State var selectedItem: Item?
    
    var body: some View {
        VStack(spacing : 0) {
            Divider()
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // LEFT
                    ZStack {
                        Color(.systemGray6)
                        VStack {
                            HStack {
                                ShuffleControlView(selectedStyle: $selectedStyle, shuffleData: $viewModel.shuffleData, selectedItem: $selectedItem)
                                ItemControlView(selectedStyle: $selectedStyle, selectedItem: $selectedItem)
                            }
                            .frame(height: geometry.size.height * 0.5)
                            ItemsView(
                                addItem: $addItem,
                                draggingItem: $draggingItem,
                                isShowingSelectedItemView: false,
                                itemContainerHeight: geometry.size.height * 0.325
                            )
                        }
                    }
                    .frame(width: geometry.size.width * 0.65)
                    
                    // RIGHT
                    StylePreviewView(
                        selectedStyle: $selectedStyle,
                        addItem: $addItem,
                        draggingItem: $draggingItem,
                        selectedItemType: $selectedItemType,
                        selectedItem: $selectedItem
                    )
                        .frame(width: geometry.size.width * 0.35)
                }
            }
            .navigationTitle(selectedStyle?.name ?? "Styling Details")
            .navigationBarTitleDisplayMode(.inline)
        } // VStack
        .ignoresSafeArea(.keyboard, edges: .all)
        .onChange(of: items) {
            print("items change!")
            self.updateShuffleData()
        }
        .onAppear {
            self.updateShuffleData()
        }
    }
    
    func updateShuffleData() {
        viewModel.items = items
        viewModel.setFilterdItems()
    }
    
}

#Preview {
    StylingDetailView(selectedStyle: .constant(Style()))
}
