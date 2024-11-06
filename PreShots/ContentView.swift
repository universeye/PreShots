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
            HStack(spacing: 20) {
                Button(action: { self.step = 1 }, label: {
                    Text(AppFeatures.batchImageResizer.title)
                        .foregroundColor(step == 1 ? .primary : .secondary)
                        .padding()
//                        .background(Circle().shadow(radius: 5))
                        .scaleEffect(step == 1 ? 1 : 0.65)
                })
                
                Button(action: { self.step = 2 }, label: {
                    Text(AppFeatures.imagesSetsExporter.title)
                       .foregroundColor(step == 2 ? .primary : .secondary)
                        .padding()
//                        .background(Circle().shadow(radius: 5))
                        .scaleEffect(step == 2 ? 1 : 0.65)
                })
                
                Button(action: {self.step = 3 }, label: {
                    Text(AppFeatures.alphaRemover.title)
                        .foregroundColor(step == 3 ? .primary : .secondary)
                        .padding()
//                        .background(Circle().shadow(radius: 5))
                        .scaleEffect(step == 3 ? 1 : 0.65)
                })
            }
            .animation(.smooth, value: step)
//            .animation(.spring(response: 0.4, dampingFraction: 0.5))
            .font(.system(size: 20,weight: .bold,design: .rounded))
            
            ImagesGridView(viewModel: viewModel)
                .animation(.easeIn, value: selectedFeature)
            
            DestinationSetterButton()
            GeometryReader { geometryProxy in
                HStack {
                    ControlPanel(importerViewModel: viewModel)
                        .frame(height: 300)
                        .animation(.smooth, value: selectedFeature)
                        .frame(width: geometryProxy.frame(in: .global).width)
                        .opacity(step == 1 ? 1 : 0)
                    ImagesSetsControlView(importerViewModel: viewModel)
                        .frame(height: 300)
                        .animation(.smooth, value: selectedFeature)
                        .frame(width: geometryProxy.frame(in: .global).width)
                        .opacity(step == 2 ? 1 : 0)
                    RemoveAlphaControlView(importerViewModel: viewModel)
                        .frame(height: 300)
                        .animation(.smooth, value: selectedFeature)
                        .frame(width: geometryProxy.frame(in: .global).width)
                        .opacity(step == 3 ? 1 : 0)
                }
                .frame(width: geometryProxy.frame(in: .global).width * 3) //Make Hstack 3x width of device
                .offset(x: step == 1 ? 0
                            : step == 2 ? -geometryProxy.frame(in: .global).width
                            : -geometryProxy.frame(in: .global).width * 2)
                .animation(Animation.interpolatingSpring(stiffness: 50, damping: 8), value: step)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onEnded({ value in
                                        if value.translation.width < 0 {
                                            if step <= 2 {
                                                step += 1
                                            }
                                        }
                                        if value.translation.width > 0 {
                                            if step > 1 {
                                                step -= 1
                                            }
                                        }
                                    }))
            }
            Divider()
                .padding(.top)
            bottomSection()
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
