//
//  TestViewController.swift
//  FileMe
//
//  Created by Lê Dũng on 3/18/19.
//

import UIKit
import WebKit
class TestViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

//
//        let config = WKWebViewConfiguration()
//        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
//        let urlRaw = Bundle.main.url(forResource: "index", withExtension: "html")
//        webView.loadFileURL(urlRaw!, allowingReadAccessTo: urlRaw!)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
