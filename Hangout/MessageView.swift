//
//  LiveLocationView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

struct Contact {
    let name: String
    let lastMessage: String
}

struct MessageView: View {
    // Sample contacts data
    let contacts: [Contact] = [
        Contact(name: "John Doe", lastMessage: "Hey, how are you?"),
        Contact(name: "Jane Smith", lastMessage: "See you later!"),
        Contact(name: "Alice Johnson", lastMessage: "What's up?")
    ]
    @State private var searchText = ""

    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText) ||
                contact.lastMessage.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredContacts, id: \.name) { contact in
                NavigationLink(destination: Text("Chat with \(contact.name)")) {
                    Circle()
                        .fill(Color(red: 0.26, green: 0.58, blue: 0.97))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(contact.name.prefix(1)))
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text(contact.name)
                            .font(.headline)
                        Text(contact.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .searchable(text: $searchText)
            .listStyle(GroupedListStyle())
        }
    }
}


#Preview {
    MessageView()
}
