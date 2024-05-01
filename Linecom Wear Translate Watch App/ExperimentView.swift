//
//  ExperimentView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/1.
//

import SwiftUI

struct ExperimentView: View {
    @AppStorage("CepheusEnable") var cepenable=false
    var body: some View {
        List{
            Text("此时暂无实验性功能可供测试")
            //Section(content:{
            //    Toggle("启用兼容性输入",isOn: $cepenable)
            //},footer: {
            //    Text("为Apple Watch SE和Apple Watch Series6及以前的设备提供英文与拼音的全键盘输入。\nPowered by Cepheus")
            //})
        }
    }
}

#Preview {
    ExperimentView()
}
