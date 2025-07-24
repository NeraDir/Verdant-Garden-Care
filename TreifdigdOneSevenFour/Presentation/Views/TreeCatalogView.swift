import SwiftUI

struct TreeCatalogView: View {
    @EnvironmentObject var viewModel: TreeCatalogViewModel
    @State private var showingFilters = false
    @State private var selectedTree: Tree?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // AI Suggestions Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("AI Suggestions")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.getAISuggestion()
                        }) {
                            HStack(spacing: 4) {
                                if viewModel.isLoadingAISuggestion {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "brain.head.profile")
                                }
                                Text("Get Suggestion")
                            }
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.13, green: 0.55, blue: 0.13))
                            .cornerRadius(8)
                        }
                        .disabled(viewModel.isLoadingAISuggestion)
                    }
                    
                    if !viewModel.aiSuggestion.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "lightbulb")
                                    .foregroundColor(.orange)
                                Text("Recommendation")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            Text(viewModel.aiSuggestion)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Filter Pills
                if viewModel.selectedCategory != nil || viewModel.selectedEnvironment != nil {
                    filterPills
                }
                
                // Tree List
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading trees...")
                        .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                    Spacer()
                } else if viewModel.filteredTrees.isEmpty {
                    emptyState
                } else {
                    treeList
                }
            }
            .navigationTitle("Tree Catalog")
            .navigationBarItems(trailing: filterButton)
            .sheet(isPresented: $showingFilters) {
                FilterSheet(viewModel: viewModel)
            }
            .sheet(item: $selectedTree) { tree in
                TreeDetailView(tree: tree, viewModel: viewModel)
            }
            .onChange(of: viewModel.searchText) { _ in
                viewModel.filterTrees()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search trees...", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let category = viewModel.selectedCategory {
                    FilterPill(
                        title: category.rawValue,
                        color: viewModel.getCategoryColor(category)
                    ) {
                        viewModel.selectedCategory = nil
                        viewModel.filterTrees()
                    }
                }
                
                if let environment = viewModel.selectedEnvironment {
                    FilterPill(
                        title: environment.rawValue,
                        color: .blue
                    ) {
                        viewModel.selectedEnvironment = nil
                        viewModel.filterTrees()
                    }
                }
                
                Button("Clear All") {
                    viewModel.clearFilters()
                }
                .foregroundColor(.red)
                .font(.caption)
                .padding(.horizontal, 8)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 4)
    }
    
    private var treeList: some View {
        List(viewModel.filteredTrees) { tree in
            TreeRowView(tree: tree, viewModel: viewModel) {
                selectedTree = tree
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tree")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No trees found")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Try adjusting your search or filters")
                .foregroundColor(.secondary)
            
            if viewModel.selectedCategory != nil || viewModel.selectedEnvironment != nil {
                Button("Clear Filters") {
                    viewModel.clearFilters()
                }
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var filterButton: some View {
        Button(action: {
            showingFilters = true
        }) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
        }
    }
}

struct TreeRowView: View {
    let tree: Tree
    let viewModel: TreeCatalogViewModel
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Tree icon
            ZStack {
                Circle()
                    .fill(viewModel.getCategoryColor(tree.category).opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "tree")
                    .font(.title2)
                    .foregroundColor(viewModel.getCategoryColor(tree.category))
            }
            
                            VStack(alignment: .leading, spacing: 4) {
                    Text(tree.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                
                Text(tree.scientificName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                
                HStack {
                    CategoryBadge(category: tree.category, color: viewModel.getCategoryColor(tree.category))
                    
                    EnvironmentBadge(environment: tree.environment)
                    
                    Spacer()
                }
            }
            
            Button(action: onTap) {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct CategoryBadge: View {
    let category: TreeCategory
    let color: Color
    
    var body: some View {
        Text(category.rawValue)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

struct EnvironmentBadge: View {
    let environment: TreeEnvironment
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: getEnvironmentIcon())
                .font(.caption2)
            Text(environment.rawValue)
                .font(.caption2)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color.blue.opacity(0.2))
        .foregroundColor(.blue)
        .cornerRadius(4)
    }
    
    private func getEnvironmentIcon() -> String {
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

struct FilterPill: View {
    let title: String
    let color: Color
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.caption)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .cornerRadius(8)
    }
}

struct FilterSheet: View {
    @ObservedObject var viewModel: TreeCatalogViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Category Filter
                VStack(alignment: .leading, spacing: 12) {
                    Text("Category")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(TreeCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                category: category,
                                isSelected: viewModel.selectedCategory == category,
                                color: viewModel.getCategoryColor(category)
                            ) {
                                if viewModel.selectedCategory == category {
                                    viewModel.selectedCategory = nil
                                } else {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                    }
                }
                
                // Environment Filter
                VStack(alignment: .leading, spacing: 12) {
                    Text("Environment")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(TreeEnvironment.allCases, id: \.self) { environment in
                            EnvironmentFilterButton(
                                environment: environment,
                                isSelected: viewModel.selectedEnvironment == environment
                            ) {
                                if viewModel.selectedEnvironment == environment {
                                    viewModel.selectedEnvironment = nil
                                } else {
                                    viewModel.selectedEnvironment = environment
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filters")
            .navigationBarItems(
                leading: Button("Clear All") {
                    viewModel.clearFilters()
                },
                trailing: Button("Done") {
                    viewModel.filterTrees()
                    dismiss()
                }
            )
        }
    }
}

struct CategoryFilterButton: View {
    let category: TreeCategory
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "tree")
                    .foregroundColor(isSelected ? .white : color)
                
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : color)
                
                Spacer()
            }
            .padding()
            .background(isSelected ? color : color.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

struct EnvironmentFilterButton: View {
    let environment: TreeEnvironment
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: getIcon())
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(environment.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .blue)
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.blue : Color.blue.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    private func getIcon() -> String {
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

#Preview {
    TreeCatalogView()
        .environmentObject(TreeCatalogViewModel())
} 