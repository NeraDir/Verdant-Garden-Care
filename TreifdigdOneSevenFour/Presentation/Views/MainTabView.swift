import SwiftUI

struct MainTabView: View {
    @StateObject private var dependencies = DependencyContainer()
    
    var body: some View {
        TabView {
            TreeCatalogView()
                .environmentObject(dependencies.treeCatalogViewModel)
                .tabItem {
                    Image(systemName: "tree")
                    Text("Catalog")
                }
            
            PlantingGuidesView()
                .environmentObject(dependencies.plantingGuidesViewModel)
                .tabItem {
                    Image(systemName: "book")
                    Text("Guides")
                }
            
            ToolInventoryView()
                .environmentObject(dependencies.toolInventoryViewModel)
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver")
                    Text("Tools")
                }
            
            MaterialCalculatorView()
                .environmentObject(dependencies.materialCalculatorViewModel)
                .tabItem {
                    Image(systemName: "function")
                    Text("Calculator")
                }
            
            CostTrackerView()
                .environmentObject(dependencies.costTrackerViewModel)
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Costs")
                }
            
            AIAdvisorView()
                .environmentObject(dependencies.aiAdvisorViewModel)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("AI Advisor")
                }
            
            PlantingSchedulerView()
                .environmentObject(dependencies.plantingSchedulerViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Scheduler")
                }
            

        }
        .accentColor(Color(red: 0.13, green: 0.55, blue: 0.13)) // Forest Green
    }
}

// Dependency Injection Container
class DependencyContainer: ObservableObject {
    // Repositories
    private let treeRepository: TreeRepository
    private let aiRepository: AIRepository
    private let plantingGuideRepository: PlantingGuideRepository
    
    // Use Cases
    private let getAllTreesUseCase: GetAllTreesUseCase
    private let searchTreesUseCase: SearchTreesUseCase

    private let sendMessageToAIUseCase: SendMessageToAIUseCase
    private let getChatSessionsUseCase: GetChatSessionsUseCase
    private let saveChatSessionUseCase: SaveChatSessionUseCase
    private let getAllGuidesUseCase: GetAllGuidesUseCase
    private let startGuideUseCase: StartGuideUseCase
    private let completeStepUseCase: CompleteStepUseCase
    
    // ViewModels
    lazy var treeCatalogViewModel: TreeCatalogViewModel = {
        TreeCatalogViewModel(
            getAllTreesUseCase: getAllTreesUseCase,
            searchTreesUseCase: searchTreesUseCase
        )
    }()
    
    lazy var aiAdvisorViewModel: AIAdvisorViewModel = {
        AIAdvisorViewModel(
            sendMessageUseCase: sendMessageToAIUseCase,
            getChatSessionsUseCase: getChatSessionsUseCase,
            saveChatSessionUseCase: saveChatSessionUseCase
        )
    }()
    
    lazy var plantingGuidesViewModel: PlantingGuidesViewModel = {
        PlantingGuidesViewModel(
            getAllGuidesUseCase: getAllGuidesUseCase,
            startGuideUseCase: startGuideUseCase,
            completeStepUseCase: completeStepUseCase
        )
    }()
    
    lazy var toolInventoryViewModel: ToolInventoryViewModel = {
        ToolInventoryViewModel()
    }()
    
    lazy var materialCalculatorViewModel: MaterialCalculatorViewModel = {
        MaterialCalculatorViewModel()
    }()
    
    lazy var costTrackerViewModel: CostTrackerViewModel = {
        CostTrackerViewModel()
    }()
    
    lazy var plantingSchedulerViewModel: PlantingSchedulerViewModel = {
        PlantingSchedulerViewModel()
    }()
    

    
    init() {
        // Initialize repositories
        self.treeRepository = TreeRepositoryImpl()
        self.aiRepository = AIRepositoryImpl()
        self.plantingGuideRepository = PlantingGuideRepositoryImpl()
        
        // Initialize use cases
        self.getAllTreesUseCase = GetAllTreesUseCase(repository: treeRepository)
        self.searchTreesUseCase = SearchTreesUseCase(repository: treeRepository)
        self.sendMessageToAIUseCase = SendMessageToAIUseCase(repository: aiRepository)
        self.getChatSessionsUseCase = GetChatSessionsUseCase(repository: aiRepository)
        self.saveChatSessionUseCase = SaveChatSessionUseCase(repository: aiRepository)
        self.getAllGuidesUseCase = GetAllGuidesUseCase(repository: plantingGuideRepository)
        self.startGuideUseCase = StartGuideUseCase(repository: plantingGuideRepository)
        self.completeStepUseCase = CompleteStepUseCase(repository: plantingGuideRepository)
    }
}

#Preview {
    MainTabView()
} 