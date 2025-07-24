import Foundation
import SwiftUI

class TreeCatalogViewModel: ObservableObject {
    @Published var trees: [Tree] = []
    @Published var filteredTrees: [Tree] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: TreeCategory?
    @Published var selectedEnvironment: TreeEnvironment?
    @Published var isLoading: Bool = false
    @Published var aiSuggestion: String = ""
    @Published var isLoadingAISuggestion: Bool = false

    
    private let getAllTreesUseCase: GetAllTreesUseCase
    private let searchTreesUseCase: SearchTreesUseCase


    
    init(
        getAllTreesUseCase: GetAllTreesUseCase = GetAllTreesUseCase(repository: TreeRepositoryImpl()),
        searchTreesUseCase: SearchTreesUseCase = SearchTreesUseCase(repository: TreeRepositoryImpl())
    ) {
        self.getAllTreesUseCase = getAllTreesUseCase
        self.searchTreesUseCase = searchTreesUseCase
        
        loadTrees()
    }
    
    func loadTrees() {
        isLoading = true
        trees = getAllTreesUseCase.execute()
        filterTrees()
        isLoading = false
    }
    

    
    func searchTrees() {
        isLoading = true
        filteredTrees = searchTreesUseCase.execute(
            query: searchText,
            category: selectedCategory,
            environment: selectedEnvironment
        )
        isLoading = false
    }
    

    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedEnvironment = nil
        filterTrees()
    }
    
    func getAISuggestion() {
        isLoadingAISuggestion = true
        aiSuggestion = ""
        
        Task {
            // Simulate AI request
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            
            let suggestions = [
                "Based on your climate, I recommend planting an oak tree this season. It's drought-resistant and perfect for your region.",
                "To improve air quality in your area, I suggest a linden tree. It purifies air excellently and grows quickly.",
                "Considering your plot size, an apple tree would be ideal. It will provide fruit and beautify your garden with blossoms.",
                "For creating shade, I recommend a maple tree. It grows fast and creates dense foliage.",
                "A birch tree would be perfect for decorative purposes. It's low-maintenance and beautiful year-round."
            ]
            
            let randomSuggestion = suggestions.randomElement() ?? suggestions[0]
            
            await MainActor.run {
                self.aiSuggestion = randomSuggestion
                self.isLoadingAISuggestion = false
            }
        }
    }
    
    func filterTrees() {
        if searchText.isEmpty && selectedCategory == nil && selectedEnvironment == nil {
            filteredTrees = trees
        } else {
            searchTrees()
        }
    }
    
    func getCategoryColor(_ category: TreeCategory) -> Color {
        switch category {
        case .deciduous: return .orange
        case .evergreen: return Color(red: 0.13, green: 0.55, blue: 0.13) // Forest Green
        case .fruit: return .red
        case .flowering: return .pink
        case .nut: return .brown
        case .ornamental: return .purple
        }
    }
    
    func getEnvironmentIcon(_ environment: TreeEnvironment) -> String {
        switch environment {
        case .urban: return "building.2"
        case .suburban: return "house"
        case .rural: return "leaf"
        case .coastal: return "water.waves"
        case .mountain: return "mountain.2"
        case .desert: return "sun.max"
        }
    }
} 