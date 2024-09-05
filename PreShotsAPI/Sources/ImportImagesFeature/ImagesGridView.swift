//
//  ImagesGridView.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import UniformTypeIdentifiers
import Models

public struct ImagesGridView: View {
    @ObservedObject var viewModel: ImageImporterViewModel
    @State private var isHoverOverEmpty = false
#if os(iOS)
    @State var isShowing = false
#endif
    public init(viewModel: ImageImporterViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 30)]) {
                    ForEach(viewModel.images, id: \.self) { imageFile in
                        ImageCell(imageFile: imageFile, viewModel: viewModel)
                    }
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
            HStack {
#if os(macOS)
                Button(action: {
                    viewModel.openFilePicker()
                }) {
                    Text("Add Images")
                }
                .keyboardShortcut("+", modifiers: [.command])
#elseif os(iOS)
                Button {
                    isShowing.toggle()
                } label: {
                    Text("documents")
                }.fileImporter(isPresented: $isShowing, allowedContentTypes: [.image], allowsMultipleSelection: true) { results in
                    
                    switch results {
                    case .success(let fileurls):
                        print(fileurls.count)
                        viewModel.handlePickedDocuments(urls: fileurls)
                        //                        for fileurl in fileurls {
                        //                            print(fileurl.path)
                        //                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
#endif
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
                Spacer()
            }
            .frame(maxWidth: .infinity)

        }
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
                            .foregroundStyle(.primary.opacity(0.5))
                            .rotationEffect(.degrees(isHoverOverEmpty ? -12 : -10))
                            .scaleEffect(isHoverOverEmpty ? 1.2 : 1.0)
                            .animation(.spring(duration: 0.3), value: isHoverOverEmpty)
                        Image(systemName: isHoverOverEmpty ? "photo.badge.plus.fill" : "photo.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.primary.opacity(0.5))
                            .rotationEffect(.degrees(isHoverOverEmpty ? 22 : 20))
                            .scaleEffect(isHoverOverEmpty ? 1.2 : 1.0)
                            .animation(.spring(duration: 0.2), value: isHoverOverEmpty)
                    }
                    Text("Add images or drop them here")
                        .monospaced()
                        .font(.system(size: 15))
                        .bold()
                        .foregroundStyle(.primary.opacity(0.5))
                        .animation(.easeInOut(duration: 0.2), value: isHoverOverEmpty)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .clipShape(.rect(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary.opacity(0.5), lineWidth: 0.7)
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
#if os(macOS)
                    viewModel.openFilePicker()
#elseif os(iOS)
                    self.isShowing.toggle()
#endif
                }
                .onHover { hover in
                    self.isHoverOverEmpty = hover
                }
            }
        }
    }
}
