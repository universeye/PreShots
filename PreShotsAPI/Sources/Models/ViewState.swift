//
//  File.swift
//  
//
//  Created by Terry Kuo on 2024/6/10.
//

import Foundation

public enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(Error)
    
    static public func == (lhs: ViewState, rhs: ViewState) -> Bool {
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
