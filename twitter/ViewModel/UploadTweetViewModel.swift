//
//  UploadTweetViewModel.swift
//  twitter
//
//  Created by Rodrigo Santos on 27/03/21.
//

import Foundation

struct UploadTweetViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happing"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Tweet"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.fullname)"
        }
    }
}

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

