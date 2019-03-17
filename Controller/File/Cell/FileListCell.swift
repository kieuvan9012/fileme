//
//  FileListCell.swift
//  File Me
//
//  Created by Lê Dũng on 3/10/19.
//

import UIKit

class FileListCell: UITableViewCell {

    @IBOutlet weak var activeView: UIView!
    
    var file : MediaFile!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var levelTraits: NSLayoutConstraint!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBOutlet weak var imgView: UIImageView!
    func set(_ file : MediaFile)
    {
        self.file = file
        imgView.image = file.imageDisplay()
        lbTitle.text = file.originalname
        levelTraits.constant = CGFloat(12 + ((file.level - 1) * 24))
        
        updateMedia()
    }
    
    func updateMedia()
    {
        if(file.active)
        {
            activeView.backgroundColor = template.primaryColor
        }
        else
        {
            activeView.backgroundColor = .white
        }

    }
}
