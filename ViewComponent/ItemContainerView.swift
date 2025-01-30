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
    
    init(item: Item, isSelected: Bool) {
        self.item = item
        self.isSelected = isSelected
        self.showingEditSheet = false
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                if let subjectImage = item.getSubjectImage() {
                    Image(uiImage: subjectImage)
                        .resizable()
                        .scaledToFit()
//                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 150)
                        .clipped()
                } else {
                    Text("no subject image")
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name.isEmpty ? "no name" : item.name)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 8)
                HStack {
                    Spacer()
                    Menu {
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
                    }  label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.primary)
                            .padding()
                    }
                }
            }
            .padding()
            .frame(width: 200, height: 260)
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
    }
    
    private func deleteItem() {
        context.delete(item)
        do {
            try context.save() // 削除を保存
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    ItemContainerView(item: Item(name: "Hybrid Down", descriptionText: "UNIQLO UNIQLO", type: ItemType.tops), isSelected: true)
}
