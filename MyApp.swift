import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self, Style.self,
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
    
    private static func addInitialDataIfNeeded(to container: ModelContainer) {
        let context = ModelContext(container)
        
        let existingItems = try? context.fetch(FetchDescriptor<Item>())
        if let existingItems, !existingItems.isEmpty {
            return
        }
        
        let existingStyles = try? context.fetch(FetchDescriptor<Style>())
        if let existingStyles, !existingStyles.isEmpty {
            return
        }
        
        let initialItems: [Item] = [
            // TOPS
            Item(descriptionText: "Initial Tops", type: .tops, uiImageName: "tops01", true, true, true, true),
            Item(descriptionText: "Initial Tops", type: .tops, uiImageName: "tops04", true, true, true, true),
            Item(descriptionText: "Initial Tops", type: .tops, uiImageName: "tops06", true, true, true, true),
            Item(descriptionText: "Initial Tops", type: .tops, uiImageName: "tops10", true, true, true, true),
            Item(descriptionText: "Initial Tops", type: .tops, uiImageName: "tops15", true, true, true, true),
            Item(descriptionText: "Initial Tops", type: .tops, uiImageName: "tops17", true, true, true, true),
            
            // BOTTOMS
            Item(descriptionText: "Initial Bottoms", type: .bottoms, uiImageName: "bottoms03", true, true, true, true),
            Item(descriptionText: "Initial Bottoms", type: .bottoms, uiImageName: "bottoms04", true, true, true, true),
            Item(descriptionText: "Initial Bottoms", type: .bottoms, uiImageName: "bottoms05", true, true, true, true),
            Item(descriptionText: "Initial Bottoms", type: .bottoms, uiImageName: "bottoms06", true, true, true, true),
            
            // SHOES
            Item(descriptionText: "Initial Shoes", type: .shoes, uiImageName: "shoes02", true, true, true, true),
            Item(descriptionText: "Initial Shoes", type: .shoes, uiImageName: "shoes05", true, true, true, true),
            Item(descriptionText: "Initial Shoes", type: .shoes, uiImageName: "shoes07", true, true, true, true),
            Item(descriptionText: "Initial Shoes", type: .shoes, uiImageName: "shoes10", true, true, true, true),
            Item(descriptionText: "Initial Shoes", type: .shoes, uiImageName: "shoes11", true, true, true, true),
            
        ]
        
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
            try context.save()
            print("Initial data saved.")
        } catch {
            print("Failed to save initial data: \(error)")
        }
    }
}
