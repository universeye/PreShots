//
//  ImageFormat.swift
//  PreShotsAPI
//
//  Created by Terry Kuo on 2024/12/31.
//
import Foundation

public enum ImageFormat: Int, CaseIterable {
    case jpeg = 0
    case png = 1
    
    public var showString: String {
        switch self {
        case .jpeg: return "JPEG"
        case .png: return "PNG"
        }
    }
    
    public var fileExtension: String {
        switch self {
        case .jpeg: return "jpg"
        case .png: return "png"
        }
    }
}
