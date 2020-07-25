//
//  SearchTextField.swift
//  iOS
//
//  Created by Alejandro Modroño Vara on 21/07/2020.
//

import Foundation
import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    var body: some View {
        SearchBarTextField(text: $text)
    }
}

struct SearchBarTextField: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> SearchBarTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBarTextField>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = false
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBarTextField>) {
        uiView.text = text
        uiView.placeholder = "Search"
    }
}
