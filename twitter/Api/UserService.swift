//
//  UserService.swift
//  twitter
//
//  Created by Rodrigo Santos on 24/03/21.
//

import Foundation

struct UserService {
    static let shared = UserService()
    
    // MARK: - Bussiness Logic
    
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = AUTH_FIREBASE.currentUser?.uid else { return }
        
        REFERENCE_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
}

