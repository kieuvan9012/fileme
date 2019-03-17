//
//  MIDropListTableView.swift
//  File Me
//
//  Created by Lê Dũng on 3/17/19.
//

import UIKit

class MIDropListTableView: GreenView {
    @IBOutlet weak var tbView: UITableView!
    public var dropListView: MIDropListView?
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.point(inside: point, with: event) {
            return super.hitTest(point, with: event)
        }
        guard isUserInteractionEnabled, !isHidden, alpha > 0 else {
            return nil
        }
        
        let pointInDropdown = self.convert(point, to: dropListView)
        if (dropListView?.point(inside: pointInDropdown, with: event) == false) {
            isHidden = true
        }
        
        return nil
    }
    
    
    override func initStyle() {
        tbView?.layer.cornerRadius = 2
        tbView?.layer.masksToBounds = true
        tbView?.clipsToBounds = true
        tbView?.layer.borderWidth = 1
        tbView?.layer.borderColor = template.primaryColor.cgColor
    }
    
    deinit {
        print("Deinit---------")
    }
}
