//
//  MIDropListCell.swift
//  MTS
//
//  Created by Lê Dũng on 12/18/18.
//  Copyright © 2018 InnoTech. All rights reserved.
//

import UIKit

class MIDropListCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(_ value : String)
    {
        lbTitle.text = value
    }
    
}
