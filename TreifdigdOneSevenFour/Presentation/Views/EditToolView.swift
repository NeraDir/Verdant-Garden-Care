import SwiftUI

struct EditToolView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ToolInventoryViewModel
    
    @State private var tool: Tool
    @State private var name: String
    @State private var category: ToolCategory
    @State private var brand: String
    @State private var purchaseDate: Date
    @State private var price: String
    @State private var condition: ToolCondition
    @State private var location: String
    @State private var notes: String
    @State private var isAvailable: Bool
    
    let isNewTool: Bool
    
    init(viewModel: ToolInventoryViewModel, tool: Tool? = nil) {
        self.viewModel = viewModel
        self.isNewTool = tool == nil
        
        let toolToEdit = tool ?? Tool(
            name: "",
            category: .digging,
            brand: "",
            purchaseDate: Date(),
            price: 0.0,
            condition: .excellent,
            location: "",
            notes: ""
        )
        
        self._tool = State(initialValue: toolToEdit)
        self._name = State(initialValue: toolToEdit.name)
        self._category = State(initialValue: toolToEdit.category)
        self._brand = State(initialValue: toolToEdit.brand)
        self._purchaseDate = State(initialValue: toolToEdit.purchaseDate)
        self._price = State(initialValue: String(format: "%.2f", toolToEdit.price))
        self._condition = State(initialValue: toolToEdit.condition)
        self._location = State(initialValue: toolToEdit.location)
        self._notes = State(initialValue: toolToEdit.notes)
        self._isAvailable = State(initialValue: toolToEdit.isAvailable)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tool Information")) {
                    TextField("Tool Name", text: $name)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    Picker("Category", selection: $category) {
                        ForEach(ToolCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    TextField("Brand", text: $brand)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                }
                
                Section(header: Text("Details")) {
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    Picker("Condition", selection: $condition) {
                        ForEach(ToolCondition.allCases, id: \.self) { condition in
                            Text(condition.rawValue).tag(condition)
                        }
                    }
                    
                    TextField("Location", text: $location)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    Toggle("Available", isOn: $isAvailable)
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                }
            }
            .navigationTitle(isNewTool ? "Add Tool" : "Edit Tool")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveTool()
                }
                .disabled(name.isEmpty || brand.isEmpty)
            )
        }
    }
    
    private func saveTool() {
        let priceValue = Double(price) ?? 0.0
        
        let updatedTool = Tool(
            id: tool.id,
            name: name,
            category: category,
            brand: brand,
            purchaseDate: purchaseDate,
            price: priceValue,
            condition: condition,
            location: location,
            notes: notes,
            isAvailable: isAvailable,
            maintenanceSchedule: tool.maintenanceSchedule
        )
        
        if isNewTool {
            viewModel.addTool(updatedTool)
        } else {
            viewModel.updateTool(updatedTool)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    EditToolView(viewModel: ToolInventoryViewModel())
} 