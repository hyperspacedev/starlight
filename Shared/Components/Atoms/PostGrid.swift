//
//  PostGrid.swift
//  PostGrid
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI
import Chica

struct PostGrid: View {
    
    @State var statuses: [Status]
    private let gridLayout: [GridItem] = [.init(.adaptive(minimum: 300, maximum: .infinity), spacing: 4, alignment: .top)]
    
    var body: some View {
        LazyVGrid(columns: gridLayout) {
            ForEach(statuses, id: \.self) { status in
                PostView(post: status)
            }
        }
    }
}

struct PostGrid_Previews: PreviewProvider {
    static var previews: some View {
        PostGrid(statuses: [])
    }
}
