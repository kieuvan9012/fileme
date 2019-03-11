//
//  University.swift
//  MiBook
//
//  Created by Lê Dũng on 1/4/19.
//  Copyright © 2019 limerence. All rights reserved.
//

import UIKit

class University: Mi {
    @objc dynamic var id = 1;
    @objc dynamic var name = "";
    
    class func  list(data : [Dictionary<String, Any>]) -> [University]
    {
        var output  : [University]  = []
        for item in data
        {
            let unit = University.init(dictionary: item as NSDictionary)
            output.append(unit)
        }        
        return output
    }

}



extension Services
{
    func universityList(success :@escaping (([University])->Void), failure: ((String)->Void))
    {
        services.request(api: .universityList, param:["":"" as AnyObject], success: { (response) in
            success(University.list(data: response.data as! [Dictionary<String, Any>]))
        }) { (error) in
        }
    }
}
