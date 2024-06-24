//
//  File.swift
//  
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI

// Custom struct to hold NSImage and file name
public struct ImageFile: Identifiable, Hashable {
    
#if os(iOS)
    public typealias PlatformImage = UIImage
#elseif os(macOS)
    public typealias PlatformImage = NSImage
#endif
    
    public init(image: PlatformImage, fileName: String, pixelWidth: Int, pixelHeight: Int) {
        self.image = image
        self.fileName = fileName
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
    }
    public let id = UUID()
    public let image: PlatformImage
    public let fileName: String
    public let pixelWidth: Int
    public let pixelHeight: Int
}
