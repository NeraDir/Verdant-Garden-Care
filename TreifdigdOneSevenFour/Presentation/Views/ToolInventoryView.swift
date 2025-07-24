import SwiftUI

struct ToolInventoryView: View {
    @EnvironmentObject var viewModel: ToolInventoryViewModel
    @State private var showingEditView = false
    @State private var selectedTool: Tool?
    @State private var showingDeleteAlert = false
    @State private var toolToDelete: Tool?
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    HStack {
                        TextField("Search tools...", text: $viewModel.searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Tools List
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading tools...")
                        .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                    Spacer()
                } else {
                    if viewModel.filteredTools().isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Text("No Tools Available")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text("Start building your tool inventory by adding your first tool")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Button("Add Your First Tool") {
                                selectedTool = nil
                                showingEditView = true
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.13, green: 0.55, blue: 0.13))
                            .cornerRadius(10)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(viewModel.filteredTools()) { tool in
                            ToolRowView(
                                tool: tool,
                                onEdit: {
                                    selectedTool = tool
                                    showingEditView = true
                                },
                                onDelete: {
                                    toolToDelete = tool
                                    showingDeleteAlert = true
                                }
                            )
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Tool Inventory")
            .navigationBarItems(
                trailing: Button("Add") {
                    selectedTool = nil
                    showingEditView = true
                }
            )
            .sheet(isPresented: $showingEditView) {
                if let tool = selectedTool {
                    EditToolView(viewModel: viewModel, tool: tool)
                } else {
                    EditToolView(viewModel: viewModel)
                }
            }
            .alert("Delete Tool", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let tool = toolToDelete {
                        viewModel.deleteTool(tool)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this tool? This action cannot be undone.")
            }
        }
    }
}

struct ToolRowView: View {
    let tool: Tool
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Tool Category Indicator
            ZStack {
                Circle()
                    .fill(getCategoryColor(tool.category).opacity(0.2))
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.headline)
                
                Text(tool.brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(tool.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(getCategoryColor(tool.category).opacity(0.2))
                        .foregroundColor(getCategoryColor(tool.category))
                        .cornerRadius(4)
                    
                    Text(tool.condition.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(getConditionColor(tool.condition).opacity(0.2))
                        .foregroundColor(getConditionColor(tool.condition))
                        .cornerRadius(4)
                    
                    Spacer()
                }
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", tool.price))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(tool.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Button(action: onEdit) {
                        Text("Edit")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Button(action: onDelete) {
                        Text("Delete")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func getCategoryColor(_ category: ToolCategory) -> Color {
        switch category {
        case .digging: return .brown
        case .cutting: return .red
        case .watering: return .blue
        case .measuring: return .orange
        case .protection: return .green
        case .maintenance: return .purple
        case .planting: return Color(red: 0.13, green: 0.55, blue: 0.13)
        }
    }
    

    
    private func getConditionColor(_ condition: ToolCondition) -> Color {
        switch condition {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        case .needsRepair: return .purple
        }
    }
}

#Preview {
    ToolInventoryView()
        .environmentObject(ToolInventoryViewModel())
} 