//
//  ListDataGGDriveTableViewCell.swift
//  FileMe
//
//  Created by trang.le on 3/13/19.
//

import UIKit
import GoogleAPIClientForREST

class ListDataGGDriveTableViewCell: UITableViewCell {
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.text = ""
        lblSubTitle.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func processFileData(_ file: GTLRDrive_File) {
        var fileExtension = ""
        var fileSize = ""
        var imageName = ""

        if(ConfigGoogleDrive.isFolder(file)) {
            fileExtension = "Folder"
            imageName = "folder"
            btnDownload.hidden()
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
            btnDownload.show()
            
            if(file.fileExtension != nil && !(file.fileExtension?.isEmpty)!) {
                imageName = file.fileExtension!
            } else {
                imageName = "file"
            }
            
            if (file.size != nil) {
                fileSize = ByteCountFormatter.string(fromByteCount: (file.size?.int64Value)!, countStyle: .file)
            }
            
            if (file.fileExtension != nil) {
                fileExtension = file.fileExtension!
            }
        }
        
        let image = UIImage.init(named: imageName)
        imgType.image = image ?? "file".image()
        lblTitle.text = file.name
        lblSubTitle.text = fileExtension.isEmpty ? fileSize : fileExtension + "  " + fileSize
    }
}

class ConfigGoogleDrive: NSObject {
    class func isFolder(_ file: GTLRDrive_File) -> Bool {
        if(file.fileExtension == nil && file.mimeType  == "application/vnd.google-apps.folder") {
            return true
        }
        return false
    }
}
