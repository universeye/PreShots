//
//  GitHubRelease.swift
//
//
//  Created by Terry Kuo on 2024/8/13.
//

import Foundation

class GitHubRelease: Codable {
    let tagName: String
    let assets: [Asset]
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case assets
    }
}

class Asset: Codable {
    let name: String
    let browserDownloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case browserDownloadURL = "browser_download_url"
    }
}
