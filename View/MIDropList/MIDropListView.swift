//
//  MIDropListView.swift
//  MTS
//
//  Created by Lê Dũng on 12/18/18.
//  Copyright © 2018 InnoTech. All rights reserved.
//

import UIKit


class MIDropListView: GreenView , UITableViewDelegate,UITableViewDataSource
{
    private let heightCell : CGFloat = 40
    private var _targetFrame : CGRect = CGRect.init()
    private var _controller : UIViewController!
    private var _dropListTableView: MIDropListTableView?
    private var _showView : UIView!
    private var _value : [String] = []
    private var _selectedValue = ""
    private var _selectedIndex = 0
    
    @IBOutlet weak var rightWidth: NSLayoutConstraint!
    
    private var selectedBlock : ((String)->Void)!
    private var selectedIndexBlock : ((Int)->Void)!

    @IBOutlet private var contentView : UIView!
    @IBOutlet  var tfContent : UILabel!

    var selectedValue : String{
        set {
            _selectedValue = newValue
            updateSelectedValue()
        }
        get {
            return _selectedValue
        }
    }

    var alignment : NSTextAlignment{
        set {
            tfContent.textAlignment = newValue
        }
        get {
            return tfContent.textAlignment
        }
    }
    
    var value : [String]!{
        set {
            _value.removeAll()
            
            _value.append(contentsOf: newValue)
        }
        get {
            return _value
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            return super.hitTest(point, with: event)
        }
        
        guard isUserInteractionEnabled, !isHidden, alpha > 0 else {
            return nil
        }
        return nil
    }
    
    func set(_ value : [String], inView : UIView?, selectBlock :@escaping ((String)->Void))
    {
        self.clearData()
        
        if(value.count == 0) {
            return
        }
        
        self._showView = inView
        self.value = value
        self.selectedBlock = selectBlock
        updateSelectedValue()
    }
    
    func clearData() {
        _selectedValue = ""
        _value.removeAll()
        tfContent.text = ""
        _dropListTableView?.tbView?.reloadData()
    }
    
    func setIndex(_ value : [String], inView : UIView?, selectIndexBlock :@escaping ((Int)->Void))
    {
        self.clearData()

        if(value.count == 0) {
            return
        }
        
        self._showView = inView
        self.value = value
        self.selectedIndexBlock = selectIndexBlock
        updateSelectedValue()
    }

    func prefer(_ value : [String])
    {
        self.value.removeAll()
        self.value.append(contentsOf: value)
        self._dropListTableView?.tbView?.reloadData()
    }
    func updateSelectedValue()
    {
        if(_selectedValue.isEmpty)
        {
            if(_value.count > 0)
            {
                _selectedIndex = 0
                _selectedValue = value[_selectedIndex]
                tfContent.text = _selectedValue
            }
        }
        else
        {
            if let targetIndex = value.index(where: {$0 == _selectedValue})
            {
                _selectedIndex = targetIndex
                _selectedValue = value[_selectedIndex]
                tfContent.text = _selectedValue
            }
        }
    }
    
    override func initStyle() {
        tfContent.textAlignment = .center
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: UIDevice.orientationDidChangeNotification, object: nil)
        backgroundColor = UIColor.white

    }
    
    func updateFrame()
    {
        if(_dropListTableView != nil)
        {
            
        }
    }
    
    @IBAction func touchIn(_ sender: Any)
    {
        if(_showView == nil) {
            return
        }
        
        _targetFrame = _showView.convert(self.bounds, from: self)
        _targetFrame.origin.y = _targetFrame.origin.y + self.frame.size.height
        _targetFrame.size.height = getHeightContent()
        _targetFrame.size.width = _targetFrame.size.width + 30
        
        if(_dropListTableView == nil)
        {
            _dropListTableView = MIDropListTableView.init(frame: CGRect.init())
            _dropListTableView?.backgroundColor = UIColor.white
            _dropListTableView?.tbView?.delegate = self
            _dropListTableView?.tbView?.dataSource = self
            _dropListTableView?.tbView?.register(UINib.init(nibName: "MIDropListCell", bundle: Bundle.main), forCellReuseIdentifier: "MIDropListCell")
            _showView.addSubview(_dropListTableView!)
            _dropListTableView?.dropListView = self
            _dropListTableView?.isHidden = true
        }
        
        _dropListTableView?.frame = _targetFrame
        _dropListTableView?.isHidden = !(_dropListTableView!.isHidden)
        reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    @objc func dismissView()
    {
        _dropListTableView?.isHidden = true
    }
    
    func reloadData()
    {
        _dropListTableView?.tbView?.reloadData()
    }
    
    func getHeightContent()->CGFloat
    {
        return heightCell * CGFloat(_value.count) + 9.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         _selectedValue = _value[indexPath.row]
        _selectedIndex = indexPath.row
        tfContent.text = _selectedValue
        
        if(selectedBlock != nil)
        {
            selectedBlock(_selectedValue)
        }
        
        if(selectedIndexBlock != nil)
        {
            selectedIndexBlock(_selectedIndex)
        }
        dismissView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MIDropListCell") as! MIDropListCell
        
        cell.imgCheckMark.isHidden = true
        if (_selectedIndex == indexPath.row) {
            cell.imgCheckMark.isHidden = false
        }
        cell.set(_value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  heightCell
    }
    
    func disable()
    {
        isUserInteractionEnabled = false
        alpha = 0.68
    }
    
    func enable()
    {
        isUserInteractionEnabled = true
        alpha = 1
    }
}
