//
//  ViewController.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import UIKit
import StreamChat

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var channels:[ChatChannel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom cell
        let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        chatTableView.register(nib, forCellReuseIdentifier: "ChatTableViewCell")
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        ChatManager.shared.connectUser(completion: { error in
            if let error = error {
                print("Failed to connect user: \(error.localizedDescription)")
            } else {
                print("joined")
            }
            })
        Task {
            await ChatManager.shared.createChannel(completion: {err in
                print(err ?? nil)
            })
        }
        
        ChatManager.shared.fetchChannels(completion: {result in
            switch result {
                case .success(let channels):
                self.channels = channels
                DispatchQueue.main.async {
                    self.chatTableView.reloadData()
                }
                case .failure(let error):
                    print("Failed to fetch channels: \(error.localizedDescription)")
                }
        })
        
        
        }
    
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        
        let connection = channels?[indexPath.row]
        
                            
        cell.configureCell(name: connection?.name ?? "", statusMessage: connection?.latestMessages.first?.text ?? "", profileImage: nil, isOnline: nil)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatDetailViewController") as? ChatDetailViewController
        vc?.titleTxt = channels?[indexPath.row].extraData["info"]?.stringValue ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
