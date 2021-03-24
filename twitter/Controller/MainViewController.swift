//
//  MainViewController.swift
//  twitter
//
//  Created by Rodrigo Santos on 23/03/21.
//

import UIKit

class MainViewController: UITabBarController {
    
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
        configureUI()
        configureViewControllers()
    }
    
    // MARK: - Selectors
    @objc func handleActionButtonTapped() {
        print(123)
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
        let feed = FeedViewController()
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
