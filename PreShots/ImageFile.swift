//
//  ImageFile.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import SwiftUI

// Custom struct to hold NSImage and file name
struct ImageFile: Identifiable, Hashable {
    let id = UUID()
    let image: NSImage
    let fileName: String
    let pixelWidth: Int
    let pixelHeight: Int
}
