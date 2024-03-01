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
        }
    }
}
struct AppAbout: View{
    var body: some View{
        VStack{
            Text("Linecom Wear Translate").padding()
            Text("Developed by Linecom").padding()
        }
    }
}

#Preview {
    AboutView()
}
