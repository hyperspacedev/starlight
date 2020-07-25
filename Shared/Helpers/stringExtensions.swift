//
//  stringExtensions.swift
//  Hyperspace
//
//  Created by Alejandro Modroño Vara on 22/07/2020.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
