//
//  ControlPanel.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import ImportImagesFeature
import DestinationManager
import Models

public struct ControlPanel: View {
    @ObservedObject var importerViewModel: ImageImporterViewModel
    @StateObject private var viewModel = ImageResizeViewModel()
    private let defaults = UserDefaults.standard
    
    
    public init(importerViewModel: ImageImporterViewModel) {
        self.importerViewModel = importerViewModel
    }
    
    public var body: some View {
        HStack {
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

                DevicesButtons(viewModel: viewModel)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Width(px): ")
                        TextField("Width", value: $viewModel.resizedWidth, formatter: NumberFormatter())
                    }
                    .padding(5)
                    .background()
                    .clipShape(.rect(cornerRadius: 5))
                    .padding(.vertical, 8)
                    
                    Button {
                        viewModel.swapWidthHeight()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Height(px): ")
                        TextField("Height", value: $viewModel.resizedHeight, formatter: NumberFormatter())
                    }
                    .padding(5)
                    .background()
                    .clipShape(.rect(cornerRadius: 5))
                    .padding(.vertical, 8)
                }
                Spacer()
                HStack {
                    if viewModel.outputState == .loading {
                        ProgressView()
                            .progressViewStyle(.linear)
                    }
                    
                    Spacer()
//                    Button {
//                        viewModel.resizeRemoveAlphaAndSaveImages(images: importerViewModel.images) {}
//                    } label: {
//                        Text("Remove Alpha")
//                            .font(.system(size: 14, weight: .bold))
//                            .padding()
//                            .foregroundStyle(.white)
//                            .frame(width: 200, height: 50)
//                            .background(.blue.gradient)
//                            .clipShape(.rect(cornerRadius: 13))
//                    }
//                    .buttonStyle(.plain)
                    
                    if viewModel.outputState == .loading {
                        ProgressView()
                    } else if viewModel.outputState == .success {
                        Label("Success!", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 14, weight: .bold))
                            .padding()
                            .foregroundStyle(.white)
                            .frame(width: 200, height: 50)
                            .background(.blue.gradient)
                            .clipShape(.rect(cornerRadius: 13))
                    } else {
                        Button(
                            action: {
                                guard DestinationFolderManager.shared.accessSavedFolder() != nil else {
                                    DestinationFolderManager.shared.requestDownloadsFolderPermission()
                                    return
                                }
                                viewModel.resizeAndSaveImages(
                                    images: importerViewModel.images,
                                    selectedFormat: importerViewModel.selectedFormat,
                                    compressionQuality: importerViewModel.compressionQuality
                                ) {
                                let isAutoDelete = defaults.bool(forKey:"autoRemoveImage")
                                if isAutoDelete {
                                    withAnimation {
                                        importerViewModel.removeAllImages()
                                    }
                                }
                            }
                        }) {
                            Text("Resize and Save Images")
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
                
                switch viewModel.outputState {
                case .error(let error):
                    VStack {
                        Text("Failed: \(error.localizedDescription)")
                            .font(.footnote)
                            .foregroundStyle(.red)
                        Button {
                            viewModel.resizeAndSaveImages(
                                images: importerViewModel.images,
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
            }
            .padding()
//            Spacer()
        }
    }
    
    
}

#Preview {
    ControlPanel(importerViewModel: ImageImporterViewModel())
        .padding()
}
