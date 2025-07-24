import Foundation

struct Tool: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: ToolCategory
    var brand: String
    var purchaseDate: Date
    var price: Double
    var condition: ToolCondition
    var location: String
    var notes: String
    var isAvailable: Bool
    var maintenanceSchedule: [MaintenanceRecord]
    
    init(id: UUID = UUID(), name: String, category: ToolCategory, brand: String, purchaseDate: Date, price: Double, condition: ToolCondition, location: String, notes: String, isAvailable: Bool = true, maintenanceSchedule: [MaintenanceRecord] = []) {
        self.id = id
        self.name = name
        self.category = category
        self.brand = brand
        self.purchaseDate = purchaseDate
        self.price = price
        self.condition = condition
        self.location = location
        self.notes = notes
        self.isAvailable = isAvailable
        self.maintenanceSchedule = maintenanceSchedule
    }
}

enum ToolCategory: String, CaseIterable, Codable {
    case digging = "Digging"
    case cutting = "Cutting"
    case watering = "Watering"
    case measuring = "Measuring"
    case protection = "Protection"
    case maintenance = "Maintenance"
    case planting = "Planting"
}

enum ToolCondition: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case needsRepair = "Needs Repair"
}

struct MaintenanceRecord: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var type: MaintenanceType
    var description: String
    var cost: Double
    
    init(date: Date, type: MaintenanceType, description: String, cost: Double) {
        self.date = date
        self.type = type
        self.description = description
        self.cost = cost
    }
}

enum MaintenanceType: String, CaseIterable, Codable {
    case cleaning = "Cleaning"
    case sharpening = "Sharpening"
    case repair = "Repair"
    case replacement = "Replacement"
    case oiling = "Oiling"
} 