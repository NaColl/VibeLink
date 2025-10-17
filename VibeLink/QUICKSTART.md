# VibeLink - Quick Start Guide

Get the app running in **5 minutes** with offline sample data.

## 🚀 Fastest Path to Run

### Option 1: Offline Mode (No Setup Required)

1. **Open in Xcode**
   ```bash
   cd VibeLink
   open Package.swift  # Or drag folder to Xcode
   ```

2. **Wait for dependencies** (~30 seconds)
   - Xcode will fetch Firebase packages automatically

3. **Select simulator**
   - Choose any iPhone running iOS 17+
   - Recommended: iPhone 15 Pro

4. **Build and Run** (`Cmd+R`)
   - App launches with sample data
   - No Firebase connection needed
   - All features work with mock data

### Option 2: Firebase Connected (Production Ready)

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Create new project named "VibeLink"

2. **Add iOS App**
   - Bundle ID: `com.vibelink.app` (or your own)
   - Download `GoogleService-Info.plist`

3. **Add to Xcode**
   - Drag `GoogleService-Info.plist` into `VibeLink/VibeLink/` folder
   - Check "Copy items if needed"

4. **Enable Firebase**
   - Open `VibeLinkApp.swift`
   - Uncomment line: `FirebaseApp.configure()`

5. **Setup Firestore**
   - In Firebase Console → Firestore Database
   - Create database in test mode
   - Collections will be created automatically on first use

6. **Enable Auth**
   - Firebase Console → Authentication
   - Enable "Apple" sign-in provider
   - Add bundle ID

7. **Build and Run** (`Cmd+R`)

## 📱 Test Flow (Offline Mode)

### First Launch
1. **Onboarding Screen** appears
2. Tap "Sign in with Apple" (simulated - no actual Apple ID needed in dev)
3. Select a hub (try "Bookworms")
4. Optional: Add bio and photos
5. Tap "Start Vibing ✨"

### Explore Features
1. **Hub Feed**
   - Scroll through posts
   - Tap reactions (❤️, 😂, etc.)
   - Tap post → View comments
   - Add your own reply

2. **Vibe Kin Sidebar**
   - See 4 suggested matches on right side
   - Tap a user card
   - Answer icebreaker question
   - 70% chance of match!

3. **Weekly Progress**
   - Top banner shows "Day X/7"
   - Progress bar fills over time
   - Simulated timer (updates every hour)

4. **Chats Tab**
   - View 2 pre-existing matches
   - Tap to open conversation
   - Send messages
   - Try photo/voice buttons

5. **Vault Tab**
   - See your profile
   - View streaks and achievements
   - Try "Switch Club" (disabled for 30 days)
   - Settings and logout

## 🎯 Sample Users Available

All in "Bookworms" club:
- **Emma Rodriguez** - Fantasy reader
- **Jordan Kim** - Thriller fan  
- **Samira Patel** - Poetry lover
- **Marcus Johnson** - Sci-fi nerd
- **Lily Zhang** - Romance connoisseur

Current user: **Alex Chen** (you)

## 🧪 Testing Features

### Test Matching Flow
1. Go to Hub Home
2. Tap Vibe Kin on sidebar (e.g., Emma - 87% match)
3. Select question: "What's a book everyone loves that you secretly hate?"
4. Type answer: "The Alchemist"
5. Tap "Send Anonymously"
6. ~70% chance → "✨ Aligned!" screen
7. Tap "Unlock Chat" → Goes to chats

### Test Weekly Decision
1. Simulate week completion:
   - Open `WeeklyTimerService.swift`
   - Change `currentDay` to 7 in `updateProgress()`
2. Relaunch app
3. Full-screen modal appears: "Pick Your Sparks"
4. Swipe through Vibe Kin cards
5. Tap heart on up to 3 people
6. Tap "Complete Selection"
7. Week resets, matches appear in Chats

### Test Chat Features
1. Go to Chats tab
2. Tap "Emma Rodriguez"
3. Type message → Send
4. Long-press message → Report option
5. Try photo picker button
6. Menu (•••) → Mute/Report user

## 🐛 Troubleshooting

### "Cannot find FirebaseAuth in scope"
→ Wait for Xcode to finish fetching packages (bottom right status)

### App crashes on launch
→ Make sure iOS deployment target is 17.0+  
→ Check Xcode Console for specific error

### No sample data showing
→ Verify `SampleData.swift` is included in target  
→ Check `AuthService` has `currentUser` set

### Tab bar not showing
→ User must complete onboarding first  
→ Check `currentUser?.club` is not empty

### Previews not working
→ Enable Canvas: `Cmd+Opt+Return`  
→ Try "Cmd+Opt+P" to refresh preview

## 💡 Tips

1. **Preview Everything**: Each view has `#Preview` - use them!
2. **Haptic Feedback**: Run on device to feel the taps
3. **Dark Mode**: Works automatically with system setting
4. **Accessibility**: Enable VoiceOver to test labels
5. **State Reset**: Force quit app to reset to onboarding

## 📚 Sample Data Reference

- **20 Hubs**: From Bookworms to Pet Squad
- **10 Users**: 5 in Bookworms, rest distributed
- **8 Posts**: Mix of text, polls, events
- **4 Vibe Kin**: Pre-calculated matches
- **2 Matches**: With chat history
- **6 Messages**: Conversation thread

## 🎨 Customization

Want to tweak the vibe?

### Change Colors
Edit `Utils/Constants.swift`:
```swift
static let softBlue = Color(hex: "#YOUR_COLOR")
```

### Add More Hubs
Edit `Utils/SampleData.swift`:
```swift
Hub(id: "yourclub", name: "Your Club", iconName: "star.fill", ...)
```

### Modify Sample Posts
Edit `SampleData.swift` → `posts` array

## ✅ Ready to Build

You now have a complete, functional dating app MVP running locally!

**Next Steps**:
- Customize the UI/UX
- Add your Firebase config for production
- Implement Cloud Functions for weekly automation
- Deploy to TestFlight

---

**Need help?** Check inline code comments or README.md for architecture details.
