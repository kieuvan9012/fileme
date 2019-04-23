//
//  MyFileDataInstance.swift
//  FileMe
//
//  Created by Emty on 4/21/19.
//

import UIKit

let myFileInstance = MyFileDataInstance.sharedInstance()

class MyFileDataInstance: NSObject {
    var filesData : [MediaFile] = []
    private var root : MediaFile!
    private var successBlock : ((String)->Void)! // "" rỗng là thành công

    func getFilesData(_ successBlock: @escaping((String))->Void)
    {
        self.successBlock = successBlock
        weak var weakself = self
        if(filesData.count > 0) { // dùng dữ liệu cũ
            successBlock("")
            
            return
        }
        
        services.fileList(success: { (response) in
            weakself?.root = response
            weakself?.generatorProcessing(item: response)
            
            successBlock("")
        }) { (error) in
            successBlock(error)
        }
    }
    
    private func generatorProcessing(item : MediaFile)
    {
        filesData.append(item)
        for child in item.child
        {
            generatorProcessing(item: child)
        }
    }
    
    func insertMediaFile(_ value : MediaFile, parentId: Int, _ successBlock: @escaping(String)->Void)
    {
        weak var weakself = self

        let request = MediaFileInsert_Request.init(value)
        request.parent_id = parentId
        
        services.fileInsert(request, success: {response in
            let parent = self.filesData.index{$0.id == parentId}
            weakself?.filesData[parent!].addChild([value])
            weakself?.filesData.removeAll()
            weakself?.generatorProcessing(item: self.root)
            
            successBlock("")
        }) { (error) in
            successBlock(error)
        }
    }

    func addFolderViewAccept(_ value: String, parentId: Int, _ successBlock: @escaping(String)->Void) {
        weak var weakself = self

        let request = MediaFileInsert_Request()
        request.originalname = value
        request.parent_id = parentId

        services.fileInsert(request, success: { response in
            let parent = self.filesData.index{$0.id == parentId}
            weakself?.filesData[parent!].addChild([response])
            weakself?.filesData.removeAll()
            weakself?.generatorProcessing(item: self.root)
            
            successBlock("")
        }) { (error) in
            successBlock(error)
        }
    }
    
    func deleteFile(_ value : MediaFile, parentId: Int, _ successBlock: @escaping(String)->Void)
    {
        let request = MediaFileDelete_Request()
        request.file_ids = value.grossIds()
        
        weak var weakobject = value
        weak var weakself = self
        
        services.fileDelete(request, success: {
            weakobject!.delete()
            weakself?.filesData.removeAll()
            weakself?.generatorProcessing(item: (weakself?.root)!)
            
            successBlock("")
        }) { (error) in
            successBlock(error)
        }
    }
    
    // init ============
    static var instance: MyFileDataInstance!
    
    class func sharedInstance() -> MyFileDataInstance
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? MyFileDataInstance())
        }
        return self.instance
    }
}
