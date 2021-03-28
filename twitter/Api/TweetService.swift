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
    
    func uploadTweet(_ caption: String, type: UploadTweetConfiguration, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = AUTH_FIREBASE.currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String : Any]
        
        
        switch type {
        case .tweet:
            
            REFERENCE_TWEETS.childByAutoId().updateChildValues(values) { (err, ref) in
                
                guard let tweetID = ref.key else { return }
                REFERENCE_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REFERENCE_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completions: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REFERENCE_TWEETS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            let tweetID = snapshot.key
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                
                completions(tweets)
            }
            
        }
    }
    
    func fetchTweets(forUser user: User, completions: @escaping ([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        REFERENCE_USER_TWEETS.child(user.uid).observe(.childAdded) { (snapshot) in
            let tweetID = snapshot.key
            
            REFERENCE_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    
                    completions(tweets)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REFERENCE_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
}
