//
//  WYWTranslate.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/6/28.
//

import SwiftUI
import DarockKit
import CepheusKeyboardKit

struct WYWTranslate: View {
    var body: some View{
        TabView{
            WYWToCN()
        }
    }
    
    struct WYWToCN: View {
        @State var wywin=""
        @State var wywout=""
        @State var req=false
        @AppStorage("CepheusEnable") var cepenable=false
        var body: some View {
            List{
                Section{
                    HStack{
                        Spacer()
                        Text("文言->中文")
                        Spacer()
                    }
                }
                Section{
                    if !cepenable{
                        TextField("输入文言", text: $wywin)
                    } else if cepenable{
                        CepheusKeyboard(input: $wywin,prompt:"键入文言")
                    }
                    Button(action: {
                        req=true
                        if !wywin.isEmpty{
                            DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/translate?provider=baidu&text=\(wywin)&slang=wyw&tlang=zh&pass=l1nec0m".urlEncoded()){
                                resp, successd in
                                wywout=resp["trans_result"][0]["dst"].string ?? "返回错误"
                            }
                        } else {
                            wywout="请输入文本"
                        }
                        req=false
                    }, label: {
                        if !req{
                            HStack{
                                Spacer()
                                Image(systemName: "text.bubble")
                                Text("翻译")
                                Spacer()
                            }
                        } else {
                            ProgressView()
                        }
                    })
                }
                if !wywout.isEmpty{
                    Section{
                        Text(wywout)
                        Button(action: {
                            wywin=""
                        }, label: {
                            HStack{
                                Spacer()
                                Image(systemName: "")
                                Text("重置")
                                Spacer()
                            }
                        })
                    }
                }
                
            }
        }
    }
}

#Preview {
    WYWTranslate()
}
