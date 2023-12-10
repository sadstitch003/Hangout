//
//  LoginFormView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

struct LoginFormView: View {
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Text("Login Form")
                .font(.title)
                .padding()

            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                // Add login functionality here
                print("Login tapped")
            }) {
                Text("Login")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView()
    }
}
#endif

#Preview {
    LoginFormView()
}
