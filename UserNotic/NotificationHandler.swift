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
        
        //完成了工作
        completionHandler()
    }
    
}
