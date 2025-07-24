import Foundation
import SwiftUI

class CostTrackerViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var budgets: [Budget] = []
    @Published var totalSpent: Double = 0.0
    @Published var monthlySpent: Double = 0.0
    @Published var isLoading: Bool = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        
        // Start with empty expenses list to show empty state
        expenses = []
        
        budgets = [
            Budget(name: "Backyard Project", totalBudget: 500.0, spent: 261.48, startDate: Date().addingTimeInterval(-604800), endDate: Date().addingTimeInterval(604800)),
            Budget(name: "Front Yard", totalBudget: 200.0, spent: 29.99, startDate: Date().addingTimeInterval(-1209600), endDate: Date().addingTimeInterval(302400))
        ]
        
        calculateTotals()
        isLoading = false
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        calculateTotals()
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        calculateTotals()
    }
    
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
    }
    
    private func calculateTotals() {
        totalSpent = expenses.reduce(0) { $0 + $1.amount }
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        monthlySpent = expenses.filter { expense in
            let expenseMonth = calendar.component(.month, from: expense.date)
            let expenseYear = calendar.component(.year, from: expense.date)
            return expenseMonth == currentMonth && expenseYear == currentYear
        }.reduce(0) { $0 + $1.amount }
    }
    
    func getCategorySpending() -> [ExpenseCategory: Double] {
        var categoryTotals: [ExpenseCategory: Double] = [:]
        
        for expense in expenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        
        return categoryTotals
    }
} 