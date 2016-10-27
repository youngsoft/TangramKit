//
//  LLTest4ViewController.swift
//  TangramKit
//
//  Created by yant on 10/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class LLTest4ViewController: UIViewController {

    weak var rootLayout :TGLinearLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func loadView() {
        
        /*
         这个例子详细说明tg_width, tg_height设置为.wrap的意义、以及边界线性的设定、以及布局中可局部缩放背景图片的设定方法。
         */

        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .gray
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.wrap)
        rootLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.tg_vspace = 5
        self.view.addSubview(rootLayout)
        self.rootLayout = rootLayout
        
        self.rootLayout.addSubview(self.addWrapContentLayout())
    }
    
    
    
}

//MARK: - Layout Construction
extension LLTest4ViewController
{
    internal func addWrapContentLayout() -> TGLinearLayout
    {
        let wrapContentLayout = TGLinearLayout(.horz)
        wrapContentLayout.layer.contentsCenter = CGRect(x: 0.1, y: 0.1, width: 0.5, height: 0.5)
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        wrapContentLayout.tg_hspace = 5
        
        /*
         布局视图的tg_backgroundImage的属性的内部实现是通过设置视图的layer的content属性来实现的。因此如果我们希望实现具有拉升效果的
         背景图片的话。则可以设置布局视图的layer.contentCenter属性。这个属性的意义请参考CALayer方面的介绍。
         */
        wrapContentLayout.tg_backgroundImage = UIImage(named: "bk2")
        
        //四周的边线
        wrapContentLayout.tg_boundBorderline = TGLayoutBorderline(color: .green, headIndent:10, tailIndent:30)
        
        
        let actionLayout = TGLinearLayout(.vert)
        actionLayout.backgroundColor = .blue
        actionLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        actionLayout.tg_vspace = 5
        actionLayout.tg_width.equal(.wrap)
        actionLayout.tg_height.equal(.wrap)
        wrapContentLayout.addSubview(actionLayout)
        
        
        actionLayout.addSubview(self.addActionButton(NSLocalizedString("add vert layout", comment:"") ,tag:100))
        actionLayout.addSubview(self.addActionButton(NSLocalizedString("add vert button", comment:""), tag:500))
        
        
        wrapContentLayout.addSubview(self.addActionButton(NSLocalizedString("add horz button", comment:""), tag:200))
        wrapContentLayout.addSubview(self.addActionButton(NSLocalizedString("remove layout", comment:""), tag:300))
        
        return wrapContentLayout
        
    }
    
    
    internal func addActionButton(_ title: String , tag :NSInteger) -> UIButton
    {
        let button = UIButton(type:.system)
        button.backgroundColor = .green
        button.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        button.setTitle(title ,for:.normal)
        button.tag = tag
        button.tg_height.equal(50)
        button.tg_width.equal(110)
        
        return button
    }


    
}

//MARK: - Handle Method
extension LLTest4ViewController
{
    internal func handleAction(_ sender :UIButton)
    {
        if (sender.tag == 100)
        {
            self.rootLayout.addSubview(self.addWrapContentLayout())
        }
        else if (sender.tag == 200)
        {
            let actionLayout = sender.superview as! TGLinearLayout
            actionLayout.addSubview(self.addActionButton(NSLocalizedString("remove self", comment:""), tag:400))
        }
        else if (sender.tag == 300)
        {
            let actionLayout = sender.superview as! TGLinearLayout
            actionLayout.removeFromSuperview()
        }
        else if (sender.tag == 400)
        {
            sender.removeFromSuperview()
        }
        else if (sender.tag == 500)
        {
            let addLayout = sender.superview as! TGLinearLayout
            addLayout.addSubview(self.addActionButton(NSLocalizedString("remove self", comment:""), tag:400))
            
        }
        
    }

}

