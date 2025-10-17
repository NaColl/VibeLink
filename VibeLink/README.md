# VibeLink - Dating App MVP

A SwiftUI-based dating app disguised as hobby clubs, designed to fight Tinder burnout through natural, time-bound connections.

## 🎯 Core Philosophy

- **Simple**: Under 60 seconds onboarding
- **Sticky**: Weekly rituals that keep users engaged
- **Natural**: Matching emerges from hub interactions, not swipes
- **Time-bound**: One week per cycle - no endless scrolling

## 🏗️ Architecture

### Tech Stack
- **iOS**: 17+ (iPhone only, portrait-first)
- **UI Framework**: SwiftUI
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Language**: Swift 5.9+

### Project Structure

```
VibeLink/
├── Models/
│   ├── User.swift
│   ├── Hub.swift
│   ├── Post.swift
│   ├── VibeKin.swift
│   ├── Match.swift
│   └── Message.swift
├── Services/
│   ├── AuthService.swift
│   ├── FirestoreService.swift
│   └── WeeklyTimerService.swift
├── Utils/
│   ├── Constants.swift
│   ├── Extensions.swift
│   └── SampleData.swift
├── Views/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift
│   │   └── HubSelectionView.swift
│   ├── Hub/
│   │   ├── HubHomeView.swift
│   │   ├── ButtonMomentSheet.swift
│   │   └── WeeklyDecisionView.swift
│   ├── Chat/
│   │   ├── ChatListView.swift
│   │   └── ChatDetailView.swift
│   ├── Vault/
│   │   └── VaultView.swift
│   ├── Components/
│   │   ├── PostCard.swift
│   │   └── PostDetailView.swift
│   └── MainTabView.swift
└── VibeLinkApp.swift
```

## 🚀 Features

### 1. Onboarding (<60 seconds)
- Apple Sign-In integration
- Hub selection from 20 curated communities
- Optional profile setup (bio + 3 photos)
- 30-day club lock-in period

### 2. Hub Home Feed
- Time-bound weekly cycles (Day 1-7 progress tracking)
- Interactive posts: text shares, polls, events
- Reactions and threaded comments
- Vibe Kin sidebar showing compatible users

### 3. Matching System
- **Vibe Kin**: AI-scored compatibility based on interactions
- **Button Moment**: Icebreaker questions for mutual interest
- **Weekly Decision**: End-of-week match selection (max 3 picks)
- Context-aware matching (remembers which post sparked connection)

### 4. Chat System
- Unlocked only after mutual matches
- Text, image, and voice messages (voice is stubbed)
- Context labels showing origin of connection
- Report/mute functionality for safety

### 5. Vault (Profile & Settings)
- Streaks and achievements
- Personalized nudges
- Club switching (with 30-day cooldown)
- Privacy and safety controls

## 📦 Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ device or simulator
- Firebase project (for production)

### Installation

1. **Clone the repository**
   ```bash
   cd /path/to/project
   ```

2. **Firebase Setup** (for production use)
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Add an iOS app with bundle ID: `com.vibelink.app`
   - Download `GoogleService-Info.plist`
   - Add it to the VibeLink project in Xcode
   - Uncomment `FirebaseApp.configure()` in `VibeLinkApp.swift`

3. **Install Dependencies**
   - Open `Package.swift` in Xcode
   - Xcode will automatically fetch Firebase dependencies
   - Or use Swift Package Manager:
     ```bash
     swift package resolve
     ```

4. **Build and Run**
   - Open the project in Xcode
   - Select iPhone simulator (iOS 17+)
   - Press `Cmd+R` to build and run

### Offline Development

The app includes extensive sample data for offline development:
- 10+ fake users with profiles
- 20 curated hub communities
- Sample posts, polls, and events
- Pre-configured Vibe Kin matches
- Mock chat conversations

All data is stored in `SampleData.swift` and works without Firebase connection.

## 🎨 Design System

### Colors (Pastel Theme)
- **Soft Blue**: `#A8D8EA`
- **Soft Green**: `#B8E6D5`
- **Soft Pink**: `#F4ACB7`
- **Soft Purple**: `#D4A5DA`
- **Soft Yellow**: `#FFE156`

### Typography
- System font: SF Pro (Apple's default)
- Rounded design for friendly feel
- Dynamic Type support for accessibility

### Components
- Cards with subtle shadows
- 16px corner radius standard
- Haptic feedback on interactions
- Smooth animations and transitions

## 🔐 Privacy & Safety

- **Rate Limiting**: 1 post per hour to prevent spam
- **Reporting**: One-tap report on messages and posts
- **Moderation**: Firestore flags for admin review
- **Data Privacy**: Minimal data collection, anonymous icebreakers

## 📱 Screen Flows

1. **Onboarding** → Apple Sign-In → Hub Selection → Profile Setup
2. **Hub Home** → Browse Feed → React/Comment → Discover Vibe Kin
3. **Button Moment** → Pick Question → Answer → Match/No Match
4. **Weekly Decision** → Review Vibe Kin → Select Matches (max 3)
5. **Chat** → Unlocked Matches → Message Exchange

## 🧪 Testing

### Preview Support
Every view includes SwiftUI Previews for rapid development:
```swift
#Preview {
    OnboardingView()
}
```

### Sample Data
Use `SampleData.shared` to test all features offline:
- 5 sample users in Bookworms club
- 8+ posts with various types
- 4 Vibe Kin suggestions
- 2 existing matches with chat history

## 🚧 Future Enhancements

- [ ] Push notifications for matches and messages
- [ ] Cloud Functions for weekly cycle automation
- [ ] Advanced matching algorithm with ML
- [ ] Voice message playback (currently stubbed)
- [ ] Profile editing and photo management
- [ ] Hub statistics and insights
- [ ] Premium features (hub switching without cooldown)

## 📄 License

Copyright © 2025 VibeLink. All rights reserved.

## 🤝 Contributing

This is an MVP codebase. For production use:
1. Set up proper Firebase project
2. Implement production authentication
3. Add error handling and loading states
4. Implement actual image upload to Firebase Storage
5. Add analytics and crash reporting
6. Implement proper background task scheduling for weekly resets

## 📞 Support

For questions or issues, please refer to the inline code documentation.

---

**Built with ❤️ using SwiftUI**
