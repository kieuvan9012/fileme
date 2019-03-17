//
//  InterfaceDataStore.swift
//  LimeBook
//
//  Created by Lê Dũng on 9/29/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit
let  interfaceDataStore = InterfaceDataStore.sharedInstance()

class InterfaceDataStore: NSObject {
    static var instance: InterfaceDataStore!

    var emoj : [String] = []

    class func sharedInstance() -> InterfaceDataStore
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? InterfaceDataStore())
            self.instance.loadEmoj()
        }
        return self.instance
    }
    
    func loadEmoj()
    {
        for item in 0...53
        {
            if(item < 10 )
            {
                emoj.append("["+"emj" + "0" + String(item)+"]")
            }
            else
            {
                emoj.append("["+"emj"+String(item)+"]")
            }
        }
    }
}
