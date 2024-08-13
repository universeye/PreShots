//
//  OnAppearModifier.swift
//  Yosum
//
//  Created by Terry Kuo on 2024/2/28.
//

import SwiftUI

struct OnAppearModifier: ViewModifier {
    @State private var onAppearCalled: Bool = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !onAppearCalled {
                    onAppearCalled = true
                    action?()
                }
            }
    }
}
