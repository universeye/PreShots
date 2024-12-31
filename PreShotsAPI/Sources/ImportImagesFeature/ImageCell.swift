//
//  File.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import Models

struct ImageCell: View {
    let imageFile: ImageFile
    @ObservedObject var viewModel: ImageImporterViewModel
    
    private func formatFileSize(_ bytes: Int?) -> String {
        guard let bytes = bytes else { return "Unknown size" }
        
        let kb = Double(bytes) / 1024
        let mb = kb / 1024
        
        if mb >= 1.0 {
            return String(format: "%.2f MB", mb)
        } else {
            return String(format: "%.2f KB", kb)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 0) {
#if os(macOS)
                Image(nsImage: imageFile.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 5))
                    .frame(width: 200, height: 200)
                    .padding()
#elseif os(iOS)
                Image(uiImage: imageFile.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 5))
                    .frame(width: 200, height: 200)
                    .padding()
#endif
            }
            Text("\(imageFile.fileName)")
                .font(.footnote)
                .bold()
            HStack {
                Text("Size:")
                Text("\(String(imageFile.pixelWidth))")
                    .foregroundStyle(.blue)
                    .bold()
                Text("x")
                Text("\(String(imageFile.pixelHeight))")
                    .foregroundStyle(.blue)
                    .bold()
                Text("(px)")
            }
            .font(.footnote)
            
            Text("\(formatFileSize(imageFile.fileSize))")
                .font(.footnote)
                .bold()
                .padding(.bottom)
            
            Button(action: {
                withAnimation {
                    viewModel.removeImage(target: imageFile.id)
                }
            }, label: {
                Text("Delete")
                    .foregroundStyle(.red)
                    .font(.footnote)
            })
            
            //Text("↓")
            .padding(.bottom)
        }
        .padding(.horizontal, 8)
        .background()
    }
}
