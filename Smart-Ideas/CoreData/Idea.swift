//
//  Idea.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import CoreData

extension Idea {
    static var entityName: String { "Idea" }
    
    convenience init(title: String, description: String, container: NSPersistentContainer = CoreDataManager.persistentContainer) {
        self.init(context: container.viewContext)
        self.title = title
        self.descript = description
        CoreDataManager.saveContext()
    }
    
    static func getAll() -> [CK_Idea] {
        let request: NSFetchRequest<Idea> = Idea.fetchRequest()
        //let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        //request.sortDescriptors = [sort]
    
        let ideas = CoreDataManager.fetch(request)
        
        var ck_ideas: [CK_Idea] = []
        ideas.forEach {
            ck_ideas.append(CK_Idea(title: $0.title ?? "", description: $0.descript ?? ""))
        }
        
        return ck_ideas
        
    }

}
