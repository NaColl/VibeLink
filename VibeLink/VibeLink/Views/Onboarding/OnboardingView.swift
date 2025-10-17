//
//  OnboardingView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @StateObject private var authService = AuthService.shared
    @State private var showHubSelection = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            // Background gradient
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Logo and title
                VStack(spacing: 16) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                    
                    Text("VibeLink")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Find your people through shared passions")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "person.3.fill", text: "Join ONE hobby club that matches you")
                    FeatureRow(icon: "calendar", text: "Weekly cycles - no endless scrolling")
                    FeatureRow(icon: "bubble.left.and.bubble.right.fill", text: "Natural connections through conversations")
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Sign in button
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        handleSignIn(result)
                    }
                )
                .signInWithAppleButtonStyle(.white)
                .frame(height: 50)
                .cornerRadius(25)
                .padding(.horizontal, 32)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                
                Text("Sign in to continue (<60 seconds)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showHubSelection) {
            HubSelectionView()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func handleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                Task {
                    do {
                        try await authService.signInWithApple(credential: appleIDCredential)
                        HapticFeedback.success()
                        showHubSelection = true
                    } catch {
                        HapticFeedback.error()
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                }
            }
        case .failure(let error):
            HapticFeedback.error()
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(.white)
                .frame(width: 32)
            
            Text(text)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    OnboardingView()
}
