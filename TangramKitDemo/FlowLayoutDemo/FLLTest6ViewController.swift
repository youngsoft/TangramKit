//
//  FLLTest6ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *6.FlowLayout - Scroll
 */
class FLLTest6ViewController: UIViewController {
    
    weak var scrollView:UIScrollView!
    weak var rootLayout:TGFlowLayout!
    
    override func loadView() {
        
        /*
         这个例子用于介绍流式布局来实现2种风格的切换，多行多列到单行单列的切换,以及滚动方向的切换。
         */
        
        let scrollView = UIScrollView()
        self.view = scrollView
        self.scrollView = scrollView
        
        let rootLayout = TGFlowLayout(.vert,arrangedCount:3)
        rootLayout.backgroundColor = CFTool.color(0)
        rootLayout.tg_pagedCount = 9
        rootLayout.tg_height.equal(.wrap)  //上下滚动，每页9个。
        rootLayout.tg_space = 10
        rootLayout.tg_padding = UIEdgeInsetsMake(10, 5, 10, 5)
        rootLayout.tg_leading.equal(0).isActive = true //active属性用来表示是否让这个属性设置生效。
        rootLayout.tg_trailing.equal(0).isActive = true  //这里设置左右的边距是0并生效，表示宽度和父视图相等。
        rootLayout.tg_top.equal(0).isActive = false
        rootLayout.tg_bottom.equal(0).isActive = false  //这里设置上下边距是0但是不生效，这时候高度是不能生效的。
        scrollView.addSubview(rootLayout)
        self.rootLayout = rootLayout
        
        
        let images = ["image1","image2","image3","image4"];
        for i in 0 ..< 28
        {
            //因为使用了分页技术，系统默认会设置布局视图里面子控件的高度和宽度，因此一般情况下你不需要单独指定。
            let button = UIButton(type:.custom)
            button.setBackgroundImage(UIImage(named:images[Int(arc4random_uniform(UInt32(images.count)))]),for:.normal)
            self.rootLayout.addSubview(button)
            
            button.tag = i + 100;
            button.addTarget(self, action:#selector(handleTap),for:.touchUpInside)
            
        }
        

        
    }
    
    
    @objc func handleTap(sender:UIButton!)
    {
        //这里实现单击里面控件按钮来实现多行多列到单行单列的切换。多行多列时布局视图的宽度和父视图相等，而单行单列时布局视图的高度和父视图的高度相等。
        //下面这段话就是用来设置每次切换时的布局尺寸的处理。
        self.rootLayout.tg_leading.isActive = !self.rootLayout.tg_leading.isActive;
        self.rootLayout.tg_trailing.isActive = !self.rootLayout.tg_trailing.isActive;
        self.rootLayout.tg_top.isActive = !self.rootLayout.tg_top.isActive;
        self.rootLayout.tg_bottom.isActive = !self.rootLayout.tg_bottom.isActive;
        
        //当前是多行多列。
        if (self.rootLayout.tg_height.isWrap)
        {
            //换成单行单列
            self.rootLayout.tg_arrangedCount = 1
            self.rootLayout.tg_pagedCount = 1
            self.rootLayout.tg_padding = .zero
            self.rootLayout.tg_space = 0
            
        }
        else
        {
            //恢复为多行多列
            self.rootLayout.tg_arrangedCount = 3
            self.rootLayout.tg_pagedCount = 9
            self.rootLayout.tg_padding = UIEdgeInsetsMake(10, 5, 10, 5);
            self.rootLayout.tg_space = 10
            
        }
        
        //这里切换水平滚动还是垂直滚动。
        self.rootLayout.tg_height.equal(self.rootLayout.tg_height.isWrap ? nil : .wrap)
        self.rootLayout.tg_width.equal(self.rootLayout.tg_width.isWrap ? nil : .wrap)
                
        let isHorzScroll = self.rootLayout.tg_width.isWrap
        
        
        UIView.animate(withDuration: 0.3) {
            
            self.rootLayout.layoutIfNeeded()  //上面因为进行布局属性的设置变更，必定会激发重新布局，因此如果想要应用动画时可以在动画块内调用layoutIfNeeded来实现
            
            if (isHorzScroll)
            {
                self.scrollView.contentOffset = sender.frame.origin
            }
            else
            {
                var offsetPoint = CGPoint(x:0, y:sender.frame.origin.y)
                if (offsetPoint.y > self.scrollView.contentSize.height - self.scrollView.bounds.height)
                {
                    offsetPoint.y = self.scrollView.contentSize.height - self.scrollView.bounds.height
                }
                
                self.scrollView.contentOffset = offsetPoint
            }
            
            
            
        }
        
    }

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
