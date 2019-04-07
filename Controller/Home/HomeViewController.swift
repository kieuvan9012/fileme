//
//  HomeViewController.swift
//  Mobile_68
//
//  Created by Lê Dũng on 5/12/18.
//  Copyright © 2018 Ledung. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class HomeViewController: MasterViewController
{
    
    
    
    var file = FileViewController()
    var history = HistoryViewController()
    var user = UserViewController()
    var conversation = TestViewController() // test test fix tạm

    
    
    
    let item0 = UITabBarItem.init(title: "", image: "file_disable".image(), tag: 0)
    let item1 = UITabBarItem.init(title: "", image: "print_disable".image(), tag: 1)
    let item2 = UITabBarItem.init(title: "", image: "user_disable".image(), tag: 1)
    let item3 = UITabBarItem.init(title: "", image: "chat_disable".image(), tag: 1)
    let item4 = UITabBarItem.init(title: "", image: "Conver".image(), tag: 1)
    let item5 = UITabBarItem.init(title: "", image: "notify_disable".image(), tag: 1)
    let item6 = UITabBarItem.init(title: "", image: "function_disable".image(), tag: 1)
    
    var item0Selected : UIImage! = UIImage(named: "file_enable")?.withRenderingMode(.alwaysOriginal)
    let item1Selected : UIImage! = UIImage(named: "print_enable")?.withRenderingMode(.alwaysOriginal)
    var item5Selected : UIImage! = UIImage(named: "notify_enable")?.withRenderingMode(.alwaysOriginal)
    var item6Selected : UIImage! = UIImage(named: "function_enable")?.withRenderingMode(.alwaysOriginal)
    var item3Selected : UIImage! = UIImage(named: "chat_enable")?.withRenderingMode(.alwaysOriginal)
    var item2Selected : UIImage! = UIImage(named: "user_enable")?.withRenderingMode(.alwaysOriginal)

    @IBOutlet weak var bottomContraits: NSLayoutConstraint!
    
    
   // @IBOutlet weak var topView: HomeTopView!
    let mainTabar = MainTabbarViewController()
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        self.addChildViewController(mainTabar)
        contentView.addSubview(mainTabar.view)
        contentView.setLayout(mainTabar.view)
        
        mainTabar.tabBar.layer.borderWidth = 0.0
        mainTabar.tabBar.layer.borderColor = UIColor.clear.cgColor
        mainTabar.tabBar.tintColor = "00000".hexColor()
        
        
        
        
        mainTabar.tabBar.barTintColor = template.navigationColor
        mainTabar.tabBar.isTranslucent = false
        
        item6.selectedImage = item6Selected
        item5.selectedImage = item5Selected
        item0.selectedImage = item0Selected
        item1.selectedImage = item1Selected
        item3.selectedImage = item3Selected
        item2.selectedImage = item2Selected

        file.tabBarItem = item0
        file.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        history.tabBarItem = item1
        history.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        
        user.tabBarItem = item2
        user.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        
        conversation.tabBarItem = item3
        conversation.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        
        
        mainTabar.setTabBarSwipe(enabled: false)
        mainTabar.isSwipeEnabled = false
        mainTabar.selectedIndex = 0
        
        
        mainTabar.viewControllers  = [file,history,conversation,user] ;

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(apppInstance.isMatchVersion())
        {
            bottomContraits.constant = 0
        }
        else
        {
            #if !DEBUG
            bottomContraits.constant = 36
            #endif
        }
    }
    @IBAction func updateTouch(_ sender: Any) {
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL.init(string: apppInstance.ios_link)!, options: [:]) { (response) in
                
            }
        } else
        {
            UIApplication.shared.openURL(URL.init(string: apppInstance.ios_link)!)
        }
    }
    
}
