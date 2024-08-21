//
//  ContentView.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import ImportImagesFeature
import ImageResizeFeature
import AutoUpdates


struct ContentView: View {
    @StateObject private var viewModel = ImageImporterViewModel()
    @State private var isPresentTipSheet: Bool = false
    @State private var selectedFeature: AppFeatures = .batchImageResizer
    
    enum AppFeatures: CaseIterable {
        case batchImageResizer
        case imagesSetsExporter
        
        var title: String {
            switch self {
            case .batchImageResizer:
                return "Batch Resizer"
            case .imagesSetsExporter:
                return "Xcode Images Sets"
            }
        }
    }
    
    var body: some View {
        VStack {
            
            Picker("Feature", selection: $selectedFeature.animation(.easeInOut)) {
                ForEach(AppFeatures.allCases, id: \.self) {
                    Text($0.title)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(width: 300)
            
            ImagesGridView(viewModel: viewModel)
                .animation(.easeIn, value: selectedFeature)
            
            switch selectedFeature {
            case .batchImageResizer:
                ControlPanel(importerViewModel: viewModel)
                    .frame(height: 300)
                    .transition(.move(edge: .leading))
                    .animation(.smooth, value: selectedFeature)
            case .imagesSetsExporter:
                ImagesSetsControlView(importerViewModel: viewModel)
                    .frame(height: 300)
                    .transition(.move(edge: .trailing))
                    .animation(.smooth, value: selectedFeature)
            }
            
            bottomSection()
            

        }
        .padding()
        .frame(minWidth: 1000, minHeight: 800)
        .onFirstAppear {
            Updater.shared.checkForUpdates()
        }
    }
    
    @ViewBuilder
    private func bottomSection() -> some View {
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
                Image("appicon1024")
                   .resizable()
                   .scaledToFill()
                   .frame(width: 30, height: 20)
                   .padding(.leading, 10)
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
        Text("ⓒ 2024 Universeye, designed & developed in Taipei, Taiwan")
            .foregroundStyle(.gray)
            .font(.footnote)
            .padding(.top, 8)
        
    }
}

#Preview {
    ContentView()
        .frame(height: 900)
}
