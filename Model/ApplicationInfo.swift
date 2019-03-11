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

extension Services
{
    func applicationInfo(success :@escaping (([ApplicationInfo])->Void), failure: ((String)->Void))
    {
        services.request(api: .applicationInfo, param: General_Request().dictionary(), success: { (response) in
            success(ApplicationInfo.list(data: response.data as! [Dictionary<String, Any>]))
        }) { (error) in
            
        }
    }
}

