//
//  ContentView.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State var ckService = CloudKitService.shared
    @State var isP = true
    var body: some View {
        TabbedView {
            IdeasList(tab: 0, navTitle: "Public Ideas")
                .tabItemLabel(Text("Public Ideas")) // TODO: Bug in Xcode 11 beta doesn't allow for image & text
                .tag(0)
            IdeasList(tab: 1, navTitle: "My Ideas")
                .tabItemLabel(Text("My Ideas")) // TODO: Bug in Xcode 11 beta doesn't allow for image & text
                .tag(1)
            
        }
//        VStack {
//            Button(action: {
//                let idea = CK_Idea(title: "titulo qualquer", description: "descricao qualquer")
//
//                self.ckService.save(idea, result: { (idea) in
//                    print("idea: - \(idea?.title ?? "nil") - saved")
//                }) { (error) in
//                    print("error while saving: \(error.debugDescription)")
//                }
//
//            }) {
//                Text("\(title)")
//            }
//
//            Button(action: {
//                CK_Idea.deleteAll {
//
//                }
//            }) {
//                Text("Delete all")
//            }
//
//            Button(action: {
//                self.isPresented = false
//            }) {
//                Text("Dismiss")
//            }
//
//        }
            
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
#endif
