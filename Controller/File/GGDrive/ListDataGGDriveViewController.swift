//
//  ListDataGGDriveViewController.swift
//  FileMe
//
//  Created by trang.le on 3/13/19.
//

import UIKit
import GTMOAuth2
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

private let kKeychainItemName = "GoogleDrive"
private let kClientID = "47587196428-3svqb2ftjaj77e79r9f9argeosgd8qvc.apps.googleusercontent.com"
private let kClientSecret = ""


class ListDataGGDriveViewController: MasterViewController {
    @IBOutlet weak var tbContent: UITableView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewDownloadFile: UIView!
    @IBOutlet weak var btnSignOut: UIButton!

    private var serviceGGDrive : GTLRDriveService!
    private var fetcher: GTMSessionFetcher! = GTMSessionFetcher()

    private var lstData: [GTLRDrive_File] = []
    private var folderId = "root"
    private var folderName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        self.setUpGoogle()
    }
    
    func setUpView() {
        self.viewDownloadFile.hiddenView()
        self.viewDownloadFile.backgroundColor = template.primaryColor
        self.lblProgress.textColor = .white
        self.lblProgress.text = ""
        self.progressView.progress = 0
        self.progressView.transform = .init(scaleX: 1.0, y: 3.5)
        self.btnCancel.titleColor(.white)
        self.navigationView.bringSubview(toFront: viewDownloadFile)
        self.navigationView.bringSubview(toFront: btnSignOut)

        setTitleWithBackAction(folderName.isEmpty ? "Google Drive": folderName)
        
        tbContent.setIdentifier("ListDataFileTableViewCell")
    }
    
    @objc func refresh(_ sender: Any) {
        self.connectGGDrive()
    }
    
    func setUpGoogle() {
        let dictionary = [
            "UserAgent" : "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
        ]
        UserDefaults.standard.register(defaults: dictionary)
        // Initialize the Drive API service & load existing credentials from the keychain if available.
        serviceGGDrive = GTLRDriveService()
        serviceGGDrive.authorizer = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(forName: kKeychainItemName, clientID: kClientID, clientSecret: kClientSecret)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.connectGGDrive()
    }
    
    func connectGGDrive() {
        if !(serviceGGDrive.authorizer?.canAuthorize)! {
            // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
            present(createAuthController()!, animated: true)
        } else {
            self.loadData()
        }
    }
    
    @objc func viewController(_ viewController: GTMOAuth2ViewControllerTouch?, finishedWithAuth authResult: GTMOAuth2Authentication?, error : Error) throws {
        if (error != nil) {
            self.view.warning(title: "Authentication Error", desc: error.localizedDescription)
            serviceGGDrive.authorizer = nil
        } else {
            serviceGGDrive.authorizer = authResult
            dismiss(animated: true)
            self.loadData()
        }
    }
    
    func createAuthController() -> GTMOAuth2ViewControllerTouch? {
        var authController: GTMOAuth2ViewControllerTouch?
        // If modifying these scopes, delete your previously saved credentials by
        // resetting the iOS simulator or uninstall the app.
        let scopes = [kGTLRAuthScopeDrive]
        authController = GTMOAuth2ViewControllerTouch(scope: scopes.joined(separator: " "), clientID: kClientID, clientSecret: nil, keychainItemName: kKeychainItemName, delegate: self, finishedSelector: #selector(viewController(_:finishedWithAuth:error:)))
        return authController
    }

    func loadData() {
        let query = GTLRDriveQuery_FilesList.query()
        query.fields = "kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,fileExtension,size, createdTime,modifiedTime)"
        query.pageSize = 1000
        query.q = String(format: "trashed = false and '%@' In parents ", folderId)
        
        serviceGGDrive.executeQuery(query) { (ticket, result, error) in
            print(ticket)
            print(result as! GTLRDrive_FileList)
            print(error as Any)
            
            if(error == nil) {
                self.lstData = (result as! GTLRDrive_FileList).files!
                self.tbContent.reloadData()
            }
        }
    }
    
    @IBAction func actionCancelDownloadFile() {
        weak var weakSelf = self
        
        weakSelf?.fetcher.stopFetching()
        weakSelf?.btnSignOut.showView()

        weakSelf?.viewDownloadFile.hiddenView()
        weakSelf?.lblProgress.text = ""
        weakSelf?.progressView.progress = 0
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychain(forName: kKeychainItemName)
        self.navigationController?.popViewController(animated: false)
    }
}

extension ListDataGGDriveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListDataFileTableViewCell", for: indexPath) as! ListDataFileTableViewCell
//        cell.selectionStyle = .none
        
        let fileData = lstData[indexPath.row]

        cell.processFileData(fileData)
        
        return cell
    }

}

extension ListDataGGDriveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self

        let fileData = lstData[indexPath.row]
        if(ConfigFileType.isFolderGGDrive(fileData)) {
            let view = ListDataGGDriveViewController()
            view.serviceGGDrive = serviceGGDrive
            view.folderId = fileData.identifier ?? "root"
            view.folderName = fileData.name ?? "Google Drive"
            
            weakSelf?.navigationController?.pushViewController(view, animated: false)
        } else {
//            UIApplication.shared.openURL(URL.init(string: fileData.webViewLink!)!)
            if(!ConfigFileType.isSupportFile(fileData.fileExtension)) {
                weakSelf?.view.warning(title: "Lỗi", desc: "Không thể tải tập tin này")
                return
            }
            
            weakSelf?.downloadFile(fileData)
        }
    }
    
    func downloadFile(_ fileData: GTLRDrive_File) {
        weak var weakSelf = self

        if((weakSelf?.fetcher.isFetching)!) {
            self.actionCancelDownloadFile()
        }
        
        var downloadRequest: URLRequest
        if (fileData.fileExtension == nil) {
            // Google Spread Sheet like googles own format can be downloaded via this query
            // https://developers.google.com/drive/v3/web/manage-downloads
            let query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId: fileData.identifier!, mimeType: "application/pdf")
            downloadRequest = self.serviceGGDrive.request(for: query) as URLRequest
        } else {
            let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileData.identifier!)
            downloadRequest = self.serviceGGDrive.request(for: query) as URLRequest
        }
        if(downloadRequest == nil) {
            return
        }

        weakSelf?.fetcher = self.serviceGGDrive.fetcherService.fetcher(with: downloadRequest)

        // reset data
        weakSelf?.viewDownloadFile.showView()
        weakSelf?.progressView.progress = 0
        weakSelf?.btnSignOut.hiddenView()

        if (fileData.size != nil) {
            weakSelf?.lblProgress.text = "Downloading 0 KB of " + ByteCountFormatter.string(fromByteCount: (fileData.size?.int64Value)!, countStyle: .file)
        } else {
            weakSelf?.lblProgress.text =  "Wait for Downloading..."
        }

        // Progress
        weakSelf?.fetcher.receivedProgressBlock = { bytesWritten, totalBytesWritten in
            let progress = Float(totalBytesWritten) / fileData.size!.floatValue
            weakSelf?.updateDownloadProgress(progress)
            
            if (fileData.size != nil) {
                weakSelf?.lblProgress.text = String(format: "Downloading %@ of %@", ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .file), ByteCountFormatter.string(fromByteCount: fileData.size!.int64Value, countStyle: .file))
            } else {
                weakSelf?.lblProgress.text = String(format: "Downloading... %@", ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .file))
            }
        }
        
        weakSelf?.fetcher.beginFetch(completionHandler: { (data, fetchError) in
            if fetchError == nil {
                weakSelf?.successDownload(fileData.name!)
            } else {
                weakSelf?.actionCancelDownloadFile()
                weakSelf?.view.warning(title: "Lỗi", desc: (fetchError?.localizedDescription)!)
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
    
    func successDownload(_ val: String) {
        self.viewDownloadFile.hiddenView()

        let viewSuccessNoti = UIView(frame: CGRect(x: 0, y: self.navigationView.frame.size.height , width: self.navigationView.frame.size.width , height: 30))
        viewSuccessNoti.backgroundColor = UIColor(red: 92 / 255.0, green: 195 / 255.0, blue: 138 / 255.0, alpha: 1)
        
        let lblDLSuccess = UILabel(frame: CGRect(x: 0, y: 0, width: self.navigationView.frame.size.width , height: 30))
        lblDLSuccess.textColor = UIColor.black
        lblDLSuccess.font = UIFont.systemFont(ofSize: 18)
        lblDLSuccess.textColor = UIColor.white
        lblDLSuccess.textAlignment = .center
        lblDLSuccess.text = "Tải thành công " + val
        
        viewSuccessNoti.addSubview(lblDLSuccess)
        viewSuccessNoti.alpha = 0.0
        self.view.addSubview(viewSuccessNoti)
        
        UIView.animate(withDuration: 1.0, animations: {
            viewSuccessNoti.alpha = 1.0
        }) { finished in
            viewSuccessNoti.removeFromSuperview()
        }
    }
    
    func updateDownloadProgress(_ progress: Float) {
        self.progressView.progress = progress
    }
}
