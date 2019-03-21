//
//  DownloadFileView.swift
//  FileMe
//
//  Created by trang.le on 3/19/19.
//

import UIKit

protocol DownloadFileViewDelegate : class {
    func cancelledDownloadFile()
}

class DownloadFileView: GreenView {
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var imgFile: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    var fileData: MediaFile!
    weak var actionDelegate : DownloadFileViewDelegate?

    override func initStyle() {
        drawRadius(4)

        progressView.transform = .init(scaleX: 1.0, y: 3)
        progressView.progress = 0
    }
    
    func setProcess(_ process: Float) {
        self.progressView.progress = process
    }
    
    override func didMoveToSuperview() {
        lblFileName.text = fileData.name
        imgFile.image = fileData.fileExtension.image()
    }
    
    @IBAction func cancelDownloadPressed(_ sender: Any) {
        if(actionDelegate != nil) {
            actionDelegate?.cancelledDownloadFile()
        }
    }
}
