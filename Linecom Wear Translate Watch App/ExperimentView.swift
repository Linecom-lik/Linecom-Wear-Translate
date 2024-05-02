//
//  ExperimentView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/1.
//

import SwiftUI

struct ExperimentView: View {
    @AppStorage("CepheusEnable") var cepenable=false
    @AppStorage("Offlinetrans") var offlinet=false
    var body: some View {
        List{
            //Text("此时暂无实验性功能可供测试")
            //Section(content:{
            //    Toggle("启用兼容性输入",isOn: $cepenable)
            //},footer: {
            //    Text("为Apple Watch SE和Apple Watch Series6及以前的设备提供英文与拼音的全键盘输入。\nPowered by Cepheus")
            //})
            Section(content:{
                Toggle("启用离线翻译",isOn: $offlinet)
            },footer: {
                Text("离线翻译在有限的词库中为您提供英语单词至简体中文的翻译\n目前离线翻译词库已收集250个单词。\n离线词库内置于App，随App版本更新而更新\n当前版本：1.0.10045")
            })
        }
    }
}

#Preview {
    ExperimentView()
}
