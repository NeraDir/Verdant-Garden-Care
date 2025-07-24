import Foundation

struct PlantingTask: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var category: TaskCategory
    var priority: TaskPriority
    var dueDate: Date
    var estimatedDuration: TimeInterval
    var isCompleted: Bool
    var completedDate: Date?
    var assignedTo: String
    var treeId: UUID?
    var treeName: String
    var location: String
    var requiredTools: [String]
    var requiredMaterials: [String]
    var notes: String
    var weatherDependent: Bool
    var reminders: [TaskReminder]
    
    init(title: String, description: String, category: TaskCategory, priority: TaskPriority, dueDate: Date, estimatedDuration: TimeInterval, isCompleted: Bool = false, completedDate: Date? = nil, assignedTo: String, treeId: UUID? = nil, treeName: String, location: String, requiredTools: [String] = [], requiredMaterials: [String] = [], notes: String = "", weatherDependent: Bool = false, reminders: [TaskReminder] = []) {
        self.title = title
        self.description = description
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
        self.estimatedDuration = estimatedDuration
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.assignedTo = assignedTo
        self.treeId = treeId
        self.treeName = treeName
        self.location = location
        self.requiredTools = requiredTools
        self.requiredMaterials = requiredMaterials
        self.notes = notes
        self.weatherDependent = weatherDependent
        self.reminders = reminders
    }
}

struct TaskReminder: Identifiable, Codable {
    let id = UUID()
    var reminderDate: Date
    var message: String
    var isTriggered: Bool
    
    init(reminderDate: Date, message: String, isTriggered: Bool = false) {
        self.reminderDate = reminderDate
        self.message = message
        self.isTriggered = isTriggered
    }
}

struct PlantingProject: Identifiable, Codable {
    let id = UUID()
    var name: String
    var description: String
    var startDate: Date
    var expectedEndDate: Date
    var actualEndDate: Date?
    var status: ProjectStatus
    var tasks: [UUID] // Task IDs
    var treeIds: [UUID]
    var location: String
    var budget: Double
    var actualCost: Double
    var notes: String
    
    init(name: String, description: String, startDate: Date, expectedEndDate: Date, actualEndDate: Date? = nil, status: ProjectStatus, tasks: [UUID] = [], treeIds: [UUID] = [], location: String, budget: Double, actualCost: Double = 0, notes: String = "") {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.expectedEndDate = expectedEndDate
        self.actualEndDate = actualEndDate
        self.status = status
        self.tasks = tasks
        self.treeIds = treeIds
        self.location = location
        self.budget = budget
        self.actualCost = actualCost
        self.notes = notes
    }
}

enum TaskCategory: String, CaseIterable, Codable {
    case planting = "Planting"
    case watering = "Watering"
    case pruning = "Pruning"
    case fertilizing = "Fertilizing"
    case mulching = "Mulching"
    case inspection = "Inspection"
    case treatment = "Treatment"
    case protection = "Protection"
    case maintenance = "Maintenance"
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
}

enum ProjectStatus: String, CaseIterable, Codable {
    case planning = "Planning"
    case inProgress = "In Progress"
    case onHold = "On Hold"
    case completed = "Completed"
    case cancelled = "Cancelled"
} 