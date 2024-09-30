//
//  WhatsNewView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 程炜栋 on 2024/9/30.
//

import SwiftUI

struct WhatsNewView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("欢迎使用 LWT v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)")
                    .font(.caption2)
                Text("本次更新内容聚焦")
                    .font(.title3)
                    .bold()
                
                Section {
                    HStack {
                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Spacer()
                        VStack {
                            Text("翻译历史记录")
                                .padding()
                                .font(.headline)
                            Text("现在，LWT 会记住你翻译的内容，以便离线查看。")
                                .font(.custom(" ", size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    HStack {
                        Image(systemName: "person.text.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Spacer()
                        VStack {
                            Text("Linecom ID")
                                .padding()
                                .font(.headline)
                            Text("登录 Linecom ID, 体验 Linecom 生态。")
                                .font(.custom(" ", size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    HStack {
                        Image(systemName: "inset.filled.applewatch.case")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                        Spacer()
                        VStack {
                            Text("优化的用户界面")
                                .padding()
                                .font(.headline)
                            Text("更为 watchOS 打造的焕然一新的用户界面。")
                                .font(.custom(" ", size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    WhatsNewView()
}
