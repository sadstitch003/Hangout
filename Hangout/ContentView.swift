//
//  ContentView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @AppStorage("appUsername") var appUsername: String?
    @AppStorage("appName") var appName: String?
    
    var body: some View {
        VStack{
            TabView {
                MapView()
                    .tabItem {
                        Image(systemName: "location.north")
                        Text("Map")
                    }
                    .tag(0)
                
                SplitBillView()
                    .tabItem {
                        Image(systemName: "pencil.and.list.clipboard")
                        Text("Split Bill")
                    }
                    .tag(1)
                
                MessageView()
                    .tabItem {
                        Image(systemName: "message")
                        Text("Message")
                    }
                    .tag(2)
                
                FriendView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Friends")
                    }
                    .tag(3)
            }
            .accentColor(Color(red: 67/255, green: 147/255, blue: 267/255))
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear{
            fetchUserName()
        }
    }
    
    func fetchUserName(){
        if let username = appUsername {
            let db = Firestore.firestore()
            let usersCollection = db.collection("users")
            
            usersCollection.whereField("username", isEqualTo: username).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents, let userDocument = documents.first {
                    if let name = userDocument["name"] as? String {
                        DispatchQueue.main.async {
                            appName = name
                        }
                    }
                }
            }
        } else {
            print("App username is nil.")
        }
    }
}

#Preview {
    ContentView()
}
