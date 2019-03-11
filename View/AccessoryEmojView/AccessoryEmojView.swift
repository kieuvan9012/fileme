//
//  AccessoryEmojView.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/26/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

protocol AccessoryEmojViewDelegate {
    func accessEmojSelectKeyboard()
    func accessEmojSelectEmoj()
}

class AccessoryEmojView: GreenView {

    var delegate : AccessoryEmojViewDelegate!


    @IBAction func keyboardSelect(_ sender: Any)
    {
        delegate.accessEmojSelectKeyboard()
    }
    
    @IBAction func emojSelect(_ sender: Any)
    {
        delegate.accessEmojSelectEmoj()

    }
    
    override func initStyle() {
        view.backgroundColor = UIColor.white
        view.backgroundColor = template.backgroundColor

    }
    
}
