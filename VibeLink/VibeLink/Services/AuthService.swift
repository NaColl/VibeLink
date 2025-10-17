//
//  AuthService.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import SwiftUI

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    static let shared = AuthService()
    
    private init() {
        checkAuth()
    }
    
    func checkAuth() {
        if let firebaseUser = Auth.auth().currentUser {
            // Load user from Firestore
            Task {
                await loadUser(userId: firebaseUser.uid)
            }
        }
    }
    
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // For MVP, simulate successful auth
        // In production, use Firebase Auth with Apple Sign-In
        let userId = credential.user
        let fullName = "\(credential.fullName?.givenName ?? "User") \(credential.fullName?.familyName ?? "")"
        let email = credential.email ?? "user@vibelink.app"
        
        // Simulate user creation
        let newUser = User(
            id: userId,
            fullName: fullName.isEmpty ? "VibeLink User" : fullName,
            email: email,
            club: ""
        )
        
        currentUser = newUser
        isAuthenticated = true
    }
    
    func loadUser(userId: String) async {
        // In production, fetch from Firestore
        // For MVP, use sample data
        isLoading = true
        defer { isLoading = false }
        
        // Simulate loading
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if let user = SampleData.shared.currentUser {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    func updateUser(_ user: User) async throws {
        // In production, update Firestore
        currentUser = user
        
        // Update sample data for offline dev
        SampleData.shared.currentUser = user
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        try? Auth.auth().signOut()
    }
}
