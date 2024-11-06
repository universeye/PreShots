//
//  DestinationFolderManager.swift
//  
//
//  Created by Terry Kuo on 2024/7/24.
//

import Foundation
import Cocoa

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
    
    public func saveImageToDownloads(image: NSImage, originalImage: NSImage) {
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return
        }
        var downloadsDirectory: URL
        if let downloadsFolderUrl = self.accessSavedFolder() {
            downloadsDirectory = downloadsFolderUrl
            
            let imageName = UUID().uuidString + ".png" // You can use original image name if desired
            let imageUrl = downloadsDirectory.appendingPathComponent(imageName)
            
            do {
                try pngData.write(to: imageUrl)
                print("Image saved to \(imageUrl.path)")
            } catch {
                print("Failed to save image: \(error.localizedDescription)")
            }
        }
    }
}
