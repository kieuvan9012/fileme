//
//  PrintStore.swift
//  FileMe
//
//  Created by Lê Dũng on 3/19/19.
//

import UIKit

class PrintStore: Mi {

}
class PrintStoreList_Request : Mi
{
    
}

extension Services
{
    func printStoreList( request :UserNear_Request,success :@escaping (([User])->Void), failure: ((String)->Void))
    {
        services.request(api: .userSearch, param: request.dictionary(), success: { (response) in
            success(User.list(data: response.data as! [Dictionary<String, Any>]))
        }) { (error) in
            
        }
    }

}
