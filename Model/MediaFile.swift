//
//  MediaFile.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/28/18.
//  Copyright © 2018 limerence. All rights reserved.
//
import SDWebImage
import UIKit
import Alamofire

enum MediaType : Int
{
    case image = 2
    case info = 1
    case conference = 3
}


/*
 user_id    int(11)            Yes    NULL        Change Change    Drop Drop
 More
 3    name    text    latin1_swedish_ci        Yes    NULL        Change Change    Drop Drop
 More
 4    path    varchar(256)    latin1_swedish_ci        Yes    NULL        Change Change    Drop Drop
 More
 5    file_type    int(11)            Yes    NULL        Change Change    Drop Drop
 More
 6    des    text    latin1_swedish_ci        Yes    NULL        Change Change    Drop Drop
 More
 7    date    timestamp            Yes    CURRENT_TIMESTAMP        Change Change    Drop Drop
 More
 8    parent_id    int(11)
 */


enum FileType : String
{
    case folder =  "folder"
    case excel = "excel"
    case word = "word"
    case ppt = "ppt"
    case image = "image"
    case none = "none"
}


enum MediaBrand : Int
{
    case book = 2
    case info = 1
    case conference = 3
}

class MediaFile: Mi {

    
    @objc dynamic var destination = "";
    @objc dynamic var filename = "";
    @objc dynamic var mimetype = "";
    @objc dynamic var originalname = "";
    @objc dynamic var path = "";
    @objc dynamic var id = 0;
    @objc dynamic var size = 1;
    @objc dynamic var parent_id = 1;
    @objc dynamic var name = "";
    @objc dynamic var fileExtension = "";
    @objc dynamic var data : Data!;
    @objc dynamic var isExpand = false;
    @objc dynamic var content : Any? ;
    @objc dynamic var active = false;
    @objc dynamic var isDowload = false ;
    
    @objc dynamic var identifier = ""
    @objc dynamic var rev = "" // parameter rev: Please specify revision in path instead - dropbox
    
    var url : URL!

    
    
    var fileType  = FileType.none;
    var media_type = MediaType.image;
    @objc dynamic var child : [MediaFile] = [];
    @objc dynamic var parent : MediaFile! ;

    
    
    func getNameFromURL() ->String
    {
        return url.lastPathComponent
    }
    
    func getFilExtensionFromURL()->String
    {
        return  url.pathExtension
    }
    
    func getDataFromURL()->Data
    {
        return try! Data.init(contentsOf: url!, options: [])
    }

    var level : Int{
        set{
            
        }
        get{
            if(parent == nil)
            {
                return 0 ;
            }
            else
            {
                return parent.level + 1
            }
        }
    }

    
    func getEndData()->Data
    {
        if(url != nil)
        {
            return getDataFromURL()
        }
        else
        {
            return data
        }
    }
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
        processFileType()
    }
    
    func processFileType()
    {
        switch mimetype {
        case "doc","docx","docm","dotx","dotm","docb": fileType = .word;
        case "xls","xlsb","xlsm","xlsx": fileType = .excel;
        case "sldx","pptx","pptm","potx","potm","ppam","ppsx","ppsm": fileType = .ppt;
        case "png","jpg","jpeg" : fileType = .image;
        default : fileType = .folder;
        }
    }
    
    class func  list(data : [Dictionary<String, Any>]) -> [MediaFile]
    {
        var output  : [MediaFile]  = []
        for item in data
        {
            let unit = MediaFile.init(dictionary: item as NSDictionary)
            output.append(unit)
        }
        return output
    }
    
    required init() {
        super.init()
    }
    
    func toggle()
    {
        if(fileType != .folder)
        {
            return
        }
        
        isExpand = !isExpand
        if(!isExpand)
        {
            closeExpand()
        }
        else
        {
        }
        grossActive()
    }
    
    func isOpen()->Bool
    {
        if(parent != nil)
        {
            return parent.isExpand
        }
        return true ;
    }
    
    func addChild(_ value : [MediaFile])
    {
        for item in value
        {
            item.parent = self;
        }
       child.append(contentsOf: value)
    }
    
    func imageDisplay()->UIImage
    {
        
        switch mimetype {
        case "doc","docx","docm","dotx","dotm","docb": return "Word".image();
        case "xls","xlsb","xlsm","xlsx": return "Excel".image();
        case "sldx","pptx","pptm","potx","potm","ppam","ppsx","ppsm": return "PowerPoint".image();
        case "png","jpg","jpeg" : return "PowerPoint".image();
        default : return "Folder".image();
        }
    }
    
    /*
     
     .pptx – PowerPoint presentation.
     .pptm – PowerPoint macro-enabled presentation.
     .potx – PowerPoint template.
     .potm – PowerPoint macro-enabled template.
     .ppam – PowerPoint add-in.
     .ppsx – PowerPoint slideshow.
     .ppsm – PowerPoint macro-enabled slideshow.
     .sldx
     
     xls    Microsoft Excel 5.0/95 Workbook
     .xlsb    Excel Binary Workbook
     .xlsm    Excel Macro-Enabled Workbook
     .xlsx
     .docx – Word document.
     .docm – Word macro-enabled document; same as docx, but may contain macros and scripts.
     .dotx – Word template.
     .dotm – Word macro-enabled template; same as dotx, but may contain macros and scripts.
     .docb
     */
    
    func getHeightDisplay()->CGFloat
    {
        if(parent == nil)
        {
            return 0 ;
        }
        if(isOpen())
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return 0
        }
    }
    
    func closeExpand()
    {
        isExpand = false
        for item in child
        {
            item.closeExpand()
        }
    }
    
    func root()->MediaFile?
    {
        if(parent == nil)
        {
            return self;
        }
        else
        {
            return parent!.root()
        }
    }
    
    func grossActive()
    {
        root()?.inActive()
        if(fileType == .folder)
        {
            active = true;
        }
    }
    
    func inActive()
    {
        active = false
        for item in child
        {
            item.inActive()
        }
    }
    func delete()
    {
        parent.child.remove(at:parent.child.index{$0 == self}!)
    }
    
    func grossIds()->[Int]
    {
        var result : [Int] = []
        result.append(id)
        for item in child
        {
          result.append(contentsOf: item.grossIds())
        }
        return result
    }

    func searchParent(_ value : Int)->MediaFile
    {
        var result : MediaFile!
        for item in child
        {
            if(item.id == value)
            {
                result = item
                break ;
            }else
            {
                result = item.searchParent(value)
                if(result != nil)
                {
                    break ;
                }
            }
        }
        return result
    }
}


class MediaFileInsert_Request : Mi
{
    @objc dynamic var destination = "";
    @objc dynamic var filename = "";
    @objc dynamic var user_id = userInstance.user.id;
    @objc dynamic var mimetype = "";
    @objc dynamic var originalname = "";
    @objc dynamic var path = "";
    @objc dynamic var parent_id = 0;

    @objc dynamic var size = 1;
    
     init(_ media : MediaFile)
    {
        super.init()
        self.destination = media.destination
        self.filename = media.filename
        self.mimetype = media.mimetype
        self.originalname = media.originalname
        self.path = media.path
        self.size = media.size
        
    }
    
    required public init() {
        super.init()
    }
    
}


class MediaFileDelete_Request : Mi
{
    @objc dynamic var user_id = userInstance.user.id
    @objc dynamic var file_ids : [Int] = []
}

class MediaFileList_Request : Mi
{
    @objc dynamic var user_id = userInstance.user.id
}


extension Services
{
    func fileInsert(_ request : MediaFileInsert_Request, success :@escaping ((MediaFile)->Void), failure: ((String)->Void))
    {
        services.request(api: .fileInsert, param: request.dictionary(), success: { (response) in
            
            let files = MediaFile.list(data: response.data as! [Dictionary<String, Any>])
            
            success(files[0])
        }) { (error) in
            
        }
    }
    
    func fileDelete(_ request : MediaFileDelete_Request, success :@escaping (()->Void), failure: ((String)->Void))
    {
        services.request(api: .fileDelete, param: request.dictionary(), success: { (response) in
            success()
        }) { (error) in
            
        }
    }

    
    func fileList(success :@escaping ((MediaFile)->Void), failure: @escaping ((String)->Void))
    {
        services.request(api: .fileList, param: MediaFileList_Request().dictionary(), success: { (response) in
            
            let list = MediaFile.list(data: response.data as! [Dictionary<String, Any>])
            let root  = MediaFile.init()
            root.isExpand = true ;
            for item in list
            {
                for sub in list
                {
                    if(sub.parent_id == item.id)
                    {
                        item.addChild([sub])
                    }
                }
                
                if(item.parent_id == 0)
                {
                    root.addChild([item])
                }
            }
            success(root)
        }) { (error) in
            failure("")
        }
    }
}
