//
//  OptionsTableViewCell.swift
//  Audio Player
//
//  Created by Attabiq Khan on 08/10/2024.
//

import Foundation
import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "Cell"
    private let containerView = View(backgroundColor: .white, cornerRadius: 18)
    private let optionsTitle = Label(text: "A")
    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .black
        return iv
    }()
    var options: Options? {
        didSet {
            self.optionsTitle.text = options?.title
        }
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(optionsTitle)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50.autoSized),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.autoSized),
            
            optionsTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -80.autoSized),
            optionsTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.widthRatio),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18.widthRatio),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18.autoSized),
        ])
    }
}
