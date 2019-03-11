//
//  InitInfoViewController.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/12/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
import Gallery
import FBSDKLoginKit
import FBSDKCoreKit
import ALCameraViewController
import Photos

class InitInfoViewController: MasterViewController, UITextFieldDelegate {

    
    
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = false
    var minimumSize: CGSize = CGSize(width: 120 , height: 120)
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }


    
    
    @IBOutlet weak var btNext: UIButton!
    @IBOutlet weak var avatarView: UIView!
    var image : ImageSelect!
    var fromFace = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.drawRound()
        registerDismissKeyboardWhenTouchScreen()
        btNext.drawRadius(4)
        btNext.backgroundColor = template.lendColor
        
        if(fromFace)
        {
            grapInfo()
        }
        
        tfName.attributedPlaceholder = NSAttributedString(string: "Nhập tên của bạn",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    /*
     let grap = FBSDKGraphRequest.init(graphPath: "me", parameters:  ["fields": "id, name, picture.type(large),cover,gender,birthday,user_location,user_gender"])

     */
    func grapInfo()
    {
        let currentToken = FBSDKAccessToken.current()
        if(currentToken == nil)
        {
            let fbLogin = FBSDKLoginManager.init()
            fbLogin.logIn(withReadPermissions: ["public_profile"], from: self) { (response, error) in
                self.grapRequest()
            }
        }
        else
        {
            self.grapRequest()
        }
    }
    
    func grapRequest()
    {
        let grap = FBSDKGraphRequest.init(graphPath: "me", parameters:  ["fields": "id, name, picture.type(large),birthday,gender"])
        
        _ = grap?.start(completionHandler: { (request, response, error) in
            let media = (response as! NSDictionary)
            let picture = (media.value(forKey: "picture") as! NSDictionary)
            let data  = (picture.value(forKey: "data") as! NSDictionary)
            let url  = (data.value(forKey: "url") as! String)
            self.imgAvatar.setSD(url)
            self.image = ImageSelect.init(url)
            self.image.imageURL = url
            self.tfName.text = (media.value(forKey: "name") as! String)
        })

    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    @IBAction func touchAva(_ sender: Any) {
        callLibrary()
    }
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var tfName: UITextField!
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
    }
    
    @IBAction func nextTouch(_ sender: Any)
    {
        if(self.image == nil)
        {
            view.dialog(title: "Lỗi", desc: "Vui lòng chọn ảnh đại diện", type: .warning, acceptBlock: {
            }) {
            }
            return
        }
        
        if(tfName.text?.trim().isEmpty)!
        {
            view.dialog(title: "Lỗi", desc: "Vui lòng nhập tên bạn", type: .warning, acceptBlock: {
            }) {
            }
            return
        }
    
        uploadImg()
    }
    
    func uploadImg()
    {
        if(self.image.image == nil)
        {
            updateUser();
            return;
        }
        
        view.showHud()
        services.uploadMedia(MediaBrand.info,images: [self.image.image], success: { (respone) in
            
            if(respone.data is Array<Any>)
            {
                let mediaFiles = MediaFile.list(data: respone.data as! [Dictionary<String, Any>])
                self.image = ImageSelect.init(mediaFiles[0].path)
                self.updateUser()
            }
        }, failure: { (error) in
            self.view.hideHub()

        }) { (progress) in
        }
    }
    
    
    func updateUser()
    {
        let request = UserUpdateAA_Request()
        request.user_id = userInstance.user.id
        request.aliasname = (tfName.text?.trim())!
        request.avatar = self.image.imageURL
        services.userUpdateAA(request: request, success: { (response) in
            userInstance.updateUser(response[0])
            app.home()
            self.view.hideHub()
        }) { (error) in
            self.view.hideHub()
        }
    }
    
    
    
    
    
    
    
    func callLibrary()
    {
        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
            if(image != nil)
            {
                self?.imgAvatar.image = image
                self?.image = ImageSelect.init(image!)
            }
            self?.dismiss(animated: false, completion: nil)
        }
        present(libraryViewController, animated: false, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfName.resignFirstResponder()
        return true
    }
    
    
    
}
