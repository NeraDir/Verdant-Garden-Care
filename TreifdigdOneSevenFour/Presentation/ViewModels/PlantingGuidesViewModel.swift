import Foundation
import SwiftUI

class PlantingGuidesViewModel: ObservableObject {
    @Published var guides: [PlantingGuide] = []
    @Published var inProgressGuides: [PlantingGuide] = []
    @Published var completedGuides: [PlantingGuide] = []
    @Published var selectedDifficulty: Difficulty?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let getAllGuidesUseCase: GetAllGuidesUseCase
    private let startGuideUseCase: StartGuideUseCase
    private let completeStepUseCase: CompleteStepUseCase
    
    init(
        getAllGuidesUseCase: GetAllGuidesUseCase,
        startGuideUseCase: StartGuideUseCase,
        completeStepUseCase: CompleteStepUseCase
    ) {
        self.getAllGuidesUseCase = getAllGuidesUseCase
        self.startGuideUseCase = startGuideUseCase
        self.completeStepUseCase = completeStepUseCase
        
        loadGuides()
    }
    
    func loadGuides() {
        isLoading = true
        guides = getAllGuidesUseCase.execute()
        updateFilteredGuides()
        isLoading = false
    }
    
    func startGuide(_ guide: PlantingGuide) {
        if let updatedGuide = startGuideUseCase.execute(guideId: guide.id) {
            updateGuideInArrays(updatedGuide)
        }
    }
    
    func completeStep(guideId: UUID, stepNumber: Int, notes: String = "") {
        if let updatedGuide = completeStepUseCase.execute(guideId: guideId, stepNumber: stepNumber, notes: notes) {
            updateGuideInArrays(updatedGuide)
        }
    }
    
    func filterGuides() {
        updateFilteredGuides()
    }
    
    private func updateFilteredGuides() {
        var filtered = guides
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { guide in
                guide.title.localizedCaseInsensitiveContains(searchText) ||
                guide.treeType.localizedCaseInsensitiveContains(searchText) ||
                guide.steps.contains { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Filter by difficulty
        if let difficulty = selectedDifficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }
        
        // Separate by progress status
        inProgressGuides = filtered.filter { $0.userProgress.isStarted && !$0.userProgress.isCompleted }
        completedGuides = filtered.filter { $0.userProgress.isCompleted }
        
        // Remaining guides (not started)
        let notStartedGuides = filtered.filter { !$0.userProgress.isStarted }
        guides = notStartedGuides
    }
    
    private func updateGuideInArrays(_ guide: PlantingGuide) {
        // Update in all arrays
        if let index = guides.firstIndex(where: { $0.id == guide.id }) {
            guides[index] = guide
        }
        if let index = inProgressGuides.firstIndex(where: { $0.id == guide.id }) {
            inProgressGuides[index] = guide
        }
        if let index = completedGuides.firstIndex(where: { $0.id == guide.id }) {
            completedGuides[index] = guide
        }
        
        // Re-filter to move guides between categories if needed
        updateFilteredGuides()
    }
    
    func getDifficultyColor(_ difficulty: Difficulty) -> Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        case .expert: return .purple
        }
    }
    
    func getProgressPercentage(_ guide: PlantingGuide) -> Double {
        let totalSteps = guide.steps.count
        let completedSteps = guide.userProgress.completedSteps.count
        return totalSteps > 0 ? Double(completedSteps) / Double(totalSteps) : 0.0
    }
} 