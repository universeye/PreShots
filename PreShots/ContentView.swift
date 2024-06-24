//
//  ContentView.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import ImportImagesFeature
import ImageResizeFeature

struct ContentView: View {
    @StateObject private var viewModel = ImageImporterViewModel()
    
    var body: some View {
        VStack {
            ImagesGridView(viewModel: viewModel)
            ControlPanel(importerViewModel: viewModel)
        }
        .padding()
        .frame(minWidth: 500)
    }
}

#Preview {
    ContentView()
        .frame(height: 600)
}
