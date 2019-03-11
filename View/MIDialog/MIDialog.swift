//
//  MIDialog.swift
//  ReBook
//
//  Created by Lê Dũng on 9/18/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit


enum MIDialogType
{
    case info
    case warning
    case infoConfirm
    case warningConfirm
}



class MIDialog: GreenView {

    @IBOutlet weak var lbDes: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var btAccept: UIButton!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var acceptBlock : (()->Void)!
    var cancelBlock : (()->Void)!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mainView: UIView!

    @IBAction func cancel(_ sender: Any) {
        cancelBlock()
        remove()
    }
    
    func remove()
    {
        removeFromSuperview()
    }
    
    @IBAction func accept(_ sender: Any) {
        acceptBlock()
        remove()

    }
    
    init(title : String,desc : String, type : MIDialogType, acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void))
    {
        super.init(frame: CGRect.init())
        self.acceptBlock = acceptBlock
        self.cancelBlock = cancelBlock
        
        alphaView.backgroundColor = UIColor.black
        alphaView.alpha =  0.48
        mainView.drawRadius(1.75)
//        contentView.dropShadow(color: UIColor.lightGray)
        
        lbTitle.text = title
        lbDes.text = desc
        
        switch type {
        case .info: infoStyle() ; break
        case .warning: warningStyle() ; break
        case .infoConfirm: infoConfirm() ; break
        case .warningConfirm: warningConfirm() ; break

        }
        
        
        btAccept.setTitleColor(template.primaryColor, for: .normal)
        headerView.backgroundColor = UIColor.white

    }
    
    func infoConfirm()
    {
        btCancel.isHidden = false
        lbTitle.textColor = template.primaryColor ;

    }
    
    func warningConfirm()
    {
        lbTitle.textColor = template.dangerColor ;
        btCancel.isHidden = false
    }
    
    
    func infoStyle()
    {
        lbTitle.textColor = template.primaryColor ;
        btCancel.isHidden = true

    }
    
    func warningStyle()
    {
        lbTitle.textColor = template.dangerColor ;
        btCancel.isHidden = true
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



extension UIView
{
    func dialog(title : String ,desc : String , type : MIDialogType ,acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void))
    {
        let dialog = MIDialog.init(title: title, desc: desc, type: type, acceptBlock: { () in
            acceptBlock()
        }) { () in
            cancelBlock()
        }
        
        
        
        
        
        
        app.window?.rootViewController?.view.addSubview(dialog)
        app.window?.rootViewController?.view.setLayout(dialog)
        
        dialog.alpha = 0.0

        dialog.contentView.drawRadius(4)
        UIView.animate(withDuration: 0.25) { () -> Void in
            dialog.alpha = 1.0
        }
        

    }
    
    func dialogView(title : String ,desc : String , type : MIDialogType ,acceptBlock : @escaping (()->Void),cancelBlock : @escaping (()->Void))
    {
        let dialog = MIDialog.init(title: title, desc: desc, type: type, acceptBlock: { () in
            acceptBlock()
        }) { () in
            cancelBlock()
        }
        
        self.addSubview(dialog)
        self.setLayout(dialog)
        
        dialog.alpha = 0.0
        
        dialog.contentView.drawRadius(4)
        UIView.animate(withDuration: 0.25) { () -> Void in
            dialog.alpha = 1.0
        }
        
        
    }
    
    func info(title : String ,desc : String )
    {
        let dialog = MIDialog.init(title: title, desc: desc, type: .info, acceptBlock: { () in
        }) { () in
        }
        
        self.addSubview(dialog)
        self.setLayout(dialog)
        
        dialog.alpha = 0.0
        
        dialog.contentView.drawRadius(4)
        UIView.animate(withDuration: 0.25) { () -> Void in
            dialog.alpha = 1.0
        }
        
        
    }

    func warning(title : String ,desc : String )
    {
        let dialog = MIDialog.init(title: title, desc: desc, type: .warning, acceptBlock: { () in
        }) { () in
        }
        self.addSubview(dialog)
        self.setLayout(dialog)
        dialog.alpha = 0.0
        
        dialog.contentView.drawRadius(4)
        UIView.animate(withDuration: 0.25) { () -> Void in
            dialog.alpha = 1.0
        }
    }

    

}

