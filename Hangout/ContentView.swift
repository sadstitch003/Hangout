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
                LiveLocationView()
                    .tabItem {
                        Text("Location")
                    }
                    .tag(0)
                
                SplitBillView()
                    .tabItem {
                        Text("Split Bill")
                    }
                    .tag(1)
                
                FriendView()
                    .tabItem {
                        Text("Friends")
                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        Text("Profile")
                    }
                    .tag(3)
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
}
