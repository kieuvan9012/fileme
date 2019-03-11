//
//  Mi.swift
//  GProject
//
//  Created by KieuVan & LeHuuDung on 3/24/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit
//open class Mi: NSObject
//{
//
//
//    public override init()
//    {
//        super.init()
//    }
//   public init(dictionary : NSDictionary)
//    {
//        super.init()
//        var allKey = self.propertyNames()
//        for  i in 0..<allKey.count
//        {
//            let key = allKey[i]
//            if(dictionary[key] != nil)
//            {
//                if var value = dictionary[key]
//                {
//                    if(!(value  is NSNull))
//                    {
//                        if(value is String)
//                        {
//                            if((value as! String) == "<null>")
//                            {
//                                value = ""
//                            }
//                        }
//                        self.setValue(value , forKey: key )
//                    }
//                }
//            }
//        }
//    }
//
//    public init(dictionary : NSDictionary, ignore : [String])
//    {
//        super.init()
//        var allKey = self.propertyNames()
//        for  i in 0..<allKey.count
//        {
//
//            let key = allKey[i]
//
//            for ignTiem  in ignore
//            {
//                if(key == ignTiem)
//                {
//                    continue;
//                }
//
//            }
//            if(dictionary[key] != nil)
//            {
//                if var value = dictionary[key]
//                {
//                    if(!(value  is NSNull))
//                    {
//                        if(value is String)
//                        {
//                            if((value as! String) == "<null>")
//                            {
//                                value = ""
//                            }
//                        }
//                        self.setValue(value , forKey: key )
//                    }
//                }
//            }
//        }
//    }
//
//
//    public func dictionary() ->Dictionary<String,AnyObject >
//    {
//        var dict = Dictionary<String, Any>()
//        let allKey = propertyNames()
//        for  i in 0..<allKey.count
//        {
//            dict[allKey[i]] = value(forKey: allKey[i])
//        }
//        return dict as Dictionary<String, AnyObject>;
//    }
//
//    public func dictionary(ignore : [String]) ->Dictionary<String,AnyObject >
//    {
//        var dict = Dictionary<String, Any>()
//        let allKey = propertyNames()
//        for  i in 0..<allKey.count
//        {
//
//
//
//
//            if ignore.contains(allKey[i]) {
//                continue
//            }
//
//
//
//            dict[allKey[i]] = value(forKey: allKey[i])
//        }
//        return dict as Dictionary<String, AnyObject>;
//    }
//
//}
//
//public extension Mi
//{
//    public func propertyNames() -> [String]
//    {
//        return Mirror(reflecting: self).children.compactMap { $0.label }
//    }
//}


//
//  Mi.swift
//  GProject
//
//  Created by KieuVan & LeHuuDung on 3/24/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

open class Mi: NSObject {
    
    private static let RESPONSES = "responses"
    
    required public override init() {
        super.init()
    }
    
    public init(dictionary : NSDictionary, ignore : [String])
    {
        super.init()
        var allKey = self.getPropertyNames(mirror: nil)
        for  i in 0..<allKey.count
        {

            let key = allKey[i]

            for ignTiem  in ignore
            {
                if(key == ignTiem)
                {
                    continue;
                }

            }
            if(dictionary[key] != nil)
            {
                if var value = dictionary[key]
                {
                    if(!(value  is NSNull))
                    {
                        if(value is String)
                        {
                            if((value as! String) == "<null>")
                            {
                                value = ""
                            }
                        }
                        self.setValue(value , forKey: key )
                    }
                }
            }
        }
    }

  
    
    
    
    
    
    public init(dictionary : NSDictionary)
    {
        super.init()
        var allKey = self.getPropertyNames(mirror: nil)
        for  i in 0..<allKey.count
        {
            let key = allKey[i]
            if(dictionary[key] != nil)
            {
                if var value = dictionary[key]
                {
                    if(!(value  is NSNull))
                    {
                        if(value is String)
                        {
                            if((value as! String) == "<null>")
                            {
                                value = ""
                            }
                        }
                        self.setValue(value , forKey: key )
                    }
                }
            }
        }
    }
    
    
    
    public func dictionary(ignore : [String]) ->Dictionary<String,AnyObject >
    {
        var dict = Dictionary<String, Any>()
        let allKey = getPropertyNames(mirror: nil)
        for  i in 0..<allKey.count
        {
            if ignore.contains(allKey[i]) {
                continue
            }
            dict[allKey[i]] = value(forKey: allKey[i])
        }
        return dict as Dictionary<String, AnyObject>;
    }

    // MARK: Check methods
    func checkKey(_ key: String) -> String {
        if key.hasPrefix("_") {
            var newKey = key
            newKey.remove(at: key.startIndex)
            return newKey
        }
        return key
    }
    
    // MARK: Getter methods
    func getClassName(_ className: String) -> String {
        return "\(Bundle.main.infoDictionary!["CFBundleExecutable"] as! String).\(className)"
    }
    
    func getPropertyClassFromClassName(_ className: String) -> Mi.Type
    {
        let anyobjectype : AnyObject.Type = NSClassFromString(className)!
        let nsobjectype : Mi.Type = anyobjectype as! Mi.Type
        return nsobjectype
    }
    
    func getPropertyClassFromName(_ name: String) -> Mi? {
        if let className = getPropertyTypeStringOfName(name) {
            return getPropertyClassFromClassName(className).init()
        }
        return nil
    }
    
    func getPropertyTypeStringOfName(_ name: String) -> String? {
        for child in Mirror(reflecting:self).children {
            if child.label! == name {
                return getClassName(String(describing: type(of: child.value)))
            }
        }
        return nil
    }
    
    // MARK: Getter methods (Public)
    public func getPropertyNames(mirror: Mirror?) -> [String] {
        var result = [String]()
        let type = mirror ?? Mirror(reflecting: self)
        result.append(contentsOf: type.children.compactMap { $0.label })
        if let parent = type.superclassMirror {
            result.append(contentsOf: getPropertyNames(mirror: parent))
        }
        return result
    }
    
    
    public func propertyNamesOriginal() -> [String]
    {
        return Mirror(reflecting: self).children.compactMap{ $0.label }
    }
    
    public func dictionary() ->Dictionary<String,AnyObject>
    {
        var dict = Dictionary<String, Any>()
        let allKey = getPropertyNames(mirror: nil)
        for  i in 0..<allKey.count
        {
            dict[allKey[i]] = value(forKey: allKey[i])
        }
        return dict as Dictionary<String, AnyObject>;
    }
    
}



