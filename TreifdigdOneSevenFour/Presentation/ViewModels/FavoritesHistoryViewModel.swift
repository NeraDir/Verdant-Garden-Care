import Foundation
import SwiftUI

class FavoritesHistoryViewModel: ObservableObject {
    @Published var favoriteTrees: [Tree] = []
    @Published var plantingHistory: [PlantingRecord] = []
    @Published var searchHistory: [SearchRecord] = []
    @Published var achievements: [Achievement] = []
    @Published var isLoading: Bool = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        
        // Load favorite trees (empty list since we removed favorites functionality)
        favoriteTrees = []
        
        // Sample planting history
        plantingHistory = [
            PlantingRecord(
                treeId: UUID(),
                treeName: "Red Oak",
                plantingDate: Date().addingTimeInterval(-2592000), // 30 days ago
                location: "Backyard",
                successRate: 1.0,
                notes: "Healthy growth, regular watering schedule maintained"
            ),
            PlantingRecord(
                treeId: UUID(),
                treeName: "Japanese Maple",
                plantingDate: Date().addingTimeInterval(-5184000), // 60 days ago
                location: "Front Garden",
                successRate: 0.9,
                notes: "Some initial transplant shock, but recovering well"
            ),
            PlantingRecord(
                treeId: UUID(),
                treeName: "Apple Tree",
                plantingDate: Date().addingTimeInterval(-7776000), // 90 days ago
                location: "Side Yard",
                successRate: 1.0,
                notes: "Excellent growth, first buds appearing"
            )
        ]
        
        // Sample search history
        searchHistory = [
            SearchRecord(query: "oak tree", searchType: .trees, resultCount: 5),
            SearchRecord(query: "pruning guide", searchType: .guides, resultCount: 3),
            SearchRecord(query: "watering", searchType: .advice, resultCount: 8),
            SearchRecord(query: "fertilizer", searchType: .materials, resultCount: 12)
        ]
        
        // Sample achievements
        achievements = [
            Achievement(
                title: "First Planting",
                description: "Plant your first tree",
                iconName: "leaf",
                isUnlocked: true,
                progress: 1.0,
                requirement: "Plant 1 tree"
            ),
            Achievement(
                title: "Tree Lover",
                description: "Add 5 trees to favorites",
                iconName: "heart.fill",
                isUnlocked: favoriteTrees.count >= 5,
                progress: min(Double(favoriteTrees.count) / 5.0, 1.0),
                requirement: "Favorite 5 trees"
            ),
            Achievement(
                title: "Green Thumb",
                description: "Successfully grow 3 trees",
                iconName: "hand.thumbsup",
                isUnlocked: false,
                progress: 0.67,
                requirement: "Successfully grow 3 trees"
            ),
            Achievement(
                title: "Researcher",
                description: "Use AI advisor 10 times",
                iconName: "brain.head.profile",
                isUnlocked: false,
                progress: 0.3,
                requirement: "Ask AI advisor 10 questions"
            )
        ]
        
        isLoading = false
    }
    
    func refreshFavorites() {
        favoriteTrees = [] // Empty list since we removed favorites functionality
    }
    
    func getRecentSearches(limit: Int = 5) -> [SearchRecord] {
        return Array(searchHistory.prefix(limit))
    }
    
    func getUnlockedAchievements() -> [Achievement] {
        return achievements.filter { $0.isUnlocked }
    }
    
    func getInProgressAchievements() -> [Achievement] {
        return achievements.filter { !$0.isUnlocked && $0.progress > 0 }
    }
    
    func getTotalTreesPlanted() -> Int {
        return plantingHistory.count
    }
    
    func getSuccessRate() -> Double {
        guard !plantingHistory.isEmpty else { return 0 }
        let totalSuccess = plantingHistory.reduce(0) { $0 + $1.successRate }
        return totalSuccess / Double(plantingHistory.count)
    }
} 