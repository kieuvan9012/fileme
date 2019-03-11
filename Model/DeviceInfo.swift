//
//  DeviceInfo.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/18/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class DeviceInfo: Mi {
    @objc dynamic var token = ""
    @objc dynamic var socket_id = ""
    @objc dynamic var version = ""
    @objc dynamic var revision = ""
    @objc dynamic var operation = "ios"
    @objc dynamic var name = ""
    @objc dynamic var device_id = ""
    @objc dynamic var device_type = "IPHONE"
    @objc dynamic var user_id = -1
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
    }
    
    required init() {
        super.init()
        user_id = userInstance.user.id
        token = userInstance.getDeviceToken()
        operation = device.OS
        version = device.Version
        revision = device.revision
        name = device.Name
        device_id = device.vendorID()
        device_type = "IPHONE"
    }
}

extension Services
{
    func deviceUpdate(_ request : DeviceInfo, success :@escaping (()->Void), failure: ((String)->Void))
    {
        services.request(api: .deviceUpdate, param: request.dictionary(), success: { (response) in
            success()
        }) { (error) in
            
        }
    }
    
    
    
}

