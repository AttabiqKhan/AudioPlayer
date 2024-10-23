//
//  CollectionViewCell.swift
//  Audio Player
//
//  Created by Attabiq Khan on 17/10/2024.
//

import Foundation
import UIKit

class OptionsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let collectionViewIdentifier = "Cell"
    private let containerView = View(backgroundColor: .dimWhite, cornerRadius: 20)
    private let optionsTitle = Label(text: "A")
    var options: Options? {
        didSet {
            self.optionsTitle.text = options?.title
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(optionsTitle)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.autoSized),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.autoSized),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.autoSized),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.autoSized),
            
            optionsTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            optionsTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
