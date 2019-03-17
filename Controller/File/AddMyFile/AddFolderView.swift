//
//  AddFolderView.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

protocol AddFolderViewDelegate : class {
    func addFolderViewAccept(_ value : String)
}

class AddFolderView: GreenView {

    
    weak var delegate : AddFolderViewDelegate?
    override func initStyle() {
        drawRadius(4)
    }
    
    
    @IBOutlet weak var tfContent: UITextField!
    
    
    @IBAction func cancelAction(_ sender: Any) {
        superview!.hideAlertBox()
    }
    
    @IBAction func createAction(_ sender: Any) {
        delegate?.addFolderViewAccept((tfContent.text?.trim())!)
        superview!.hideAlertBox()
    }
    
}
