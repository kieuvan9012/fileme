//
//  PrintSelectCell.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

class PrintSelectCell: UICollectionViewCell {

    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white

    }
    
    func active()
    {
        lbTitle.textColor = UIColor.white
        contentView.backgroundColor = template.primaryColor
    }
    
    func inActive()
    {
        lbTitle.textColor = UIColor.lightGray
        contentView.backgroundColor = UIColor.white


    }
    func set(_ value : String)
    {
        lbTitle.text = value
    }

}
