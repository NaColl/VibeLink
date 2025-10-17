//
//  PostCard.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct PostCard: View {
    let post: Post
    @State private var hasReacted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(colors: [.orange.opacity(0.3), .pink.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(post.userName.prefix(1)))
                            .font(.headline)
                            .foregroundStyle(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.userName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(post.createdAt.timeAgo())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: postTypeIcon)
                    .foregroundStyle(.secondary)
            }
            
            // Content
            Text(post.content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            // Poll options
            if post.type == .poll, let options = post.pollOptions {
                VStack(spacing: 8) {
                    ForEach(options) { option in
                        PollOptionRow(option: option, totalVotes: options.reduce(0) { $0 + $1.votes })
                    }
                }
            }
            
            // Event details
            if post.type == .event {
                HStack(spacing: 16) {
                    if let date = post.eventDate {
                        Label(date.formatted(style: .medium), systemImage: "calendar")
                            .font(.caption)
                    }
                    if let location = post.eventLocation {
                        Label(location.truncated(to: 20), systemImage: "location.fill")
                            .font(.caption)
                    }
                }
                .foregroundStyle(.secondary)
                
                if let rsvpCount = post.rsvpCount {
                    Text("\(rsvpCount) going")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.softGreen)
                }
            }
            
            Divider()
            
            // Reactions and replies
            HStack(spacing: 20) {
                // Reactions
                HStack(spacing: 4) {
                    ForEach(Array(post.reactions.keys.prefix(3)), id: \.self) { emoji in
                        Text(emoji)
                            .font(.caption)
                    }
                    if !post.reactions.isEmpty {
                        Text("\(post.reactions.values.reduce(0, +))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // Reply count
                Label("\(post.replyCount)", systemImage: "bubble.left")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    private var postTypeIcon: String {
        switch post.type {
        case .text:
            return "text.bubble"
        case .poll:
            return "chart.bar.fill"
        case .event:
            return "calendar.badge.clock"
        }
    }
}

struct PollOptionRow: View {
    let option: PollOption
    let totalVotes: Int
    
    var percentage: Double {
        guard totalVotes > 0 else { return 0 }
        return Double(option.votes) / Double(totalVotes)
    }
    
    var body: some View {
        HStack {
            Text(option.text)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(Int(percentage * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.softBlue.opacity(0.2))
                    .frame(width: geometry.size.width * percentage)
            }
        )
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            PostCard(post: SampleData.shared.posts[0])
            PostCard(post: SampleData.shared.posts[1])
            PostCard(post: SampleData.shared.posts[2])
        }
        .padding()
    }
    .background(AppColors.background)
}
