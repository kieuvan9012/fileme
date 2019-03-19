//
//  ListDataFileTableViewCell.swift
//  FileMe
//
//  Created by trang.le on 3/13/19.
//

import UIKit
import GoogleAPIClientForREST
import SwiftyDropbox

class ListDataFileTableViewCell: UITableViewCell {
    @IBOutlet weak var imgFileType: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgDownload: UIImageView!
    
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
    
//    func processDropboxFileData(_ file: Files.Metadata) {
//        var fileSize = ""
//        var fileType = ""
//        
//        self.accessoryType = .none
//        self.imgDownload.showView()
//        
//        lblTitle.text = file.name
//        if(file is Files.FolderMetadata) {
//            self.accessoryType = .disclosureIndicator
//            imgDownload.hiddenView()
//            fileType = "folder"
//            
//        } else {
//            fileSize = ByteCountFormatter.string(fromByteCount: Int64((file as! Files.FileMetadata).size), countStyle: .file)
//            fileType = (file.name as NSString).pathExtension // URL path của String k detect dc .pdf và .txt
//        }
//        
//        if(fileType.isEmpty) {
//            fileType = "file"
//        }
//        
//        if(!ConfigFileType.isSupportFile(fileType)) {
//            imgDownload.hiddenView()
//        }
//        
//        let image = UIImage.init(named: fileType)
//        imgFileType.image = image ?? "file".image()
//        lblSubTitle.text = fileType == "folder" ? fileType : fileType + "  " + fileSize
//    }
    
    func processGGDriveFileData(_ file: MediaFile) {
        var fileSize = ""
        let fileType = file.fileExtension
        
        self.accessoryType = .none
        imgDownload.showView()
        
        if(file.fileType == .folder) {
            imgDownload.hiddenView()
            self.accessoryType = .disclosureIndicator
        } else {
            fileSize = ByteCountFormatter.string(fromByteCount: Int64(file.size), countStyle: .file)
        }
        
        if(!ConfigFileType.isSupportFile(fileType)) {
            imgDownload.hiddenView()
        }
        
        let image = UIImage.init(named: fileType)
        imgFileType.image = image ?? "file".image()
        lblTitle.text = file.name
        lblSubTitle.text = fileType == "folder" ? fileType : fileType + "  " + fileSize
    }
}

class ConfigFileType: NSObject {
    static let lstFileSupport = ["doc", "docx", "docm", "dotx", "dotm", "docb",
                                 "xls", "xlsb", "xlsm", "xlsx",
                                 "sldx", "pptx", "pptm", "potx", "potm", "ppam", "ppsx", "ppsm",
                                 "png", "jpg", "jpeg",
                                 "txt", "pdf", "folder"]
    
    class func isFolderGGDrive(_ fileExtension: String?, mimeType: String) -> Bool {
        if(fileExtension == nil && mimeType  == "application/vnd.google-apps.folder") {
            return true
        }
        return false
    }
    
    class func isSupportFile(_ val: String?) -> Bool {
        if(lstFileSupport.contains(val ?? "")) {
            return true
        }
        return false
    }
}
