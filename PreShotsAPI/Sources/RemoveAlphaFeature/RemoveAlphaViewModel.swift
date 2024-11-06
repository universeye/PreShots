//
//  RemoveAlphaViewModel.swift
//  PreShotsAPI
//
//  Created by Terry Kuo on 2024/11/5.
//

import Models
import SwiftUI
import DestinationManager

public class RemoveAlphaViewModel: ObservableObject {
    @Published public var outputState: ViewState = .idle
    
    public init() {}
    
    func removeAlpha() {
        print("Remove Alpha")
    }
    
    
    @MainActor
    public func resizeRemoveAlphaAndSaveImages(images: [ImageFile], onSuccess: @escaping () -> Void) {
        guard !images.isEmpty else { return }
        withAnimation {
            outputState = .loading
        }
        
        let myGroup = DispatchGroup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            for imageFile in images {
                myGroup.enter()
                if let imageWithoutAlpha = self.removeAlphaChannel(from: imageFile.image) {
                    DestinationFolderManager.shared.saveImageToDownloads(image: imageWithoutAlpha, originalImage: imageFile.image)
                }
                myGroup.leave()
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                withAnimation {
                    self.outputState = .success
                    onSuccess()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.outputState = .idle
                    }
                }
            }
        }
    }

    // Helper function to remove alpha channel
    private func removeAlphaChannel(from image: NSImage) -> NSImage? {
            // Get the image representations to find actual pixel dimensions
            guard let tiffRep = image.tiffRepresentation,
                  let bitmapRep = NSBitmapImageRep(data: tiffRep) else { return nil }
            
            // Use actual pixel dimensions rather than point-based size
            let pixelWidth = bitmapRep.pixelsWide
            let pixelHeight = bitmapRep.pixelsHigh
            
            // Create a new RGB color space
            guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
            
            // Create a new bitmap context without alpha channel
            guard let bitmapContext = CGContext(
                data: nil,
                width: pixelWidth,
                height: pixelHeight,
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
            ) else { return nil }
            
            // Draw the original image into the new context
            guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
            bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: pixelWidth, height: pixelHeight))
            
            // Create a new image from the context
            guard let newCGImage = bitmapContext.makeImage() else { return nil }
            
            // Create new NSImage with correct pixel dimensions
            let newImage = NSImage(size: NSSize(width: pixelWidth, height: pixelHeight))
            newImage.addRepresentation(NSBitmapImageRep(cgImage: newCGImage))
            
            return newImage
        }
}

