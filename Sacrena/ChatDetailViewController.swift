//
//  ChatDetailViewController.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import UIKit
import StreamChat

class ChatDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,ChatChannelControllerDelegate {
    
    let tableView = UITableView()
    var messages: [ChatMessage]?
    var titleTxt:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupHeaderView()
        setupMessageInputView()
        
        setupTableView()
        
        
        fetchMsgs()
        ChatManager.shared.listenForMessages()
        // Observe new message notifications
            NotificationCenter.default.addObserver(self, selector: #selector(handleNewMessage(_:)), name: NSNotification.Name("NewMessageReceived"), object: nil)
    }
    @objc func handleNewMessage(_ notification: Notification) {
        fetchMsgs()
//        if let message = notification.object as? ChatMessage {
//            print("New message received: \(message.text)")
//            fetchMsgs()
//        }
    }
    func channelController(
            _ channelController: ChatChannelController,
            didReceiveMessage message: ChatMessage
        ) {
            print("New message received: \(message.text)")
            
            // Handle new message logic here, for example, update UI or notify observers
        }
    func fetchMsgs(){
        ChatManager.shared.fetchMessagesFromChannel(completion: {result in
            switch result {
            case .success(let message):
                self.messages = message
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            default:
                break
            }
        })
    }
    private func setupTableView() {
            view.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.delegate = self
            tableView.dataSource = self
            
            
            tableView.register(IncomingMessageCell.self, forCellReuseIdentifier: "IncomingMessageCell")
            tableView.register(OutgoingMessageCell.self, forCellReuseIdentifier: "OutgoingMessageCell")
            
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
        
        tableView.backgroundColor = .clear
            
            // Add constraints for the table view to fit between the header and message input view
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60), // Below header
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60) // Above message input view
            ])
        }
    
    private func setupHeaderView() {
            let headerView = CustomHeaderView()
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.profileImageView.image = UIImage(systemName: "person.crop.circle") // Use your own image
            headerView.tintColor = .white
            headerView.nameLabel.text = titleTxt
            
            // Add the header view
            view.addSubview(headerView)
            
            // Set constraints for the header view
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 60) // Adjust as needed
            ])
            
            // Action for back button
            headerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        @objc func backButtonTapped() {
            self.navigationController?.popViewController(animated: true)
        }
    
    func setupMessageInputView() {
            let messageInputView = MessageInputView()
        messageInputView.delegate = self
            view.addSubview(messageInputView)
            messageInputView.translatesAutoresizingMaskIntoConstraints = false
            
            // Set constraints for the bottom view
            NSLayoutConstraint.activate([
                messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                messageInputView.heightAnchor.constraint(equalToConstant: 60) // Adjust height as necessary
            ])
        }
}

extension ChatDetailViewController:MessageInputViewDelegate {
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections - 1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }

    func cameraButtonTapped() {
        
    }
    
    // 92fc791e-d304-40a8-9e42-97e1696b1d22
    // 24bc4d21-baa8-463c-aa31-b4660fad882d
    
    func sendButtonTapped(with message: String) {
        ChatManager.shared.sendMsg(msg: message)
        fetchMsgs()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let message = messages?[indexPath.row]
            let from = fetchNameFromMessage(message!)
            if from != "Alice" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageCell
                cell.messageLabel.text = message?.text
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageCell
            cell.messageLabel.text = message?.text
                return cell
            }
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    func fetchNameFromMessage(_ message: ChatMessage) -> String? {
        // Extract the "extraData" dictionary from the message
        guard let extraData = message.extraData as? [String: RawJSON] else {
            return nil
        }

        // Get the "name" value from the extraData
        if let nameRawJSON = extraData["name"], case .string(let name) = nameRawJSON {
            return name
        }

        return nil
    }
}
