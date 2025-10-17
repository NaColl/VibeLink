//
//  ChatListView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var authService = AuthService.shared
    @StateObject private var firestoreService = FirestoreService.shared
    
    @State private var chatPreviews: [ChatPreview] = []
    @State private var selectedChat: ChatPreview?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                if chatPreviews.isEmpty {
                    emptyState
                } else {
                    chatList
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await loadChats()
            }
            .sheet(item: $selectedChat) { chat in
                ChatDetailView(chatPreview: chat)
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Matches Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Keep engaging in your hub to build connections!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Chat List
    
    private var chatList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(chatPreviews) { preview in
                    ChatPreviewRow(preview: preview)
                        .onTapGesture {
                            HapticFeedback.light()
                            selectedChat = preview
                        }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Data Loading
    
    private func loadChats() async {
        guard let userId = authService.currentUser?.id else { return }
        
        do {
            let matches = try await firestoreService.fetchMatches(for: userId)
            
            // Create chat previews from matches
            var previews: [ChatPreview] = []
            
            for match in matches {
                let otherUserId = match.otherUserId(currentUserId: userId)
                
                // Get last message
                let messages = try await firestoreService.fetchMessages(for: match.id ?? "")
                let lastMessage = messages.last
                
                // Get other user info
                let otherUser = SampleData.shared.users.first(where: { $0.id == otherUserId })
                
                let preview = ChatPreview(
                    id: match.id ?? "",
                    matchId: match.id ?? "",
                    otherUserId: otherUserId,
                    otherUserName: otherUser?.fullName ?? "User",
                    otherUserPhoto: otherUser?.photos.first ?? "",
                    lastMessage: lastMessage?.content ?? "Start chatting!",
                    lastMessageAt: lastMessage?.createdAt ?? match.matchedAt ?? Date(),
                    unreadCount: messages.filter { !$0.isRead && $0.receiverId == userId }.count,
                    contextLabel: match.contextPost ?? "From \(authService.currentUser?.club ?? "Hub")"
                )
                
                previews.append(preview)
            }
            
            chatPreviews = previews.sorted { $0.lastMessageAt > $1.lastMessageAt }
            
        } catch {
            print("Error loading chats: \(error)")
        }
    }
}

// MARK: - Chat Preview Row

struct ChatPreviewRow: View {
    let preview: ChatPreview
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile photo
            Circle()
                .fill(
                    LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Text(String(preview.otherUserName.prefix(1)))
                        .font(.title2)
                        .foregroundStyle(.white)
                )
            
            // Message info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(preview.otherUserName)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(preview.lastMessageAt.timeAgo())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(preview.lastMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                Text(preview.contextLabel)
                    .font(.caption)
                    .foregroundStyle(AppColors.softBlue)
            }
            
            if preview.unreadCount > 0 {
                ZStack {
                    Circle()
                        .fill(AppColors.softBlue)
                        .frame(width: 24, height: 24)
                    
                    Text("\(preview.unreadCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

#Preview {
    ChatListView()
}
