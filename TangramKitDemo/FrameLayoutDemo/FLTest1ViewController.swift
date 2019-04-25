//
//  FLTest1ViewController.swift
//  TangramKit
//
//  Created by yant on 28/4/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 * 1.FrameLayout - Gravity&Fill
 */
class FLTest1ViewController: UIViewController {

    
    override func loadView() {
        
        
        /*
         使用TangramKit时必读的知识点：
         
         
         1.布局视图：    就是从TGBaseLayout派生而出的视图，目前TangramKit中一共有：线性布局、框架布局、相对布局、表格布局、流式布局、浮动布局、路径布局7种布局。 布局视图也是一个视图。
         2.非布局视图：  除上面说的7种布局视图外的所有视图和控件。
         3.布局父视图：  如果某个视图的父视图是一个布局视图，那么这个父视图就是布局父视图。
         4.非布局父视图：如果某个视图的父视图不是一个布局视图，那么这个父视图就是非布局父视图。
         5.布局子视图：  如果某个视图的子视图是一个布局视图，那么这个子视图就是布局子视图。
         6.非布局子视图：如果某个视图的子视图不是一个布局视图，那么这个子视图就是非布局子视图。
         
         
         
         这要区分一下边距和间距和概念，所谓边距是指子视图距离父视图的距离；而间距则是指子视图距离兄弟视图的距离。
         当tg_leading,tg_trailing,tg_top,tg_bottom这四个属性的equal方法设置的值为CGFloat类型或者TGWeight类型时即可用来表示边距也可以用来表示间距，这个要根据子视图所归属的父布局视图的类型而确定：
         
         1.垂直线性布局TGLinearLayout中的子视图： tg_leading,tg_trailing表示边距，而tg_top,tg_bottom则表示间距。
         2.水平线性布局TGLinearLayout中的子视图： tg_leading,tg_trailing表示间距，而tg_top,tg_bottom则表示边距。
         3.表格布局中的子视图：                  tg_leading,tg_trailing,tg_top,tg_bottom的定义和线性布局是一致的。
         4.框架布局TGFrameLayout中的子视图：     tg_leading,tg_trailing,tg_top,tg_bottom都表示边距。
         5.相对布局TGRelativeLayout中的子视图：  tg_leading,tg_trailing,tg_top,tg_bottom都表示边距。
         6.流式布局TGFlowLayout中的子视图：      tg_leading,tg_trailing,tg_top,tg_bottom都表示间距。
         7.浮动布局TGFloatLayout中的子视图：     tg_leading,tg_trailing,tg_top,tg_bottom都表示间距。
         8.路径布局TGPathLayout中的子视图：      tg_leading,tg_trailing,tg_top,tg_bottom即不表示间距也不表示边距，它表示自己中心位置的偏移量。
         9.非布局父视图中的布局子视图：           tg_leading,tg_trailing,tg_top,tg_bottom都表示边距。
         10.非布局父视图中的非布局子视图：         tg_leading,tg_trailing,tg_top,tg_bottom的设置不会起任何作用，因为TangramKit已经无法控制了。
         
         再次强调的是：
         1. 如果同时设置了左右边距就能决定自己的宽度，同时设置左右间距不能决定自己的宽度！
         2. 如果同时设置了上下边距就能决定自己的高度，同时设置上下间距不能决定自己的高度！
         
         */
        

        
        
        /*
         这个例子主要介绍了框架布局的功能。框架布局里面的所有子视图的布局位置都只跟框架布局相关。
         框架布局中的子视图可以层叠显示，因此框架布局常用来作为视图控制器里面的根视图。
         */

        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        super.loadView()
        
        let frameLayout = TGFrameLayout()
        frameLayout.backgroundColor = .white
        frameLayout.tg_margin(TGLayoutPos.tg_safeAreaMargin)
        frameLayout.tg_padding = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        self.view.addSubview(frameLayout)
        
        //全部填充。 all fill subview
        let fill = self.createLabel("", backgroundColor: CFTool.color(0))
        fill.tg_width.equal(.fill)
        fill.tg_height.equal(.fill)  //宽度和高度都填充父视图的全部空间
        frameLayout.addSubview(fill)
        
        //左右填充。 width fill subview
        let horzFill = self.createLabel("horz fill", backgroundColor: CFTool.color(8))
        horzFill.tg_top.equal(40)  //这里偏移40为了看清楚一些。
        horzFill.tg_width.equal(.fill)
        horzFill.tg_height.equal(.wrap)
        frameLayout.addSubview(horzFill)
        
        //上下填充。 height fill subview
        let vertFill = self.createLabel("vert fill", backgroundColor: CFTool.color(9))
        vertFill.numberOfLines = 0;
        vertFill.tg_leading.equal(90)  //这里偏移90为了看清楚一些。
        vertFill.tg_width.equal(10)
        vertFill.tg_height.equal(.fill)
        frameLayout.addSubview(vertFill)
        
        
        //左上。 top leading subview
        let topLeft = self.createLabel("top leading", backgroundColor: CFTool.color(5))
        topLeft.tg_top.equal(0)
        topLeft.tg_leading.equal(0)
        frameLayout.addSubview(topLeft)
        
        //左中。center leading subview
        let centerLeft = self.createLabel("center leading", backgroundColor: CFTool.color(5))
        centerLeft.tg_centerY.equal(0)
        centerLeft.tg_leading.equal(0)
        frameLayout.addSubview(centerLeft)
        
        //左下。bottom leading subview
        let bottomLeft = self.createLabel("bottom leading", backgroundColor: CFTool.color(5))
        bottomLeft.tg_bottom.equal(0)
        bottomLeft.tg_leading.equal(0)
        frameLayout.addSubview(bottomLeft)
        
        
        //中上。  top center subview
        let topCenter = self.createLabel("top center", backgroundColor: CFTool.color(6))
        topCenter.tg_top.equal(0)
        topCenter.tg_centerX.equal(0)
        frameLayout.addSubview(topCenter)
        
        
        //中中。 center center subview
        let centerCenter = self.createLabel("center center", backgroundColor: CFTool.color(6))
        centerCenter.tg_centerY.equal(0)
        centerCenter.tg_centerX.equal(0)
        frameLayout.addSubview(centerCenter)
        
        
        //中下。 bottom center subview
        let bottomCenter = self.createLabel("bottom center", backgroundColor: CFTool.color(6))
        bottomCenter.tg_bottom.equal(0)
        bottomCenter.tg_centerX.equal(0)
        frameLayout.addSubview(bottomCenter)
        
        
        //右上。 top trailing subview
        let topRight = self.createLabel("top trailing", backgroundColor: CFTool.color(7))
        topRight.tg_top.equal(0)
        topRight.tg_trailing.equal(0)
        frameLayout.addSubview(topRight)
        
        
        //右中。center trailing subview
        let centerRight = self.createLabel("center trailing", backgroundColor: CFTool.color(7))
        centerRight.tg_centerY.equal(0)
        centerRight.tg_trailing.equal(0)
        frameLayout.addSubview(centerRight)
        
        //右下。 bottom trailing subview
        let bottomRight = self.createLabel("bottom trailing", backgroundColor: CFTool.color(7))
        bottomRight.tg_bottom.equal(0)
        bottomRight.tg_trailing.equal(0)
        frameLayout.addSubview(bottomRight)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLabel(_ title: String, backgroundColor color: UIColor) -> UILabel {
        let v = UILabel()
        v.text = title
        v.font = CFTool.font(15)
        v.textAlignment = .center
        v.backgroundColor = color
        v.layer.shadowOffset = CGSize(width: CGFloat(3), height: CGFloat(3))
        v.layer.shadowColor! = CFTool.color(4).cgColor
        v.layer.shadowRadius = 2
        v.layer.shadowOpacity = 0.3
        v.sizeToFit()
        return v
    }

    
    
}
