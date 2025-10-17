//
//  ChatDetailView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI
import PhotosUI

struct ChatDetailView: View {
    let chatPreview: ChatPreview
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = AuthService.shared
    @StateObject private var firestoreService = FirestoreService.shared
    
    @State private var messages: [Message] = []
    @State private var newMessage = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showReportAlert = false
    @State private var reportedMessageId: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Context label
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundStyle(AppColors.softBlue)
                        Text(chatPreview.contextLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(AppColors.cardBackground)
                    
                    // Messages
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(messages) { message in
                                    MessageBubble(
                                        message: message,
                                        isFromCurrentUser: message.senderId == authService.currentUser?.id,
                                        onLongPress: {
                                            reportedMessageId = message.id
                                            showReportAlert = true
                                        }
                                    )
                                    .id(message.id)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: messages.count) { oldValue, newValue in
                            if let lastMessage = messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Input bar
                    messageInputBar
                }
            }
            .navigationTitle(chatPreview.otherUserName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            // Mute action
                        } label: {
                            Label("Mute", systemImage: "bell.slash")
                        }
                        
                        Button(role: .destructive) {
                            showReportAlert = true
                        } label: {
                            Label("Report", systemImage: "exclamationmark.triangle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .task {
                await loadMessages()
                await markAsRead()
            }
            .alert("Report", isPresented: $showReportAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Report", role: .destructive) {
                    reportMessage()
                }
            } message: {
                Text("Report this message or user for inappropriate content?")
            }
        }
    }
    
    // MARK: - Message Input Bar
    
    private var messageInputBar: some View {
        HStack(spacing: 12) {
            // Photo picker
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Image(systemName: "photo")
                    .font(.title3)
                    .foregroundStyle(AppColors.softBlue)
            }
            .onChange(of: selectedPhoto) { oldValue, newValue in
                if newValue != nil {
                    sendPhotoMessage()
                }
            }
            
            // Voice recording button (stub)
            Button(action: {
                HapticFeedback.light()
                // Voice recording stub
            }) {
                Image(systemName: "waveform")
                    .font(.title3)
                    .foregroundStyle(AppColors.softBlue)
            }
            
            // Text field
            TextField("Message...", text: $newMessage, axis: .vertical)
                .lineLimit(1...4)
                .textFieldStyle(.plain)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                )
            
            // Send button
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(newMessage.isEmpty ? Color.gray : AppColors.softBlue)
            }
            .disabled(newMessage.isEmpty)
        }
        .padding()
        .background(AppColors.background)
        .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
    
    // MARK: - Actions
    
    private func loadMessages() async {
        do {
            messages = try await firestoreService.fetchMessages(for: chatPreview.matchId)
        } catch {
            print("Error loading messages: \(error)")
        }
    }
    
    private func markAsRead() async {
        guard let userId = authService.currentUser?.id else { return }
        
        do {
            try await firestoreService.markMessagesAsRead(matchId: chatPreview.matchId, userId: userId)
        } catch {
            print("Error marking messages as read: \(error)")
        }
    }
    
    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty,
              let userId = authService.currentUser?.id else { return }
        
        let message = Message(
            matchId: chatPreview.matchId,
            senderId: userId,
            receiverId: chatPreview.otherUserId,
            type: .text,
            content: newMessage
        )
        
        Task {
            do {
                try await firestoreService.sendMessage(message)
                await loadMessages()
                newMessage = ""
                HapticFeedback.light()
            } catch {
                print("Error sending message: \(error)")
            }
        }
    }
    
    private func sendPhotoMessage() {
        guard let userId = authService.currentUser?.id else { return }
        
        // In production, upload photo to Storage and get URL
        let photoURL = "photo_url_placeholder"
        
        let message = Message(
            matchId: chatPreview.matchId,
            senderId: userId,
            receiverId: chatPreview.otherUserId,
            type: .image,
            content: photoURL
        )
        
        Task {
            do {
                try await firestoreService.sendMessage(message)
                await loadMessages()
                selectedPhoto = nil
                HapticFeedback.light()
            } catch {
                print("Error sending photo: \(error)")
            }
        }
    }
    
    private func reportMessage() {
        HapticFeedback.medium()
        // In production, flag in Firestore
        print("Reported message: \(reportedMessageId ?? "user")")
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool
    let onLongPress: () -> Void
    
    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if message.type == .text {
                    Text(message.content)
                        .font(.body)
                        .foregroundStyle(isFromCurrentUser ? .white : .primary)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isFromCurrentUser ? AppColors.softBlue : AppColors.cardBackground)
                        )
                } else if message.type == .image {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                        )
                } else if message.type == .voice {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 4)
                        
                        Text("0:15")
                            .font(.caption)
                    }
                    .foregroundStyle(isFromCurrentUser ? .white : .primary)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isFromCurrentUser ? AppColors.softBlue : AppColors.cardBackground)
                    )
                }
                
                Text(message.createdAt.formattedTime())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .contextMenu {
                Button(role: .destructive) {
                    onLongPress()
                } label: {
                    Label("Report", systemImage: "exclamationmark.triangle")
                }
            }
            
            if !isFromCurrentUser { Spacer() }
        }
    }
}

#Preview {
    ChatDetailView(chatPreview: ChatPreview(
        id: "match1",
        matchId: "match1",
        otherUserId: "user1",
        otherUserName: "Emma Rodriguez",
        otherUserPhoto: "photo_emma",
        lastMessage: "Just started Project Hail Mary!",
        lastMessageAt: Date(),
        unreadCount: 2,
        contextLabel: "From Book Poll"
    ))
}
