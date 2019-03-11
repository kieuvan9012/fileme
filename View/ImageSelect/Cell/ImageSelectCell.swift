//
//  ImageSelectCell.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/26/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
import AlamofireImage
protocol ImageSelectCellDelegate {
    func imageSelectCellDelete( _ imgSelect : ImageSelect)
}
class ImageSelectCell: UICollectionViewCell {

    
    var delegate : ImageSelectCellDelegate!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    var imgSelect : ImageSelect!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        mainView.drawRadius(4)
        
        
    }

    @IBAction func deleteTouch(_ sender: Any) {
        delegate.imageSelectCellDelete(imgSelect )
    }
    
    func set(_ imageSelect : ImageSelect)
    {
        self.imgSelect = imageSelect
        
        if(imgSelect.isLocal)
        {
            imgView.image = imageSelect.image
        }
        else
        {
            imgView.setSD(imageSelect.imageURL)
        }
    }
}
