//
//  ListDataGGDriveViewController.swift
//  FileMe
//
//  Created by trang.le on 3/13/19.
//

import UIKit

class ListDataGGDriveViewController: MasterViewController {
    @IBOutlet weak var tbContent: UITableView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewDownloadFile: UIView!
    @IBOutlet weak var btnSignOut: UIButton!
    
    private var lstData: [MediaFile] = []
    private var folderId = "root" // default root - get all data
    private var folderName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ggDriveInstance.connectGGDrive(folderId) { (response) in
            self.lstData = response
            self.tbContent.reloadData()
        }
    }
    
    @IBAction func actionCancelDownloadFile() {
        weak var weakSelf = self
        
        ggDriveInstance.fetcher.stopFetching()
        weakSelf?.btnSignOut.showView()
        
        weakSelf?.viewDownloadFile.hiddenView()
        weakSelf?.lblProgress.text = ""
        weakSelf?.progressView.progress = 0
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        ggDriveInstance.sighOut()
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
        
        cell.processGGDriveFileData(fileData)
        
        return cell
    }
    
}

extension ListDataGGDriveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        
        let fileData = lstData[indexPath.row]
        if(fileData.fileType == .folder) {
            let view = ListDataGGDriveViewController()
            view.folderId = fileData.identifier
            view.folderName = fileData.name
            
            weakSelf?.navigationController?.pushViewController(view, animated: false)
        } else {
            //            UIApplication.shared.openURL(URL.init(string: fileData.webViewLink!)!)
            if(!ConfigFileType.isSupportFile(fileData.fileExtension)) {
                weakSelf?.view.warning(title: "Lỗi", desc: "Không thể tải tập tin này")
                return
            }
            
//            weakSelf?.downloadFile(fileData)
        }
    }
    
//    func downloadFile(_ fileData: MediaFile) {
//        weak var weakSelf = self
//
//        if((weakSelf?.fetcher.isFetching)!) {
//            self.actionCancelDownloadFile()
//        }
//
//        var downloadRequest: URLRequest
//        if (fileData.fileExtension == nil) {
//            // Google Spread Sheet like googles own format can be downloaded via this query
//            // https://developers.google.com/drive/v3/web/manage-downloads
//            let query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId: fileData.identifier, mimeType: "application/pdf")
//            downloadRequest = self.serviceGGDrive.request(for: query) as URLRequest
//        } else {
//            let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileData.identifier)
//            downloadRequest = self.serviceGGDrive.request(for: query) as URLRequest
//        }
//        if(downloadRequest == nil) {
//            return
//        }
//
//        weakSelf?.fetcher = self.serviceGGDrive.fetcherService.fetcher(with: downloadRequest)
//
//        // reset data
//        weakSelf?.viewDownloadFile.showView()
//        weakSelf?.progressView.progress = 0
//        weakSelf?.btnSignOut.hiddenView()
//
//        if (fileData.size != nil) {
//            weakSelf?.lblProgress.text = "Downloading 0 KB of " + ByteCountFormatter.string(fromByteCount: Int64(fileData.size), countStyle: .file)
//        } else {
//            weakSelf?.lblProgress.text =  "Wait for Downloading..."
//        }
//
//        // Progress
//        weakSelf?.fetcher.receivedProgressBlock = { bytesWritten, totalBytesWritten in
//            let progress = Float(totalBytesWritten) / Float(fileData.size)
//            weakSelf?.updateDownloadProgress(progress)
//
//            if (fileData.size != nil) {
//                weakSelf?.lblProgress.text = String(format: "Downloading %@ of %@", ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .file), ByteCountFormatter.string(fromByteCount: Int64(fileData.size), countStyle: .file))
//            } else {
//                weakSelf?.lblProgress.text = String(format: "Downloading... %@", ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .file))
//            }
//        }
//
//        weakSelf?.fetcher.beginFetch(completionHandler: { (data, fetchError) in
//            if fetchError == nil {
//                weakSelf?.successDownload(fileData.name)
//            } else {
//                weakSelf?.actionCancelDownloadFile()
//                weakSelf?.view.warning(title: "Lỗi", desc: (fetchError?.localizedDescription)!)
//            }
//        })
//
//        // cách download khác - k có progress
//
//        //        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileData.identifier!)
//        //        serviceGGDrive.executeQuery(query) { (ticket, file , error) in
//        //            if (error == nil) {
//        //                print(ticket)
//        //                print(error as Any)
//        //                print((file as! GTLRDataObject))
//        //                print((file as! GTLRDataObject).data)
//        //            } else {
//        //
//        //            }
//        //        }
//    }
    
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
