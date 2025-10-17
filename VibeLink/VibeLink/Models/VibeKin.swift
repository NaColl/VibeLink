//
//  VibeKin.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import FirebaseFirestore

struct VibeKin: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var userId: String
    var kinUserId: String
    var kinUserName: String
    var kinUserPhoto: String
    var kinUserBio: String
    var overlapPercentage: Int
    var interactionCount: Int
    var sharedInterests: [String]
    var teaserQuote: String
    var createdAt: Date
    var clubId: String
    
    init(id: String? = nil, userId: String, kinUserId: String, kinUserName: String, kinUserPhoto: String, kinUserBio: String, overlapPercentage: Int, interactionCount: Int, sharedInterests: [String], teaserQuote: String, createdAt: Date = Date(), clubId: String) {
        self.id = id
        self.userId = userId
        self.kinUserId = kinUserId
        self.kinUserName = kinUserName
        self.kinUserPhoto = kinUserPhoto
        self.kinUserBio = kinUserBio
        self.overlapPercentage = overlapPercentage
        self.interactionCount = interactionCount
        self.sharedInterests = sharedInterests
        self.teaserQuote = teaserQuote
        self.createdAt = createdAt
        self.clubId = clubId
    }
}
