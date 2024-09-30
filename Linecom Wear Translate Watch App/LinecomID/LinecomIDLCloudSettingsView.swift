//
//  LinecomIDLCloudSettingsView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 程炜栋 on 2024/9/30.
//

import SwiftUI

struct LinecomIDLCloudSettingsView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.badge.xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 55)
            Text("Linecom Cloud 暂未就绪")
                .font(.caption)
                .bold()
            Text("请稍后回来，好戏不怕晚。")
                .font(.caption2)
                .padding()
        }
        .navigationTitle("云服务设置")
    }
}

#Preview {
    LinecomIDLCloudSettingsView()
}
