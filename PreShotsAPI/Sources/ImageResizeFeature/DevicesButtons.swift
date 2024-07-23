//
//  DevicesButtons.swift
//
//
//  Created by Terry Kuo on 2024/6/10.
//

import SwiftUI
import Models

struct DevicesButtons: View {
    @ObservedObject var viewModel: ImageResizeViewModel
    @State private var selectedDeviceType: DeviceTypes = .iphone6_7
    
    var body: some View {
      VStack {
            Picker("Quick Select", selection: $selectedDeviceType) {
                ForEach(DeviceTypes.allCases, id: \.self) { type in
                    Text("\(type.title) \(Image(systemName: type.deviceSymbol)) \(String(Int(type.width))) x \(String(Int(type.height)))")
                }
            }
            .frame(maxWidth: 400)
            .onChange(of: selectedDeviceType) { oldValue, newValue in
                viewModel.setDeviceSize(device: newValue)
            }
        }
    }
}

#Preview {
    DevicesButtons(viewModel: ImageResizeViewModel())
        .padding()
}
