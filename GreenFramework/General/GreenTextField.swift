//
//  GreenTextField.swift
//  GFramework
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

 class GreenTextField: UITextField {

    func initStyle()
    {
        self.backgroundColor = UIColor.clear
    }
    
    override  func awakeFromNib() {
        initStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initStyle()
    }

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initStyle()
    }

    public convenience init()
    {
        self.init(frame: CGRect.init())
    }


}
