//
//  MasterViewController.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/18/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    @IBOutlet weak var homeNavi: HomeNaviView!
    @IBOutlet weak var simpleNavi: SimpleNavi!

    @IBOutlet weak var navigationView: NavigationView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    func setTitleWithBackAction(_ value : String)
    {
        navigationView.set(style: .back, title: value) {
            self.navigationController?.popViewController(animated: false)
        }
    }

    func hideAlertBox()
    {
        view.hideAlertBox()
    }
}
