//
//  PrintView.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

class PrintView_DOC: PrintView {
    @IBOutlet weak var pageCountingView: MIDropListView!
    
    @IBOutlet weak var colorView: MIDropListView!
    
    @IBOutlet weak var typeView: MIDropListView!
    
    
    @IBOutlet weak var layoutView: MIDropListView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfTo: UITextField!
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var radioColor: RadioView!
    @IBOutlet weak var radioWB: RadioView!
    @IBOutlet weak var radioF2: RadioView!
    @IBOutlet weak var radioF1: RadioView!
    @IBOutlet weak var radioLimitPage: RadioView!
    @IBOutlet weak var radioFullPage: RadioView!
    @IBOutlet weak var numberCopiesView: MIStepNumberView!
    
    @IBOutlet weak var radioBinding: RadioView!
    @IBOutlet weak var radioStandartView: RadioView!
    @IBOutlet weak var radioCover: RadioView!

    override func initStyle() {
        numberCopiesView.value = 1
        numberCopiesView.min = 1
        
        pageCountingView.setIndex(["Toàn bộ","Giới hạn số trang"], inView: self) { (response) in
            
        }
        
        colorView.setIndex(["In trắng đen","In màu"], inView: self) { (response) in
            
        }
        
        typeView.setIndex(["In 1 mặt","In 2 mặt"], inView: self) { (response) in
            
        }
        
        layoutView.setIndex(["A0","A2","A3","A4","A5"], inView: self) { (response) in
            
        }

        radioBinding.set(false, "Bìa nilong")
        radioStandartView.set(false, "Tinh chỉnh văn bản")
        radioCover.set(false, "Đóng bìa")
        
        backgroundColor = .white
    }
    
    override func set(_ file: MediaFile) {
        super.set(file)
        lbName.text = file.originalname
        imgView.image = file.imageDisplay()
    }
}
