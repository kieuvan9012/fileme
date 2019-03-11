//
//  DHMDistrict.swift
//  Mobile_68
//
//  Created by Lê Dũng on 7/17/18.
//  Copyright © 2018 Ledung. All rights reserved.
//

import UIKit

class District: Mi {
    @objc dynamic var id = -1
    @objc dynamic var name = ""
    @objc dynamic var province_id = -1

    
    class func  list(data : [Dictionary<String, Any>]) -> [District]
    {
        var output  : [District]  = []
        for item in data
        {
            let unit = District.init(dictionary: item as NSDictionary)
            output.append(unit)
        }
        return output
    }

}
extension Services
{
    
    func addressNode( success : @escaping (([NSDictionary],[NSDictionary])->Void), failure : @escaping ((String)->Void))
    {
        services.request(api: .addressNode, param: ["":"" as AnyObject], success: { (response) in
            let dict = response.data as! NSDictionary;            
            success(dict.value(forKey: "province") as! [NSDictionary],dict.value(forKey: "district") as! [NSDictionary])
        }) { (error) in
            
        }
    }
    
}
