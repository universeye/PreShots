//
//  ControlPanel.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import ImportImagesFeature
import DestinationManager

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
                
                DestinationSetterButton()
                
                HStack {
                    if viewModel.outputState == .loading {
                        ProgressView()
                            .progressViewStyle(.linear)
                    }
                    
                    Spacer()
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
                        Button(action: {
                            viewModel.resizeAndSaveImages(images: importerViewModel.images) {
                                let isAutoDelete = defaults.bool(forKey:"autoRemoveImage")
                                if isAutoDelete {
                                    withAnimation {
                                        importerViewModel.images = []
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
                                .clipShape(.rect(cornerRadius: 13))
                            
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
                            viewModel.resizeAndSaveImages(images: importerViewModel.images) {
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
                
                Divider()
                    .padding(.top)
            }
            Spacer()
        }
    }
    
    
}

#Preview {
    ControlPanel(importerViewModel: ImageImporterViewModel())
        .padding()
}
