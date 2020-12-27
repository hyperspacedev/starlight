//
//  StateRepresentable.swift
//  Hyperspace
//
//  Created by Marquis Kurt on 10/4/20.
//

import Foundation

/// A class that represents a data structure with a state.
///
/// This class is used to provide a state to any other class that subclasses from this one. The state property
/// can be used to handle state management during network operations.
public class StateRepresentable: ObservableObject, CustomStringConvertible {

    /// The current state of the class. Defaults to ready to load (.willLoad).
    @Published var state: State = .willLoad

    /// An enumeration that represents the different states this class can be in.
    public enum State {

        /// The class is ready to load data.
        case willLoad

        /// The class is loading data.
        case loading(message: String)

        /// The class has failed in loading data.
        case error(message: String, icon: String)

        /// The class has successfully loaded data.
        case success(icon: String)

    }

}

extension StateRepresentable.State: Hashable, Equatable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }

}
