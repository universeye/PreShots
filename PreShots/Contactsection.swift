//
//  Contactsection.swift
//  PreShots
//
//  Created by Terry Kuo on 2025/1/7.
//

import SwiftUI

struct Contactsection: View {
    var body: some View {
        Form {
            Section {
                Link(destination: Links.getLink(link: .email)!, label: {
                    Label("Bugs Report/Feature Request", systemImage: "envelope")
                })
                Link(destination: Links.getLink(link: .twitterTerry)!, label: {
                    HStack {
                        Image("twitterlogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:  25, height: 25)
                        Text("X(Twitter)")
                    }
                })
                Link(destination: Links.getLink(link: .lilredbook)!, label: {
                    HStack {
                        Image("XiaohongshuLOGO")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("RED")
                    }
                })
                Link(destination: Links.getLink(link: .thread)!, label: {
                    HStack {
                        Image("threadslogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Threads")
                    }
                })
                Link(destination: Links.getLink(link: .mastadon)!, label: {
                    HStack {
                        Image("mastodon_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Mastodon")
                    }
                })
            } header: {
                Text("Contact")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    Contactsection()
}
