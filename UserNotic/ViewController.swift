//
//  ViewController.swift
//  UserNotic
//
//  Created by doingself on 2020/2/19.
//  Copyright © 2020 syc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "UserNotificatioin"
        self.view.backgroundColor = UIColor.white
        
        let add = getButton(tag: 1, title: "add")
        let get = getButton(tag: 2, title: "get")
        let del = getButton(tag: 3, title: "del")
        
        self.view.addSubview(add)
        self.view.addSubview(get)
        self.view.addSubview(del)
        
        add.frame = CGRect(x: 100, y: 100, width: 100, height: 35)
        get.frame = CGRect(x: 100, y: 150, width: 100, height: 35)
        del.frame = CGRect(x: 100, y: 200, width: 100, height: 35)
    }
    
    func getButton(tag: Int, title: String) -> UIButton {
        let btn = UIButton()
        btn.tag = tag
        btn.setTitle(title, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(self.buttonAction(sender:)), for: UIControl.Event.touchUpInside)
        return btn
    }
    
    @objc func buttonAction(sender: UIButton){
        let tag = sender.tag
        switch tag {
        case 1:
            createLocalUserNotifications()
            
        case 2:
            getLocalUserNotificatoins()
            
        case 3:
            deleteLocalUserNotificatioins()
            
        default:
            break
        }
    }
}

// MARK: UserNotificatons
extension ViewController {
    func createLocalUserNotifications(){
        print("==== \(#function)")
        
        //设置推送内容
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.subtitle = "subtitle"
        content.body = "body"
        content.badge = 2
        content.userInfo = ["key": "value"]
         
        //设置通知触
        /*
         // 指定日期时间触发（UNCalendarNotificationTrigger）
         var components = DateComponents()
         components.year = 2017
         components.month = 11
         components.day = 11
         let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
         
         // 根据位置触发（UNLocationNotificationTrigger）
         let coordinate = CLLocationCoordinate2D(latitude: 52.10, longitude: 51.11)
         let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "center")
         region.notifyOnEntry = true  //进入此范围触发
         region.notifyOnExit = false  //离开此范围不触发
         let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
         */
        // 一段时间后触发（UNTimeIntervalNotificationTrigger）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
         
        //设置请求标识符, 可用相同的标识符进行更新 content
        let requestIdentifier = "identifier-\(Date().timeIntervalSince1970)"
         
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
         
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
    }
    
    func getLocalUserNotificatoins(){
        print("==== \(#function)")
        
        // 获取所有待推送的通知
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            //遍历所有未推送的request
            for request in requests {
                print("pending ==== \(request)")
            }
        }
        
        //获取所有已推送的通知
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications: [UNNotification]) in
            //遍历所有已推送的通知
            for notification in notifications {
                print("delivered ==== \(notification)")
            }
        }
    }
    
    func deleteLocalUserNotificatioins(){
        print("==== \(#function)")
        
        //取消未发送的通知
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["identifier"])
        //取消全部未发送通知
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // 删除已发送的通知（清除通知中心里的记录）
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["identifier"])
        //删除全部已发送通知
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
