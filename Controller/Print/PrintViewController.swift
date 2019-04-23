//
//  PrintViewController.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

class PrintViewController: MasterViewController,PrintAddViewDelegate , PrintSelectViewDelegate, PrintSelectViewControllerDelegate{

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selectView: PrintSelectView!
    @IBOutlet weak var printContentView: UIView!
    @IBOutlet weak var lblPrintStore: UILabel!
    
    var data : [(MediaFile, PrintView)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakself = self;
        navigationView.set(style: .back, title: "In Tài Liệu") {
            weakself?.pop()
        }
        contentView.backgroundColor = template.backgroundColor
        innerView.drawRadius(2)
        selectView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // test123
        
        if(data.count > 0) {

        }

        let media = MediaFile.init()
        media.mimetype = "docx"
        media.originalname = "test.docx"
        media.fileType = .word
        let pView = PrintView_DOC.init(frame: CGRect.init())
        pView.set(media)
        data.append((media,pView))
        self.selectView.counting = data.count
        drawView()
    }
    
    func printSelectViewAdd() {
//        let addView = PrintAddView()
//        view.alertBox(addView, ratio: 0.90)
//        addView.delegate = self;
        
        let addView = PrintFileSelectViewController()
        addView.delegate = self
        
        self.push(addView)
    }

    @IBAction func printSelect(_ sender: Any) {
        let printSelect = PrintStoreListViewController()
        printSelect.delegate = self
        
        push(printSelect)
    }
    
    func printAddViewSelect(_ storeType: FileStore) {
        hideAlertBox()
        if(storeType == .fileMe)
        {
            let fileMe = PrintSelectViewController()
            fileMe.delegate = self;
            push(fileMe)
        }
    }
    
    func printSelectViewControllerFile(_ file: MediaFile)
    {
        let pView = PrintView_DOC.init(frame: CGRect.init())
        pView.set(file)
        data.append((file,pView))
        self.selectView.counting = data.count
        drawView()
    }
    
    func drawView()
    {
        printContentView.removeSubsView()
        let printView = data[selectView.selectIndex].1
        printContentView.addSubview(printView)
        printContentView.setLayout(printView)
    }
    
    func printSelectViewUpdateSelect() {
        drawView()
    }
}

extension PrintViewController: PrintStoreListViewControllerDelegate{
    func PrintStoreListViewControllerDidSelect(_ value: PrintStore) {
        lblPrintStore.attributedText = NSMutableAttributedString().boldLeft(value.name).newLine().normalLeft(value.address + " " + value.district_name)
    }
}

extension PrintViewController: PrintFileSelectViewController_Delegate{
    func fileSelected(_ value: MediaFile) {
        let pView = PrintView_DOC.init(frame: CGRect.init())
        pView.set(value)
        data.append((value,pView))
        self.selectView.counting = data.count
        drawView()
    }
}

