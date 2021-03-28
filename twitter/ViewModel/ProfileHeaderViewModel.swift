//
//  ProfileHeaderViewModel.swift
//  twitter
//
//  Created by Rodrigo Santos on 25/03/21.
//

import UIKit

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "Followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "Following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    let usernameString: String
    
    init(user: User) {
        self.user = user
        
        self.usernameString = "@" + user.username
    }
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ",
                                                    attributes: [
                                                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
                                                    ])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                              attributes: [
                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                NSAttributedString.Key.foregroundColor: UIColor.lightGray
                                              ]))
        
        return attributedTitle
    }
}
