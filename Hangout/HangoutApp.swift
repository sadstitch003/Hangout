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
struct SignInUsingGoogleApp: App{
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
            } else {
                SigninFormView()
            }
        }
    }
}
