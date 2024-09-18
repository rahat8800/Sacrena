//
//  File.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import Foundation
import UIKit

protocol MessageInputViewDelegate: AnyObject {
    func cameraButtonTapped()
    func sendButtonTapped(with message: String)
}


class MessageInputView: UIView {
    weak var delegate: MessageInputViewDelegate? // Add this
    let cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let cameraImage = UIImage(systemName: "camera.fill") // SF Symbol for the camera icon
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Message"
        
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.1) // Light gray background
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.setLeftPaddingPoints(12) // Custom function for padding
        
        // Set placeholder text color
            let placeholderColor = UIColor.white
            textField.attributedPlaceholder = NSAttributedString(
                string: "Message",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let sendImage = UIImage(systemName: "paperplane.fill") // SF Symbol for the send icon
        button.setImage(sendImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
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
        self.backgroundColor = UIColor(hex: "#1C1C1C") // Dark gray background
        
        // Add subviews
        addSubview(cameraButton)
        addSubview(messageTextField)
        addSubview(sendButton)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Camera button constraints
            cameraButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cameraButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 24),
            cameraButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Send button constraints
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 24),
            sendButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Message text field constraints
            messageTextField.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 12),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            messageTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 40) // Adjust height as needed
        ])
    }
    @objc private func sendButtonTapped() {
            // Handle send button tap
        guard let messageText = messageTextField.text, !messageText.isEmpty else {
                    print("Message is empty")
                    return
                }
                
                // Notify the delegate with the message
                delegate?.sendButtonTapped(with: messageText)
                
                // Clear the text field after sending the message
                messageTextField.text = ""
        }
    
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


