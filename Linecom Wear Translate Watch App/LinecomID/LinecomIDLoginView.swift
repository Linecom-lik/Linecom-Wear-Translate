//
//  LinecomIDLoginView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 程炜栋 on 2024/9/30.
//

import SwiftUI
import AuthenticationServices

struct LinecomIDLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isLoading: Bool = false
    @AppStorage("IDAccessToken") var accesstoken = ""
    @AppStorage("IDidToken") var idtoken = ""
    @AppStorage("IDrefreshToken") var refreshtoken = ""
    @AppStorage("IDName") var idname = ""
    @AppStorage("IDEmail") var idemail = ""
    var body: some View {
        ScrollView {
            VStack {
                Text("使用 Linecom ID")
                    .font(.title3)
                    .bold()
                Spacer()
                Section {
                    HStack {
                        Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Spacer()
                        Text("同步你的翻译历史")
                            .padding()
                            .font(.headline)
                    }
                    HStack {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Spacer()
                        Text("为付费扩展做好准备")
                            .font(.headline)
                    }
                    HStack {
                        Image(systemName: "lock.icloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Spacer()
                        Text("防止你的数据丢失")
                            .font(.headline)
                    }
                }
                .padding()
                Button(action: {
                    isLoading = true
                    startAuthentication()
                    isLoading = false
                }, label: {
                    if !isLoading {
                        Text("登录")
                            .frame(width: 300)
                            .padding(5)
                    } else {
                        HStack {
                            Text("登录")
                                .frame()
                                .padding(5)
                            ProgressView()
                        }
                    }
                })
                    .buttonStyle(BorderedProminentButtonStyle())
                    .disabled(isLoading)
            }
        }
    }
    
    func startAuthentication() {
        let authURL = URL(string: "https://idmsa.cn/realms/idpub/protocol/openid-connect/auth?response_type=code&client_id=linecom-wear-translate&redirect_uri=https%3A%2F%2Fapi.linecom.net.cn%2Flwt%2Fcallback&scope=openid%20profile%20email%20offline_access")! // PHP 后端认证 URL
        let callbackScheme = "linecomweart" // 自定义 URL Scheme
        
        let sess = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "linecomweart") { respond, error in
            if let callbackURL = respond {
                handleAuthCallback(url: callbackURL)
            }
        }
        sess.start()
    }
    
    func handleAuthCallback(url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        
        // 从 URL 中提取用户名和电子邮件
        if let name = queryItems?.first(where: { $0.name == "name" })?.value {
            self.idname = name.replacingOccurrences(of: "+", with: " ")
        }
        
        if let email = queryItems?.first(where: { $0.name == "email" })?.value {
            self.idemail = email.removingPercentEncoding!
        }
        
        if let accessToken = queryItems?.first(where: { $0.name == "access_token" })?.value {
            self.accesstoken = accessToken
        }
        if let idToken = queryItems?.first(where: { $0.name == "id_token" })?.value {
            self.idtoken = idToken
        }
        if let refreshToken = queryItems?.first(where: { $0.name == "refresh_token" })?.value {
            self.refreshtoken = refreshToken
        }
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    LinecomIDLoginView()
}
