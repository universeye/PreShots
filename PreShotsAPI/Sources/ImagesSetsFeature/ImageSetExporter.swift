//
//  ImageSetExporter.swift
//
//
//  Created by Terry Kuo on 2024/8/19.
//

import Foundation
import SwiftUI
import AppKit
import CoreGraphics
import DestinationManager
import Models

@MainActor
public class ImageSetExporter: ObservableObject {
    @Published public var state: ViewState = .idle
    
    public init() {}
    
    public func exportImageSets(imageFiles: [ImageFile], selectedFormat: ImageFormat, compressionQuality: Float, onSuccess: @escaping () -> Void) {
        withAnimation {
            state = .loading
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            let myGroup = DispatchGroup()
            var errors: [Error] = []
            
            
            do {
                for imageFile in imageFiles {
                    myGroup.enter()
                    try self.exportSingleImageSet(imageFile: imageFile, selectedFormat: selectedFormat, compressionQuality: compressionQuality)
                    myGroup.leave()
                }
            } catch {
                errors.append(error)
                myGroup.leave()
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                if errors.isEmpty {
                    withAnimation {
                        self.state = .success
                        onSuccess()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.state = .idle
                        }
                    }
                } else {
                    withAnimation {
                        self.state = .error(errors.first!)
                    }
                }
            }
        }
        
      
    }
    
    private func exportSingleImageSet(imageFile: ImageFile, selectedFormat: ImageFormat, compressionQuality: Float) throws {
        
        
        let image = imageFile.image
        
        var downloadsDirectory: URL
        if let downloadsFolderUrl = DestinationFolderManager.shared.accessSavedFolder() {
            downloadsDirectory = downloadsFolderUrl
        } else {
            downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        }
        
        let fileManager = FileManager.default
        var imageName: String
        
        if let fileURL = imageFile.fileURL {
            imageName = fileURL.deletingPathExtension().lastPathComponent
        } else {
            imageName = imageFile.fileName
        }
        let outputURL = downloadsDirectory.appendingPathComponent(imageName + ".imageset")
        
        do {
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: outputURL.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    print("Directory already exists at \(outputURL.path). Continuing with existing directory.")
                } else {
                    print("A file (not a directory) already exists at \(outputURL.path). Please choose a different output path.")
                    return
                }
            } else {
                // Directory doesn't exist, so create it
                try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                print("Created directory at \(outputURL.path)")
            }
//            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            
            for scale in ImageScale.allCases {
                let scaledSize = CGSize(width: image.size.width / ImageScale.x3.scaleFactor * scale.scaleFactor,
                                        height: image.size.height / ImageScale.x3.scaleFactor * scale.scaleFactor)
                
                guard let scaledImage = resizeImage(image: image, to: scaledSize) else {
                    print("Failed to resize image for scale: \(scale.rawValue)")
                    continue
                }
                
                let fileName = "\(imageName)\(scale.rawValue).\(selectedFormat.fileExtension)"
                let fileURL = outputURL.appendingPathComponent(fileName)
                
                if let tiffData = scaledImage.tiffRepresentation,
                   let bitmapImage = NSBitmapImageRep(data: tiffData) {
                    let imageData: Data?
                    
                    switch selectedFormat {
                    case .jpeg:
                        imageData = bitmapImage.representation(using: .jpeg, 
                                                             properties: [.compressionFactor: NSNumber(value: compressionQuality)])
                    case .png:
                        imageData = bitmapImage.representation(using: .png, properties: [:])
                    }
                    
                    if let imageData = imageData {
                        try imageData.write(to: fileURL)
                        print("Saved: \(fileURL.path)")
                    } else {
                        print("Failed to convert image to \(selectedFormat.showString) data for scale: \(scale.rawValue)")
                    }
                } else {
                    print("Failed to convert image to bitmap data for scale: \(scale.rawValue)")
                }
            }
            
            // Update Contents.json creation to use the selected format
            try createContentsJson(for: imageName, format: selectedFormat, at: outputURL)
            
            print("Image set created successfully for \(imageName) in \(outputURL.path)")
            
        } catch {
            print("Error creating image set: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func resizeImage(image: NSImage, to newSize: CGSize) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        NSGraphicsContext.current?.cgContext.draw(cgImage, in: CGRect(origin: .zero, size: newSize))
        newImage.unlockFocus()
        
        return newImage
    }
    
    private func createContentsJson(for imageName: String, format: ImageFormat, at url: URL) throws {
        let contentsJson = """
        {
          "images" : [
            {
              "filename" : "\(imageName).\(format.fileExtension)",
              "idiom" : "universal",
              "scale" : "1x"
            },
            {
              "filename" : "\(imageName)@2x.\(format.fileExtension)",
              "idiom" : "universal",
              "scale" : "2x"
            },
            {
              "filename" : "\(imageName)@3x.\(format.fileExtension)",
              "idiom" : "universal",
              "scale" : "3x"
            }
          ],
          "info" : {
            "author" : "xcode",
            "version" : 1
          }
        }
        """
        
        do {
            try contentsJson.write(to: url.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
        } catch {
            print("Error creating Contents.json: \(error.localizedDescription)")
            throw error
        }
    }
}
