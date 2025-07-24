import Foundation

struct PlantingGuide: Identifiable, Codable {
    let id = UUID()
    var title: String
    var treeType: String
    var difficulty: Difficulty
    var estimatedTime: String
    var steps: [PlantingStep]
    var requiredTools: [String]
    var requiredMaterials: [String]
    var tips: [String]
    var userProgress: UserProgress
    
    init(title: String, treeType: String, difficulty: Difficulty, estimatedTime: String, steps: [PlantingStep], requiredTools: [String], requiredMaterials: [String], tips: [String], userProgress: UserProgress = UserProgress()) {
        self.title = title
        self.treeType = treeType
        self.difficulty = difficulty
        self.estimatedTime = estimatedTime
        self.steps = steps
        self.requiredTools = requiredTools
        self.requiredMaterials = requiredMaterials
        self.tips = tips
        self.userProgress = userProgress
    }
}

struct PlantingStep: Identifiable, Codable {
    let id = UUID()
    var stepNumber: Int
    var title: String
    var description: String
    var iconName: String
    var estimatedTime: String
    var isCompleted: Bool
    var completedDate: Date?
    var notes: String
    
    init(stepNumber: Int, title: String, description: String, iconName: String, estimatedTime: String, isCompleted: Bool = false, completedDate: Date? = nil, notes: String = "") {
        self.stepNumber = stepNumber
        self.title = title
        self.description = description
        self.iconName = iconName
        self.estimatedTime = estimatedTime
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.notes = notes
    }
}

struct UserProgress: Codable {
    var isStarted: Bool
    var startDate: Date?
    var currentStep: Int
    var completedSteps: [Int]
    var totalTimeSpent: TimeInterval
    var isCompleted: Bool
    var completionDate: Date?
    
    init(isStarted: Bool = false, startDate: Date? = nil, currentStep: Int = 1, completedSteps: [Int] = [], totalTimeSpent: TimeInterval = 0, isCompleted: Bool = false, completionDate: Date? = nil) {
        self.isStarted = isStarted
        self.startDate = startDate
        self.currentStep = currentStep
        self.completedSteps = completedSteps
        self.totalTimeSpent = totalTimeSpent
        self.isCompleted = isCompleted
        self.completionDate = completionDate
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
} 