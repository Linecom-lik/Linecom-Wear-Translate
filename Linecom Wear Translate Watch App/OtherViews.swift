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
            CerditView().navigationTitle("开发团队")
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
                    Text("1.0.3")
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
                NavigationLink(destination: {LineAboutView()},label:{
                    HStack{
                        Image("LINEAvatar")
                            .resizable()
                            .scaledToFit()
                            .frame(width:43,height:43)
                            .mask{Circle()}
                        Text("澪空\n澪空软件技术\n开发者&责任人")
                    }
                })
                NavigationLink(destination: {MEMZAboutView()},label:{
                    HStack{
                        Image("MEMZAvatar")
                            .resizable()
                            .scaledToFit()
                            .frame(width:43,height:43)
                            .mask{Circle()}
                        Text("WindowsMEMZ\n暗礁工作室\n合作开发者")
                    }
                })
                   
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
            Text("Darockkit\nLicense under none")
        }
    }
}
struct SettingsView: View{
    @AppStorage("RememberLast") var lastenable=true
    var body: some View{
        List{
            
                Section{
                    NavigationLink(destination:{apiconfigView().navigationTitle("配置密钥")},label:{Image(systemName: "key.fill");Text("配置API密钥")})
                    NavigationLink(destination:{SupportView().navigationTitle("联系我们")},label:{Image(systemName: "envelope.open.fill");Text("联系与反馈")})
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
struct LineAboutView: View{
    var body: some View{
        if #available(watchOS 10.0, *) {
            TabView{
                LineInfoView()
                LineContactView()
            }
            .tabViewStyle(.verticalPage)
        } else {
            // Fallback on earlier versions
            ScrollView{
                LineInfoView()
                LineContactView()
            }
            
        }
        
    }
    struct LineInfoView: View{
        var body: some View{
            VStack{
                HStack{
                    Spacer()
                    Image("LINEAvatar")
                        .resizable()
                        .scaledToFit()
                        .mask{Circle()}
                    .frame(width:100, height:100)
                    Spacer()
                }
                Text("澪空Linecom")
                    .font(.title3)
                Text("From 浙江 宁波")
                    .font(.caption)
            }
        }
    }
    struct LineContactView: View{
        var body: some View{
            List{
                VStack{
                    HStack{
                        Image(systemName: "paperplane")
                        Text("澪空软件技术")
                    }
                    HStack{
                        Image(systemName: "info.circle")
                        Text("负责人")
                    }
                    HStack{
                        Image(systemName: "apple.terminal")
                        Text("程序开发")
                    }
                    HStack{
                        Image(systemName: "envelope")
                        Text("linecom@linecom.net.cn").font(.custom("cust", size: 13))
                    }
                }
            }
        }
    }
    
}
struct MEMZAboutView: View{
    var body: some View{
        if #available(watchOS 10.0, *) {
            TabView{
                MEMZInfoView()
                MEMZContactView()
            }
            .tabViewStyle(.verticalPage)
        } else {
            // Fallback on earlier versions
            ScrollView{
                MEMZInfoView()
                MEMZContactView()
            }
        }
        
    }
    struct MEMZInfoView: View{
        var body: some View{
            VStack{
                HStack{
                    Spacer()
                    Image("MEMZAvatar")
                        .resizable()
                        .scaledToFit()
                        .mask{Circle()}
                    .frame(width:100, height:100)
                    Spacer()
                }
                Text("WindowsMEMZ")
                    .font(.title3)
                Text("From 四川 德阳")
                    .font(.caption)
            }
        }
    }
    struct MEMZContactView: View{
        var body: some View{
            List{
                VStack{
                    HStack{
                        Image(systemName: "paperplane")
                        Text("Darock")
                    }
                    HStack{
                        Image(systemName: "info.circle")
                        Text("首席执行官")
                    }
                    HStack{
                        Image(systemName: "apple.terminal")
                        Text("技术支持")
                    }
                    HStack{
                        Image(systemName: "envelope")
                        Text("memz@darock.top").font(.custom("cust", size: 13))
                    }
                }
            }
        }
    }
    
}


#Preview {
    AboutView()
}
