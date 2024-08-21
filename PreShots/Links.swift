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
    case twitterTerry
    case lilredbook
    case email
    case thread
    case mastadon
    
    static func getLink(link: Links) -> URL? {
        switch link {
        case .rateAppStore:
            return URL(string: "itms-apps://itunes.apple.com/app/id\(6503602987)?mt=8&action=write-review")
        case .shareApp:
            return URL(string: "https://apps.apple.com/app/id6503602987")
        case .myOtherApps:
            return URL(string: "https://apps.apple.com/us/developer/tai-yu-kuo/id1585922485")
        case .twitterTerry:
            return URL(string: "https://twitter.com/yoyokuoo")
        case .lilredbook:
            return URL(string: "https://www.xiaohongshu.com/user/profile/642d56570000000011021d80")
        case .email:
            return URL(string: "mailto:terrykuo501@gmail.com")
        case .thread:
            return URL(string: "https://www.threads.net/@yoyokuoo")
        case .mastadon:
            return URL(string: "https://mastodon.world/@yoyokuo")
        }
    }
}
