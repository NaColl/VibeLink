//
//  PostDetailView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = AuthService.shared
    @StateObject private var firestoreService = FirestoreService.shared
    
    @State private var replies: [Reply] = []
    @State private var newReply = ""
    @State private var selectedReaction = ""
    
    let reactionEmojis = ["❤️", "😂", "😭", "🔥", "👀", "💯"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Original post
                        PostCard(post: post)
                            .padding(.horizontal)
                        
                        // Reactions bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(reactionEmojis, id: \.self) { emoji in
                                    Button(action: {
                                        addReaction(emoji)
                                    }) {
                                        Text(emoji)
                                            .font(.title2)
                                            .padding(8)
                                            .background(
                                                Circle()
                                                    .fill(selectedReaction == emoji ? AppColors.softBlue.opacity(0.3) : Color.gray.opacity(0.1))
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Replies
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Replies (\(replies.count))")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if replies.isEmpty {
                                Text("Be the first to reply!")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                            } else {
                                ForEach(replies) { reply in
                                    ReplyRow(reply: reply)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                // Reply input
                VStack {
                    Spacer()
                    replyInputBar
                }
            }
            .navigationTitle("Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadReplies()
            }
        }
    }
    
    // MARK: - Reply Input
    
    private var replyInputBar: some View {
        HStack(spacing: 12) {
            TextField("Add a reply...", text: $newReply, axis: .vertical)
                .lineLimit(1...3)
                .textFieldStyle(.plain)
                .padding(12)
                .background(AppColors.cardBackground)
                .cornerRadius(20)
            
            Button(action: sendReply) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(newReply.isEmpty ? Color.gray : AppColors.softBlue)
            }
            .disabled(newReply.isEmpty)
        }
        .padding()
        .background(AppColors.background)
        .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
    
    // MARK: - Actions
    
    private func loadReplies() async {
        guard let postId = post.id else { return }
        
        do {
            replies = try await firestoreService.fetchReplies(for: postId)
        } catch {
            print("Error loading replies: \(error)")
        }
    }
    
    private func sendReply() {
        guard !newReply.trimmingCharacters(in: .whitespaces).isEmpty,
              let user = authService.currentUser,
              let postId = post.id else { return }
        
        let reply = Reply(
            postId: postId,
            userId: user.id ?? "",
            userName: user.fullName,
            userPhoto: user.photos.first ?? "",
            content: newReply
        )
        
        Task {
            do {
                try await firestoreService.addReply(reply)
                await loadReplies()
                newReply = ""
                HapticFeedback.light()
            } catch {
                print("Error sending reply: \(error)")
            }
        }
    }
    
    private func addReaction(_ emoji: String) {
        selectedReaction = emoji
        HapticFeedback.light()
        
        guard let postId = post.id else { return }
        
        Task {
            do {
                try await firestoreService.addReaction(postId: postId, emoji: emoji)
            } catch {
                print("Error adding reaction: \(error)")
            }
        }
    }
}

struct ReplyRow: View {
    let reply: Reply
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(reply.userName.prefix(1)))
                        .font(.caption)
                        .foregroundStyle(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(reply.userName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(reply.createdAt.timeAgo())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(reply.content)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

#Preview {
    PostDetailView(post: SampleData.shared.posts[0])
}
