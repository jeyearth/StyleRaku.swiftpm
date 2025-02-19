import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Face.self, Item.self, Style.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            addInitialDataIfNeeded(to: container)
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var viewModel = StylingDetailViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(viewModel)
        }
    }
    
    /// 初回起動時にデータがなければ追加する
    private static func addInitialDataIfNeeded(to container: ModelContainer) {
        let context = ModelContext(container)
        
        // すでにデータがあるか確認
        let existingItems = try? context.fetch(FetchDescriptor<Item>())
        if let existingItems, !existingItems.isEmpty {
            return  // データがすでにある場合は何もしない
        }
        
        let existingStyles = try? context.fetch(FetchDescriptor<Style>())
        if let existingStyles, !existingStyles.isEmpty {
            return
        }
        
        // 初期データの作成
        let initialItems: [Item] = [
            Item(descriptionText: "Initial Item 01", type: .tops, uiImageName: "jacket", true, true, true, true),
            Item(descriptionText: "Initial Item 02", type: .bottoms, uiImageName: "pants", true, true, true, false),
            Item(descriptionText: "Initial Item 03", type: .shoes, uiImageName: "shoes", true, true, true, true)
        ]
        
        // データを SwiftData に追加
        for item in initialItems {
            context.insert(item)
        }
        
        let initialStyles: [Style] = [
            Style(name: "Style 1"),
            Style(name: "Style 2")
        ]
        
        for style in initialStyles {
            context.insert(style)
        }
        
        do {
            try context.save()  // データを保存
            print("初期データを保存しました")
        } catch {
            print("初期データの保存に失敗しました: \(error)")
        }
    }
}
