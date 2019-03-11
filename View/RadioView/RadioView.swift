//
//  RadioView.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/25/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
protocol RadioViewDelegate {
    func radioChangeState(_ value : Bool, sender : RadioView)
}

class RadioView: GreenView {

    var checkImg = "ButtonCheck".image()
    var unCheckUmg = "ButtonUncheck".image()
    @IBOutlet weak var lbTitle: UILabel!
    var delegate : RadioViewDelegate!
    @IBOutlet weak var imgCheck: UIImageView!
    
    var isCheck = false

    override func initStyle() {
        view.backgroundColor = UIColor.white

    }
    
    
    func font(_ value : UIFont)
    {
        lbTitle.font = value
    }
    
    func set(_ _imgCheck : UIImage, _imgUncheck : UIImage)
    {
        self.checkImg = _imgCheck
        self.unCheckUmg = _imgUncheck
    }
    
    
    func set(_ isCheck : Bool, _ title : String)
    {
        self.isCheck = isCheck
        lbTitle.text = title;
        style()
    }
    func style()
    {
        if(isCheck)
        {
            imgCheck.image = checkImg
            lbTitle.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else
        {
            imgCheck.image = unCheckUmg
            lbTitle.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    func uncheck()
    {
        self.isCheck = false
        style()
    }
    
    func check()
    {
        self.isCheck = true
        style()
    }
    
    @IBAction func touch(_ sender: Any)
    {
        isCheck = !self.isCheck
        style()
        if(delegate != nil)
        {
            delegate.radioChangeState(self.isCheck, sender: self)
        }
    }
    
}
