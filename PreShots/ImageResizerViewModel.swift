//
//  ImageResizerViewModel.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI
import UniformTypeIdentifiers

class ImageResizerViewModel: ObservableObject {
    @Published var images: [ImageFile] = []
    @Published var downloadsFolderUrl: URL?
    @Published var state: ViewState = .idle
    @Published var resizedWidth: CGFloat = 1290
    @Published var resizedHeight: CGFloat = 2796
    @Published var outputState: ViewState = .idle
    
    func removeImage(target: UUID) {
        if let firstIndex = images.firstIndex(where: { $0.id == target }) {
            images.remove(at: firstIndex)
        }
    }
    
    func removeAllImages() {
        images = []
    }
    
    func swapWidthHeight() {
        let tempWidth = resizedHeight
        resizedHeight = resizedWidth
        resizedWidth = tempWidth
    }
    
    func openFilePicker() {
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose images"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = true
        dialog.allowedContentTypes = [
            UTType.png,
            UTType.jpeg,
            UTType.gif,
            UTType.tiff,
            UTType.heic
        ]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.urls
            
            for url in result {
                if let nsImage = NSImage(contentsOf: url) {
                    let fileName = url.lastPathComponent
                    let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: nsImage)
                    images.append(ImageFile(image: nsImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
                }
            }
        }
        state = .success
    }
    
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        var found = false
        state = .loading
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (item, error) in
                    if let data = item as? Data, let nsImage = NSImage(data: data) {
                        let fileName = "unknown"
                        let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: nsImage)
                        DispatchQueue.main.async {
                            self.images.append(ImageFile(image: nsImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
                        }
                    } else if let url = item as? URL, let nsImage = NSImage(contentsOf: url) {
                        let fileName = url.lastPathComponent
                        let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: nsImage)
                        DispatchQueue.main.async {
                            self.images.append(ImageFile(image: nsImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
                        }
                    }
                }
                found = true
                state = .success
            }
        }
        
        return found
    }
    
    func getPixelDimensions(from image: NSImage) -> (Int, Int) {
            guard let tiffData = image.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData) else {
                return (0, 0)
            }
            return (bitmap.pixelsWide, bitmap.pixelsHigh)
        }
    
    @MainActor
    func resizeAndSaveImages() {
        guard !self.images.isEmpty else { return }
        withAnimation {
            outputState = .loading
        }
        
        let myGroup = DispatchGroup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for imageFile in self.images {
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
        if let downloadsFolderUrl = downloadsFolderUrl {
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
    
    func requestDownloadsFolderPermission() {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select Downloads Folder"
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            downloadsFolderUrl = dialog.url
        }
    }
    
    func setDeviceSize(device: DeviceTypes) {
        self.resizedWidth = device.width
        self.resizedHeight = device.height
    }
}
