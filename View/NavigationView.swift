//
//  NavigationView.swift
//  MiBook
//
//  Created by Lê Dũng on 7/10/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit

let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
let IS_RETINA           = UIScreen.main.scale >= 2.0

let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )

let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
let IS_IPHONE_XR        = IS_IPHONE && SCREEN_MAX_LENGTH == 896
let IS_IPHONE_XR_MAX    = IS_IPHONE && SCREEN_MAX_LENGTH == 896
let IS_RABIT            = IS_IPHONE && (IS_IPHONE_X || IS_IPHONE_XR)

func IS_PORTRAIT()->Bool {
    return UIDevice.current.orientation.isPortrait
}

func IS_LANDSCAPE()->Bool {
    return UIDevice.current.orientation.isLandscape
}

enum NavigationStyle : String
{
    case menu = "GMenu"
    case back = "GBack"
    case none = "GNone"
}

protocol NavigationViewDelegate
{
}

class NavigationView: GreenView , UITextFieldDelegate{
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftBt: GreenButtonCenter!
    @IBOutlet weak var lbTitle: UILabel!
    
    var delegate : NavigationViewDelegate!
    var completion : (()->Void)!
    var rightBlock : (()->Void)!
    
    @IBOutlet weak var heightContent: NSLayoutConstraint!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightButton: GreenButtonCenter!
    @IBOutlet weak var heightStatusBar: NSLayoutConstraint!
    @IBOutlet weak var heightNavi: NSLayoutConstraint!
    
    override func initStyle()
    {
        if(IS_LANDSCAPE()) {
            heightStatusBar.constant = 0
        } else {
            heightStatusBar.constant = 20
            if(IS_RABIT)
            {
                heightStatusBar.constant = 40
            }
        }
        
        statusView.backgroundColor = template.primaryColor
        contentView.backgroundColor = template.primaryColor
        lbTitle.textColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @IBAction func rightTouch(_ sender: Any)
    {
        self.rightBlock()
    }
    
    @IBAction func leftTouch(_ sender: Any)
    {
        self.completion()
    }
    
    func set(style : NavigationStyle, title : String?, completion : @escaping (()->Void))
    {
        if(IS_IPAD) {
            self.heightStatusBar.constant = 0
        }
        
        self.completion = completion
        var image  : UIImage!
        switch style
        {
        case .menu : image = "Default_Menu_White".image()
        if(IS_IPAD)
        {
            self.leftView.isHidden = true
        }
            break
        case .back :image = "Default_Back_White".image()
            break
        case .none:
            self.leftView.isHidden = true
        }
        
        leftImage.image = image
        lbTitle.text = title
        
        rightView.isHidden = true
    }
    
    @objc func setStyle( title : String?, completion : @escaping (()->Void))
    {
        if(IS_IPAD) {
            self.heightStatusBar.constant = 0
        }
        self.completion = completion
        let  image   =  "Default_Back_White".image()
        leftImage.image = image
        lbTitle.text = title;
        lbTitle.font = UIFont.boldSystemFont(ofSize: 15)
        rightView.isHidden = true ;
    }
    
    @objc func setContentHeight(_ value : CGFloat)
    {
        self.heightContent.constant = value
    }
    
    @objc func hidenNavi()
    {
        self.heightStatusBar.constant = 0
        self.heightContent.constant = 0
    }
    
    @objc func setStatusHeight(_ value : CGFloat)
    {
        self.heightStatusBar.constant = value
    }
    
    func setTitle(_ value : String)
    {
        self.lbTitle.text = value;
    }
    
    @objc public func setRight(_ image : UIImage, touch : @escaping (()->Void))
    {
        self.rightImage.image = image
        self.rightBlock = touch
        hidenRightView(false)
    }
    
    func hidenRightView(_ isHiden : Bool)
    {
        self.rightView.isHidden = isHiden
    }
    
    @objc func rotated() {
        if IS_LANDSCAPE() {
            self.heightStatusBar.constant = 0
        }
        
        if IS_PORTRAIT()  {
            if(IS_IPHONE) {
                self.heightStatusBar.constant = 20
                if(IS_RABIT)
                {
                    heightStatusBar.constant = 40
                }
            }
        }
    }
}
