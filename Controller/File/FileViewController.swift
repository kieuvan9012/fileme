//
//  FileViewController.swift
//  FileMe
//
//  Created by Lê Dũng on 3/7/19.
//

import UIKit
import MobileCoreServices

class TableView: UITableView
{
    var stackView :UIStackView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        if let hitView = super.hitTest(point, with: event) , hitView != self
        {
            return hitView
        }
        
        let indexPath: IndexPath? = indexPathForRow(at: point)
        let pointButton = self.convert(point, to: stackView)

        if (indexPath == nil && stackView?.point(inside: pointButton, with: event) == false) {
            notifyInstance.post(.hitOutsideCell)
        }
        
        return nil
    }
}

class FileViewController: MasterViewController, AddFolderViewDelegate,FileAddViewDelegate
{
    @IBOutlet weak var stackView: UIStackView!
    var files : [MediaFile] = []
    var root : MediaFile!
    @IBOutlet weak var tbView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = template.backgroundColor

        simpleNavi.set("My File")
        tbView.setIdentifier("FileListCell")
        
        self.tbView.stackView = stackView
        simpleNavi.bringSubviewToFront(stackView)
        
        tbView.es.addPullToRefresh {
            self.loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notifyInstance.add(self, .hitOutsideCell, selector: #selector(hitOutsideCell))
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notifyInstance.remove(self)
    }
    
    @objc func hitOutsideCell(){
        self.files = files.map({ (data) -> MediaFile in
            data.active = false
            
            return data
        })
        
        tbView.reloadData()
    }
    
    func loadData()
    {
        weak var weakself = self
        files.removeAll()
        
        myFileInstance.getFilesData { (response) in
            weakself?.processResponseFilesData(response)
        }
    }
    
    func processResponseFilesData(_ val: String) {
        weak var weakself = self

        if(val.isEmpty) {
            weakself?.files = myFileInstance.filesData
            weakself?.updateData()
        } else {
            weakself?.view.error(desc: val)
        }
    }
    
    func updateData() {
        weak var weakself = self

        weakself?.tbView.reloadData()
        weakself?.tbView.es.stopPullToRefresh()
    }
    
    @IBAction func addTouch(_ sender: Any) {
        let selectFileView = FileAddView.init(frame: CGRect.init())
        selectFileView.delegate = self
        
        view.alertBox(selectFileView, ratio: 0.90)
    }
    
    func fileAddViewSelect(_ storeType: FileStore) {
        hideAlertBox()
        switch storeType {
        case .icloud : pushIcloud() ; break;
        case .dropbox : pushGGDriveDropbox(storeType) ; break;
        case .drive : pushGGDriveDropbox(storeType) ; break;
        case .fileMe : pushIcloud() ; break;
        }
    }
    
    func pushGGDriveDropbox(_ storeType: FileStore) {
        let view = DriveDropBoxViewController()
        view.fileType = storeType
        view.actionDelegate = self
        
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    func pushIcloud()
    {
        fileiCloud.callFilePicker { (response) in
            
        }
    }
    
    @IBAction func createFolderTouch(_ sender: Any) {
        let add = AddFolderView()
        add.delegate = self
        
        view.alertBox(add, ratio: 0.90)
    }
    
    func addFolderViewAccept(_ value: String) {
        weak var weakself = self
        myFileInstance.addFolderViewAccept(value, parentId: getActiveId()) { (response) in
            weakself?.processResponseFilesData(response)
        }
    }
    
    func insertMediaFile(_ value : MediaFile)
    {
        weak var weakself = self
        myFileInstance.insertMediaFile(value, parentId: getActiveId()) { (response) in
            weakself?.processResponseFilesData(response)
        }
    }

    func deleteFile(_ value : MediaFile)
    {
        weak var weakself = self
        myFileInstance.deleteFile(value, parentId: getActiveId()) { (response) in
            weakself?.processResponseFilesData(response)
        }
    }
    
    func getActiveId()-> Int
    {
        if let index = self.files.index(where: {$0.active})
        {
            return self.files[index].id
        }
        return 0
    }
}

extension FileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return files[indexPath.row].getHeightDisplay()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "FileListCell") as! FileListCell
        cell.set(files[indexPath.row])
        
        return cell
    }
}

extension FileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFile(files[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = files[indexPath.row]
        if(data.fileType != .folder) {
            //                let add = PrintViewController()
            //                add.data.append()
            //
            //                self.push(add)
            _ = MIActionSheet("title", "des", action: [("a", UIColor.red), ("2", UIColor.green)], actionBlock: { (index) in
            })
            
            return
        }
        
        data.toggle()
        
        tbView.reloadData()
    }
}

extension FileViewController: DriveDropBoxViewControllerDelegate {
    func successDownloadFile(_ data: MediaFile) {
        services.uploadFile(file: data, success: { (resposen) in
            
            self.insertMediaFile(MediaFile.init(dictionary: (resposen.data as! [NSDictionary])[0]))
            
            // insert
        }, failure: { (error) in
            
        }) { (process) in
            
        }
    }    
}
