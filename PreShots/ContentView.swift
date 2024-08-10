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
                
                ShareLink("Share", item: "")
                    .buttonStyle(.link)
                
                Divider()
                    .frame(height: 25)
                
                Link(destination: URL(string: "https://apps.apple.com/app/id1624452493")!, label: {
                    Label("Rate PicPulse", systemImage: "star.fill")
                })
                
                Divider()
                    .frame(height: 25)
                
                Link(destination: URL(string: "https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://apps.apple.com/by/developer/tai-yu-kuo/id1585922485&ved=2ahUKEwjtm_3f0NqHAxV0b_UHHQdJPXQQFnoECBkQAQ&usg=AOvVaw37KxYmIROxj8fwoQgPx5tx")!, label: {
                    Label("See my other apps", systemImage: "apps.iphone")
                })
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $isPresentTipSheet, content: {
                TipsListView(isPresentTipSheet: $isPresentTipSheet)
            })
           
            Text("ⓒ 2024 universeye, designed & developed in Taipei, Taiwan")
                .foregroundStyle(.gray)
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

        }
        .padding()
        .frame(minWidth: 1000, minHeight: 800)
    }
}

#Preview {
    ContentView()
        .frame(height: 600)
}
