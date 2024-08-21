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
                    self.saveImageToDownloads(image: resizedImage, originalImage: imageFile.image)
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
    
    func saveImageToDownloads(image: NSImage, originalImage: NSImage) {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return
        }
        var downloadsDirectory: URL
        if let downloadsFolderUrl = DestinationFolderManager.shared.accessSavedFolder() {
            downloadsDirectory = downloadsFolderUrl
        } else {
            downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        }
        let imageName = UUID().uuidString + ".png" // You can use original image name if desired
        let imageUrl = downloadsDirectory.appendingPathComponent(imageName)
        
        do {
            try pngData.write(to: imageUrl)
            print("Image saved to \(imageUrl.path)")
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
        }
    }
    
   
    
    func setDeviceSize(device: DeviceTypes) {
        self.resizedWidth = device.width
        self.resizedHeight = device.height
    }
}
