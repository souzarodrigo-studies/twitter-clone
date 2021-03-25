//
//  AuthService.swift
//  twitter
//
//  Created by Rodrigo Santos on 24/03/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?)  {
        AUTH_FIREBASE.signIn(withEmail: email, password: password, completion: completion) 
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                AUTH_FIREBASE.createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    let values = [
                        "email": credentials.email,
                        "username": credentials.username,
                        "fullname": credentials.fullname,
                        "profileImageURL": profileImageURL
                    ]
                    guard let uuid = result?.user.uid else { return }
                    
                    REFERENCE_USERS.child(uuid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
    
}
