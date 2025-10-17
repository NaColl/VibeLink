//
//  FirestoreService.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class FirestoreService: ObservableObject {
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Posts
    
    func fetchPosts(for clubId: String) async throws -> [Post] {
        // For MVP, return sample data
        return SampleData.shared.posts.filter { $0.clubId == clubId }
    }
    
    func createPost(_ post: Post) async throws {
        // In production, add to Firestore
        SampleData.shared.posts.append(post)
    }
    
    func addReaction(postId: String, emoji: String) async throws {
        // Update local sample data
        if let index = SampleData.shared.posts.firstIndex(where: { $0.id == postId }) {
            var post = SampleData.shared.posts[index]
            post.reactions[emoji, default: 0] += 1
            SampleData.shared.posts[index] = post
        }
    }
    
    func fetchReplies(for postId: String) async throws -> [Reply] {
        return SampleData.shared.replies.filter { $0.postId == postId }
    }
    
    func addReply(_ reply: Reply) async throws {
        SampleData.shared.replies.append(reply)
        
        // Increment reply count
        if let index = SampleData.shared.posts.firstIndex(where: { $0.id == reply.postId }) {
            SampleData.shared.posts[index].replyCount += 1
        }
    }
    
    // MARK: - Vibe Kin
    
    func fetchVibeKin(for userId: String, clubId: String) async throws -> [VibeKin] {
        return SampleData.shared.vibeKins.filter { $0.userId == userId && $0.clubId == clubId }
    }
    
    // MARK: - Matches
    
    func createMatch(_ match: Match) async throws {
        SampleData.shared.matches.append(match)
    }
    
    func updateMatch(_ match: Match) async throws {
        if let index = SampleData.shared.matches.firstIndex(where: { $0.id == match.id }) {
            SampleData.shared.matches[index] = match
        }
    }
    
    func fetchMatches(for userId: String) async throws -> [Match] {
        return SampleData.shared.matches.filter { 
            ($0.user1Id == userId || $0.user2Id == userId) && $0.status == .matched
        }
    }
    
    // MARK: - Messages
    
    func fetchMessages(for matchId: String) async throws -> [Message] {
        return SampleData.shared.messages.filter { $0.matchId == matchId }
            .sorted { $0.createdAt < $1.createdAt }
    }
    
    func sendMessage(_ message: Message) async throws {
        SampleData.shared.messages.append(message)
    }
    
    func markMessagesAsRead(matchId: String, userId: String) async throws {
        for i in 0..<SampleData.shared.messages.count {
            if SampleData.shared.messages[i].matchId == matchId && 
               SampleData.shared.messages[i].receiverId == userId {
                SampleData.shared.messages[i].isRead = true
            }
        }
    }
}
