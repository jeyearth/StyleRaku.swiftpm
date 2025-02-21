//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/23
//
//

import SwiftUI
import SwiftData

struct ItemContainerView: View {
    
    @Environment(\.modelContext) private var context
    
    @State var item: Item
    let isSelected: Bool
    @State var showingEditSheet: Bool
    let itemContainerHeight: CGFloat
    
    init(item: Item, isSelected: Bool, itemContainerHeight: CGFloat) {
        self.item = item
        self.isSelected = isSelected
        self.showingEditSheet = false
        self.itemContainerHeight = itemContainerHeight
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                if let subjectImage = item.getSubjectImage() {
                    Image(uiImage: subjectImage)
                        .resizable()
                        .scaledToFit()
//                        .aspectRatio(contentMode: .fill)
                        .frame(width: itemContainerHeight * 0.8 - 40, height: itemContainerHeight - 40)
                } else {
                    Text("No Subject Image")
                }
                
            }
            .padding()
            .frame(width: itemContainerHeight * 0.8, height: itemContainerHeight)
            .background(Color(UIColor.systemBackground))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke((isSelected ? Color.accentColor : Color.clear), lineWidth: 3)
            )
            .cornerRadius(10)
        }
        .shadow(radius: 4)
        .sheet(isPresented: $showingEditSheet, content: {
            ItemEditView(
                newItemToggle: false,
                selectedItem: $item
            )
        })
        .contextMenu {
            Button(action: {
                self.showingEditSheet.toggle()
            }) {
                Label("Edit", systemImage: "square.and.pencil")
            }
            Button(role: .destructive) {
                self.deleteItem()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func deleteItem() {
        context.delete(item)
//        do {
//            try context.save() // 削除を保存
//        } catch {
//            print("Error saving context: \(error.localizedDescription)")
//        }
    }
    
}

#Preview {
    ItemContainerView(item: Item(descriptionText: "UNIQLO UNIQLO", type: ItemType.tops), isSelected: true, itemContainerHeight: 260)
}
