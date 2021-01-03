//
//  customStringConvertible.swift
//  Starlight
//
//  Created by Alejandro Modroño Vara on 26/12/20.
//

import Foundation

/// Allows to easily debug methods.
extension CustomStringConvertible {
    public var description: String {
        var description = "========= \((type(of: self))) =========".uppercased()
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\n\(propertyName): \(child.value)"
            }
        }
        description += "\n====== END OF \(type(of: self)) ======".uppercased()
        return description
    }
}
