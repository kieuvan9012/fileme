//
//  PrintSelectViewController.swift
//  File Me
//
//  Created by Lê Dũng on 3/16/19.
//

import UIKit

protocol PrintSelectViewControllerDelegate : class {
    func printSelectViewControllerFile(_ file : MediaFile)
}

class PrintSelectViewController: MasterViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate : PrintSelectViewControllerDelegate?
    
    @IBOutlet weak var tbView: UITableView!
    var files : [MediaFile] = []
    var root : MediaFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.setIdentifier("FileListCell")
        loadData()
        
        setTitleWithBackAction("Chọn File In")
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

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return files[indexPath.row].getHeightDisplay();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(files[indexPath.row].fileType != .folder)
        {
            delegate?.printSelectViewControllerFile(files[indexPath.row])
            pop()
        }
        else
        {
            files[indexPath.row].toggle()
            tbView.reloadData()
        }
    }

}
