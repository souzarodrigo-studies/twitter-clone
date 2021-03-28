//
//  ProfileCollectionViewController.swift
//  twitter
//
//  Created by Rodrigo Santos on 25/03/21.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerIdentifier = "Header"

class ProfileViewController: UICollectionViewController {

    
    // MARK: - States
    
    private var user: User
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Properties
    
    
    
    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Configure UI
        configureUI()
        
        /// Fetch in firebase APIs
        fetchTweets()
        fetchUserStats()
        checkIfUserIsFollowed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Helpers
    private func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier )
        
    }
    
    // MARK: - API

    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { (tweets) in
            self.tweets = tweets
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Selectors
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */



}


extension ProfileViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeaderCollectionReusableView
        header.user = user
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController {
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tweets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCollectionViewCell
    
        // Configure the cell
        cell.tweet = tweets[indexPath.row]
    
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileViewController: ProfileHeaderDelegate {
    func handleEditProfileFollow(_ header: ProfileHeaderCollectionReusableView) {
        
        if user.isCurrentUser {
            print("DEBUG: Show edit profile controller")
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (ref, err) in
                self.user.isFollowed = false
                self.fetchUserStats()
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (ref, err) in
                self.user.isFollowed = true
                self.fetchUserStats()
                self.collectionView.reloadData()
            }
        }
        
    }
    
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
}
