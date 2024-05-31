//
//  ImageCell.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/29.
//

import SwiftUI

struct ImageCell: View {
    let imageFile: ImageFile
    @ObservedObject var viewModel: ImageResizerViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 0) {
                Image(nsImage: imageFile.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 5))
                    .frame(width: 200, height: 200)
                    .padding()
                VStack {
                    Button {
                        withAnimation {
                            viewModel.removeImage(target: imageFile.id)
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .padding(.vertical)
                    Spacer()
                }
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
            
            //Text("↓")
            .padding(.bottom)
        }
        .padding(.horizontal, 8)
        //.background()
        //.clipShape(.rect(cornerRadius: 10))
        
    }
}
