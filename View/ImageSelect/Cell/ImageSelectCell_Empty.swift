//
//  ImageSelectCell_Empty.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/26/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class ImageSelectCell_Empty: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.drawRadius(4, color: template.primaryColor, thickness: 1)
    }

}
