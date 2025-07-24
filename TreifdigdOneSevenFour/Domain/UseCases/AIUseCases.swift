import Foundation

protocol AIRepository {
    func sendMessage(message: String) async throws -> String
    func getChatSessions() -> [ChatSession]
    func saveChatSession(_ session: ChatSession)
    func deleteChatSession(id: UUID)
    func getAdviceHistory() -> [AIAdvice]
    func saveAdvice(_ advice: AIAdvice)
}

class SendMessageToAIUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(message: String, context: AIContext? = nil) async throws -> String {
        let contextualMessage = buildContextualMessage(message: message, context: context)
        return try await repository.sendMessage(message: contextualMessage)
    }
    
    private func buildContextualMessage(message: String, context: AIContext?) -> String {
        guard let context = context else { return message }
        
        var contextualMessage = ""
        
        if let treeInfo = context.currentTree {
            contextualMessage += "Context: I'm asking about \(treeInfo.name) (\(treeInfo.scientificName)). "
        }
        
        if let location = context.userLocation {
            contextualMessage += "I'm located in \(location). "
        }
        
        if let experience = context.userExperience {
            contextualMessage += "My gardening experience level is \(experience.rawValue). "
        }
        
        contextualMessage += "Question: \(message)"
        
        return contextualMessage
    }
}

class GetChatSessionsUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute() -> [ChatSession] {
        return repository.getChatSessions().sorted { $0.lastMessageDate > $1.lastMessageDate }
    }
}

class SaveChatSessionUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(session: ChatSession) {
        repository.saveChatSession(session)
    }
}

class GetAdviceHistoryUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(category: AdviceCategory? = nil) -> [AIAdvice] {
        let allAdvice = repository.getAdviceHistory()
        
        if let category = category {
            return allAdvice.filter { $0.category == category }
        }
        
        return allAdvice.sorted { $0.timestamp > $1.timestamp }
    }
}

class SaveAdviceUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(advice: AIAdvice) {
        repository.saveAdvice(advice)
    }
}

struct AIContext {
    let currentTree: Tree?
    let userLocation: String?
    let userExperience: GardeningExperience?
    let currentSeason: String?
    let recentTasks: [PlantingTask]?
    
    init(currentTree: Tree? = nil, userLocation: String? = nil, userExperience: GardeningExperience? = nil, currentSeason: String? = nil, recentTasks: [PlantingTask]? = nil) {
        self.currentTree = currentTree
        self.userLocation = userLocation
        self.userExperience = userExperience
        self.currentSeason = currentSeason
        self.recentTasks = recentTasks
    }
} 