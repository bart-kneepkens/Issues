//
//  SearchBar.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 18/03/2021.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    let searchTerm: Binding<String>
    
    func makeUIView(context: Context) -> UISearchBar {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.delegate = context.coordinator
        bar.returnKeyType = .done
        return bar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        let parentView: SearchBar
        
        init(_ parentView: SearchBar) {
            self.parentView = parentView
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parentView.searchTerm.wrappedValue = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchTerm: .constant("query"))
    }
}
