//
//  HangoutApp.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct HangoutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
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
                LoginFormView()
            }
            else
            {
                ContentView()
            }
        }
    }
}
