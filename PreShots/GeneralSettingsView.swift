//
//  GeneralSettingsView.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/8/20.
//

import SwiftUI
import DestinationManager
//import Sparkle

struct GeneralSettingsView: View {
    @State private var isShowWelcome = false
    @State private var settingTwoValue = false
    @State private var isPresentTipSheet: Bool = false
    @State private var destinationURLString: String = ""
    @AppStorage("autoRemoveImage") var autoRemoveImage: Bool = false
//    private var updater: SPUUpdater?
    
//    init(updater: SPUUpdater?) {
//        self.updater = updater
//    }
    
    var body: some View {
        Form {
            HStack {
                Text("Welcom to PicPulse!")
            }
            .bold()
            .frame(maxWidth: .infinity)
            .opacity(isShowWelcome ? 1 : 0)
            
            
            Section {
//                Toggle(isOn: $settingTwoValue, label: {
//                    Label("Launch at login", systemImage: "desktopcomputer")
//                })
                
                Toggle(isOn: $autoRemoveImage, label: {
                    Label("Auto remove image after exporting", systemImage: "trash")
                })
                .toggleStyle(.checkbox)
                
                LabeledContent {
                    HStack {
                        Text(destinationURLString)
                        if let _ =  DestinationFolderManager.shared.accessSavedFolder() {
                            Button {
                                DestinationFolderManager.shared.openFolder()
                            } label: {
                               Image(systemName: "arrow.up.right")
                            }
                        }
                       
                        
                        Button(action: {
                            DestinationFolderManager.shared.requestDownloadsFolderPermission()
                            if let downloadsFolderUrl =  DestinationFolderManager.shared.accessSavedFolder() {
                                withAnimation {
                                    self.destinationURLString = downloadsFolderUrl.absoluteString
                                }
                                
                            }
                        }) {
                            Text("Change")
                        }
                        .buttonStyle(.link)
                    }
                } label: {
                    Label("Destination Folder", systemImage: "folder")
                }
                .onAppear {
                    if let downloadsFolderUrl =  DestinationFolderManager.shared.accessSavedFolder() {
                        self.destinationURLString = downloadsFolderUrl.absoluteString
                    }
                }
                
            } header: {
                Text("General")
            }
            
            
            Section {
                ShareLink("Share", item: Links.getLink(link: .shareApp)!.absoluteString)
                    .buttonStyle(.link)
                
                Link(destination: Links.getLink(link: .myOtherApps)!, label: {
                    Label("See my other apps", systemImage: "apps.iphone")
                })
                
                Link(destination: Links.getLink(link: .rateAppStore)!, label: {
                    Label("Rate PicPulse in App store", systemImage: "star")
                })
                
                Button {
                    isPresentTipSheet.toggle()
                } label: {
                    Label("Tips me", systemImage: "heart")
                }
                .buttonStyle(.link)
                .sheet(isPresented: $isPresentTipSheet, content: {
                    TipsListView(isPresentTipSheet: $isPresentTipSheet)
                })

//                Button {
//                    if let updater = updater {
//                        updater.checkForUpdates()
//                    }
//                } label: {
//                    Label("Check for updates", systemImage: "arrow.down.circle")
//                }
//                .buttonStyle(.link)
                
            }
            
            Section {
                Link(destination: Links.getLink(link: .email)!, label: {
                    Label("Bugs Report/Feature Request", systemImage: "envelope")
                })
                Link(destination: Links.getLink(link: .twitterTerry)!, label: {
                    HStack {
                        Image("twitterlogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:  25, height: 25)
                        Text("X(Twitter)")
                    }
                })
                Link(destination: Links.getLink(link: .lilredbook)!, label: {
                    HStack {
                        Image("XiaohongshuLOGO")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("RED")
                    }
                })
                Link(destination: Links.getLink(link: .thread)!, label: {
                    HStack {
                        Image("threadslogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Threads")
                    }
                })
                Link(destination: Links.getLink(link: .mastadon)!, label: {
                    HStack {
                        Image("mastodon_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Mastodon")
                    }
                })
            } header: {
                Text("Contact")
            } footer: {
                VStack {
                    Image("appicon1024")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                    Text("\(NSLocalizedString("Version", comment: "Version")) \(getAppVersion())(\(getBuildNumber()))")
                    Text("© 2024 Universeye")
                }
                .frame(maxWidth: .infinity)
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 450, minHeight: 200)
        .navigationTitle("PicPulse Settings")
        .onAppear {
            withAnimation {
                isShowWelcome.toggle()
            }
        }

    }
    
    private func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "Unknown"
    }
    
    private func getBuildNumber() -> String {
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "Unknown"
    }
}

#Preview {
    GeneralSettingsView(/*updater: nil*/)
}
