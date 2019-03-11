//
//  LoginViewController.swift
//  MiBook
//
//  Created by Lê Dũng on 7/10/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit
import SwiftHash
import FBSDKCoreKit
import FBSDKLoginKit
import SafariServices
class LoginViewController: MasterViewController,RegisterDelegate {

    @IBOutlet weak var passwordField: GreenInfoFieldSymbol!
    @IBOutlet weak var usernameField: GreenInfoFieldSymbol!

    @IBOutlet weak var btRegister: UIButton!
    @IBOutlet weak var btForgot: UIButton!
    @IBOutlet weak var btLogin: UIButton!
    var fbLogin = FBSDKLoginManager.init()

    @IBOutlet weak var btFace: UIButton!
    @IBAction func register(_ sender: Any) {
        
        let register = RegisterViewController()
        register.delegate = self;
        push(register)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        usernameField.setLeft("GPhone".image().tint(UIColor.white))
        usernameField.keyboardType(.numberPad)

        passwordField.setLeft("GPassword".image().tint(UIColor.white))
        
        usernameField.set(placeholder: "Số điện thoại")
        passwordField.set(placeholder: "Mật khẩu")
        
        usernameField.content = ""
        passwordField.content = ""
        
        
        passwordField.setSecurity(security: true)

        btLogin.setTitleColor(UIColor.white, for: .normal)
        btLogin.drawRadius(4)
        
        btRegister.backgroundColor = UIColor.clear
        
        view.backgroundColor = UIColor.white;
        
        usernameField.content = userInstance.getUsername()
        passwordField.content = userInstance.getPassword()
        
        btFace.drawRadius(4)
    }
 
    @IBAction func faceLoginTouch(_ sender: Any) {

        if(FBSDKAccessToken.currentAccessTokenIsActive())
        {
            FBSDKAccessToken.setCurrent(nil)
        }
        fbLogin.logIn(withReadPermissions: ["public_profile"], from: self) { (response, error) in
            if(error == nil)
            {
                if(response?.token != nil)
                {
                    self.loginFace((response?.token.userID)!)
                }
            }
        }

    }
    func loginFace(_ id : String){
        
        let request = UserLogin_Request()
        request.username = id
        services.userLoginFacebook(request, success: { (response) in
            if(response.count > 0)
            {
                userInstance.login(response[0])
                if(response[0].info_success)
                {
                    app.home()
                }
                else
                {
                    app.info()
                }
            }

        }) { (error) in
            
        }
    }

    @IBAction func login(_ sender: Any)
    {
        
        view.endEditing(true)
        if(usernameField.content.length == 0)
        {
            return ;
        }
        
        let user = User()
        self.view.showHud()
        user.username = usernameField.content.lowercased()
        user.password = passwordField.content
        

        let request = UserLogin_Request()
        request.username = user.username
        request.password = MD5(user.password)
        
        services.userLogin(request, success: { (response) in
            self.view.hideHub()
            
            if(response.count > 0)
            {
                userInstance.login(response[0])
                userInstance.setPassword(request.password)

                if(response[0].info_success)
                {
                    app.home()

                }
                else
                {
                    app.info()
                }
            }
            

        }) { (error) in
            self.view.dialogView(title: "Lỗ đăng nhập", desc: "Sai tên đăng nhập hoặc mật khẩu", type: .warning, acceptBlock: {
                
            }, cancelBlock: {
                
            })
            self.view.hideHub()

        }

    }
    
    func registerDidSuccess(_ username: String, password: String) {
        usernameField.content = username
        passwordField.content = password

    }
}
