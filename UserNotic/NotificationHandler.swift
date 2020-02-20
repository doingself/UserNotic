//
//  NotificationHandler.swift
//  UserNotic
//
//  Created by doingself on 2020/2/19.
//  Copyright © 2020 syc. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHandler: NSObject {

}

// MARK: UNUserNotificationCenterDelegate
extension NotificationHandler: UNUserNotificationCenterDelegate{
    //在应用内展示通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("==== \(#function) identifier: \(notification.request.identifier)")
        
        // 如果不想显示某个通知，可以直接用空 options
        completionHandler([UNNotificationPresentationOptions.alert, .sound])
        
    }
    
    //对通知进行响应（用户与通知进行交互时被调用）
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("==== \(#function) title: \(response.notification.request.content.title)")
        
        //获取通知附加数据
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        // 添加事件
        configActionWithIdentifier(response: response)
        
        //完成了工作
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
        print("==== \(#function) notification.title: \(notification?.request.content.title)")
        
    }
    
    //处理新闻资讯通知的交互
    private func configActionWithIdentifier(response: UNNotificationResponse) {
        
        guard response.notification.request.content.categoryIdentifier == "news" else {
            return
        }
        
        let message: String
        //判断点击是那个action
        switch response.actionIdentifier {
        case "newsLike": message = "你点击了“点个赞”按钮"
        case "newsCancel": message = "你点击了“取消”按钮"
        case "newsComment":
            message = "你输入的是：\((response as! UNTextInputNotificationResponse).userText)"
        default:
            message = response.actionIdentifier
        }
        
        //在根视图控制器上弹出普通消息提示框
        //let vc = UIApplication.shared.keyWindow?.rootViewController
        if let vc = UIApplication.shared.windows.last?.rootViewController {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel))
            vc.present(alert, animated: true)
        }
    }
}
