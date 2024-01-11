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
import FirebaseFirestore
import CryptoKit


struct LoginFormView: View {
    @State var username = ""
    @State var password = ""
    @State var isPasswordVisible = false
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var showEmptyFieldsAlert = false
    @State private var showInvalidCredentialsAlert = false
    @AppStorage("needLogin") var needLogin: Bool?
    @AppStorage("appUsername") var appUsername: String?
    
    var body: some View {
        VStack {
            VStack {
                Text("Login").bold()
                    .font(
                        .system(size: 28)
                    )
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .frame(width: 120, height: 42, alignment: .center)
            }
            .padding(.bottom, 30)
            
            VStack{
                HStack {
                    Text("Username")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        
                }
                .padding(.leading)
                
                TextField("", text: $username)
                    .underlinetextfield()
                    .padding(.horizontal)
                    .autocapitalization(.none)
            }
            .padding(.bottom)
            
            VStack{
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
                                .padding(.horizontal)
                                .autocapitalization(.none)
                        } else {
                            SecureField("", text: $password)
                                .underlinetextfield()
                                .padding(.horizontal)
                                .autocapitalization(.none)
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
            }
            
            VStack{
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
                            print("Error: Missing user or ID token")
                            return
                        }

                        let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)

                        Auth.auth().signIn(with: credential) { authResult, error in
                            guard error == nil else {
                                print("Error during Firebase sign in: \(error!)")
                                return
                            }

                            if let currentUser = Auth.auth().currentUser {
                                let name = currentUser.displayName ?? ""
                                let email = currentUser.email ?? ""
                                let username = email.components(separatedBy: "@").first ?? ""

                                let db = Firestore.firestore()
                                let userRef = db.collection("users").whereField("username", isEqualTo: username)

                                userRef.getDocuments { snapshot, error in
                                    if let error = error {
                                        print("Error fetching documents: \(error)")
                                        return
                                    }

                                    guard let snapshot = snapshot else {
                                        print("No documents found")
                                        return
                                    }

                                    if snapshot.documents.isEmpty {
                                        let nameComponents = name.components(separatedBy: " ")
                                        let firstName = nameComponents.first ?? ""

                                        let userData: [String: Any] = [
                                            "name": firstName,
                                            "email": email,
                                            "username": username,
                                        ]

                                        db.collection("users").document(currentUser.uid).setData(userData) { error in
                                            if let error = error {
                                                print("Error adding document: \(error)")
                                            } else {
                                                print("Document added!")
                                            }
                                        }
                                        
                                        let friends: [String: Any] = [
                                            "username": username,
                                            "hangout": "Hangout"
                                        ]

                                        db.collection("friends").document(currentUser.uid).setData(friends) { error in
                                            if let error = error {
                                                print("Error adding document: \(error)")
                                            } else {
                                                print("Document added!")
                                            }
                                        }
                                    } else {
                                        print("Username already exists in Firestore")
                                    }
                                }
                                appUsername = username
                                needLogin = false
                            }
                        }
                    }
                }
  

                
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 260, height: 42)
                        .background(Color(red: 0.26, green: 0.58, blue: 0.97))
                        .cornerRadius(90)

                    Button(action: {
                        if username.isEmpty || password.isEmpty {
                            // Show an alert if username or password is empty
                            showEmptyFieldsAlert.toggle()
                        } else {
                            // Check for valid credentials
                            isValidCredentials(username: username, password: password) { isValid in
                                if isValid {
                                    // Authentication successful
                                    // You can handle the success case here
                                    print("Firebase sign in successful")
                                    needLogin = false
                                } else {
                                    // Show an alert if authentication fails
                                    showInvalidCredentialsAlert.toggle()
                                }
                            }
                        }
                    }) {
                        Text("LOG IN")
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
                    .alert(isPresented: $showInvalidCredentialsAlert) {
                        Alert(
                            title: Text("Invalid Credentials"),
                            message: Text("Username or password is incorrect."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                    
                }
            }
            
            .frame(height: 700)
        }
    
    private func isValidCredentials(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Check if username and password are not empty
        guard !username.isEmpty && !password.isEmpty else {
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").whereField("username", isEqualTo: username)

        userRef.getDocuments { snapshot, error in
            if let error = error {
                // Error fetching documents
                print("Error fetching documents: \(error)")
                completion(false)
            } else {
                // Check if documents are found
                guard let snapshot = snapshot, let userDocument = snapshot.documents.first else {
                    completion(false)
                    return
                }

                // Retrieve the hashed password from Firestore
                if let storedHashedPassword = userDocument["password"] as? String {
                    // Hash the provided password
                    let hashedPasswordData = SHA256.hash(data: Data(password.utf8))
                    let hashedPassword = hashedPasswordData.compactMap { String(format: "%02x", $0) }.joined()

                    // Compare the hashed passwords
                    if storedHashedPassword == hashedPassword {
                        // Authentication successful
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    }

extension View {
    func underlinetextfield() -> some View {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return self
                .overlay(
                    Rectangle()
                        .frame(width: .infinity, height: 2)
                        .padding(.top, 30)
                )
                .padding(.horizontal, 10)
                .foregroundColor(Color.white)
        } else {
            return self
                .overlay(
                    Rectangle()
                        .frame(width: .infinity, height: 2)
                        .padding(.top, 30)
                )
                .padding(.horizontal, 10)
                .foregroundColor(Color.black)
        }
    }
}

struct LogInFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView()
    }
}
