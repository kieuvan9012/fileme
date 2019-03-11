//
//  GreenExtension+UIViewController.swift
//  Green
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import Foundation
import UIKit

public extension UIViewController
{
    public func registerDismissKeyboardWhenTouchScreen()
    {
        let tapGesture  = UITapGestureRecognizer.init(target: self, action: #selector(touched))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc fileprivate func touched()
    {
        view.endEditing(true)
    }
    
    
    
    func push(_ target : UIViewController)
    {
        
        let transition = CATransition()
        transition.duration = 0.24
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(target, animated: false)
    }
    
    func pop()
    {
        let transition = CATransition()
        transition.duration = 0.24
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)

    }
    
    func present(_ target : UIViewController,competion: @escaping (()->Void))
    {
        present(target, animated: false) {
            competion()
        }
    }
    
    func presentWithNavi(_ target : UIViewController,competion: @escaping (()->Void))
    {
        let navi = UINavigationController();
        navi.viewControllers = [target]
        present(navi) { () in
            competion()
        }
    }

    func endEdit()
    {
        view.endEditing(true)
    }
    func dismiss()
    {
        dismiss(animated: true) {
        }
    }
    
    

    
}
