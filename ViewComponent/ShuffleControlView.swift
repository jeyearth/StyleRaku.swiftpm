//
//  ShuffleControlView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/02/04
//  
//

import SwiftUI

struct ShuffleControlView: View {
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("ShuffleControlView")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground)) // 背景色を白に設定
            )
        }
        .padding(.top, 10)
        .padding([.leading, .trailing], 10)
        .padding(.bottom, 5)
    }
}

#Preview {
    ShuffleControlView()
}
