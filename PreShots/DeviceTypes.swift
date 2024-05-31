//
//  DeviceTypes.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/30.
//

import Foundation

enum DeviceTypes {
    case iphone6_7
    case iphone6_5
    case iphone5_5
    case ipad13
    case ipad12_9
    
    var width: CGFloat {
        switch self {
        case .iphone6_7:
            return 1290
        case .iphone6_5:
            return 1290
        case .iphone5_5:
            return 1290
        case .ipad13:
            return 1290
        case .ipad12_9:
            return 1290
        }
    }
    
    var height: CGFloat {
        switch self {
        case .iphone6_7:
            return 2796
        case .iphone6_5:
            return 1290
        case .iphone5_5:
            return 1290
        case .ipad13:
            return 1290
        case .ipad12_9:
            return 1290
        }
    }
}
