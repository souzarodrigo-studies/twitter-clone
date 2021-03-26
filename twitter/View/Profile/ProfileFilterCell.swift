//
//  ProfileFilterCell.swift
//  twitter
//
//  Created by Rodrigo Santos on 25/03/21.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    // MARK: - States
    
    var option: ProfileFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test filter"
        return label
    }()
    
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    
}
