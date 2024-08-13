//
//  ContentView.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import ImportImagesFeature
import ImageResizeFeature
import RevenueCat
import AutoUpdates
import AppKit

struct ContentView: View {
    @StateObject private var viewModel = ImageImporterViewModel()
    @State private var isPresentTipSheet: Bool = false
    
    var body: some View {
        VStack {
            ImagesGridView(viewModel: viewModel)
            ControlPanel(importerViewModel: viewModel)
            
            HStack {
                Button {
                    isPresentTipSheet.toggle()
                } label: {
                    Text("Tip me😎")
                }
                .buttonStyle(.link)
                
                Divider()
                    .frame(height: 25)
                
                ShareLink("Share", item: Links.getLink(link: .shareApp)!.absoluteString)
                    .buttonStyle(.link)
                
                Divider()
                    .frame(height: 25)
                
                Link(destination: Links.getLink(link: .rateAppStore)!, label: {
                    Label("Rate PicPulse", systemImage: "star.fill")
                })
                
                Divider()
                    .frame(height: 25)
                
                Link(destination: Links.getLink(link: .myOtherApps)!, label: {
                    Label("See my other apps", systemImage: "apps.iphone")
                })
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $isPresentTipSheet, content: {
                TipsListView(isPresentTipSheet: $isPresentTipSheet)
            })
            
            if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                HStack {
                    Text("PicPulse v\(currentVersion)")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    Button {
                        Updater.shared.checkForUpdates(withAlert: true)
                    } label: {
                        Text("Check for updates")
                            .font(.footnote)
                    }
                    .buttonStyle(.link)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
            
            Text("ⓒ 2024 universeye, designed & developed in Taipei, Taiwan")
                .foregroundStyle(.gray)
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

        }
        .padding()
        .frame(minWidth: 1000, minHeight: 800)
        .onFirstAppear {
            Updater.shared.checkForUpdates()
        }
    }
}

#Preview {
    ContentView()
        .frame(height: 600)
}
