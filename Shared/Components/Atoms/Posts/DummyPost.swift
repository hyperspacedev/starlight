//
//  DummyPost.swift
//  Starlight
//
//  Created by Marquis Kurt on 2/10/21.
//

import SwiftUI

struct DummyPost: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 32)
                VStack(alignment: .leading) {
                    Text("Hey")
                        .bold()
                    Text("Hi")
                        .font(.caption)
                }
            }
            Text("This was a triumph. I'm making a note here: huge success. It's hard to overstate my satisfaction.")
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct DummyPost_Previews: PreviewProvider {
    static var previews: some View {
        DummyPost()
    }
}
