//
//  PrintAddView.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

protocol FileAddViewDelegate : class {
    func fileAddViewSelect(_ storeType : FileStore)
}

class FileAddView: GreenView, PrintAddUnitViewDelegate {
    
    weak var delegate : FileAddViewDelegate?
    @IBOutlet weak var googleDri: PrintAddUnitView!
    @IBOutlet weak var dropbox: PrintAddUnitView!
    @IBOutlet weak var icloud: PrintAddUnitView!
    
    override func initStyle() {
        drawRadius(4)
        
        googleDri.delegate = self
        icloud.delegate = self
        dropbox.delegate = self
        
        dropbox.set("Dropbox", "dropbox".image())
        icloud.set("iCloud", "icloud".image())
        googleDri.set("Google Drive", "drive".image())
    }
    
    func printAddUnitViewTouch(_ sender: PrintAddUnitView) {
        if(sender == dropbox)
        {
            delegate?.fileAddViewSelect(.dropbox)
        }
        else if(sender == googleDri)
        {
            delegate?.fileAddViewSelect(.drive)
        }
        else if(sender == icloud)
        {
            delegate?.fileAddViewSelect(.icloud)
        }
    }
}
