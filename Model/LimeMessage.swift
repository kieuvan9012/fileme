//
//  LimeMessage.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/15/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

enum MesageType : Int
{
    case plaintext = 1
    case media = 2
    case file = 4
}

enum MessageMediaType : Int
{
    case image = 1
    case audio = 2
    case file  = 3
    case video  = 4
}

enum MessagePrivateType : Int
{
    case prev = 1
    case group = 2
    case broacast  = 3
}






class LimeMessage: Mi {
    
    
    @objc dynamic var readed = false // trạng thái đã/chưa đọc
    @objc dynamic var delivered = false // trạng thái đã/chưa nhận
    @objc dynamic var content = "" // nội dung
    @objc dynamic var conversation_id = 0
    @objc dynamic var media_type = 0 // loại media : video, image , tạm chưa dùng
    @objc dynamic var private_type = 0
    @objc dynamic var message_type = 1 //loại : tạm thời chỉ chat text
    @objc dynamic var create_date = ""
    @objc dynamic var date_io = Date()
    @objc dynamic var timeDisplay = ""
    @objc dynamic var id = -1
    @objc dynamic var user_id = -1 // người gửi
    @objc dynamic var target_user_id = -1 // người nhận
    @objc dynamic var aliasname = "" // tên ngừoi gửi
    @objc dynamic var avatar = "" // avatar người gửi
    @objc dynamic var attri : NSMutableAttributedString!

    @objc dynamic var next : LimeMessage!
    @objc weak dynamic var  previous : LimeMessage!

    
    func getKeyID()->Int
    {
        if(user_id != userInstance.user.id)
        {
            return user_id
        }
        else
        {
            return target_user_id
        }
    }
    
    func conversation()->Conversation
    {
        let newConversation  = Conversation()
        newConversation.id = conversation_id
        newConversation.last_message = content
        newConversation.image = avatar
        return newConversation
    }
    
    
    
    func messageType()-> MesageType
    {
        if(message_type == 1)
        {
            return .plaintext
        }
        else
        {
            return .media
        }
        
    }
    
    init(_ text : String)
    {
        super.init()
        self.user_id = userInstance.user.id
        self.target_user_id = 2
        self.message_type = 1
        self.content = text
        self.attributeText()
    }
    
    
    
    
    func attributeText()
    {
        
        attri = NSMutableAttributedString.init(string: content)

        
        attri = NSMutableAttributedString(
            string: content,
            attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])

        
        if(self.content.contains("emj"))
        {
           for item in interfaceDataStore.emoj
           {
                if(self.content.contains(item))
                {
                    var n = 0
                    let rang = attri.string.ranges(of:item)
                    for itemRange in rang
                    {
                        var targetName = item.replacingOccurrences(of: "]", with: "")
                        targetName = targetName.replacingOccurrences(of: "[", with: "")
                        let image1Attachment = NSTextAttachment()
                        image1Attachment.image = UIImage(named: targetName)
                        if(self.content.length == 7 )
                        {
                            image1Attachment.bounds = CGRect.init(x: 0, y: 0, width: 48, height: 48)
                        }
                        else
                        {
                            image1Attachment.bounds = CGRect.init(x: 0, y: -4, width: 18, height: 18)
                        }
                        let image1String = NSAttributedString(attachment: image1Attachment)
                        attri.replaceCharacters(in: NSRange.init(location: itemRange.lowerBound.encodedOffset - (n*6), length: 7), with: image1String)
                        n = n + 1;
                    }
                }
            }
        }
    }
    
    override init(dictionary: NSDictionary)
    {
        super.init(dictionary: dictionary)
        self.attributeText()
    }
    
    override init(dictionary: NSDictionary, ignore: [String]) {
        super.init(dictionary: dictionary, ignore: ignore)
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    class func  list(data : [Dictionary<String, Any>]) -> [LimeMessage]
    {
        var output  : [LimeMessage]  = []
        
        if(data.count > 0)
        {
            for i in  0...data.count-1
            {
                let item = data[i]
                let unit = LimeMessage.init(dictionary: item as NSDictionary)
                unit.date_io = unit.create_date.date8601()
                unit.timeDisplay = unit.date_io.timeValue()
                
                if(i > 0)
                {
                    unit.previous = output[i-1]
                    output[i-1].next = unit
                }
                unit.attributeText()
                output.append(unit)
            }

        }
        
        return output
    }
    
    func insertMessage()
    {
        
    }


}
