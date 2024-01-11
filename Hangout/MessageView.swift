//
//  LiveLocationView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI
import FirebaseFirestore

struct Contact {
    let username: String
    let name: String
    let status: String
}

struct MessageView: View {
    @AppStorage("appUsername") var appUsername: String?

    @State private var searchText = ""
    @State private var contacts: [Contact] = []

    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredContacts, id: \.username) { contact in
                NavigationLink(destination: ChatView(contactName: contact.name,contactUsername: contact.username)) {
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
                        Text(contact.status) // Use 'status' instead of 'lastMessage'
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .searchable(text: $searchText)
            .listStyle(GroupedListStyle())
            .onAppear {
                fetchContactsFromFirestore()
            }
        }
    }

    func fetchContactsFromFirestore() {
        guard let appUsername = appUsername else {
            return
        }

        // Clear existing contacts
        contacts = []

        let db = Firestore.firestore()

        db.collection("friends")
            .whereField("username", isEqualTo: appUsername)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        for field in document.data() {
                            if(field.key != "username"){
                                if let fieldValue = field.value as? String, field.key != "username" {
                                    let friend = Contact(username: field.key, name: fieldValue, status: "Hey, I'm using Hangout.")
                                    contacts.append(friend)
                                }
                            }
                        }
                        
                        contacts.sort { $0.name < $1.name }
                    }
                }
            }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
