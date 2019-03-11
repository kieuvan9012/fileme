//
//  DHMProvince.swift
//  Mobile_68
//
//  Created by Lê Dũng on 7/17/18.
//  Copyright © 2018 Ledung. All rights reserved.
//

import UIKit

class Province: Mi {
    @objc dynamic var id = -1
    @objc dynamic var name = ""
    @objc dynamic var child : [Province]! = []
    
    @objc dynamic var IsSelect = false

    
    class func  list(data : [Dictionary<String, Any>]) -> [Province]
    {
        var output  : [Province]  = []
        for item in data
        {
            let unit = Province.init(dictionary: item as NSDictionary)
            output.append(unit)
        }
        return output
    }

}


