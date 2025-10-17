//
//  WeeklyDecisionView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct WeeklyDecisionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = AuthService.shared
    @StateObject private var firestoreService = FirestoreService.shared
    @StateObject private var timerService = WeeklyTimerService.shared
    
    @State private var vibeKins: [VibeKin] = []
    @State private var selectedKins: Set<String> = []
    @State private var currentIndex = 0
    @State private var showComplete = false
    
    let maxPicks = AppConstants.maxMatchesPerWeek
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                if !showComplete {
                    selectionContent
                } else {
                    completionContent
                }
            }
            .navigationTitle("Week's End")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(selectedKins.count)/\(maxPicks)")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            .task {
                await loadVibeKins()
            }
        }
    }
    
    // MARK: - Selection Content
    
    private var selectionContent: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 12) {
                Text("Pick Your Sparks")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Choose up to \(maxPicks) people to match with")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.top, 32)
            
            // Carousel
            if !vibeKins.isEmpty {
                TabView(selection: $currentIndex) {
                    ForEach(Array(vibeKins.enumerated()), id: \.element.id) { index, kin in
                        VibeKinDetailCard(
                            vibeKin: kin,
                            isSelected: selectedKins.contains(kin.kinUserId),
                            onHeart: { toggleSelection(kin) },
                            onPass: { nextCard() }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(height: 500)
            } else {
                Text("No potential matches this week")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.vertical, 100)
            }
            
            Spacer()
            
            // Done button
            Button(action: completeSelection) {
                Text("Complete Selection")
                    .font(.headline)
                    .foregroundStyle(AppColors.softGreen)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
            .disabled(selectedKins.isEmpty)
            .opacity(selectedKins.isEmpty ? 0.5 : 1)
        }
    }
    
    // MARK: - Completion Content
    
    private var completionContent: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundStyle(.white)
            
            Text("Week Complete!")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.white)
            
            VStack(spacing: 12) {
                Text("You matched with:")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                
                Text("\(selectedKins.count) \(selectedKins.count == 1 ? "person" : "people")")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Text("Check your chats to start connecting!")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                HapticFeedback.success()
                timerService.resetWeek()
                dismiss()
            }) {
                Text("Start New Week")
                    .font(.headline)
                    .foregroundStyle(AppColors.softGreen)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - Actions
    
    private func loadVibeKins() async {
        guard let userId = authService.currentUser?.id,
              let clubId = authService.currentUser?.club else { return }
        
        do {
            vibeKins = try await firestoreService.fetchVibeKin(for: userId, clubId: clubId)
        } catch {
            print("Error loading vibe kins: \(error)")
        }
    }
    
    private func toggleSelection(_ kin: VibeKin) {
        if selectedKins.contains(kin.kinUserId) {
            selectedKins.remove(kin.kinUserId)
            HapticFeedback.light()
        } else if selectedKins.count < maxPicks {
            selectedKins.insert(kin.kinUserId)
            HapticFeedback.success()
            nextCard()
        }
    }
    
    private func nextCard() {
        if currentIndex < vibeKins.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        }
    }
    
    private func completeSelection() {
        HapticFeedback.success()
        
        // Create matches in database
        Task {
            for kinUserId in selectedKins {
                let match = Match(
                    user1Id: authService.currentUser?.id ?? "",
                    user2Id: kinUserId,
                    status: .matched,
                    matchedAt: Date(),
                    clubId: authService.currentUser?.club ?? ""
                )
                try? await firestoreService.createMatch(match)
            }
            
            await MainActor.run {
                withAnimation {
                    showComplete = true
                }
            }
        }
    }
}

// MARK: - Vibe Kin Detail Card

struct VibeKinDetailCard: View {
    let vibeKin: VibeKin
    let isSelected: Bool
    let onHeart: () -> Void
    let onPass: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Photo section
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(colors: [.purple.opacity(0.4), .blue.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(height: 300)
                    .overlay(
                        Text(String(vibeKin.kinUserName.prefix(1)))
                            .font(.system(size: 100, weight: .bold))
                            .foregroundStyle(.white)
                    )
                
                if isSelected {
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
            
            // Info section
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(vibeKin.kinUserName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 20) {
                        Label("\(vibeKin.overlapPercentage)%", systemImage: "heart.fill")
                        Label("\(vibeKin.interactionCount)", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                }
                
                Text(vibeKin.kinUserBio)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Shared interests
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vibeKin.sharedInterests, id: \.self) { interest in
                            Text(interest)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(.white.opacity(0.2))
                                )
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                Text("\"\(vibeKin.teaserQuote)\"")
                    .font(.callout)
                    .italic()
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal)
                
                // Action buttons
                HStack(spacing: 24) {
                    Button(action: onPass) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(.white.opacity(0.2))
                            )
                    }
                    
                    Button(action: onHeart) {
                        Image(systemName: isSelected ? "heart.fill" : "heart")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .fill(isSelected ? Color.pink : .white.opacity(0.2))
                            )
                    }
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.opacity(0.1))
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    WeeklyDecisionView()
}
