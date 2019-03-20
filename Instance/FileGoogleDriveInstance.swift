//
//  FileGoogleDriveInstance.swift
//  FileMe
//
//  Created by trang.le on 3/18/19.
//

import UIKit
import GoogleAPIClientForREST
import GTMSessionFetcher
import GTMOAuth2

let ggDriveInstance = FileGoogleDriveInstance.sharedInstance()

class FileGoogleDriveInstance: NSObject {
    private let kKeychainItemName = "GoogleDrive"
    private let kClientID = "47587196428-3svqb2ftjaj77e79r9f9argeosgd8qvc.apps.googleusercontent.com"
    private let kClientSecret = ""

    var serviceGGDrive : GTLRDriveService!
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
        let dictionary = [
            "UserAgent" : "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
        ]
        UserDefaults.standard.register(defaults: dictionary)
        // Initialize the Drive API service & load existing credentials from the keychain if available.
        serviceGGDrive = GTLRDriveService()
        serviceGGDrive.authorizer = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(forName: kKeychainItemName, clientID: kClientID, clientSecret: kClientSecret)
    }
    
    private func createAuthController() -> GTMOAuth2ViewControllerTouch? {
        var authController: GTMOAuth2ViewControllerTouch?
        // If modifying these scopes, delete your previously saved credentials by
        // resetting the iOS simulator or uninstall the app.
        let scopes = [kGTLRAuthScopeDrive]
        authController = GTMOAuth2ViewControllerTouch(scope: scopes.joined(separator: " "), clientID: kClientID, clientSecret: nil, keychainItemName: kKeychainItemName, delegate: self, finishedSelector: #selector(viewController(_:finishedWithAuth:error:)))
        return authController
    }

    @objc private func viewController(_ viewController: GTMOAuth2ViewControllerTouch?, finishedWithAuth authResult: GTMOAuth2Authentication?, error : Error) throws {
        if (error != nil) { // thất bại
            print("lỗi gg drive: ", error)
            serviceGGDrive.authorizer = nil
            viewController?.dismiss()
        } else {
            serviceGGDrive.authorizer = authResult
            viewController?.dismiss()
            self.loadListData("root")
        }
    }
    
    func connectGGDrive(_ folderId: String, success : @escaping (([MediaFile])->Void)) {
        self.getMediaBlock = success

        if (serviceGGDrive.authorizer == nil || !(serviceGGDrive.authorizer?.canAuthorize)!) {
            // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
            app.window?.rootViewController?.present(createAuthController()!, competion: {
            })
        } else {
            self.loadListData(folderId)
        }
    }

    public func sighOut() {
        serviceGGDrive = GTLRDriveService()
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychain(forName: kKeychainItemName)
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
        if(downloadRequest == nil) {
            return
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
            print(ticket)
            print(result as! GTLRDrive_FileList)
            print(error as Any)
            
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
