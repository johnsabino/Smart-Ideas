//
//  IdeasRow.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 17/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SwiftUI

struct IdeasRow : View {
    var idea: CK_Idea
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            Text(idea.title ?? "nil")
                .font(.title)
                .padding(.vertical, 50)
        }
        
    }
}

#if DEBUG
struct IdeasRow_Previews : PreviewProvider {
    static var previews: some View {
            IdeasRow(idea: CK_Idea(title: "titulo", description: "descricao"))
            .previewLayout(.fixed(width: 400, height: 300))
        
    }
}
#endif

struct BackgroundRect : View {
    var title: String
    var body: some View {
        
        Text(title)
            .font(.title)
            .padding(.vertical, 50)
            .padding(.horizontal, 150)
            .background(Color(red: 255/255, green: 230/255, blue: 0))

        
        
    }
}
