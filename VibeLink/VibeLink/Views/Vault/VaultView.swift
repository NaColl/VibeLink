//
//  VaultView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct VaultView: View {
    @StateObject private var authService = AuthService.shared
    @StateObject private var timerService = WeeklyTimerService.shared
    
    @State private var showSwitchClubAlert = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile section
                        profileSection
                        
                        // Streaks section
                        streaksSection
                        
                        // Nudges section
                        nudgesSection
                        
                        // Settings section
                        settingsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Vault")
            .navigationBarTitleDisplayMode(.large)
            .alert("Switch Club?", isPresented: $showSwitchClubAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Switch") {
                    // Navigate to hub selection
                }
            } message: {
                Text("You can switch to a different club. This will reset your week progress.")
            }
            .alert("Sign Out?", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authService.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
    
    // MARK: - Profile Section
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            // Profile photo
            Circle()
                .fill(
                    LinearGradient(colors: [AppColors.softPurple.opacity(0.4), AppColors.softBlue.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Text(String(authService.currentUser?.fullName.prefix(1) ?? "V"))
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                )
            
            VStack(spacing: 4) {
                Text(authService.currentUser?.fullName ?? "User")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(authService.currentUser?.email ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Current club
            if let clubId = authService.currentUser?.club,
               let hub = SampleData.shared.hubs.first(where: { $0.id == clubId }) {
                HStack {
                    Image(systemName: hub.iconName)
                        .foregroundStyle(hub.colorValue)
                    Text(hub.name)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(hub.colorValue.opacity(0.2))
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    // MARK: - Streaks Section
    
    private var streaksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Streaks & Achievements")
                .font(.headline)
            
            VStack(spacing: 12) {
                StreakRow(
                    icon: "flame.fill",
                    title: "\(timerService.currentDay)-Day Active!",
                    subtitle: "Keep the vibe going",
                    color: .orange
                )
                
                StreakRow(
                    icon: "star.fill",
                    title: "Community Member",
                    subtitle: "Active in \(authService.currentUser?.club ?? "Hub")",
                    color: AppColors.softYellow
                )
                
                StreakRow(
                    icon: "heart.fill",
                    title: "\(SampleData.shared.matches.count) Connections",
                    subtitle: "Matches this week",
                    color: .pink
                )
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    // MARK: - Nudges Section
    
    private var nudgesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Nudges")
                .font(.headline)
            
            VStack(spacing: 12) {
                NudgeRow(
                    icon: "book.fill",
                    message: "Check out the new book poll in your hub!",
                    color: AppColors.softBlue
                )
                
                NudgeRow(
                    icon: "calendar",
                    message: "\(timerService.daysRemaining) days until weekly decision",
                    color: AppColors.softGreen
                )
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    // MARK: - Settings Section
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
            
            VStack(spacing: 0) {
                SettingRow(
                    icon: "arrow.triangle.2.circlepath",
                    title: "Switch Club",
                    subtitle: authService.currentUser?.canSwitchClub ?? false ? "Available now" : "In \(authService.currentUser?.daysUntilClubSwitch ?? 30) days",
                    action: {
                        if authService.currentUser?.canSwitchClub ?? false {
                            showSwitchClubAlert = true
                        }
                    },
                    isDisabled: !(authService.currentUser?.canSwitchClub ?? false)
                )
                
                Divider()
                    .padding(.leading, 52)
                
                SettingRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Manage your alerts",
                    action: { }
                )
                
                Divider()
                    .padding(.leading, 52)
                
                SettingRow(
                    icon: "hand.raised.fill",
                    title: "Privacy & Safety",
                    subtitle: "Control your experience",
                    action: { }
                )
                
                Divider()
                    .padding(.leading, 52)
                
                SettingRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    subtitle: "Get assistance",
                    action: { }
                )
                
                Divider()
                    .padding(.leading, 52)
                
                SettingRow(
                    icon: "rectangle.portrait.and.arrow.right",
                    title: "Sign Out",
                    subtitle: "",
                    action: {
                        showLogoutAlert = true
                    },
                    isDestructive: true
                )
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

// MARK: - Supporting Views

struct StreakRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct NudgeRow: View {
    let icon: String
    let message: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
            
            Text(message)
                .font(.subheadline)
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    var isDisabled: Bool = false
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isDestructive ? .red : AppColors.softBlue)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(isDestructive ? .red : .primary)
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    VaultView()
}
