//
//  UserInstance.swift
//  MiBook
//
//  Created by Dũng Lê on 7/31/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit

enum UserDefaultsKey : String
{
    case isFirstLogin   = "IsFirstLogin"
    case username       = "Username"
    case password       = "Password"
    case deviceToken = "LIMERENCEDEVICETOKEN"
    case isLoginFace = "ISLOGINFACEBOOK"
    case isAcceptPostLegancy = "isAcceptPostLegancy"
}

import SDWebImage
let  userInstance = UserInstance.sharedInstance()

class UserInstance: NSObject
{
    var user = User()
    var isMatchVersion = true
    var isLogin = false;
    var appInfo : ApplicationInfo!
    
    static var instance: UserInstance!
    class func sharedInstance() -> UserInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? UserInstance())
            self.instance.user.id = -1 ;
            self.instance.user.aliasname = ""
        }
        return self.instance
    }
    
    func setApplicationInfo(_ appInfo : ApplicationInfo)
    {
    }
    
    func login(_ userLogin : User)
    {
        userInstance.user = userLogin
        userLoginSuccess()
        setUsername(user.username)
        setPassword(user.password)
        isLogin = true;
        userLoginSuccess()
    }
    
    func updateUser(_ value : User)
    {
        user.aliasname = value.aliasname
        user.avatar = value.avatar
        user.phone = value.phone
        user.gender = value.gender
        user.dob = value.dob
        user.cover = value.cover
        
        user.university_name = value.university_name
        user.university_id = value.university_id
        user.province_id = value.province_id
        user.province_name = value.province_name
        user.district_id = value.district_id
        user.district_name = value.district_name
    }
    
    func logout()
    {
        userInstance.user.id = -1
        userInstance.user.aliasname = ""
        setAlreadyLogin(false)
        setUsername("")
        setPassword("")
        setAlreadyLogin(false)
        isLogin = false
    }
    
    @objc func userLoginSuccess()
    {
        setAlreadyLogin(true)
        let request = DeviceInfo.init()
        request.user_id = userInstance.user.id
        request.token = userInstance.getDeviceToken()
        services.deviceUpdate(request, success: { () in
            
        }) { (error) in
            
        }
    }
    
    
    func setIsLoginFace(_ value : Bool)
    {
        UserDefaults.standard.set(value, forKey: UserDefaultsKey.isLoginFace.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func isLoginFace()->Bool
    {
        let islgf = UserDefaults.standard.value(forKey: UserDefaultsKey.isLoginFace.rawValue)
        if(islgf is Bool)
        {
            return islgf as! Bool
        }
        else
        {
            return false
        }
    }
    
    
    func setDeviceToken(_ value : String)
    {
        UserDefaults.standard.set(value, forKey: UserDefaultsKey.deviceToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func acceptLagency(_ value : Bool)
    {
        UserDefaults.standard.set(value, forKey: UserDefaultsKey.isAcceptPostLegancy.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getAcceptLagency() ->Bool
    {
        if let islgf = UserDefaults.standard.value(forKey: UserDefaultsKey.isAcceptPostLegancy.rawValue)
        {
            return islgf as! Bool
        }
        return false
    }

    func setCouting(_ value : Int)
    {
        UserDefaults.standard.set(value, forKey: "Countx")
        UserDefaults.standard.synchronize()
    }
    
    func getCouting() -> Int
    {
        return UserDefaults.standard.value(forKey: "Countx") as! Int
    }

    func getDeviceToken()->String
    {
        let token = UserDefaults.standard.value(forKey: UserDefaultsKey.deviceToken.rawValue)
        return (token == nil) ? "" : token as! String
    }
    
    func alreadyLogin()->Bool
    {
        if((UserDefaults.standard.value(forKey: UserDefaultsKey.isFirstLogin.rawValue)) != nil)
        {
            return UserDefaults.standard.value(forKey: UserDefaultsKey.isFirstLogin.rawValue)  as! Bool
        }
        else
        {
            return false;
        }
    }
    
    func setAlreadyLogin(_ isFirstLogin : Bool)
    {
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.isFirstLogin.rawValue)
    }
    
    func getUsername()->String
    {
        let username = UserDefaults.standard.value(forKey: UserDefaultsKey.username.rawValue)
        if(username != nil)
        {
            return username as! String
        }
        return ""
    }
    
    func setUsername(_ Username : String)
    {
        UserDefaults.standard.setValue(Username, forKey: UserDefaultsKey.username.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getPassword()->String
    {
        let pass = UserDefaults.standard.value(forKey: UserDefaultsKey.password.rawValue)
        if(pass != nil)
        {
            return pass as! String
        }
        return ""
    }
    
    func setPassword(_ Password : String)
    {
        UserDefaults.standard.setValue(Password, forKey: UserDefaultsKey.password.rawValue)
    }
    
    func setCustomKey(_ value : String)
    {
        UserDefaults.standard.setValue(value, forKey: "CustomKey")
    }

    func getCustomKey()->String
    {
        let username = UserDefaults.standard.value(forKey: "CustomKey")
        if(username != nil)
        {
            return username as! String
        }
        return ""
    }
}
