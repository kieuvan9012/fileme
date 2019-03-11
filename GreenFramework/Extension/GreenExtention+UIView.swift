//
//  UIView+Extension.swift
//  LimeSoftware
//
//  Created by KieuVan on 10/11/16.
//  Copyright © 2016 KieuVan. All rights reserved.
//

import Foundation
import UIKit

enum AlertButton {
    case info
    case DB_Error
    



    func values() -> (name: String, value: Int)
    {
        switch self {
        case .info:
            return ("Cancel",0)
        case .DB_Error:
            return ("OK",1)
        case .DB_Error:
            return ("OK",1)
        }
    }
}




let AnyViewTag = 101


let ALERTBOXCONTAINERTAG =  9009
let ALERTBOXALPHATAG =  9001

public extension UIView
{
    func alertBox(_ targetView : UIView)
    {
        targetView.translatesAutoresizingMaskIntoConstraints = false;
        
        let containerView = UIView.init()
        containerView.tag = ALERTBOXCONTAINERTAG
        
        let alphaView = UIView.init()
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha = 0.48;
        addSubview(containerView)
        setLayout(containerView)
        

        containerView.addSubview(alphaView)
        containerView.setLayout(alphaView)

        containerView.addSubview(targetView)

        
        let xConstraint = NSLayoutConstraint(item: targetView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: targetView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)

        containerView.addConstraint(xConstraint)
        containerView.addConstraint(yConstraint)


    }
    
    func alertBox(_ targetView : UIView, ratio : CGFloat)
    {
        targetView.translatesAutoresizingMaskIntoConstraints = false;
        
        let containerView = UIView.init()
        containerView.tag = ALERTBOXCONTAINERTAG
        
        let alphaView = UIView.init()
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha = 0.48;
        addSubview(containerView)
        setLayout(containerView)
        
        
        containerView.addSubview(alphaView)
        containerView.setLayout(alphaView)
        
        containerView.addSubview(targetView)
        
        
        let xConstraint = NSLayoutConstraint(item: targetView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: targetView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
        
        
        let widthConstraint = NSLayoutConstraint(item: targetView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: ratio, constant: 0)

        containerView.addConstraint(widthConstraint)
        containerView.addConstraint(xConstraint)
        containerView.addConstraint(yConstraint)
        
        
    }

    
    func hideAlertBox()
    {
        let containerView = viewWithTag(ALERTBOXCONTAINERTAG)
        if(containerView != nil)
        {
            containerView?.removeFromSuperview()
        }
    }
}



public extension UIView
{
    func copyView<T: UIView>() -> T
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    public func addByView(_ view : UIView)
    {
        self.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(self)
    }
    
    public func addByViewWithlAutoSizing(_ view : UIView)
    {
        self.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        view.addSubview(self)
        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight,UIViewAutoresizing.flexibleLeftMargin,UIViewAutoresizing.flexibleRightMargin,UIViewAutoresizing.flexibleTopMargin,UIViewAutoresizing.flexibleBottomMargin ]
    }
    
    public func removeSubsView()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }

    func setY(y : CGFloat)
    {
        self.frame = CGRect.init(x: self.frame.origin.x, y: y, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func getY() ->CGFloat
    {
        return self.frame.origin.y
    }
    func getHeight() ->CGFloat
    {
        return self.frame.size.height
    }
    
    func setHeight(height : CGFloat)
    {
        self.frame.size.height = height
    }

    public func drawRound()
    {
        self.layer.cornerRadius = self.frame.size.width/2;
        self.clipsToBounds = true;
    }
    
    public func drawRadius(_ radius  : CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        self.clipsToBounds = true;
        self.layer.borderColor = UIColor.clear.cgColor
    }
    public func drawRadius(_ radius  : CGFloat, corners : CACornerMask )
    {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        self.clipsToBounds = true;
        
        self.layer.borderColor = UIColor.clear.cgColor
        
//        self.layer.maskedCorners =  corners
        
    }

    public func drawRadius(_ radius  : CGFloat,color : UIColor , thickness :CGFloat )  {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = thickness
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
    }
    
    
    
    public func addBorder(_ edges: UIRectEdge, color: UIColor, thickness: CGFloat = 0.5) -> [UIView]{
        var borders = [UIView]()
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
        
    }
    
    
    
    
    func verticalView(views : [UIView])
    {
        var targtIndex : Int = -1 ;
        for   i in  0..<views.count
        {
            let limeUnit  : UIView = views[i]
            
            
            print(self.bounds.width)

            self.addSubview(limeUnit)
            var previousXView : UIView!
            var targetView : UIView!
            
            if(i > 0)
            {
                previousXView   = views[i-1]
            }
            
            if(targtIndex != -1 )
            {
                targetView = views [targtIndex]
            }
            limeUnit.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0))
            
            self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0))
            if(i == 0 )
            {
                self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0))
            }
            else if (i == views.count - 1)
            {
                self.addConstraint(NSLayoutConstraint(item: limeUnit, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0))
                
                let verticalSpacing1 = NSLayoutConstraint(item: previousXView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: limeUnit, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([verticalSpacing1])
            }
                
            else
            {
                let verticalSpacing1 = NSLayoutConstraint(item: previousXView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: limeUnit, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([verticalSpacing1])
            }
            if(views.count == 1)
            {
                let widthContrain  = NSLayoutConstraint(item: limeUnit, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([widthContrain])
            }
            
            if(targtIndex != -1 )
            {
                let widthContrain  = NSLayoutConstraint(item: limeUnit, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: targetView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
                NSLayoutConstraint.activate([widthContrain])
                
            }
            if(targtIndex == -1 )
            {
                targtIndex = i ;
            }
            
            
            print(limeUnit.frame)

            
        }
    }
    
    
    func setLayout(_ view : UIView) // full layout for sub view
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0))
    }
    
    
    
    
        func dropShadow() {
            dropShadow(radius: 2, width: -1, height: -1, opacity: 0.12, shadowRadius : 2)
        }
    
    
    func dropShadow(radius : CGFloat , width : CGFloat, height : CGFloat ,opacity : CGFloat , shadowRadius : CGFloat) {
        
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = radius; // if you like rounded corners
        self.layer.shadowOffset = CGSize.init(width:width, height:height)
        self.layer.shadowRadius = shadowRadius;
        self.layer.shadowOpacity = Float(opacity);
        self.layer.shadowColor = UIColor.black.cgColor
    }

    func viewController() -> UIViewController? {
        var responder = self as? UIResponder
        while (responder != nil) {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }

    
}
extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = self.superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

