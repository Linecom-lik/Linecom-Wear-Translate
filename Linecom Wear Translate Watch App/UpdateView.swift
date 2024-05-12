//
//  UpdateView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/12.
//

import SwiftUI
import DarockKit
import AuthenticationServices

struct UpdateView: View {
    @State var reqing=true
    @State var latest=""
    @State var success=true
    @State var nowv=Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    var body: some View {
        ScrollView{
            VStack{
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
                        Text("LWT \(latest)")
                        Text("Linecom LLC")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Divider()
                        Text("请前往App Store更新")
                        //List{
                            Button(action: {
                                let session = ASWebAuthenticationSession(url: URL(string: "https://apps.apple.com/app/id6478855138")!, callbackURLScheme: "mlhd") { _, _ in
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

#Preview {
    UpdateView()
}
