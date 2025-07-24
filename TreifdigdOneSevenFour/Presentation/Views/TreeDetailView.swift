import SwiftUI

struct TreeDetailView: View {
    let tree: Tree
    @ObservedObject var viewModel: TreeCatalogViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var currentTree: Tree {
        // Find the current version of the tree in ViewModel 
        return viewModel.trees.first(where: { $0.id == tree.id }) ?? tree
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    treeHeader
                    
                    // Detailed Description Section
                    detailedDescriptionSection
                    
                    // Basic Info Cards
                    basicInfoSection
                    
                    // Growing Conditions
                    growingConditionsSection
                    
                    // Care Tips
                    careTipsSection
                    
                    // Planting Information
                    plantingInfoSection
                    
                    // Additional Benefits Section
                    benefitsSection
                }
                .padding()
            }
            .navigationTitle(currentTree.name)
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                }
            )
        }
    }
    
    private var treeHeader: some View {
        VStack(spacing: 16) {
            // Tree Icon
            ZStack {
                Circle()
                    .fill(viewModel.getCategoryColor(currentTree.category).opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "tree")
                    .font(.system(size: 50))
                    .foregroundColor(viewModel.getCategoryColor(currentTree.category))
            }
            
            VStack(spacing: 8) {
                Text(currentTree.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(currentTree.scientificName)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .italic()
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 12) {
                    CategoryBadge(category: currentTree.category, color: viewModel.getCategoryColor(currentTree.category))
                    EnvironmentBadge(environment: currentTree.environment)
                }
            }
            
            Text(currentTree.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var detailedDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "About This Tree", icon: "text.alignleft")
            
            VStack(alignment: .leading, spacing: 12) {
                Text("This \(currentTree.category.rawValue.lowercased()) tree is perfectly suited for \(currentTree.environment.rawValue.lowercased()) environments and serves as an excellent choice for \(currentTree.purpose.rawValue.lowercased()) purposes.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Growth Characteristics:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "Reaches mature height of \(currentTree.matureHeight)")
                    BulletPoint(text: "Requires \(currentTree.spacing) spacing between trees")
                    BulletPoint(text: "\(currentTree.growthRate.rawValue) growth rate")
                    BulletPoint(text: "Thrives in \(currentTree.sunRequirement.rawValue.lowercased()) conditions")
                    BulletPoint(text: "Water needs: \(currentTree.waterNeeds.rawValue.lowercased())")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Benefits & Features", icon: "star.circle")
            
            VStack(alignment: .leading, spacing: 8) {
                BenefitRow(icon: "leaf", title: "Environmental Impact", description: "Provides oxygen, filters air, and supports local wildlife")
                BenefitRow(icon: "thermometer.sun", title: "Climate Benefits", description: "Natural cooling through shade and transpiration")
                BenefitRow(icon: "house", title: "Property Value", description: "Increases property value and curb appeal")
                BenefitRow(icon: "heart", title: "Health Benefits", description: "Reduces stress and improves air quality")
            }
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Basic Information", icon: "info.circle")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                InfoCard(title: "Mature Height", value: currentTree.matureHeight, icon: "ruler")
                InfoCard(title: "Spacing", value: currentTree.spacing, icon: "arrow.left.and.right")
                InfoCard(title: "Growth Rate", value: currentTree.growthRate.rawValue, icon: "speedometer")
                InfoCard(title: "Purpose", value: currentTree.purpose.rawValue, icon: "target")
            }
        }
    }
    
    private var growingConditionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Growing Conditions", icon: "leaf")
            
            VStack(spacing: 12) {
                ConditionRow(
                    title: "Sun Requirement",
                    value: currentTree.sunRequirement.rawValue,
                    icon: "sun.max",
                    color: .yellow
                )
                
                ConditionRow(
                    title: "Water Needs",
                    value: currentTree.waterNeeds.rawValue,
                    icon: "drop",
                    color: .blue
                )
                
                ConditionRow(
                    title: "Soil Types",
                    value: currentTree.soilType.map { $0.rawValue }.joined(separator: ", "),
                    icon: "square.stack.3d.down.right",
                    color: .brown
                )
            }
        }
    }
    
    private var plantingInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Planting Information", icon: "calendar")
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Best Planting Months")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                PlantingMonthsView(months: currentTree.plantingMonths)
            }
        }
    }
    
    private var careTipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Care Tips", icon: "heart")
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(currentTree.careTips.enumerated()), id: \.offset) { index, tip in
                    CareTipRow(tip: tip, index: index + 1)
                }
            }
        }
    }
    

}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                .fontWeight(.bold)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}



struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ConditionRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct PlantingMonthsView: View {
    let months: [Int]
    
    private let monthNames = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var body: some View {
        HStack {
            ForEach(1...12, id: \.self) { month in
                VStack(spacing: 4) {
                    Text(monthNames[month])
                        .font(.caption2)
                        .foregroundColor(months.contains(month) ? .white : .secondary)
                    
                    Circle()
                        .fill(months.contains(month) ? Color(red: 0.13, green: 0.55, blue: 0.13) : Color(.systemGray5))
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CareTipRow: View {
    let tip: String
    let index: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color(red: 0.13, green: 0.55, blue: 0.13))
                .clipShape(Circle())
            
            Text(tip)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    TreeDetailView(
        tree: Tree(
            name: "Red Oak",
            scientificName: "Quercus rubra",
            category: .deciduous,
            environment: .suburban,
            purpose: .shade,
            growthRate: .moderate,
            matureHeight: "60-75 feet",
            spacing: "40-50 feet",
            soilType: [.loamy, .acidic],
            sunRequirement: .fullSun,
            waterNeeds: .moderate,
            plantingMonths: [3, 4, 5, 9, 10],
            description: "A large deciduous tree known for its beautiful fall foliage and strong wood.",
            careTips: ["Water regularly", "Mulch around base", "Prune in winter"]
        ),
        viewModel: TreeCatalogViewModel()
    )
} 