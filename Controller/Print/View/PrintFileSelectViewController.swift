//
//  PrintFileSelectViewController.swift
//  FileMe
//
//  Created by Emty on 4/21/19.
//

import UIKit

protocol PrintFileSelectViewController_Delegate: class {
    func fileSelected(_ value: MediaFile)
}

class PrintFileSelectViewController: MasterViewController {
    @IBOutlet weak var tbView: UITableView!

    var files : [MediaFile] = []
    weak var delegate: PrintFileSelectViewController_Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = template.backgroundColor
        
        setTitleWithBackAction("My Files")
        tbView.setIdentifier("FileListCell")
        tbView.delegate = self
        tbView.dataSource = self
        tbView.es.addPullToRefresh {
            self.loadData()
        }
        
        loadData()
    }
    
    func loadData() {
        weak var weakself = self
        files = myFileInstance.filesData
        
        weakself?.updateData()
    }
    
    func updateData() {
        weak var weakself = self
        
        weakself?.tbView.reloadData()
        weakself?.tbView.es.stopPullToRefresh()
    }
}

extension PrintFileSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return files[indexPath.row].getHeightDisplay();
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

extension PrintFileSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakself = self

        let data = files[indexPath.row]
        
        if(data.fileType != .folder) {
            weakself?.delegate?.fileSelected(data)
            weakself?.pop()
            
            return
        }
        
        data.toggle()
        weakself?.tbView.reloadData()
    }
}
