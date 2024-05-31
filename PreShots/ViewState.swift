//
//  ViewState.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/19.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(Error)
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.error(error: let lhsType), .error(error: let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.success, .success):
            return true
        default :
            return false
            
        }
    }
}
