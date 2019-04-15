//
//  HistoryCell.swift
//  File Me
//
//  Created by Lê Dũng on 3/10/19.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var lblLeft0: UILabel!
    @IBOutlet weak var lblLeft1: UILabel!
    @IBOutlet weak var lblLeft2: UILabel!
    @IBOutlet weak var lblRight0: UILabel!
    @IBOutlet weak var lblRight1: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
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
    
    func setDataCell() {
        lblLeft0.attributedText = NSMutableAttributedString().boldLeft("Hồ sơ xin việc.docx")
        lblLeft1.attributedText = NSMutableAttributedString().subLeft("14/4/2019")
        lblLeft2.attributedText = NSMutableAttributedString().subLeft("Cửa hàng XXX")

        lblRight0.attributedText = NSMutableAttributedString().boldRight("$ 50k")
        lblRight1.attributedText = NSMutableAttributedString().subRight("Đã in")
    }
}
