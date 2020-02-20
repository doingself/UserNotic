//
//  AppDelegate.swift
//  UserNotic
//
//  Created by doingself on 2020/2/19.
//  Copyright © 2020 syc. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationHandler = NotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("==== \(#function)")
        
        configUserNotificatioins()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        print("==== \(#function)")
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
        print("==== \(#function)")
    }


}

// MARK: Remote Notifications
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //打印出获取到的token字符串
        //let token = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)}).lowercased()
        print("==== \(#function) Get Push token: \(token)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("==== \(#function) error: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("==== \(#function) userInfo: \(userInfo)")
    }
}
// MARK: UserNotifications
extension AppDelegate{
    func configUserNotificatioins(){
        
        //设置通知代理
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        // 权限
        UNUserNotificationCenter.current().getNotificationSettings { (settings: UNNotificationSettings) in
            switch settings.authorizationStatus {
            case UNAuthorizationStatus.authorized:
                // 向APNs请求token
                // 请求授权时异步进行的，这里需要在主线程进行通知的注册
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            case .notDetermined:
                //请求通知权限
                UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, .sound, .badge]) { (accepted: Bool, error: Error?) in
                    if accepted {
                        // 向APNs请求token
                        // 请求授权时异步进行的，这里需要在主线程进行通知的注册
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    print("消息通知权限: \(accepted)")
                }
                
            case .denied:
                // 拒绝
                let url = URL(string: UIApplication.openSettingsURLString)
                if let url = url, UIApplication.shared.canOpenURL(url) {
                    print(url)
                    /*
                    UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: { (suc) in
                        print(suc)
                    }
                    */
                }
                
            default: break
            }
        }
        
        // category
        let newsCategory: UNNotificationCategory = {
            //创建输入文本的action
            let inputAction = UNTextInputNotificationAction(
                identifier: "newsComment",
                title: "评论",
                options: [.foreground],
                textInputButtonTitle: "发送",
                textInputPlaceholder: "在这里留下你想说的话...")
             
            //创建普通的按钮action
            let likeAction = UNNotificationAction(
                identifier: "newsLike",
                title: "点个赞",
                options: [.foreground])
             
            //创建普通的按钮action
            let cancelAction = UNNotificationAction(
                identifier: "newsCancel",
                title: "取消",
                options: [.destructive])
             
            //创建category
            return UNNotificationCategory(identifier: "news", actions: [inputAction, likeAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])
        }()
         
        //把category添加到通知中心
        UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
    }
}
