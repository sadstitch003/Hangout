//
//  LoginFormView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//
//
//  LoginFormView.swift
//  Hangout
//
//  Created by MacBook Pro on 03/12/23.
//
import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase

struct LoginFormView: View {
    @State var username = ""
    @State var password = ""
    @State var isPasswordVisible = false
    @State private var showEmptyFieldsAlert = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Login").bold()
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
                Text("Username or Email").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            
            TextField("", text: $username)
                .underlinetextfield()
                .padding()

            
            HStack {
                Text("Password").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                
            }
            .padding(.leading)
            ZStack(alignment: .trailing) {
                HStack {
                    if isPasswordVisible {
                        TextField("", text: $password)
                            .underlinetextfield()
                            .padding()
                    } else {
                        SecureField("", text: $password)
                            .underlinetextfield()
                            .padding()
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
            VStack{
                Spacer()
                    // Start the sign in flow!
                GoogleSignInButton {
                    guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                    // Create Google Sign In configuration object.
                    let config = GIDConfiguration(clientID: clientID)
                    GIDSignIn.sharedInstance.configuration = config

                    // Start the sign in flow!
                    GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                        guard error == nil else {
                            // Handle the sign-in error...
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
                            // TODO: -MANAGE ERROR
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
                            .frame(width: 208, height: 45)
                            .background(Color(red: 0.26, green: 0.58, blue: 0.97))
                            .cornerRadius(90)
                        
                        Button(action: {
                            if username.isEmpty || password.isEmpty {
                                showEmptyFieldsAlert.toggle()
                            } else {
                                // Handle the login action when all fields are filled
                            }
                        }) {
                            Text("LOG IN")
//                                .font(
//                                    Font.custom("Inter", size: 14)
//                                        .weight(.medium)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 166, height: 42, alignment: .center)
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
            }
            
            .frame(height: 700)
            .navigationBarBackButtonHidden(true)
        }
    }

extension View {
    func underlinetextfield() -> some View {
        self
            .overlay(Rectangle().frame(width: .infinity, height: 2)
            .padding(.top, 30))
            .foregroundColor(Color.black)
            .padding(.horizontal, 10)
    }
}
struct LogInFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView()
    }
}

