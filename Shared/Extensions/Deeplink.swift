//
//  Deeplink.swift
//  Starlight
//
//  Created by Alex Modroño Vara on 30/1/22.
//

import Foundation
import SwiftUI

extension Deeplinker {

    /// Refreshes a deeplink
    func refresh(_ deeplink: inout Deeplink?) {

        //  It is important to reset the deeplink or else if a user opens
        //  the same link twice, it won't work.

        deeplink = nil
    }
}
