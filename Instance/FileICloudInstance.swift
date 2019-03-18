//
//  FileICloudInstance.swift
//  FileMe
//
//  Created by Lê Dũng on 3/18/19.
//

import UIKit


let  fileiCloud = FileICloudInstance.sharedInstance()

class FileICloudInstance: NSObject,  UIDocumentPickerDelegate {
    
    static var instance: FileICloudInstance!
    var getMediaBlock : (([URL])->Void)!

    class func sharedInstance() -> FileICloudInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? FileICloudInstance())
        }
        return self.instance
    }
    
    func callFilePicker(_ success : @escaping (([URL])->Void))
    {
        self.getMediaBlock = success
        let types: [String] = ["public.jpeg","public.png","com.adobe.pdf ","com.microsoft.word.doc","com.microsoft.excel.xls","org.openxmlformats.wordprocessingml.document","com.microsoft.powerpoint.​ppt","org.openxmlformats.spreadsheetml.sheet"]
        let importMenu = UIDocumentPickerViewController(documentTypes:types, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        app.window?.rootViewController?.present(importMenu, competion: {
            
        })
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        self.getMediaBlock(urls)
    }
}
