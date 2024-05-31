//
//  ContentView.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = ImageResizerViewModel()
    @State private var isHoverOverEmpty = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 30)]) {
                    ForEach(viewModel.images, id: \.self) { imageFile in
                        ImageCell(imageFile: imageFile, viewModel: viewModel)
                    }
                    .background()
                    .clipShape(.rect(cornerRadius: 10))
                }
                .clipShape(.rect(cornerRadius: 10))
            }
            .onDrop(
                of: [UTType.image],
                isTargeted: nil,
                perform: viewModel.handleDrop
            )
            .overlay {
                emptyStateView()
            }
            Divider()
            controlPanel()
        }
        .padding()
        .frame(minWidth: 500)
    }
    
    @ViewBuilder
    private func emptyStateView() -> some View {
        if viewModel.state == .loading {
            ProgressView()
        } else {
            if viewModel.images.isEmpty {
                VStack(spacing: 20) {
                    HStack(spacing: isHoverOverEmpty ? 30 : 20) {
                        Image(systemName: isHoverOverEmpty ? "photo.badge.plus.fill" : "photo.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white.opacity(0.5))
                            .rotationEffect(.degrees(isHoverOverEmpty ? -12 : -10))
                            .scaleEffect(isHoverOverEmpty ? 1.2 : 1.0)
                            .animation(.spring(duration: 0.3), value: isHoverOverEmpty)
                        Image(systemName: isHoverOverEmpty ? "photo.badge.plus.fill" : "photo.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white.opacity(0.5))
                            .rotationEffect(.degrees(isHoverOverEmpty ? 22 : 20))
                            .scaleEffect(isHoverOverEmpty ? 1.2 : 1.0)
                            .animation(.spring(duration: 0.2), value: isHoverOverEmpty)
                    }
                    Text("Add images or drop them here")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundStyle(.white.opacity(0.5))
                        .animation(.easeInOut(duration: 0.2), value: isHoverOverEmpty)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .clipShape(.rect(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.5), lineWidth: 0.7)
                }
                .overlay {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 10))
                        .opacity(isHoverOverEmpty ? 1 : 0)
                        .animation(.smooth(duration: 0.2), value: isHoverOverEmpty)
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.state = .loading
                    }
                    viewModel.openFilePicker()
                }
                .onHover { hover in
                    print("Mouse hover: \(hover)")
                    self.isHoverOverEmpty = hover
                }
            }
        }
    }
    
    private func controlPanel() -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        viewModel.openFilePicker()
                    }) {
                        Text("Add Images")
                    }
                    if !viewModel.images.isEmpty {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.removeAllImages()
                            }
                        } label: {
                            Text("Remove all")
                                .foregroundStyle(.red)
                        }
                    }
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
                    //.padding()
                }
                HStack {
                    Button(action: {
                        viewModel.requestDownloadsFolderPermission()
                    }) {
                        HStack {
                            Text("Set Destination Folder")
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    
                    if let downloadsFolderUrl = viewModel.downloadsFolderUrl {
                        Text("\(downloadsFolderUrl.absoluteString)")
                    } else {
                        Text("\(FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!)")
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
                            viewModel.resizeAndSaveImages()
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
}

#Preview {
    ContentView()
        .frame(height: 600)
}
