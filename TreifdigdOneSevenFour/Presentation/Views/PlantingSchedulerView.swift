import SwiftUI

struct PlantingSchedulerView: View {
    @EnvironmentObject var viewModel: PlantingSchedulerViewModel
    @State private var showingCalendar = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Quick Stats
                    quickStatsSection
                    
                    // Upcoming Tasks
                    upcomingTasksSection
                    
                    // Projects Section
                    projectsSection
                }
                .padding()
            }
            .navigationTitle("Planting Scheduler")
            .navigationBarItems(trailing: calendarButton)
            .sheet(isPresented: $showingCalendar) {
                CalendarView(viewModel: viewModel)
            }
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.headline)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Upcoming",
                    value: "\(viewModel.getUpcomingTasks().count)",
                    icon: "clock",
                    color: .blue
                )
                
                StatCard(
                    title: "Overdue",
                    value: "\(viewModel.getOverdueTasks().count)",
                    icon: "exclamationmark.triangle",
                    color: .red
                )
                
                StatCard(
                    title: "Projects",
                    value: "\(viewModel.projects.count)",
                    icon: "folder",
                    color: Color(red: 0.13, green: 0.55, blue: 0.13)
                )
            }
        }
    }
    
    private var upcomingTasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Upcoming Tasks")
                    .font(.headline)
                
                Spacer()
                
                Button("View All") {
                    showingCalendar = true
                }
                .font(.caption)
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            }
            
            if viewModel.isLoading {
                ProgressView("Loading tasks...")
                    .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            } else if viewModel.getUpcomingTasks().isEmpty {
                Text("No upcoming tasks")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(viewModel.getUpcomingTasks()) { task in
                    TaskRowView(task: task, viewModel: viewModel)
                }
            }
        }
    }
    
    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Projects")
                .font(.headline)
            
            if viewModel.projects.isEmpty {
                Text("No active projects")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(viewModel.projects) { project in
                    ProjectRowView(project: project)
                }
            }
        }
    }
    
    private var calendarButton: some View {
        Button(action: {
            showingCalendar = true
        }) {
            Image(systemName: "calendar")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct TaskRowView: View {
    let task: PlantingTask
    let viewModel: PlantingSchedulerViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(viewModel.getPriorityColor(task.priority).opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: viewModel.getCategoryIcon(task.category))
                    .foregroundColor(viewModel.getPriorityColor(task.priority))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(task.treeName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(task.dueDate, format: .dateTime.weekday().day().month())
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(task.location)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(task.priority.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(viewModel.getPriorityColor(task.priority).opacity(0.2))
                    .foregroundColor(viewModel.getPriorityColor(task.priority))
                    .cornerRadius(4)
                
                if task.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Button("Complete") {
                        viewModel.completeTask(task)
                    }
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ProjectRowView: View {
    let project: PlantingProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(project.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                StatusBadge(status: project.status)
            }
            
            // Progress Info
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Budget")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "$%.0f / $%.0f", project.actualCost, project.budget))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Location")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(project.location)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            
            // Progress Bar
            ProgressView(value: project.actualCost / project.budget)
                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.13, green: 0.55, blue: 0.13)))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct StatusBadge: View {
    let status: ProjectStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(getStatusColor().opacity(0.2))
            .foregroundColor(getStatusColor())
            .cornerRadius(4)
    }
    
    private func getStatusColor() -> Color {
        switch status {
        case .planning: return .blue
        case .inProgress: return Color(red: 0.13, green: 0.55, blue: 0.13)
        case .onHold: return .orange
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}

struct CalendarView: View {
    @ObservedObject var viewModel: PlantingSchedulerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $viewModel.selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                List(viewModel.getTasksForDate(viewModel.selectedDate)) { task in
                    TaskRowView(task: task, viewModel: viewModel)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Calendar")
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    PlantingSchedulerView()
        .environmentObject(PlantingSchedulerViewModel())
} 