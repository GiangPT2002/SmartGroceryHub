//
//  SmartGroceryHubApp.swift
//  SmartGroceryHub
//
//  Created by Phạm Trường Giang on 9/2/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class SmartGroceryHubAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        #if targetEnvironment(simulator)
        return AppCheckDebugProviderFactory().createProvider(with: app)
        #else
        return AppAttestProvider(app: app)
        #endif
    }
}

@main
struct SmartGroceryHubApp: App {
    
    @StateObject private var appState = AppState()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    init() {
        AppCheck.setAppCheckProviderFactory(SmartGroceryHubAppCheckProviderFactory())
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
            .environmentObject(appState)
            .environmentObject(appState.mainVM)
            .environmentObject(appState.homeVM)
            .environmentObject(appState.cartVM)
            .environmentObject(appState.exploreVM)
            .environmentObject(appState.favoritesVM)
            .environmentObject(appState.orderVM)
            .overlay(alignment: .top) {
                // Global Toast
                if appState.showToast {
                    ToastView(
                        message: appState.toastMessage,
                        icon: appState.toastIcon,
                        color: appState.toastColor
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(999)
                }
            }
        }
    }
}

struct AppRootView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if mainVM.isUserLogin {
                NavigationStack {
                    MainTabView()
                }
            } else {
                NavigationStack {
                    WelcomeView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: hasSeenOnboarding)
        .animation(.easeInOut(duration: 0.4), value: mainVM.isUserLogin)
    }
}
