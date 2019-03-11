//
//  ImageDisplayView.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/15/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class ImageDisplayView: GreenView {
    @IBOutlet weak var imgView: UIImageView!
    
    var mediaFiles : [MediaFile] = []
    
    func set(_ images : [MediaFile])
    {
        self.mediaFiles.removeAll()
        self.mediaFiles.append(contentsOf: images)
        if(images.count > 0)
        {
        }
    }
    
    @IBAction func touchIn(_ sender: Any)
    {
    }

}
