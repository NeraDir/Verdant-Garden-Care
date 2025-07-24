import Foundation

class TreeRepositoryImpl: TreeRepository {
    private let userDefaults = UserDefaults.standard
    private let treesKey = "saved_trees"
    
    init() {
        // Initialize with default trees if empty
        if getAllTrees().isEmpty {
            initializeDefaultTrees()
        }
    }
    
    func getAllTrees() -> [Tree] {
        guard let data = userDefaults.data(forKey: treesKey),
              let trees = try? JSONDecoder().decode([Tree].self, from: data) else {
            return []
        }
        return trees
    }
    
    func getTree(by id: UUID) -> Tree? {
        return getAllTrees().first { $0.id == id }
    }
    
    func getFavoriteTrees() -> [Tree] {
        return [] // Возвращаем пустой список, так как убрали функциональность избранного
    }
    
    func addTree(_ tree: Tree) {
        var trees = getAllTrees()
        trees.append(tree)
        saveTrees(trees)
    }
    
    func updateTree(_ tree: Tree) {
        var trees = getAllTrees()
        if let index = trees.firstIndex(where: { $0.id == tree.id }) {
            trees[index] = tree
            saveTrees(trees)
        }
    }
    
    func deleteTree(by id: UUID) {
        var trees = getAllTrees()
        trees.removeAll { $0.id == id }
        saveTrees(trees)
    }
    
    func searchTrees(query: String, category: TreeCategory?, environment: TreeEnvironment?) -> [Tree] {
        let allTrees = getAllTrees()
        let lowercaseQuery = query.lowercased()
        
        return allTrees.filter { tree in
            let matchesQuery = query.isEmpty ||
                tree.name.lowercased().contains(lowercaseQuery) ||
                tree.scientificName.lowercased().contains(lowercaseQuery) ||
                tree.description.lowercased().contains(lowercaseQuery)
            
            let matchesCategory = category == nil || tree.category == category
            let matchesEnvironment = environment == nil || tree.environment == environment
            
            return matchesQuery && matchesCategory && matchesEnvironment
        }
    }
    
    func toggleFavorite(treeId: UUID) -> Bool {
        // Возвращаем false, так как убрали функциональность избранного
        return false
    }
    
    private func saveTrees(_ trees: [Tree]) {
        if let data = try? JSONEncoder().encode(trees) {
            userDefaults.set(data, forKey: treesKey)
        }
    }
    
    private func initializeDefaultTrees() {
        let defaultTrees = [
            Tree(
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
                description: "A large deciduous tree known for its beautiful fall foliage and strong wood. Perfect for shade and wildlife habitat.",
                careTips: [
                    "Water regularly during first year",
                    "Mulch around base to retain moisture",
                    "Prune in late winter when dormant",
                    "Watch for oak wilt disease"
                ]
            ),
            Tree(
                name: "Eastern White Pine",
                scientificName: "Pinus strobus",
                category: .evergreen,
                environment: .rural,
                purpose: .windbreak,
                growthRate: .fast,
                matureHeight: "50-80 feet",
                spacing: "20-30 feet",
                soilType: [.sandy, .loamy],
                sunRequirement: .fullSun,
                waterNeeds: .low,
                plantingMonths: [4, 5, 9, 10],
                description: "A fast-growing evergreen with soft, blue-green needles. Excellent for windbreaks and privacy screens.",
                careTips: [
                    "Drought tolerant once established",
                    "Avoid wet, poorly drained soils",
                    "Prune lightly to maintain shape",
                    "Watch for white pine weevil"
                ]
            ),
            Tree(
                name: "Japanese Maple",
                scientificName: "Acer palmatum",
                category: .ornamental,
                environment: .urban,
                purpose: .beauty,
                growthRate: .slow,
                matureHeight: "15-25 feet",
                spacing: "15-20 feet",
                soilType: [.loamy, .acidic],
                sunRequirement: .partialShade,
                waterNeeds: .moderate,
                plantingMonths: [3, 4, 5, 10, 11],
                description: "A stunning ornamental tree with delicate leaves and incredible fall color. Perfect for small spaces and gardens.",
                careTips: [
                    "Protect from strong winds",
                    "Provide afternoon shade in hot climates",
                    "Keep soil consistently moist",
                    "Minimal pruning required"
                ]
            ),
            Tree(
                name: "Apple Tree",
                scientificName: "Malus domestica",
                category: .fruit,
                environment: .suburban,
                purpose: .food,
                growthRate: .moderate,
                matureHeight: "20-30 feet",
                spacing: "15-25 feet",
                soilType: [.loamy],
                sunRequirement: .fullSun,
                waterNeeds: .moderate,
                plantingMonths: [3, 4, 5, 10, 11],
                description: "A productive fruit tree that provides delicious apples and beautiful spring blossoms.",
                careTips: [
                    "Requires cross-pollination for fruit",
                    "Prune annually for best fruit production",
                    "Monitor for common pests and diseases",
                    "Thin fruit for larger, better quality apples"
                ]
            ),
            Tree(
                name: "Live Oak",
                scientificName: "Quercus virginiana",
                category: .evergreen,
                environment: .coastal,
                purpose: .shade,
                growthRate: .moderate,
                matureHeight: "40-80 feet",
                spacing: "50-80 feet",
                soilType: [.sandy, .loamy],
                sunRequirement: .fullSun,
                waterNeeds: .low,
                plantingMonths: [3, 4, 5, 10, 11],
                description: "An iconic Southern tree with a broad, spreading crown. Extremely long-lived and hurricane resistant.",
                careTips: [
                    "Very drought tolerant once established",
                    "Avoid soil compaction around roots",
                    "Minimal pruning needed",
                    "Provides excellent wildlife habitat"
                ]
            )
        ]
        
        for tree in defaultTrees {
            addTree(tree)
        }
    }
} 