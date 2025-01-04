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
            if #available(macOS 15.0, *) {
                ContentView()
                    .containerBackground(
                        .thinMaterial, for: .window
                    )
                    .toolbarBackgroundVisibility(
                        .hidden, for: .windowToolbar
                    )
            } else {
                ContentView()
                
            }
        }
        .defaultSize(width: 800, height: 600)
//        .commands {
//            CommandGroup(after: .appInfo) {
//                CheckForUpdatesView(updater: updaterController.updater)
//            }
//        }
        
//        MenuBarExtra("My Menu Bar Extra", systemImage: "square.stack.3d.forward.dottedline") {
//            Text("Test")
//                .padding()
//        }
//        .menuBarExtraStyle(.window)
        
        Settings {
            TabView {
                GeneralSettingsView(updater: updaterController.updater)
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            
        }
        .defaultSize(width: 600, height: 800)
    }
}
