//
//  FileViewController.swift
//  FileMe
//
//  Created by Lê Dũng on 3/7/19.
//

import UIKit
import MobileCoreServices

class FileViewController: MasterViewController, UITableViewDelegate, UITableViewDataSource, AddFolderViewDelegate,FileAddViewDelegate
{
    @IBOutlet weak var stackView: UIStackView!
    var files : [MediaFile] = []
    var root : MediaFile!
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleNavi.set("My File")
        tbView.setIdentifier("FileListCell")
        simpleNavi.bringSubviewToFront(stackView)
        loadData()
        tbView.es.addPullToRefresh {
            self.loadData()
        }
    }
    
    func loadData()
    {
        weak var weakself = self
        files.removeAll()
        
        services.fileList(success: { (response) in
            weakself?.root = response
            weakself?.generatorProcessing(item: response)
            weakself?.updateData()
        }) { (error) in
            
        }
    }
    
    func updateData() {
        weak var weakself = self

        weakself?.tbView.reloadData()
        weakself?.tbView.es.stopPullToRefresh()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "FileListCell") as! FileListCell
        cell.set(files[indexPath.row])
        return cell ;
    }
    
    func generatorProcessing(item : MediaFile)
    {
        files.append(item)
        for child in item.child
        {
            generatorProcessing(item: child)
        }
    }
    
    @IBAction func addTouch(_ sender: Any) {
        let selectFileView = FileAddView.init(frame: CGRect.init())
        selectFileView.delegate = self;
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return files[indexPath.row].getHeightDisplay();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
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
    

    
    func insertMediaFile(_ value : MediaFile)
    {
        let request = MediaFileInsert_Request.init(value)
        request.parent_id = getActiveId()
        
        services.fileInsert(request, success: {response in
            let parent = self.files.index{$0.id == self.getActiveId()}
            self.files[parent!].addChild([value])
            self.files.removeAll()
            self.generatorProcessing(item: self.root)
            self.tbView.reloadData()
        }) { (error) in
            
        }
    }
    
    @IBAction func createFolderTouch(_ sender: Any) {
        let add = AddFolderView()
        add.delegate = self;
        view.alertBox(add, ratio: 0.90)
    }
    
    func addFolderViewAccept(_ value: String) {
        let request = MediaFileInsert_Request()
        request.originalname = value
        request.parent_id = getActiveId()
        services.fileInsert(request, success: { response in
            let parent = self.files.index{$0.id == self.getActiveId()}
            self.files[parent!].addChild([response])
            self.files.removeAll()
            self.generatorProcessing(item: self.root)
            self.tbView.reloadData()
        }) { (error) in
            
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFile(files[indexPath.row])
        }
    }
    
    func deleteFile(_ value : MediaFile)
    {
        let request = MediaFileDelete_Request()
        request.file_ids = value.grossIds()
        
        weak var weakobject = value
        weak var weakself = self;
        
        services.fileDelete(request, success: {
            weakobject!.delete()
            weakself!.files.removeAll()
            weakself?.generatorProcessing(item: (weakself?.root)!)
            weakself?.tbView.reloadData()
            
        }) { (error) in
            
        }
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
