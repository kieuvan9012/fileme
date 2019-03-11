//
//  GreenTableView.swift
//  GFramework
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit


class GreenTableViewCell: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}


 class GreenTableView: UITableView {
    
    
    

    func initStyle()
    {
        self.backgroundColor = UIColor.clear
    }
    
    override  func awakeFromNib() {
        initStyle()
        separatorStyle = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initStyle()
    }
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    
        initStyle()
    }
    public convenience init()
    {
        self.init(frame: CGRect.init())
    }

}
