import Foundation

struct Tree: Identifiable, Codable {
    let id = UUID()
    var name: String
    var scientificName: String
    var category: TreeCategory
    var environment: TreeEnvironment
    var purpose: Purpose
    var growthRate: GrowthRate
    var matureHeight: String
    var spacing: String
    var soilType: [SoilType]
    var sunRequirement: SunRequirement
    var waterNeeds: WaterNeeds
    var plantingMonths: [Int] // Months 1-12
    var description: String
    var careTips: [String]
    
    init(name: String, scientificName: String, category: TreeCategory, environment: TreeEnvironment, purpose: Purpose, growthRate: GrowthRate, matureHeight: String, spacing: String, soilType: [SoilType], sunRequirement: SunRequirement, waterNeeds: WaterNeeds, plantingMonths: [Int], description: String, careTips: [String]) {
        self.name = name
        self.scientificName = scientificName
        self.category = category
        self.environment = environment
        self.purpose = purpose
        self.growthRate = growthRate
        self.matureHeight = matureHeight
        self.spacing = spacing
        self.soilType = soilType
        self.sunRequirement = sunRequirement
        self.waterNeeds = waterNeeds
        self.plantingMonths = plantingMonths
        self.description = description
        self.careTips = careTips
    }
}

enum TreeCategory: String, CaseIterable, Codable {
    case deciduous = "Deciduous"
    case evergreen = "Evergreen"
    case fruit = "Fruit"
    case flowering = "Flowering"
    case nut = "Nut"
    case ornamental = "Ornamental"
}

enum TreeEnvironment: String, CaseIterable, Codable {
    case urban = "Urban"
    case suburban = "Suburban"
    case rural = "Rural"
    case coastal = "Coastal"
    case mountain = "Mountain"
    case desert = "Desert"
}

enum Purpose: String, CaseIterable, Codable {
    case shade = "Shade"
    case privacy = "Privacy"
    case windbreak = "Windbreak"
    case wildlife = "Wildlife"
    case food = "Food"
    case beauty = "Beauty"
    case erosionControl = "Erosion Control"
}

enum GrowthRate: String, CaseIterable, Codable {
    case slow = "Slow"
    case moderate = "Moderate"
    case fast = "Fast"
}

enum SoilType: String, CaseIterable, Codable {
    case clay = "Clay"
    case sandy = "Sandy"
    case loamy = "Loamy"
    case rocky = "Rocky"
    case acidic = "Acidic"
    case alkaline = "Alkaline"
}

enum SunRequirement: String, CaseIterable, Codable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case partialShade = "Partial Shade"
    case fullShade = "Full Shade"
}

enum WaterNeeds: String, CaseIterable, Codable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
} 