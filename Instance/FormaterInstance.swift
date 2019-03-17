//
//  FormaterInstance.swift
//  NCMobileERP_iOS
//
//  Created by Lê Dũng on 6/6/17.
//  Copyright © 2017 nhatcuong. All rights reserved.
//

import UIKit



let VNTimeFormat = "HH:mm:ss"
let VNDateFormat =  "dd/MM/yyyy"

let APIDateFormat =  "MM/dd/yyyy"

let  formaterInstance = FormaterInstance.sharedInstance()
class FormaterInstance: NSObject
{

    
    
    
    
    static var instance: FormaterInstance!
    class func sharedInstance() -> FormaterInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? FormaterInstance())
        }
        return self.instance
    }
    
    // Hàm chuyển đổi từ kiểu Double sang tiền tệ
    func priceFromDouble(value : Double) ->String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "es_ES") as Locale!
        formatter.maximumFractionDigits = 0 ;
        return formatter.string(from: value as NSNumber)!.appending(" đ")
    }
    
        //  hàm chuyển từ Double sang định dạng số lượng . ex  7.5kg
    func numberValue(value : Double) ->String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 2 ;
        formatter.decimalSeparator = ""
        return formatter.string(from: value as NSNumber)!
    }

    // Hàm chuyển định dạng ngày sang chuổi
    func dateToString(date : Date) ->String
    {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = VNDateFormat
        return dateFormatter.string(from: date)
    }
    
    func timeString(date : Date) ->String
    {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = VNTimeFormat
        return dateFormatter.string(from: date)
    }


    // Hàm chuyển định dạng ngày sang String, chỉ dùng lúc call api
    func dateToAPIString(date : Date) ->String
    {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = APIDateFormat
        return dateFormatter.string(from: date)
    }
    
    // hàm lấy ngày đầu tiên của tháng
    func firstDateOfMonth() ->Date
    {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        return Calendar.current.date(from: comp)!
    }
}

extension Double
{
    // Hàm chuyển đổi từ kiểu Double sang tiền tệ
    func priceValue()->String
    {
        return formaterInstance.priceFromDouble(value: self)
    }
    
    //  hàm chuyển từ Double sang định dạng số lượng . ex  7.5kg
    func numberValue()-> String
    {
        return formaterInstance.numberValue(value: self)
    }
    
    //  hàm chuyển từ Double sang định dạng số lượng . ex  7.5kg
    func stringValue()->String
    {
        return formaterInstance.numberValue(value: self)
    }
}

extension Date
{
    // chuyển từ ngày Date -> String , định dạng vn
    func stringValue() ->String
    {
      return  formaterInstance.dateToString(date: self)
    }

    func timeValue() ->String
    {
        return  formaterInstance.timeString(date: self)
    }

    // chuyển từ Date -> String, định dạng API
    func APIStringValue () ->String
    {
        return  formaterInstance.dateToAPIString(date: self)
    }
    
    // lấy ngày đầu tiên của tháng
    func firstDateOfMonth() ->Date
    {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        return Calendar.current.date(from: comp)!
    }
}


extension String
{
    
    func vnDate() -> Date?
    {
        let formater = DateFormatter()
        formater.dateFormat = VNDateFormat
        return formater.date(from: self)
    }

    
    func timeDisplay() -> String
    {
        let formater = DateFormatter()
        formater.dateFormat = "hh:mm"
        return formater.string(from: date8601())
    }
}


