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
            // TOPS
            Item(descriptionText: "Initial Tops 00", type: .tops, uiImageName: "tops", true, true, true, true),
            Item(descriptionText: "Initial Tops 01", type: .tops, uiImageName: "tops01", true, true, true, true),
            Item(descriptionText: "Initial Tops 02", type: .tops, uiImageName: "tops02", true, true, true, true),
            Item(descriptionText: "Initial Tops 03", type: .tops, uiImageName: "tops03", true, true, true, true),
//            Item(descriptionText: "Initial Tops 04", type: .tops, uiImageName: "tops04", true, true, true, true),
//            Item(descriptionText: "Initial Tops 05", type: .tops, uiImageName: "tops05", true, true, true, true),
//            Item(descriptionText: "Initial Tops 06", type: .tops, uiImageName: "tops06", true, true, true, true),
//            Item(descriptionText: "Initial Tops 07", type: .tops, uiImageName: "tops07", true, true, true, true),
//            Item(descriptionText: "Initial Tops 08", type: .tops, uiImageName: "tops08", true, true, true, true),
//            Item(descriptionText: "Initial Tops 09", type: .tops, uiImageName: "tops09", true, true, true, true),
//            Item(descriptionText: "Initial Tops 10", type: .tops, uiImageName: "tops10", true, true, true, true),
//            Item(descriptionText: "Initial Tops 11", type: .tops, uiImageName: "tops11", true, true, true, true),
//            Item(descriptionText: "Initial Tops 12", type: .tops, uiImageName: "tops12", true, true, true, true),
//            Item(descriptionText: "Initial Tops 13", type: .tops, uiImageName: "tops13", true, true, true, true),
//            Item(descriptionText: "Initial Tops 14", type: .tops, uiImageName: "tops14", true, true, true, true),
//            Item(descriptionText: "Initial Tops 15", type: .tops, uiImageName: "tops15", true, true, true, true),
//            Item(descriptionText: "Initial Tops 16", type: .tops, uiImageName: "tops16", true, true, true, true),
//            Item(descriptionText: "Initial Tops 17", type: .tops, uiImageName: "tops17", true, true, true, true),
            // BOTTOMS
            Item(descriptionText: "Initial Bottoms 01", type: .bottoms, uiImageName: "bottoms01", true, true, true, true),
            Item(descriptionText: "Initial Bottoms 02", type: .bottoms, uiImageName: "bottoms02", true, true, true, true),
            Item(descriptionText: "Initial Bottoms 03", type: .bottoms, uiImageName: "bottoms03", true, true, true, true),
//            Item(descriptionText: "Initial Bottoms 04", type: .bottoms, uiImageName: "bottoms04", true, true, true, true),
//            Item(descriptionText: "Initial Bottoms 05", type: .bottoms, uiImageName: "bottoms05", true, true, true, true),
//            Item(descriptionText: "Initial Bottoms 06", type: .bottoms, uiImageName: "bottoms06", true, true, true, true),
//            Item(descriptionText: "Initial Bottoms 07", type: .bottoms, uiImageName: "bottoms07", true, true, true, true),
            // SHOES
            Item(descriptionText: "Initial Shoes 01", type: .shoes, uiImageName: "shoes01", true, true, true, true),
            Item(descriptionText: "Initial Shoes 02", type: .shoes, uiImageName: "shoes02", true, true, true, true),
            Item(descriptionText: "Initial Shoes 03", type: .shoes, uiImageName: "shoes03", true, true, true, true),
//            Item(descriptionText: "Initial Shoes 04", type: .shoes, uiImageName: "shoes04", true, true, true, true),
//            Item(descriptionText: "Initial Shoes 05", type: .shoes, uiImageName: "shoes05", true, true, true, true),
//            Item(descriptionText: "Initial Shoes 06", type: .shoes, uiImageName: "shoes06", true, true, true, true),
//            Item(descriptionText: "Initial Shoes 07", type: .shoes, uiImageName: "shoes07", true, true, true, true),
//            Item(descriptionText: "Initial Shoes 08", type: .shoes, uiImageName: "shoes08", true, true, true, true),
//            Item(descriptionText: "Initial Shoes 09", type: .shoes, uiImageName: "shoes09", true, true, true, true),
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
