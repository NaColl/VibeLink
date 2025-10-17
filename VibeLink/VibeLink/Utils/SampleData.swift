//
//  SampleData.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import Foundation

class SampleData {
    static let shared = SampleData()
    
    // MARK: - Current User
    
    var currentUser: User? = User(
        id: "user_current",
        fullName: "Alex Chen",
        email: "alex@vibelink.app",
        bio: "Book lover, coffee enthusiast, and weekend hiker. Always down for deep conversations about plot twists.",
        photos: ["photo1", "photo2", "photo3"],
        club: "Bookworms",
        clubJoinedDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
        engagementScore: 75
    )
    
    // MARK: - Hubs
    
    let hubs: [Hub] = [
        Hub(id: "bookworms", name: "Bookworms", iconName: "book.fill", description: "For readers & literature lovers", color: "#A8D8EA", memberCount: 1247),
        Hub(id: "hikers", name: "Trail Seekers", iconName: "figure.hiking", description: "Outdoor adventurers unite", color: "#B8E6D5", memberCount: 892),
        Hub(id: "gamers", name: "Pixel Pals", iconName: "gamecontroller.fill", description: "Gaming & esports community", color: "#F4ACB7", memberCount: 2103),
        Hub(id: "foodies", name: "Flavor Chasers", iconName: "fork.knife", description: "Food lovers & home chefs", color: "#FFE156", memberCount: 1567),
        Hub(id: "fitness", name: "Fit Fam", iconName: "figure.run", description: "Fitness & wellness crew", color: "#D4A5DA", memberCount: 1834),
        Hub(id: "artists", name: "Creative Souls", iconName: "paintbrush.fill", description: "Artists & makers", color: "#F4A582", memberCount: 945),
        Hub(id: "musicians", name: "Sound Wave", iconName: "music.note", description: "Musicians & music lovers", color: "#92C5DE", memberCount: 1123),
        Hub(id: "coders", name: "Code Collective", iconName: "chevron.left.forwardslash.chevron.right", description: "Developers & tech enthusiasts", color: "#C7E9B4", memberCount: 1456),
        Hub(id: "travelers", name: "Wanderlust", iconName: "airplane", description: "Travel enthusiasts", color: "#FDB863", memberCount: 1689),
        Hub(id: "yoga", name: "Zen Zone", iconName: "figure.mind.and.body", description: "Yoga & mindfulness", color: "#E0E4CC", memberCount: 723),
        Hub(id: "photographers", name: "Shutter Squad", iconName: "camera.fill", description: "Photography lovers", color: "#A6D4D1", memberCount: 1034),
        Hub(id: "dancers", name: "Rhythm Crew", iconName: "figure.dance", description: "Dancers of all styles", color: "#F4C2C2", memberCount: 678),
        Hub(id: "writers", name: "Word Weavers", iconName: "pencil.and.outline", description: "Writers & storytellers", color: "#D5A6BD", memberCount: 856),
        Hub(id: "cinephiles", name: "Film Buffs", iconName: "film.fill", description: "Movie & TV enthusiasts", color: "#FFD9A0", memberCount: 1290),
        Hub(id: "volunteers", name: "Good Vibes", iconName: "heart.fill", description: "Community helpers", color: "#B8D4E3", memberCount: 534),
        Hub(id: "boardgames", name: "Board Lords", iconName: "square.grid.3x3.fill", description: "Board game enthusiasts", color: "#E8B4D4", memberCount: 789),
        Hub(id: "astronomy", name: "Star Gazers", iconName: "sparkles", description: "Space & astronomy fans", color: "#A4C3D2", memberCount: 456),
        Hub(id: "gardeners", name: "Plant Parents", iconName: "leaf.fill", description: "Gardening & plant care", color: "#C8E6C9", memberCount: 612),
        Hub(id: "pets", name: "Pet Squad", iconName: "pawprint.fill", description: "Pet lovers unite", color: "#FFE4B5", memberCount: 1923),
        Hub(id: "meditation", name: "Mindful Moments", iconName: "sun.max.fill", description: "Meditation & peace", color: "#E6D7FF", memberCount: 501)
    ]
    
    // MARK: - Users
    
    let users: [User] = [
        User(id: "user1", fullName: "Emma Rodriguez", email: "emma@test.com", bio: "Fantasy reader, tea addict", photos: ["photo_emma"], club: "Bookworms", engagementScore: 82),
        User(id: "user2", fullName: "Jordan Kim", email: "jordan@test.com", bio: "Thriller fan, mystery solver", photos: ["photo_jordan"], club: "Bookworms", engagementScore: 68),
        User(id: "user3", fullName: "Samira Patel", email: "samira@test.com", bio: "Poetry lover, book club host", photos: ["photo_samira"], club: "Bookworms", engagementScore: 91),
        User(id: "user4", fullName: "Marcus Johnson", email: "marcus@test.com", bio: "Sci-fi nerd, speed reader", photos: ["photo_marcus"], club: "Bookworms", engagementScore: 77),
        User(id: "user5", fullName: "Lily Zhang", email: "lily@test.com", bio: "Romance connoisseur, writer wannabe", photos: ["photo_lily"], club: "Bookworms", engagementScore: 85)
    ]
    
    // MARK: - Posts
    
    var posts: [Post] = [
        Post(
            id: "post1",
            userId: "user1",
            userName: "Emma Rodriguez",
            userPhoto: "photo_emma",
            type: .text,
            content: "Just finished 'The Midnight Library' and I'm SOBBING. Who else read this and felt personally attacked by every single alternate reality? 😭",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            reactions: ["❤️": 12, "😭": 8, "📚": 5],
            replyCount: 7
        ),
        Post(
            id: "post2",
            userId: "user2",
            userName: "Jordan Kim",
            userPhoto: "photo_jordan",
            type: .poll,
            content: "Settling a debate: What's the WORST book-to-movie adaptation?",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
            reactions: ["🤔": 15, "😤": 6],
            replyCount: 23,
            pollOptions: [
                PollOption(text: "Percy Jackson (2010)", votes: 34),
                PollOption(text: "Eragon", votes: 52),
                PollOption(text: "Artemis Fowl", votes: 28),
                PollOption(text: "The Dark Tower", votes: 19)
            ]
        ),
        Post(
            id: "post3",
            userId: "user3",
            userName: "Samira Patel",
            userPhoto: "photo_samira",
            type: .event,
            content: "Virtual book club this Saturday! We're discussing 'Project Hail Mary'. Drinks encouraged, spoilers mandatory. 🚀📖",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            reactions: ["🎉": 18, "🍷": 9],
            replyCount: 12,
            eventDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            eventLocation: "Zoom (link in comments)",
            rsvpCount: 24
        ),
        Post(
            id: "post4",
            userId: "user4",
            userName: "Marcus Johnson",
            userPhoto: "photo_marcus",
            type: .text,
            content: "Hot take: Audiobooks ARE real reading and I'm tired of pretending they're not. Finishing 100+ books a year thanks to my commute 🎧",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!,
            reactions: ["💯": 24, "👀": 11, "📱": 7],
            replyCount: 31
        ),
        Post(
            id: "post5",
            userId: "user5",
            userName: "Lily Zhang",
            userPhoto: "photo_lily",
            type: .poll,
            content: "Unpopular opinion time! Which romance trope is overrated?",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .hour, value: -12, to: Date())!,
            reactions: ["😱": 19, "👀": 14],
            replyCount: 45,
            pollOptions: [
                PollOption(text: "Enemies to Lovers", votes: 12),
                PollOption(text: "Second Chance", votes: 8),
                PollOption(text: "Forced Proximity", votes: 23),
                PollOption(text: "Fake Dating", votes: 31)
            ]
        ),
        Post(
            id: "post6",
            userId: "user1",
            userName: "Emma Rodriguez",
            userPhoto: "photo_emma",
            type: .text,
            content: "Currently reading 5 books at once and starting a 6th. Yes I have a problem. No I won't stop. Send help (or book recs) 📚😅",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            reactions: ["😂": 16, "📚": 12],
            replyCount: 18
        ),
        Post(
            id: "post7",
            userId: "user3",
            userName: "Samira Patel",
            userPhoto: "photo_samira",
            type: .text,
            content: "Found my childhood copy of 'Harry Potter' and the margins are FILLED with 12-year-old me's theories. Some were... surprisingly close 👀⚡",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            reactions: ["⚡": 28, "📖": 15, "💕": 10],
            replyCount: 22
        ),
        Post(
            id: "post8",
            userId: "user2",
            userName: "Jordan Kim",
            userPhoto: "photo_jordan",
            type: .event,
            content: "Bookstore crawl next Sunday! Hitting 3 indie stores, hunting for hidden gems. Who's in? 🏪📚",
            clubId: "bookworms",
            createdAt: Calendar.current.date(byAdding: .hour, value: -15, to: Date())!,
            reactions: ["📚": 21, "🚶": 13],
            replyCount: 16,
            eventDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            eventLocation: "Meet at Book Culture (2:00 PM)",
            rsvpCount: 18
        )
    ]
    
    // MARK: - Replies
    
    var replies: [Reply] = [
        Reply(id: "reply1", postId: "post1", userId: "user2", userName: "Jordan Kim", userPhoto: "photo_jordan", content: "That book WRECKED me. The librarian's wisdom hits different when you're going through it 😭", createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!),
        Reply(id: "reply2", postId: "post1", userId: "user3", userName: "Samira Patel", userPhoto: "photo_samira", content: "Reading it right now and already crying at page 50... what have I gotten into", createdAt: Calendar.current.date(byAdding: .minute, value: -45, to: Date())!),
        Reply(id: "reply3", postId: "post4", userId: "user5", userName: "Lily Zhang", userPhoto: "photo_lily", content: "THANK YOU! Also the narrators bring so much life to the characters ❤️", createdAt: Calendar.current.date(byAdding: .hour, value: -7, to: Date())!)
    ]
    
    // MARK: - Vibe Kin
    
    var vibeKins: [VibeKin] = [
        VibeKin(
            id: "kin1",
            userId: "user_current",
            kinUserId: "user1",
            kinUserName: "Emma Rodriguez",
            kinUserPhoto: "photo_emma",
            kinUserBio: "Fantasy reader, tea addict",
            overlapPercentage: 87,
            interactionCount: 12,
            sharedInterests: ["Fantasy", "Tea", "Book clubs"],
            teaserQuote: "Just finished 'The Midnight Library' and I'm SOBBING...",
            clubId: "bookworms"
        ),
        VibeKin(
            id: "kin2",
            userId: "user_current",
            kinUserId: "user3",
            kinUserName: "Samira Patel",
            kinUserPhoto: "photo_samira",
            kinUserBio: "Poetry lover, book club host",
            overlapPercentage: 92,
            interactionCount: 18,
            sharedInterests: ["Poetry", "Book clubs", "Deep conversations"],
            teaserQuote: "Found my childhood copy of 'Harry Potter' and the margins...",
            clubId: "bookworms"
        ),
        VibeKin(
            id: "kin3",
            userId: "user_current",
            kinUserId: "user5",
            kinUserName: "Lily Zhang",
            kinUserPhoto: "photo_lily",
            kinUserBio: "Romance connoisseur, writer wannabe",
            overlapPercentage: 78,
            interactionCount: 9,
            sharedInterests: ["Romance", "Writing", "Character analysis"],
            teaserQuote: "Unpopular opinion time! Which romance trope is overrated?",
            clubId: "bookworms"
        ),
        VibeKin(
            id: "kin4",
            userId: "user_current",
            kinUserId: "user2",
            kinUserName: "Jordan Kim",
            kinUserPhoto: "photo_jordan",
            kinUserBio: "Thriller fan, mystery solver",
            overlapPercentage: 81,
            interactionCount: 14,
            sharedInterests: ["Thrillers", "Plot twists", "Book-to-movie"],
            teaserQuote: "Settling a debate: What's the WORST book-to-movie...",
            clubId: "bookworms"
        )
    ]
    
    // MARK: - Icebreaker Questions
    
    let icebreakerQuestions: [String: [String]] = [
        "bookworms": [
            "What's a book everyone loves that you secretly hate?",
            "Worst plot twist you've ever read?",
            "If you could live in any book's world, where?",
            "What's your most embarrassing book crush?",
            "Dog-ear pages or never? (Choose wisely)"
        ],
        "hikers": [
            "Sunrise or sunset hike?",
            "Scariest wildlife encounter?",
            "Trail snack of choice?",
            "Mountains or beaches?",
            "Solo hike or group adventure?"
        ],
        "gamers": [
            "PC or console? (Fight me)",
            "Most rage-quit game?",
            "Favorite gaming snack?",
            "Single-player or multiplayer?",
            "Game that made you cry?"
        ]
    ]
    
    // MARK: - Matches
    
    var matches: [Match] = [
        Match(
            id: "match1",
            user1Id: "user_current",
            user2Id: "user1",
            status: .matched,
            matchedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            clubId: "bookworms",
            icebreakerQuestion: "What's a book everyone loves that you secretly hate?",
            user1Answer: "The Alchemist. There, I said it. Come at me.",
            user2Answer: "1984. Too depressing. Give me escapism!",
            contextPost: "post1"
        ),
        Match(
            id: "match2",
            user1Id: "user_current",
            user2Id: "user3",
            status: .matched,
            matchedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            clubId: "bookworms",
            icebreakerQuestion: "If you could live in any book's world, where?",
            user1Answer: "Hogwarts, obviously. I'd be a Ravenclaw.",
            user2Answer: "Middle Earth! I'd live in the Shire and never leave.",
            contextPost: "post3"
        )
    ]
    
    // MARK: - Messages
    
    var messages: [Message] = [
        Message(id: "msg1", matchId: "match1", senderId: "user1", receiverId: "user_current", type: .text, content: "OMG finally someone who gets it! Everyone worships that book 😂", createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, isRead: true),
        Message(id: "msg2", matchId: "match1", senderId: "user_current", receiverId: "user1", type: .text, content: "RIGHT?! I felt so alone. But 1984 is a masterpiece how dare you 👀", createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!.addingTimeInterval(300), isRead: true),
        Message(id: "msg3", matchId: "match1", senderId: "user1", receiverId: "user_current", type: .text, content: "Haha fair! We can agree to disagree. So what ARE you reading right now?", createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!.addingTimeInterval(600), isRead: true),
        Message(id: "msg4", matchId: "match1", senderId: "user_current", receiverId: "user1", type: .text, content: "Just started Project Hail Mary! Heard it's amazing. You?", createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!, isRead: false),
        Message(id: "msg5", matchId: "match2", senderId: "user3", receiverId: "user_current", type: .text, content: "A fellow Ravenclaw! 💙 Though I'd probably visit Hogwarts then hide in the Shire forever lol", createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, isRead: true),
        Message(id: "msg6", matchId: "match2", senderId: "user_current", receiverId: "user3", type: .text, content: "That's the dream combo honestly. Saw you're hosting that virtual book club!", createdAt: Calendar.current.date(byAdding: .hour, value: -12, to: Date())!, isRead: false)
    ]
}
