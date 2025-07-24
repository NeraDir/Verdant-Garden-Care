import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CostTrackerViewModel
    
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var category: ExpenseCategory = .other
    @State private var date: Date = Date()
    @State private var projectName: String = ""
    @State private var vendor: String = ""
    @State private var paymentMethod: PaymentMethod = .cash
    @State private var receipt: String = ""
    @State private var notes: String = ""
    @State private var isRecurring: Bool = false
    @State private var recurringInterval: RecurringInterval? = nil
    
    @FocusState private var isDescriptionFocused: Bool
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isProjectNameFocused: Bool
    @FocusState private var isVendorFocused: Bool
    @FocusState private var isReceiptFocused: Bool
    @FocusState private var isNotesFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Description", text: $description)
                        .focused($isDescriptionFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    HStack {
                        Text("$")
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .focused($isAmountFocused)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        hideKeyboard()
                                    }
                                }
                            }
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: getCategoryIcon(category))
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Project & Vendor")) {
                    TextField("Project Name", text: $projectName)
                        .focused($isProjectNameFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    TextField("Vendor", text: $vendor)
                        .focused($isVendorFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    Picker("Payment Method", selection: $paymentMethod) {
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                }
                
                Section(header: Text("Additional Information")) {
                    TextField("Receipt #", text: $receipt)
                        .focused($isReceiptFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                        .focused($isNotesFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                }
                
                Section(header: Text("Recurring")) {
                    Toggle("Recurring Expense", isOn: $isRecurring)
                    
                    if isRecurring {
                        Picker("Interval", selection: Binding<RecurringInterval>(
                            get: { recurringInterval ?? .monthly },
                            set: { recurringInterval = $0 }
                        )) {
                            ForEach(RecurringInterval.allCases, id: \.self) { interval in
                                Text(interval.rawValue).tag(interval)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveExpense()
                }
                .disabled(description.isEmpty || amount.isEmpty || projectName.isEmpty)
            )
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        
        let newExpense = Expense(
            description: description,
            amount: amountValue,
            category: category,
            date: date,
            projectName: projectName,
            vendor: vendor,
            paymentMethod: paymentMethod,
            receipt: receipt,
            notes: notes,
            isRecurring: isRecurring,
            recurringInterval: isRecurring ? recurringInterval : nil
        )
        
        viewModel.addExpense(newExpense)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func hideKeyboard() {
        isDescriptionFocused = false
        isAmountFocused = false
        isProjectNameFocused = false
        isVendorFocused = false
        isReceiptFocused = false
        isNotesFocused = false
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
    AddExpenseView(viewModel: CostTrackerViewModel())
} 