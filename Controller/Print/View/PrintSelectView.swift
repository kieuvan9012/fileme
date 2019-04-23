//
//  PrintSelectView.swift
//  File Me
//
//  Created by Lê Dũng on 3/15/19.
//

import UIKit

protocol PrintSelectViewDelegate: class  {
    func printSelectViewAdd()
    func printSelectViewUpdateSelect()
}

class PrintSelectView: GreenView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate : PrintSelectViewDelegate?
    var selectIndex = -1
    private var  _count = 0
    
    var counting : Int{
        set{
            _count = newValue
            if(selectIndex == -1)
            {
                selectIndex = 0
            }
            clView.reloadData()
        }
        get
        {
            return _count
        }
    }
    
    @IBOutlet weak var clView: UICollectionView!
    override func initStyle() {
        clView.delegate = self;
        clView.dataSource = self;
        clView.setIdentifier("PrintSelectCell")
        
        roundView.drawRound()
        roundView.backgroundColor = template.primaryColor
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clView.dequeueReusableCell(withReuseIdentifier: "PrintSelectCell", for: indexPath) as! PrintSelectCell
        if(self.selectIndex == indexPath.row)
        {
            cell.active()
        }
        else
        {
            cell.inActive()
        }
        cell.set(String(indexPath.row + 1))
        return cell 
    }
    
    @IBAction func touchInAdd(_ sender: Any) {
        delegate?.printSelectViewAdd()
    }
    
    @IBOutlet weak var roundView: UIView!
    
    func setIndex(_ value : Int)
    {
        self.selectIndex = value ;
        clView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectIndex = indexPath.row
        clView.reloadData()
        
        delegate?.printSelectViewUpdateSelect()

        
    }
}
