//
//  ServicesConfig.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
let  servicesConfig = ServicesConfig.sharedInstance()


class ServicesConfig: NSObject {
    
    let baseURL = "http://dephoanmy.vn:9886/"

    let url = "http://dephoanmy.vn:9886/"
    
    let testURL = "https://backend.loyaworld.com:7443/"

    static var instance: ServicesConfig!
    class func sharedInstance() -> ServicesConfig
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? ServicesConfig())
        }
        return self.instance
    }
}


