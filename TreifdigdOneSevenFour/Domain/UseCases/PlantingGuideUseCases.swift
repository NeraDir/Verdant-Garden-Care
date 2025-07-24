import Foundation

protocol PlantingGuideRepository {
    func getAllGuides() -> [PlantingGuide]
    func getGuide(by id: UUID) -> PlantingGuide?
    func getGuidesByDifficulty(_ difficulty: Difficulty) -> [PlantingGuide]
    func getGuidesByTreeType(_ treeType: String) -> [PlantingGuide]
    func saveGuide(_ guide: PlantingGuide)
    func updateGuideProgress(_ guide: PlantingGuide)
    func markStepCompleted(guideId: UUID, stepNumber: Int)
    func resetGuideProgress(guideId: UUID)
}

class GetAllGuidesUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute() -> [PlantingGuide] {
        return repository.getAllGuides()
    }
}

class GetGuideByIdUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute(id: UUID) -> PlantingGuide? {
        return repository.getGuide(by: id)
    }
}

class GetGuidesByDifficultyUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute(difficulty: Difficulty) -> [PlantingGuide] {
        return repository.getGuidesByDifficulty(difficulty)
    }
}

class GetGuidesByTreeTypeUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute(treeType: String) -> [PlantingGuide] {
        return repository.getGuidesByTreeType(treeType)
    }
}

class StartGuideUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute(guideId: UUID) -> PlantingGuide? {
        guard var guide = repository.getGuide(by: guideId) else { return nil }
        
        guide.userProgress.isStarted = true
        guide.userProgress.startDate = Date()
        guide.userProgress.currentStep = 1
        
        repository.updateGuideProgress(guide)
        return guide
    }
}

class CompleteStepUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute(guideId: UUID, stepNumber: Int, notes: String = "") -> PlantingGuide? {
        guard var guide = repository.getGuide(by: guideId) else { return nil }
        
        // Find and update the step
        if let stepIndex = guide.steps.firstIndex(where: { $0.stepNumber == stepNumber }) {
            guide.steps[stepIndex].isCompleted = true
            guide.steps[stepIndex].completedDate = Date()
            guide.steps[stepIndex].notes = notes
        }
        
        // Update user progress
        if !guide.userProgress.completedSteps.contains(stepNumber) {
            guide.userProgress.completedSteps.append(stepNumber)
        }
        
        // Check if all steps are completed
        let totalSteps = guide.steps.count
        if guide.userProgress.completedSteps.count == totalSteps {
            guide.userProgress.isCompleted = true
            guide.userProgress.completionDate = Date()
        } else {
            // Move to next step
            let nextStep = guide.userProgress.completedSteps.count + 1
            if nextStep <= totalSteps {
                guide.userProgress.currentStep = nextStep
            }
        }
        
        repository.updateGuideProgress(guide)
        return guide
    }
}

class ResetGuideProgressUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute(guideId: UUID) -> PlantingGuide? {
        guard var guide = repository.getGuide(by: guideId) else { return nil }
        
        // Reset all steps
        for index in guide.steps.indices {
            guide.steps[index].isCompleted = false
            guide.steps[index].completedDate = nil
            guide.steps[index].notes = ""
        }
        
        // Reset progress
        guide.userProgress = UserProgress()
        
        repository.updateGuideProgress(guide)
        return guide
    }
}

class GetInProgressGuidesUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute() -> [PlantingGuide] {
        return repository.getAllGuides().filter { $0.userProgress.isStarted && !$0.userProgress.isCompleted }
    }
}

class GetCompletedGuidesUseCase {
    private let repository: PlantingGuideRepository
    
    init(repository: PlantingGuideRepository) {
        self.repository = repository
    }
    
    func execute() -> [PlantingGuide] {
        return repository.getAllGuides().filter { $0.userProgress.isCompleted }
    }
} 