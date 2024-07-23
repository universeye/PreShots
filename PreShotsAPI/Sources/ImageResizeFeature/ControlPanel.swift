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
                    //.padding()
                }
                HStack {
                    Button(action: {
                        viewModel.requestDownloadsFolderPermission()
                    }) {
                        HStack {
                            Text("Set Destination Folder")
                            if let _ = viewModel.downloadsFolderUrl {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    HStack {
                    if let downloadsFolderUrl = viewModel.downloadsFolderUrl {
                            Text("\(downloadsFolderUrl.absoluteString)")

                    } else {
                        Text("\(FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!)")
                    }
                        Button {
                            openFolder(url:  viewModel.downloadsFolderUrl ?? FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!)
                        } label: {
                            Image(systemName: "arrowshape.right.circle.fill")
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
                            .frame(width: 200, height: 50)
                            .background(.blue.gradient)
                            .clipShape(.rect(cornerRadius: 13))
                    } else {
                        Button(action: {
//                            viewModel.requestDownloadsFolderPermission()
                            viewModel.resizeAndSaveImages(images: importerViewModel.images)
                        }) {
                            Text("Resize and Save Images")
                                .font(.system(size: 14, weight: .bold))
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(.blue.gradient)
                                .clipShape(.rect(cornerRadius: 13))
                            
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Spacer()
        }
    }
    
    func openFolder(url: URL) {
        if NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path) {
            print("Successfully opened the folder.")
        } else {
            print("Failed to open the folder.")
        }
    }
}

#Preview {
    ControlPanel(importerViewModel: ImageImporterViewModel())
}
