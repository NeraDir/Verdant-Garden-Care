import SwiftUI

struct MaterialCalculatorView: View {
    @EnvironmentObject var viewModel: MaterialCalculatorViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Input Section
                    inputSection
                    
                    // Calculate Button
                    calculateButton
                    
                    // Results Section
                    if !viewModel.calculations.isEmpty {
                        resultsSection
                    }
                }
                .padding()
            }
            .navigationTitle("Material Calculator")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isTextFieldFocused = false
                    }
                }
            }
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Project Details")
                .font(.headline)
            
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Project Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter project name", text: $viewModel.projectName)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Number of Trees")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        TextField("1", text: $viewModel.treeCount)
                            .focused($isTextFieldFocused)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Spacing (feet)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        TextField("20", text: $viewModel.spacing)
                            .focused($isTextFieldFocused)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Area (sq ft)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("100", text: $viewModel.area)
                        .focused($isTextFieldFocused)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var calculateButton: some View {
        Button(action: {
            viewModel.calculateMaterials()
        }) {
            HStack {
                if viewModel.isCalculating {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Calculating...")
                } else {
                    Image(systemName: "function")
                    Text("Calculate Materials")
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.13, green: 0.55, blue: 0.13))
            .cornerRadius(10)
        }
        .disabled(viewModel.isCalculating)
    }
    
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Material Requirements")
                    .font(.headline)
                
                Spacer()
                
                Button("Clear") {
                    viewModel.clearCalculations()
                }
                .foregroundColor(.red)
            }
            
            VStack(spacing: 12) {
                ForEach(viewModel.calculations) { material in
                    MaterialRowView(material: material)
                }
            }
            
            // Total Cost
            HStack {
                Text("Total Estimated Cost")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(String(format: "$%.2f", viewModel.totalCost))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct MaterialRowView: View {
    let material: CalculatedMaterial
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(material.materialName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(String(format: "%.1f %@", material.quantityNeeded, material.unit.rawValue))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", material.cost))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    MaterialCalculatorView()
        .environmentObject(MaterialCalculatorViewModel())
} 