//
//  DeviceInstance.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
import DeviceUtil
import SystemConfiguration
let isIpad  : Bool = UIDevice.current.userInterfaceIdiom == .pad
let isIphone  : Bool = !isIpad
let isPortrait : Bool = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
let isLandscape:Bool = !isPortrait

let isStatusBarPortrait:Bool = (UIApplication.shared.statusBarOrientation.isPortrait)
let isStatusBarLandscape:Bool = !isStatusBarPortrait
let screenSize = UIScreen.main.bounds.size



let  device = DeviceInstance.sharedInstance()
class DeviceInstance: NSObject {
    
    let screenSize = UIScreen.main.bounds.size

    var Name = ""
    var OS = ""
    var Version = ""
    var revision = ""
    var Token = ""
    var Latitude = 0.0
    var Longitude = 0.0
    let deviceU = DeviceUtil.init()

    static var instance: DeviceInstance!
    class func sharedInstance() -> DeviceInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? DeviceInstance())
        }
        self.instance.appVersion()
        return self.instance
    }
    
    func appVersion()
    {
        self.Name =   UIDevice.current.name
        self.OS =     UIDevice.current.systemVersion
    }
    
    
     func  isConnectedNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
            {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else
        {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    
    func vendorID() ->String
    {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    func isRStatusBar() ->Bool
    {
        var resutl = false ;
        let hardW = deviceU.hardware()
        
        switch hardW {
        case .IPHONE_X,.IPHONE_X_CN,.IPHONE_XR,.IPHONE_XS,.IPHONE_XS_MAX,.IPHONE_XS_MAX_CN: resutl = true ; break;
        default: resutl = false ;
        }
        return resutl
        
    }

}
