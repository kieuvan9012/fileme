//
//  ListDataDropBoxViewController.swift
//  FileMe
//
//  Created by trang.le on 3/15/19.
//

import UIKit
import SwiftyDropbox

class ListDataDropBoxViewController: MasterViewController {
    @IBOutlet weak var tbContent: UITableView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewDownloadFile: UIView!
    @IBOutlet weak var btnSignOut: UIButton!
    
    private var downRequest : DownloadRequestMemory<Files.FileMetadataSerializer, Files.DownloadErrorSerializer>?
    var clientDropbox: DropboxClient!

    private var lstData: [Files.Metadata] = []
    private var folderId = ""
    private var folderName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        DropboxClientsManager.unlinkClients()
        self.navigationController?.popViewController(animated: false)
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

        setTitleWithBackAction(folderName.isEmpty ? "Dropbox": folderName)

        tbContent.setIdentifier("ListDataFileTableViewCell")
    }
    
    @objc func refresh(_ sender: Any) {
        self.connectDropbox()
    }
    
    func connectDropbox() {
        if let _ = DropboxClientsManager.authorizedClient {
            clientDropbox = DropboxClientsManager.authorizedClient
            self.loadData()
        } else {
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.openURL(url)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reference after programmatic auth flow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.connectDropbox()
    }

    func loadData() {
        let listFolders = DropboxClientsManager.authorizedClient!.files.listFolder(path: folderId)
        listFolders.response{ response, error in
            guard let result = response else{
                return
            }
            self.lstData = result.entries
            self.tbContent.reloadData()
        }
    }
    
    @IBAction func actionCancelDownloadFile() {
        weak var weakSelf = self
        
        weakSelf?.downRequest?.cancel()
        weakSelf?.btnSignOut.showView()
        
        weakSelf?.viewDownloadFile.hiddenView()
        weakSelf?.lblProgress.text = ""
        weakSelf?.progressView.progress = 0
    }
}

extension ListDataDropBoxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListDataFileTableViewCell", for: indexPath) as! ListDataFileTableViewCell
        //        cell.selectionStyle = .none
        
        let fileData = lstData[indexPath.row]
        
        cell.processDropboxFileData(fileData)
        
        return cell
    }
}

extension ListDataDropBoxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self

        let fileData = lstData[indexPath.row]
        if(fileData is Files.FolderMetadata) {
            let view = ListDataDropBoxViewController()
            view.folderId = (fileData as! Files.FolderMetadata).id
            view.folderName = (fileData as! Files.FolderMetadata).name
            
            weakSelf?.navigationController?.pushViewController(view, animated: false)
        } else {
            if(!ConfigFileType.isSupportFile((fileData.name as NSString).pathExtension)) {
                weakSelf?.view.warning(title: "Lỗi", desc: "Không thể tải tập tin này")
                return
            }

            weakSelf?.downloadFile(fileData)
        }
    }
    
    func downloadFile(_ fileData: Files.Metadata) {
        weak var weakSelf = self
        
        let patch = "/" + fileData.name

        weakSelf?.startDownload(ByteCountFormatter.string(fromByteCount: Int64((fileData as! Files.FileMetadata).size), countStyle: .file))

        // Download to Data
        weakSelf?.downRequest = clientDropbox!.files.download(path: patch, rev: (fileData as! Files.FileMetadata).rev)
            .response { response, error in
                self.viewDownloadFile.hiddenView()

                if let response = response {
                    let responseMetadata = response.0
                    print("responseMetadata :", responseMetadata)
                    let fileContents = response.1
                    print("fileContents :", fileContents)
                    self.successDownload(fileData.name)
                } else if let error = error {
                    print("lỗi :", error)
                    weakSelf?.actionCancelDownloadFile()
                    if(!error.description.contains("Code=-999")) { // lỗi cancel
                        weakSelf?.view.warning(title: "Lỗi", desc: error.description)
                    }
                }
            }
            .progress { progressData in
                print("progressData:", progressData)
                weakSelf?.updateDownloadProgress(Float(progressData.fractionCompleted))
                weakSelf?.lblProgress.text = String(format: "Downloading %@ of %@", ByteCountFormatter.string(fromByteCount: progressData.completedUnitCount, countStyle: .file), ByteCountFormatter.string(fromByteCount: progressData.totalUnitCount, countStyle: .file))
        }
    }
    
    func startDownload(_ data: String) {
        weak var weakSelf = self
        weakSelf?.viewDownloadFile.showView()
        weakSelf?.btnSignOut.hiddenView()
        weakSelf?.lblProgress.text = String(format: "Downloading 0 KB of %@", data)
        weakSelf?.progressView.progress = 0
    }
    
    func updateDownloadProgress(_ progress: Float) {
        self.progressView.progress = progress
    }

    func successDownload(_ val: String) {
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
}
