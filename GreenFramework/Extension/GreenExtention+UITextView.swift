//
//  GreenExtention+UITextView.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
extension UITextView
{
    public func setStyle(_ style : TextStyle)
    {
        self.font = greenDefine.getFontStyle(style).font
        self.textColor = greenDefine.getFontStyle(style).color
    }
    
    
    public func setBold()
    {
        self.font = UIFont(name: greenDefine.GreenFontBold.fontName, size: (self.font?.pointSize)!)
    }

}
