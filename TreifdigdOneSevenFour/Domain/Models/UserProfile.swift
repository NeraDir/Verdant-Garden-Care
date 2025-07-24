import Foundation

struct UserProfile: Codable {
    var name: String
    var experience: GardeningExperience
    var location: String
    var climate: ClimateZone
    var preferences: UserPreferences
    var achievements: [Achievement]
    var statistics: UserStatistics
    var favoriteTreeIds: [UUID]
    var plantingHistory: [PlantingRecord]
    var searchHistory: [SearchRecord]
    var lastActiveDate: Date
    
    init(name: String = "", experience: GardeningExperience = .beginner, location: String = "", climate: ClimateZone = .temperate, preferences: UserPreferences = UserPreferences(), achievements: [Achievement] = [], statistics: UserStatistics = UserStatistics(), favoriteTreeIds: [UUID] = [], plantingHistory: [PlantingRecord] = [], searchHistory: [SearchRecord] = [], lastActiveDate: Date = Date()) {
        self.name = name
        self.experience = experience
        self.location = location
        self.climate = climate
        self.preferences = preferences
        self.achievements = achievements
        self.statistics = statistics
        self.favoriteTreeIds = favoriteTreeIds
        self.plantingHistory = plantingHistory
        self.searchHistory = searchHistory
        self.lastActiveDate = lastActiveDate
    }
}

struct UserPreferences: Codable {
    var preferredTreeCategories: [TreeCategory]
    var notificationSettings: NotificationSettings
    var measurementUnit: MeasurementUnit
    var defaultCurrency: String
    var autoSaveProgress: Bool
    var showBeginnertips: Bool
    
    init(preferredTreeCategories: [TreeCategory] = [], notificationSettings: NotificationSettings = NotificationSettings(), measurementUnit: MeasurementUnit = .imperial, defaultCurrency: String = "USD", autoSaveProgress: Bool = true, showBeginnertips: Bool = true) {
        self.preferredTreeCategories = preferredTreeCategories
        self.notificationSettings = notificationSettings
        self.measurementUnit = measurementUnit
        self.defaultCurrency = defaultCurrency
        self.autoSaveProgress = autoSaveProgress
        self.showBeginnertips = showBeginnertips
    }
}

struct NotificationSettings: Codable {
    var taskReminders: Bool
    var seasonalTips: Bool
    var maintenanceAlerts: Bool
    var budgetAlerts: Bool
    var achievementNotifications: Bool
    
    init(taskReminders: Bool = true, seasonalTips: Bool = true, maintenanceAlerts: Bool = true, budgetAlerts: Bool = true, achievementNotifications: Bool = true) {
        self.taskReminders = taskReminders
        self.seasonalTips = seasonalTips
        self.maintenanceAlerts = maintenanceAlerts
        self.budgetAlerts = budgetAlerts
        self.achievementNotifications = achievementNotifications
    }
}

struct Achievement: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var iconName: String
    var unlockedDate: Date?
    var isUnlocked: Bool
    var progress: Double // 0.0 to 1.0
    var requirement: String
    
    init(title: String, description: String, iconName: String, unlockedDate: Date? = nil, isUnlocked: Bool = false, progress: Double = 0.0, requirement: String) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.unlockedDate = unlockedDate
        self.isUnlocked = isUnlocked
        self.progress = progress
        self.requirement = requirement
    }
}

struct UserStatistics: Codable {
    var treesPlanted: Int
    var guidesCompleted: Int
    var totalTimeSpent: TimeInterval
    var adviceQuestionsAsked: Int
    var projectsCompleted: Int
    var totalMoneySpent: Double
    var favoriteTreesCount: Int
    var longestStreak: Int
    var currentStreak: Int
    var lastActivityDate: Date?
    
    init(treesPlanted: Int = 0, guidesCompleted: Int = 0, totalTimeSpent: TimeInterval = 0, adviceQuestionsAsked: Int = 0, projectsCompleted: Int = 0, totalMoneySpent: Double = 0, favoriteTreesCount: Int = 0, longestStreak: Int = 0, currentStreak: Int = 0, lastActivityDate: Date? = nil) {
        self.treesPlanted = treesPlanted
        self.guidesCompleted = guidesCompleted
        self.totalTimeSpent = totalTimeSpent
        self.adviceQuestionsAsked = adviceQuestionsAsked
        self.projectsCompleted = projectsCompleted
        self.totalMoneySpent = totalMoneySpent
        self.favoriteTreesCount = favoriteTreesCount
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
        self.lastActivityDate = lastActivityDate
    }
}

struct PlantingRecord: Identifiable, Codable {
    let id = UUID()
    var treeId: UUID
    var treeName: String
    var plantingDate: Date
    var location: String
    var successRate: Double // 0.0 to 1.0
    var notes: String
    var photos: [String] // Photo references
    var milestones: [GrowthMilestone]
    
    init(treeId: UUID, treeName: String, plantingDate: Date, location: String, successRate: Double = 1.0, notes: String = "", photos: [String] = [], milestones: [GrowthMilestone] = []) {
        self.treeId = treeId
        self.treeName = treeName
        self.plantingDate = plantingDate
        self.location = location
        self.successRate = successRate
        self.notes = notes
        self.photos = photos
        self.milestones = milestones
    }
}

struct GrowthMilestone: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var height: Double
    var health: HealthStatus
    var notes: String
    var photos: [String]
    
    init(date: Date, height: Double, health: HealthStatus, notes: String = "", photos: [String] = []) {
        self.date = date
        self.height = height
        self.health = health
        self.notes = notes
        self.photos = photos
    }
}

struct SearchRecord: Identifiable, Codable {
    let id = UUID()
    var query: String
    var searchType: SearchType
    var resultCount: Int
    var timestamp: Date
    
    init(query: String, searchType: SearchType, resultCount: Int, timestamp: Date = Date()) {
        self.query = query
        self.searchType = searchType
        self.resultCount = resultCount
        self.timestamp = timestamp
    }
}

enum GardeningExperience: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
}

enum ClimateZone: String, CaseIterable, Codable {
    case tropical = "Tropical"
    case subtropical = "Subtropical"
    case temperate = "Temperate"
    case continental = "Continental"
    case polar = "Polar"
    case arid = "Arid"
    case mediterranean = "Mediterranean"
}

enum MeasurementUnit: String, CaseIterable, Codable {
    case metric = "Metric"
    case imperial = "Imperial"
}

enum HealthStatus: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case critical = "Critical"
}

enum SearchType: String, CaseIterable, Codable {
    case trees = "Trees"
    case guides = "Guides"
    case tools = "Tools"
    case advice = "Advice"
    case materials = "Materials"
} 