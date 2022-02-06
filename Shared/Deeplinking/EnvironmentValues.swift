//
//  EnvironmentValues.swift
//  Starlight
//
//  Created by Alex Modroño Vara on 15/1/22.
//

import Foundation
import SwiftUI

struct DeeplinkKey: EnvironmentKey {
    static var defaultValue: Deeplinker.Deeplink? {
        return nil
    }
}
extension EnvironmentValues {
    var deeplink: Deeplinker.Deeplink? {
        get {
            self[DeeplinkKey]
        }
        set {
            self[DeeplinkKey] = newValue
        }
    }
}
