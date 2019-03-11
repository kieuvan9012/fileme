//
//  FileViewController.swift
//  FileMe
//
//  Created by Lê Dũng on 3/7/19.
//

import UIKit
import MobileCoreServices

class FileViewController: MasterViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentMenuDelegate, UIDocumentPickerDelegate
{
    
    
    @IBOutlet weak var stackView: UIStackView!
    var files : [MediaFile] = []
    
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleNavi.set("My File")
        tbView.setIdentifier("FileListCell")
        
        let item = MediaFile.init()
        item.title = "Nhóm học tập"
        item.isExpand = true
        let sub0 = MediaFile.init()
        sub0.fileType = .excel
        sub0.title = "File excel 0"
        
        let sub1 = MediaFile.init()
        sub1.fileType = .word
        sub1.title = "File doc 0"
        
        let item1 = MediaFile.init()
        item1.title = "Điện ảnh"
        item1.isExpand = true
        
        let sub01 = MediaFile.init()
        sub01.fileType = .excel
        sub01.title = "File excel 1"
        
        let sub11 = MediaFile.init()
        sub11.fileType = .word
        sub11.title = "File doc 1"
        

        item1.addChild([sub01,sub11])

        item.addChild([sub0,sub1,item1])

        generatorProcessing(item: item)
        tbView.reloadData()
        
        simpleNavi.bringSubview(toFront: stackView)

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
        
        let types: [String] = ["public.jpeg","public.png","com.adobe.pdf ","com.microsoft.word.doc","com.microsoft.excel.xls","com.microsoft.powerpoint.​ppt"]
        
        let importMenu = UIDocumentMenuViewController(documentTypes:types, in: .import)
        importMenu.delegate = self
        importMenu.addOption(withTitle: <#T##String#>, image: <#T##UIImage?#>, order: <#T##UIDocumentMenuOrder#>, handler: <#T##() -> Void#>)
        
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return files[indexPath.row].getHeightDisplay();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        files[indexPath.row].toggle()
        tbView.beginUpdates()
        tbView.endUpdates()
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        viewModel.attachDocuments(at: urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
    }


}
