//
//  MIStepNumberView.swift
//  MTS
//
//  Created by Lê Dũng on 12/22/18.
//  Copyright © 2018 InnoTech. All rights reserved.
//

import UIKit

protocol MIStepNumberViewDelegate : class
{
    func MIStepNumberViewWillEdit(_ sender : MIStepNumberView )
}

class MIStepNumberView: GreenView, UITextFieldDelegate {
    @IBOutlet weak var tfContent: UITextField!
    
    weak var delegate : MIStepNumberViewDelegate?
    private var _value : Double! = 0
    private var _min : Double!
    private var _max : Double!
    private var _step : Double = 1
    private var _formater : NumberFormatter = NumberFormatter.init()
    
    @IBOutlet weak var btRight: UIButton!
    @IBOutlet weak var btLeft: UIButton!
    private var _zeroToEmpty = false
    
    var zeroToEmpty : Bool!
    {
        set {
            _zeroToEmpty = newValue
            updateValue()
        }
        get{
            return _zeroToEmpty
        }
    }
    
    var value : Double!
    {
        set {
            _value = newValue
            updateValue()
        }
        get{
            return _value
        }
    }
    
    var step : Double
    {
        set {
            _step = newValue
            updateValue()
        }
        get{
            return _step
        }
    }
    
    func isEmpty() ->Bool
    {
        return (tfContent.text?.isEmpty)!
    }
    
    @IBAction func leftTouch(_ sender: Any)
    {
        if(value == nil)
        {
            return;
        }
        if (_min == nil)
        {
            _value = _value! - step
        }
        else if ((_value! - step) >= _min)
        {
            _value = _value! - step
        }
        
        updateValue()
    }
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    
    func setImage(_ left : UIImage, _ right : UIImage)
    {
        self.btLeft.setImage(left, for: .normal)
        self.btRight.setImage(right, for: .normal)

    }
    
    func setTextColor(_ color : UIColor)
    {
        tfContent.textColor = color
    }
    func setBackgroundColor(_ color : UIColor)
    {
        leftView.backgroundColor = color
        rightView.backgroundColor = color
        view.backgroundColor = color
        layer.borderColor = UIColor.clear.cgColor
    }
    @IBAction func rightTouch(_ sender: Any) {
        if(value == nil)
        {
            return;
        }
        
        if (_max == nil)
        {
            _value = _value! + step
        }
        else if ((_value! + step) <= _max)
        {
            _value = _value! + step
        }
        
        updateValue()
    }
    
    var min : Double
    {
        set {
            _min = newValue
            updateValue()
        }
        get{
            return _min
        }
    }
    
    var max : Double
    {
        set {
            _max = newValue
            updateValue()
        }
        get{
            return _max
        }
    }
    
    private func updateValue()
    {
        if(_value != nil)
        {
            tfContent.text = _formater.string(from: NSNumber.init(value: _value!))
            if(_value == 0)
            {
                if(zeroToEmpty)
                {
                    tfContent.text? = ""
                }
            }
        }
        else
        {
            tfContent.text = ""
        }
    }
    
    override func initStyle() {
        _formater.numberStyle = .decimal
        
        layer.cornerRadius = 4
        layer.masksToBounds = true
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.backgroundColor = UIColor.white
        
        tfContent.delegate = self
        tfContent.keyboardType = .numberPad
        tfContent.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        tfContent.delegate = self
        
        value = 0
        updateValue()
        
        tfContent.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        updateNumberValue()
    }
    
    @IBAction func textFieldChange(_ sender: Any)
    {
        updateNumberValue()
    }
    
    func updateNumberValue()
    {
        let number = _formater.number(from: tfContent.text!)
        if(number != nil)
        {
            _value = number!.doubleValue
        }
    }
    
    func setInputView(_ _view : UIView)
    {
        tfContent.inputView = _view
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(delegate != nil)
        {
            delegate?.MIStepNumberViewWillEdit(self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text!.isEmpty) {
            updateValue()
        }
    }
}
