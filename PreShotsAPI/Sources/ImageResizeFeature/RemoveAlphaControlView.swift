//
//  RemoveAlphaControlView.swift
//  PreShotsAPI
//
//  Created by Terry Kuo on 2024/11/5.
//

import SwiftUI
import ImportImagesFeature
//import DestinationManager
import RemoveAlphaFeature

public struct RemoveAlphaControlView: View {
    @ObservedObject var importerViewModel: ImageImporterViewModel
    @StateObject private var viewModel = RemoveAlphaViewModel()
    
    public init(importerViewModel: ImageImporterViewModel) {
        self.importerViewModel = importerViewModel
    }
    
    public var body: some View {
        VStack {
            
            
            if viewModel.outputState == .loading {
                ProgressView()
                    .progressViewStyle(.linear)
            }
            
            HStack {
                Spacer()
                Button {
                    viewModel.resizeRemoveAlphaAndSaveImages(images: importerViewModel.images) {}
                } label: {
                    Text("Remove Alpha")
                        .font(.system(size: 14, weight: .bold))
                        .padding()
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 50)
                        .background(.blue.gradient)
                        .clipShape(.rect(cornerRadius: 13))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    RemoveAlphaControlView(importerViewModel: ImageImporterViewModel())
}
