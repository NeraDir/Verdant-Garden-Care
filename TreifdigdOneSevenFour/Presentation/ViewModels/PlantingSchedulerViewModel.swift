import Foundation
import SwiftUI

class PlantingSchedulerViewModel: ObservableObject {
    @Published var tasks: [PlantingTask] = []
    @Published var projects: [PlantingProject] = []
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = false
    @Published var showingUpcomingTasks: Bool = true
    
    init() {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        
        // Sample tasks
        tasks = [
            PlantingTask(
                title: "Water Young Oak Trees",
                description: "Deep watering session for newly planted oak saplings",
                category: .watering,
                priority: .high,
                dueDate: Date().addingTimeInterval(86400),
                estimatedDuration: 3600,
                assignedTo: "Me",
                treeName: "Red Oak",
                location: "Backyard"
            ),
            PlantingTask(
                title: "Prune Apple Tree",
                description: "Annual pruning to maintain shape and health",
                category: .pruning,
                priority: .medium,
                dueDate: Date().addingTimeInterval(172800),
                estimatedDuration: 7200,
                assignedTo: "Me",
                treeName: "Apple Tree",
                location: "Front Yard"
            ),
            PlantingTask(
                title: "Apply Mulch",
                description: "Refresh mulch layer around tree bases",
                category: .mulching,
                priority: .low,
                dueDate: Date().addingTimeInterval(259200),
                estimatedDuration: 5400,
                assignedTo: "Me",
                treeName: "Japanese Maple",
                location: "Side Garden"
            )
        ]
        
        // Sample projects
        projects = [
            PlantingProject(
                name: "Backyard Reforestation",
                description: "Plant 5 oak trees to create a natural windbreak",
                startDate: Date().addingTimeInterval(-604800),
                expectedEndDate: Date().addingTimeInterval(1209600),
                status: .inProgress,
                location: "Backyard",
                budget: 750.0,
                actualCost: 450.0
            ),
            PlantingProject(
                name: "Front Yard Landscaping",
                description: "Ornamental trees and shrubs for curb appeal",
                startDate: Date().addingTimeInterval(-1209600),
                expectedEndDate: Date().addingTimeInterval(302400),
                status: .planning,
                location: "Front Yard",
                budget: 400.0
            )
        ]
        
        isLoading = false
    }
    
    func getTasksForDate(_ date: Date) -> [PlantingTask] {
        let calendar = Calendar.current
        return tasks.filter { task in
            calendar.isDate(task.dueDate, inSameDayAs: date)
        }
    }
    
    func getUpcomingTasks(limit: Int = 5) -> [PlantingTask] {
        return tasks
            .filter { $0.dueDate >= Date() && !$0.isCompleted }
            .sorted { $0.dueDate < $1.dueDate }
            .prefix(limit)
            .map { $0 }
    }
    
    func getOverdueTasks() -> [PlantingTask] {
        return tasks.filter { $0.dueDate < Date() && !$0.isCompleted }
    }
    
    func completeTask(_ task: PlantingTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = true
            tasks[index].completedDate = Date()
        }
    }
    
    func addTask(_ task: PlantingTask) {
        tasks.append(task)
    }
    
    func deleteTask(_ task: PlantingTask) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func getPriorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        case .urgent: return .purple
        }
    }
    
    func getCategoryIcon(_ category: TaskCategory) -> String {
        switch category {
        case .planting: return "leaf"
        case .watering: return "drop"
        case .pruning: return "scissors"
        case .fertilizing: return "testtube.2"
        case .mulching: return "circle.dotted"
        case .inspection: return "magnifyingglass"
        case .treatment: return "cross.case"
        case .protection: return "shield"
        case .maintenance: return "wrench"
        }
    }
} 