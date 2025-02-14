//
//  StyleEditView.swift
//  StyleRaku
//  
//  Created by Jey Hirano on 2025/01/28
//  
//

import SwiftUI

struct StyleEditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let newStyleToggle: Bool
    
    @Binding var selectedStyle: Style
    
    @State private var inputName: String = ""
    @State private var inputDescriptionText: String = ""
    
    init(newStyleToggle: Bool, selectedStyle: Binding<Style>) {
        self.newStyleToggle = newStyleToggle
        self._selectedStyle = selectedStyle
        
        if !newStyleToggle {
            let wrappedStyle = selectedStyle.wrappedValue
            
            self._inputName = State(initialValue: wrappedStyle.name)
            self._inputDescriptionText = State(initialValue: wrappedStyle.descriptionText ?? "")
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack {
                    Form {
                        TextField("Name", text: $inputName)
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $inputDescriptionText)
                                .frame(height: 150)
                            
                            if inputDescriptionText.isEmpty {
                                Text("Description")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                    } // Form
                } // VStack
            }
            .navigationTitle("Style Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(newStyleToggle ? "Add" : "Save") {
                        self.saveChanges()
                        dismiss()
                    }
                    .disabled(inputName.isEmpty)
                }
            } // toolbar
        } // NavigationStack
    } // body
    
    private func saveChanges() {
        selectedStyle.name = inputName
        selectedStyle.descriptionText = inputDescriptionText
        
        if newStyleToggle {
            addNewStyle()
        } else {
            updateExistingStyle()
        }
        
        resetState()
    }
    
    private func addNewStyle() {
        let newStyle = selectedStyle
        context.insert(newStyle)
    }
    
    private func updateExistingStyle() {
        try? context.save()
    }
    
    private func resetState() {
        inputName = ""
        inputDescriptionText = ""
        selectedStyle = Style()
    }
}

//#Preview {
//    StyleEditView()
//}
