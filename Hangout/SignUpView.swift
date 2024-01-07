//
//  SignUpFormView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase

struct SignUpView: View {
    @State var name = ""
    @State var gender = ""
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var isPasswordVisible = false
    @State private var showEmptyFieldsAlert = false
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            VStack {
                Text("Register").bold()
                    .font(
                        .system(size: 28)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .frame(width: 120, height: 42, alignment: .center)
            }
            .padding(.bottom, 30)
            
            HStack {
                Text("Name").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            
            TextField("", text: $name)
                .underlinetextfield()
                .padding(.horizontal)
            
            HStack {
                Text("Gender").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            .padding(.top, 10)
            
            TextField("", text: $gender)
                .underlinetextfield()
                .padding(.horizontal)
            HStack {
                Text("Username").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            .padding(.top, 10)
            
            TextField("", text: $username)
                .underlinetextfield()
                .padding(.horizontal)
            HStack {
                Text("Password").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                
            }
            .padding(.leading)
            .padding(.top, 10)
            ZStack(alignment: .trailing) {
                HStack {
                    if isPasswordVisible {
                        TextField("", text: $password)
                            .underlinetextfield()
                            .padding(.horizontal)
                    } else {
                        SecureField("", text: $password)
                            .underlinetextfield()
                            .padding(.horizontal)
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(Color.gray)
                            .padding(.trailing, 25)
                    }
                    .onTapGesture {
                        isPasswordVisible.toggle()
                    }
                }
            }
            HStack {
                Text("Email").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            .padding(.top, 10)
            
            TextField("", text: $email)
                .underlinetextfield()
                .padding(.horizontal)
            HStack {
                Text("Birthday").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            .padding(.top, 10)
            DatePickerTextFields()
                .padding(.horizontal)
            
            
            VStack{
                VStack{
                    Text("By tapping Sign Up & Accept, you acknowledge that you have read the\nPrivacy Policy and agree to the Terms of Service. Hangoutters can\nalways capture or save your messages, such as by taking a\nscreenshot or using a camera.")
                        .font(Font.custom("Inter", size: 10.5))
                      .multilineTextAlignment(.center)
                      .foregroundColor(.black)
                      .frame(width: 414, height: 54, alignment: .center)
                }
                .padding(.top, 40)
                
                Spacer()
                
                GoogleSignInButtons {
                    guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                    let config = GIDConfiguration(clientID: clientID)
                    GIDSignIn.sharedInstance.configuration = config

                    GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                        guard error == nil else {
                            print("Error during sign in: \(error!)")
                            return
                        }

                        guard let user = result?.user,
                              let idToken = user.idToken?.tokenString else {
                            // Handle the missing user or ID token...
                            print("Error: Missing user or ID token")
                            return
                        }

                        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                        accessToken: user.accessToken.tokenString)

                        Auth.auth().signIn(with: credential) {
                        result, error in
                            guard error == nil else {
                                return
                            }
                            print("Sign In")
                            UserDefaults.standard.set(true, forKey: "signIn")
                        }
                    }
                }
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 260, height: 42)
                            .background(Color(red: 0.26, green: 0.58, blue: 0.97))
                            .cornerRadius(90)
                        
                        Button(action: {
                            if username.isEmpty || password.isEmpty {
                                showEmptyFieldsAlert.toggle()
                            } else {
                                // Handle the login action when all fields are filled
                            }
                        }) {
                            Text("SIGN UP")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .bold()
                        }
                        .alert(isPresented: $showEmptyFieldsAlert) {
                            Alert(
                                title: Text("Incomplete Fields"),
                                message: Text("Please fill in all fields."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    
                }
                
                Spacer()
            }
            
            .frame(height: 700)
            .navigationBarBackButtonHidden(true)
        }
    }

struct SignUpFormView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
