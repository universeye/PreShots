//
//  Links.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/8/13.
//

import Foundation

enum Links {
    case rateAppStore
    case shareApp
    case myOtherApps
    
    static func getLink(link: Links) -> URL? {
        switch link {
        case .rateAppStore:
            return URL(string: "itms-apps://itunes.apple.com/app/id\(6503602987)?mt=8&action=write-review")
        case .shareApp:
            return URL(string: "https://apps.apple.com/app/id6503602987")
        case .myOtherApps:
            return URL(string: "https://apps.apple.com/us/developer/tai-yu-kuo/id1585922485")
        }
    }
}
