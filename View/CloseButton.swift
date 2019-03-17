//
//  CloseButton.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

class CloseButton: GreenView {
    
    
    var closeBlock : (()->Void)!
    @IBOutlet weak var contentView: UIView!
    
    override func layoutSubviews() {
        
        contentView.drawRadius(contentView.frame.size.width/2)
    }

    
    func setTouch(block : @escaping (()->Void))
    {
    }
    @IBAction func touchIn(_ sender: Any) {
        viewController()!.view.hideAlertBox()
    }
}
