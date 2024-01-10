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
import FirebaseFirestore
import CryptoKit

struct SignUpView: View {
    @State var name = ""
    @State var gender = ""
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var isPasswordVisible = false
    @State private var showEmptyFieldsAlert = false
    @State private var selectedDate = Date()
    @State private var firestoreError: Error?
    @AppStorage("needLogin") var needLogin: Bool?
    @AppStorage("appUsername") var appUsername: String?
    
    var body: some View {
        VStack {
            VStack {
                Text("Register").bold()
                    .font(
                        .system(size: 28)
                    )
                    .multilineTextAlignment(.center)
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
                .autocapitalization(.none)
            
            HStack {
                Text("Gender").fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            .padding(.top, 10)
            
            
            Picker("Gender", selection: $gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
            }
            .pickerStyle(SegmentedPickerStyle())
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
                .autocapitalization(.none)
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
                .autocapitalization(.none)
            
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
                                            "username": username
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
                            saveUserDataToFirestore()
                            appUsername = username
                            needLogin = false
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
    }
    
    func saveUserDataToFirestore() {
        guard let hashedPasswordData = password.data(using: .utf8) else {
            print("Error converting password to data")
            return
        }
        
        let hashedPassword = SHA256.hash(data: hashedPasswordData)
        let hashedPasswordString = hashedPassword.compactMap { String(format: "%02x", $0) }.joined()
       
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
                let userData: [String: Any] = [
                    "name": name,
                    "gender": gender,
                    "email": email,
                    "username": username,
                    "password": hashedPasswordString
                ]
                
                db.collection("users").addDocument(data: userData) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                        firestoreError = error
                    } else {
                        print("Document added!")
                    }
                }
                
                let friends: [String: Any] = [
                    "username": username
                ]

                db.collection("friends").addDocument(data: friends) { error in
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
    }

}

struct SignUpFormView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
