//
//  AboutView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/3/2.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        TabView{
            AppAbout()
            //CerditView().navigationTitle("致谢")
            OSPView().navigationTitle("开源许可")
        }
    }
}
struct AppAbout: View{
    var body: some View{
        VStack{
            HStack{
                Image("abouticon").resizable().scaledToFit().mask{Circle()}
                VStack{
                    Text("澪空软件\n腕表翻译").padding()
                    Text("1.0.2")
                }
            }
            
            Text("Developed by Linecom").padding()
            
            Text("License under MIT.").font(.custom("", size: 12))
            Text("浙ICP备2024071295号-3A").font(.custom("", size: 11))
            //Text("*备案审核进行中，暂时作为PlaceHolder").font(.custom("", size: 6))
        }
    }
}
struct CerditView: View{
    var body: some View{
        List{
            Section{
                    HStack{
                        Image("MEMZAvatar")
                            .resizable()
                            .scaledToFit()
                            .frame(width:43,height:43)
                            .mask{Circle()}
                        Text("WindowsMEMZ\n提供代码指导。")
                    }
            }
        }
    }
}
struct OSPView: View{
    var body: some View{
        List{
            Text("SwiftyJSON\nLicense under MIT")
            Text("Alamofire\nLicense under MIT")
            Text("SFSymbol\nLicense under MIT")
        }
    }
}
struct SettingsView: View{
    @AppStorage("RememberLast") var lastenable=true
    var body: some View{
            NavigationStack{
                Section{
                    NavigationLink(destination:{apiconfigView().navigationTitle("配置密钥")},label:{Text("配置API密钥")})
                    
                }
                Section{
                    NavigationLink(destination:{SupportView().navigationTitle("联系我们")},label:{Text("联系与反馈")})
                }
            }
            //搁置
            //Section{
            //    Toggle("记录上次语言",isOn: $lastenable)
            //}footer:{
            //       Text("打开此选项，LWT将会记住您上次所用的语言。")
            //    }
    }
}
struct apiconfigView: View{
    @AppStorage("ApiKeyStatus") var customkeyenable=false
    @AppStorage("CustomAppid") var custid=""
    @AppStorage("CustomKey") var custkey=""
    var body: some View{
        List{
            Section{
                Text("概述：")
                Text("百度翻译自2022年8月1日起将每月免费的调用额度限制在100万字符，如果您有自己的密钥，您可以在此替换由澪空软件提供的默认密钥")
            }
            Section{
                Toggle("使用自定义密钥",isOn: $customkeyenable)
            }
            if customkeyenable{
                
                Section{
                    TextField("APPID",text: $custid)
                    TextField("密钥",text: $custkey)
                }
            }
        }
    }
}
struct SupportView: View{
    var body: some View{
        List{
            Text("请通过邮件联系我们：")
            Text("linecom@linecom.net.cn").font(.custom("", size: 15))
            Text("若您遇到了问题，请发送支持工单：")
            Text("support@linecom.net.cn").font(.custom("", size: 15))
        }
    }
}

#Preview {
    AboutView()
}
