//
//  HistoryViewController.swift
//  FileMe
//
//  Created by Lê Dũng on 3/7/19.
//

import UIKit

class HistoryViewController: MasterViewController {
    @IBOutlet weak var tbContent: UITableView!
    @IBOutlet weak var printView: UIView!
    var lstData: [String] = []
    @IBOutlet weak var viewTotal: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        printView.drawRound()
        printView.backgroundColor = template.primaryColor
        simpleNavi.set("Lịch Sử In")
        
        self.view.backgroundColor = template.backgroundColor
        
        // tb
        tbContent.setIdentifier("HistoryCell")
        tbContent.delegate = self
        tbContent.dataSource = self
        
        viewTotal.drawDefaultRadius()
    }

    @IBAction func printTtouch(_ sender: Any) {
        let detail = PrintViewController()
        push(detail)
    }
}
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15 // lstData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        
        cell.setDataCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


extension HistoryViewController: UITableViewDelegate {}
