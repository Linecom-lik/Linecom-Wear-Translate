//
//  ExperimentView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/1.
//

import SwiftUI

struct ExperimentView: View {

    @AppStorage("Offlinetrans") var offlinet=false
    var body: some View {
        List{
            Text("此时暂无实验性功能可供测试")
            
        }
    }
}

#Preview {
    ExperimentView()
}
