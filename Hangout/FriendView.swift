//
//  LiveLocationView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

struct FriendView: View {
    @AppStorage("appName") var appName: String?
    
    var body: some View {
        Text("Friends")
    }
}

#Preview {
    FriendView()
}
