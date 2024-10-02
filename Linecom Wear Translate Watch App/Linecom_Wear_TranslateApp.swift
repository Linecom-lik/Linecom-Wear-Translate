//
//  Linecom_Wear_TranslateApp.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/3/1.
//

import SwiftUI

var pShowTipText = ""
var pShowTipSymbol = ""
var pIsShowingTip = false
@main
struct Linecom_Wear_Translate_Watch_AppApp: App {
    
    @WKExtensionDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

public func tipWithText(_ text: String, symbol: String = "", time: Double = 3.0) {
    pShowTipText = text
    pShowTipSymbol = symbol
    pIsShowingTip = true
    Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
        pIsShowingTip = false
    }
}
