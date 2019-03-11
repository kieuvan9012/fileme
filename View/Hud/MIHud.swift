//
//  LDHub.swift
//  ReBook
//
//  Created by Lê Dũng on 9/14/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit


let MiHudReTag = 10071990
class MIHud: GreenView {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func initStyle() {
        self.tag = MiHudReTag
        super.initStyle()
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha = 0.5
        fillJsonLottie()
        animationView.drawRadius(6)
    }
    
    func fillJsonLottie()
    {
        indicator.startAnimating()
    }
    
    func setTitle(title : String?)
    {
        lbTitle.text = title ?? "Đang tải...";
    }
    
    @IBAction func testClose(_ sender: Any) {
        let ssString : NSString = ""
        ssString.hideWindowHud()
    }
}


extension NSObject
{
    func showWindowHud()
    {
        self.showHud(title: "", isWindow: true)
    }
    
    func showWindowHud(title : String)
    {
        self.showHud(title: title, isWindow: true)
    }

    
    func showHud()
    {
        self.showHud(title: nil, isWindow: false)
    }
    
    func showHud(title : String)
    {
        self.showHud(title: title, isWindow: false)
    }

   private func showHud(title : String?, isWindow : Bool)
    {
        let targetView : UIView!
        if(isWindow)
        {
            targetView = (UIApplication.shared.delegate as! AppDelegate).window
        }
        else
        {
            if(self is UIView)
            {
                targetView = self as! UIView;
            }
            else
            {
                targetView = (UIApplication.shared.delegate as! AppDelegate).window
            }
        }
        
        hideHud(window: isWindow)
        let hud = MIHud()
        targetView.addSubview(hud)
        targetView.setLayout(hud)
        targetView.bringSubview(toFront: hud)
        hud.alpha = 0.0
        UIView.animate(withDuration: 0.24) { () -> Void in
            hud.alpha = 1.0
        }
        hud.setTitle(title: title)
    }
    
    private func hideHud(window : Bool)
    {

        let targetView : UIView?
        if(window)
        {
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            targetView = window?.viewWithTag(MiHudReTag)
            if(targetView != nil)
            {
                if(!(targetView?.superview == window))
                {
                    return
                }
            }
        }
        else
        {
            if(self is UIView)
            {
                targetView = (self as! UIView);

            }
            else
            {
                return
                //targetView = (UIApplication.shared.delegate as! AppDelegate).window
            }
        }

        let hud = targetView?.viewWithTag(MiHudReTag)
        if(hud != nil)
        {
            UIView.animate(withDuration: 0.3, animations: {
                hud?.alpha = 0

            }, completion: { (valueD) in
                if(valueD)
                {
                    
                    hud?.removeFromSuperview()
                }
            })
        }
    }
    
    func hideHub()
    {
        hideHud(window: false)
    }
    
    func hideWindowHud()
    {
        hideHud(window: true)
    }
}
