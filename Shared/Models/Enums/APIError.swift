//
//  APIError.swift
//  Starlight
//
//  Created by Alejandro Modroño Vara on 26/12/20.
//

import Foundation

/// All the possible errors we can get from a URLSession.
enum APIError: Error, CustomStringConvertible {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure

    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }

}
