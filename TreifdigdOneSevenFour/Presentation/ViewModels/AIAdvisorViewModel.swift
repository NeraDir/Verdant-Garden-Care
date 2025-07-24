import Foundation
import SwiftUI

class AIAdvisorViewModel: ObservableObject {
    @Published var chatSessions: [ChatSession] = []
    @Published var currentSession: ChatSession?
    @Published var messageText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let sendMessageUseCase: SendMessageToAIUseCase
    private let getChatSessionsUseCase: GetChatSessionsUseCase
    private let saveChatSessionUseCase: SaveChatSessionUseCase
    
    init(
        sendMessageUseCase: SendMessageToAIUseCase,
        getChatSessionsUseCase: GetChatSessionsUseCase,
        saveChatSessionUseCase: SaveChatSessionUseCase
    ) {
        self.sendMessageUseCase = sendMessageUseCase
        self.getChatSessionsUseCase = getChatSessionsUseCase
        self.saveChatSessionUseCase = saveChatSessionUseCase
        
        loadChatSessions()
    }
    
    func loadChatSessions() {
        chatSessions = getChatSessionsUseCase.execute()
    }
    
    func startNewChat() {
        let newSession = ChatSession(
            title: "New Chat",
            messages: [],
            category: .general
        )
        currentSession = newSession
        chatSessions.insert(newSession, at: 0)
        saveChatSessionUseCase.execute(session: newSession)
    }
    
    func selectSession(_ session: ChatSession) {
        currentSession = session
    }
    
    @MainActor
    func sendMessage() async {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard var session = currentSession else {
            startNewChat()
            guard let session = currentSession else { return }
            await sendMessage()
            return
        }
        
        let userMessage = ChatMessage(
            content: messageText,
            isUser: true
        )
        
        session.messages.append(userMessage)
        
        // Update session title if it's the first message
        if session.title == "New Chat" && session.messages.count == 1 {
            session.title = String(messageText.prefix(30)) + (messageText.count > 30 ? "..." : "")
        }
        
        let currentMessage = messageText
        messageText = ""
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await sendMessageUseCase.execute(message: currentMessage)
            
            let aiMessage = ChatMessage(
                content: response,
                isUser: false
            )
            
            session.messages.append(aiMessage)
            session.lastMessageDate = Date()
            
            currentSession = session
            saveChatSessionUseCase.execute(session: session)
            
            // Update the session in our array
            if let index = chatSessions.firstIndex(where: { $0.id == session.id }) {
                chatSessions[index] = session
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deleteSession(_ session: ChatSession) {
        chatSessions.removeAll { $0.id == session.id }
        
        if currentSession?.id == session.id {
            currentSession = nil
        }
    }
    
    func clearCurrentChat() {
        guard var session = currentSession else { return }
        session.messages.removeAll()
        currentSession = session
        saveChatSessionUseCase.execute(session: session)
        
        if let index = chatSessions.firstIndex(where: { $0.id == session.id }) {
            chatSessions[index] = session
        }
    }
} 