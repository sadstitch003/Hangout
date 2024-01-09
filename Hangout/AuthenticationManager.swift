//
//  AuthenticationManager.swift
//  Hangout
//
//  Created by MacBook Pro on 09/01/24.
//


import FirebaseFirestore
import FirebaseAuth
import CommonCrypto


class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()

    private init() {}
    
    @Published var authenticated = false

    func authenticateUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let usersCollection = Firestore.firestore().collection("users")

            // Hash the password before querying (use a secure hashing algorithm)
            let hashedPassword = hashPassword(password)

            // Query for the user with the given username and hashed password
            usersCollection
                .whereField("username", isEqualTo: username)
                .whereField("password", isEqualTo: hashedPassword)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                        completion(false)
                        return
                    }

                    if let document = querySnapshot?.documents.first {
                        // Authentication successful
                        print("User found: \(document.documentID)")
                        completion(true)
                    } else {
                        // Authentication failed
                        print("User not found or password incorrect")
                        completion(false)
                    }
                }
        authenticated = true
    }
    
    func hashPassword(_ password: String) -> String {
            if let data = password.data(using: .utf8) {
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                _ = data.withUnsafeBytes {
                    CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
                }
                return Data(digest).map { String(format: "%02hhx", $0) }.joined()
            }
            return ""
        }

    // Other authentication-related functions
}
