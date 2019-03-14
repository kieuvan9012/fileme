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


enum FileType : String
{
    case folder =  "folder"
    case excel = "excel"
    case word = "word"
    case ppt = "ppt"
}


enum MediaBrand : Int
{
    case book = 2
    case info = 1
    case conference = 3
}

class MediaFile: Mi {
    
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
    
    @objc dynamic var destination = "";
    @objc dynamic var encoding = "";
    @objc dynamic var fieldname = "";
    @objc dynamic var filename = "";
    @objc dynamic var title = "";
    @objc dynamic var mimetype = "";
    @objc dynamic var originalname = "";
    @objc dynamic var path = "";
    @objc dynamic var size = 1;
    @objc dynamic var child : [MediaFile] = [];
    @objc dynamic var parent : MediaFile! ;
    
    
    var isExpand = false;
    var fileType  = FileType.folder;
    var isDowload = false ;
    var media_type = MediaType.image;
    var content : Any? ;
    
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
    
    override init(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
    }
    
    required init() {
        super.init()
    }
    
    func toggle()
    {
        isExpand = !isExpand
        if(!isExpand)
        {
            closeExpand()
        }
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
        switch fileType {
        case .folder: return "Folder".image();
        case .excel: return "Excel".image();
        case .word: return "Word".image();
        case .ppt: return "PowerPoint".image();
        }
    }
    
    func getHeightDisplay()->CGFloat
    {
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
}
