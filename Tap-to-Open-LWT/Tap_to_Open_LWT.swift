//
//  Tap_to_Open_LWT.swift
//  Tap-to-Open-LWT
//
//  Created by 程炜栋 on 2024/10/24.
//

import WidgetKit
import SwiftUI

// 定义小组件的数据结构
struct GreetingEntry: TimelineEntry {
    let date: Date
    let greeting: String
}

// 创建提供者
struct GreetingProvider: TimelineProvider {
    
    // 占位符数据（当小组件加载时显示）
    func placeholder(in context: Context) -> GreetingEntry {
        GreetingEntry(date: Date(), greeting: "你好")
    }
    
    // 快速预览时显示的数据
    func getSnapshot(in context: Context, completion: @escaping (GreetingEntry) -> Void) {
        let entry = GreetingEntry(date: Date(), greeting: getGreeting(for: Date()))
        completion(entry)
    }
    
    // 实际数据
    func getTimeline(in context: Context, completion: @escaping (Timeline<GreetingEntry>) -> Void) {
        var entries: [GreetingEntry] = []
        
        // 定义一天中的不同时间节点
        let morning = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
        let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let evening = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        let night = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
        
        // 在这些时间节点上创建条目
        let times = [morning, noon, evening, night]
        
        for time in times {
            let entry = GreetingEntry(date: time, greeting: getGreeting(for: time))
            entries.append(entry)
        }
        
        // 创建时间线，重复这些时间点
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    // 根据时间返回不同的问候语
    func getGreeting(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 6..<12:
            return "早上好"
        case 12..<18:
            return "下午好"
        case 18..<22:
            return "晚上好"
        default:
            return "凌晨好"
        }
    }
}

// 小组件视图
struct GreetingWidgetEntryView : View {
    var entry: GreetingProvider.Entry
    
    var body: some View {
        HStack {
            Image("abouticon")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            VStack {
                Text(entry.greeting)
                Text("使用 LWT 翻译")
            }
        }
        .containerBackground(Color(hue: 170/360, saturation: 100/100, brightness: 100/100).gradient, for: .widget)
    }
}

// 小组件配置
@main
struct GreetingWidget: Widget {
    let kind: String = "GreetingWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GreetingProvider()) { entry in
            GreetingWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("快速翻译")
        .description("快速打开 LWT 翻译")
    }
}
