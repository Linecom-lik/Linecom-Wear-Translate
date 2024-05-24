//
//  NoticeDetailView.swift
//  Linecom Wear Translate Watch App
//
//  Created by 澪空 on 2024/5/24.
//

import SwiftUI

struct NoticeDetailView: View {
    var DetlText: String=""
    var body: some View {
        List{
            Text(DetlText)
        }
    }
}

#Preview {
    NoticeDetailView()
}
