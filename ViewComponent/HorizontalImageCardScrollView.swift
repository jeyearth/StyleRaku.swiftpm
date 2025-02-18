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
                VStack {
                    if selectedItem == nil {
                        Text("select Item")
                    } else {
                        HStack {
                            if let subject = selectedItem?.getSubjectImage() {
                                Image(uiImage: subject)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Text("no subject")
                            }
                            VStack {
                                Text(selectedItem?.descriptionText ?? "no description")
                                Button(action: {
                                    self.showingEditSheet.toggle()
                                    print("Edtt!")
                                }) {
                                    Label("Edit", systemImage: "square.and.pencil")
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
                                
                            }
                        } // HStack
                    }
                    
                }
                Spacer()
            }
            
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
                Spacer()
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
            return .others
        }
    }
}
//
//#Preview {
//    @State var cards = [
//        (image: "down", title: "山の風景", description: "美しい山々と緑豊かな自然の景色"),
//        (image: "down", title: "ビーチリゾート", description: "穏やかな海と白い砂浜のパラダイス"),
//        (image: "down", title: "都市の夜景", description: "輝く街の灯りと近代的な建築"),
//        (image: "down", title: "深い森", description: "神秘的で静かな森の内部"),
//        (image: "down", title: "夕日", description: "色とりどりの空と沈みゆく太陽")
//    ]
//    
//    HorizontalImageCardScrollView(selectedItemViewType: .constant(ItemViewType.all), _items: cards)
//}
