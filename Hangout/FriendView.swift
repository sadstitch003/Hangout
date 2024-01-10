//
//  LiveLocationView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI
import FirebaseFirestore

struct Friend: Decodable, Identifiable{
    var id = UUID()
    var name: String
    var username: String
}

struct FriendView: View {
    @AppStorage("appName") var appName: String?
    @AppStorage("appUsername") var appUsername: String?
    @State var friends: [Friend] = []
    @State var db = Firestore.firestore()
    @State var newFriendID: String = ""
    @State var newFriendName: String = ""
    
    var body: some View {
        VStack{
            
            Text("Friends")
                .font(.title)
                .bold()
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            
            List(friends) { friend in
                HStack {
                    Circle()
                        .fill(Color(red: 0.26, green: 0.58, blue: 0.97))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(friend.name.prefix(1)))
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text(friend.name)
                            .font(.headline)
                        Text(friend.username)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(GroupedListStyle())
            
            Spacer()
            
            Text("Add Friend")
            TextField("Enter friend's ID", text: $newFriendID)
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 260, height: 42)
                    .background(Color(red: 0.26, green: 0.58, blue: 0.97))
                    .cornerRadius(90)
                
                Button(action: {
                    addFriend()
                }) {
                    Text("Add Friend")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .onAppear{
            if friends.isEmpty {
                fetchFriendDetails()
            }
        }
    }

    func fetchFriendDetails() {
        guard let username = appUsername else {
            return
        }
        
        friends = []
        
        db.collection("friends")
            .whereField("username", isEqualTo: username)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        for field in document.data() {
                            if(field.key != "username"){
                                if let fieldValue = field.value as? String, field.key != "username" {
                                    let friend = Friend(name: fieldValue, username: field.key)
                                    friends.append(friend)
                                }
                            }
                        }
                        
                        friends.sort { $0.name < $1.name }
                    }
                }
            }
    }
    
    func addFriend() {
        guard let username = appUsername else {
            return
        }
        
        db.collection("users")
            .whereField("username", isEqualTo: newFriendID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting user document: \(error)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        if let name = document.data()["name"] as? String {
                            db.collection("friends")
                                .whereField("username", isEqualTo: username)
                                .getDocuments { (querySnapshot, error) in
                                    if let error = error {
                                        print("Error getting friends document: \(error)")
                                    } else if let documents = querySnapshot?.documents {
                                        if let friendDocument = documents.first {
                                            let documentID = friendDocument.documentID
                                            
                                            db.collection("friends")
                                                .document(documentID)
                                                .setData([
                                                    newFriendID: name
                                                ], merge: true) { error in
                                                    if let error = error {
                                                        print("Error adding friend: \(error)")
                                                    } else {
                                                        fetchFriendDetails()
                                                    }
                                                }
                                        }
                                    }
                                }
                        }
                    } else {
                        print("User document not found")
                    }
                }
            }
    }

}

#Preview {
    FriendView()
}
