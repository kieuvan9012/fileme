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
    var data : [PrintStore] = []
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.setIdentifier("PrintStoreCell")
        
    }
    
    func loadData()
    {
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.PrintStoreListViewControllerDidSelect(data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "PrintStoreCell") as! PrintStoreCell
        cell.set(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count
        
    }

}
