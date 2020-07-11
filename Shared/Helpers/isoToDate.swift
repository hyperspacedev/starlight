//
//  isoToDate.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 11/07/2020.
//

import Foundation

extension String {

    func getDate() -> Date {

        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: self)!

        return date

    }

}
