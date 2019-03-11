//
//  SimpleNavi.swift
//  LimeBook
//
//  Created by Lê Dũng on 10/7/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class SimpleNavi: GreenView {

    @IBOutlet weak var heightStatus: NSLayoutConstraint!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbTitle: UILabel!

    
    
    override func initStyle() {
        mainView.backgroundColor = template.primaryColor
        statusView.backgroundColor = template.primaryColor
        lbTitle.textColor = UIColor.white
        
        if(device.isRStatusBar())
        {
            heightStatus.constant = 40 ;
        }

    }
    
    
    func set(_ title : String)
    {
        lbTitle.text = title.capitalized ;
    }
}
