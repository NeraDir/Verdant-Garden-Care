import Foundation
import SwiftUI

class ToolInventoryViewModel: ObservableObject {
    @Published var tools: [Tool] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: ToolCategory?
    @Published var isLoading: Bool = false
    
    init() {
        loadTools()
    }
    
    func loadTools() {
        isLoading = true
        // Start with empty list to show empty state message
        tools = []
        isLoading = false
    }
    
    func addTool(_ tool: Tool) {
        tools.append(tool)
    }
    
    func deleteTool(_ tool: Tool) {
        tools.removeAll { $0.id == tool.id }
    }
    
    func updateTool(_ updatedTool: Tool) {
        if let index = tools.firstIndex(where: { $0.id == updatedTool.id }) {
            tools[index] = updatedTool
        }
    }
    
    func filteredTools() -> [Tool] {
        var filtered = tools
        
        if !searchText.isEmpty {
            filtered = filtered.filter { tool in
                tool.name.localizedCaseInsensitiveContains(searchText) ||
                tool.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered
    }
} 