//
//  ChatTableViewCell.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusMessageLabel: UILabel!
    @IBOutlet weak var onlineStatusView: UIView!

    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Customize the appearance of the views
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.clipsToBounds = true
            
            // Making the online status indicator a circle
           // onlineStatusView.layer.cornerRadius = onlineStatusView.frame.size.width / 2
           // onlineStatusView.backgroundColor = .green // Online status indicator (green)
        }

        func configureCell(name: String, statusMessage: String?, profileImage: UIImage?, isOnline: Bool?) {
            nameLabel.text = name
            statusMessageLabel.text = statusMessage
           // profileImageView.image = profileImage
            
            // Show or hide the online status based on the isOnline parameter
         //   onlineStatusView.isHidden = !isOnline
        }
    
}
