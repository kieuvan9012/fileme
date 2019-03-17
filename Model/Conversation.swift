//
//  Conversation.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/16/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class Conversation: Mi {
    // đây là list hiển thị ở tab các cuộc trò chuyện
    @objc dynamic var id = -1
    @objc dynamic var user_id = -1
    @objc dynamic var target_user_id = -1
    @objc dynamic var last_message = ""// message cuối
    @objc dynamic var name = "" // tên người ko phải là mình
    @objc dynamic var image = "" // avatar người ko phải mình
    @objc dynamic var last_date = ""
    @objc dynamic var conversation_type = -1
    @objc dynamic var messages : [LimeMessage] = []
    

    var media_file : MediaFile!
    @objc dynamic var message_unread = 0 // số lượng message mà mình chưa đọc
    @objc dynamic var lastMessageAttribute : NSAttributedString!
    
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
        initMedia()
    }
    
    override init(dictionary: NSDictionary, ignore: [String]) {
        super.init(dictionary: dictionary, ignore: ignore)
        initMedia()
    }
    
    init(user : User)
    {
        super.init()
        target_user_id = user.id
        user_id = userInstance.user.id
        name = user.aliasname
        image = user.avatar
        initMedia()
    }
    
    init(message : LimeMessage)
    {
        super.init()
        user_id = userInstance.user.id
        id = message.conversation_id
        target_user_id = message.user_id
        image = message.avatar
        name = message.aliasname
        initMedia()
        last_message = message.content
    }

    
    required public init()
    {
        super.init()
    }
    
    
    func initMedia()
    {
    }
    
    func update(_ new : Conversation)
    {
        id = new.id
        last_message = new.last_message
        message_unread = new.message_unread
        name = new.name
        image = new.image
        initMedia()
    }
    
    
    class func  list(data : [Dictionary<String, Any>]) -> [Conversation]
    {
        var output  : [Conversation]  = []
        for item in data
        {
            let unit = Conversation.init(dictionary: item as NSDictionary, ignore: ["media_file"])
            unit.attributeLastMessage()
            output.append(unit)
        }
        return output
    }
    
    func user()->User
    {
        let user = User()
        user.id = target_user_id ;
        user.avatar = image
        user.aliasname = name
        return user ;
    }
    
    func messageLatestId() -> Int
    {
        var lastId  = -1
        if(messages.count > 0)
        {
            lastId = messages.last!.id
        }
        return lastId;
    }
    
    func messageCount()->Int
    {
        return messages.count
    }
    
    func userContacts(success :@escaping (([User])->Void), failure: ((String)->Void))
    {
        services.request(api: .contactList, param: General_Request().dictionary(), success: { (response) in
            success(User.list(data: response.data as! [Dictionary<String, Any>]))
        }) { (error) in
            
        }
    }
    
    
    func readAllMessage()
    {
        for item in messages
        {
            item.readed = true;
        }
        message_unread = 0
        
    }

    func attributeLastMessage()
    {
        lastMessageAttribute = last_message.emojAttributeText(true)
    }

    func insertMessage(_ value : LimeMessage)
    {
        messages.append(value)
        attributeLastMessage()
    }
    
    func removeAliasMessage()
    {
        messages = messages.filter(){ $0.id > 0 }
    }
    
}
