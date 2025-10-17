//
//  Match.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import FirebaseFirestore

enum MatchStatus: String, Codable {
    case pending // One person interested
    case matched // Mutual interest
    case declined
}

struct Match: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var user1Id: String
    var user2Id: String
    var status: MatchStatus
    var matchedAt: Date?
    var clubId: String
    var icebreakerQuestion: String?
    var user1Answer: String?
    var user2Answer: String?
    var contextPost: String? // Reference to post that sparked connection
    
    init(id: String? = nil, user1Id: String, user2Id: String, status: MatchStatus, matchedAt: Date? = nil, clubId: String, icebreakerQuestion: String? = nil, user1Answer: String? = nil, user2Answer: String? = nil, contextPost: String? = nil) {
        self.id = id
        self.user1Id = user1Id
        self.user2Id = user2Id
        self.status = status
        self.matchedAt = matchedAt
        self.clubId = clubId
        self.icebreakerQuestion = icebreakerQuestion
        self.user1Answer = user1Answer
        self.user2Answer = user2Answer
        self.contextPost = contextPost
    }
    
    func otherUserId(currentUserId: String) -> String {
        return currentUserId == user1Id ? user2Id : user1Id
    }
}
