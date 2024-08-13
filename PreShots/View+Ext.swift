//
//  View+Ext.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/8/13.
//

import SwiftUI

extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        self
            .modifier(OnAppearModifier(perform: action))
    }
}

