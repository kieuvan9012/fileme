//
//  PrintAddView.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

enum FileStore : Int {
    case fileMe = 0
    case drive = 1
    case dropbox = 2
    case icloud = 3
}



protocol PrintAddViewDelegate : class {
    func printAddViewSelect(_ storeType : FileStore)
}

class PrintAddView: GreenView, PrintAddUnitViewDelegate {
    
    weak var delegate : PrintAddViewDelegate?
    
    
    @IBOutlet weak var googleDri: PrintAddUnitView!
    
    @IBOutlet weak var fileMe: PrintAddUnitView!
    @IBOutlet weak var icloud: PrintAddUnitView!
    override func initStyle() {
        drawRadius(4)
        
        googleDri.delegate = self
        icloud.delegate = self;
        fileMe.delegate = self;
        
        
        fileMe.set("File Me", "Attach".image())
        icloud.set("iCloud", "icloud".image())
        googleDri.set("Google Drive", "drive".image())

    }
    
    func printAddUnitViewTouch(_ sender: PrintAddUnitView) {
        if(sender == fileMe)
        {
            delegate?.printAddViewSelect(.fileMe)
        }
        else if(sender == googleDri)
        {
            delegate?.printAddViewSelect(.drive)

        }
        else if(sender == icloud)
        {
            delegate?.printAddViewSelect(.icloud)

        }
        
    }

}
