//
//  BuyView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/11.
//

import SwiftUI
import SwiftyStoreKit

struct BuyView: View {
    @State var pname=""
    @State var price=""
    @State var loading=false
    @AppStorage("ExtraBuyed") var buyed=false
    var body: some View {
        List{
            if buyed{
                Section{
                    Text("感谢您购买")
                    Text("额外提供商现已可用")
                }
            } else if !buyed{
                Section{
                    Text("额外翻译提供商")
                    Text(pname)
                    Text("价格：\(price)")
                    Button(action: {
                        loading=true
                        SwiftyStoreKit.purchaseProduct("com.linecom.weartranslate.extra_provider", quantity: 1, atomically: true) { result in
                            switch result {
                            case .success(let purchase):
                                loading=false
                                buyed=true
                                print("Purchase Success: \(purchase.productId)")
                                let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
                                SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
                                    switch result {
                                    case .success(let receipt):
                                        print("Verify receipt success: \(receipt)")
                                    case .error(let error):
                                        print("Verify receipt failed: \(error)")
                                    }
                                }
                            case .error(let error):
                                loading=false
                                switch error.code {
                                case .unknown: print("Unknown error. Please contact support")
                                case .clientInvalid: print("Not allowed to make the payment")
                                case .paymentCancelled: break
                                case .paymentInvalid: print("The purchase identifier was invalid")
                                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                                default: print((error as NSError).localizedDescription)
                                }
                            case .deferred(purchase: let purchase):
                                print("deferred")
                            }
                        }
                    }, label: {
                        if loading{
                            ProgressView()
                        }else{
                            Text("购买")
                        }
                    })
                } footer: {
                    Text("如已购买，请再次点击以确认")
                }
            }
        }
        .onAppear(){
            SwiftyStoreKit.retrieveProductsInfo(["com.linecom.weartranslate.extra_provider"]) { result in
                let product = result.retrievedProducts.first
                pname=product!.localizedDescription
                let priceString = product?.localizedPrice!
                price=priceString!
                print("Product: \(product?.localizedDescription), price: \(priceString)")
                }
            let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
            SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                switch result {
                case .success(let receipt):
                    let productId = "com.linecom.weartranslate.extra_provider"
                    // Verify the purchase of Consumable or NonConsumable
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt)
                        
                    switch purchaseResult {
                    case .purchased(let receiptItem):
                        buyed=true
                        print("\(productId) is purchased: \(receiptItem)")
                    case .notPurchased:
                        print("The user has never purchased \(productId)")
                    }
                case .error(let error):
                    print("Receipt verification failed: \(error)")
                }
            }
            }
    }
}

#Preview {
    BuyView()
}
