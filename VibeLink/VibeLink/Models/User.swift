//
//  User.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var fullName: String
    var email: String
    var bio: String
    var photos: [String] // URLs
    var club: String
    var clubJoinedDate: Date
    var createdAt: Date
    var engagementScore: Int // Track activity level
    var preferences: UserPreferences
    
    enum CodingKeys: String, CodingKey {
        case id, fullName, email, bio, photos, club, clubJoinedDate, createdAt, engagementScore, preferences
    }
    
    init(id: String? = nil, fullName: String, email: String, bio: String = "", photos: [String] = [], club: String, clubJoinedDate: Date = Date(), createdAt: Date = Date(), engagementScore: Int = 0, preferences: UserPreferences = UserPreferences()) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.bio = bio
        self.photos = photos
        self.club = club
        self.clubJoinedDate = clubJoinedDate
        self.createdAt = createdAt
        self.engagementScore = engagementScore
        self.preferences = preferences
    }
    
    var canSwitchClub: Bool {
        let daysSinceJoin = Calendar.current.dateComponents([.day], from: clubJoinedDate, to: Date()).day ?? 0
        return daysSinceJoin >= 30
    }
    
    var daysUntilClubSwitch: Int {
        let daysSinceJoin = Calendar.current.dateComponents([.day], from: clubJoinedDate, to: Date()).day ?? 0
        return max(0, 30 - daysSinceJoin)
    }
}

struct UserPreferences: Codable, Hashable {
    var ageMin: Int = 21
    var ageMax: Int = 40
    var distance: Double = 50.0 // miles
    var notificationsEnabled: Bool = true
}
