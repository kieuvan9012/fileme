//
//  UserCell.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/18/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var statusCell: UIView!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusCell.isHidden = true ;
        statusCell.drawRound()
        statusCell.backgroundColor = template.highlightTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(_ user : User)
    {
        lbName.text = user.aliasname        
        user.isOnline ? setOnline() : setOffline();
    }
    
    func setOnline()
    {
        statusCell.isHidden = false ;
    }
    
    func setOffline()
    {
        statusCell.isHidden = true ;

    }
    
}
