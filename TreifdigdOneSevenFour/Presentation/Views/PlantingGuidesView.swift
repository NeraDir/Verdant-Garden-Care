import SwiftUI

struct PlantingGuidesView: View {
    @EnvironmentObject var viewModel: PlantingGuidesViewModel
    @State private var selectedGuide: PlantingGuide?
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Content
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading guides...")
                        .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                    Spacer()
                } else {
                    guidesList
                }
            }
            .navigationTitle("Planting Guides")
            .navigationBarItems(trailing: filterButton)
            .sheet(isPresented: $showingFilters) {
                GuidesFilterSheet(viewModel: viewModel)
            }
            .sheet(item: $selectedGuide) { guide in
                GuideDetailView(guide: guide, viewModel: viewModel)
            }
            .onChange(of: viewModel.searchText) { _ in
                viewModel.filterGuides()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search guides...", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var guidesList: some View {
        List {
            // In Progress Section
            if !viewModel.inProgressGuides.isEmpty {
                Section("In Progress") {
                    ForEach(viewModel.inProgressGuides) { guide in
                        GuideRowView(guide: guide, viewModel: viewModel) {
                            selectedGuide = guide
                        }
                    }
                }
            }
            
            // Completed Section
            if !viewModel.completedGuides.isEmpty {
                Section("Completed") {
                    ForEach(viewModel.completedGuides) { guide in
                        GuideRowView(guide: guide, viewModel: viewModel) {
                            selectedGuide = guide
                        }
                    }
                }
            }
            
            // Available Guides Section
            if !viewModel.guides.isEmpty {
                Section("Available Guides") {
                    ForEach(viewModel.guides) { guide in
                        GuideRowView(guide: guide, viewModel: viewModel) {
                            selectedGuide = guide
                        }
                    }
                }
            }
            
            // Empty state
            if viewModel.guides.isEmpty && viewModel.inProgressGuides.isEmpty && viewModel.completedGuides.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "book")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No guides found")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("Try adjusting your search or filters")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var filterButton: some View {
        Button(action: {
            showingFilters = true
        }) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
        }
    }
}

struct GuideRowView: View {
    let guide: PlantingGuide
    let viewModel: PlantingGuidesViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(guide.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(guide.treeType)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    DifficultyBadge(difficulty: guide.difficulty, color: viewModel.getDifficultyColor(guide.difficulty))
                }
                
                // Progress Bar (if started)
                if guide.userProgress.isStarted {
                    ProgressView(value: viewModel.getProgressPercentage(guide))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.13, green: 0.55, blue: 0.13)))
                    
                    HStack {
                        Text("\(guide.userProgress.completedSteps.count) of \(guide.steps.count) steps completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if guide.userProgress.isCompleted {
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.medium)
                        } else {
                            Text("Step \(guide.userProgress.currentStep)")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                                .fontWeight(.medium)
                        }
                    }
                }
                
                // Info Row
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(guide.estimatedTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "list.number")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(guide.steps.count) steps")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty
    let color: Color
    
    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

struct GuidesFilterSheet: View {
    @ObservedObject var viewModel: PlantingGuidesViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Difficulty Level")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            DifficultyFilterButton(
                                difficulty: difficulty,
                                isSelected: viewModel.selectedDifficulty == difficulty,
                                color: viewModel.getDifficultyColor(difficulty)
                            ) {
                                if viewModel.selectedDifficulty == difficulty {
                                    viewModel.selectedDifficulty = nil
                                } else {
                                    viewModel.selectedDifficulty = difficulty
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filters")
            .navigationBarItems(
                leading: Button("Clear") {
                    viewModel.selectedDifficulty = nil
                },
                trailing: Button("Done") {
                    viewModel.filterGuides()
                    dismiss()
                }
            )
        }
    }
}

struct DifficultyFilterButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "book")
                    .foregroundColor(isSelected ? .white : color)
                
                Text(difficulty.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : color)
                
                Spacer()
            }
            .padding()
            .background(isSelected ? color : color.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

struct GuideDetailView: View {
    let guide: PlantingGuide
    let viewModel: PlantingGuidesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingStepDetail: PlantingStep?
    @State private var isStartingGuide: Bool = false
    
    private var currentGuide: PlantingGuide {
        // Get the most up-to-date version of the guide from ViewModel
        return viewModel.guides.first(where: { $0.id == guide.id }) ?? 
               viewModel.inProgressGuides.first(where: { $0.id == guide.id }) ?? 
               viewModel.completedGuides.first(where: { $0.id == guide.id }) ?? 
               guide
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    guideHeader
                    
                    // Progress Section
                    if currentGuide.userProgress.isStarted {
                        progressSection
                    }
                    
                    // Steps Section
                    stepsSection
                    
                    // Requirements Section
                    requirementsSection
                    
                    // Tips Section
                    tipsSection
                }
                .padding()
            }
            .navigationTitle(currentGuide.title)
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                },
                trailing: startButton
            )
            .sheet(item: $showingStepDetail) { step in
                StepDetailView(step: step, guide: currentGuide, viewModel: viewModel)
            }
        }
    }
    
    private var guideHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentGuide.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(currentGuide.treeType)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                DifficultyBadge(difficulty: currentGuide.difficulty, color: viewModel.getDifficultyColor(currentGuide.difficulty))
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                    Text(currentGuide.estimatedTime)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "list.number")
                        .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                    Text("\(currentGuide.steps.count) steps")
                        .fontWeight(.medium)
                }
            }
            .font(.subheadline)
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress")
                .font(.headline)
            
            ProgressView(value: viewModel.getProgressPercentage(currentGuide))
                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.13, green: 0.55, blue: 0.13)))
            
            HStack {
                Text("\(currentGuide.userProgress.completedSteps.count) of \(currentGuide.steps.count) steps completed")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if currentGuide.userProgress.isCompleted {
                    Text("✓ Completed")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Steps")
                .font(.headline)
            
            ForEach(currentGuide.steps) { step in
                StepRowView(step: step, guide: currentGuide, viewModel: viewModel) {
                    showingStepDetail = step
                }
            }
        }
    }
    
    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Requirements")
                .font(.headline)
            
            HStack(alignment: .top, spacing: 20) {
                // Tools
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tools")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ForEach(currentGuide.requiredTools, id: \.self) { tool in
                        HStack {
                            Image(systemName: "wrench")
                                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                                .font(.caption)
                            Text(tool)
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                // Materials
                VStack(alignment: .leading, spacing: 8) {
                    Text("Materials")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ForEach(currentGuide.requiredMaterials, id: \.self) { material in
                        HStack {
                            Image(systemName: "cube.box")
                                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                                .font(.caption)
                            Text(material)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pro Tips")
                .font(.headline)
            
            ForEach(Array(currentGuide.tips.enumerated()), id: \.offset) { index, tip in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(index + 1)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .background(Color(red: 0.13, green: 0.55, blue: 0.13))
                        .clipShape(Circle())
                    
                    Text(tip)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var startButton: some View {
        Button(action: {
            if !currentGuide.userProgress.isStarted {
                isStartingGuide = true
                viewModel.startGuide(currentGuide)
                
                // Give the UI a moment to update, then open the first step
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isStartingGuide = false
                    if let firstStep = currentGuide.steps.first {
                        showingStepDetail = firstStep
                    }
                }
            }
        }) {
            HStack {
                if isStartingGuide {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Text(currentGuide.userProgress.isStarted ? "Started" : "Start")
                }
            }
            .foregroundColor(currentGuide.userProgress.isStarted ? .gray : Color(red: 0.13, green: 0.55, blue: 0.13))
        }
        .disabled(currentGuide.userProgress.isStarted || isStartingGuide)
    }
}

struct StepRowView: View {
    let step: PlantingStep
    let guide: PlantingGuide
    let viewModel: PlantingGuidesViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Step number with status
                ZStack {
                    Circle()
                        .fill(step.isCompleted ? Color(red: 0.13, green: 0.55, blue: 0.13) : Color(.systemGray5))
                        .frame(width: 30, height: 30)
                    
                    if step.isCompleted {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.bold)
                    } else {
                        Text("\(step.stepNumber)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(step.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(step.estimatedTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(step.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StepDetailView: View {
    let step: PlantingStep
    let guide: PlantingGuide
    let viewModel: PlantingGuidesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var notes: String = ""
    @FocusState private var isNotesFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Step Header
                    stepHeader
                    
                    // Description
                    descriptionSection
                    
                    // Notes Section
                    notesSection
                    
                    // Complete Button
                    if !step.isCompleted && guide.userProgress.isStarted {
                        completeButton
                    }
                }
                .padding()
            }
            .navigationTitle("Step \(step.stepNumber)")
            .navigationBarItems(
                trailing: Button("Close") {
                    dismiss()
                }
            )
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isNotesFocused = false
                    }
                }
            }
        }
        .onAppear {
            notes = step.notes
        }
    }
    
    private var stepHeader: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(step.isCompleted ? Color(red: 0.13, green: 0.55, blue: 0.13) : Color(.systemGray5))
                    .frame(width: 60, height: 60)
                
                if step.isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                } else {
                    Image(systemName: step.iconName)
                        .foregroundColor(.secondary)
                        .font(.title2)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Estimated time: \(step.estimatedTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if step.isCompleted, let completedDate = step.completedDate {
                    Text("Completed: \(completedDate, format: .dateTime.day().month().year())")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.headline)
            
            Text(step.description)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(.headline)
            
            TextField("Add your notes here...", text: $notes, axis: .vertical)
                .focused($isNotesFocused)
                .lineLimit(3...8)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var completeButton: some View {
        Button(action: {
            viewModel.completeStep(guideId: guide.id, stepNumber: step.stepNumber, notes: notes)
            dismiss()
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Mark as Complete")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.13, green: 0.55, blue: 0.13))
            .cornerRadius(10)
        }
    }
}

#Preview {
    PlantingGuidesView()
        .environmentObject(PlantingGuidesViewModel(
            getAllGuidesUseCase: GetAllGuidesUseCase(repository: PlantingGuideRepositoryImpl()),
            startGuideUseCase: StartGuideUseCase(repository: PlantingGuideRepositoryImpl()),
            completeStepUseCase: CompleteStepUseCase(repository: PlantingGuideRepositoryImpl())
        ))
} 