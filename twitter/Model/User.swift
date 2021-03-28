//
//  User.swift
//  twitter
//
//  Created by Rodrigo Santos on 24/03/21.
//

import Foundation

struct User {
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    var stats: UserRelationsStats?
    
    var isCurrentUser: Bool {
        return AUTH_FIREBASE.currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let profileImageString = dictionary["profileImageURL"] as? String {
            guard let url = URL(string: profileImageString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationsStats {
    var followers: Int
    var following: Int
}
