//
//  LoginViewModel.swift
//  Starlight (iOS)
//
//  Created by Alex Modroño Vara on 16/5/22.
//

import Foundation

extension LoginView {
    public class ViewModel: ObservableObject {

        @Published var keyboardVisible: Bool = false
        @Published var instanceDomain: String = ""

        @Published var toggleSafari: Bool = false
        @Published var url: URL? = nil {
            didSet {
                self.toggleSafari.toggle()
            }
        }
    }
}
