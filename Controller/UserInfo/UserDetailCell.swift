//
//  UserDetailCell.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/3/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func set( _ item : UserDetailMenu )
    {
        lbName.text = item.name
    }
    
}
