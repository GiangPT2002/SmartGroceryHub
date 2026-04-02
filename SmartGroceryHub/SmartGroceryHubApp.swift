//
//  SmartGroceryHubApp.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 9/2/25.
//

import SwiftUI
import FirebaseCore

@main
struct SmartGroceryHubApp: App {
    
    @StateObject var mainVM = MainViewModel.shared
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !hasSeenOnboarding {
                    OnboardingView()
                } else if mainVM.isUserLogin {
                    MainTabView()
                } else {
                    WelcomeView()
                }
            }
        }
    }
}
