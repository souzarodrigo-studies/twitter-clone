//
//  UploadTweetViewController.swift
//  twitter
//
//  Created by Rodrigo Santos on 25/03/21.
//

import UIKit



class UploadTweetViewController: UIViewController {
    
    // MARK: - States
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    // MARK: - Properties
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "replying to @spiderman"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        
        //
        switch config {
        case .tweet:
            print("DEBUG: Config is tweet ")
        case .reply(let tweet):
            print("DEBUG: Replying to \(tweet.caption) ")
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption, type: config ) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error is \(error.localizedDescription)")
                return
            }
            
            switch self.config {
            case .tweet:
                self.dismiss(animated: true, completion: nil)
            default:
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func handleCancel() {
        switch config {
        case .tweet:
            dismiss(animated: true, completion: nil)
        default:
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - API
    
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        
        let ImageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        ImageCaptionStack.axis = .horizontal
        ImageCaptionStack.spacing = 12
        ImageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, ImageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingTop: 16,
                            paddingLeft: 16,
                            paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
        
    }
    
    private func configureUIComponents() {
        
    }
    
    
    private func configureNavigationBar() {
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
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
