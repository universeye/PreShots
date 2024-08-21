//
//  PreShotsApp.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import RevenueCat

@main
struct PreShotsApp: App {
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: APIKey.revenueCatId)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 800, height: 600)
        
        Settings {
            TabView {
                GeneralSettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            
        }
        .defaultSize(width: 600, height: 800)
    }
}
