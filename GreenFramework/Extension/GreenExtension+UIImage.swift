//
//  GreenExtension+UIImage.swift
//  Green
//
//  Created by KieuVan on 2/17/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView
{
    func setSD(_ url : String)
    {
        let tempURl = url.replacingOccurrences(of: "200x200", with: "800x800")
        sd_setImage(with: URL(string: tempURl), placeholderImage: "userbackground.jpg".image(), options: .refreshCached)
    }

}

extension UIImage {
    
    
    
    func logSize()
    {
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((self), 1)!)
        var imageSize: Int = imgData.length
        print("size of image in KB: %f ", Double(imageSize) / 1024.0)
    }
    
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        
        if(self.size.width < width)
        {
            return self
        }
        
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

public extension  UIImage {


    public func dataValue() -> Data
    {
        
        if(isPNG())
        {
            return UIImagePNGRepresentation(self)!
        }
        else
        {
            return UIImageJPEGRepresentation(self, 1)!
            
            
        }
    }
    public func resizeImage() -> UIImage
    {
        var actualHeight:Float = Float(self.size.height)
        var actualWidth:Float = Float(self.size.width)
        
        
        if(Int(actualHeight) > 800 || Int(actualWidth) > 800)
        {
        }
        else
        {
            return self;
        }
        let maxHeight:Float = 800 //your choose height
        let maxWidth:Float = (maxHeight/actualHeight)*actualWidth  //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: Int(actualWidth), height: Int(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImagePNGRepresentation(img)!
        UIGraphicsEndImageContext()
        return UIImage(data: imageData)!
    }
    
    public func tint(_ color:UIColor)->UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        context!.scaleBy(x: 1.0, y: -1.0)
        context!.translateBy(x: 0.0, y: -self.size.height)
        
        context!.setBlendMode(CGBlendMode.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context!.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    public func isPNG() -> Bool
    {
        if(imageType() == ".png")
        {
            return true
        }
        else
        {
            return false;
        }
        
    }
    public func imageWithColor(_ color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    public func imageType() -> String
    {
        
        
        let imageData: Foundation.Data = UIImagePNGRepresentation(self)!
        var c = [UInt8](repeating: 0, count: 1)
        (imageData as NSData).getBytes(&c, length: 1)
        
        let ext : String
        
        switch (c[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "" //unknown
        }
        return ext
    }
    
    public func imageData () -> Foundation.Data
    {
        return  UIImagePNGRepresentation(self)!
    }
    
    public func imageBase64() -> String!
    {
        let imageData : Foundation.Data = UIImagePNGRepresentation(self)!
        return imageData.base64EncodedString(options: Foundation.Data.Base64EncodingOptions(rawValue: 0))
    }
    
    
    public func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}

extension UIImage
{
    var highestQualityJPEGNSData: Data { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData: Data    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: Data     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.0)!  }
}





