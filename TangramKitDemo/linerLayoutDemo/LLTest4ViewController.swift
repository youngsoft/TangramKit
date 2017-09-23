//
//  LLTest4ViewController.swift
//  TangramKit
//
//  Created by yant on 10/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *4.LinearLayout - Wrap content
 */
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

        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
        
        super.loadView()
        
        let contentView = UIView()
        contentView.backgroundColor = CFTool.color(5)
        self.view.addSubview(contentView)
        contentView.tg_width.equal(.wrap)
        contentView.tg_height.equal(.wrap)   //如果一个非布局父视图里面有布局子视图，那么这个非布局父视图也是可以将高度和宽度设置为.wrap的，他表示的意义是这个非布局父视图的尺寸由里面的布局子视图的尺寸来决定的。还有一个场景是非布局父视图是一个UIScrollView。他是左右滚动的，但是滚动视图的高度是由里面的布局子视图确定的，而宽度则是和窗口保持一致。这样只需要将滚动视图的宽度设置为和屏幕保持一致，高度设置为.wrap，并且把一个水平线性布局添加到滚动视图即可。
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.layer.borderWidth = 1
        rootLayout.layer.borderColor = UIColor.lightGray.cgColor
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.wrap)
        rootLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.tg_zeroPadding = false   //这个属性设置为false时表示当布局视图的尺寸是wrap也就是由子视图决定时并且在没有任何子视图是不会参与布局视图高度的计算的。您可以在这个DEMO的测试中将所有子视图都删除掉，看看效果，然后注释掉这句代码看看效果。
        rootLayout.tg_vspace = 5
        contentView.addSubview(rootLayout)
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
        wrapContentLayout.tg_height.equal(.wrap)
        wrapContentLayout.tg_width.equal(.wrap)
        wrapContentLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        wrapContentLayout.tg_hspace = 5
        
        /*
         布局视图的tg_backgroundImage的属性的内部实现是通过设置视图的layer的content属性来实现的。因此如果我们希望实现具有拉升效果的
         背景图片的话。则可以设置布局视图的layer.contentCenter属性。这个属性的意义请参考CALayer方面的介绍。
         */
        wrapContentLayout.tg_backgroundImage = UIImage(named: "bk2")
        wrapContentLayout.layer.contentsCenter = CGRect(x: 0.1, y: 0.1, width: 0.5, height: 0.5)
        
        //四周的边线
        wrapContentLayout.tg_boundBorderline = TGBorderline(color: .red, headIndent:10, tailIndent:30)
        
        
        let actionLayout = TGLinearLayout(.vert)
        actionLayout.layer.borderWidth = 1
        actionLayout.layer.borderColor = CFTool.color(9).cgColor
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
        button.addTarget(self ,action:#selector(handleAction), for:.touchUpInside)
        button.setTitle(title ,for:.normal)
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.font = CFTool.font(14)
        button.backgroundColor = CFTool.color(14)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.tag = tag
        button.tg_height.equal(50)
        button.tg_width.equal(80)
        
        return button
    }


    
}

//MARK: - Handle Method
extension LLTest4ViewController
{
    @objc internal func handleAction(_ sender :UIButton)
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

