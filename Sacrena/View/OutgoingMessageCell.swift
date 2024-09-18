//
//  File.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import Foundation
import UIKit

class OutgoingMessageCell: UITableViewCell {

    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()

    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = UIColor.green.withAlphaComponent(0.7)
        bubbleBackgroundView.layer.cornerRadius = 12
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)

        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white

        // Disable autoresizing mask
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for message label and bubble
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),

            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]

        NSLayoutConstraint.activate(constraints)

        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)

        trailingConstraint.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
