//
//  ExpHistoryCTL.swift
//  Linecom Wear Translate
//
//  Created by 程炜栋 on 2024/9/30.
//


import Foundation
import DarockKit
import Alamofire

class ExpHistoryCTL {
    func saveHistory(history: History) {
        let userDefaults = UserDefaults.standard
        var historys = readHistory()
        historys.append(history)
        if let encodedHistorys = try? JSONEncoder().encode(historys) {
            userDefaults.set(encodedHistorys, forKey: "historys")
        }
    }
    
    func readHistory() -> [History] {
        let userDefaults = UserDefaults.standard
        
        // 获取存储的书签数据
        if let savedHistorysData = userDefaults.data(forKey: "historys") {
            // 使用JSON解码器将Data转换为书签数组
            if let savedHistorys = try? JSONDecoder().decode([History].self, from: savedHistorysData) {
                return savedHistorys
            }
        }
        
        return []
    }
    
    func uploadtoLCloud(accesstoken: String) -> Bool {
        var isSuccess = false
        let Headers: HTTPHeaders = [
            "Authorization": "Bearer \(accesstoken)",
            "Content-Type": "application/json"
        ]
        let userDefaults = UserDefaults.standard
        if let savedHistorysData = userDefaults.data(forKey: "historys") {
            DarockKit.Network.shared.requestJSON("https://api.linecom.net.cn/lwt/history/sync", method: .post, parameters: ["historys": savedHistorysData], headers: Headers) { resp, succeed in
                if succeed && resp["status"].int == 0 {
                    isSuccess = true
                }
            }
        }
        if isSuccess {
            return true
        } else {
            return false
        }
    }
    
    func deleteHistory(history: History) {
        var bookmarks = readHistory()
        if let index = bookmarks.firstIndex(where: { $0.id == history.id }) {
            bookmarks.remove(at: index)
            if let encodedBookmarks = try? JSONEncoder().encode(bookmarks) {
                UserDefaults.standard.set(encodedBookmarks, forKey: "historys")
            }
        }
    }
}

struct History: Identifiable, Codable {
    let id: UUID
    var slang: String
    var tlang: String
    var stext: String
    var ttext: String
    
    init(slang: String, tlang: String, stext: String, ttext: String) {
        self.id = UUID()
        self.slang = slang
        self.tlang = tlang
        self.stext = stext
        self.ttext = ttext
    }
}
