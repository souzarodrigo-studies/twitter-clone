//
//  TweetService.swift
//  twitter
//
//  Created by Rodrigo Santos on 25/03/21.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    // MARK: - Bussiness Logic
    
    func uploadTweet(_ caption: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = AUTH_FIREBASE.currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String : Any]
        
        REFERENCE_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets(completions: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REFERENCE_TWEETS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            let tweetID = snapshot.key
            let tweet = Tweet(tweetID: tweetID, dictionary: dictionary)
            tweets.append(tweet)
            
            completions(tweets)
        }
    }
}
