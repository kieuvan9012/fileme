//
//  KVUnitButton20.swift
//  ERPSwift
//
//  Created by KieuVan on 7/12/16.
//  Copyright © 2016 KieuVan. All rights reserved.
//

import UIKit




open class GreenButtonCenter : GreenView {
    
    @IBOutlet fileprivate weak var button: UIButton!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var iconHeigh: NSLayoutConstraint!
    @IBOutlet fileprivate weak var iconWidth: NSLayoutConstraint!
    var completeHandle : ((_ button : GreenButtonCenter) -> Void)!
    open override func awakeFromNib() {
        setupView()
    }
    
    func setupView()
    {
        self.view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }

    func action()
    {
        self.completeHandle(self)
    }
    
    
   public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    @IBAction func touch(_ sender: Any)
    {
        if(self.completeHandle != nil)
        {
            self.completeHandle(self)
        }
    }
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    
    //Public Method--------------------------------------------
    
    open func setTarget(_ image : UIImage ,action :  @escaping ((GreenButtonCenter)-> Void))
    {
        self.completeHandle = action;
        imageView.image = image
    }
    
    open func setTarget(_ action :  @escaping ((GreenButtonCenter)-> Void))
    {
        self.completeHandle = action;
    }

    open func setSize(_ width : CGFloat, height : CGFloat)
    {
        iconWidth.constant = width;
        iconHeigh.constant = height
    }
    
    open func setImage(_ image : UIImage?)
    {
        imageView.image = image
    }
    open func settingButtonBackground(backgroundColor: UIColor, alpha: CGFloat) {
        button.backgroundColor = backgroundColor
        button.alpha = alpha
    }
    open func roundButton() {
        button.layer.cornerRadius = button.frame.size.height/2
    }
}
