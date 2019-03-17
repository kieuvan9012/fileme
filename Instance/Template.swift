//
//  ApplicationStyleDefine.swift
//  MTS
//
//  Created by KieuVan on 2/22/17.
//  Copyright © 2017 InnoTech. All rights reserved.
//

import UIKit


public let  template = ApplicationTemplaceInstance.sharedInstance()
@objc open class ApplicationTemplaceInstance: NSObject {
    
    static var instance: ApplicationTemplaceInstance!
    class func sharedInstance() -> ApplicationTemplaceInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? ApplicationTemplaceInstance())
        }
        return self.instance
    }

    var viewRadius      : Float = 3;
    var buttonRadius    : Float = 0;
    var successColor    : UIColor!
    var infoColor       : UIColor!
    var dangerColor     = "FF671e".hexColor()
    var warningColor    : UIColor!
    
    var backgroundColor = "EAEBED".hexColor()
    var backgroundHighlightColor = "232b3D".hexColor()
    var negativeColor = "F8FAFF".hexColor()
    
    var highlightTextColor = "0386c6".hexColor()
    var navigationColor = "F8FAFF".hexColor()
    
    var newsColor = "3b6de0".hexColor()
    var questionColor = "6a3ce2".hexColor()

    
    
    
    
    
    var primaryPlusColor = "E64B3B".hexColor()
    var primaryMinusMinusColor = "FFB8B0".hexColor()

    var primaryMinusColor = "FF9185".hexColor()

    var primaryColor = "ff7061".hexColor()
    var secondaryColor = "FF2535".hexColor()
    var lendColor = "009c91".hexColor()
    var buyColor = "3BD900".hexColor()
    var sellColor = "FF671e".hexColor()
    var naviColor = "44424A".hexColor()
    var accentColor  = "25A3FF".hexColor()
    var subTextColor = "A5AED0".hexColor()
    var generalTextColor = "000000".hexColor()
}








