//
//  MessageEMIT.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/15/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class GeneralMessageRequest : Mi
{
    @objc dynamic var conversation_id = -1
    @objc dynamic var limit = 60;
    @objc dynamic var user_id = userInstance.user.id;
    @objc dynamic var target_user_id = 2;

    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
    }
    
    init(_ target : User)
    {
        super.init()
        target_user_id = target.id
    }
    
    required init() {
        super.init()
    }
}


class ContactAdd_Request : Mi
{
    @objc dynamic var user_id = userInstance.user.id ;
    @objc dynamic var target_user_id = -1
}

class MessageLatest_Request : Mi
{
    @objc dynamic var user_id = userInstance.user.id ;
    @objc dynamic var target_user_id = -1
    @objc dynamic var message_id = -1
    
    init(_ user_id : Int, _ target_user_id : Int,_ message_id : Int)
    {
        super.init()
        self.user_id = user_id
        self.target_user_id = target_user_id
        self.message_id = message_id
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
}

class CustomRequest_Request : Mi
{
    @objc dynamic var user_id = 12 ;
    @objc dynamic var target_user_id = 33
    @objc dynamic var request_id = "ledung"
}

class MessageHistory_Request : Mi
{
    @objc dynamic var message_id = 0 ;
}

class BookSearch_Request : Mi
{
    @objc dynamic var keyword = "" ;
}

class UserSearchEngine_Request : Mi
{
    @objc dynamic var keyword = "" ;
}

class BookAuthor_Request : Mi
{
    @objc dynamic var keyword = "" ;
}

class BookReport_Request : Mi
{
    @objc dynamic var user_id = -1 ;
    @objc dynamic var book_id = -1 ;
    @objc dynamic var content = "" ;
}

extension   MessageInstance {
    
    func sendMessage(_ message : LimeMessage)
    {
        let mess = message.dictionary(ignore: ["date_io","next","previous","timeDisplay","date","attri"])
        socket.emit(ConferenceNotify.messageSend.rawValue, with:[mess])
    }
    
    func readMessage(_ message : LimeMessage)
    {
        socket.emit(ConferenceNotify.messageRead.rawValue, with: [message.dictionary()])
    }
    
    func receiveMessage(_ message : LimeMessage)
    {
        socket.emit(ConferenceNotify.messageDelivery.rawValue, with: [message.dictionary()])
    }
    
    func afterMessage(_ message : GeneralMessageRequest)
    {
        socket.emit(ConferenceNotify.messageAfter.rawValue, with: [message.dictionary()])
    }

    func latestMessage(_ message : MessageLatest_Request)
    {
        socket.emit(ConferenceNotify.messageLatest.rawValue, with: [message.dictionary()])
    }

    func contactList(_ request : GeneralMessageRequest)
    {
        socket.emit(ConferenceNotify.contactList.rawValue, with: [request.dictionary()])
    }
    
    func conversationReceive(_ request : GeneralMessageRequest)
    {
        socket.emit(ConferenceNotify.conversationReceive.rawValue, with: [request.dictionary()])
    }

    func conversationMarkRead(_ request : GeneralMessageRequest)
    {
        socket.emit(ConferenceNotify.conversationMarkRead.rawValue, with: [request.dictionary()])
    }
    
    func bookSearch(_ request : BookSearch_Request)
    {
        socket.emit(ConferenceNotify.bookSearch.rawValue, with: [request.dictionary()])
    }
    
    
    func userSearch(_ request : UserSearch_Request)
    {
        socket.emit(ConferenceNotify.userSearch.rawValue, with: [request.dictionary()])
    }
    
    func newsSearch(_ request : NewsSearch_Request)
    {
        socket.emit(ConferenceNotify.newsSearch.rawValue, with: [request.dictionary()])
    }

    func customRequest(_ request : CustomRequest_Request)
    {
        socket.emit("CustomRequest", with: [request.dictionary()])
    }
    
    func messageHistory(_ request : MessageHistory_Request)
    {
        socket.emit(ConferenceNotify.messageHistory.rawValue, with: [request.dictionary()])
    }
}
