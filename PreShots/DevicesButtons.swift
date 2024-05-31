//
//  DevicesButtons.swift
//  PreShots
//
//  Created by Terry Kuo on 2024/5/29.
//

import SwiftUI

struct DevicesButtons: View {
    @ObservedObject var viewModel: ImageResizerViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.setDeviceSize(device: .iphone6_7)
            } label: {
                HStack {
                    Text("6.7''")
                    Image(systemName: "iphone")
                }
            }
            Button {
                viewModel.setDeviceSize(device: .iphone6_5)
            } label: {
                HStack {
                    Text("6.5''")
                    Image(systemName: "iphone")
                }
            }
            
            Button {
                viewModel.setDeviceSize(device: .iphone5_5)
            } label: {
                HStack {
                    Text("5.5''")
                    Image(systemName: "iphone.gen1")
                }
            }
            
            Button {
                viewModel.setDeviceSize(device: .ipad13)
            } label: {
                HStack {
                    Text("13''")
                    Image(systemName: "ipad")
                }
            }
            
            Button {
                viewModel.setDeviceSize(device: .ipad12_9)
            } label: {
                HStack {
                    Text("12.9''")
                    Image(systemName: "ipad")
                }
            }
        }
    }
}

#Preview {
    DevicesButtons(viewModel: ImageResizerViewModel())
}
