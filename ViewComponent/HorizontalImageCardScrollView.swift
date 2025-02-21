//
//  HorizontalImageCardScrollView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/01/24
//  
//

import SwiftUI
import SwiftData

struct HorizontalImageCardScrollView: View {
    @Binding var selectedItemViewType: ItemViewType
    @Binding var addItem: Item?
    @Binding var draggingItem: Item?
    
    @Query var items: [Item]
    @State var selectedItem: Item?
    
    @State var showingEditSheet: Bool = false
    @State private var ascendingOrder: Bool = true
    
    let isShowingSelectedItemView: Bool
    let itemContainerHeight: CGFloat
    
    var body: some View {
        VStack {
            if isShowingSelectedItemView {
                Spacer()
                VStack {
                    if selectedItem == nil {
                        Text("Select an Item")
                    } else {
                        HStack {
                            if let subject = selectedItem?.getSubjectImage() {
                                Image(uiImage: subject)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: itemContainerHeight)
                            } else {
                                Text("no subject")
                            }
                            VStack {
                                Spacer()
                                Text(selectedItem?.descriptionText ?? "no description")
                                Spacer()
                                Button(action: {
                                    self.showingEditSheet.toggle()
                                    print("Edtt!")
                                }) {
                                    Label("Edit", systemImage: "square.and.pencil")
                                        .font(.title2)
                                }
                                .sheet(isPresented: $showingEditSheet) {
                                    if let selectedItem = selectedItem {
                                        ItemEditView(
                                            newItemToggle: false,
                                            selectedItem: .constant(selectedItem)
                                        )
                                    } else {
                                        Text("No item selected")
                                    }
                                } // sheet
                            } // VStacl
                            .padding(.leading, 80)
                        } // HStack
                    }
                    
                }
            }
            Spacer()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.ascendingOrder.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                            .padding(.trailing , 20)
                            .padding(.top, 10)
                    }
                }
            }
            
            let filteredItems = getFilteredItems()
                
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 15) {
                    ForEach(self.ascendingOrder ? filteredItems.sorted(by: { $0.createdAt < $1.createdAt }) : filteredItems.sorted(by: { $0.createdAt > $1.createdAt }),
                            id: \.self) { item in
                        let isSelected: Bool = (item.id == selectedItem?.id ? true : false)
                        ItemContainerView(
                            item: item,
                            isSelected: isSelected,
                            itemContainerHeight: itemContainerHeight
                        )
                        .onTapGesture(perform: {
                            selectedItem = item
                            addItem = item
                        })
                        .onDrag {
                            draggingItem = item
                            return NSItemProvider(object: item.id.uuidString as NSString)
                        }
                    }
                } // HStack
                .padding()
            } // ScrollView
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .onChange(of: selectedItemViewType, {
            // ItemViewTypeを変更したら選択されたItemをnilに変更
            selectedItem = nil
        })
        
    }
    
    private func getFilteredItems() -> [Item] {
        if selectedItemViewType == .all {
            return items
        } else {
            let type = getItemType(selectedItemViewType: selectedItemViewType)
            return items.filter { $0.type == type }
        }
    }
    
    func getItemType(selectedItemViewType: ItemViewType) -> ItemType {
        switch selectedItemViewType {
        case .tops:
            return .tops
        case .bottoms:
            return .bottoms
        case .shoes:
            return .shoes
        default:
            return .tops
        }
    }
}
