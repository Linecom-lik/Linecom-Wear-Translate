//
//  LinecomIDMgmtView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 程炜栋 on 2024/9/30.
//

import SwiftUI
import DarockKit
import AuthenticationServices

struct LinecomIDMgmtView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("IDAccessToken") var idAccessToken = ""
    @AppStorage("IDidToken") var idToken = ""
    @AppStorage("IDName") var idname = ""
    @AppStorage("IDEmail") var idemail = ""
    @AppStorage("IDrefreshToken") var idrefreshToken = ""
    @State var isAccountMgmtORCodeSheetPresent = false
    @State var isLogoutFailedAlertPresented = false
    @State var LogoutLoading = false
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 75)
                            Spacer()
                        }
                        VStack {
                            Text("\(idname)")
                                .font(.caption)
//                                .padding(.bottom, 5)
                            Text("\(idemail)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    .padding()
                }
                Section {
                    Button(action: {
                        isAccountMgmtORCodeSheetPresent = true
                    }, label: {
                        Text("管理你的 Linecom ID")
                    })
                }
                .sheet(isPresented: $isAccountMgmtORCodeSheetPresent, content: {
                    VStack {
                        Text("扫描 QR 码以继续")
                        Image("IDMgmtQR")
                            .resizable()
                            .scaledToFit()
                    }
                    .navigationTitle("账号管理")
                })
                Section(content: {
                    NavigationLink(destination: {LinecomIDLCloudSettingsView()}) {
                        HStack {
                            Image(systemName: "cloud.fill")
                            Text("云同步设置")
                        }
                        
                    }
                }, footer: {
                    Text("由 Linecom Cloud Access 强力驱动")
                })
                
                Section {
                    Button(action: {
                        LogoutLoading = true
                        DarockKit.Network.shared.requestString("https://idmsa.cn/realms/idpub/protocol/openid-connect/logout?id_token_hint=\(idToken)") { resp, succeed in
                            if !succeed {
                                isLogoutFailedAlertPresented = true
                            }
                            if succeed {
                                idAccessToken.removeAll()
                                idToken.removeAll()
                                idname.removeAll()
                                idemail.removeAll()
                                idrefreshToken.removeAll()
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                        }
                        LogoutLoading = false
                    }, label: {
                        if LogoutLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("退出登录")
                                .foregroundColor(.red)
                        }
                    })
                    .disabled(LogoutLoading)
                    .alert(isPresented: $isLogoutFailedAlertPresented) {
                        Alert(title: Text("Linecom ID"), message: Text("无法退出登录"), dismissButton: .default(Text("确定")))
                    }
                }
            }
        }
    }
}

#Preview {
    LinecomIDMgmtView()
}
