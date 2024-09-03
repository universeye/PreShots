//
//  PreShotsApp.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import RevenueCat
import Sparkle

@main
struct PreShotsApp: App {
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: APIKey.revenueCatId)
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 800, height: 600)
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: updaterController.updater)
            }
        }
        
        Settings {
            TabView {
                GeneralSettingsView(updater: updaterController.updater)
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            
        }
        .defaultSize(width: 600, height: 800)
    }
}
