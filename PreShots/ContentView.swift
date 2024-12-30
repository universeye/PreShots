//
//  ContentView.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import ImportImagesFeature
import ImageResizeFeature
import RemoveAlphaFeature
import DestinationManager

struct ContentView: View {
    @StateObject private var viewModel = ImageImporterViewModel()
    @State private var isPresentTipSheet: Bool = false
    @State private var selectedFeature: AppFeatures = .batchImageResizer
    @State private var step = 1
    
    enum AppFeatures: Int, CaseIterable {
        case batchImageResizer = 0
        case imagesSetsExporter = 1
        case alphaRemover = 2
        
        var title: String {
            switch self {
            case .batchImageResizer:
                return "Batch Resizer"
            case .imagesSetsExporter:
                return "Xcode Images Sets"
            case .alphaRemover:
                return "Alpha Remover"
            }
        }
    }
    
    var body: some View {
        VStack {
            
            
            HStack {
                ImagesGridView(viewModel: viewModel)
                    .animation(.easeIn, value: selectedFeature)
                if !viewModel.images.isEmpty {
                    Divider()
                }
                VStack {
                    VStack(spacing: 20) {
                        Picker("Features", selection: $step) {
                            Text(AppFeatures.batchImageResizer.title)
                                .tag(1)
                            Text(AppFeatures.imagesSetsExporter.title)
                                .tag(2)
                            Text(AppFeatures.alphaRemover.title)
                                .tag(3)
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .padding(.horizontal)
                        .animation(.smooth, value: step)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        DestinationSetterButton()
                        switch step {
                        case 1:
                            ControlPanel(importerViewModel: viewModel)
                        case 2:
                            ImagesSetsControlView(importerViewModel: viewModel)
                        case 3:
                            RemoveAlphaControlView(importerViewModel: viewModel)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
//            Divider()
//                .padding(.top)
//            bottomSection()
        }
        .padding()
        .frame(minWidth: 1000, minHeight: 800)
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
