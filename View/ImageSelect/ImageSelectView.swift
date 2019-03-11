//
//  ImageSelectView.swift
//  LimeBook
//
//  Created by Lê Dũng on 8/26/18.
//  Copyright © 2018 limerence. All rights reserved.
//

import UIKit

class ImageSelect: NSObject {
    var image : UIImage!
    var imageURL = ""
    var isLocal = true
    
    init(_ image : UIImage)
    {
        self.image = image
        isLocal = true
    }
    
    init(_ url : String)
    {
        self.imageURL = url
        isLocal = false
    }

}

protocol ImageSelectViewDelegate {
    
}


import  Gallery

class ImageSelectView: GreenView, UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GalleryControllerDelegate, ImageSelectCellDelegate{
    
    var delegate : ImageSelectViewDelegate!
    let width = (device.screenSize.width - 30 )/4
    let margin = 12.0;
    @IBOutlet weak var clView: UICollectionView!
    
    @IBOutlet weak var height: NSLayoutConstraint!

    
    var images : [ImageSelect] = []
    
    override func initStyle() {
        view.backgroundColor = template.backgroundColor
        
        clView.setIdentifier("ImageSelectCell")
        clView.setIdentifier("ImageSelectCell_Empty")

        clView.delegate = self;
        clView.dataSource = self;
        
        height.constant = width + CGFloat(( margin * 2.0 ))
    }
    
    
    
    func fillImage(_ values : [String])
    {
        self.images.removeAll()
        for item in values
        {
            self.images.append(ImageSelect.init(item))
        }
        self.clView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.row == 0)
        {
            let cell = clView.dequeueReusableCell(withReuseIdentifier: "ImageSelectCell_Empty", for: indexPath) as! ImageSelectCell_Empty
            
            return cell
        }
        else
        {
            let cell = clView.dequeueReusableCell(withReuseIdentifier: "ImageSelectCell", for: indexPath) as! ImageSelectCell
            cell.set(self.images[indexPath.row - 1])
            cell.delegate = self;
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0 )
        {
            callLibrary()
        }
    }
    
    func callLibrary()
    {
        let gallery = GalleryController()
        Config.tabsToShow = [Config.GalleryTab.cameraTab,Config.GalleryTab.imageTab]
        Config.Camera.imageLimit = 4;
        Config.Grid.CloseButton.tintColor = template.primaryColor
        Config.Grid.ArrowButton.tintColor = template.primaryColor
        gallery.delegate = self
        viewController()?.present(gallery, animated: false, completion: nil)
    }

    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        for image in images
        {
            image.resolve { (png) in
                self.images.append(ImageSelect.init(png!))
                self.clView.reloadData()
                
            }
        }
        
        
        controller.dismiss()
    }
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss()

    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss()

    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: width, height: width)
    }
    
    func getImage()->[ImageSelect]
    {
        return images
    }
    
    func hasImages() -> Bool
    {
        return (images.count > 0)
    }
    
    
    func getImageServices()->[UIImage]
    {
        var output : [UIImage] = []
        
        for item in images
        {
            if(!item.isLocal)
            {
                output.append(item.image)
            }
        }
        return output
    }

    
    
    func clear()
    {
        self.images.removeAll()
        self.clView.reloadData()
    }

    func imageSelectCellDelete(_ imgSelect: ImageSelect) {
        
        let indexImage = self.images.index(of: imgSelect)
        self.images.remove(at: indexImage!)
        
        
        self.clView.reloadData()
    }
    
    
    
}
