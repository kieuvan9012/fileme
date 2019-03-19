//
//  FileDropboxInstance.swift
//  FileMe
//
//  Created by trang.le on 3/18/19.
//

import UIKit
import SwiftyDropbox

let dropboxInstance = FileDropboxInstance.sharedInstance()

class FileDropboxInstance: NSObject {
    var clientDropbox: DropboxClient!
    var getMediaBlock : (([MediaFile])->Void)!

    static var instance: FileDropboxInstance!
    class func sharedInstance() -> FileDropboxInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? FileDropboxInstance())
            DropboxClientsManager.setupWithAppKey("tm7vfvtwq1v3lpe")
        }
        
        return self.instance
    }

    func connectDropbox(_ folderId: String, vc: UIViewController, success : @escaping (([MediaFile])->Void)) {
        self.getMediaBlock = success

        if let _ = DropboxClientsManager.authorizedClient {
            clientDropbox = DropboxClientsManager.authorizedClient
            self.loadData(folderId)
        } else {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: vc,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.canOpenURL(url)
            })
        }
    }
    
    public func sighOut() {
        DropboxClientsManager.unlinkClients()
    }

    func loadData(_ folderId: String) {
        let listFolders = DropboxClientsManager.authorizedClient!.files.listFolder(path: folderId)
        listFolders.response{ response, error in
            guard let result = response else{
                return
            }
            var lstData: [MediaFile] = []
            for data in result.entries { // convert data
                let media = MediaFile()
                media.name = data.name
                if(data is Files.FolderMetadata) {
                    media.fileType = .folder
                    media.fileExtension = "folder"
                    media.identifier = (data as! Files.FolderMetadata).id
                } else if (data is Files.FileMetadata) {
                    media.fileExtension = (data.name as NSString).pathExtension
                    media.size = Int((data as! Files.FileMetadata).size)
                    media.rev = (data as! Files.FileMetadata).rev
                }
                
                lstData.append(media)
            }

            self.getMediaBlock(lstData)
        }
    }

}
