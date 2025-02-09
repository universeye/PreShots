//
//  DestinationFolderManager.swift
//  
//
//  Created by Terry Kuo on 2024/7/24.
//

import Foundation
import Cocoa
import Models

public class DestinationFolderManager {
    public static let shared = DestinationFolderManager()
    private let defaults = UserDefaults.standard
    private let folderKey = "DestinationFolder"
    private let bookmarkKey = "DestinationFolderBookmark"
    
    public init() {}
    
    func saveDestinationFolder(_ url: URL) {
        defaults.set(url.path, forKey: folderKey)
    }
    
    func getDestinationFolder() -> URL? {
        guard let path = defaults.string(forKey: folderKey) else { return nil }
        return URL(fileURLWithPath: path)
    }
    
    func clearDestinationFolder() {
        defaults.removeObject(forKey: folderKey)
    }
    
    public func requestDownloadsFolderPermission() {
        let dialog = NSOpenPanel()
        
        dialog.title = "Select Downloads Folder"
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let url = dialog.url {
                saveAndRequestAccess(to: url)
            }
        }
    }
    
    public func openFolder() {
        if let url = accessSavedFolder() {
            if NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path) {
                print("Successfully opened the folder with \(url).")
            } else {
                print("Failed to open the folder.")
            }
        } else {
            print("Failed")
        }
    }
    
    
    func saveAndRequestAccess(to url: URL) {
        do {
            let bookmarkData = try url.bookmarkData(options: .withSecurityScope,
                                                    includingResourceValuesForKeys: nil,
                                                    relativeTo: nil)
            defaults.set(bookmarkData, forKey: bookmarkKey)
        } catch {
            print("Failed to create bookmark: \(error)")
        }
    }
    
    public func accessSavedFolder() -> URL? {
        guard let bookmarkData = defaults.data(forKey: bookmarkKey) else {
            return nil
        }
        
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData,
                              options: .withSecurityScope,
                              relativeTo: nil,
                              bookmarkDataIsStale: &isStale)
            
            if isStale {
                // Bookmark data is stale, request access again
                saveAndRequestAccess(to: url)
            }
            
            if url.startAccessingSecurityScopedResource() {
                return url
            } else {
                print("Failed to access the security scoped resource.")
                return nil
            }
        } catch {
            print("Failed to resolve bookmark: \(error)")
            return nil
        }
    }
    
    public func saveImageToDownloads(image: NSImage, originalImage: NSImage, format: ImageFormat) {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            return
        }
        
        // Use the format to determine the representation type and file extension
        let imageData: Data?
        switch format {
        case .jpeg:
            imageData = bitmap.representation(using: .jpeg, properties: [:])
        case .png:
            imageData = bitmap.representation(using: .png, properties: [:])
        }
        
        guard let imageData = imageData else { return }
        
        if let downloadsFolderUrl = self.accessSavedFolder() {
            let downloadsDirectory = downloadsFolderUrl
            
            // Use the format's file extension
            let imageName = UUID().uuidString + "." + format.fileExtension
            let imageUrl = downloadsDirectory.appendingPathComponent(imageName)
            
            do {
                try imageData.write(to: imageUrl)
                print("Image saved to \(imageUrl.path)")
            } catch {
                print("Failed to save image: \(error.localizedDescription)")
            }
        }
    }
}
