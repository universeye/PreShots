//
//  DeviceButton.swift
//
//
//  Created by Terry Kuo on 2024/7/23.
//

import SwiftUI
import Models

struct DeviceButton: View {
    @ObservedObject var viewModel: ImageResizeViewModel
    let device: DeviceTypes
    
    var body: some View {
        Button {
            viewModel.setDeviceSize(device: device)
        } label: {
            HStack {
                Text(device.title)
                Image(systemName: device.deviceSymbol)
            }
        }
    }
}

#Preview {
    DeviceButton(viewModel: ImageResizeViewModel(), device: .ipad12_9)
}
