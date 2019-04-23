//
//  FileGoogleDriveInstance.swift
//  FileMe
//
//  Created by trang.le on 3/18/19.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

let ggDriveInstance = FileGoogleDriveInstance.sharedInstance()

class FileGoogleDriveInstance: NSObject {
    private let kClientID = "47587196428-3svqb2ftjaj77e79r9f9argeosgd8qvc.apps.googleusercontent.com"
    
    var serviceGGDrive = GTLRDriveService()
    var fetcher: GTMSessionFetcher! = GTMSessionFetcher()
    var getMediaBlock : (([MediaFile])->Void)!
    private var getSuccessDownBlock : ((Float, Data?, String?)->Void)!
    
    static var instance: FileGoogleDriveInstance!
    class func sharedInstance() -> FileGoogleDriveInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? FileGoogleDriveInstance())
            instance.setUpGoogle()
        }
        
        return self.instance
    }
    
    private func setUpGoogle() {
        GIDSignIn.sharedInstance().clientID = kClientID
    }
    
    func connectGGDrive(_ folderId: String, success : @escaping (([MediaFile])->Void)) {
        self.getMediaBlock = success
        
        self.loadListData(folderId)
    }
    
    public func signOut() {
        serviceGGDrive = GTLRDriveService()
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func cancelDownload() {
        self.fetcher.stopFetching()
    }
    
    func downloadFile(_ fileData: MediaFile, success: @escaping ((Float, Data?, String?)-> Void)) {
        self.getSuccessDownBlock = success
        
        // start config download
        if(self.fetcher.isFetching) {
            self.fetcher.stopFetching()
        }
        
        var downloadRequest: URLRequest
        if (fileData.fileExtension == nil) {
            // Google Spread Sheet like googles own format can be downloaded via this query
            // https://developers.google.com/drive/v3/web/manage-downloads
            let query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId: fileData.identifier, mimeType: "application/pdf")
            downloadRequest = self.serviceGGDrive.request(for: query) as URLRequest
        } else {
            let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileData.identifier)
            downloadRequest = self.serviceGGDrive.request(for: query) as URLRequest
        }
        
        self.fetcher = self.serviceGGDrive.fetcherService.fetcher(with: downloadRequest)
        
        // Progress
        self.fetcher.receivedProgressBlock = { bytesWritten, totalBytesWritten in
            let progress = Float(totalBytesWritten) / Float(fileData.size)
            print("progressData:", progress)
            
            self.getSuccessDownBlock(progress, nil, nil)
        }
        
        self.fetcher.beginFetch(completionHandler: { (data, fetchError) in
            if fetchError == nil {
                self.getSuccessDownBlock(1, data, nil)
            } else {
                self.getSuccessDownBlock(0, nil, fetchError.debugDescription)
            }
        })
        
        // cách download khác - k có progress
        
        //        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileData.identifier!)
        //        serviceGGDrive.executeQuery(query) { (ticket, file , error) in
        //            if (error == nil) {
        //                print(ticket)
        //                print(error as Any)
        //                print((file as! GTLRDataObject))
        //                print((file as! GTLRDataObject).data)
        //            } else {
        //
        //            }
        //        }
    }
    
    
    public func loadListData(_ folderId: String){
        var lstData: [MediaFile] = []
        
        let query = GTLRDriveQuery_FilesList.query()
        query.fields = "kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,fileExtension,size, createdTime,modifiedTime)"
        query.pageSize = 1000
        query.q = String(format: "trashed = false and '%@' In parents ", folderId)
        
        serviceGGDrive.executeQuery(query) { (ticket, result, error) in
//            print(ticket)
//            print(result as! GTLRDrive_FileList)
//            print(error as Any)
            
            if(error == nil) {
                let lstFilesData = (result as! GTLRDrive_FileList).files!
                for data in lstFilesData { // convert data
                    let media = MediaFile()
                    media.name = data.name!
                    media.mimetype = data.mimeType!
                    media.identifier = data.identifier!
                    if(ConfigFileType.isFolderGGDrive(data.fileExtension, mimeType: data.mimeType!)) {
                        media.fileExtension = "folder" // folder thì fileExtension = nil
                        media.fileType = .folder
                    } else {
                        media.fileExtension = !data.fileExtension!.isEmpty ? data.fileExtension! : "file"
                        media.size = data.size != nil ? (data.size?.intValue)! : 0
                    }
                    
                    lstData.append(media)
                }
                
                self.getMediaBlock(lstData)
            }
        }
    }
}
