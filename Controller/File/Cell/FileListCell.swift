//
//  FileListCell.swift
//  File Me
//
//  Created by Lê Dũng on 3/10/19.
//

import UIKit

class FileListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var levelTraits: NSLayoutConstraint!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var imgView: UIImageView!
    func set(_ file : MediaFile)
    {
        imgView.image = file.imageDisplay()
        lbTitle.text = file.title
        levelTraits.constant = CGFloat(12 + (file.level * 24))
    }
}
