//
//  PrintAddUnitView.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

protocol PrintAddUnitViewDelegate : class {
    func printAddUnitViewTouch(_ sender : PrintAddUnitView)
}

class PrintAddUnitView: GreenView
{

    weak var delegate : PrintAddUnitViewDelegate?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbTitne: UILabel!
    
    func set(_ title : String, _ image : UIImage)
    {
        lbTitne.text = title;
        imgView.image = image
    }

    @IBAction func touchIn(_ sender: Any) {
        weak var weakself = self
        delegate?.printAddUnitViewTouch(weakself!)
    }
    

}
