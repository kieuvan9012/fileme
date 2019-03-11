//
//  HomeNaviView.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/18/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit





protocol HomeNaviViewDelegate
{
    func homeNaviViewActiveSearchEngine()
    func homeNaviViewDisableSearch()
    func homeNaviViewSearch(_ text : String)
    
}

class HomeNaviView: GreenView, UITextFieldDelegate
{
    
    var activeSearch = false
    @IBOutlet weak var lbTitle: UILabel!
    var delegate : HomeNaviViewDelegate!
    var right_0_block : (()->Void)!
    
    @IBOutlet weak var btSearch: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var btRight_0: UIButton!
    
    override func initStyle()
    {
        view.backgroundColor = template.naviColor
        tfSearch.delegate = self;
//        tfSearch.setValue("7ecff7".hexColor(), forKeyPath: "_placeholderLabel.textColor")
        tfSearch.setValue(template.subTextColor, forKeyPath: "_placeholderLabel.textColor")

    }

    @IBAction func right0Touch(_ sender: Any) {
        if((right_0_block) != nil)
        {
            right_0_block()
        }
    }
    
    
    
    func setRight_0(_ image : UIImage, touchIn : @escaping (()->Void))
    {
        right_0_block = touchIn
        btRight_0.setImage(image, for: .normal)
        btRight_0.isHidden = false
    }
    func disableRight()
    {
        btRight_0.isHidden = true;
    }
    
    
    @IBAction func searchTouchIn(_ sender: Any) {
        
        if(activeSearch)
        {
            normalStyle()
            tfSearch.resignFirstResponder()
        }
        else
        {
            tfSearch.becomeFirstResponder()
            searchStyle()
        }
    }

    @IBAction func tfChange(_ sender: Any) {
        delegate.homeNaviViewSearch((tfSearch.text?.trim())!)
    }
    
    
    func searchStyle()
    {
        activeSearch = true ;
        btSearch.setImage("DefaultBack".image(), for: .normal)
        
        btRight_0.isHidden = true;
        
    }
    
    func normalStyle()
    {
        btSearch.setImage("search".image(), for: .normal)
        activeSearch = false ;
        tfSearch.text = ""
        btRight_0.isHidden = false;

    }
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        delegate.homeNaviViewDisableSearch()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchStyle()
        delegate.homeNaviViewActiveSearchEngine()
    }
    
    
    
}
