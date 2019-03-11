//
//  ReactView.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/27/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

protocol ReactUserDelegate {
    func reactUserTouch(_ sender : ReactUserView)
}

class ReactUserView: GreenView {

    var delegate : ReactUserDelegate!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var img: UIImageView!

    @IBAction func reactTouch(_ sender: Any) {
        delegate.reactUserTouch(self)
    }
    
    override func initStyle() {
        lbCount.textColor = template.subTextColor
    }
    
    func setImage(_ value : UIImage, _ title : String)
    {
        img.image = value
        lbCount.text = title
    }
    
}
