//
//  MessageInstance.swift
//  MiBook
//
//  Created by Le Dung on 3/13/18.
//  Copyright © 2018 Ledung. All rights reserved.
//

import UIKit

import SocketIO



enum ConferenceNotify : String
{
    case userLoginSuccess       = "UserLoginSuccess"
    case messageSend            = "MessageSend"
    case messageSendSuccess     = "MessageSendSuccess"
    case messageReceive         = "MessageReceive"
    case messageRead            = "MessageRead"
    case messageDelivery        = "MessageDelivery"
    case messageHistory         = "MessageHistory"
    case messageLatest          = "MessageLatest"
    case messageAfter           = "MessageAfter"
    case contactReceive         = "ContactReceive"
    case contactReceiveRequest  = "ContactReceiveRequest"
    case contactList                = "ContactList"
    case contactAdd                 = "ContactAdd"
    case contactDeny                = "ContactDeny"
    case contactCancel              = "ContactCancel"
    case contactAccept              = "ContactAccept"
    case contactOnline              = "ContactOnline"
    case contactOffline             = "ContactOffline"
    case contactInfo                = "ContactInfo"
    case developerRequest           = "DeveloperRequest"
    case conversationReceive        = "ConversationReceive"
    case conversationLastMessage    = "ConversationLastMessage"
    case conversationUpdateItem     = "ConversationUpdateItem"
    case conversationMarkRead        = "ConversationMarkRead"
    case bookSearch        = "BookSearch"
    case newsSearch        = "NewsSearch"
    case userSearch        = "UserSearch"
    case bookAuthor        = "BookAuthor"
    case authorSearch        = "AuthorSearch"
}


let  messageInstance = MessageInstance.sharedInstance()

class MessageInstance: NSObject {
    var socket : SocketIOClient!
    var manager : SocketManager!
    
    static var instance: MessageInstance!
    
    var isRegister = false
    
    class func sharedInstance() -> MessageInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? MessageInstance())
        }
        return self.instance
    }
    
    @objc func userLoginSuccess()
    {
        initSocket()
        connectSocket()
    }
    
    func initSocket()
    {
        manager = SocketManager(socketURL: URL(string: "http://dephoanmy.vn:9802")!, config: [.log(true),
                                                                                              .selfSigned(true),
                                                                                              .reconnects(true),
                                                                                              .forceWebsockets(true),
                                                                                              .compress,
                                                                                              .forceNew(true),
                                                                                              .connectParams(["user_id":userInstance.user.id])])
        manager.reconnects = true;
        socket = manager.defaultSocket
    }
    
    func connectSocket()
    {
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            messageInstance.contactList(GeneralMessageRequest())
            messageInstance.conversationReceive(GeneralMessageRequest())
            self.registerMessageNotify()
            self.contactRegister()
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("disconnect")
        }
        
    }
    
    func reconnect()
    {
        if(manager == nil)
        {
            return
        }
        
        switch manager.status {
        case .connected:
            print("socket connected")
            break;
            
        case .connecting:
            print("socket connecting")
            break;
            
        case .disconnected:
            socket.setReconnecting(reason: "Rec")
            break;
        case .notConnected:
            connectSocket()
            print("socket not connected")
            break;
            
        }
    }
    
    func isConnected () ->Bool
    {
        return manager.status == .connected
    }
    
    func disConnectSocket()
    {
        socket.disconnect()
    }
    
    
}

