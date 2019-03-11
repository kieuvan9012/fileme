//
//  HistoryViewController.swift
//  FileMe
//
//  Created by Lê Dũng on 3/7/19.
//

import UIKit

class HistoryViewController: MasterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        printView.drawRound()
        printView.backgroundColor = template.primaryColor
                
        simpleNavi.set("Lịch Sử In")
        
    }

    @IBOutlet weak var printView: UIView!
    @IBAction func printTtouch(_ sender: Any) {
        
    }

}
