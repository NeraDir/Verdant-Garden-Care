import SwiftUI

struct AIAdvisorView: View {
    @EnvironmentObject var viewModel: AIAdvisorViewModel
    @State private var showingSessions = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let session = viewModel.currentSession {
                    // Chat Messages
                    chatView(session: session)
                    
                    // Message Input
                    messageInputView
                } else {
                    // Welcome Screen
                    welcomeView
                }
            }
            .navigationTitle("AI Tree Advisor")
            .navigationBarItems(
                leading: chatHistoryButton,
                trailing: newChatButton
            )
            .sheet(isPresented: $showingSessions) {
                ChatSessionsView(viewModel: viewModel)
            }
        }
    }
    
    private func chatView(session: ChatSession) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(session.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                    
                    if viewModel.isLoading {
                        LoadingBubble()
                    }
                }
                .padding()
            }
            .onChange(of: session.messages.count) { _ in
                if let lastMessage = session.messages.last {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            .onChange(of: viewModel.isLoading) { _ in
                if viewModel.isLoading, let lastMessage = session.messages.last {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private var messageInputView: some View {
        VStack(spacing: 8) {
            if let errorMessage = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            HStack(spacing: 12) {
                HStack {
                    TextField("Ask about tree care, planting, or troubleshooting...", text: $viewModel.messageText, axis: .vertical)
                        .focused($isTextFieldFocused)
                        .lineLimit(1...4)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                
                Button(action: {
                    Task {
                        await viewModel.sendMessage()
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : Color(red: 0.13, green: 0.55, blue: 0.13))
                }
                .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
        }
    }
    
    private var welcomeView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            
            VStack(spacing: 12) {
                Text("Welcome to AI Tree Advisor")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Get expert advice on tree planting, care, and troubleshooting. Ask me anything about trees!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 16) {
                Text("Example questions:")
                    .font(.headline)
                    .fontWeight(.medium)
                
                VStack(spacing: 8) {
                    ExampleQuestionView(question: "How often should I water a young oak tree?")
                    ExampleQuestionView(question: "What's the best time to prune fruit trees?")
                    ExampleQuestionView(question: "My tree leaves are turning yellow. What could be wrong?")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Button("Start New Chat") {
                viewModel.startNewChat()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color(red: 0.13, green: 0.55, blue: 0.13))
            .cornerRadius(10)
            
            Spacer()
        }
    }
    
    private var chatHistoryButton: some View {
        Button(action: {
            showingSessions = true
        }) {
            Image(systemName: "clock")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
        }
    }
    
    private var newChatButton: some View {
        Button(action: {
            viewModel.startNewChat()
        }) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        message.isUser ?
                        Color(red: 0.13, green: 0.55, blue: 0.13) :
                        Color(.systemGray5)
                    )
                    .cornerRadius(18)
                
                Text(message.timestamp, format: .dateTime.hour().minute())
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }
            
            if !message.isUser {
                Spacer(minLength: 50)
            }
        }
    }
}

struct LoadingBubble: View {
    @State private var animationPhase = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color(.systemGray3))
                            .frame(width: 8, height: 8)
                            .opacity(animationPhase == index ? 1.0 : 0.4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemGray5))
                .cornerRadius(18)
                
                Text("AI is typing...")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }
            
            Spacer(minLength: 50)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever()) {
                animationPhase = 0
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    animationPhase = (animationPhase + 1) % 3
                }
            }
        }
    }
}

struct ExampleQuestionView: View {
    let question: String
    
    var body: some View {
        HStack {
            Image(systemName: "bubble.left")
                .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
                .font(.caption)
            
            Text(question)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct ChatSessionsView: View {
    @ObservedObject var viewModel: AIAdvisorViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.chatSessions) { session in
                    ChatSessionRow(session: session) {
                        viewModel.selectSession(session)
                        dismiss()
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteSession(viewModel.chatSessions[index])
                    }
                }
            }
            .navigationTitle("Chat History")
            .navigationBarItems(
                trailing: Button("Done") {
                                            dismiss()
                }
            )
        }
    }
}

struct ChatSessionRow: View {
    let session: ChatSession
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(session.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(session.lastMessageDate, format: .dateTime.day().month().hour().minute())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let lastMessage = session.messages.last {
                    Text(lastMessage.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                                            ChatCategoryBadge(category: session.category)
                    
                    Spacer()
                    
                    Text("\(session.messages.count) messages")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChatCategoryBadge: View {
    let category: ChatCategory
    
    var body: some View {
        Text(category.rawValue)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(red: 0.13, green: 0.55, blue: 0.13).opacity(0.2))
            .foregroundColor(Color(red: 0.13, green: 0.55, blue: 0.13))
            .cornerRadius(4)
    }
}

#Preview {
    AIAdvisorView()
        .environmentObject(AIAdvisorViewModel(
            sendMessageUseCase: SendMessageToAIUseCase(repository: AIRepositoryImpl()),
            getChatSessionsUseCase: GetChatSessionsUseCase(repository: AIRepositoryImpl()),
            saveChatSessionUseCase: SaveChatSessionUseCase(repository: AIRepositoryImpl())
        ))
} 