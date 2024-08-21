//
//  ImageScale.swift
//
//
//  Created by Terry Kuo on 2024/8/19.
//

import Foundation

enum ImageScale: String, CaseIterable {
    case x1 = ""
    case x2 = "@2x"
    case x3 = "@3x"
    
    var scaleFactor: CGFloat {
        switch self {
        case .x1: return 1.0
        case .x2: return 2.0
        case .x3: return 3.0
        }
    }
}
