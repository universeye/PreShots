//
//  ImagesSetsControlView.swift
//
//
//  Created by Terry Kuo on 2024/8/19.
//

import SwiftUI
import ImagesSetsFeature
import ImportImagesFeature
import DestinationManager

public struct ImagesSetsControlView: View {
    @ObservedObject var importerViewModel: ImageImporterViewModel
    @StateObject private var imageSetExporterViewModel = ImageSetExporter()
    private let defaults = UserDefaults.standard
    
    public init(importerViewModel: ImageImporterViewModel) {
        self.importerViewModel = importerViewModel
    }
    
    public var body: some View {
        VStack {
            DestinationSetterButton()
            
            ImageSetsIndicatorView()
            
            switch imageSetExporterViewModel.state {
            case .error(let error):
                VStack {
                    Text("Failed: \(error.localizedDescription)")
                        .font(.footnote)
                        .foregroundStyle(.red)
                    Button {
                        guard imageSetExporterViewModel.state != .loading else { return }
                        imageSetExporterViewModel.exportImageSets(imageFiles: importerViewModel.images) {
                            let isAutoDelete = defaults.bool(forKey:"autoRemoveImage")
                            if isAutoDelete {
                                withAnimation {
                                    importerViewModel.images = []
                                }
                            }
                        }
                    } label: {
                        Text("Try Again")
                    }
                    .buttonStyle(.link)

                }
            default:
                EmptyView()
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    guard imageSetExporterViewModel.state != .loading else { return }
                    imageSetExporterViewModel.exportImageSets(imageFiles: importerViewModel.images) {
                        let isAutoDelete = defaults.bool(forKey:"autoRemoveImage")
                        if isAutoDelete {
                            withAnimation {
                                importerViewModel.images = []
                            }
                        }
                    }
                }) {
                    
                    Group {
                        if imageSetExporterViewModel.state == .loading {
                            ProgressView()
                        } else {
                            Text("Export Image Sets")
                        }
                    }
                    .font(.system(size: 14, weight: .bold))
                    .padding()
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 50)
                    .background(.blue.gradient)
                    .clipShape(.rect(cornerRadius: 13))
                    
                }
                .buttonStyle(.plain)
                .disabled(importerViewModel.images.isEmpty)
            }
            
            Divider()
                .padding(.top)
        }
    }
}

#Preview {
    ImagesSetsControlView(importerViewModel: ImageImporterViewModel())
}
