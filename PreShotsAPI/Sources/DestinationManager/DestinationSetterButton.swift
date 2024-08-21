//
//  DestinationSetterButton.swift
//
//
//  Created by Terry Kuo on 2024/8/20.
//

import SwiftUI

public struct DestinationSetterButton: View {
    @State private var destinationURLString: String = ""
    
    public init() {}
    
    public var body: some View {
        HStack {
            Button(action: {
                DestinationFolderManager.shared.requestDownloadsFolderPermission()
                if let downloadsFolderUrl =  DestinationFolderManager.shared.accessSavedFolder() {
                    withAnimation {
                        self.destinationURLString = downloadsFolderUrl.absoluteString
                    }
                    
                }
            }) {
                HStack {
                    Text("Set Destination Folder")
                    if let _ =  DestinationFolderManager.shared.accessSavedFolder() {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            HStack {
                Text(destinationURLString)
                
                if let _ =  DestinationFolderManager.shared.accessSavedFolder() {
                    Button {
                        DestinationFolderManager.shared.openFolder()
                    } label: {
                        Image(systemName: "arrowshape.right.circle.fill")
                    }
                }
            }
            .onAppear {
                if let downloadsFolderUrl =  DestinationFolderManager.shared.accessSavedFolder() {
                    self.destinationURLString = downloadsFolderUrl.absoluteString
                }
            }
            
        }
    }
}

#Preview {
    DestinationSetterButton()
}
