//
//  GreenExtension+String.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
extension Collection {
    func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}

public extension Array
{

    mutating func rearrange(from: Int, to: Int) {
            insert(remove(at: from), at: to)
    }
}
extension Array {
    
    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        
        var results = [Element]()
        
        forEach { (element) in
            
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
