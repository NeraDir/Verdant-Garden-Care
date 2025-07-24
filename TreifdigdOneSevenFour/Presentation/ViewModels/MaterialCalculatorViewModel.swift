import Foundation
import SwiftUI

class MaterialCalculatorViewModel: ObservableObject {
    @Published var projectName: String = ""
    @Published var treeCount: String = "1"
    @Published var spacing: String = "20"
    @Published var area: String = "100"
    @Published var calculations: [CalculatedMaterial] = []
    @Published var totalCost: Double = 0.0
    @Published var isCalculating: Bool = false
    
    func calculateMaterials() {
        isCalculating = true
        
        let trees = Int(treeCount) ?? 1
        let spacingValue = Double(spacing) ?? 20.0
        let areaValue = Double(area) ?? 100.0
        
        // Simulate material calculations
        calculations = [
            CalculatedMaterial(
                materialId: UUID(),
                materialName: "Organic Compost",
                quantityNeeded: Double(trees) * 2.0,
                cost: Double(trees) * 2.0 * 15.99,
                unit: .bags
            ),
            CalculatedMaterial(
                materialId: UUID(),
                materialName: "Mulch",
                quantityNeeded: areaValue * 0.1,
                cost: areaValue * 0.1 * 3.50,
                unit: .cubicYards
            ),
            CalculatedMaterial(
                materialId: UUID(),
                materialName: "Tree Stakes",
                quantityNeeded: Double(trees) * 2.0,
                cost: Double(trees) * 2.0 * 4.99,
                unit: .pieces
            ),
            CalculatedMaterial(
                materialId: UUID(),
                materialName: "Tree Ties",
                quantityNeeded: Double(trees) * 2.0,
                cost: Double(trees) * 2.0 * 2.49,
                unit: .pieces
            )
        ]
        
        totalCost = calculations.reduce(0) { $0 + $1.cost }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isCalculating = false
        }
    }
    
    func clearCalculations() {
        calculations.removeAll()
        totalCost = 0.0
        projectName = ""
        treeCount = "1"
        spacing = "20"
        area = "100"
    }
} 