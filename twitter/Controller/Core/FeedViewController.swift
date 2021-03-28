//
//  FeedViewController.swift
//  twitter
//
//  Created by Rodrigo Santos on 23/03/21.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Tweet"

class FeedViewController: UICollectionViewController {
    
    // MARK: - States
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets { (tweets) in
            self.tweets = tweets
        }
    }
    
    // MARK: - Helpers
    private func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        collectionView.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.setDimensions(width: 44, height: 44)
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
        
    }
    
    private func configureLeftBarButton() {
        
        guard let user = user else { return }
        
        /// Profile Image View
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .twitterBlue
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UICollectionViewDelegate / Datasource
extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCollectionViewCell
        
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        let controller = TweetCollectionViewController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tweet = tweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

// MARK: - TweetCellDelegate

extension FeedViewController: TweetCellDelegate {
    
    func handleRetweetTapped(_ cell: TweetCollectionViewCell) {
        print("DEBUG: retweet")
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetViewController(user: tweet.user, config: .reply(tweet))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleProfileImageTapped(_ cell: TweetCollectionViewCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
