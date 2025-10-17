//
//  MainTabView.swift
//  VibeLink
//
//  Created on 2025-10-17.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HubHomeView()
                .tabItem {
                    Label("Hub", systemImage: "house.fill")
                }
                .tag(0)
            
            ChatListView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
                .tag(1)
            
            VaultView()
                .tabItem {
                    Label("Vault", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(AppColors.softBlue)
    }
}

#Preview {
    MainTabView()
}
