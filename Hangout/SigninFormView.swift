//
//  SigninFormView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI

struct SigninFormView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.title)
                .padding()

            TextField("Full Name", text: $fullName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("New Password", text: $newPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                // Add signup functionality here
                print("Sign Up tapped")
            }) {
                Text("Sign Up")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
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
struct SigninForm_Previews: PreviewProvider {
    static var previews: some View {
        SigninFormView()
    }
}
#endif
#Preview {
    SigninFormView()
}
