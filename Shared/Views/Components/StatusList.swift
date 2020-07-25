//
//  StatusList.swift
//  Hyperspace
//
//  Created by Alejandro Modroño Vara on 25/7/20.
//

import SwiftUI

/// Computes Mastodon statuses on demand from an array.
struct StatusList: View {

    var statuses: [Status]

    var divider: Bool
    var action: (Status) -> Void
    var condition: () -> Bool

    var body: some View {
        LazyVStack {
            ForEach(self.statuses, id: \.self.id) { status in

                if condition() {
                    StatusView(status: status)
                        .onAppear {
                            self.action(status)
                        }

                    if divider {
                        Divider()
                            .padding(.leading, 20)
                    }
                }

            }
        }
    }
}

extension StatusList {

    public init(_ statuses: [Status], divider: Bool = false) {
        self.init(statuses, divider: divider, action: {_ in }, condition: {return true})
    }

    public init(_ statuses: [Status], divider: Bool = false, action: @escaping (Status) -> Void) {
        self.init(statuses, divider: divider, action: action, condition: {return true})
    }

    public init(_ statuses: [Status], divider: Bool = false, action: @escaping (Status) -> Void = {_ in}, condition: @escaping () -> Bool) {
        self.statuses = statuses
        self.divider = divider
        self.action = action
        self.condition = condition
    }

}
