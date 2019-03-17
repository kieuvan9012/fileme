//
//  Services.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
import Alamofire
class APIResponse: Mi
{
    @objc dynamic var success = false;
    @objc dynamic var  message = "";
    @objc dynamic var  data : Any!
    @objc dynamic var  code  = 0
}


enum UploadType : String
{
    case user = "user"
    case book = "book"
}

let  services = Services.sharedInstance()
class Services: NSObject {
    static var instance: Services!
    class func sharedInstance() -> Services
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? Services())
        }
        return self.instance
    }

    func request(api : APIFunction, param : Dictionary <String, AnyObject>, success :@escaping ((APIResponse)->Void), failure :@escaping ((String)->Void))
    {
        weak var weakself = self
        let dataRequest = repareRequest(api: api, parameter: param)
        
        
                do {
                    let data = try JSONSerialization.data(withJSONObject: param, options: [])
                    let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    if let json = json {
                        print("JSON: \(json)")
                    }
                } catch {
                    print("JSON serialization failed:  \(error)")
                }

        
        
        
        
        Alamofire.request(dataRequest.0, method: .post, parameters: dataRequest.1, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print("api : \(api.rawValue) \n  response :  \(response.result.value)")   // result of response serialization
                let apiResponse = weakself?.processReponse(response: response)
                if(apiResponse?.success)!
                {
                    success(apiResponse!)
                }
                else
                {
                    failure((apiResponse?.message)!)
                }
        }
    }
    

    
    
    func processReponse(response : DataResponse<Any>) -> APIResponse
    {
        if(response.result.isSuccess)
        {
            return APIResponse.init(dictionary: response.result.value as! NSDictionary)
        }
        else
        {
            return APIResponse.init()
        }
    }
    
    func repareRequest(api : APIFunction, parameter : Dictionary <String,AnyObject>) -> (String, Parameters)
    {
        var endParameter : Parameters = [:]
        for  (k,v) in  parameter
        {
            endParameter[k] = v
        }
        return (servicesConfig.url.appending(api.rawValue),endParameter)
    }


    func uploadMedia(_ brand : MediaBrand,images : [UIImage],success :@escaping ((APIResponse)->Void), failure :@escaping ((String)->Void), progress: @escaping ((Progress)->Void))
    {
        weak var weakself = self
        let dataRequest = repareRequest(api: APIFunction.uploadMedia, parameter: NSDictionary() as! Dictionary<String, AnyObject>)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let StringID = String(userInstance.user.id)
            multipartFormData.append(String(brand.rawValue).data(using: String.Encoding.utf8)!, withName: "brand")
            multipartFormData.append(StringID.data(using: String.Encoding.utf8)!, withName: "user_id")
            
            for image in images
            {
                let imageType = image.imageType()
                let fileName =  String.random(4) + "." + imageType
                multipartFormData.append((image.mediumQualityJPEGNSData)  , withName: "media", fileName: fileName, mimeType: imageType.mineType())
            }
            
        }, to:dataRequest.0,headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progressValue) in
                    progress(progressValue)
                })
                upload.responseJSON
                    { response in
                        
                        print(response.result.value as Any)   // result of response serialization
                        
                        let apiResponse = weakself?.processReponse(response: response)
                        if (apiResponse?.success == true) {
                            success(apiResponse!)
                        }
                        else
                        {
                            failure((apiResponse?.message)!)
                        }
                }
            case .failure( _):
                failure("Lỗi không xác định")
                
                break
            }
        }
    }
    
    
    func uploadFile(file : MediaFile,success :@escaping ((APIResponse)->Void), failure :@escaping ((String)->Void), progress: @escaping ((Progress)->Void))
    {
        weak var weakself = self
        let dataRequest = repareRequest(api: APIFunction.uploadMedia, parameter: NSDictionary() as! Dictionary<String, AnyObject>)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let StringID = String(userInstance.user.id)
            multipartFormData.append("1".data(using: String.Encoding.utf8)!, withName: "brand")
            multipartFormData.append(StringID.data(using: String.Encoding.utf8)!, withName: "user_id")
            multipartFormData.append(file.data  , withName: "media", fileName: file.name, mimeType: file.fileExtension)
            
        }, to:dataRequest.0,headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progressValue) in
                    progress(progressValue)
                })
                upload.responseJSON
                    { response in
                        
                        print(response.result.value as Any)   // result of response serialization
                        
                        let apiResponse = weakself?.processReponse(response: response)
                        if (apiResponse?.success == true) {
                            success(apiResponse!)
                        }
                        else
                        {
                            failure((apiResponse?.message)!)
                        }
                }
            case .failure( _):
                failure("Lỗi không xác định")
                
                break
            }
        }
    }


    
}
