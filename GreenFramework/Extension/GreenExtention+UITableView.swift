//
//  GreenExtention+UITableView.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension UITableView
{
    public func setIdentifier(_ identifier : String)
    {
        register(UINib.init(nibName: identifier , bundle: Bundle.main), forCellReuseIdentifier: identifier);
    }
    
    public func getIdentiferCell(_ identifier : String) -> UITableViewCell
    {
       return  dequeueReusableCell(withIdentifier: identifier)!
    }
    
        func scrollToBottom(animated: Bool)
    {
            let y = contentSize.height - frame.size.height
            setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }

}
extension UITableView {
    func reloadDataSmoothly() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock { () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        
        reloadData()
        beginUpdates()
        endUpdates()
        
        CATransaction.commit()
    }
}

