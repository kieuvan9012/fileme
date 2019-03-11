//
//  GreenExtension+Date.swift
//  GProject
//
//  Created by KieuVan on 3/23/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

extension Formatter
{
        static let iso8601: DateFormatter =
        {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    
    

    

}



