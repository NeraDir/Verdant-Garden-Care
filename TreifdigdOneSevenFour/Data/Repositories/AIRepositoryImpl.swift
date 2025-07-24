import Foundation

class AIRepositoryImpl: AIRepository {
    private let userDefaults = UserDefaults.standard
    private let chatSessionsKey = "chat_sessions"
    private let adviceHistoryKey = "advice_history"
    private let apiKey = "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"
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(message: String) async throws -> String {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let systemPrompt = """
        You are a knowledgeable tree care expert and arborist assistant. You help users with:
        - Tree selection and planting advice
        - Care and maintenance guidance
        - Problem diagnosis and solutions
        - Seasonal care recommendations
        - Soil and environmental considerations
        
        Provide practical, actionable advice. Keep responses concise but informative. 
        Always consider safety and local regulations when giving advice.
        """
        
        let messages = [
            OpenAIMessage(role: "system", content: systemPrompt),
            OpenAIMessage(role: "user", content: message)
        ]
        
        let requestBody = OpenAIRequest(
            model: "gpt-3.5-turbo",
            messages: messages,
            maxTokens: 1000,
            temperature: 0.7
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw AIError.apiError(statusCode: httpResponse.statusCode)
        }
        
        let apiResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let firstChoice = apiResponse.choices.first else {
            throw AIError.noResponse
        }
        
        return firstChoice.message.content
    }
    
    func getChatSessions() -> [ChatSession] {
        guard let data = userDefaults.data(forKey: chatSessionsKey),
              let sessions = try? JSONDecoder().decode([ChatSession].self, from: data) else {
            return []
        }
        return sessions
    }
    
    func saveChatSession(_ session: ChatSession) {
        var sessions = getChatSessions()
        
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        
        if let data = try? JSONEncoder().encode(sessions) {
            userDefaults.set(data, forKey: chatSessionsKey)
        }
    }
    
    func deleteChatSession(id: UUID) {
        var sessions = getChatSessions()
        sessions.removeAll { $0.id == id }
        
        if let data = try? JSONEncoder().encode(sessions) {
            userDefaults.set(data, forKey: chatSessionsKey)
        }
    }
    
    func getAdviceHistory() -> [AIAdvice] {
        guard let data = userDefaults.data(forKey: adviceHistoryKey),
              let advice = try? JSONDecoder().decode([AIAdvice].self, from: data) else {
            return []
        }
        return advice
    }
    
    func saveAdvice(_ advice: AIAdvice) {
        var allAdvice = getAdviceHistory()
        
        if let index = allAdvice.firstIndex(where: { $0.id == advice.id }) {
            allAdvice[index] = advice
        } else {
            allAdvice.append(advice)
        }
        
        if let data = try? JSONEncoder().encode(allAdvice) {
            userDefaults.set(data, forKey: adviceHistoryKey)
        }
    }
}

enum AIError: Error, LocalizedError {
    case invalidResponse
    case apiError(statusCode: Int)
    case noResponse
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from AI service"
        case .apiError(let statusCode):
            return "AI service error (Status: \(statusCode))"
        case .noResponse:
            return "No response from AI service"
        case .networkError:
            return "Network connection error"
        }
    }
} 