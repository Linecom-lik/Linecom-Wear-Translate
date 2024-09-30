//
//  HistoryDetailView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 程炜栋 on 2024/9/30.
//

import SwiftUI

struct HistoryDetailView: View {
    @State var slang: String
    @State var tlang: String
    @State var stext: String
    @State var ttext: String
    var body: some View {
        List {
            Section {
                Text("\(stext)")
                Text("从 \(slang) 翻译为 \(tlang):")
                    .bold()
                Text("\(ttext)")
            }
        }
    }
}

