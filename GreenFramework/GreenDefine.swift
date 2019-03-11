//
//  GreenDefine.swift
//  Green
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit
public var greenDefine = GreenDefine.sharedInstance()


open class CFStyle : NSObject {
    var font : UIFont!
    var color : UIColor!
}



public enum TextStyle
{
    case h1Sub
    case h2Sub
    case h3Sub
    case h4Sub
    case h5Sub
    case h6Sub
    
    case h1General
    case h2General
    case h3General
    case h4General
    case h5General
    case h6General
    
    case h1Highlight
    case h2Highlight
    case h3Highlight
    case h4Highlight
    case h5Highlight
    case h6Highlight
}


open class GreenDefine: NSObject
{
    open  var GreenFont  = UIFont.systemFont(ofSize: 12)
    open  var GreenFontBold = UIFont.boldSystemFont(ofSize: 12)
    
    
    open var H1Font : UIFont! 
    open var H2Font : UIFont!
    open var H3Font : UIFont!
    open var H4Font : UIFont!
    open var H5Font : UIFont!
    open var H6Font : UIFont!
    
    open var GreenSubTextColor = UIColor.red
    open var GreenGeneralTextColor = UIColor.green
    open var GreenHighlightTextColor = UIColor.blue
    
    open var GreenCheckBox_ImageCheck  = UIImage.init(named: "ic_check")
    open var GreenCheckBox_ImageUncheck  = UIImage.init(named: "ic_uncheck")

    
    //---------------------------------------------
    open var GreenInfoView_BackgroundColor  = UIColor.clear
    open var GreenInfoView_TitleColor = UIColor.red
    open var GreenInfoView_ContentColor = UIColor.black
    open var GreenInfoView_LineColor = UIColor.lightGray
    
    
    //-------------------------------------------------------------------------
    open var GreenDropDown_BackgroundColor  = UIColor.clear
    open var GreenDropDown_TitleColor = UIColor.red
    open var GreenDropDown_RightImage : UIImage!
    open var GreenDropDown_SelectedBackgroundColor = UIColor.red
    open var GreenDropDown_UnSelectedBackgroundColor = UIColor.red
    open var GreenDropDown_SelectedTextColor = UIColor.red
    open var GreenDropDown_UnSelectedTextColor = UIColor.red
    
    //-------------------------------------------------------------------------
    
    open var GreenRadius  = 2
    open var GreenButton_Radius  = 2
    
    open var GreenButtonSuccess_BackgroundColor  = UIColor.red
    open var GreenButtonSuccess_TitleColor = UIColor.white
    
    open var GreenButtonInfo_BackgroundColor  = UIColor.green
    open var GreenButtonInfo_TitleColor = UIColor.white
    
    open var GreenButtonDanger_BackgroundColor  = UIColor.blue
    open var GreenButtonDanger_TitleColor = UIColor.white
    
    open var GreenButtonWarning_BackgroundColor  = UIColor.black
    open var GreenButtonWarning_TitleColor = UIColor.white
    
    open var GreenButtonLink_TitleColor  = UIColor.black
    open var GreenButtonLink_LineColor = UIColor.red
    
    open var GreenInfoFieldSymbol_TextStyle : TextStyle = TextStyle.h3General
    open var GreenInfoFieldSymbol_BackgroundColor : UIColor = UIColor.red
    open var GreenInfoFieldSymbol_LineColor : UIColor = UIColor.red
    open var GreenInfoFieldSymbol_LeftBackgroundColor : UIColor = UIColor.red
    open var GreenInfoFieldSymbol_RightBackgroundColor : UIColor = UIColor.red
    open var GreenInfoFieldSymbol_Radius : CGFloat = 2
    open var GreenInfoFieldSymbol_PlacehoderTextColor : UIColor = UIColor.red


    
    
    
    open var GreenInfoFieldStep_Radius : CGFloat = 2
    open var GreenInfoFieldStep_TextColor = UIColor.black
    open var GreenInfoFieldStep_BackgroundColor = UIColor.white
    open var GreenInfoFieldStep_ButtonTintColor = UIColor.green
    open var GreenInfoFieldStep_LeftImage  : UIImage! = UIImage.init(named: "GMinus")
    open var GreenInfoFieldStep_RightImage : UIImage! = UIImage.init(named: "GPlus")




    
    
    
    
    
    
    var GreenStepField_LeftImage : UIImage!
    var GreenStepField_RightImage : UIImage!
    var GreenStepField_LineColor = UIColor.red
    var GreenStepField_Radius = 2.0
    
    
    
    
    
    open var GreenInfoFieldHorizontal_LeftTextStyle  = TextStyle.h3Sub
    open var GreenInfoFieldHorizontal_RightTextStyle = TextStyle.h3General

    
    
    open func defaultStyle()
    {
    }
    
    static var instance: GreenDefine!
    class func sharedInstance() -> GreenDefine
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? GreenDefine())
            self.instance.defaultStyle()
        }
        return self.instance
    }
    
    open func getFontStyle(_ textStyle : TextStyle) -> CFStyle
    {
        let cfStyle : CFStyle = CFStyle()
        switch textStyle {
        case .h1Sub: cfStyle.font = H1Font ; cfStyle.color = GreenSubTextColor; break
        case .h2Sub: cfStyle.font = H2Font ; cfStyle.color = GreenSubTextColor; break
        case .h3Sub: cfStyle.font = H3Font ; cfStyle.color = GreenSubTextColor; break
        case .h4Sub: cfStyle.font = H4Font ; cfStyle.color = GreenSubTextColor; break
        case .h5Sub: cfStyle.font = H5Font ; cfStyle.color = GreenSubTextColor; break
        case .h6Sub: cfStyle.font = H6Font ; cfStyle.color = GreenSubTextColor; break
        case .h1General: cfStyle.font = H1Font ; cfStyle.color = GreenGeneralTextColor ; break
        case .h2General: cfStyle.font = H2Font ; cfStyle.color = GreenGeneralTextColor ; break
        case .h3General: cfStyle.font = H3Font ; cfStyle.color = GreenGeneralTextColor ; break
        case .h4General: cfStyle.font = H4Font ; cfStyle.color = GreenGeneralTextColor ; break
        case .h5General: cfStyle.font = H5Font ; cfStyle.color = GreenGeneralTextColor ; break
        case .h6General: cfStyle.font = H6Font ; cfStyle.color = GreenGeneralTextColor ; break
        case .h1Highlight: cfStyle.font = H1Font ; cfStyle.color = GreenHighlightTextColor ; break
        case .h2Highlight: cfStyle.font = H2Font ; cfStyle.color = GreenHighlightTextColor ; break
        case .h3Highlight: cfStyle.font = H3Font ; cfStyle.color = GreenHighlightTextColor ; break
        case .h4Highlight: cfStyle.font = H4Font ; cfStyle.color = GreenHighlightTextColor ; break
        case .h5Highlight: cfStyle.font = H5Font ; cfStyle.color = GreenHighlightTextColor ; break
        case .h6Highlight: cfStyle.font = H6Font ; cfStyle.color = GreenHighlightTextColor ; break
        }
        return cfStyle
    }
    
}
