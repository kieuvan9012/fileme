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
        simpleNavi.bringSubview(toFront: stackView)
        loadData()
    }
    
    func loadData()
    {
        weak var weakself = self;
        files.removeAll()
        
        services.fileList(success: { (response) in
            weakself?.root = response
            weakself?.generatorProcessing(item: response)
            weakself?.tbView.reloadData()
        }) { (error) in
            
        }
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
        case .dropbox : pushDropbox() ; break;
        case .drive : pushGoogleDrive() ; break;
        case .fileMe : pushIcloud() ; break;
        }
    }
    
    func pushGoogleDrive() {
        let view = ListDataGGDriveViewController()
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    func pushDropbox() {
        let view = ListDataDropBoxViewController()
        
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
        files[indexPath.row].toggle()
        tbView.reloadData()
    }
    

    
    func insertMediaFile(_ value : MediaFile)
    {
        let request = MediaFileInsert_Request.init(value)
        request.parent_id = getActiveId()
        
        let parent = files.index{$0.id == getActiveId()}
        files[parent!].addChild([value])
        files.removeAll()
        generatorProcessing(item: root)
        tbView.reloadData()
        
        services.fileInsert(request, success: {response in
            
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
