//
//  Message_Contact.swift
//  MiBook
//
//  Created by Lê Dũng on 12/6/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
class Contact_Request : Mi
{
    @objc dynamic var user_id = userInstance.user.id ;
    @objc dynamic var target_user_id = -1
    @objc dynamic var contact_id = -1
}

extension  MessageInstance {


    func contactRegister()
    {
        socket.on(ConferenceNotify.contactOnline.rawValue) {data, ack in
            if(data.count > 0)
            {
                notifyInstance.postM(.contactOnline, data[0])
            }
        }
        
        socket.on(ConferenceNotify.contactOffline.rawValue) {data, ack in
            if(data.count > 0)
            {
                notifyInstance.postM(.contactOffline, data[0])
            }
        }
        
        socket.on(ConferenceNotify.contactInfo.rawValue) {data, ack in
            if(data.count > 0)
            {
                let dictionary = data[0] as! NSDictionary
                notifyInstance.postM(.contactInfo, LimeContact.init(dictionary: dictionary))
            }
        }
    }
    
    func contactAdd(_ request : Contact_Request)
    {
        socket.emit(ConferenceNotify.contactAdd.rawValue, with: [request.dictionary()])
    }
    
    func contactCancel(_ request : Contact_Request)
    {
        socket.emit(ConferenceNotify.contactCancel.rawValue, with: [request.dictionary()])
    }
    func contactDeny(_ request : Contact_Request)
    {
        socket.emit(ConferenceNotify.contactDeny.rawValue, with: [request.dictionary()])
    }
    
    func contactAccept(_ request : Contact_Request)
    {
        socket.emit(ConferenceNotify.contactAccept.rawValue, with: [request.dictionary()])
    }
    
    func contactInfo(_ request : Contact_Request)
    {
        socket.emit(ConferenceNotify.contactInfo.rawValue, with: [request.dictionary()])
    }
}
