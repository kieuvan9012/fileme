//
//  ConfernceDataStore.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/19/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
let  confernceDataStore = ConfernceDataStore.sharedInstance()

class ConfernceDataStore: NSObject
{
    static var instance: ConfernceDataStore!
    var conversations : [Conversation] = []

    class func sharedInstance() -> ConfernceDataStore
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? ConfernceDataStore())
        }
        return self.instance
    }

    
    @objc func messageLatest(_ messages   :  [LimeMessage])
    {
        if(messages.count > 0)
        {
            let conversation = self.forceGetConversationByMessage(messages.first!)
            conversation.messages.append(contentsOf: messages)
            notifyInstance.post(.reloadMessageList, nil)
        }
    }

    @objc func messageReceive(_ message  : LimeMessage)
    {
        insertMessage(message)
    }
    
    func insertMessage(_ message : LimeMessage)
    {
        print("Insert message");
        var conversation : Conversation!
        let targetIndex = conversations.index(where: {$0.id == message.conversation_id})
        if(targetIndex == nil)
        {
            conversation = Conversation.init(message: message)
            self.conversations.insert(conversation, at: 0)
        }
        else
        {
            
            let index = self.conversations.index{$0.target_user_id == message.getKeyID()}
            if(index != nil)
            {
                conversation = self.conversations[index!]
            }
            else
            {
                conversation = Conversation.init(message: message)
                self.conversations.insert(conversation, at: 0)
            }
        }
        conversation.messages.append(message)
        conversation.last_message = message.content
        conversation.attributeLastMessage()
        notifyInstance.post(.reloadConversation, nil)
    }
    
    @objc func conversationReceive(_ convers : [Conversation])
    {
        for item in convers
        {
            requestConversationUpdate(item)
        }
        notifyInstance.post(.reloadConversation, nil)
    }

    func conversationNotifyUnreadMessage()-> Int
    {
        return   conversations.count{$0.message_unread > 0 }
    }
    
    func requestConversationUpdate(_ target : Conversation)
    {
        let index = self.conversations.index{$0.target_user_id == target.target_user_id}
        if(index != nil)
        {
            let conversation = self.conversations[index!]
            conversation.update(target)
        }
        else
        {
            self.conversations.insert(target, at: 0)
        }
    }
    
    func forceGetConversationByUser(_ target : User) ->Conversation
    {
        let index = self.conversations.index{$0.target_user_id == target.id}
        if(index != nil)
        {
            let conversation = self.conversations[index!]
            return conversation
        }
        else
        {
            let conver = Conversation.init(user: target)
            self.conversations.insert(conver, at: 0)
            return conver
        }
    }
    
    
    func updateConversation(_ value  : Conversation)
    {
        let index = self.conversations.index{$0.target_user_id == value.target_user_id}
        if(index != nil)
        {
            let conversation = self.conversations[index!]
            conversation.update(value)
        }
    }
    
    
    func forceGetConversationByMessage(_ value  : LimeMessage) -> Conversation
    {
        let index = self.conversations.index{$0.id == value.conversation_id}
        if(index != nil)
        {
            return self.conversations[index!]
        }
        else
        {
            let conver = Conversation.init(message: value)
            self.conversations.insert(conver, at: 0)
            return conver
        }
    }

    func sendMessage(_ value : LimeMessage)
    {
        messageInstance.sendMessage(value)
    }
    
}
