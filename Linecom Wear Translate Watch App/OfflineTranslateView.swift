//
//  OfflineTranslateView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/2.
//

import SwiftUI

struct OfflineTranslateView: View {
    @State var input=""
    @State var query=""
    var body: some View {
        List{
            Section{
                Text("离线翻译现仅支持")
                Text("英文-->中文")
                Text("请只键入单词且全小写")
            }
            Section{
                TextField("键入英文",text: $input)
                Button(action: {
                    query=EnuToChs[input] ?? "查询无结果"
                }, label: {
                    HStack{
                        Spacer()
                        Image(systemName: "globe")
                        Text("查询翻译")
                        Spacer()
                    }
                })
            }
            if !query.isEmpty{
                Section{
                    Text("翻译结果为：")
                    HStack{
                        Spacer()
                        Text(query)
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    OfflineTranslateView()
}
