//
//  ApplicationInfo.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/10/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class ApplicationInfo: Mi {

    @objc dynamic var id = -1;
    @objc dynamic var name = "";
    @objc dynamic var value = "";

    class func  list(data : [Dictionary<String, Any>]) -> [ApplicationInfo]
    {
        var output  : [ApplicationInfo]  = []
        for item in data
        {
            let unit = ApplicationInfo.init(dictionary: item as NSDictionary)
            output.append(unit)
        }
        return output
    }


}


class DraftOrderDTO : Mi {
    @objc dynamic var numberOrder = 1
    @objc dynamic var createDate = 123456
    @objc dynamic var items : Dictionary<String, AnyObject> = Dictionary()
    @objc dynamic var items_model : [OrderItemDTO] = [OrderItemDTO()]
    required init()
    {
        super.init()
    }
    func grossModel()
    {
        for item in items_model
        {
            items[item.name] = item.dictionary() as AnyObject
        }
    }
}
class OrderItemDTO : Mi {
    @objc dynamic var name = "item1"
    @objc dynamic var numberOrder = 1
    @objc dynamic var message = "order message"
}


extension Services
{
    func applicationInfo(success :@escaping (([ApplicationInfo])->Void), failure: ((String)->Void))
    {
        let requst = DraftOrderDTO()
        requst.grossModel()
        
        let endRequest = requst.dictionary(ignore: ["items_model"])
        services.request(api: .applicationInfo, param: endRequest, success: { (response) in
            success(ApplicationInfo.list(data: response.data as! [Dictionary<String, Any>]))
        }) { (error) in
            
        }
    }
}

