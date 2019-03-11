//
//  AppInstance.swift
//  MiBook
//
//  Created by Lê Dũng on 12/28/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
let  apppInstance = AppInstance.sharedInstance()

class AppInstance: NSObject {

    var is_maintenance = false
    var ios_version = ""
    var ios_link = ""
    
    func updateInfo(_ values : [ApplicationInfo])
    {
        for item in values
        {
            if(item.name == "ios_version")
            {
                ios_version = item.value
            }
            if(item.name == "is_maintenance")
            {
                is_maintenance = item.value.toBool()
            }
            if(item.name == "ios_link")
            {
                ios_link = item.value
            }
        }
    }
    
    func isMatchVersion() -> Bool
    {
        let dictionary = Bundle.main.infoDictionary!
        let version  = dictionary["CFBundleShortVersionString"] as! String
        let revision  = dictionary["CFBundleVersion"] as! String
        
        let totalVersion = version + "-" + revision
        
        if(totalVersion == ios_version)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    static var instance: AppInstance!
    class func sharedInstance() -> AppInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? AppInstance())
        }
        return self.instance
    }


}
