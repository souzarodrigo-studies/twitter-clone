//
//  MainViewController.swift
//  twitter
//
//  Created by Rodrigo Santos on 23/03/21.
//

import UIKit

class MainViewController: UITabBarController {
    
    // MARK: - States
    
    var user: User? {
        didSet {
            guard let navigation = viewControllers?[0] as? UINavigationController else { return }
            guard let feedController = navigation.viewControllers.first as? FeedViewController else { return }
            
            feedController.user = user
        }
    }
    
    
    // MARK: - Properties
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        logUserOut()
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - Publics

    func authenticateUserAndConfigureUI() {
        
        if AUTH_FIREBASE.currentUser == nil {
            DispatchQueue.main.async {
                let navigation = UINavigationController(rootViewController: LoginViewController())
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
        
    }
        
    // MARK: - API
    
    private func fetchUser() {
        
        guard let uid = AUTH_FIREBASE.currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }

    private func logUserOut() {
        do {
            try AUTH_FIREBASE.signOut()
            print("DEBUG: Did log user out ...")
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription) ...")
        }
    }
    
    // MARK: - Selectors
    @objc func handleActionButtonTapped() {
        guard let user = user else { return }
        let navigation = UINavigationController(rootViewController: UploadTweetViewController(user: user, config: .tweet))
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    private func configureViewControllers() {
        
        ///
        /// Configurações para o tab bar
        let feed = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let explore = ExploreViewController()
        let notifications = NotificationsViewController()
        let conversations = ConversationsViewController()
        
        let navigationFeed = templateNavigationController(image: UIImage(named: "home_unselected")!, rootViewController: feed)
        
        let navigationExplore = templateNavigationController(image: UIImage(named: "search_unselected")!, rootViewController: explore)
        
        let navigationNotifications = templateNavigationController(image: UIImage(named: "like_unselected")!, rootViewController: notifications)
        
        let navigationConversations = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1")!, rootViewController: conversations)
   
        
        viewControllers = [navigationFeed, navigationExplore, navigationNotifications, navigationConversations]
        
    }
    
    private func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.barTintColor = .systemBackground
        
        return navigationController
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
