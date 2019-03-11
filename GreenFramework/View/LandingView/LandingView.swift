//
//  LandingView.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/17/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit

class LandingView: GreenView , UIPageViewControllerDelegate, UIPageViewControllerDataSource
{

    let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers : [UIViewController] = []
    
    @IBOutlet weak var indicatorCenterConstrain: NSLayoutConstraint!
    @IBOutlet weak var indicatorBotContraits: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIPageControl!
    
    var  firstIndex = 0
    var currentIndex:Int = 0
    var nextIndex:Int = 0
    
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        NewsTableViewController *controller  = [pendingViewControllers firstObject];
//        self.nextIndex = [self.arrViews indexOfObject:controller];
//        
//        
//    }
    
    override func initStyle() {
        indicator.currentPageIndicatorTintColor = UIColor.red;
    }
    
    
    func initWithView(views : [UIView])
    {
        page.delegate = self;
        page.dataSource = self;

        indicator.numberOfPages = views.count;
        self.view.backgroundColor = UIColor.white;
        
        
        for view in views
        {
            let controller = UIViewController()
            view.frame = controller.view.bounds;
            controller.view.addSubview(view)
            controller.view.setLayout(view)
            viewControllers.append(controller)
        }
        
        
        page.view.frame = CGRect.init(x: 0, y: 0,width : self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(page.view);
        self.view.setLayout(page.view)
        
        page.setViewControllers([viewControllers[firstIndex]], direction: .forward, animated: true) { (nex) in
        }
        indicator.currentPage = firstIndex

        

        self.view.bringSubview(toFront: indicator)

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let index:Int = viewControllers.index(of: viewController)!;
        if(index == (viewControllers.count - 1 ))
        {
            return nil
        }
        else
        {
            return viewControllers[index + 1]
        }
    }
    @IBOutlet weak var paddingBottom: NSLayoutConstraint!
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index:Int  = viewControllers.index(of: viewController)!;
        if(index == 0)
        {
            return nil
        }
        else
        {
            return viewControllers[index - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let current : UIViewController = (pageViewController.viewControllers?.last)!
        let index  = viewControllers.index(of: current)
        indicator.currentPage = index!;
    }
    
    func setCurrentIndicatorColor(color : UIColor)
    {
        indicator.currentPageIndicatorTintColor = color;

    }
    
    func setIndicatorCenterPadding(padding: CGFloat) {
        indicatorCenterConstrain.constant = padding
    }
    
    func setPaddingBottom(bottom : CGFloat)
    {
        paddingBottom.constant = bottom
    }
}
