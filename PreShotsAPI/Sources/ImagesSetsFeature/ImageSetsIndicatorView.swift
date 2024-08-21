//
//  ImageSetsIndicatorView.swift
//
//
//  Created by Terry Kuo on 2024/8/19.
//

import SwiftUI

public struct ImageSetsIndicatorView: View {
    @State private var shouldAnimate: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            HStack {
                Image(systemName: "photo")
                    .font(.system(size: 30))
                    .padding()
                    .background()
                    .clipShape(.rect(cornerRadius: 10))
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 20))
                    .bold()
                    .scaleEffect(self.shouldAnimate ? 1 : 0)
                    .animation(.bouncy.delay(0.3), value: self.shouldAnimate)
                HStack {
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                        Text("@1x")
                            .monospaced()
                            .font(.system(size: 16))
                    }
                    .scaleEffect(self.shouldAnimate ? 1 : 0)
                    .animation(.bouncy.delay(0.5), value: self.shouldAnimate)
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 35))
                        Text("@2x")
                            .monospaced()
                            .font(.system(size: 16))
                    }
                    .scaleEffect(self.shouldAnimate ? 1 : 0)
                    .animation(.bouncy.delay(0.7), value: self.shouldAnimate)
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                        Text("@3x")
                            .monospaced()
                            .font(.system(size: 16))
                    }
                    .scaleEffect(self.shouldAnimate ? 1 : 0)
                    .animation(.bouncy.delay(0.9), value: self.shouldAnimate)
                }
                .padding()
                .background()
                .clipShape(.rect(cornerRadius: 10))
            }
            
            Label("Add images to create resource images for your Xcode projects.", systemImage: "info.circle")
                .monospaced()
                .bold()
                .frame(maxWidth: 300)
        }
        .padding()
        .onAppear(perform: {
            withAnimation(Animation.bouncy(duration: 0.6).delay(1)) {
                self.shouldAnimate = true
            }
        })
    }
}

#Preview {
    ImageSetsIndicatorView()
}
