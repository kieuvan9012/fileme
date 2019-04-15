//
//  PrintStore.swift
//  FileMe
//
//  Created by Lê Dũng on 3/19/19.
//

import UIKit

class PrintStore: Mi {
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var location = ""
    @objc dynamic var province_name = ""
    @objc dynamic var district_name = ""
    
    class func  list(data : [Dictionary<String, Any>]) -> [PrintStore]
    {
        var output  : [PrintStore]  = []
        for item in data
        {
            let unit = PrintStore.init(dictionary: item as NSDictionary)
            output.append(unit)
        }
        return output
    }
}

class PrintStoreList_Request : Mi
{
    // nodatarequest
}

extension Services
{
    func printStoreList( request :PrintStoreList_Request,success :@escaping (([PrintStore])->Void), failure: @escaping ((String)->Void))
    {
        services.request(api: .printStoreList, param: request.dictionary(), success: { (response) in
            success(PrintStore.list(data: response.data as! [Dictionary<String, Any>]))
        }) { (error) in
            failure(error)
        }
    }

}
