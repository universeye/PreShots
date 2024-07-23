//
//  File.swift
//  
//
//  Created by Terry Kuo on 2024/6/10.
//

import Foundation

public enum DeviceTypes: CaseIterable {
    case iphone6_7
    case iphone6_5
    case iphone6_5_2
    case iphone5_5
    case ipad13
    case ipad12_9
    case mac1
    case mac2
    case mac3
    case mac4
    
    public var title: String {
        switch self {
        case .iphone6_7:
            return "iPhone 6.7''"
        case .iphone6_5:
            return "iPhone 6.5''"
        case .iphone6_5_2:
            return "iPhone 6.5''"
        case .iphone5_5:
            return "iPhone SE 5.5''"
        case .ipad13:
            return "iPad 13''"
        case .ipad12_9:
            return "iPad 12.9''"
        case .mac1:
            return "Mac 1"
        case .mac2:
            return "Mac 2"
        case .mac3:
            return "Mac 3"
        case .mac4:
            return "Mac 4"
        }
    }
    
    public var deviceSymbol: String {
        switch self {
        case .iphone6_7:
            return "iphone"
        case .iphone6_5:
            return "iphone"
        case .iphone6_5_2:
            return "iphone"
        case .iphone5_5:
            return "iphone.gen1"
        case .ipad13:
            return "ipad"
        case .ipad12_9:
            return "ipad"
        case .mac1:
            return "macbook"
        case .mac2:
            return "macbook"
        case .mac3:
            return "macbook"
        case .mac4:
            return "macbook"
        }
    }
    
    public var width: CGFloat {
        switch self {
        case .iphone6_7:
            return 1290
        case .iphone6_5:
            return 1242
        case .iphone6_5_2:
            return 1284
        case .iphone5_5:
            return 1242
        case .ipad13:
            return 2064
        case .ipad12_9:
            return 2048
        case .mac1:
            return 1280
        case .mac2:
            return 1440
        case .mac3:
            return 2560
        case .mac4:
            return 2880
        }
    }
    
    public var height: CGFloat {
        switch self {
        case .iphone6_7:
            return 2796
        case .iphone6_5:
            return 2688
        case .iphone6_5_2:
            return 2778
        case .iphone5_5:
            return 2208
        case .ipad13:
            return 2752
        case .ipad12_9:
            return 2732
        case .mac1:
            return 800
        case .mac2:
            return 900
        case .mac3:
            return 1600
        case .mac4:
            return 1800
        }
    }
}
