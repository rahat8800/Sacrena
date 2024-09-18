//
//  File.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import UIKit

class IncomingMessageCell: UITableViewCell {

    let profileImageView = UIImageView()
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()

    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        // Setup profileImageView
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "defaultProfile") // Placeholder image
        addSubview(profileImageView)

        // Setup bubble background
        bubbleBackgroundView.backgroundColor = UIColor(white: 0.90, alpha: 1)
        bubbleBackgroundView.layer.cornerRadius = 12
        addSubview(bubbleBackgroundView)

        // Setup message label
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0

        // Disable autoresizing mask
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints for profile image, message label, and bubble background
        let constraints = [
            // Profile image constraints
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            // Message label constraints
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),

            // Bubble background constraints
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]

        NSLayoutConstraint.activate(constraints)

        // Adjust constraints for message label to appear next to the profile image
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)

        leadingConstraint.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

