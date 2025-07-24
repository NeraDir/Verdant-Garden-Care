import SwiftUI

struct CostTrackerView: View {
    @EnvironmentObject var viewModel: CostTrackerViewModel
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    summarySection
                    
                    // Budgets Section
                    budgetsSection
                    
                    // Recent Expenses
                    expensesSection
                }
                .padding()
            }
            .navigationTitle("Cost Tracker")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary")
                .font(.headline)
            
            HStack(spacing: 12) {
                SummaryCard(
                    title: "Total Spent",
                    value: String(format: "$%.2f", viewModel.totalSpent),
                    icon: "dollarsign.circle",
                    color: .blue
                )
                
                SummaryCard(
                    title: "This Month",
                    value: String(format: "$%.2f", viewModel.monthlySpent),
                    icon: "calendar",
                    color: Color(red: 0.13, green: 0.55, blue: 0.13)
                )
            }
            
            // Category Breakdown
            CategorySpendingView(categoryTotals: viewModel.getCategorySpending())
        }
    }
    
    private var budgetsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Budgets")
                .font(.headline)
            
            if viewModel.budgets.isEmpty {
                Text("No budgets set")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(viewModel.budgets) { budget in
                    BudgetRowView(budget: budget)
                }
            }
        }
    }
    
    private var expensesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Expenses")
                    .font(.headline)
                
                Spacer()
                
                Button("Add Expense") {
                    showingAddExpense = true
                }
                .font(.subheadline)
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            }
            
            if viewModel.isLoading {
                ProgressView("Loading expenses...")
                    .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            } else if viewModel.expenses.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "dollarsign.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No Expenses Recorded")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("Start tracking your tree planting expenses by adding your first expense")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Button("Add Your First Expense") {
                        showingAddExpense = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.13, green: 0.55, blue: 0.13))
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(viewModel.expenses.sorted { $0.date > $1.date }) { expense in
                    ExpenseRowView(expense: expense)
                }
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            showingAddExpense = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CategorySpendingView: View {
    let categoryTotals: [ExpenseCategory: Double]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Spending by Category")
                .font(.subheadline)
                .fontWeight(.medium)
            
            ForEach(Array(categoryTotals.keys.sorted { $0.rawValue < $1.rawValue }), id: \.self) { category in
                HStack {
                    Text(category.rawValue)
                        .font(.caption)
                    
                    Spacer()
                    
                    Text(String(format: "$%.2f", categoryTotals[category] ?? 0))
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct BudgetRowView: View {
    let budget: Budget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(budget.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(String(format: "$%.2f / $%.2f", budget.spent, budget.totalBudget))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: budget.spent / budget.totalBudget)
                .progressViewStyle(LinearProgressViewStyle(tint: budget.percentageUsed > 90 ? .red : Color(red: 0.13, green: 0.55, blue: 0.13)))
            
            HStack {
                Text(String(format: "%.1f%% used", budget.percentageUsed))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(String(format: "$%.2f remaining", budget.remaining))
                    .font(.caption2)
                    .foregroundColor(budget.remaining > 0 ? Color(red: 0.13, green: 0.55, blue: 0.13) : .red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(getCategoryColor(expense.category).opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: getCategoryIcon(expense.category))
                    .foregroundColor(getCategoryColor(expense.category))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(expense.vendor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(expense.date, format: .dateTime.day().month())
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", expense.amount))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(expense.category.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(getCategoryColor(expense.category).opacity(0.2))
                    .foregroundColor(getCategoryColor(expense.category))
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func getCategoryColor(_ category: ExpenseCategory) -> Color {
        switch category {
        case .trees: return Color(red: 0.13, green: 0.55, blue: 0.13)
        case .tools: return .orange
        case .materials: return .blue
        case .labor: return .purple
        case .permits: return .red
        case .transportation: return .yellow
        case .maintenance: return .pink
        case .utilities: return .cyan
        case .other: return .gray
        }
    }
    
    private func getCategoryIcon(_ category: ExpenseCategory) -> String {
        switch category {
        case .trees: return "tree"
        case .tools: return "wrench"
        case .materials: return "cube.box"
        case .labor: return "person.2"
        case .permits: return "doc.text"
        case .transportation: return "car"
        case .maintenance: return "gearshape"
        case .utilities: return "bolt"
        case .other: return "ellipsis.circle"
        }
    }
}

#Preview {
    CostTrackerView()
        .environmentObject(CostTrackerViewModel())
} 