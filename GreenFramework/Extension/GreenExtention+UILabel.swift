//
//  GreenExtention+UILabel.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension UILabel
{
    public func setStyle(_ style : TextStyle)
    {
        self.font = greenDefine.getFontStyle(style).font
        self.textColor = greenDefine.getFontStyle(style).color
    }
    
    public func setBold()
    {
        self.font = UIFont(name: greenDefine.GreenFontBold.fontName, size: self.font.pointSize)
    }

}

extension UILabel
{
    var textR: String? {
        
        get { return text }
        set {
            
            if(newValue?.isEmpty)!
            {
                text = "-"
            }
            else
            {
                text = newValue
            }
        }
    }
    
}





extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedStringKey.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedStringKey.font: moreTextFont, NSAttributedStringKey.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedStringKey.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedStringKey : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedStringKey : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}


class UILabelGeneral : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()

    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}

class UILabelSub : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        
    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}

class UILabelHighlight : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        
    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}
