//
//  LimeContact.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/10/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

enum ContactType : Int
{
    case response = 2
    case request = 1
    case success = 12
    case none = -1
}


class LimeContact: Mi {

    @objc dynamic var status = -1
    var contactType : ContactType!


    
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
        contactType = ContactType.init(rawValue: status)
    }
    
    required public init() {
        super.init()
    }
    class func  list(data : [Dictionary<String, Any>]) -> [LimeContact]
    {
        var output  : [LimeContact]  = []
        for item in data
        {
            let unit = LimeContact.init(dictionary: item as NSDictionary)
            output.append(unit)
        }
        return output
    }
}


