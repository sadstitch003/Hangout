//
//  LiveLocationView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

struct FriendView: View {
    @AppStorage("appUsername") var appUsername: String?
    var body: some View {
        if let str = appUsername{
            Text(str)
        }
    }
}

#Preview {
    FriendView()
}
