//
//  PrintStoreCell.swift
//  FileMe
//
//  Created by Lê Dũng on 3/19/19.
//

import UIKit

class PrintStoreCell: UITableViewCell {
    @IBOutlet weak var lblLeft0: UILabel!
    @IBOutlet weak var lblLeft1: UILabel!
    @IBOutlet weak var lblLeft2: UILabel!

    @IBOutlet weak var lblRight0: UILabel!
    @IBOutlet weak var lblBottom0: UILabel!
    @IBOutlet weak var mainContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainContentView.drawDefaultRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataCell(_ value : PrintStore)
    {
        lblLeft0.attributedText = NSMutableAttributedString().boldLeft(value.name)
        lblLeft1.attributedText = NSMutableAttributedString().subLeft(String(format: "%@ %@ %@", value.address, value.province_name, value.district_name))
        lblLeft2.attributedText = NSMutableAttributedString().subLeft("0909.123.567")
        lblRight0.attributedText = NSMutableAttributedString().subRight("2km")
        lblBottom0.attributedText = NSMutableAttributedString().normalLeft("Giờ mở cửa: 9:00 - 20:00")
    }
    
}
