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

private let kKeychainItemName = "GoogleDrive"
private let kClientID = "47587196428-3svqb2ftjaj77e79r9f9argeosgd8qvc.apps.googleusercontent.com"
private let kClientSecret = ""

class ListDataGGDriveViewController: MasterViewController {
    @IBOutlet weak var tbContent: UITableView!
    var serviceGGDrive : GTLRDriveService!
    
    private var lstData: [GTLRDrive_File] = []
    private var folderId = "root"
    private var folderName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleWithBackAction(folderName.isEmpty ? "Google Drive": folderName)
        
        tbContent.setIdentifier("ListDataGGDriveTableViewCell")
        // Do any additional setup after loading the view.
        
        self.setUpGoogle()
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
        
        if !(serviceGGDrive.authorizer?.canAuthorize)! {
            // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
            present(createAuthController()!, animated: true)
        } else {
            self.loadData()
        }
    }
    
    @objc func viewController(_ viewController: GTMOAuth2ViewControllerTouch?, finishedWithAuth authResult: GTMOAuth2Authentication?, error : Error) throws {
        if error != nil {
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
            print(result)
            print(error)
            if(error != nil) {
                self.lstData = (result as! GTLRDrive_FileList).files!
                self.tbContent.reloadData()
            }
        }
    }
}

extension ListDataGGDriveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListDataGGDriveTableViewCell", for: indexPath) as! ListDataGGDriveTableViewCell
//        cell.selectionStyle = .none
        
        let fileData = lstData[indexPath.row]

        cell.processFileData(fileData)
        
        return cell
    }
    
    
}

extension ListDataGGDriveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileData = lstData[indexPath.row]
        if(ConfigGoogleDrive.isFolder(fileData)) {
            let view = ListDataGGDriveViewController()
            view.serviceGGDrive = serviceGGDrive
            view.folderId = fileData.identifier ?? "root"
            view.folderName = fileData.name ?? "Google Drive"
            
            navigationController?.pushViewController(view, animated: false)
        } else {
            UIApplication.shared.openURL(URL.init(string: fileData.webViewLink!)!)
        }
    }
}
