//
//  ContactDataStore.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/29/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
let  contactDataStore = ContactDataStore.sharedInstance()

class ContactDataStore: NSObject {

    static var instance: ContactDataStore!
    var contacts : [User] = []


    
    class func sharedInstance() -> ContactDataStore
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? ContactDataStore())
            notifyInstance.addM(self.instance, .contactOnline, selector: #selector(contactOnline))
            notifyInstance.addM(self.instance, .contactOffline, selector: #selector(contactOffline))
            notifyInstance.addM(self.instance, .contactReceive, selector: #selector(contactReceive))
        }
        
        return self.instance
    }
    func reloadContactList()
    {
        notifyInstance.post(.reloadContactList, nil)
    }
    
    @objc func contactOffline(notify  : NSNotification)
    {
        let idOnline = Int(notify.object as! String)
        let indexUser = contacts.index{$0.id == idOnline}
        if(indexUser != nil)
        {
            contacts[indexUser!].isOnline = false;
            reloadContactList()
        }
    }
    @objc func contactReceive(notify  : NSNotification)
    {
        let rosterList = notify.object as! [User]
        contacts.removeAll()
        contacts .append(contentsOf: rosterList)
        reloadContactList()
    }
    
    @objc func contactOnline(notify  : NSNotification)
    {
        let idOnline = Int(notify.object as! String)
        let indexUser = contacts.index{$0.id == idOnline}
        if(indexUser != nil)
        {
            contacts[indexUser!].isOnline = true;
            reloadContactList()
        }
    }

}
