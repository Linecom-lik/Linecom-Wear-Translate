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
    @AppStorage("RememberLast") var lastenable=true
    @State var translatedText = ""
    @State var appid="20221006001373645"
    @State var apikey="7YH2L_U7dSHwqq6OErqB"
    @AppStorage("CustomAppid") var custid=""
    @AppStorage("CustomKey") var custkey=""
    @AppStorage("ApiKeyStatus") var custkeyenable=false
    @State var dislang=""
    @State var sdata=""
    @State var requesting=false
    @AppStorage("LastSource") var sourcelang="auto"
    @AppStorage("LastTarget") var targetlang="en"
    @State var errcode=0
    @State var errinfo=""
    @AppStorage("debugmode") var debugenable=false
    @AppStorage("Offlinetrans") var offlineenable=false
    @AppStorage("CepheusEnable") var cepenable=false
    @State var NetPing=""
    var body: some View {
        //搁置
        //if !lastenable{
         //   var sourcelang="auto"
        //    var targetlang="en"
        //}
        NavigationStack {
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
                } header: {
                    Text("网络异常，无法翻译")
                } footer: {
                    Text("请等待一会，马上回来")
                }
                } else if NetPing=="ok"{
                    Section {
                        Picker("源语言",selection: $sourcelang) {
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
                            
                        }
                        Picker("目标语言",selection: $targetlang) {
                            //debug selection!
                            if debugenable{
                                Text("自动").tag("auto")
                            }
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
                                    errcode=0
                                    errinfo=""
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
                SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                        for purchase in purchases {
                            switch purchase.transaction.transactionState {
                            case .purchased, .restored:
                                if purchase.needsFinishTransaction {
                                    // Deliver content from server, then:
                                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                                }
                                // Unlock content
                            case .failed, .purchasing, .deferred:
                                break // do nothing
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

