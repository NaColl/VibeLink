//
//  ButtonMomentSheet.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct ButtonMomentSheet: View {
    let vibeKin: VibeKin
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = AuthService.shared
    @StateObject private var firestoreService = FirestoreService.shared
    
    @State private var selectedQuestion = ""
    @State private var userAnswer = ""
    @State private var showResult = false
    @State private var isMatch = false
    @State private var otherUserAnswer = ""
    @State private var alignmentPercentage = 0
    
    var questions: [String] {
        SampleData.shared.icebreakerQuestions[authService.currentUser?.club ?? "bookworms"] ?? []
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                if !showResult {
                    questionContent
                } else {
                    resultContent
                }
            }
            .navigationTitle("Sync Vibes?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
            .onAppear {
                selectedQuestion = questions.first ?? ""
            }
        }
    }
    
    // MARK: - Question Content
    
    private var questionContent: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Vibe Kin info
            VStack(spacing: 16) {
                Circle()
                    .fill(
                        LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(String(vibeKin.kinUserName.prefix(1)))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.white)
                    )
                
                Text(vibeKin.kinUserName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("\(vibeKin.overlapPercentage)% vibe overlap")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            // Question picker
            VStack(spacing: 20) {
                Text("Pick an icebreaker:")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Picker("Question", selection: $selectedQuestion) {
                    ForEach(questions, id: \.self) { question in
                        Text(question)
                            .tag(question)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.2))
                )
            }
            
            // Answer input
            VStack(alignment: .leading, spacing: 12) {
                Text("Your answer:")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                TextField("Type here...", text: $userAnswer, axis: .vertical)
                    .lineLimit(2...4)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                    )
            }
            
            // Send button
            Button(action: sendIcebreaker) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Send Anonymously")
                }
                .font(.headline)
                .foregroundStyle(AppColors.softBlue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .cornerRadius(16)
            }
            .disabled(userAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(userAnswer.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
            
            Spacer()
        }
        .padding(24)
    }
    
    // MARK: - Result Content
    
    private var resultContent: some View {
        VStack(spacing: 32) {
            Spacer()
            
            if isMatch {
                // Match result
                VStack(spacing: 24) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                    
                    Text("\(alignmentPercentage)% Aligned!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("You both answered:")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.9))
                    
                    VStack(spacing: 16) {
                        answerBubble(label: "You", answer: userAnswer)
                        answerBubble(label: vibeKin.kinUserName, answer: otherUserAnswer)
                    }
                    
                    Button(action: unlockChat) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Unlock Chat")
                        }
                        .font(.headline)
                        .foregroundStyle(AppColors.softGreen)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .cornerRadius(16)
                    }
                }
            } else {
                // No match result
                VStack(spacing: 24) {
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                    
                    Text("No Spark This Time")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Keep vibing in the feed!")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Button(action: { dismiss() }) {
                        Text("Back to Hub")
                            .font(.headline)
                            .foregroundStyle(AppColors.softBlue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(16)
                    }
                }
            }
            
            Spacer()
        }
        .padding(24)
    }
    
    private func answerBubble(label: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.8))
            
            Text(answer)
                .font(.body)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.2))
                )
        }
    }
    
    // MARK: - Actions
    
    private func sendIcebreaker() {
        HapticFeedback.medium()
        
        // Simulate matching algorithm (70% success rate)
        let randomValue = Int.random(in: 1...100)
        isMatch = randomValue <= 70
        
        if isMatch {
            // Generate simulated alignment and answer
            alignmentPercentage = Int.random(in: 65...95)
            otherUserAnswer = generateSimulatedAnswer()
            
            // Create match in database
            let match = Match(
                user1Id: authService.currentUser?.id ?? "",
                user2Id: vibeKin.kinUserId,
                status: .matched,
                matchedAt: Date(),
                clubId: authService.currentUser?.club ?? "",
                icebreakerQuestion: selectedQuestion,
                user1Answer: userAnswer,
                user2Answer: otherUserAnswer
            )
            
            Task {
                try? await firestoreService.createMatch(match)
                HapticFeedback.success()
            }
        } else {
            HapticFeedback.light()
        }
        
        withAnimation {
            showResult = true
        }
    }
    
    private func generateSimulatedAnswer() -> String {
        let answers = [
            "Honestly? Probably an unpopular opinion but...",
            "Oh this is tough! I'd have to say...",
            "I've thought about this SO much...",
            "Hot take incoming...",
            "Can I pick two? No? Fine then..."
        ]
        return answers.randomElement() ?? ""
    }
    
    private func unlockChat() {
        HapticFeedback.success()
        dismiss()
        // In production, navigate to chat
    }
}

#Preview {
    ButtonMomentSheet(vibeKin: SampleData.shared.vibeKins[0])
}
