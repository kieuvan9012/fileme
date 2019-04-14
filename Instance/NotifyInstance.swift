//
//  NotifyInstance.swift
//  iTraffic
//
//  Created by Lê Dũng on 3/6/18.
//  Copyright © 2018 Ledung. All rights reserved.
//

import UIKit

public enum NotifyType : String
{
    case reloadContactList           = "ReloadContactList"
    case updateLocation              = "updateLocation"
    case reloadConversation          = "ReloadConversation"
    case reloadMessageList           = "reloadMessageList"
    case insertMessageRow            = "insertMessageRow"
    case cartUpdateItem              = "cartUpadteItem"
    case hitOutsideCell                  = "hitOutsideCell"

}

let notifyInstance = NotifyInstance.sharedInstance()

class NotifyInstance: NSObject
{
    
    public static var instance: NotifyInstance!
    public class func sharedInstance() -> NotifyInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? NotifyInstance())
        }
        return self.instance
    }
    
    func add(_ target : Any,_ type : NotifyType, selector : Selector)
    {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name(rawValue: type.rawValue), object: nil)
    }
    
    func post(_ type : NotifyType, _ object : Any?)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: type.rawValue), object: object, userInfo: nil)
    }
    
    func post(_ type : NotifyType)
    {
        post(type, nil)
    }
    
    func remove (_ target : Any)
    {
        NotificationCenter.default.removeObserver(target)
    }
    
    func postM(_ type : ConferenceNotify, _ object : Any?)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: type.rawValue), object: object, userInfo: nil)
    }
    
    func addM(_ target : Any,_ type : ConferenceNotify, selector : Selector)
    {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name(rawValue: type.rawValue), object: nil)
    }

    
    
    func postFile(_ type : NotifyType, _ object : Any?)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: type.rawValue), object: object, userInfo: nil)
    }
    func addFile(_ target : Any,_ type : NotifyType, selector : Selector)
    {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name(rawValue: type.rawValue), object: nil)
    }


}
