import Foundation

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    var content: String
    var isUser: Bool
    var timestamp: Date
    var metadata: MessageMetadata?
    
    init(content: String, isUser: Bool, timestamp: Date = Date(), metadata: MessageMetadata? = nil) {
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

struct MessageMetadata: Codable {
    var relatedTreeId: UUID?
    var relatedTaskId: UUID?
    var relatedGuideId: UUID?
    var confidence: Double?
    var sources: [String]
    
    init(relatedTreeId: UUID? = nil, relatedTaskId: UUID? = nil, relatedGuideId: UUID? = nil, confidence: Double? = nil, sources: [String] = []) {
        self.relatedTreeId = relatedTreeId
        self.relatedTaskId = relatedTaskId
        self.relatedGuideId = relatedGuideId
        self.confidence = confidence
        self.sources = sources
    }
}

struct ChatSession: Identifiable, Codable {
    let id = UUID()
    var title: String
    var messages: [ChatMessage]
    var createdDate: Date
    var lastMessageDate: Date
    var isFavorite: Bool
    var category: ChatCategory
    
    init(title: String, messages: [ChatMessage] = [], createdDate: Date = Date(), lastMessageDate: Date = Date(), isFavorite: Bool = false, category: ChatCategory = .general) {
        self.title = title
        self.messages = messages
        self.createdDate = createdDate
        self.lastMessageDate = lastMessageDate
        self.isFavorite = isFavorite
        self.category = category
    }
}

struct AIAdvice: Identifiable, Codable {
    let id = UUID()
    var question: String
    var answer: String
    var category: AdviceCategory
    var relevantTrees: [String]
    var actionItems: [String]
    var resources: [String]
    var timestamp: Date
    var rating: Int? // User rating 1-5
    var isSaved: Bool
    
    init(question: String, answer: String, category: AdviceCategory, relevantTrees: [String] = [], actionItems: [String] = [], resources: [String] = [], timestamp: Date = Date(), rating: Int? = nil, isSaved: Bool = false) {
        self.question = question
        self.answer = answer
        self.category = category
        self.relevantTrees = relevantTrees
        self.actionItems = actionItems
        self.resources = resources
        self.timestamp = timestamp
        self.rating = rating
        self.isSaved = isSaved
    }
}

enum ChatCategory: String, CaseIterable, Codable {
    case general = "General"
    case planting = "Planting"
    case care = "Care"
    case troubleshooting = "Troubleshooting"
    case species = "Species Selection"
    case diseases = "Diseases & Pests"
    case pruning = "Pruning"
    case seasonal = "Seasonal Care"
}

enum AdviceCategory: String, CaseIterable, Codable {
    case plantingTips = "Planting Tips"
    case careTips = "Care Tips"
    case problemSolving = "Problem Solving"
    case speciesInfo = "Species Information"
    case seasonalCare = "Seasonal Care"
    case diseaseControl = "Disease Control"
    case pruningAdvice = "Pruning Advice"
    case soilManagement = "Soil Management"
}

// OpenAI API Models
struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let maxTokens: Int
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case maxTokens = "max_tokens"
        case temperature
    }
    
    init(model: String = "gpt-3.5-turbo", messages: [OpenAIMessage], maxTokens: Int = 1000, temperature: Double = 0.7) {
        self.model = model
        self.messages = messages
        self.maxTokens = maxTokens
        self.temperature = temperature
    }
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
    
    init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}

struct OpenAIResponse: Codable {
    let choices: [OpenAIChoice]
    let usage: OpenAIUsage?
    
    init(choices: [OpenAIChoice], usage: OpenAIUsage? = nil) {
        self.choices = choices
        self.usage = usage
    }
}

struct OpenAIChoice: Codable {
    let message: OpenAIMessage
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
    }
    
    init(message: OpenAIMessage, finishReason: String? = nil) {
        self.message = message
        self.finishReason = finishReason
    }
}

struct OpenAIUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
    
    init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
} 