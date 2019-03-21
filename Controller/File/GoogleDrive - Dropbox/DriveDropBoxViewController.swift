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
    @IBOutlet weak var viewLogout: UIView!
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
        self.navigationView.bringSubview(toFront: viewLogout)
        setTitleWithBackAction(folderName.isEmpty ? getTypeName() : folderName)
        tbContent.setIdentifier("DriveDropBoxTableViewCell")
        
        if(isGGDriveMode() && folderId.count == 0) { // default của drive là root, dropbox rỗng
            folderId = "root"
        }
    }
    
    @objc private func loadDropboxData() {
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

        if(isGGDriveMode()) {
            self.loadGGDriveData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if(!isGGDriveMode()) { // dropbox nên load viewDidAppear
            self.loadDropboxData()
        }
    }
    
    func isGGDriveMode() -> Bool {
        if(fileType == .drive) {
            return true
        }
        return false
    }
    
    func getTypeName() -> String {
        if(isGGDriveMode()) {
            return "Google Drive"
        } else {
            return "Dropbox"
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        view.dialog(title: "Xác nhận", desc: String(format: "Bạn có muốn đăng xuất %@ ?", getTypeName()), type: .infoConfirm, acceptBlock: {
            if(self.isGGDriveMode()) {
                ggDriveInstance.sighOut()
            } else {
                dropboxInstance.sighOut()
            }
            
            self.navigationController?.popViewController(animated: false)
        }) {
        }
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
            if(!ConfigFileType.isSupportFile(fileData.fileExtension)) {
                weakSelf?.view.warning(title: "Lỗi", desc: "Không thể tải tập tin này")
                return
            }
            
            let add = DownloadFileView()
            add.fileData = fileData
            add.actionDelegate = self
            weakSelf?.view.alertBox(add, ratio: 0.7)
            
            if(isGGDriveMode()) {
                ggDriveInstance.downloadFile(fileData) { (progress, data, error) in
                    add.setProcess(progress)
                    weakSelf?.processDownload(progress, data, error, fileData)
                }
            } else {
                dropboxInstance.downloadFile(fileData) { (progress, data, error)  in
                    add.setProcess(progress)
                    weakSelf?.processDownload(progress, data, error, fileData)
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
            self.view.hideAlertBox()
            if(!(error?.contains("Code=-999"))!) { // cancelled dropbox
                self.view.error(desc: error!)
            }
        }
    }
}

extension DriveDropBoxViewController: DownloadFileViewDelegate {
    func cancelledDownloadFile() {
        if(self.isGGDriveMode()) {
            ggDriveInstance.cancelDownload()
        } else {
            dropboxInstance.cancelDownload()
        }
        
        self.view.hideAlertBox()
    }
}
