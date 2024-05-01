//
//  AboutView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/3/2.
//

import SwiftUI
import AuthenticationServices

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
    @AppStorage("debugselect") var debug=false
    @State var ICPPersent=false
    @State var LicensePersent=false
    @State var debugmodepst=false
    var body: some View{
        VStack{
            HStack{
                Image("abouticon").resizable().scaledToFit().mask{Circle()}
                
                VStack{
                    Text("澪空软件")
                    Text("腕表翻译")
                    Text("1.0.6").onTapGesture(count: 10, perform: {
                        debug=true
                        debugmodepst=true
                    }).sheet(isPresented: $debugmodepst, content: {
                        Text("调试选项已启用")
                    })//.font(.custom("ccccc", size: 10))
                }.padding()
            }
            
            Text("Developed by Linecom").padding()

            VStack{
                Text("Licensed under Apache License 2.0.").font(.custom("", size: 12)).sheet(isPresented: $LicensePersent, content: {
                    LicenseView()
                }).onTapGesture {
                    LicensePersent=true
                }
                Spacer()
                Text("浙ICP备2024071295号-3A").font(.custom("", size: 13)).sheet(isPresented: $ICPPersent, content: {ICPView()}).onTapGesture {
                    ICPPersent=true
                }
                //Text("*备案审核进行中，暂时作为PlaceHolder").font(.custom("", size: 6))
            }
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
            Button(action: {
                let session = ASWebAuthenticationSession(url: URL(string: "https://github.com/SwiftyJSON/SwiftyJSON")!, callbackURLScheme: "mlhd") { _, _ in
                    return
                }
                session.prefersEphemeralWebBrowserSession = true
                session.start()
            }, label:{Text("SwiftyJSON\nLicensed under MIT")})
            Button(action: {
                let session = ASWebAuthenticationSession(url: URL(string: "https://github.com/Alamofire/Alamofire")!, callbackURLScheme: "mlhd") { _, _ in
                    return
                }
                session.prefersEphemeralWebBrowserSession = true
                session.start()
            }, label:{Text("Alamofire\nLicensed under MIT")})
            Text("SFSymbol\nLicensed under MIT")
            Text("Darockkit\nLicensed under none")
        }
    }
}
struct SettingsView: View{
    @AppStorage("debugselect") var debugdisplay=false
    @AppStorage("RememberLast") var lastenable=true
    @AppStorage("debugmode") var debugmode=false
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
            if debugdisplay{
                Section(content:{
                    Toggle("调试模式",isOn: $debugmode)
                    Button(action:{
                        debugdisplay=false
                        debugmode=false
                    },label: {
                        Text("隐藏调试选项")
                    })
                },footer:{
                    Text("如您开启调试模式，即表明您愿意接受开启调试模式带来的不稳定性")
                })
            }
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
struct ICPView: View{
    var body: some View{
        List{
            Text("浙ICP备2024071295号-3A").font(.custom("cstom", size: 14))
            Button(action: {
                let session = ASWebAuthenticationSession(url: URL(string: "https://beian.miit.gov.cn")!, callbackURLScheme: "mlhd") { _, _ in
                    return
                }
                session.prefersEphemeralWebBrowserSession = true
                session.start()
            }, label: {
                HStack{
                    Image(systemName: "arrow.up.forward")
                    Text("MIIT网站")
                }
            })
        }.navigationTitle("ICP备案")
    }
}
struct LicenseView: View{
    var body: some View{
        ScrollView{
            Text("""
    Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
"""
            )
        }.navigationTitle("License")
    }
}

#Preview {
    AboutView()
}
