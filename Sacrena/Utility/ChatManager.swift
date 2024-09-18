//
//  File.swift
//  Sacrena
//
//  Created by Rahat on 17/09/24.
//

import Foundation
import StreamChat

final class ChatManager {
    
    // Shared instance (Singleton)
    static let shared = ChatManager()
    
    // The Stream Chat client
    private var chatClient: ChatClient!
    private var channelController: EventsController?
    private init(){}
    
    
    func setup(){
        // Initialize the chat client with API key
        
        let client = ChatClient(config: .init(apiKey: .init("8p39wf6jy3w8")))
        self.chatClient = client
        
    }
    
    // Connect a user to the chat service
    func connectUser( completion: @escaping (Error?) -> Void) {
        
        chatClient.connectUser(
            userInfo: .init(id: "mark"),
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFyayJ9.KsmacMghibTEm6QVS4MrpVWqOIJd0peJVP-L6Fmylq8"
        ) { error in
            if let error = error {
                print("Connection failed with: \(error)")
            } else {
                // User successfully connected
                print("User successfully connected")
            }
        }
    }
    func createChannel( completion: @escaping (Error?) -> Void) async {
            
            /// 1: Create a `ChannelId` that represents the channel you want to create.
            let channelId = ChannelId(type: .messaging, id: "alice_bob_chat")

            /// 2: Use the `ChatClient` to create a `Chat` with the `ChannelId`.
            let chat = try! chatClient.makeChat(
                with: channelId,
                extraData: ["info": .string("Friendly Chat Between Alice & Bob")]
            )
        

            /// 3: Call `Chat.get(watch:)` to create the channel.
        ///
        ///
        do {
            try? await chat.get(watch: true)
        } catch (let error) {
            print(error)
        }
        
        }
    func fetchChannels(completion: @escaping (Result<[ChatChannel], Error>) -> Void) {
        let controller = chatClient.channelListController(
            query: .init(
                filter: .and([.equal(.type, to: .messaging), .containMembers(userIds: ["mark1"])]),
                sort: [.init(key: .lastMessageAt, isAscending: false)],
                pageSize: 10
            )
        )
        controller.synchronize { error in
            if let error = error {
                // handle error
                print(error)
            } else {
                // access channels
                let channelsArray = Array(controller.channels)
                            // Pass the channels array to the completion handler
                            completion(.success(channelsArray))
                // load more if needed
                controller.loadNextChannels(limit: 10) { error in
                    // handle error / access channels
                }
            }
        }
    }
    func sendMsg(msg:String){
        /// 1: Create a `ChannelId` that represents the channel you want to send a message to.
        let channelId = ChannelId(type: .messaging, id: "alice_bob_chat")

        /// 2: Use the `ChatClient` to create a `ChatChannelController` with the `ChannelId`.
        let channelController = chatClient.channelController(for: channelId)
        

        /// 3: Call `ChatChannelController.createNewMessage` to create the message.
        channelController.createNewMessage(text: msg,extraData: ["name":"Alice"]) { result in
            switch result {
            case .success(let messageId):
                print(messageId)
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchMessagesFromChannel(completion: @escaping (Result<[ChatMessage], Error>) -> Void) {
        /// 1: Create a `ChannelId` that represents the channel you want to fetch messages from.
        let channelId = ChannelId(type: .messaging, id: "alice_bob_chat")

        /// 2: Use the `ChatClient` to create a `ChatChannelController` with the `ChannelId`.
        let channelController = chatClient.channelController(for: channelId)

        /// 3: Synchronize the channel to fetch the latest messages.
        channelController.synchronize { error in
            if let error = error {
                // Pass the error to the completion handler
                completion(.failure(error))
            } else {
                // Convert LazyCachedMapCollection<ChatMessage> to [ChatMessage]
                let messagesArray = Array(channelController.messages)
                // Pass the fetched messages to the completion handler
                completion(.success(messagesArray.reversed()))
            }
        }
    }
    // Listen for new messages in a channel
        func listenForMessages() {
            let channelId = ChannelId(type: .messaging, id: "alice_bob_chat")
            //var channelController = chatClient.channelController(for: channelId)
            channelController = chatClient.eventsController()
            
            // Set delegate to handle new messages
            channelController?.delegate = self
            
            // Synchronize to start listening for events
//            channelController?.synchronize { error in
//                if let error = error {
//                    print("Error synchronizing channel: \(error.localizedDescription)")
//                } else {
//                    print("Listening for messages in channel: \(channelId)")
//                }
//            }
        }

        
    }

// MARK: - ChatChannelControllerDelegate
extension ChatManager: EventsControllerDelegate {
    
//    // This delegate method is called when messages are updated
//    func channelController(_ channelController: ChatChannelController, didUpdateMessages changes: [ListChange<ChatMessage>]) {
//        NotificationCenter.default.post(name: NSNotification.Name("NewMessageReceived"), object: changes.first)
////        var newMessages: [ChatMessage] = []
////        
////        for change in changes {
////            switch change {
////            case let .insert(message, _):  // Correct tuple pattern for insertion
////                newMessages.append(message)
////                
////            case let .update(message, _):  // Handle updates if needed
////                
////            case let .remove(message, _):  // Handle removals if needed
////                print("Message removed: \(message.text)")
////            case let .move(message, _, _): // Handle moves if needed
////                print("Message moved: \(message.text)")
////            }
////        }
//        
//        // Pass the new messages to the NotificationCenter
//       // if !newMessages.isEmpty {
//        
//        //}
//    }
    func eventsController(_ controller: EventsController, didReceiveEvent event: Event) {
            // Handle any event received
            switch event {
            case let event as MessageNewEvent:
                // handle MessageNewEvent
                NotificationCenter.default.post(name: NSNotification.Name("NewMessageReceived"), object: nil)
            default:
                break
            }
        }
    
}
