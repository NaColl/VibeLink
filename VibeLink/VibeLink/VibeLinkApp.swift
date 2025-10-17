//
//  VibeLinkApp.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI
import FirebaseCore

@main
struct VibeLinkApp: App {
    @StateObject private var authService = AuthService.shared
    
    init() {
        // Configure Firebase
        // FirebaseApp.configure() // Uncomment when Firebase is set up
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if authService.isAuthenticated, authService.currentUser?.club.isEmpty == false {
                    // User is logged in and has selected a club
                    MainTabView()
                        .transition(.opacity)
                } else if authService.isAuthenticated {
                    // User is logged in but hasn't selected a club
                    HubSelectionView()
                        .transition(.opacity)
                } else {
                    // User is not logged in
                    OnboardingView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: authService.isAuthenticated)
            .animation(.easeInOut, value: authService.currentUser?.club)
        }
    }
}
