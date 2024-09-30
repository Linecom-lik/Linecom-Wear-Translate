//
//  HistoryView.swift
//  Linecom Wear Translate
//
//  Created by 程炜栋 on 2024/9/30.
//


import SwiftUI

struct HistoryView: View {
    @State private var historys: [History] = ExpHistoryCTL().readHistory().reversed()
    var body: some View {
        List {
            if !historys.isEmpty {
                ForEach(0..<historys.count, id: \.self) { i in
                    NavigationLink(destination: {
                        HistoryDetailView(slang: historys[i].slang, tlang: historys[i].tlang, stext: historys[i].stext, ttext: historys[i].ttext)
                    }, label: {
                        VStack(alignment: .leading) {
                            Text("\(historys[i].stext) -> \(historys[i].tlang)")
                                .font(.headline)
                            Text(historys[i].ttext)
                                .font(.subheadline)
                        }
                    })
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            ExpHistoryCTL().deleteHistory(history: historys[i])
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            } else {
                Text("无历史记录")
            }
        }
        .navigationTitle("历史记录")
        .onAppear() {
            historys = ExpHistoryCTL().readHistory().reversed()
        }
    }
}

#Preview {
    HistoryView()
}
