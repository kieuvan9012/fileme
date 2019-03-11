//
//  GreenExtension+String.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension UITableViewCell
{
    var tableView: UITableView? {
        return self.parentView(of: UITableView.self)
    }

}

//Value of type 'String' has no member 'parentView'
