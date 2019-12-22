//
//  FLLTest8ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *8.FlowLayout - Flex space
 */
class FLLTest8ViewController: UIViewController {
    
    var vertLayout:TGFlowLayout! = nil
    var horzLayout:TGFlowLayout! = nil
    var vertLayout2:TGFlowLayout! = nil
    var horzLayout2:TGFlowLayout! = nil
    
    override func loadView() {
        
        /*
         这个例子主要用于展示流式布局的间距的可伸缩性。当我们布局视图中的子视图的宽度或者高度为固定值，但是其中的间距又希望是可以伸缩的，那么就可以借助流式布局提供的方法
         
         tg_setSubviews(size:CGFloat, minSpace:CGFloat, maxSpace:CGFloat = CGFloat.greatestFiniteMagnitude, centered:Bool = false, inSizeClass type:TGSizeClassType = TGSizeClassType.default)
         
         来设置子视图的尺寸，以及最小和最大的间距值。并且当布局视图中子视图的间距小于最小值时会自动调整子视图的尺寸来满足这个最小的间距。
         
         对于垂直流式布局来说，这个方法只用于设置子视图的宽度和水平间距。
         对于水平流式布局来说，这个方法只用于设置子视图的高度和垂直间距。
         
         
         你可以在这个界面中尝试一下屏幕的旋转，看看布局为了支持横屏和竖屏而进行的布局调整，以便达到最完美的布局效果。
         
         */
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0)  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
        
        //这里的根视图是一个每列只有一个子视图的垂直流式布局，效果就相当于垂直线性布局了。
        let rootLayout = TGFlowLayout(.vert, arrangedCount: 1)
        rootLayout.tg_gravity = .fill  //这里将tg_gravity设置为.fill表明子视图的宽度和高度都将平分这个流式布局，可见一个简单的属性设置就可以很容易的实现子视图的尺寸的设置，而不需要编写太复杂的约束。
        rootLayout.tg_space = 10
        rootLayout.backgroundColor = .white
        self.view = rootLayout
        
        
        //数量约束流式布局
        let vertLayout = TGFlowLayout(.vert, arrangedCount: 4)
        vertLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
        vertLayout.backgroundColor = CFTool.color(5)
        vertLayout.tg_vspace = 20
        vertLayout.tg_gravity = TGGravity.vert.fill  //因为上面tg_setSubviews设置了固定宽度，这个属性设置子视图的高度是填充满子布局视图，因此系统内部会自动设置每个子视图的高度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置高度。
        rootLayout.addSubview(vertLayout)
        self.vertLayout = vertLayout
        
        for i in 0 ..< 14
        {
             let label = UILabel()
            //label.tg_height.equal(60)  因为子视图的宽度在布局视图的tg_setSubviews中设置了，你也可以在这里单独为每个子视图设置高度，当然如果你的父布局视图使用了tg_gravity来设置填充属性的话，那么子视图是不需要单独设置高度尺寸的。
            label.text = "\(i)" //[NSString stringWithFormat:@"%d", i];
            label.textAlignment = .center
            label.backgroundColor = CFTool.color(2)
            vertLayout.addSubview(label)
        }
        
        
        
        let horzLayout = TGFlowLayout(.horz, arrangedCount: 4)
        horzLayout.tg_padding = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        horzLayout.backgroundColor = CFTool.color(6)
        horzLayout.tg_hspace = 20
        horzLayout.tg_gravity = TGGravity.horz.fill //因为上面tg_setSubviews设置了固定高度，这个属性设置子视图的宽度是填充满子布局视图，因此系统内部会自动设置每个子视图的宽度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置宽度。
        rootLayout.addSubview(horzLayout)
        self.horzLayout = horzLayout

        for i in 0 ..< 14
        {
            let label = UILabel()
            //label.tg_height.equal(60)  因为子视图的高度在布局视图的setSubviewsSize:minSpace:maxSpace:中设置了，你也可以在这里单独为每个子视图设置宽度，当然如果你的父布局视图使用了gravity来设置填充属性的话，那么子视图是不需要单独设置宽度尺寸的。
            label.text = "\(i)" //[NSString stringWithFormat:@"%d", i];
            label.textAlignment = .center
            label.backgroundColor = CFTool.color(3)
            horzLayout.addSubview(label)
        }
        
        //内容约束流式布局
        let vertLayout2 = TGFlowLayout(.vert, arrangedCount: 0)
        vertLayout2.tg_padding = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
        vertLayout2.backgroundColor = CFTool.color(5)
        vertLayout2.tg_vspace = 20
        vertLayout2.tg_gravity = TGGravity.vert.fill  //因为上面tg_setSubviews设置了固定宽度，这个属性设置子视图的高度是填充满子布局视图，因此系统内部会自动设置每个子视图的高度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置高度。
        rootLayout.addSubview(vertLayout2)
        self.vertLayout2 = vertLayout2
        
        for i in 0 ..< 14
        {
            let label = UILabel()
            //label.tg_height.equal(60)  因为子视图的宽度在布局视图的tg_setSubviews中设置了，你也可以在这里单独为每个子视图设置高度，当然如果你的父布局视图使用了tg_gravity来设置填充属性的话，那么子视图是不需要单独设置高度尺寸的。
            label.text = "\(i)" //[NSString stringWithFormat:@"%d", i];
            label.textAlignment = .center
            label.backgroundColor = CFTool.color(2)
            vertLayout2.addSubview(label)
        }
        
        
        
        let horzLayout2 = TGFlowLayout(.horz, arrangedCount: 0)
        horzLayout2.tg_padding = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        horzLayout2.backgroundColor = CFTool.color(6)
        horzLayout2.tg_hspace = 20
        horzLayout2.tg_gravity = TGGravity.horz.fill //因为上面tg_setSubviews设置了固定高度，这个属性设置子视图的宽度是填充满子布局视图，因此系统内部会自动设置每个子视图的宽度，如果你不设置这个属性，那么你就需要在下面分别为每个子视图设置宽度。
        rootLayout.addSubview(horzLayout2)
        self.horzLayout2 = horzLayout2
        
        for i in 0 ..< 14
        {
            let label = UILabel()
            //label.tg_height.equal(60)  因为子视图的高度在布局视图的setSubviewsSize:minSpace:maxSpace:中设置了，你也可以在这里单独为每个子视图设置宽度，当然如果你的父布局视图使用了gravity来设置填充属性的话，那么子视图是不需要单独设置宽度尺寸的。
            label.text = "\(i)" //[NSString stringWithFormat:@"%d", i];
            label.textAlignment = .center
            label.backgroundColor = CFTool.color(3)
            horzLayout2.addSubview(label)
        }
        
        //这个垂直流式布局中，每个子视图之间的水平间距是浮动的，并且子视图的宽度是固定为60。间距最小为10，最大不限制。
        vertLayout.tg_setSubviews(size:60, minSpace:10)
        //这个水平流式布局中，每个子视图之间的垂直间距是浮动的，并且子视图的高度是固定为60。间距最小为10，最大不限制。
        horzLayout.tg_setSubviews(size:60, minSpace:10)
        //这个垂直流式布局中，每个子视图之间的水平间距是浮动的，并且子视图的宽度是固定为60。间距最小为10，最大不限制。
        vertLayout2.tg_setSubviews(size:60, minSpace:10)
        //这个水平流式布局中，每个子视图之间的垂直间距是浮动的，并且子视图的高度是固定为60。间距最小为10，最大不限制。
        horzLayout2.tg_setSubviews(size:60, minSpace:10)

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "center off", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCenterOnOff(sender:)))
        
    }
    
    @objc func handleCenterOnOff(sender:UIBarButtonItem)
    {
        if sender.title == "center off" {
            sender.title = "center on"
            self.vertLayout.tg_setSubviews(size: 60, minSpace: 10, centered:true)
            self.horzLayout.tg_setSubviews(size: 60, minSpace: 10, centered:true)
            self.vertLayout2.tg_setSubviews(size: 60, minSpace: 10, centered:true)
            self.horzLayout2.tg_setSubviews(size: 60, minSpace: 10, centered:true)
        } else {
            sender.title = "center off"
            self.vertLayout.tg_setSubviews(size: 60, minSpace: 10, centered:false)
            self.horzLayout.tg_setSubviews(size: 60, minSpace: 10, centered:false)
            self.vertLayout2.tg_setSubviews(size: 60, minSpace: 10, centered:false)
            self.horzLayout2.tg_setSubviews(size: 60, minSpace: 10, centered:false)
        }
        
        self.vertLayout.tg_layoutAnimationWithDuration(0.3)
        self.horzLayout.tg_layoutAnimationWithDuration(0.3)
        self.vertLayout2.tg_layoutAnimationWithDuration(0.3)
        self.horzLayout2.tg_layoutAnimationWithDuration(0.3)
    }
}
