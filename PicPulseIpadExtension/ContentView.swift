//
//  ContentView.swift
//  PicPulseIpadExtension
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import ImportImagesFeature

struct ContentView: View {
    @StateObject private var viewModel = ImageImporterViewModel()
    
    var body: some View {
        VStack {
            ImagesGridView(viewModel: viewModel)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
