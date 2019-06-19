//
//  CloudKitProtocol.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import CloudKit
import SwiftUI

protocol CloudKitProtocol {
    var record: CKRecord? { get set }
    init(ckRecord: CKRecord)
    
}

extension CloudKitProtocol {
    
    static var recordType: String {
        return String(describing: self)
    }
    
    /// Salva um ckrecord na nuvem
    ///
    /// - Parameters:
    ///   - database: a database em que salvar, padrão é a publica do container padrao
    ///   - result: completion de sucesso
    ///   - errorCase: completion de erro
    func save(inDatabase database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase,
              result: @escaping (Self?) -> (),
              errorCase: @escaping (Error?) -> ()) {
        
        guard let record = self.record else {return}
        
        print("title: ", record["title"]!)
        database?.save(record) { (record, error) in
            if let error = error {
                errorCase(error)
                return
            }
            
            if let postRecord = record {
                result(Self(ckRecord: postRecord))
                return
            }
            
            result(nil)
        }
    }
    
    static func queryRecord(inDatabase database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase, predicate: NSPredicate, retrieving: @escaping (CKRecord) -> Void, completion: @escaping (CKQueryOperation.Cursor?, Error?) -> Void) {
        
        let query = CKQuery(recordType: Self.recordType, predicate: predicate)
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
    
    /// Busca todos os objetos de um tipo no banco
    ///
    /// - Parameters:
    ///   - database: a database na qual procurar, padrao é a publica do container padrao
    ///   - result: completion de sucesso
    ///   - errorCase: completion de erro
    static func all(inDatabase database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase,
                    withSortDescriptors sortDescriptors: [NSSortDescriptor] = [],
                    result: @escaping ([CKRecord]?) -> (),
                    errorCase: @escaping (Error) -> ()) {
        let predicate = NSPredicate.init(value: true)
        let query = CKQuery.init(recordType: Self.recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        
        database?.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                errorCase(error)
                return
            }
            
            result(records)
        }
    }
    
    /// Busca todos os objetos de um tipo no banco
    ///
    /// - Parameters:
    ///   - database: a database na qual procurar, padrao é a publica do container padrao
    ///   - result: completion de sucesso
    ///   - errorCase: completion de erro
    
    static func all(inDatabase database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase,
                    withSortDescriptors sortDescriptors: [NSSortDescriptor] = [],
                    result: @escaping ([Self]?) -> (),
                    errorCase: @escaping (Error) -> ()) {
        let predicate = NSPredicate.init(value: true)
        let query = CKQuery.init(recordType: Self.recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        
        database?.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                errorCase(error)
                return
            }
            
            result(
                records?.map({ (record) -> Self in
    
                    return Self(ckRecord: record)
                })
            )
        }
    }
    
    static func deleteAll(inDatabase database: CKDatabase? = CloudKitService.shared.container.publicCloudDatabase, completion: @escaping () -> Void) {
        Self.queryRecord(predicate: NSPredicate(value: true), retrieving: { (record) in
            database?.delete(withRecordID: record.recordID, completionHandler: { (recordID, error) in
                guard let recordID = recordID else { return }
                print("record with id: \(recordID)")
                
                completion()
            })
        }) { (_, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Records deleted")
            }
            
        }
    }
    
    
}
