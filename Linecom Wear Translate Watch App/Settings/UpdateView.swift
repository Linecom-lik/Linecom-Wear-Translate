//
//  UpdateView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/12.
//

import SwiftUI
import DarockKit
import AuthenticationServices
import Dynamic
import UIKit
import WatchKit

struct UpdateView: View {
    @State var reqing=true
    @State var latest=""
    @State var success=true
    @AppStorage("HomeTipUpdate") var homeTipUpdate = true
    @State var nowv=Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    var body: some View {
        ScrollView{
            VStack{
                    NavigationLink(destination: {HomeTipUpdateControlView()}) {
                        Text("提示更新")
                        if homeTipUpdate {
                            Text("开启")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("关闭")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                if reqing{
                    HStack{
                        Text("正在检查更新")
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .frame(width: 130)
                        //Spacer()
                            .frame(maxWidth: .infinity)
                        ProgressView()
                    }
                } else if !success{
                        Text("检查更新时出错")
                    } else if latest != nowv{
                        HStack {
                            Image("abouticon").resizable().scaledToFit().mask{Circle()}.frame(width: 35)
                            Spacer()
                            VStack {
                                Text("LWT \(latest)")
                                Text("Linecom LLC")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .padding(.bottom, 4)
                        Divider()
                        Text("请前往App Store更新")
                        //List{
                            Button(action: {
                                let session = ASWebAuthenticationSession(url: URL(string: "https://api.linecom.net.cn/lwt/update?action=go")!, callbackURLScheme: "mlhd") { _, _ in
                                    return
                                }
                                session.prefersEphemeralWebBrowserSession = true
                                session.start()
                            }, label:{
                                HStack{
                                    Image(systemName: "applewatch.and.arrow.forward")
                                    Text("打开App Store")
                                }
                            })
                        //}
                    } else if latest==nowv{
                        Text("LWT已是最新版本")
                    }
                }
            }.onAppear(){
            DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/update?action=query"){ resp, succeed in
                if !succeed{
                    reqing=false
                    success=false
                }
                reqing=false
                latest=resp["message"].string ?? ""
            }
        }
    }
}

struct HomeTipUpdateControlView: View {
    @AppStorage("HomeTipUpdate") var homeTipUpdate = true
    var body: some View {
        List {
            Section(content: {
                Toggle("提示更新", isOn: $homeTipUpdate)
            }, footer: {
                Text("关闭后，LWT 在更新就绪时不会在首页或其他位置提示")
            })
        }
    }
}

#Preview {
    UpdateView()
}
