//
//  WYWTranslate.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/6/28.
//

import SwiftUI
import DarockKit

struct WYWTranslate: View {
    @State var wywin=""
    @State var wywout=""
    @State var req=false
    var body: some View {
        List{
            Section{
                TextField("输入文言", text: $wywin)
                Button(action: {
                    req=true
                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/translate?provider=baidu&text=\(wywin)&slang=wyw&tlang=zh&pass=l1nec0m".urlEncoded()){
                        resp, successd in
                        wywout=resp["trans_result"][0]["dst"].string ?? ""
                        req=false
                    }
                }, label: {
                    if !req{
                        Text("翻译")
                    } else {
                        ProgressView()
                    }
                })
            }
            if !wywout.isEmpty{
                Section{
                    Text(wywout)
                }
            }
            
        }
    }
}

#Preview {
    WYWTranslate()
}
