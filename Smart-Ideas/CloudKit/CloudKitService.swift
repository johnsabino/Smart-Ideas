//
//  CloudKitService.swift
//  CDCKDemo
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import CloudKit
import SwiftUI
import Combine


class CloudKitService: BindableObject {

    static let shared = CloudKitService()
    let container = CKContainer.default()
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let publicDatabase = CKContainer.default().publicCloudDatabase
    let sharedDatabase = CKContainer.default().sharedCloudDatabase
    
    var didChange = PassthroughSubject<CloudKitService, Never>()
    
    var ideas: [CK_Idea] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    func getCurrentUserRecordId(completion: @escaping (CKRecord.ID?) -> Void) {
        container.fetchUserRecordID { (recordID, error) in
            guard let recordID = recordID, error == nil else {
                print("An error occurred when fetching user record ID.")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(recordID)
            }
        }
    }
    
    func save<T: CloudKitProtocol>(_ record: T, in database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase,
              result: @escaping (T?) -> (),
              errorCase: @escaping (Error?) -> ()) {
    
        guard let record = record.record else {return}
        
        database?.save(record) { (record, error) in
            if let error = error {
                errorCase(error)
                return
            }
            
            if let postRecord = record {
                result(T(ckRecord: postRecord))
                return
            }
            
            result(nil)
        }
    }
    
    func queryRecord(recordType: CKRecord.RecordType, in database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase, predicate: NSPredicate, retrieving: @escaping (CKRecord) -> Void, completion: @escaping (CKQueryOperation.Cursor?, Error?) -> Void) {
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let sortCreation = NSSortDescriptor(key: "creationDate", ascending: false)
        query.sortDescriptors = [sortCreation]
        
        let queryOperation = CKQueryOperation(query: query)
        
        database?.add(queryOperation)
        
        queryOperation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                retrieving(record)
            }
        }
        
        queryOperation.queryCompletionBlock = { (cursor, error) in
            guard error == nil else {
                print("An error occurred during record querying.")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(cursor, error)
            }
        }
    }
    
    func getAll<T: CloudKitProtocol>(entity: T.Type, recordType: CKRecord.RecordType, in database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase,
             withSortDescriptors sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "creationDate", ascending: false)]) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        
        database?.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error)
                //errorCase(error)
                return
            }
            
            DispatchQueue.main.async {
                guard let records = records else {return}
                
                let ideasMap = records.map({ (record) -> T in
                    T(ckRecord: record)
                }) as! [CK_Idea]
                
                self.ideas = ideasMap
            }
        }
    }
    

    func fetch(recordID : CKRecord.ID){
        publicDatabase.fetch(withRecordID: recordID) { (record, error) in
            
        }
    }
    
    func fetchRecordsOf(type: String, completion: @escaping ([CKRecord]?) -> (Void)) {
        let query = CKQuery(recordType: type, predicate: NSPredicate.init(value: true))
        
        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records, error == nil else {
                print("Error when fetch all records")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(records)
            }
        }
    }
    
    func deleteAllRecord(recordType: CKRecord.RecordType, database: CKDatabase, completion: @escaping () -> Void) {
        queryRecord(recordType: recordType, in: database, predicate: NSPredicate(value: true), retrieving: { (record) in
            database.delete(withRecordID: record.recordID, completionHandler: { (recordID, _) in
                guard let recordID = recordID else { return }
                print("record with id: \(recordID)")
                completion()
            })
        }) { (_, _) in
            print("Records deleted")
        }
    }
    
    func updateOrderStatus(order: CKRecord, completion: @escaping (CKRecord?,Error?) -> Void){
        
        self.container.publicCloudDatabase.fetch(withRecordID: order.recordID) { (record, error) in
            
            guard let record = record else {return}
            record["hasFinished"] = 1
            
            if let error = error {
                print(error)
                completion(nil,error)
            }
            
            self.container.publicCloudDatabase.save(record, completionHandler: { (orderUpdated, error) in
                if let error = error {
                    print(error)
                }else{
                    
                    print("pedido atualizado")
                    completion(orderUpdated,nil)
                }
            })
        }
    }
    
    
    
}
