//
//  MIStepView.swift
//  MTS
//
//  Created by Lê Dũng on 12/21/18.
//  Copyright © 2018 InnoTech. All rights reserved.
//

import UIKit

class MIStepView: GreenView , UITextFieldDelegate{
    
    @IBOutlet weak var btRight: UIButton!
    @IBOutlet weak var btLeft: UIButton!
    private var _list : [String] = []
    private var _value : String = ""
    private var _index  = -1
    
    override func initStyle() {
        layer.cornerRadius = 4
        layer.masksToBounds = true
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.backgroundColor = UIColor.white
        tfContent.delegate = self
    }
    
    var sucessBlock : ((String)->Void)!
    
    var selectedValue : String
    {
        set {
            _value = newValue
            updateValue()
        }
        get{
            return _value
        }
    }
    
    private func updateValue()
    {
        if(_value.isEmpty)
        {
            _index = -1
            return
        }
        tfContent.text = _value.uppercased()
        btRight.alpha = 1
        btLeft.alpha = 1
        if(_index == 0)
        {
            btLeft.alpha = 0.24
        }
        if(_index == (_list.count - 1 ))
        {
            btRight.alpha = 0.24
        }
    }
    
    @IBOutlet weak var tfContent: UITextField!
    
    @IBAction func leftTouch(_ sender: Any)
    {
        let tempIndex = _index - 1
        if(tempIndex < 0)
        {
            return
        }
        
        _index = tempIndex
        _value = _list[_index]
        sucessBlock(_list[_index])
        updateValue()
    }
    
    @IBAction func rightTouch(_ sender: Any)
    {
        let tempIndex = _index + 1
        if(tempIndex >= _list.count)
        {
            return
        }
        
        _index = tempIndex
        _value = _list[_index]
        sucessBlock(_list[_index])
        updateValue()
    }
    
    func set(_ data : [String] ,successBlock : @escaping ((String)->Void))
    {
        self.sucessBlock = successBlock
        _list.removeAll()
        _list.append(contentsOf: data)
        updateValue()
    }
    @IBAction func textFieldChange(_ sender: Any)
    {
        _value = tfContent.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tempText = tfContent.text?.uppercased()
        
        let tempIndex = _list.index{$0.uppercased() == tempText}
        if(tempIndex != nil)
        {
            _index = tempIndex!
            sucessBlock(_list[_index])
            updateValue()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func disable()
    {
        isUserInteractionEnabled = false
        alpha = 0.68
    }
    
    func enable()
    {
        isUserInteractionEnabled = true
        alpha = 1
    }
}

