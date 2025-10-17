//
//  Constants.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct AppColors {
    static let softBlue = Color(hex: "#A8D8EA") ?? .blue
    static let softGreen = Color(hex: "#B8E6D5") ?? .green
    static let softPink = Color(hex: "#F4ACB7") ?? .pink
    static let softPurple = Color(hex: "#D4A5DA") ?? .purple
    static let softYellow = Color(hex: "#FFE156") ?? .yellow
    static let background = Color(hex: "#F8F9FA") ?? Color(.systemBackground)
    static let cardBackground = Color(hex: "#FFFFFF") ?? Color(.systemBackground)
    
    static let primaryGradient = LinearGradient(
        colors: [softBlue, softGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct AppConstants {
    static let maxPhotos = 3
    static let clubSwitchCooldown = 30 // days
    static let weekDuration = 7 // days
    static let maxMatchesPerWeek = 3
    static let postRateLimit = 1 // per hour
}

struct HapticFeedback {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
