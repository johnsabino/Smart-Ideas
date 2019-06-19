//
//  DetailIdea.swift
//  Smart-Ideas
//
//  Created by João Paulo de Oliveira Sabino on 18/06/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SwiftUI

struct DetailIdea : View {
    var idea: CK_Idea?
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            VStack {
                Text(idea?.title ?? "nil")
                    .font(.largeTitle)
                    .lineLimit(nil)
                    .padding(.top, 20)
                Text(idea?.descript ?? "nil")
                    .font(.system(size: 22))
                    .lineLimit(nil)
                    .padding(.top, 20)
                Spacer()
            }
        }.padding()
        
        
    }

}



#if DEBUG
struct DetailIdea_Previews : PreviewProvider {
    static var previews: some View {
        DetailIdea(idea: nil)
    }
}
#endif
