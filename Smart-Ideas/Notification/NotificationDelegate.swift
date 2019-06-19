//
//  NotificationDelegate.swift
//  CDCKDemo
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import CloudKit

protocol NotificationDelegate {
    func receivedNotification(record: CKRecord)
}
