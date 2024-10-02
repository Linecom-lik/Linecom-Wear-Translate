//
//  AppDelegate.swift
//  Linecom Wear Translate
//
//  Created by 程炜栋 on 2024/10/2.
//


import WatchKit
import PushKit

class AppDelegate: NSObject, WKExtensionDelegate, PKPushRegistryDelegate {

    var pushRegistry: PKPushRegistry!

    func applicationDidFinishLaunching() {
        // 初始化 PushKit 并注册推送类型
        setupPushKit()
    }

    func setupPushKit() {
        // 创建 PKPushRegistry 实例并设置其代理
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = self
        
        // 注册 VoIP 推送类型（也可以根据需求注册其他类型）
        pushRegistry.desiredPushTypes = [.voIP]
    }

    // MARK: - PKPushRegistryDelegate

    // 当设备成功注册推送时会调用此方法，并返回推送凭证
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        // 将推送凭证发送到服务器
        let token = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        print("PushKit Token: \(token)")
    }

    // 当收到推送时调用此方法
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//        // 处理收到的推送通知
//        print("Received Push: \(payload.dictionaryPayload)")
//    }

    // 处理推送注册失败
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("PushKit Token invalidated for \(type)")
    }
}
