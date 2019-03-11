//
//  UserImageView.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/20/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
import  AlamofireImage




class UserImageView: GreenView {

    @IBOutlet weak var imgView: UIImageView!
    
    override func initStyle() {
        
        self.drawRound()
        view.backgroundColor = template.primaryColor
        lbName.text = ""
    }
    
    @IBOutlet weak var lbName: UILabel!
    func set(_ name : String, url : String)
    {
        if(name.length > 0)
        {
            lbName.text = String(name.first!)
        }
        else
        {
            lbName.text = "M"
        }
        let  urlImage = URL.init(string: url)
        if(urlImage != nil)
        {
            imgView.setSD(url)
        }
        else
        {
            
        }
    }
    
    func setUser(_ user : User)
    {
        set(user.aliasname, url: user.avatar)
    }
    
    func setMedia(_ media : MediaFile)
    {
        imgView.setSD(media.path)
    }


}
