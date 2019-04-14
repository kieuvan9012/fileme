//
//  MIDialog.swift
//  MTS
//
//  Created by Lê Dũng on 12/13/18.
//  Copyright © 2018 InnoTech. All rights reserved.
//

import UIKit

fileprivate let MIACTIONSHEETTAG  = 9887

extension UIView
{
    fileprivate func ownerViewController() -> UIViewController? {
        var responder = self as? UIResponder
        while (responder != nil) {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
    
    func actionSheet(_ title : String, _ des : Any,action : [Any],complete : @escaping ((Int)->Void))
    {
        let _  = MIActionSheet.init(title, des, action: action) { (response) in
            complete(response)
        }
    }
    
}

class MIActionSheetUnitView: UIView
{
    @IBOutlet open var view: UIView!
    
    func classNameAsString(_ obj: Any) -> String
    {
        return String(describing: type(of: (obj as AnyObject))).replacingOccurrences(of:"", with:".Type")
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        view.frame = bounds
        addSubview(view)
        self.miActionSheetLayout(view)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initStyle()
    }
    
    open func initStyle()
    {
        
    }
    open  func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:self.classNameAsString(self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public  override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        initStyle()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        xibSetup()
    }
}

fileprivate let infoTitle_vi = "THÔNG BÁO"
fileprivate let errorTitle_vi = "LỖI"

fileprivate let Close_vi = "Đóng"
fileprivate let Close_en = "Close"

fileprivate let infoTitle_en = "MESSAGE"
fileprivate let errorTitle_en = "ERROR"

fileprivate let Accept_vi = "Đồng Ý"
fileprivate let Accept_en = "Accept"

fileprivate let Cancel_vi = "Huỷ"
fileprivate let Cancel_en = "Cancel"

class MIActionSheet: MIActionSheetUnitView, MIActionSheetUnitActionViewDelegate {
    fileprivate class func infoTitle()->String
    {
        let langue = Locale.preferredLanguages[0]
        switch langue {
        case "vi":  return infoTitle_vi ;
        case "en":  return infoTitle_en ;
        default: return infoTitle_en
        }
    }
    
    fileprivate class func errorTitle()->String
    {
        let langue = Locale.preferredLanguages[0]
        switch langue {
        case "vi":  return errorTitle_vi ;
        case "en":  return errorTitle_en ;
        default: return errorTitle_en
        }
    }
    
    fileprivate class func closeTitle()->String
    {
        let langue = Locale.preferredLanguages[0]
        switch langue {
        case "vi":  return Close_vi ;
        case "en":  return Close_en ;
        default: return Close_en
        }
    }
    
    fileprivate class func acceptTitle()->String
    {
        let langue = Locale.preferredLanguages[0]
        switch langue {
        case "vi":  return Accept_vi ;
        case "en":  return Accept_en ;
        default: return Close_en
        }
    }
    
    fileprivate class func CancelTitle()->String
    {
        let langue = Locale.preferredLanguages[0]
        switch langue {
        case "vi":  return Cancel_vi ;
        case "en":  return Cancel_en ;
        default: return Cancel_en
        }
    }
    
    func MIDialogUnitActionViewTouchValue(_ val: String) {
        if(valueCompleteBlock == nil) {
            return
        }

        self.valueCompleteBlock(val)
        hideMiDialog()
    }
    
    func MIDialogUnitActionViewTouch(_ index: Int) {
        if(completeBlock == nil) {
            return
        }
        self.completeBlock(index)
        hideMiDialog()
    }
    
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var heightLB: NSLayoutConstraint!
    var completeBlock : ((Int)->Void)!
    var valueCompleteBlock : ((String)->Void)!
    
    @IBOutlet weak var stackView: UIStackView!
    override func initStyle() {
        contentView.layer.masksToBounds = true
        contentView.drawRadius(6)
        btnCancel.drawRadius(6)
        
        lbTitle.text = ""
        lbDescription.text = ""
        tag = MIACTIONSHEETTAG
    }
    
    init(_ title : String, _ des : Any ,action : [Any], actionBlockValue : @escaping ((String)->Void)) // trả về value
    {
        super.init(frame: CGRect.zero)
        
        if(title.trim().length  == 0)
        {
            heightLB.constant = 0
        }
        
        if(des is NSAttributedString)
        {
            lbDescription.attributedText = des as? NSAttributedString
        }
        
        if(des is NSAttributedString)
        {
            lbDescription.attributedText = des as? NSAttributedString
        }
        else if (des is String)
        {
            lbDescription.text = (des as! String)
        }
        
        lbTitle.text = title
        
        self.valueCompleteBlock = actionBlockValue
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        var i = 0
        for item in action
        {
            let def = MIActionSheetUnitActionView.init(frame: CGRect.init())
            stackView.addArrangedSubview(def)
            def.setObject(item)
            def.index = i
            def.delegate = self
            i = i + 1
        }
        
        //
        //        let closeButton = MIActionSheetUnitActionView.init(frame: CGRect.init())
        //        stackView.addArrangedSubview(closeButton)
        //        closeButton.index = -1
        //        closeButton.delegate = self
        //        closeButton.setBackground(.black)
        //        closeButton.setTitle(MIActionSheet.closeTitle())
        
        showDialog()
    }
    
    init(_ title : String, _ des : Any ,action : [Any], actionBlock : @escaping ((Int)->Void))
    {
        super.init(frame: CGRect.zero)
        
        if(title.trim().length  == 0)
        {
            heightLB.constant = 0
        }
        
        if(des is NSAttributedString)
        {
            lbDescription.attributedText = des as? NSAttributedString
        }
        
        if(des is NSAttributedString)
        {
            lbDescription.attributedText = des as? NSAttributedString
        }
        else if (des is String)
        {
            lbDescription.text = (des as! String)
        }
        
        lbTitle.text = title
        
        self.completeBlock = actionBlock
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        var i = 0
        for item in action
        {
            let def = MIActionSheetUnitActionView.init(frame: CGRect.init())
            stackView.addArrangedSubview(def)
            def.setObject(item)
            def.index = i
            def.delegate = self
            i = i + 1
        }
        
        //
        //        let closeButton = MIActionSheetUnitActionView.init(frame: CGRect.init())
        //        stackView.addArrangedSubview(closeButton)
        //        closeButton.index = -1
        //        closeButton.delegate = self
        //        closeButton.setBackground(.black)
        //        closeButton.setTitle(MIActionSheet.closeTitle())
        
        showDialog()
    }
    
    @IBAction func closeViewTouch(_ sender: Any) {
        if(completeBlock != nil) {
            self.completeBlock(-1)
        }
        if(valueCompleteBlock != nil) {
            self.valueCompleteBlock("")
        }
        self.hideMiDialog()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func hideMiDialog()
    {
        let app = UIApplication.shared.keyWindow!
        let containerView = app.viewWithTag(MIACTIONSHEETTAG)
        if(containerView != nil)
        {
            UIView.animate(withDuration: 0.32, animations: {
                containerView?.alpha = 0
            }) { _ in
                containerView?.removeFromSuperview()
            }
        }
    }
    
    fileprivate func  showDialog()
    {
        let app = UIApplication.shared.delegate!.window!
        app!.addSubview(self)
        app!.miActionSheetLayout(self)
        self.alpha = 0;
        
        UIView.animate(withDuration: 0.32) {
            self.alpha = 1
        }
    }
}

protocol MIActionSheetUnitActionViewDelegate : class{
    func MIDialogUnitActionViewTouch(_ index : Int)
    func MIDialogUnitActionViewTouchValue(_ value : String)
    
}

fileprivate class MIActionSheetUnitActionView: GreenView {
    @IBOutlet weak var rightLine: UIView!
    
    weak var delegate : MIActionSheetUnitActionViewDelegate?
    @IBOutlet weak var btDef: UIButton!
    var index  = -1
    
    @IBAction func touchIn(_ sender: Any) {
        delegate?.MIDialogUnitActionViewTouch(index)
        delegate?.MIDialogUnitActionViewTouchValue(btDef.titleLabel!.text!)
    }
    
    fileprivate override func initStyle() {
        btDef.layer.borderWidth = 0
        btDef.layer.masksToBounds = true
        //        btDef.setTitleColor(.white, for: [.normal,.highlighted])
    }
    
    fileprivate func setTitle(_ value : String)
    {
        btDef.setTitle(value, for: .normal)
    }
    fileprivate func setFont(_ value : UIFont)
    {
        btDef.titleLabel?.font = value
    }
    fileprivate func setColor(_ value : UIColor)
    {
        btDef.setTitleColor(value, for: .normal)
    }
    
    fileprivate func setBackground(_ value : UIColor)
    {
        btDef.backgroundColor = value
    }
    
    fileprivate func setEnable(_ value : Bool)
    {
        btDef.isEnabled = value
    }
    
    func setObject( _ value : Any)
    {
        if(value is String)
        {
            setTitle(value as! String)
        }
        else
        {
            let mirrow = Mirror(reflecting: value)
            if(mirrow.children.count > 0)
            {
                for item in mirrow.children
                {
                    if(item.value is String)
                    {
                        setTitle(item.value as! String)
                    }
                    else if (item.value is UIColor)
                    {
                        setBackground(item.value as! UIColor)
//                        btDef.setBackgroundColor(item.value as! UIColor)
                    }
                    else if (item.value is UIFont)
                    {
                        setFont(item.value as! UIFont)
                    } else if (item.value is Bool)
                    {
                        setEnable(item.value as! Bool)
                    }
                }
            }
        }
    }
}

fileprivate extension UIView
{
    fileprivate func miActionSheetLayout (_ view : UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
    }
}
