//
//  TweetViewModel.swift
//  twitter
//
//  Created by Rodrigo Santos on 25/03/21.
//

import UIKit

struct TweetViewModel {
    
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var retweetAttributeString: NSAttributedString? {
        return attributeedText(withValue: tweet.retweetCount, text: " Retweets")
    }
    
    var likesAttributeString: NSAttributedString? {
        return attributeedText(withValue: tweet.likes, text: " Likes")
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var userInfoText: NSAttributedString {
        
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " ∙ \(timestamp)",
                                    attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                 .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributeedText(withValue value: Int, text: String) -> NSAttributedString {
        let attribute = NSMutableAttributedString(string: "\(value)",
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        
        attribute.append(NSAttributedString(string: " \(text)",
                                    attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                 .foregroundColor: UIColor.lightGray]))
        
        return attribute
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
