//
//  sdf.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/15/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

extension  MessageInstance {
    func registerMessageNotify()
    {
        if(isRegister)
        {
            return ;
        }
        isRegister = true
        
        socket.on(ConferenceNotify.userLoginSuccess.rawValue) {data, ack in ack.with("Got your currentAmount", "dude")
            print("UserLoginSuccess-----------------\(data)")
        }
        
        socket.on(ConferenceNotify.messageReceive.rawValue) {data, ack in
            
            if(data.count > 0)
            {
                let message = LimeMessage.init(dictionary: data[0] as! NSDictionary)
                message.date_io = message.create_date.date8601()
                message.timeDisplay = message.date_io.timeValue()
                confernceDataStore.messageReceive(message)
                notifyInstance.postM(.messageReceive, message)
            }
        }
        
        socket.on(ConferenceNotify.messageRead.rawValue) {data, ack in
            notifyInstance.postM(.messageRead, data)
        }
        
        socket.on(ConferenceNotify.messageDelivery.rawValue) {data, ack in
            notifyInstance.postM(.messageDelivery, data)
        }

        socket.on(ConferenceNotify.messageSendSuccess.rawValue) {data, ack in
            notifyInstance.postM(.messageSendSuccess, data)
        }
        
        socket.on(ConferenceNotify.messageDelivery.rawValue) {data, ack in
            notifyInstance.postM(.messageDelivery, data)
        }
        
        socket.on(ConferenceNotify.messageLatest.rawValue) {data, ack in
            if(data.count > 0)
            {
                let messageList = LimeMessage.list(data: data[0] as! [Dictionary<String, Any>])
                if(messageList.count > 0)
                {
                    confernceDataStore.messageLatest(messageList)
                    notifyInstance.postM(.messageLatest, nil)
                }
            }
        }

        socket.on(ConferenceNotify.messageAfter.rawValue) {data, ack in
            notifyInstance.postM(.messageAfter, data)
        }
        
        socket.on(ConferenceNotify.contactReceive.rawValue) {data, ack in
            if(data.count > 0)
            {
                let messageList = User.list(data: data[0] as! [Dictionary<String, Any>])
                notifyInstance.postM(.contactReceive, messageList)
            }
        }
        
        socket.on(ConferenceNotify.conversationReceive.rawValue) {data, ack in
            if(data.count > 0)
            {
                let conversationList = Conversation.list(data: data[0] as! [Dictionary<String, Any>])
                confernceDataStore.conversationReceive(conversationList)
                notifyInstance.postM(.conversationReceive, conversationList)
            }
        }
                
        socket.on(ConferenceNotify.messageHistory.rawValue) {data, ack in
            if(data.count > 0)
            {
                let messageList = LimeMessage.list(data: data[0] as! [Dictionary<String, Any>])
                notifyInstance.postM(.messageHistory, messageList)
            }
        }

        socket.on(ConferenceNotify.developerRequest.rawValue) {data, ack in
        }
        
        socket.on(ConferenceNotify.conversationUpdateItem.rawValue) {data, ack in
            if(data.count > 0)
            {
                let conversationList = Conversation.list(data: data[0] as! [Dictionary<String, Any>])
                let conversa = conversationList[0]
                confernceDataStore.requestConversationUpdate(conversa)
                notifyInstance.postM(.conversationUpdateItem, conversa)
            }
        }

        socket.on(ConferenceNotify.userSearch.rawValue) {data, ack in
            if(data.count > 0)
            {
                let users = User.list(data: data[0] as! [Dictionary<String, Any>])
                notifyInstance.postM(.userSearch, users)
            }
        }
    }
}
