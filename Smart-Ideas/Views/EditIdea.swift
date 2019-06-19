//
//  EditIdea.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SwiftUI

struct EditIdea : View {
    @Binding var isPresented: Bool
    @State var titleField: String = ""
    @State var descriptField: String = ""
    
    @State var ckService = CloudKitService.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
            TextField($titleField)
                .textFieldStyle(.roundedBorder)
            Text("Description")
            TextField($descriptField)
                .textFieldStyle(.roundedBorder)
                .lineLimit(nil)
            Button(action: {
                DispatchQueue.main.async {
                    let idea = CK_Idea(title: self.titleField, description: self.descriptField)
                    
                    self.ckService.save(idea, result: { (idea) in
                        guard let idea = idea else {return}
                        DispatchQueue.main.async {
                            self.ckService.ideas.insert(idea, at: 0)
                            self.isPresented = false
                            self.titleField = ""
                            self.descriptField = ""
                        }
                    }) { (error) in
                        print("error while saving: \(error.debugDescription)")
                    }
                    
                    
                }
            }) {
                Text("Done")
            }
            Spacer()
        }.padding(20)
        
    }
}

//struct MultilineTextView: UIViewRepresentable {
//    @Binding var text: String
//
//    func makeUIView(context: Context) -> UITextView {
//        let view = UITextView()
//        view.isScrollEnabled = true
//        view.isEditable = true
//        view.isUserInteractionEnabled = true
//        view.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
//        view.layer.borderWidth = 0.5
//        view.layer.cornerRadius = 5
//        return view
//    }
//
//    func updateUIView(_ uiView: UITextView, context: Context) {
//        uiView.text = text
//    }
//}

#if DEBUG
struct EditIdea_Previews : PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        EditIdea(isPresented: $isPresented)
        
    }
}
#endif
