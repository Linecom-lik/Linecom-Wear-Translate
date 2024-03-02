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
            CerditView().navigationTitle("致谢")
            OSPView().navigationTitle("开源许可")
        }
    }
}
struct AppAbout: View{
    var body: some View{
        VStack{
            Text("Linecom Wear Translate").padding()
            Text("Developed by Linecom").padding()
            Text("License under MIT.")
        }
    }
}
struct CerditView: View{
    var body: some View{
        List{
            Section{
                    HStack{
                        Image("MEMZAvatar").resizable().scaledToFit().frame(width:43,height:43)
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
        List{
            NavigationStack{
                Section{
                    NavigationLink(destination:{apiconfigView().navigationTitle("配置密钥")},label:{Text("配置API密钥")})
                }//footer:{
                  //  Text("您可以配置自己的百度翻译API密钥，以在我们的API密钥额度用尽时转换为您自己的API。")
               // }
            }
            //搁置
            //Section{
            //    Toggle("记录上次语言",isOn: $lastenable)
            //}footer:{
            //       Text("打开此选项，LWT将会记住您上次所用的语言。")
            //    }
        }
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

#Preview {
    AboutView()
}
