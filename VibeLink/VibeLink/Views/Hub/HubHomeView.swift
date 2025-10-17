//
//  HubHomeView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct HubHomeView: View {
    @StateObject private var authService = AuthService.shared
    @StateObject private var timerService = WeeklyTimerService.shared
    @StateObject private var firestoreService = FirestoreService.shared
    
    @State private var posts: [Post] = []
    @State private var vibeKins: [VibeKin] = []
    @State private var selectedPost: Post?
    @State private var selectedVibeKin: VibeKin?
    @State private var showWeeklyDecision = false
    @State private var isLoading = true
    
    var hubName: String {
        SampleData.shared.hubs.first(where: { $0.id == authService.currentUser?.club })?.name ?? "Hub"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Weekly progress banner
                        WeeklyProgressView()
                            .padding(.horizontal)
                        
                        // Feed
                        VStack(spacing: 16) {
                            ForEach(posts) { post in
                                PostCard(post: post)
                                    .onTapGesture {
                                        HapticFeedback.light()
                                        selectedPost = post
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                
                // Vibe Kin sidebar
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        vibeKinSidebar
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 100)
            }
            .navigationTitle("\(hubName)")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await loadData()
            }
            .sheet(item: $selectedPost) { post in
                PostDetailView(post: post)
            }
            .sheet(item: $selectedVibeKin) { kin in
                ButtonMomentSheet(vibeKin: kin)
            }
            .fullScreenCover(isPresented: $showWeeklyDecision) {
                WeeklyDecisionView()
            }
            .onChange(of: timerService.isWeekComplete) { oldValue, newValue in
                if newValue {
                    showWeeklyDecision = true
                }
            }
        }
    }
    
    // MARK: - Vibe Kin Sidebar
    
    private var vibeKinSidebar: some View {
        VStack(spacing: 12) {
            Text("Vibe Kin")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            ForEach(vibeKins.prefix(4)) { kin in
                VibeKinMiniCard(vibeKin: kin)
                    .onTapGesture {
                        HapticFeedback.medium()
                        selectedVibeKin = kin
                    }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground.opacity(0.95))
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
        )
    }
    
    // MARK: - Data Loading
    
    private func loadData() async {
        guard let clubId = authService.currentUser?.club else { return }
        
        do {
            async let postsTask = firestoreService.fetchPosts(for: clubId)
            async let kinTask = firestoreService.fetchVibeKin(for: authService.currentUser?.id ?? "", clubId: clubId)
            
            posts = try await postsTask
            vibeKins = try await kinTask
            
            isLoading = false
        } catch {
            print("Error loading data: \(error)")
            isLoading = false
        }
    }
}

// MARK: - Weekly Progress View

struct WeeklyProgressView: View {
    @StateObject private var timerService = WeeklyTimerService.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Week Progress")
                        .font(.headline)
                    Text("Day \(timerService.currentDay)/7 - \(timerService.formattedTimeRemaining)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("\(Int(timerService.progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.softBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.primaryGradient)
                        .frame(width: geometry.size.width * timerService.progress)
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

// MARK: - Vibe Kin Mini Card

struct VibeKinMiniCard: View {
    let vibeKin: VibeKin
    
    var body: some View {
        VStack(spacing: 6) {
            // Photo placeholder
            Circle()
                .fill(
                    LinearGradient(colors: [.purple.opacity(0.3), .blue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(vibeKin.kinUserName.prefix(1)))
                        .font(.headline)
                        .foregroundStyle(.white)
                )
            
            Text("\(vibeKin.overlapPercentage)%")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.softGreen)
        }
    }
}

#Preview {
    HubHomeView()
}
