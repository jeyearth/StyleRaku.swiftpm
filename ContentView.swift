import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var styles: [Style]
    
    @State var selectedStyle: Style? // サイドバーで選択された項目
    @State private var showingNewStyleSheet: Bool = false
    @State private var showingExistingStyleSheet: Bool = false
    
    @State var newStyle: Style = Style()
    
    enum Selection: Hashable {
        case items
        case style(Style)
    }
    
    @State private var selection: Selection? = .items
    @State private var styleToEdit: Style? = nil
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section {
                    NavigationLink(value: Selection.items) {
                        Label("Items", systemImage: "cabinet")
                    }
                }
                Section(header: Text("Styling")) {
                    ForEach(styles.sorted(by: { $0.createdAt < $1.createdAt }), id: \.id) { style in
                        NavigationLink(value: Selection.style(style)) {
                            Label(style.name, systemImage: "person")
                        }
                        .contextMenu {
                            Button(action: {
                                self.styleToEdit = style  // 編集対象のStyleを設定
                                self.showingExistingStyleSheet.toggle()
                            }) {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                            Button(role: .destructive) {
                                self.deleteStyle(style)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    Button(action: {
                        self.showingNewStyleSheet.toggle()
                    }) {
                        Label("Add Styling", systemImage: "plus")
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("StyleRaku")
        } detail: {
            switch selection {
            case .items:
                ItemsView(addItem: .constant(Item()),
                         draggingItem: .constant(nil),
                         isShowingSelectedItemView: true,
                         itemContainerHeight: 260)
                .navigationBarTitle("Items")
                .toolbarBackground(Color(.systemGray6), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            case .style(let style):
                StylingDetailView(selectedStyle: .constant(style))
            case nil:
                Text("Select a styling")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingNewStyleSheet, content: {
            StyleEditView(newStyleToggle: true, selectedStyle: $newStyle)
        })
        .sheet(isPresented: $showingExistingStyleSheet, content: {
            if let style = styleToEdit {
                StyleEditView(newStyleToggle: false, selectedStyle: .constant(style))
            } else {
                Text("Failed to retrieve Style.")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        })
        
    }
    
    private func deleteStyle(_ style: Style) {
        context.delete(style)
        if case .style(let selectedStyle) = selection, selectedStyle.id == style.id {
            selection = nil
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
}
