//
//  HangoutApp.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

@main
struct HangoutApp: App {
    @AppStorage("isOnBoarding") var isOnBoarding: Bool = true
    @AppStorage("needLogin") var needLogin: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnBoarding
            {
                BoardingView()
            }
            else if needLogin
            {
                LoginView()
            }
            else
            {
                ContentView()
            }
        }
    }
}
