//
//  SwiftUIView.swift
//  
//
//  Created by Terry Kuo on 2024/8/4.
//

import SwiftUI
import RevenueCat

struct TipsListView: View {
    @State private var tipsProducts: [Package]?
    @Environment(\.colorScheme) private var scheme
    @State private var isShowDebug: Bool = false
    @Binding var isPresentTipSheet: Bool
    
    var body: some View {
        VStack {
            tipList()
                .padding()
          
            HStack {
//                Button {
//                    isShowDebug.toggle()
//                } label: {
//                    Text("Show Debug")
//                }
                
                Button {
                    isPresentTipSheet.toggle()
                } label: {
                    Text("Close")
                }
            }
            .padding(.bottom)
//            .debugRevenueCatOverlay(isPresented: $isShowDebug)
            .onAppear {
                Task {
                    do {
                        let offerings = try await Purchases.shared.offerings()
                        let tipsOffering = offerings.offering(identifier: "tip")
                        tipsProducts = tipsOffering?.availablePackages
                    } catch let error {
                        print("Get tips offering failed: \(error).")
                    }
                }
            }
        }
        .frame(width: 250)
    }
    
    @ViewBuilder
    private func tipList() -> some View {
        if let packages = tipsProducts {
            VStack {
                ForEach(packages.sorted{ $0.storeProduct.price < $1.storeProduct.price }, id: \.self) { package in
                    Button(action: {
                        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
                            print("transaction: \(transaction?.description ?? "no transaction description")")
                        }
                    }, label: {
                        HStack {
                            switch package.storeProduct.productIdentifier {
                            case "kindtip_picpulse":
                                Text("😀")
                            case "greattip_picpulse":
                                Text("😚")
                            default :
                                Text("🧣")
                            }
                            Text("\(package.storeProduct.localizedTitle)")
                            Spacer()
                            Text("\(package.storeProduct.localizedPriceString)")
                        }
                        .foregroundStyle(.primary)
                        .padding(.vertical)
                        
                    })
                }
            }
        } else {
            ProgressView()
                .frame(height: 160)
        }
    }
}

#Preview {
    TipsListView(isPresentTipSheet: .constant(false))
}
