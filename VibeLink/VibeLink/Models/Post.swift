//
//  Post.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import FirebaseFirestore

enum PostType: String, Codable {
    case text
    case poll
    case event
}

struct Post: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var userId: String
    var userName: String
    var userPhoto: String
    var type: PostType
    var content: String
    var clubId: String
    var createdAt: Date
    var reactions: [String: Int] // emoji: count
    var replyCount: Int
    
    // Poll-specific
    var pollOptions: [PollOption]?
    
    // Event-specific
    var eventDate: Date?
    var eventLocation: String?
    var rsvpCount: Int?
    
    init(id: String? = nil, userId: String, userName: String, userPhoto: String, type: PostType, content: String, clubId: String, createdAt: Date = Date(), reactions: [String: Int] = [:], replyCount: Int = 0, pollOptions: [PollOption]? = nil, eventDate: Date? = nil, eventLocation: String? = nil, rsvpCount: Int? = nil) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userPhoto = userPhoto
        self.type = type
        self.content = content
        self.clubId = clubId
        self.createdAt = createdAt
        self.reactions = reactions
        self.replyCount = replyCount
        self.pollOptions = pollOptions
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.rsvpCount = rsvpCount
    }
}

struct PollOption: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var text: String
    var votes: Int
    
    init(text: String, votes: Int = 0) {
        self.text = text
        self.votes = votes
    }
}

struct Reply: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var postId: String
    var userId: String
    var userName: String
    var userPhoto: String
    var content: String
    var createdAt: Date
    
    init(id: String? = nil, postId: String, userId: String, userName: String, userPhoto: String, content: String, createdAt: Date = Date()) {
        self.id = id
        self.postId = postId
        self.userId = userId
        self.userName = userName
        self.userPhoto = userPhoto
        self.content = content
        self.createdAt = createdAt
    }
}
