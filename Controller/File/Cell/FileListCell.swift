//
//  FileListCell.swift
//  File Me
//
//  Created by Lê Dũng on 3/10/19.
//

import UIKit

class FileListCell: MasterUITableViewCell {
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var levelTraits: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!

    var file : MediaFile!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
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
