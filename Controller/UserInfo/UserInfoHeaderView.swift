//
//  UserInfoHeaderView.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/3/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
import Gallery
import ALCameraViewController

class UserInfoHeaderView: GreenView {
    
    @IBOutlet weak var userImageView: UserImageView!
    var user : User!
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = true
    var allowResizing: Bool = true
    var allowMoving: Bool = false
    var minimumSize: CGSize = CGSize(width: 120 , height: 120)
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }

    @IBOutlet weak var lbName: UILabel!
    
    override func initStyle() {
        lbName.text = ""
    }

    
    @IBAction func avatarTouch(_ sender: Any)
    {
        callLibrary()
    }
    func callLibrary()
    {

        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] png, asset in
            if(png != nil)
            {
//                services.uploadMediaLowQuality(.info, images: [png!], success: { (response) in
//
//                    let mediaFilesResponse = MediaFile.list(data: response.data as! [Dictionary<String, Any>])
//                    if(mediaFilesResponse.count > 0)
//                    {
//                        let request = UserUpdateAvatar_Request()
//                        request.user_id = userInstance.user.id
//                        request.avatar = mediaFilesResponse[0].path
//                        services.userUpdateAvatar(request: request, success: {
//                            userInstance.user.avatar = mediaFilesResponse[0].path
//                            self?.userImageView.setUser(userInstance.user)
//                        }, failure: { (response) in
//                        })
//                    }
//
//                }, failure: { (error) in
//
//                }, progress: { (progres) in
//
//                })

            }
            self?.viewController()?.dismiss(animated: false, completion: nil)

        }
        viewController()?.present(libraryViewController, animated: false, completion: nil)
    }
    
    func set(_ user : User)
    {
        self.user = user
        lbName.text = user.aliasname
        userImageView.setUser(user)
    }
}
