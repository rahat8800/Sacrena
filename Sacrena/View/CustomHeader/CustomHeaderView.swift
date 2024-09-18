//
//  CustomHeader.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import UIKit

class CustomHeaderView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20 // Adjust based on the size
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "chevron.left") // SF Symbol for back arrow
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "ellipsis") // SF Symbol for three dots
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let bottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .white // White separator line
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear// Dark gray background
        
        // Add subviews
        addSubview(backButton)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(menuButton)
        addSubview(bottomLine) // Add the bottom line view
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Back button constraints
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Profile ImageView constraints
            profileImageView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Name Label constraints
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // Menu button constraints
            menuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            menuButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 24),
            menuButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Bottom line constraints with 20-point margin
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.3) // Thin line (1px)
        ])
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
