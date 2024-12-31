//
//  ImagesSetsControlView.swift
//
//
//  Created by Terry Kuo on 2024/8/19.
//

import SwiftUI
import ImagesSetsFeature
import ImportImagesFeature
import Models

public struct ImagesSetsControlView: View {
    @ObservedObject var importerViewModel: ImageImporterViewModel
    @StateObject private var imageSetExporterViewModel = ImageSetExporter()
    private let defaults = UserDefaults.standard
    
    public init(importerViewModel: ImageImporterViewModel) {
        self.importerViewModel = importerViewModel
    }
    
    public var body: some View {
        VStack {
      
            VStack(alignment: .leading) {
                Picker(selection: $importerViewModel.selectedFormat, label: Text("Image Format")) {
                    ForEach(ImageFormat.allCases, id: \.self) { format in
                        Text(format.showString)
                            .tag(format.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 400)
                
                if importerViewModel.selectedFormat == .jpeg {
                    HStack {
                        Text("Compression Quality")
                        Slider(value: $importerViewModel.compressionQuality, in: 0.1...1, step: 0.01)
                            .frame(width: 300)
                        Text("\(Int(importerViewModel.compressionQuality * 100))%")
                    }
                    .padding(.vertical, 8)
                }
            }
            
            ImageSetsIndicatorView()
            
            Spacer()
            
            switch imageSetExporterViewModel.state {
            case .error(let error):
                VStack {
                    Text("Failed: \(error.localizedDescription)")
                        .font(.footnote)
                        .foregroundStyle(.red)
                    Button {
                        guard imageSetExporterViewModel.state != .loading else { return }
                        imageSetExporterViewModel.exportImageSets(
                            imageFiles: importerViewModel.images,
                            selectedFormat: importerViewModel.selectedFormat,
                            compressionQuality: importerViewModel.compressionQuality
                        ) {
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
               
                
                Button(
                    action: {
                        guard imageSetExporterViewModel.state != .loading else { return }
                        imageSetExporterViewModel.exportImageSets(
                            imageFiles: importerViewModel.images,
                            selectedFormat: importerViewModel.selectedFormat,
                            compressionQuality: importerViewModel.compressionQuality
                        ) {
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
                    .clipShape(.rect(cornerRadius: 10))
                    
                }
                .buttonStyle(.plain)
                .disabled(importerViewModel.images.isEmpty)
            }
        }
        .padding()
    }
    
}

#Preview {
    ImagesSetsControlView(importerViewModel: ImageImporterViewModel())
}
