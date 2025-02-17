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
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
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
}
