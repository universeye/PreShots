//
//  ImageImporterViewModel.swift.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import UniformTypeIdentifiers
import Models

public class ImageImporterViewModel: ObservableObject {
    @Published public var images: [ImageFile] = []
    @Published public var state: ViewState = .idle
    
    public init() {}
    
    func removeImage(target: UUID) {
        if let firstIndex = images.firstIndex(where: { $0.id == target }) {
            images.remove(at: firstIndex)
        }
    }
    
    func removeAllImages() {
        images = []
    }
    
    
    
#if os(macOS)
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
#elseif os(iOS)
    func openFilePicker(from viewController: UIViewController) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
            UTType.png,
            UTType.jpeg,
            UTType.gif,
            UTType.tiff,
            UTType.heic
        ], asCopy: true)
        
        documentPicker.delegate = viewController as? UIDocumentPickerDelegate
        viewController.present(documentPicker, animated: true, completion: nil)
    }

    func handlePickedDocuments(urls: [URL]) {
        for url in urls {
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                let fileName = url.lastPathComponent
                let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: uiImage)
                images.append(ImageFile(image: uiImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
            }
        }
        state = .success
    }
#endif
    
    func handleDrop(providers: [NSItemProvider]) -> Bool {
            var found = false
            state = .loading
            for provider in providers {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (item, error) in
                        if let data = item as? Data {
                            #if os(macOS)
                            if let nsImage = NSImage(data: data) {
                                let fileName = "unknown"
                                let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: nsImage)
                                DispatchQueue.main.async {
                                    self.images.append(ImageFile(image: nsImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
                                }
                            }
                            #elseif os(iOS)
                            if let uiImage = UIImage(data: data) {
                                let fileName = "unknown"
                                let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: uiImage)
                                DispatchQueue.main.async {
                                    self.images.append(ImageFile(image: uiImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
                                }
                            }
                            #endif
                        } else if let url = item as? URL {
                            #if os(macOS)
                            if let nsImage = NSImage(contentsOf: url) {
                                let fileName = url.lastPathComponent
                                let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: nsImage)
                                DispatchQueue.main.async {
                                    self.images.append(ImageFile(image: nsImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
                                }
                            }
                            #elseif os(iOS)
                            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                                let fileName = url.lastPathComponent
                                let (pixelWidth, pixelHeight) = self.getPixelDimensions(from: uiImage)
                                DispatchQueue.main.async {
                                    self.images.append(ImageFile(image: uiImage, fileName: fileName, pixelWidth: pixelWidth, pixelHeight: pixelHeight))
                                }
                            }
                            #endif
                        }
                    }
                    found = true
                    state = .success
                }
            }
            
            return found
        }
    
#if os(macOS)
    func getPixelDimensions(from image: NSImage) -> (Int, Int) {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            return (0, 0)
        }
        return (bitmap.pixelsWide, bitmap.pixelsHigh)
    }
#elseif os(iOS)
    func getPixelDimensions(from image: UIImage) -> (Int, Int) {
        return (Int(image.size.width * image.scale), Int(image.size.height * image.scale))
    }
#endif

}

