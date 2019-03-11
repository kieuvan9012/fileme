//
//  RegisterViewController.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/11/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

import SwiftHash
protocol RegisterDelegate {
    func registerDidSuccess(_ username : String, password : String)
}

class RegisterViewController: MasterViewController {
    @IBOutlet weak var btBack: UIButton!
    
    var delegate : RegisterDelegate!
    
    @IBOutlet weak var passwordCFField: GreenInfoFieldSymbol!

    @IBOutlet weak var passwordField: GreenInfoFieldSymbol!
    @IBOutlet weak var usernameField: GreenInfoFieldSymbol!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.setLeft("GPhone".image().tint(UIColor.white))
        usernameField.keyboardType(.numberPad)
        
        
        passwordField.setLeft("GPassword".image().tint(UIColor.white))
        passwordCFField.setLeft("GPassword".image().tint(UIColor.white))

        usernameField.set(placeholder: "Số điện thoại")
        passwordField.set(placeholder: "Mật khẩu")
        passwordCFField.set(placeholder: "Nhập lại mật khẩu")
        
        passwordField.set(security: true)
        passwordCFField.set(security: true)

    }
    @IBAction func back(_ sender: Any) {
        self.pop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func regisTouch(_ sender: Any) {
        
        if(usernameField.content.trim().isEmpty)
        {
            showError("Số điện thoại không được để trống")
            return ;
        }
        if(usernameField.content.trim().length < 9)
        {
            showError("Số điện thoại phải lớn hơn 9 ký tự")
            return ;
        }

        if(passwordField.content.trim().isEmpty)
        {
            showError("Mật khẩu không được để trống")
            return ;
        }

        if(passwordField.content.length < 6)
        {
            showError("Mật khẩu phải lớn hơn hoặc bằng 6 ký tự.")
            return ;
        }

        if(passwordField.content != passwordCFField.content)
        {
            showError("Mật khẩu không trùng nhau")
            return ;
        }

        registerRequest()
        
    }
    
    
    func registerRequest()
    {
        let request = UserRegister_Request()
        request.username = usernameField.content.trim()
        request.password = MD5(passwordCFField.content)
        services.userRegister(request, success: { (response) in
            
            self.view.dialog(title: "Thông báo", desc: "Đăng ký thành công", type: .info, acceptBlock: {
                self.delegate.registerDidSuccess(request.username, password: self.passwordCFField.content)
                self.pop()

            }, cancelBlock: {
                
            })
            
        }) { (error) in
            
        }
    }
    
    func showError(_ error : String)
    {
        view.dialog(title: "Lỗi", desc: error, type: .warning, acceptBlock: {
            
        }) {
            
        }
    }
}
