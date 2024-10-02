//
//  ContentView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/3/1.
//

import SwiftUI
import DarockKit
//import CommonCrypto
import CepheusKeyboardKit
import AuthenticationServices
//import SwiftyStoreKit
import UIKit
import Dynamic


struct ContentView: View {
    @AppStorage("IDrefreshToken") var refresh = ""
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
    @State var isQQPresent=false
    @State var NetPing=""
    @State var checking=false
    @AppStorage("LinecomIDPresented") var firstpresent=false
    @AppStorage("IDAccessToken") var accesstoken = ""
    @AppStorage("IDidToken") var idtoken = ""
    @AppStorage("IDName") var idname = ""
    @AppStorage("IDEmail") var idemail = ""
    @State var isLinecomIDSuggestSheetPresent = false
    @State var isWhatsNewSheetPresent = false
    @AppStorage("WhatsNewPresent") var newpresent = false
    @State var upchecked = false
    @State var isUpdateTipAlertPresent = false
    @AppStorage("UpdateTipedTimes") var updateTipTimes = 0
    @AppStorage("NowVersion") var nowv = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    @State var baidugroup=["zh":"简体中文","cht":"繁体中文","en":"英语","jp":"日语","kor":"韩语","fra":"法语","ru":"俄语","de":"德语","spa":"西班牙语","bl":"波兰语"]
    @State var tencentgroup=["zh":"简体中文","zh-TW":"繁体中文","en":"英语","ja":"日语","ko":"韩语","fr":"法语","ru":"俄语","de":"德语","es":"西班牙语"]
    @State var aligroup=["zh":"简体中文","zh-tw":"繁体中文","en":"英语","ja":"日语","ko":"韩语","fr":"法语","ru":"俄语","de":"德语","es":"西班牙语"]
    @State var transfl=""
    @State var notice=""
    @AppStorage("recordHistory") var enableHistory = true
    @State var latest=""
    @AppStorage("HomeTipUpdate") var homeTipUpdate = true
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
                        if latest != nowv && upchecked && homeTipUpdate {
                            Section{
                                NavigationLink(destination: {UpdateView().navigationTitle("软件更新")}, label: {
                                    HStack{
                                        Image(systemName: "arrow.up.circle.badge.clock")
                                            .padding()
                                        VStack {
                                            Text("有软件更新可用")
                                            Text("v\(latest) 现已就绪")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                })
                                
                            }
                        }
                        if !notice.isEmpty{
                            Section{
                                Text(notice)
                                    .swipeActions(content: {
                                        Button(action: {
                                            notice.removeAll()
                                        }, label: {
                                            Image(systemName: "xmark")
                                        })
                                    })
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
                                } else if provider=="ali"{
                                    Text("自动").tag("auto")
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("zh-tw")
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
                                } else if provider=="ali"{
                                    Text("简体中文").tag("zh")
                                    Text("繁体中文").tag("zh-tw")
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
                                if slang.isEmpty{
                                    TextField("键入源语言",text: $slang)
                                } else {
                                    TextField("键入源语言",text: $slang, onCommit: {
                                        dislang.removeAll()
                                        translatedText=""
                                    })
                                        .swipeActions(edge: .trailing) {
                                            Button(action:{translatedText=""
                                                slang=""
                                                dislang=""
                                            },label:{
                                                Image(systemName: "xmark.circle.fill")
                                            })
                                        }
                                    }
                            } else if cepenable{
                                CepheusKeyboard(input: $slang,prompt:"键入源语言")
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
                        }
                    }
                    
                }
                .navigationTitle("翻译")
                .containerBackground(Color(hue: 179/360, saturation: 60/100, brightness: 100/100).gradient, for: .navigation)
                .toolbar() {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: {WYWTranslate().navigationTitle("文言翻译")}, label: {
                            HStack{
                                
//                                Image(systemName: "ellipsis.bubble")
                                Text("文言")
                                
                            }
                        })
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(destination:{SettingsView().navigationTitle("设置")},label:{
                            Image(systemName: "gear")
                        })
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        NavigationLink(destination: {HistoryView()}, label: {
                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        })
                        Spacer()
                        if NetPing == "ok"||debugenable{
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
                                        if enableHistory{
                                            let history=History(slang: baidugroup[sourcelang] ?? "", tlang: baidugroup[targetlang] ?? "", stext: slang, ttext: translatedText)
                                            ExpHistoryCTL().saveHistory(history: history)
                                            
                                        }
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
                                        if enableHistory{
                                            let history=History(slang: tencentgroup[sourcelang] ?? "", tlang: tencentgroup[targetlang] ?? "", stext: slang, ttext: translatedText)
                                            ExpHistoryCTL().saveHistory(history: history)
                                            
                                        }
                                        requesting=false
                                    }
                                } else if provider=="ali"{
                                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/translate?provider=\(provider)&text=\(slang)&slang=\(sourcelang)&tlang=\(targetlang)&pass=l1nec0m".urlEncoded()){
                                        resp, succeed in
                                        if !succeed{
                                            translatedText="翻译请求发送失败"
                                        }
                                        let finalsdt=slang
                                        translatedText=resp["Data"]["Translated"].string ?? "翻译返回错误"
                                        sdata=finalsdt
                                        transfl=slang
                                        dislang=aligroup[transfl] ?? ""
                                        if enableHistory{
                                            let history=History(slang: aligroup[sourcelang] ?? "", tlang: aligroup[targetlang] ?? "", stext: slang, ttext: translatedText)
                                            ExpHistoryCTL().saveHistory(history: history)
                                            
                                        }
                                        requesting=false
                                    }
                                }
                            }, label: {
                                if requesting {
                                        ProgressView()
                                } else{
                                        Image(systemName: "globe")
//                                        Text("翻译")
                                }
                            })
                            .disabled(slang.isEmpty)
                        }
                        
                    }
                }
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
                    DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/update?action=query"){ resp, succeed in
                        latest=resp["message"].string ?? ""
                        upchecked = true
                    }
//                    if nowv == latest && upchecked {
//                        updateTipTimes = 0
//                    }
//                    if nowv != latest && upchecked && homeTipUpdate {
//                        updateTipTimes += 1
//                    }
//                    if updateTipTimes == 5 || updateTipTimes == 10 || updateTipTimes == 13 && homeTipUpdate {
//                        isUpdateTipAlertPresent = true
//                    }
                    refreshToken() { gotToken in
                        
                    }
                    if !firstpresent&&accesstoken.isEmpty{
                        isLinecomIDSuggestSheetPresent = true
                    }
                    if nowv != Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String {
                        newpresent=false
                    }
                    if !newpresent {
                        isWhatsNewSheetPresent = true
                    }
                    
                }
                .sheet(isPresented: $isLinecomIDSuggestSheetPresent, onDismiss: {
                    firstpresent=true
                }, content: {
                    LinecomIDLoginView()
                })
                .sheet(isPresented: $isWhatsNewSheetPresent, onDismiss: {
                    newpresent=true
                }, content: {
                    WhatsNewView()
                })
                .alert(isPresented: $isUpdateTipAlertPresent, content: {
                    Alert(title: Text("LWT 有更新可用"), message: Text("LWT 版本 \(latest) 已就绪，请前往 App Store 更新"), primaryButton: .cancel(Text("稍后提醒"), action: {
                        if updateTipTimes == 13 {
                            updateTipTimes = 0
                        }
                    }), secondaryButton:  .default(Text("现在更新"), action: {
                        UpdateView()
                    }))
                })
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
    func refreshToken(completion: @escaping (String?) -> Void) {
                
        var request = URLRequest(url: URL(string: "https://idmsa.cn/realms/idpub/protocol/openid-connect/token")!)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
        let body = "grant_type=refresh_token&refresh_token=\(refresh)&client_id=linecom-wear-translate&client_secret=KOINKkvdOQm28WXSvGaf9eWAPEkwQ5CJ"
        request.httpBody = body.data(using: .utf8)
                
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to refresh token: \(error?.localizedDescription ?? "Unknown error")")
                self.accesstoken.removeAll()
                self.refresh.removeAll()
                self.idname.removeAll()
                self.idtoken.removeAll()
                self.idemail.removeAll()
                return
            }
            
            if let tokenData = try? JSONDecoder().decode(TokenResponse.self, from: data) {
            // 更新本地存储的访问令牌
            self.refresh = tokenData.refreshToken!
                self.accesstoken = tokenData.accessToken
            }
        }
            
        task.resume()
    }
}


struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
        
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

#Preview {
    ContentView()
}

