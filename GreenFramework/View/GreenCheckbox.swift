//
//  KVUnitCheckBox.swift
//  ERPSwift
//
//  Created by KieuVan on 7/10/16.
//  Copyright © 2016 KieuVan. All rights reserved.
//

import UIKit


open class GreenCheckbox: GreenView
{
    var imgCheck : UIImage!
    var imgUncheck : UIImage!
    var actionHandle : ((Bool) -> Void)!
    open var isCheck : Bool = false

    @IBOutlet weak var btCheck: UIButton!
    @IBOutlet weak var img: UIImageView!

    
    @IBAction func checkAction(_ sender: AnyObject)
    {
        isCheck = !isCheck
        update()
        if(self.actionHandle != nil)
        {
            self.actionHandle(isCheck)
        }
    }
    
    override open func initStyle()
    {
//            imgCheck = greenDefine.GreenCheckBox_ImageCheck
//            imgUncheck = greenDefine.GreenCheckBox_ImageUncheck;
//            update();
    }

    func update()
    {
        if(isCheck)
        {
            img.image = imgCheck;
        }
        else
        {
            img.image = imgUncheck
        }
    }
    @IBOutlet weak var widthCtr: NSLayoutConstraint!
    
    open override func awakeFromNib()
    {
        super.awakeFromNib()
//        self.view.backgroundColor = UIColor.clear
//        self.backgroundColor = UIColor.clear
//        self.img.backgroundColor = UIColor.clear
//        self.btCheck.backgroundColor = UIColor.clear
        initStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initStyle()
    }
    
    @IBOutlet weak var heightCtr: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initStyle()

    }
    
    //Public Method-----------------------------------------------------------------------
    open func setCheck(_ check : Bool)
    {
        isCheck = check;
        update();
    }
    
    open func setCheck(_ check : Bool, action :  @escaping ((Bool)-> Void))
    {
        isCheck = check;
        update();
        self.actionHandle = action ;
    }
    
    open func setImage(_ imageCheck : UIImage, imageUncheck : UIImage)
    {
        
        imgCheck = imageCheck;
        imgUncheck = imageUncheck;
        update();
    }

    open func setImageSize(_ width : Float, height : Float)
    {
        if height != 0.0 {
            widthCtr.constant = CGFloat(height)
            heightCtr.constant = CGFloat(height)
        }
       
    }
}
