//
//  ImageResizeViewModel.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import Models
import AppKit
import DestinationManager

class ImageResizeViewModel: ObservableObject {
    @Published var outputState: ViewState = .idle
    @Published var resizedWidth: CGFloat = 1290
    @Published var resizedHeight: CGFloat = 2796
    
    
    func swapWidthHeight() {
        let tempWidth = resizedHeight
        resizedHeight = resizedWidth
        resizedWidth = tempWidth
    }
    
    
    @MainActor
    func resizeAndSaveImages(images: [ImageFile], onSuccess: @escaping () -> Void) {
        guard !images.isEmpty else { return }
        withAnimation {
            outputState = .loading
        }
        
        let myGroup = DispatchGroup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            for imageFile in images {
                myGroup.enter()
                if let resizedImage = self.resizeImage(image: imageFile.image, width: self.resizedWidth, height: self.resizedHeight) {
                    DestinationFolderManager.shared.saveImageToDownloads(image: resizedImage, originalImage: imageFile.image)
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
    
    @MainActor
    func resizeRemoveAlphaAndSaveImages(images: [ImageFile], onSuccess: @escaping () -> Void) {
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
    
    func resizeImage(image: NSImage, width: CGFloat, height: CGFloat) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        
        context?.interpolationQuality = .high
        context?.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        
        guard let resizedCgImage = context?.makeImage() else {
            return nil
        }
        
        return NSImage(cgImage: resizedCgImage, size: NSSize(width: width, height: height))
    }
    
    func setDeviceSize(device: DeviceTypes) {
        self.resizedWidth = device.width
        self.resizedHeight = device.height
    }
}
