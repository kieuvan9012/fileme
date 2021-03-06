//
//  GreenView.swift
//  GFramework
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

extension UIView
{
    func setGreenLayout(_ view : UIView) // full layout for sub view
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
    }

}

open  class GreenView: UIView
{

    @IBOutlet  open  var view: UIView!
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
        self.setGreenLayout(view)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    initStyle()

    }
    
    open  func initStyle()
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
