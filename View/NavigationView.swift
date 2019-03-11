//
//  NavigationView.swift
//  MiBook
//
//  Created by Lê Dũng on 7/10/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit



enum NavigationStyle : String
{
    case menu = "GMenu"
    case back = "GBack"
    case custom = ""
}


protocol NavigationViewDelegate :  class
{
    func navigationViewClearTouch()
    func navigationViewSearching(_ searchText : String)
}




class NavigationView: GreenView , UITextFieldDelegate{
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftBt: GreenButtonCenter!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btRight: UIButton!

    @IBOutlet weak var heightStatus: NSLayoutConstraint!
    @IBOutlet weak var tfSearcg: UITextField!
    @IBOutlet weak var wSearch: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    weak var delegate : NavigationViewDelegate?
    var completion : (()->Void)!

    @IBAction func rightTouch(_ sender: Any) {
        delegate?.navigationViewClearTouch()
    }
    override func initStyle()
    {
        statusView.backgroundColor =  template.primaryColor
        contentView.backgroundColor = template.primaryColor
        wSearch.constant = 0 ;
        searchView.isHidden = true
        tfSearcg.delegate = self;
        
        lbTitle.textColor = .white;
        
        shadowView.dropShadow(radius: 1, width: 1, height: 1, opacity: 0.12, shadowRadius: 1)
        lbTitle.textColor = .white;
        tfSearcg.textColor = UIColor.white
        tfSearcg.textAlignment = .left
        
        if(device.isRStatusBar())
        {
            heightStatus.constant = 40 ;
        }

    }
    @IBAction func backTouch(_ sender: Any) {
        self.completion()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 64)
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    
    func set(style : NavigationStyle, title : String, completion : @escaping (()->Void))
    {
        self.completion = completion
        lbTitle.text = title.capitalized;
    }
    func setTitle(_ value : String)
    {
        lbTitle.text = value
    }
    
    func enableSearch (_ isEnable : Bool)
    {
        if(isEnable)
        {
            wSearch.constant = 44
            searchView.isHidden = false
            lbTitle.isHidden = true

        }
        else
        {
            wSearch.constant = 0
            searchView.isHidden = true
            lbTitle.isHidden = false
        }
        
        searchView.isHidden = !isEnable
    }
    
    func focus()
    {
        tfSearcg.becomeFirstResponder()
    }
    
    func setSearchPlaholder( _ text : String)
    {
        tfSearcg.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
    
    @IBOutlet weak var shadowView: UIView!
    @IBAction func editingChange(_ sender: Any)
    {
        self.delegate?.navigationViewSearching(tfSearcg.text!)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    func dissmissSearch()
    {
        tfSearcg.resignFirstResponder()
    }
    
}
