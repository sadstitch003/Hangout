//
//  ContentView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //BoardingView()
        //Login()
        VStack{
            TabView {
                MapView()
                    .tabItem {
                        Image(systemName: "location.north")
                        Text("Map")
                    }
                    .tag(0)
                    .edgesIgnoringSafeArea(.top)
                
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
                            .padding(.top, 5)
                        Text("Friends")
                    }
                    .tag(3)
            }
            .accentColor(Color(red: 67/255, green: 147/255, blue: 267/255))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
