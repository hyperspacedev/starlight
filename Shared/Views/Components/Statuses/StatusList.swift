//
//  StatusList.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 25/7/20.
//

import SwiftUI

/// A structure that computes statuses on demand from an underlying collection of
/// of ``Status`` view models.
struct StatusList: View {

    /// The collection of underlying ``Status`` view models used to create
    /// ``StatusView``s dynamically.
    var statuses: [Status]

//    @Binding var selection: Set<SelectionValue>

    /// ``StatusList`` renders statuses in a manner appropriate for the context.
    /// If `context` equals to ``StatusListContext.list``, statuses will be
    /// displayed inside a SwiftUI ``List``. In the other hand, if context is none
    /// (equals to ``StatusListContext.none``), statuses will be displayed
    /// inside a SwiftUI ``ForEach``.
    ///
    /// This is mostly used when you have a parent ``ScrollView`` and don't want
    /// your List to scroll as a different component.
    ///
    /// The way context works may differ in a manner appropriate for the platform.
    /// For example, on iOS, if context equals to ``StatusListContext.list``,
    /// a new closure will be provided, that will be useful for providing custom swipe actions.
    ///
    /// It is important to take in mind that context **won't** affect the ``StatusView`` style,
    /// that's up to ``StatusView.displayMode``.
    var context: StatusListContext

    /// An escaping closure ran everytime a status is loaded.
    ///
    /// - Returns: The status that is currently being displayed.
    ///
    /// This is useful for infinite scrolling, where you need to check each status' id.
    ///
    /// ```
    /// StatusList(statusesArray, action: { currentStatus in
    ///     print(currentStatus.id)
    /// })
    /// ```
    var action: (Status) -> Void

    /// There might be some moments where you might only want to display an status
    /// if a specific condition is met. You can use this escaping closure to do that.
    ///
    /// Let's say you only want to display statuses posted by a specific account.
    /// You could check the status' author account id, so that only when it is equal
    /// to a hardcoded id, you display them. This can be easily done as follows:
    ///
    /// ```
    /// StatusList(statusesArray, condition: { currentStatus in
    ///     if currentStatus.account.id == "329742" { // amodrono@mastodon.technology
    ///         return true
    ///     }
    ///
    ///     return false
    /// })
    /// ```
    var condition: (Status) -> Bool

    /// The amount of placeholder statuses to display until the data is resolved.
    var placeholderCount: Int

    // MARK: VIEWS

    var body: some View {
        if self.statuses.isEmpty {

            if self.context == .list {

                List(0 ..< placeholderCount) { _ in
                    self.placeholder
                }
                    .animation(.spring())

            } else {

                ForEach(0 ..< placeholderCount) { _ in

                    self.placeholder

                }
                    .animation(.spring())

            }

        } else {

            if self.context == .list {

                List(self.statuses, id: \.self.id) { status in
                    if condition(status) {
                        StatusView(status: status)
                            .onAppear {
                                self.action(status)
                            }
                    }
                }
                    .animation(.spring())

            } else {

                ForEach(self.statuses, id: \.self.id) { status in

                    if condition(status) {
                        StatusView(status: status)
                            .onAppear {
                                self.action(status)
                            }

                        if self.context == .noneWithSeparator {
                            Divider()
                                .padding(.trailing, -20)
                        }
                    }

                }
                    .animation(.spring())

            }

        }

    }

    var placeholder: some View {
        VStack {
            StatusView() // if we don't pass a status data model, StatusView will show PlaceholderStatusView()

            if self.context == .noneWithSeparator {
                Divider()
                    .padding(.trailing, -20)
            }
        }
    }

}

extension StatusList {

    /// Creates an instance that uniquely identifies and creates ``StatusView``s
    /// across updates based on the provided key path to the underlying data
    /// models.
    ///
    /// - Parameters:
    ///   - data: The data that the ``StatusList`` instance uses to create the ``StatusView``s.
    ///     dynamically.
    ///   - selection: A binding to a selected row.
    ///   - context: The list context.
    ///   - action: The function to run each time a new status is loaded.
    ///   - content: The view builder that creates views dynamically.
    public init(_ data: [Status],
//                selection: Binding<Set<SelectionValue>>?,
                context: StatusListContext = .none,
                action: @escaping (Status) -> Void = {_ in},
                condition: @escaping (Status) -> Bool = {_ in return true}, placeholderCount: Int = 20) {
        self.statuses = data
        self.context = context
        self.action = action
        self.condition = condition

        //  Why default it to 20, you may ask. Well, it's because when you fetch
        //  Mastodon statuses, the default amount of statuses retrieved is 20.
        self.placeholderCount = placeholderCount

    }

}

struct StatusList_Previews: PreviewProvider {

    @ObservedObject static var timeline = TimelineViewModel()

    static var previews: some View {
        StatusList(
            self.timeline.statuses,
            action: { currentStatus in
                self.timeline.updateTimeline(from: currentStatus.id)
            }
        )
    }
}
