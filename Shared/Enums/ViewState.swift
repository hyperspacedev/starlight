//
//  ViewState.swift
//  ViewState
//
//  Created by Marquis Kurt on 5/8/21.
//

import Foundation

/// An enumeration that represents the current state of a view.
enum ViewState {
    /// The view has been initialized, but not loaded.
    case initial
    
    /// The view is loading data by a publisher or network request.
    case loading
    
    /// The data has been loaded.
    case loaded
    
    /// The data has been updated after being loaded.
    case updated
    
    /// The view failed to load data for a given reason.
    case errored(reason: String)
}
