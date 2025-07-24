import Foundation

struct Expense: Identifiable, Codable {
    let id = UUID()
    var description: String
    var amount: Double
    var category: ExpenseCategory
    var date: Date
    var projectId: UUID?
    var projectName: String
    var vendor: String
    var paymentMethod: PaymentMethod
    var receipt: String // Receipt number or reference
    var notes: String
    var isRecurring: Bool
    var recurringInterval: RecurringInterval?
    
    init(description: String, amount: Double, category: ExpenseCategory, date: Date, projectId: UUID? = nil, projectName: String, vendor: String, paymentMethod: PaymentMethod, receipt: String = "", notes: String = "", isRecurring: Bool = false, recurringInterval: RecurringInterval? = nil) {
        self.description = description
        self.amount = amount
        self.category = category
        self.date = date
        self.projectId = projectId
        self.projectName = projectName
        self.vendor = vendor
        self.paymentMethod = paymentMethod
        self.receipt = receipt
        self.notes = notes
        self.isRecurring = isRecurring
        self.recurringInterval = recurringInterval
    }
}

struct Budget: Identifiable, Codable {
    let id = UUID()
    var name: String
    var totalBudget: Double
    var spent: Double
    var category: ExpenseCategory?
    var startDate: Date
    var endDate: Date
    var projectId: UUID?
    var alerts: [BudgetAlert]
    
    var remaining: Double {
        totalBudget - spent
    }
    
    var percentageUsed: Double {
        spent / totalBudget * 100
    }
    
    init(name: String, totalBudget: Double, spent: Double = 0, category: ExpenseCategory? = nil, startDate: Date, endDate: Date, projectId: UUID? = nil, alerts: [BudgetAlert] = []) {
        self.name = name
        self.totalBudget = totalBudget
        self.spent = spent
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.projectId = projectId
        self.alerts = alerts
    }
}

struct BudgetAlert: Identifiable, Codable {
    let id = UUID()
    var threshold: Double // Percentage
    var message: String
    var isTriggered: Bool
    var triggerDate: Date?
    
    init(threshold: Double, message: String, isTriggered: Bool = false, triggerDate: Date? = nil) {
        self.threshold = threshold
        self.message = message
        self.isTriggered = isTriggered
        self.triggerDate = triggerDate
    }
}

enum ExpenseCategory: String, CaseIterable, Codable {
    case trees = "Trees"
    case tools = "Tools"
    case materials = "Materials"
    case labor = "Labor"
    case permits = "Permits"
    case transportation = "Transportation"
    case maintenance = "Maintenance"
    case utilities = "Utilities"
    case other = "Other"
}

enum PaymentMethod: String, CaseIterable, Codable {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case check = "Check"
    case bankTransfer = "Bank Transfer"
    case paypal = "PayPal"
    case other = "Other"
}

enum RecurringInterval: String, CaseIterable, Codable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case annually = "Annually"
} 