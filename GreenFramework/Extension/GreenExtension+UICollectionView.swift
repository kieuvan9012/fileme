//
//  GreenExtension+UICollectionView.swift
//  Mobile_68
//
//  Created by Lê Dũng on 6/27/18.
//  Copyright © 2018 Ledung. All rights reserved.
//

import UIKit

extension UICollectionView {

    func setIdentifier(_ value : String)
    {
       register(UINib.init(nibName:value, bundle: Bundle.main), forCellWithReuseIdentifier: value)
    }
}
