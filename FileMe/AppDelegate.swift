//
//  AppDelegate.swift
//  FileMe
//
//  Created by Lê Dũng on 3/3/19.
//

import UIKit
import SwiftyDropbox
import IQKeyboardManager

let app = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false

        _ = FileGoogleDriveInstance.sharedInstance()
        _ = FileDropboxInstance.sharedInstance()
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = IntroViewController()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("success response")
        
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
                let mainController = self.window!.rootViewController as! UINavigationController
                mainController.popViewController(animated: false)
                
            case .error(_, let description):
                print("Error: \(description)")
                //                let mainController = self.window!.rootViewController as! UINavigationController
                //                mainController.popViewController(animated: false)
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    var loginNavi : UINavigationController!

    
    func maintenance()
    {
        let mt = MaintenanceViewController()
        self.window?.rootViewController = mt
    }
    
    func login()
    {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            self.loginNavi = UINavigationController.init(rootViewController: loginVC)
            self.window?.rootViewController  = self.loginNavi
            self.loginNavi.isNavigationBarHidden = true
        }
    }
    
    func info()
    {
        let info = InitInfoViewController()
        self.window?.rootViewController = info
    }
    
    func infoFace()
    {
        let info = InitInfoViewController()
        info.fromFace = true;
        self.window?.rootViewController = info
    }
    
    var navi : UINavigationController!
    var homeV : HomeViewController!
    
    func home()
    {
        DispatchQueue.main.async {
            self.homeV = HomeViewController()
            self.navi = UINavigationController.init(rootViewController: self.homeV)
            
            self.navi.isNavigationBarHidden = true
            self.window?.rootViewController = self.navi
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

