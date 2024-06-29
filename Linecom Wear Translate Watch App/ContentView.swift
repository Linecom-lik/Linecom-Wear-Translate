//
//  ContentView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/3/1.
//

import SwiftUI
import DarockKit
import CommonCrypto
import CepheusKeyboardKit
import SwiftyStoreKit

struct ContentView: View {
    @State var slang = ""
    @State var translatedText = ""
    @AppStorage("ApiKeyStatus") var custkeyenable=false
    @State var dislang=""
    @State var sdata=""
    @State var requesting=false
    @AppStorage("Provider") var provider="baidu"
    @AppStorage("LastSource") var sourcelang="auto"
    @AppStorage("LastTarget") var targetlang="en"
    @AppStorage("debugmode") var debugenable=false
    @AppStorage("CepheusEnable") var cepenable=false
    @State var NetPing=""
    @State var checking=false
    @State var baidugroup=["zh":"简体中文","cht":"繁体中文","en":"英语","jp":"日语","kor":"韩语","fra":"法语","ru":"俄语","de":"德语","spa":"西班牙语","bl":"波兰语"]
    @State var tencentgroup=["zh":"简体中文","zh-TW":"繁体中文","en":"英语","ja":"日语","ko":"韩语","fr":"法语","ru":"俄语","de":"德语","es":"西班牙语"]
    @State var transfl=""
    @State var notice=""
    @AppStorage("hideos9tip") var hideos9tip=false
    var body: some View {
        //搁置
        //if !lastenable{
         //   var sourcelang="auto"
        //    var targetlang="en"
        //}
        NavigationStack {
            if #available(watchOS 10.0, *) {
                List {
                    if debugenable{
                        Section{
                            HStack{
                                Spacer()
                                Text("Debug enabled")
                                Spacer()
                            }
                        }
                    }
                    if NetPing=="" && !debugenable{
                        Section{
                            HStack{
                                Image(systemName: "wave.3.forward")
                                Text("正在检查网络连接")
                                if checking{
                                    ProgressView()
                                }
                            }
                        } header: {
                            Text("请等待")
                        }
                    } else if NetPing=="LossNet"{
                        Section{
                            HStack{
                                Image(systemName: "wifi.exclamationmark")
                                Text("尚未连接到互联网")
                            }
                            Button(action: {
                                checking=true
                                NetPing=apiping()
                                checking=false
                            }, label: {
                                
                                if checking{
                                    ProgressView()
                                } else{
                                    Text("重试")
                                }
                            })
                        } header: {
                            Text("网络异常，无法翻译")
                        } footer: {
                            Text("LWT需要网络连接以进行在线翻译")
                        }
                    } else if NetPing=="InvaildResp" && !debugenable {
                        Section{
                            HStack{
                                Image(systemName: "xmark.icloud.fill")
                                Text("Linecom API离线")
                            }
                            Button(action: {
                                checking=true
                                NetPing=apiping()
                                checking=false
                            }, label: {
                                if checking{
                                    ProgressView()
                                } else{
                                    Text("重试")
                                }
                            })
                        } header: {
                            Text("网络异常，无法翻译")
                        } footer: {
                            Text("请等待一会，马上回来")
                        }
                    } else if NetPing=="ok" || debugenable{
                        if !notice.isEmpty{
                            Section{
                                Text(notice)
                            } header: {
                                Text("公告")
                            }
                        }
                        
                        Section {
                            Picker("源语言",selection: $sourcelang) {
                                if provider=="baidu"{
                                    Text("自动").tag("auto")
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("cht")
                                    Text("英语").tag("en")
                                    Text("日语").tag("jp")
                                    Text("韩语").tag("kor")
                                    Text("法语").tag("fra")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("spa")
                                    Text("波兰语").tag("bl")
                                } else if provider=="tencent"{
                                    Text("自动").tag("auto")
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("zh-TW")
                                    Text("英语").tag("en")
                                    Text("日语").tag("ja")
                                    Text("韩语").tag("ko")
                                    Text("法语").tag("fr")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("es")
                                }
                                
                            }
                            
                            Picker("目标语言",selection: $targetlang) {
                                //debug selection!
                                if debugenable{
                                    Text("自动").tag("auto")
                                }
                                if provider=="baidu"{
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("cht")
                                    Text("英语").tag("en")
                                    Text("日语").tag("jp")
                                    Text("韩语").tag("kor")
                                    Text("法语").tag("fra")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("spa")
                                    Text("波兰语").tag("bl")
                                } else if provider=="tencent"{
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("zh-TW")
                                    Text("英语").tag("en")
                                    Text("日语").tag("ja")
                                    Text("韩语").tag("ko")
                                    Text("法语").tag("fr")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("es")
                                }
                            }
                            if !cepenable{
                                TextField("键入源语言",text: $slang)
                            } else if cepenable{
                                CepheusKeyboard(input: $slang,prompt:"键入源语言")
                            }
                            Button(action: {
                                // ...
                                requesting = true
                                if slang.isEmpty && !debugenable{
                                    translatedText="请输入文本"
                                    requesting=false
                                } else if provider=="baidu"{
                                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/translate?provider=\(provider)&text=\(slang)&slang=\(sourcelang)&tlang=\(targetlang)&pass=l1nec0m".urlEncoded()){
                                        resp, succeed in
                                        if !succeed{
                                            translatedText="翻译请求发送失败，请联系开发者。"
                                        }
                                        translatedText=resp["trans_result"][0]["dst"].string ?? "翻译返回错误，请联系开发者"
                                        sdata=resp["trans_result"][0]["src"].string ?? "翻译返回错误，请联系开发者"
                                        transfl=resp["from"].string ?? ""
                                        dislang=baidugroup[transfl] ?? ""
                                        requesting=false
                                    }
                                } else if provider=="tencent"{
                                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/translate?provider=\(provider)&text=\(slang)&slang=\(sourcelang)&tlang=\(targetlang)&pass=l1nec0m".urlEncoded()){
                                        resp, succeed in
                                        if !succeed{
                                            translatedText="翻译请求发送失败"
                                        }
                                        let finalsdt=slang
                                        translatedText=resp["Response"]["TargetText"].string ?? "翻译返回错误"
                                        sdata=finalsdt
                                        transfl=resp["Response"]["Source"].string ?? ""
                                        dislang=tencentgroup[transfl] ?? ""
                                        requesting=false
                                    }
                                }
                            }, label: {
                                if requesting {
                                    HStack{
                                        Spacer()
                                        Text("正在请求")
                                        ProgressView()
                                        Spacer()
                                    }
                                } else{
                                    HStack{
                                        Spacer()
                                        Image(systemName: "globe")
                                        Text("翻译")
                                        Spacer()
                                    }
                                }
                                
                                
                            })
                            
                        }
                        Section{
                            NavigationLink(destination: {WYWTranslate().navigationTitle("文言翻译")}, label: {
                                HStack{
                                    Spacer()
                                    Image(systemName: "ellipsis.bubble")
                                    Text("文言文翻译")
                                    Spacer()
                                }
                            })
                        }
                    }
                    if !translatedText.isEmpty {
                        Section {
                            if !slang.isEmpty{
                                HStack{
                                    Spacer();Text(sdata).frame(alignment: .center);Spacer()
                                }
                            }
                            if !dislang.isEmpty{
                                HStack{
                                    Text("从\(dislang)翻译：").bold().frame(alignment: .center)
                                }
                            }
                            HStack{
                                Spacer();Text(translatedText).frame(alignment: .center);Spacer()
                            }
                        }
                        .padding()
                        VStack{
                            Section{
                                Button(action:{translatedText=""
                                    slang=""
                                    dislang=""
                                },label:{
                                    HStack{
                                        Spacer()
                                        Image(systemName: "restart")
                                        Text("重置")
                                        Spacer()
                                    }
                                })
                            }
                        }
                    }
                    
                    Section {
                        NavigationLink(destination:{SettingsView().navigationTitle("设置")},label:{HStack{Spacer();Image(systemName: "gear")
                            Text("设置");Spacer()}})
                        NavigationLink(destination:{AboutView().navigationTitle("关于LWT").containerBackground(Color(hue: 141/360, saturation: 60/100, brightness: 100/100).gradient, for: .navigation)},label:{HStack{Spacer();Image(systemName: "info.circle")
                            Text("关于");Spacer()
                        }})
                    }
                    
                }
                .navigationTitle("LWT翻译")
                .containerBackground(Color(hue: 179/360, saturation: 60/100, brightness: 100/100).gradient, for: .navigation)
                .onAppear(){
                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/status/check"){
                        respond, secceed in
                        if !secceed{
                            NetPing="LossNet"
                        } else if respond["status"] != 0{
                            NetPing="InvaildResp"
                        } else{
                            NetPing="ok"
                        }
                    }
                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/notice?action=get"){
                        resp, succeed in
                        notice=resp["message"].string ?? ""
                    }
                    //SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                    //        for purchase in purchases {
                    //            switch purchase.transaction.transactionState {
                    //            case .purchased, .restored:
                    //                if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    //                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    //                }
                    // Unlock content
                    //            case .failed, .purchasing, .deferred:
                    //                break // do nothing
                    //            }
                    //        }
                    //    }
                }
            } else {
                // Fallback on earlier versions
                List {
                    if debugenable{
                        Section{
                            HStack{
                                Spacer()
                                Text("Debug enabled")
                                Spacer()
                            }
                        }
                    }
                    if NetPing==""{
                        Section{
                            HStack{
                                Image(systemName: "wave.3.forward")
                                Text("正在检查网络连接")
                            }
                        } header: {
                            Text("请等待")
                        }
                    } else if NetPing=="LossNet"{
                        Section{
                            HStack{
                                Image(systemName: "wifi.exclamationmark")
                                Text("尚未连接到互联网")
                            }
                            Button(action: {
                                DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/status/check"){
                                    respond, secceed in
                                    if !secceed{
                                        NetPing="LossNet"
                                    } else if respond["status"] != 0{
                                        NetPing="InvaildResp"
                                    } else{
                                        NetPing="ok"
                                    }
                                }
                            }, label: {
                                Text("重试")
                            })
                        } header: {
                            Text("网络异常，无法翻译")
                        } footer: {
                            Text("LWT需要网络连接以进行在线翻译")
                        }
                    } else if NetPing=="InvaildResp" {
                        Section{
                            HStack{
                                Image(systemName: "xmark.icloud.fill")
                                Text("Linecom API离线")
                            }
                            Button(action: {
                                DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/status/check"){
                                    respond, secceed in
                                    if !secceed{
                                        NetPing="LossNet"
                                    } else if respond["status"] != 0{
                                        NetPing="InvaildResp"
                                    } else{
                                        NetPing="ok"
                                    }
                                }
                            }, label: {
                                Text("重试")
                            })
                        } header: {
                            Text("网络异常，无法翻译")
                        } footer: {
                            Text("请等待一会，马上回来")
                        }
                    } else if NetPing=="ok"{
                        if !hideos9tip{
                            Section{
                                Button("对于watchOS 9的支持已经结束，您不会再收到新版本，Linecom LLC建议您尽快更新watchOS以得到最新的LWT更新",action:{
                                    hideos9tip=true
                                })
                            } header: {
                                Text("公告")
                            } footer:{
                                Text("单击以关闭此消息")
                            }
                        }
                        
                        Section {
                            Picker("源语言",selection: $sourcelang) {
                                if provider=="baidu"{
                                    Text("自动").tag("auto")
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("cht")
                                    Text("英语").tag("en")
                                    Text("日语").tag("jp")
                                    Text("韩语").tag("kor")
                                    Text("法语").tag("fra")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("spa")
                                    Text("波兰语").tag("bl")
                                } else if provider=="tencent"{
                                    Text("自动").tag("auto")
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("zh-TW")
                                    Text("英语").tag("en")
                                    Text("日语").tag("ja")
                                    Text("韩语").tag("ko")
                                    Text("法语").tag("fr")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("es")
                                }
                                
                            }
                            
                            Picker("目标语言",selection: $targetlang) {
                                //debug selection!
                                if debugenable{
                                    Text("自动").tag("auto")
                                }
                                if provider=="baidu"{
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("cht")
                                    Text("英语").tag("en")
                                    Text("日语").tag("jp")
                                    Text("韩语").tag("kor")
                                    Text("法语").tag("fra")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("spa")
                                    Text("波兰语").tag("bl")
                                } else if provider=="tencent"{
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("zh-TW")
                                    Text("英语").tag("en")
                                    Text("日语").tag("ja")
                                    Text("韩语").tag("ko")
                                    Text("法语").tag("fr")
                                    Text("德语").tag("de")
                                    Text("俄语").tag("ru")
                                    Text("西班牙语").tag("es")
                                }
                            }
                            if !cepenable{
                                TextField("键入源语言",text: $slang)
                            } else if cepenable{
                                CepheusKeyboard(input: $slang,prompt:"键入源语言")
                            }
                            Button(action: {
                                // ...
                                requesting = true
                                if slang.isEmpty && !debugenable{
                                    translatedText="请输入文本"
                                    requesting=false
                                } else if provider=="baidu"{
                                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/translate?provider=\(provider)&text=\(slang)&slang=\(sourcelang)&tlang=\(targetlang)&pass=l1nec0m".urlEncoded()){
                                        resp, succeed in
                                        if !succeed{
                                            translatedText="翻译请求发送失败，请联系开发者。"
                                        }
                                        translatedText=resp["trans_result"][0]["dst"].string ?? "翻译返回错误，请联系开发者"
                                        sdata=resp["trans_result"][0]["src"].string ?? "翻译返回错误，请联系开发者"
                                        transfl=resp["from"].string ?? ""
                                        dislang=baidugroup[transfl] ?? ""
                                        requesting=false
                                    }
                                } else if provider=="tencent"{
                                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/translate?provider=\(provider)&text=\(slang)&slang=\(sourcelang)&tlang=\(targetlang)&pass=l1nec0m".urlEncoded()){
                                        resp, succeed in
                                        if !succeed{
                                            translatedText="翻译请求发送失败，请联系开发者。"
                                        }
                                        let finalsdt=slang
                                        translatedText=resp["Response"]["TargetText"].string ?? "翻译返回错误，请联系开发者"
                                        sdata=finalsdt
                                        transfl=resp["Response"]["Source"].string ?? ""
                                        dislang=tencentgroup[transfl] ?? ""
                                        requesting=false
                                    }
                                }
                            }, label: {
                                if requesting {
                                    HStack{
                                        Spacer()
                                        Text("正在请求")
                                        ProgressView()
                                        Spacer()
                                    }
                                } else{
                                    HStack{
                                        Spacer()
                                        Image(systemName: "globe")
                                        Text("翻译")
                                        Spacer()
                                    }
                                }
                                
                                
                            })
                            
                        }
                        Section{
                            NavigationLink(destination: {WYWTranslate().navigationTitle("文言翻译")}, label: {
                                HStack{
                                    Spacer()
                                    Image(systemName: "ellipsis.bubble")
                                    Text("文言文翻译")
                                    Spacer()
                                }
                            })
                        }
                    }
                    if !translatedText.isEmpty {
                        Section {
                            if !slang.isEmpty{
                                HStack{
                                    Spacer();Text(sdata).frame(alignment: .center);Spacer()
                                }
                            }
                            if !dislang.isEmpty{
                                HStack{
                                    Text("从\(dislang)翻译：").bold().frame(alignment: .center)
                                }
                            }
                            HStack{
                                Spacer();Text(translatedText).frame(alignment: .center);Spacer()
                            }
                        }
                        .padding()
                        VStack{
                            Section{
                                Button(action:{translatedText=""
                                    slang=""
                                    dislang=""
                                },label:{
                                    HStack{
                                        Spacer()
                                        Image(systemName: "restart")
                                        Text("重置")
                                        Spacer()
                                    }
                                })
                            }
                        }
                        
                    }
                    
                    Section {
                        NavigationLink(destination:{SettingsView().navigationTitle("设置")},label:{HStack{Spacer();Image(systemName: "gear")
                            Text("设置");Spacer()}})
                        NavigationLink(destination:{AboutView().navigationTitle("关于LWT")},label:{HStack{Spacer();Image(systemName: "info.circle")
                            Text("关于");Spacer()
                        }})
                    }
                    
                }
                .navigationTitle("LWT翻译")
                .onAppear(){
                    if !debugenable{
                        DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/status/check"){
                            respond, secceed in
                            if !secceed{
                                NetPing="LossNet"
                            } else if respond["status"] != 0{
                                NetPing="InvaildResp"
                            } else{
                                NetPing="ok"
                            }
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    ContentView()
}

