//
//  BookImageView.swift
//  MiBook
//
//  Created by Lê Dũng on 2/15/19.
//  Copyright © 2019 limerence. All rights reserved.
//

import UIKit

class BookImageView: GreenView {

    @IBOutlet weak var imgView: UIImageView!
    func set(_ urlString : String)
    {
        imgView.setSD(urlString)
    }
}
