//
//  CK_Idea.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import CloudKit
import Combine
import SwiftUI
class CK_Idea: CloudKitProtocol, Identifiable, Equatable {
    
    public var record: CKRecord?
    var id: CKRecord.ID?
    var title: String?
    var descript: String?
    
    public required init(ckRecord: CKRecord) {
    
        self.title = ckRecord["title"]
        self.descript = ckRecord["descript"] 
        self.record = ckRecord
        self.id = ckRecord.recordID
    }
    
    init(title: String, description: String){
        self.title = title
        self.descript = description
    
        if record == nil {
            record = CKRecord(recordType: Self.recordType)
        }
        record?["title"] = title
        record?["descript"] = description
        
        if let record = self.record {
            self.id = record.recordID
        }
        
    }
    
    static func == (lhs: CK_Idea, rhs: CK_Idea) -> Bool {
        return lhs.id == rhs.id
    }

}


