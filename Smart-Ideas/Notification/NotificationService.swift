//
//  NotificationService.swift
//  CDCKDemo
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import UserNotifications
import CloudKit
import UIKit

class NotificationService {
    static let shared = NotificationService()
    
    var delegate : NotificationDelegate?
    
    //request push notification authorization
    func registerNotification(){
        let center  = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            }
        }
    }
    
    func registerSubscription(){
        let userDefaults = UserDefaults.standard
        let subscribed = userDefaults.bool(forKey: "subscribed_idea")
        
        if !subscribed {
            let predicate = NSPredicate(value: true)
            let subscription = CKQuerySubscription(recordType: "Idea", predicate: predicate, subscriptionID: "CreationIdea", options: CKQuerySubscription.Options.firesOnRecordCreation)
            
            let notificationInfo = CKSubscription.NotificationInfo()
            notificationInfo.alertLocalizationKey = "Idea Created"
            notificationInfo.shouldBadge = true
            notificationInfo.shouldSendContentAvailable = true
            
            subscription.notificationInfo = notificationInfo
            
            CloudKitService.shared.publicDatabase.save(subscription) { (subscription, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                }else{
                    userDefaults.set(true, forKey: "subscribed")
                }
            }
            
        }
        
    }
    
    func notify(userInfo: [AnyHashable : Any]){
        
        let ck = userInfo["ck"] as! [String: Any]
        let qry = ck["qry"] as! [String: Any]
        let orderID = qry["rid"] as! String

        let recordID = CKRecord.ID(recordName: orderID)
        let ckNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo)
        
        if ckNotification?.recordID != nil {
            DispatchQueue.main.async {
                CloudKitService.shared.publicDatabase.fetch(withRecordID: recordID) { (record, error) in
                    if let record = record {
                        self.delegate?.receivedNotification(record: record)
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                }
                
            }
        }
        
    }
}
