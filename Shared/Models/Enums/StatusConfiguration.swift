//
//  StatusConfiguration.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 26/7/20.
//

import Foundation
import SwiftUI

/// A namespace that englobes all the utilities used by ``StatusView``.
public enum StatusConfiguration {

    /**
    The different ways you can display an status with ``StatusView``.
    As of Starlight v1.0, there are two ways to display mastodon statuses:
        
    - Compact: The status is being displayed from the a list, usually an instance of ``StatusList``,
        so the status should be smaller and more compact, efficiently using space to provide as many
        information we can.
     
     <br>

    - Presented: The status is the main post in a thread, so we can make it bigger, and display more information,
        such as the full date the status was posted, the author's full display name and username, etc.
        Presented statuses are generally bigger because they are the main post, so we need to make it
        easier to distinguish from the other statuses in the thread.

    */
    enum DisplayMode {
        case compact
        case presented
    }

    /*
    How should the status be shown to the user?
    */
    enum Context {
        case none
        case reblog
        case pinned
    }

    public class BindingManager: ObservableObject {

        public enum Page {

            case `default`
            case profile(identifier: String? = nil, account: Account? = nil)
            case thread(identifier: String? = nil, status: Status? = nil)

        }

        @Published public var navLinkActive: Bool = false

        @Published public var currentPage: Page = .default {
            didSet {
                self.navLinkActive.toggle()
            }
        }

    }

}
