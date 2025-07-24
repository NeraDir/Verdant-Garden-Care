import Foundation

struct Material: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: MaterialCategory
    var unit: MaterialUnit
    var pricePerUnit: Double
    var supplier: String
    var description: String
    var inStock: Double
    var minimumRequired: Double
    
    init(name: String, category: MaterialCategory, unit: MaterialUnit, pricePerUnit: Double, supplier: String, description: String, inStock: Double, minimumRequired: Double) {
        self.name = name
        self.category = category
        self.unit = unit
        self.pricePerUnit = pricePerUnit
        self.supplier = supplier
        self.description = description
        self.inStock = inStock
        self.minimumRequired = minimumRequired
    }
}

struct MaterialCalculation: Identifiable, Codable {
    let id = UUID()
    var projectName: String
    var treeCount: Int
    var spacing: Double
    var area: Double
    var calculatedMaterials: [CalculatedMaterial]
    var totalCost: Double
    var calculationDate: Date
    var notes: String
    
    init(projectName: String, treeCount: Int, spacing: Double, area: Double, calculatedMaterials: [CalculatedMaterial], totalCost: Double, calculationDate: Date, notes: String = "") {
        self.projectName = projectName
        self.treeCount = treeCount
        self.spacing = spacing
        self.area = area
        self.calculatedMaterials = calculatedMaterials
        self.totalCost = totalCost
        self.calculationDate = calculationDate
        self.notes = notes
    }
}

struct CalculatedMaterial: Identifiable, Codable {
    let id = UUID()
    var materialId: UUID
    var materialName: String
    var quantityNeeded: Double
    var cost: Double
    var unit: MaterialUnit
    
    init(materialId: UUID, materialName: String, quantityNeeded: Double, cost: Double, unit: MaterialUnit) {
        self.materialId = materialId
        self.materialName = materialName
        self.quantityNeeded = quantityNeeded
        self.cost = cost
        self.unit = unit
    }
}

enum MaterialCategory: String, CaseIterable, Codable {
    case soil = "Soil"
    case mulch = "Mulch"
    case fertilizer = "Fertilizer"
    case stakes = "Stakes"
    case ties = "Ties"
    case guards = "Guards"
    case irrigation = "Irrigation"
    case amendments = "Amendments"
}

enum MaterialUnit: String, CaseIterable, Codable {
    case bags = "Bags"
    case cubicYards = "Cubic Yards"
    case pounds = "Pounds"
    case pieces = "Pieces"
    case feet = "Feet"
    case gallons = "Gallons"
    case liters = "Liters"
    case squareFeet = "Square Feet"
} 