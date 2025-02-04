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
    
    @Query var items: [Item]
    @State var selectedItem: Item?
    
    @State var showingEditSheet: Bool = false
    
    let isShowingSelectedItemView: Bool
    
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
                                Text(selectedItem?.name ?? "no name")
                                    .font(.title)
                                    .fontWeight(.bold)
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
                
            }
            Spacer()
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 15) {
                    ForEach(selectedItemViewType == .all ? items : items.filter
                            {
                        $0.type == self.getItemType(selectedItemViewType: self.selectedItemViewType)
                    },
                            id: \.self) { item in
                        
                        let isSelected: Bool = (item.id == selectedItem?.id ? true : false)
                        ItemContainerView(
                            item: item,
                            isSelected: isSelected
                        )
                        .onTapGesture(perform: {
                            selectedItem = item
                            addItem = item
                        })
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
