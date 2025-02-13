import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var styles: [Style]
    
    @State var selectedStyle: Style? // サイドバーで選択された項目
//    private let stylings = ["Coordination 1", "Coordination 2", "Coordination 3"] // サンプルデータ
    @State private var showingNewStyleSheet: Bool = false
    @State private var showingExistingStyleSheet: Bool = false
    
    @State var newStyle: Style = Style()
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedStyle) {
                Section {
                    NavigationLink {
                        VStack {
                            Text("Home View")
                        }
                    } label: {
                        Label("Home", systemImage: "house")
                    }
                    NavigationLink {
                        VStack {
                            Text("Compare View")
                        }
                    } label: {
                        Label("Copare", systemImage: "square.and.line.vertical.and.square")
                    }
                    NavigationLink {
                        ItemsView(addItem: .constant(Item()), draggingItem: .constant(nil), isShowingSelectedItemView: true, itemContainerHeight: 260)
                    } label: {
                        Label("Items", systemImage: "cabinet")
                    }
                    
                }
                Section(header: Text("Styling")) {
                    ForEach(styles, id: \.id) { style in
                        NavigationLink(value: style) {
                            Label(style.name, systemImage: "person")
                        }
                        .contextMenu {
                            Button(action: {
                                self.showingExistingStyleSheet.toggle()
                            }) {
                                Label("Edit", systemImage: "square.and.pencil")
                            }
                            Button(role: .destructive) {
                                self.deleteStyle()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    Button(action: {
                        // 新しいスタイリングを追加する処理
                        print("Add Styling tapped")
                        self.showingNewStyleSheet.toggle()
                    }) {
                        Label("Add Styling", systemImage: "plus")
                    }
                }
            }
            .listStyle(SidebarListStyle()) // サイドバー形式
            .navigationTitle("StyleRaku")
        } detail: {
            if self.selectedStyle != nil {
                StylingDetailView(selectedStyle: self.$selectedStyle)
            } else {
                Text("Select a styling")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            let sampleStyle: Style = Style(name: "Coordination 1")
            if styles.contains(sampleStyle) {
                context.insert(sampleStyle)
            }
        }
        .sheet(isPresented: $showingNewStyleSheet, content: {
            StyleEditView(newStyleToggle: true, selectedStyle: $newStyle)
        })
        .sheet(isPresented: $showingExistingStyleSheet, content: {
            if let selectedStyle = self.selectedStyle {
                StyleEditView(newStyleToggle: false, selectedStyle: .constant(selectedStyle))
            } else {
                Text("Select a styling")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        })
        
    }
    
    private func deleteStyle() {
        guard let selectedStyle = self.selectedStyle else { return }
        context.delete(selectedStyle)
        
        do {
            try context.save() // 削除を保存
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
}
