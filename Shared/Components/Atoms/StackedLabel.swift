//
//  StackedLabel.swift
//  StackedLabel
//
//  Created by Marquis Kurt on 5/8/21.
//

import SwiftUI

struct StackedLabel<Content: View>: View {
    
    var image: Image
    var title: LocalizedStringKey
    var callToAction: () -> Content
    
    init(image: Image, title: LocalizedStringKey, callToAction: @escaping () -> Content) {
        self.image = image
        self.title = title
        self.callToAction = callToAction
    }
    
    init(systemName: String, title: LocalizedStringKey, callToAction: @escaping () -> Content) {
        self.image = Image(systemName: systemName)
        self.title = title
        self.callToAction = callToAction
    }
    
    var body: some View {
        VStack(spacing: 8) {
            image
                .font(.largeTitle)
            Text(title)
                .font(.largeTitle)
            callToAction()
        }
        .foregroundColor(.secondary)
        .padding()
    }
}

struct StackedLabel_Previews: PreviewProvider {
    static var previews: some View {
        StackedLabel(image: Image(systemName: "star"), title: "Hello") {
            Text("Hello, world")
        }
    }
}
