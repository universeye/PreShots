//
//  ControlPanel.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import ImportImagesFeature

public struct ControlPanel: View {
    @ObservedObject var importerViewModel: ImageImporterViewModel
    @StateObject private var viewModel = ImageResizeViewModel()
    @State private var destinationURLString: String = ""
    
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
                HStack {
                    Button(action: {
                        DestinationFolderManager.shared.requestDownloadsFolderPermission()
                        if let downloadsFolderUrl =  DestinationFolderManager.shared.accessSavedFolder() {
                            withAnimation {
                                self.destinationURLString = downloadsFolderUrl.absoluteString
                            }
                            
                        }
                    }) {
                        HStack {
                            Text("Set Destination Folder")
                            if let _ =  DestinationFolderManager.shared.accessSavedFolder() {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    HStack {
                        Text(destinationURLString)
                        
                        if let _ =  DestinationFolderManager.shared.accessSavedFolder() {
                            Button {
                                DestinationFolderManager.shared.openFolder()
                            } label: {
                                Image(systemName: "arrowshape.right.circle.fill")
                            }
                        }
                    }
                    .onAppear {
                        if let downloadsFolderUrl =  DestinationFolderManager.shared.accessSavedFolder() {
                            self.destinationURLString = downloadsFolderUrl.absoluteString
                        }
                    }
                    
                }
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
                            viewModel.resizeAndSaveImages(images: importerViewModel.images)
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
            }
            Spacer()
        }
    }
    
    
}

#Preview {
    ControlPanel(importerViewModel: ImageImporterViewModel())
}
