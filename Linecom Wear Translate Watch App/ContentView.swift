//
//  ContentView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/3/1.
//

import SwiftUI
import DarockKit
import CommonCrypto

struct ContentView: View {
    @State var slang = ""
    @AppStorage("Lastsourcelang") var sourcelang = "auto"
    @AppStorage("Lasttargetlang") var targetlang = "en"
    @State var translatedText = ""
    @State var appid="20221006001373645"
    @State var apikey="7YH2L_U7dSHwqq6OErqB"
    @State var dislang=""
    @State var requesting=false
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("源语言",selection: $sourcelang) {
                        Text("自动").tag("auto")
                        Text("简体中文").tag("zh")
                        Text("繁体中文").tag("cht")
                        Text("英语").tag("en")
                        Text("日语").tag("jp")
                        
                    }
                    Picker("目标语言",selection: $targetlang) {
                        Text("简体中文").tag("zh")
                        Text("繁体中文").tag("cht")
                        Text("英语").tag("en")
                        Text("日语").tag("jp")
                    }
                }
                Section {
                    TextField("键入源语言",text: $slang)
                }
                Section {
                    Button(action: {
                        // ...
                        //if !slang.isEmpty{
                         //   translatedText="WARN:请输入内容"
                        //}
                        requesting = true
                        let clipedkey=appid+slang+"1355702100"+apikey
                        let signtrue=clipedkey.md5c()
                        let all="q=\(slang)&from=\(sourcelang)&to=\(targetlang)&appid=\(appid)&salt=1355702100&sign=\(signtrue)"
                        let allurl="https://fanyi-api.baidu.com/api/trans/vip/translate?\(all)"
                        DarockKit.Network.shared.requestJSON(allurl.urlEncoded()){ respond, succeed in
                            if !succeed{
                                translatedText="WARN: 翻译请求失败"
                                requesting=false
                            }else{
                                let receiveddata=respond["trans_result"][0]["dst"].string ?? "WARN: 翻译返回错误"
                                requesting=false
                                translatedText=receiveddata
                                let currentlang=respond["from"].string
                                if currentlang=="en"{
                                    dislang="英语"
                                } else if currentlang=="zh"{
                                    dislang="简体中文"
                                } else if currentlang=="cht"{
                                    dislang="繁体中文"
                                } else if currentlang=="jp" {
                                    dislang="日语"
                                }
                            }
                        }
                    }, label: {
                        if requesting {
                            HStack{
                                ProgressView()
                                Text("正在请求")
                            }
                        } else{
                            Text("翻译")
                        }
                        
                        
                    })
                    
                }
                if !translatedText.isEmpty {
                    VStack{
                        Text("从\(dislang)翻译：")
                        Section {
                            Text(translatedText)
                        }
                    }
                    .padding()
                }
                Section {
                    NavigationLink(destination:{AboutView().navigationTitle("关于LWT")},label:{Text("关于")})
                }

            }
            .navigationTitle("LWT")
        }
    }
}


#Preview {
    ContentView()
}
