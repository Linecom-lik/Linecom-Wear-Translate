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
            Text("@WindowsMEMZ\n提供代码指导。")
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

#Preview {
    AboutView()
}
