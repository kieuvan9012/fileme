//
//  GreenExtension+NSMutableAttributedString.swift
//  MTS_POC
//
//  Created by Emty on 4/12/19.
//  Copyright © 2019 Lê Dũng. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    @discardableResult func setAttributedString(_ text: String, color: UIColor, font: UIFont, textAlignment: NSTextAlignment) -> NSMutableAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        
        let attrs: [NSAttributedString.Key: Any] = [.font: font,
                                                    .paragraphStyle: style,
                                                    .foregroundColor : color]
        let string = NSMutableAttributedString(string:text, attributes: attrs)
        append(string)
        
        return self
    }
    
    @discardableResult func boldLargeLeft(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.textColor, font: UIFont.systemFont(ofSize: 20, weight: .bold), textAlignment: .left)
    }

    @discardableResult func boldLargeRight(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.textColor, font: UIFont.systemFont(ofSize: 20, weight: .bold), textAlignment: .right)
    }
    
    @discardableResult func boldLargeCenter(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.textColor, font: UIFont.systemFont(ofSize: 20, weight: .bold), textAlignment: .center)
    }
    
    @discardableResult func boldLeft(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.textColor, font: UIFont.systemFont(ofSize: 16, weight: .bold), textAlignment: .left)
    }
    
    @discardableResult func boldRight(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.textColor, font: UIFont.systemFont(ofSize: 16, weight: .bold), textAlignment: .right)
    }

    @discardableResult func boldCenter(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.textColor, font: UIFont.systemFont(ofSize: 16, weight: .bold), textAlignment: .center)
    }

    @discardableResult func subLeft(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.subTextColor, font: UIFont.systemFont(ofSize: 16, weight: .regular), textAlignment: .left)
    }
    
    @discardableResult func subRight(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.subTextColor, font: UIFont.systemFont(ofSize: 16, weight: .regular), textAlignment: .right)
    }

    @discardableResult func subCenter(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.subTextColor, font: UIFont.systemFont(ofSize: 16, weight: .regular), textAlignment: .center)
    }
    
    @discardableResult func normalLeft(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.subTextColor, font: UIFont.systemFont(ofSize: 16, weight: .regular), textAlignment: .left)
    }
    
    @discardableResult func normalRight(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.subTextColor, font: UIFont.systemFont(ofSize: 16, weight: .regular), textAlignment: .right)
    }
    
    @discardableResult func normalCenter(_ text: String) -> NSMutableAttributedString {
        return self.setAttributedString(text, color: template.subTextColor, font: UIFont.systemFont(ofSize: 16, weight: .regular), textAlignment: .center)
    }
    
    @discardableResult func space() -> NSMutableAttributedString {
        let space = NSAttributedString(string: " ")
        append(space)
        
        return self
    }
    
    @discardableResult func tab() -> NSMutableAttributedString {
        let normal = NSAttributedString(string: "\t\t")
        append(normal)
        
        return self
    }
    
    @discardableResult func newLine() -> NSMutableAttributedString {
        let normal = NSAttributedString(string: "\n")
        append(normal)
        return self
    }
}

extension NSAttributedString
{
    class func newLine()-> NSAttributedString
    {
        return  NSAttributedString.init(string: "\n")
    }
    class func newTab()-> NSAttributedString
    {
        return  NSAttributedString.init(string: "\t")
    }
}

//extension FOS_PlaceOrderViewController
//{
//    func getAttribute(_ request :FO_FOS_TF_OE_NewOrder_Request) -> NSAttributedString
//    {
//        let conprice = request.conPrice.trim()
//        var price = request.price.stringValue()
//        if(conprice != "")
//        {
//            price = typeField.selectedValue.uppercased()
//        }
//
//        let title = NSMutableAttributedString.init(string: "FOS_PlaceConfirm".localized().uppercased())
//        if(request.isBuy())
//        {
//            title.boldColor("FOS_PlaceConfirmBuy".localized().uppercased(),template.buyColor)
//        }
//        else
//        {
//            title.boldColor("FOS_PlaceConfirmSell".localized().uppercased(),template.sellColor)
//        }
//        title.newLine().newLine()
//
//        let formattedString = NSMutableAttributedString()
//
//        formattedString
//            .normal("FOS_OrderHistory_SeriesID".localized())
//            .normal(" : ")
//            .bold(request.symbol)
//            .newLine()
//            .normal("FOS_StockVolume".localized())
//            .normal(" : ")
//            .bold(request.volume.stringValue())
//            .newLine()
//            .normal("FOS_Price".localized())
//            .normal(" : ")
//            .bold(price)
//            .newLine()
//
//        if((request.stopOrderType != STOPLIMIT_TYPE.NORMAL.rawValue) && (request.conPrice.trim() == ""))
//        {
//            let conditionalFormat = NSMutableAttributedString()
//            conditionalFormat
//                .normal("FOS_ConditionalType".localized())
//                .normal(" : ")
//                .bold(FOS_OrderConditional.desType(request.stopOrderType))
//                .newLine()
//
//            let intOrderType = STOPLIMIT_TYPE.init(rawValue: request.stopOrderType)
//
//            if(intOrderType! == .TIME)
//            {
//                conditionalFormat.normal("FOS_TriggerTime".localized())
//                    .normal(" : ")
//                    .bold(request.validityDate.fos_time_display()).newLine()
//            }
//            if((intOrderType! == .UP) || (intOrderType! == .DOWN) || (intOrderType! == .T_UP ) || (intOrderType! == .T_DOWN ) || (intOrderType! == .STOP ))
//            {
//                conditionalFormat.normal("FOS_TriggerPrice".localized())
//                    .normal(" : ")
//                    .bold(request.stopPrice.stringValue()).newLine()
//            }
//
//            if(intOrderType! == .OCO)
//            {
//                conditionalFormat.normal("FOS_B_LosPrice".localized())
//                    .normal(" : ")
//                    .bold(request.stopPrice.stringValue()).newLine()
//                conditionalFormat.normal("FOS_B_Spread".localized())
//                    .normal(" : ")
//                    .bold(request.stopToler.stringValue()).newLine()
//                conditionalFormat.normal("FOS_B_AJPrice".localized())
//                    .normal(" : ")
//                    .bold(request.adjPriceOCO().stringValue()).newLine()
//            }
//
//            if(intOrderType! == .BULLBEAR)
//            {
//                conditionalFormat.normal("FOS_B_ProfitStep".localized())
//                    .normal(" : ")
//                    .bold(request.profitStep.stringValue()).newLine()
//                conditionalFormat.normal("FOS_B_ProfitPrice".localized())
//                    .normal(" : ")
//                    .bold(request.profitPrice().stringValue()).newLine()
//                conditionalFormat.normal("FOS_B_LossStep".localized())
//                    .normal(" : ")
//                    .bold(request.lossStep.stringValue()).newLine()
//                conditionalFormat.normal("FOS_B_LosPrice".localized())
//                    .normal(" : ")
//                    .bold(request.lossPrice().stringValue()).newLine()
//                conditionalFormat.normal("FOS_B_Spread".localized())
//                    .normal(" : ")
//                    .bold(request.stopToler.stringValue()).newLine()
//                conditionalFormat.normal("FOS_B_AJPrice".localized())
//                    .normal(" : ")
//                    .bold(request.adjPriceBullBear().stringValue()).newLine().newLine()
//            }
//            formattedString.append(conditionalFormat)
//        }
//
//        let accountString = NSMutableAttributedString()
//        accountString
//            .normal( "Login_Account".localized()).normal(" : ")
//            .boldColor(AccountsDataManager.sharedInstance()?.getFOSAccountList()[0] as! String,template.sellColor)
//        formattedString.append(accountString)
//
//        //        let paragraphStyle = NSMutableParagraphStyle()
//        //        let decimalTerminators:CharacterSet = [" "]
//        //        let decimalTabOptions = [NSTextTab.OptionKey.columnTerminators:decimalTerminators]
//        //        let decimalTabLocation = CGFloat(160) // TODO: Calculate...
//        //        let decimalTab = NSTextTab(textAlignment: .left, location: decimalTabLocation, options: decimalTabOptions)
//        //        let leftTab = NSTextTab(textAlignment: .left, location: CGFloat(0.01), options: [:])
//        //        paragraphStyle.tabStops = [leftTab, decimalTab]
//        //
//        //        formattedString.addAttributes( [NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange.init(location: 0, length: formattedString.length))
//
//        formattedString.newLine().newLine()
//        formattedString.normal("FOS_PlaceUnit".localized())
//        title.append(formattedString)
//        return title
//    }
//}
