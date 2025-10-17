//
//  HubSelectionView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI
import PhotosUI

struct HubSelectionView: View {
    @StateObject private var authService = AuthService.shared
    @State private var selectedHub: Hub?
    @State private var showConfirmation = false
    @State private var showProfileSetup = false
    @State private var bio = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoURLs: [String] = []
    @State private var isComplete = false
    
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                if !showProfileSetup {
                    hubSelectionContent
                } else {
                    profileSetupContent
                }
            }
            .navigationTitle(showProfileSetup ? "Complete Profile" : "Choose Your Hub")
            .navigationBarTitleDisplayMode(.large)
        }
        .fullScreenCover(isPresented: $isComplete) {
            MainTabView()
        }
    }
    
    // MARK: - Hub Selection
    
    private var hubSelectionContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Pick ONE club that vibes with you")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
                
                Text("(You can switch in 30 days)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(SampleData.shared.hubs) { hub in
                        HubCard(hub: hub, isSelected: selectedHub?.id == hub.id)
                            .onTapGesture {
                                HapticFeedback.light()
                                selectedHub = hub
                                showConfirmation = true
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 32)
        }
        .alert("Join \(selectedHub?.name ?? "this hub")?", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) {
                selectedHub = nil
            }
            Button("Yes, join!") {
                HapticFeedback.success()
                showProfileSetup = true
            }
        } message: {
            Text("You'll be locked in for 30 days. Make it count!")
        }
    }
    
    // MARK: - Profile Setup
    
    private var profileSetupContent: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Success banner
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Joined \(selectedHub?.name ?? "")!")
                        .font(.headline)
                    Spacer()
                    Text("Switch in 30 days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Photo picker
                VStack(alignment: .leading, spacing: 12) {
                    Text("Add photos (up to 3)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 3, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Select Photos")
                            Spacer()
                            Text("\(selectedPhotos.count)/3")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .onChange(of: selectedPhotos) { oldValue, newValue in
                        loadPhotos(newValue)
                    }
                    
                    // Photo preview
                    if !photoURLs.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(photoURLs, id: \.self) { url in
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .foregroundStyle(.gray)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Bio
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tell us about yourself (optional)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextField("Your bio...", text: $bio, axis: .vertical)
                        .lineLimit(3...5)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(AppColors.cardBackground)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // Complete button
                Button(action: completeOnboarding) {
                    Text("Start Vibing ✨")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [selectedHub?.colorValue ?? .blue, selectedHub?.colorValue.opacity(0.7) ?? .blue], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
            .padding(.vertical, 24)
        }
    }
    
    // MARK: - Actions
    
    private func loadPhotos(_ items: [PhotosPickerItem]) {
        // In production, load actual images
        // For MVP, just track count
        photoURLs = items.enumerated().map { "photo\($0.offset + 1)" }
    }
    
    private func completeOnboarding() {
        guard let hub = selectedHub, var user = authService.currentUser else { return }
        
        HapticFeedback.success()
        
        user.club = hub.id
        user.bio = bio
        user.photos = photoURLs
        user.clubJoinedDate = Date()
        
        Task {
            try? await authService.updateUser(user)
            
            // Small delay for UX
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            await MainActor.run {
                isComplete = true
            }
        }
    }
}

// MARK: - Hub Card

struct HubCard: View {
    let hub: Hub
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(hub.colorValue.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: hub.iconName)
                    .font(.system(size: 32))
                    .foregroundStyle(hub.colorValue)
            }
            
            Text(hub.name)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("\(hub.memberCount)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? hub.colorValue : Color.clear, lineWidth: 3)
        )
        .shadow(color: isSelected ? hub.colorValue.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 8 : 4, y: 2)
    }
}

#Preview {
    HubSelectionView()
}
