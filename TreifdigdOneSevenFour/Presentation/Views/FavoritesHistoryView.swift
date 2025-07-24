import SwiftUI

struct FavoritesHistoryView: View {
    @EnvironmentObject var viewModel: FavoritesHistoryViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom Tab Picker
                Picker("Section", selection: $selectedTab) {
                    Text("Favorites").tag(0)
                    Text("History").tag(1)
                    Text("Achievements").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    favoritesView.tag(0)
                    historyView.tag(1)
                    achievementsView.tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Favorites & History")
            .onAppear {
                viewModel.refreshFavorites()
            }
        }
    }
    
    private var favoritesView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Stats
                statsSection
                
                // Favorite Trees
                favoriteTreesSection
            }
            .padding()
        }
    }
    
    private var historyView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Planting History
                plantingHistorySection
                
                // Search History
                searchHistorySection
            }
            .padding()
        }
    }
    
    private var achievementsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Unlocked Achievements
                unlockedAchievementsSection
                
                // In Progress Achievements
                inProgressAchievementsSection
            }
            .padding()
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Stats")
                .font(.headline)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Favorites",
                    value: "\(viewModel.favoriteTrees.count)",
                    icon: "heart.fill",
                    color: .red
                )
                
                StatCard(
                    title: "Trees Planted",
                    value: "\(viewModel.getTotalTreesPlanted())",
                    icon: "tree",
                    color: Color(red: 0.13, green: 0.55, blue: 0.13)
                )
                
                StatCard(
                    title: "Success Rate",
                    value: String(format: "%.0f%%", viewModel.getSuccessRate() * 100),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
            }
        }
    }
    
    private var favoriteTreesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Favorite Trees")
                .font(.headline)
            
            if viewModel.isLoading {
                ProgressView("Loading favorites...")
                    .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            } else if viewModel.favoriteTrees.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No favorite trees yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Explore the tree catalog and mark trees as favorites!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                ForEach(viewModel.favoriteTrees) { tree in
                    FavoriteTreeRowView(tree: tree)
                }
            }
        }
    }
    
    private var plantingHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Planting History")
                .font(.headline)
            
            if viewModel.plantingHistory.isEmpty {
                Text("No planting records yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(viewModel.plantingHistory) { record in
                    PlantingRecordRowView(record: record)
                }
            }
        }
    }
    
    private var searchHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Searches")
                .font(.headline)
            
            if viewModel.searchHistory.isEmpty {
                Text("No search history")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(viewModel.getRecentSearches()) { search in
                    SearchRecordRowView(search: search)
                }
            }
        }
    }
    
    private var unlockedAchievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Unlocked Achievements")
                .font(.headline)
            
            let unlockedAchievements = viewModel.getUnlockedAchievements()
            
            if unlockedAchievements.isEmpty {
                Text("No achievements unlocked yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(unlockedAchievements) { achievement in
                    AchievementRowView(achievement: achievement)
                }
            }
        }
    }
    
    private var inProgressAchievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In Progress")
                .font(.headline)
            
            let inProgressAchievements = viewModel.getInProgressAchievements()
            
            if inProgressAchievements.isEmpty {
                Text("No achievements in progress")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(inProgressAchievements) { achievement in
                    AchievementRowView(achievement: achievement)
                }
            }
        }
    }
}

struct FavoriteTreeRowView: View {
    let tree: Tree
    
    var body: some View {
        HStack(spacing: 12) {
            // Tree Icon
            ZStack {
                Circle()
                    .fill(getCategoryColor(tree.category).opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "tree")
                    .foregroundColor(getCategoryColor(tree.category))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tree.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(tree.scientificName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func getCategoryColor(_ category: TreeCategory) -> Color {
        switch category {
        case .deciduous: return .orange
        case .evergreen: return Color(red: 0.13, green: 0.55, blue: 0.13)
        case .fruit: return .red
        case .flowering: return .pink
        case .nut: return .brown
        case .ornamental: return .purple
        }
    }
}

struct PlantingRecordRowView: View {
    let record: PlantingRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(record.treeName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(record.plantingDate, format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text(record.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Success:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "%.0f%%", record.successRate * 100))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(record.successRate >= 0.8 ? .green : record.successRate >= 0.5 ? .orange : .red)
                }
            }
            
            if !record.notes.isEmpty {
                Text(record.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct SearchRecordRowView: View {
    let search: SearchRecord
    
    var body: some View {
        HStack {
            Image(systemName: getSearchIcon(search.searchType))
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(search.query)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(search.resultCount) results • \(search.searchType.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(search.timestamp, format: .dateTime.day().month())
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func getSearchIcon(_ type: SearchType) -> String {
        switch type {
        case .trees: return "tree"
        case .guides: return "book"
        case .tools: return "wrench"
        case .advice: return "brain.head.profile"
        case .materials: return "cube.box"
        }
    }
}

struct AchievementRowView: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 12) {
            // Achievement Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color(red: 0.13, green: 0.55, blue: 0.13).opacity(0.2) : Color(.systemGray5))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.iconName)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? Color(red: 0.13, green: 0.55, blue: 0.13) : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.13, green: 0.55, blue: 0.13)))
                        .frame(height: 4)
                    
                    Text(String(format: "%.0f%% complete", achievement.progress * 100))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    FavoritesHistoryView()
        .environmentObject(FavoritesHistoryViewModel())
} 