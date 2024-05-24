//
//  LinecomBase.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/24.
//

import Foundation
import DarockKit

func apiping()->String{
    var rr=""
    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/status/check"){
        respond, secceed in
        if !secceed{
             rr = "LossNet"
        } else if respond["status"] != 0{
            rr = "InvaildResp"
        } else{
            rr = "ok"
        }
    }
    return rr
}
