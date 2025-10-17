//
//  Message.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import FirebaseFirestore

enum MessageType: String, Codable {
    case text
    case image
    case voice
}

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var matchId: String
    var senderId: String
    var receiverId: String
    var type: MessageType
    var content: String // Text or URL for media
    var createdAt: Date
    var isRead: Bool
    
    init(id: String? = nil, matchId: String, senderId: String, receiverId: String, type: MessageType, content: String, createdAt: Date = Date(), isRead: Bool = false) {
        self.id = id
        self.matchId = matchId
        self.senderId = senderId
        self.receiverId = receiverId
        self.type = type
        self.content = content
        self.createdAt = createdAt
        self.isRead = isRead
    }
}

struct ChatPreview: Identifiable, Hashable {
    var id: String // matchId
    var matchId: String
    var otherUserId: String
    var otherUserName: String
    var otherUserPhoto: String
    var lastMessage: String
    var lastMessageAt: Date
    var unreadCount: Int
    var contextLabel: String
}
