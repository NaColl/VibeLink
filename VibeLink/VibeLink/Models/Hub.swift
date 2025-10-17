//
//  Hub.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import SwiftUI

struct Hub: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var iconName: String // SF Symbol name
    var description: String
    var color: String // Hex color
    var memberCount: Int
    
    var colorValue: Color {
        Color(hex: color) ?? .blue
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
}
