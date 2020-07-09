//
//  TimelineView.swift
//  iOS
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import SwiftUI

struct TimelineView: View {
    var body: some View {
        List(0 ..< 5) { _ in
            StatusView()
                .padding(.vertical)
                .buttonStyle(PlainButtonStyle())
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
