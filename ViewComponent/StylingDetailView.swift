//
//  SwiftUIView.swift
//  StyleRaku
//
//  Created by Jey Hirano on 2025/01/19.
//

import SwiftUI

struct StylingDetailView: View {
    
    @Binding var selectedStyle: Style?
    @State var addItem: Item?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // 左側: ItemリストView（6割幅）
                ItemsView(addItem: $addItem)
                    .frame(width: geometry.size.width * 0.65)

                // 右側: プレビューView（4割幅）
                StylePreviewView(selectedStyle: $selectedStyle, addItem: $addItem)
                    .frame(width: geometry.size.width * 0.35)
            }
        }
        .navigationTitle(selectedStyle?.name ?? "Styling Details")
        .navigationBarTitleDisplayMode(.inline)
        .border(Color.gray.opacity(0.2), width: 0.5)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    StylingDetailView(selectedStyle: .constant(Style()))
}
