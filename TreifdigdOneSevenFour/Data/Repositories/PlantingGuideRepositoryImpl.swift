import Foundation

class PlantingGuideRepositoryImpl: PlantingGuideRepository {
    private let userDefaults = UserDefaults.standard
    private let guidesKey = "planting_guides"
    
    init() {
        if getAllGuides().isEmpty {
            initializeDefaultGuides()
        }
    }
    
    func getAllGuides() -> [PlantingGuide] {
        guard let data = userDefaults.data(forKey: guidesKey),
              let guides = try? JSONDecoder().decode([PlantingGuide].self, from: data) else {
            return []
        }
        return guides
    }
    
    func getGuide(by id: UUID) -> PlantingGuide? {
        return getAllGuides().first { $0.id == id }
    }
    
    func getGuidesByDifficulty(_ difficulty: Difficulty) -> [PlantingGuide] {
        return getAllGuides().filter { $0.difficulty == difficulty }
    }
    
    func getGuidesByTreeType(_ treeType: String) -> [PlantingGuide] {
        return getAllGuides().filter { $0.treeType.lowercased().contains(treeType.lowercased()) }
    }
    
    func saveGuide(_ guide: PlantingGuide) {
        var guides = getAllGuides()
        if let index = guides.firstIndex(where: { $0.id == guide.id }) {
            guides[index] = guide
        } else {
            guides.append(guide)
        }
        saveGuides(guides)
    }
    
    func updateGuideProgress(_ guide: PlantingGuide) {
        var guides = getAllGuides()
        if let index = guides.firstIndex(where: { $0.id == guide.id }) {
            guides[index] = guide
            saveGuides(guides)
        }
    }
    
    func markStepCompleted(guideId: UUID, stepNumber: Int) {
        var guides = getAllGuides()
        if let guideIndex = guides.firstIndex(where: { $0.id == guideId }),
           let stepIndex = guides[guideIndex].steps.firstIndex(where: { $0.stepNumber == stepNumber }) {
            guides[guideIndex].steps[stepIndex].isCompleted = true
            guides[guideIndex].steps[stepIndex].completedDate = Date()
            saveGuides(guides)
        }
    }
    
    func resetGuideProgress(guideId: UUID) {
        var guides = getAllGuides()
        if let index = guides.firstIndex(where: { $0.id == guideId }) {
            guides[index].userProgress = UserProgress()
            for stepIndex in guides[index].steps.indices {
                guides[index].steps[stepIndex].isCompleted = false
                guides[index].steps[stepIndex].completedDate = nil
                guides[index].steps[stepIndex].notes = ""
            }
            saveGuides(guides)
        }
    }
    
    private func saveGuides(_ guides: [PlantingGuide]) {
        if let data = try? JSONEncoder().encode(guides) {
            userDefaults.set(data, forKey: guidesKey)
        }
    }
    
    private func initializeDefaultGuides() {
        let defaultGuides = [
            PlantingGuide(
                title: "Complete Tree Planting Guide",
                treeType: "General",
                difficulty: .intermediate,
                estimatedTime: "4-6 hours",
                steps: [
                    PlantingStep(stepNumber: 1, title: "Site Selection", description: "Choose the right location for your tree considering mature size, sun requirements, and nearby structures.", iconName: "location", estimatedTime: "30 minutes"),
                    PlantingStep(stepNumber: 2, title: "Soil Preparation", description: "Test soil pH and drainage. Amend soil if necessary with compost or organic matter.", iconName: "leaf", estimatedTime: "45 minutes"),
                    PlantingStep(stepNumber: 3, title: "Dig the Hole", description: "Dig a hole 2-3 times wider than the root ball and same depth as the root ball height.", iconName: "shovel", estimatedTime: "60 minutes"),
                    PlantingStep(stepNumber: 4, title: "Tree Placement", description: "Carefully remove the tree from container and place in hole. Ensure the root flare is at ground level.", iconName: "tree", estimatedTime: "20 minutes"),
                    PlantingStep(stepNumber: 5, title: "Backfill", description: "Fill hole with native soil, gently firm to eliminate air pockets. Water thoroughly.", iconName: "drop", estimatedTime: "30 minutes"),
                    PlantingStep(stepNumber: 6, title: "Mulching", description: "Apply 2-4 inches of organic mulch around base, keeping it away from trunk.", iconName: "circle", estimatedTime: "20 minutes"),
                    PlantingStep(stepNumber: 7, title: "Staking (if needed)", description: "Stake young trees only if necessary. Use soft ties and remove after 1-2 years.", iconName: "arrow.up", estimatedTime: "15 minutes"),
                    PlantingStep(stepNumber: 8, title: "Initial Watering", description: "Water deeply and slowly. Establish a regular watering schedule.", iconName: "drop.fill", estimatedTime: "30 minutes")
                ],
                requiredTools: ["Shovel", "Garden hose", "Measuring tape", "Stakes (if needed)"],
                requiredMaterials: ["Tree", "Mulch", "Compost", "Tree ties"],
                tips: [
                    "Plant during dormant season for best results",
                    "Never plant too deep - root flare should be visible",
                    "Water regularly first year until established",
                    "Avoid fertilizing newly planted trees"
                ]
            ),
            PlantingGuide(
                title: "Container Tree Planting",
                treeType: "Container",
                difficulty: .beginner,
                estimatedTime: "2-3 hours",
                steps: [
                    PlantingStep(stepNumber: 1, title: "Choose Location", description: "Select appropriate site based on tree's mature size and requirements.", iconName: "location", estimatedTime: "15 minutes"),
                    PlantingStep(stepNumber: 2, title: "Prepare Hole", description: "Dig hole twice as wide as container and same depth.", iconName: "shovel", estimatedTime: "45 minutes"),
                    PlantingStep(stepNumber: 3, title: "Remove Container", description: "Carefully remove tree from container, loosening circled roots.", iconName: "scissors", estimatedTime: "10 minutes"),
                    PlantingStep(stepNumber: 4, title: "Plant Tree", description: "Place tree in hole and backfill with native soil.", iconName: "tree", estimatedTime: "20 minutes"),
                    PlantingStep(stepNumber: 5, title: "Water & Mulch", description: "Water thoroughly and apply mulch around base.", iconName: "drop", estimatedTime: "30 minutes")
                ],
                requiredTools: ["Shovel", "Pruning shears", "Garden hose"],
                requiredMaterials: ["Container tree", "Mulch"],
                tips: [
                    "Container trees can be planted any time during growing season",
                    "Check for root circling and correct before planting",
                    "Keep soil consistently moist but not waterlogged"
                ]
            ),
            PlantingGuide(
                title: "Bare Root Tree Planting",
                treeType: "Bare Root",
                difficulty: .advanced,
                estimatedTime: "3-4 hours",
                steps: [
                    PlantingStep(stepNumber: 1, title: "Timing", description: "Plant during dormant season (late fall to early spring).", iconName: "calendar", estimatedTime: "5 minutes"),
                    PlantingStep(stepNumber: 2, title: "Root Inspection", description: "Examine roots and prune any damaged or broken ones.", iconName: "scissors", estimatedTime: "15 minutes"),
                    PlantingStep(stepNumber: 3, title: "Soil Preparation", description: "Prepare planting site and dig appropriate hole.", iconName: "leaf", estimatedTime: "60 minutes"),
                    PlantingStep(stepNumber: 4, title: "Root Positioning", description: "Spread roots naturally in hole, avoiding bending or circling.", iconName: "tree", estimatedTime: "20 minutes"),
                    PlantingStep(stepNumber: 5, title: "Backfill Carefully", description: "Fill hole gradually, ensuring good root-to-soil contact.", iconName: "shovel", estimatedTime: "30 minutes"),
                    PlantingStep(stepNumber: 6, title: "Water Thoroughly", description: "Water deeply to settle soil and eliminate air pockets.", iconName: "drop", estimatedTime: "20 minutes")
                ],
                requiredTools: ["Shovel", "Pruning shears", "Garden hose"],
                requiredMaterials: ["Bare root tree", "Mulch"],
                tips: [
                    "Keep roots moist until planting",
                    "Plant immediately after purchase",
                    "Root flare should be at or slightly above ground level"
                ]
            )
        ]
        
        for guide in defaultGuides {
            saveGuide(guide)
        }
    }
} 