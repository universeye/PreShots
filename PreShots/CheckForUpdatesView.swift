//
//  CheckForUpdatesView.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/9/2.
//
//
//import SwiftUI
//import Sparkle
//
//final class CheckForUpdatesViewModel: ObservableObject {
//    @Published var canCheckForUpdates: Bool = false
//    
//    init(updater: SPUUpdater) {
//        updater.publisher(for: \.canCheckForUpdates).assign(to: &$canCheckForUpdates)
//    }
//}
//
//struct CheckForUpdatesView: View {
//    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
//    private let updater: SPUUpdater
//    
//    init(updater: SPUUpdater) {
//        self.updater = updater
//        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
//    }
//    
//    var body: some View {
//        Button {
//            updater.checkForUpdates()
//        } label: {
//            Text("Check for updates...")
//        }
//        .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
//
//    }
//}
