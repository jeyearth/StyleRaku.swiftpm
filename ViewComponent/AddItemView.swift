//
//  AddItemView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/23
//
//

import SwiftUI
import PhotosUI

extension Image {
    init(path: String) {
        self.init(uiImage: UIImage(named: path)!)
    }
}

struct AddItemView: View {
    
    @State private var showingSheet: Bool = false
    
    @State var newItem: Item = Item()
    
    var body: some View {
        VStack {
            Button(action: {
                self.showingSheet.toggle()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }
            .frame(width: 60, height: 60)
            .background(Color.accentColor)
            .cornerRadius(30.0)
            .shadow(radius: 7)
            .padding(20)
            .sheet(isPresented: $showingSheet, content: {
                ItemEditView(
                    newItemToggle: true,
                    selectedItem: $newItem
                )
            })
        }
    }
}

#Preview {
    AddItemView()
}
