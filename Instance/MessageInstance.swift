//
//  MessageInstance.swift
//  MiBook
//
//  Created by Le Dung on 3/13/18.
//  Copyright © 2018 Ledung. All rights reserved.
//

import UIKit

import SocketIO


enum GeneralNotify : String
{
    
    case userLoginSuccess       = "UserLoginSuccess"
    
    
    
    
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

