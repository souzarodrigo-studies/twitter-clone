//
//  UserService.swift
//  twitter
//
//  Created by Rodrigo Santos on 24/03/21.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    // MARK: - Bussiness Logic
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        
        REFERENCE_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func fetchUser(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REFERENCE_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = AUTH_FIREBASE.currentUser?.uid else { return }
        
        REFERENCE_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (error, reference) in
            REFERENCE_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = AUTH_FIREBASE.currentUser?.uid else { return }
        
        REFERENCE_USER_FOLLOWING.child(currentUid).removeValue { (error, reference) in
            REFERENCE_USER_FOLLOWERS.child(uid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = AUTH_FIREBASE.currentUser?.uid else { return }
        
        REFERENCE_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationsStats) -> Void) {
        REFERENCE_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REFERENCE_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                                
                let stats = UserRelationsStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
}

