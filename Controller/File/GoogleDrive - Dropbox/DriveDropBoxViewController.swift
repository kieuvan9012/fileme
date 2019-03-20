//
//  DriveDropBoxViewController.swift
//  FileMe
//
//  Created by trang.le on 3/15/19.
//

import UIKit
import SwiftyDropbox

protocol DriveDropBoxViewControllerDelegate: class {
    func successDownloadFile(_ data: MediaFile)
}

class DriveDropBoxViewController: MasterViewController {
    @IBOutlet weak var tbContent: UITableView!
    @IBOutlet weak var btnSignOut: UIButton!
    var fileType: FileStore = FileStore.fileMe
    weak var actionDelegate: DriveDropBoxViewControllerDelegate?
    
    private var lstData: [MediaFile] = []
    private var folderId = ""
    private var folderName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
    }
    
    private func setUpView() {
        self.navigationView.bringSubview(toFront: btnSignOut)
        setTitleWithBackAction(folderName.isEmpty ? "Dropbox": folderName)
        tbContent.setIdentifier("DriveDropBoxTableViewCell")
        
        if(fileType == .drive && folderId.count == 0) { // default của drive là root, dropbox rỗng
            folderId = "root"
        }
    }
    
    private func loadDropboxData() {
        dropboxInstance.connectDropbox(folderId, vc: self) { (response) in
            self.lstData = response
            self.tbContent.reloadData()
        }
    }
    
    private func loadGGDriveData() {
        ggDriveInstance.connectGGDrive(folderId) { (response) in
            self.lstData = response
            self.tbContent.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reference after programmatic auth flow
        if(fileType == .drive) {
            self.loadGGDriveData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(fileType == .dropbox) { // dropbox nên load viewDidAppear
            self.loadDropboxData()
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        dropboxInstance.sighOut()
        self.navigationController?.popViewController(animated: false)
    }
}

extension DriveDropBoxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriveDropBoxTableViewCell", for: indexPath) as! DriveDropBoxTableViewCell
        //        cell.selectionStyle = .none
        
        let fileData = lstData[indexPath.row]
        
        cell.processFileData(fileData)
        
        return cell
    }
}

extension DriveDropBoxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        let fileData = lstData[indexPath.row]
        
        if(fileData.fileType == .folder) {
            let view = DriveDropBoxViewController()
            view.folderId = fileData.identifier
            view.folderName = fileData.name
            view.fileType = fileType
            
            weakSelf?.navigationController?.pushViewController(view, animated: false)
        } else {
            if(!ConfigFileType.isSupportFile((fileData.name as NSString).pathExtension)) {
                weakSelf?.view.warning(title: "Lỗi", desc: "Không thể tải tập tin này")
                return
            }
            
            let add = DownloadFileView()
            add.fileData = fileData
            view.alertBox(add, ratio: 0.7)
            
            if(fileType == .dropbox) {
                dropboxInstance.downloadFile(fileData) { (progress, data, error)  in
                    add.setProcess(progress)
                    self.processDownload(progress, data, error, fileData)
                }
            } else {
                ggDriveInstance.downloadFile(fileData) { (progress, data, error) in
                    add.setProcess(progress)
                    self.processDownload(progress, data, error, fileData)
                }
            }
        }
    }
    
    func processDownload(_ progress: Float,_ data: Data?,_ error: String?,_ dto: MediaFile) {
        if(data != nil && progress == 1 && error == nil) { // case download thành công
            self.view.warning(title: "Thành công", desc: "Tải tệp thành công")
            self.view.hideAlertBox()
            self.popToViewControllerCustomClass(HomeViewController.self)

            if(actionDelegate != nil) {
                dto.data = data
                actionDelegate?.successDownloadFile(dto) // 123123
            }
        } else if(error != nil) {
            self.view.error(desc: error!)
            self.view.hideAlertBox()
        }
    }

}
