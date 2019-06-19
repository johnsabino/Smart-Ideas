//
//  IdeasList.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SwiftUI
import CloudKit
import Combine

struct IdeasList : View {
    @State var editPresented: Bool = false
    @State var ckService = CloudKitService.shared
    
    var tab: Int = 0
    var navTitle: String = "Public Ideas"
    
    var ideas : [CK_Idea] {
        switch tab {
        case 0:
            return ckService.ideas
        default:
            return Idea.getAll()
        }
        
    }
    var body: some View {
        NavigationView {
            List(ideas) { idea in
                NavigationButton(destination: DetailIdea(idea: idea)) {
                    IdeasRow(idea: idea)
                }
            }
            .onAppear {
                self.ckService.getAll(entity: CK_Idea.self, recordType: CK_Idea.recordType)
            }
                
            .navigationBarItem(title: Text(navTitle))
            .navigationBarItems(trailing: editIdeaButton)
            .presentation(editPresented ? editModal : nil)
             
        }
    }
    
    var editModal: Modal {
        Modal(EditIdea(isPresented: $editPresented)) {
            print("dismissed")
            self.editPresented = false
        }
    }
    
    
    
    var editIdeaButton: some View {
        //PresentationButton(Text("+").font(.system(size: 40)), destination: EditIdea(isPresented: $editPresented))
        //Temporary, use PresentationButton instead
        Button(action: {
            Idea(title: "Titulo", description: "Descricao")
            //self.editPresented = true
        }) {
            Text("+").font(.system(size: 40))
        }

    }
}

#if DEBUG
struct IdeasList_Previews : PreviewProvider {
    static var previews: some View {
        IdeasList()
    }
}
#endif
