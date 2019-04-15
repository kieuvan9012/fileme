//
//  PrintStoreListViewController.swift
//  FileMe
//
//  Created by Lê Dũng on 3/19/19.
//

import UIKit

protocol PrintStoreListViewControllerDelegate : class {
    func PrintStoreListViewControllerDidSelect(_ value : PrintStore)
}

class PrintStoreListViewController: MasterViewController, UITableViewDelegate,UITableViewDataSource {
    weak var delegate : PrintStoreListViewControllerDelegate?
    var lstData : [PrintStore] = []
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleWithBackAction("Cửa tiệm in")
        tbView.setIdentifier("PrintStoreCell")
        self.view.backgroundColor = template.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    func loadData()
    {
        services.printStoreList(request: PrintStoreList_Request(), success: { (response) in
            self.lstData = response
            
            self.tbView.reloadData()
        }) { (errorStr) in
            self.view.error(desc: errorStr)
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(delegate != nil) {
            delegate!.PrintStoreListViewControllerDidSelect(lstData[indexPath.row])
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "PrintStoreCell") as! PrintStoreCell
        cell.selectionStyle = .none

        cell.setDataCell(lstData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lstData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
