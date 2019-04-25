//
//  FLLTest7ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *7.FlowLayout - Auto Arrange
 */
class FLLTest7ViewController: UIViewController {
    
    
    func createItems(_ titles:[String], in flowLayout:TGFlowLayout) ->Void
    {
        for title in titles
        {
            let label = UILabel()
            label.text = title
            label.tg_size(width:.wrap, height:.wrap)
            label.backgroundColor = CFTool.color(Int(arc4random()%14) + 1)
            label.font = CFTool.font(16)
            flowLayout.addSubview(label)
        }
    }

    
    
    override func loadView() {
        
        /*
         这个例子主要用来介绍数量约束流式布局的自动排列和紧凑排列的能力，目的是为了实现类似于瀑布流的功能，下面的代码您将能看到水平和垂直两种应用场景。
         每种应用场景中，我们通过设置tg_autoArrange为true和tg_arrangedGravity属性为TGGravity.horz.between或者TGGravity.vert.between来分别实现两种不同的
         排列策略：
         tg_autoArrange: 的策略是让总体的空间达到最高效的利用，但是他会打乱视图添加的顺序。
         tg_arrangedGravity: 的策略则不会打乱视图的添加顺序，因此他的总体空间的利用率可能会不如tg_autoArrange那么高。
         */
        
        /*
         需要注意的是，当您的数据量比较小时，我们可以考虑使用流式布局来实现瀑布流，而当你的数据量比较大，并且需要考虑复用，那么为了内存上的考虑建议您还是使用tableView或者collectionView来实现。
         */
        
        let titles = ["11111111111111111", "222222222222222222222222222","3333333333333", "4444444444444444444444", "55555555", "6666666666666", "77777777", "8888888888888888888888", "99"]
        
        
        
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0)  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_gravity = TGGravity.horz.fill
        rootLayout.tg_space = 20
        rootLayout.backgroundColor = UIColor.white
        self.view = rootLayout
        
        //水平瀑布流1。
        let scrollView1 = UIScrollView()
        scrollView1.tg_height.equal(.wrap)  //这里可以设置滚动视图的高度为包裹属性，表示他的高度依赖于布局视图的高度。
        rootLayout.addSubview(scrollView1)
        
        let flowLayout1 = TGFlowLayout(.horz,arrangedCount:3)
        flowLayout1.backgroundColor = CFTool.color(5)
        flowLayout1.tg_height.equal(.wrap)   //流式布局的尺寸由里面的子视图的整体尺寸决定。
        flowLayout1.tg_width.equal(.wrap).min(scrollView1.tg_width) //虽然尺寸是包裹的，但是最小宽度不能小于父视图的宽度
        flowLayout1.tg_autoArrange = true  //通过将流式布局的autoArrange属性设置为YES可以实现里面的子视图进行紧凑的自动排列。
        flowLayout1.tg_space = 10;
        flowLayout1.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);
        scrollView1.addSubview(flowLayout1)
        self.createItems(titles, in:flowLayout1)
        
        
        //水平瀑布流2。
        let scrollView2 = UIScrollView()
        scrollView2.tg_height.equal(.wrap)  //这里可以设置滚动视图的高度为包裹属性，表示他的高度依赖于布局视图的高度。
        rootLayout.addSubview(scrollView2)
        
        let flowLayout2 = TGFlowLayout(.horz,arrangedCount:3)
        flowLayout2.backgroundColor = CFTool.color(5)
        flowLayout2.tg_height.equal(.wrap)   //流式布局的尺寸由里面的子视图的整体尺寸决定。
        flowLayout2.tg_width.equal(.wrap).min(scrollView2.tg_width) //虽然尺寸是包裹的，但是最小宽度不能小于父视图的宽度
        flowLayout2.tg_arrangedGravity = TGGravity.horz.between //通过将水平流式布局的tg_arrangeGravity属性设置为TGGravity.vert.between，我们将得到里面的子视图在每行都会被紧凑的排列。大家可以看到和上面的将tg_autoArrange设置为true的不同的效果。
        flowLayout2.tg_space = 10;
        flowLayout2.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);
        scrollView2.addSubview(flowLayout2)
        self.createItems(titles, in:flowLayout2)

        
        //垂直瀑布流1
        let scrollView3 = UIScrollView()
        scrollView3.tg_height.equal(50%)  //这里可以设置滚动视图的高度为包裹属性，表示他的高度依赖于布局视图的高度。
        rootLayout.addSubview(scrollView3)
        
        let flowLayout3 = TGFlowLayout(.vert,arrangedCount:3)
        flowLayout3.backgroundColor = CFTool.color(5)
        flowLayout3.tg_height.equal(.wrap).min(scrollView3.tg_height) //虽然是包裹尺寸，但是最小不能小于父视图的高度。
        flowLayout3.tg_width.equal(.fill)
        flowLayout3.tg_gravity = TGGravity.horz.fill //均分宽度。
        flowLayout3.tg_autoArrange = true  //通过将流式布局的autoArrange属性设置为YES可以实现里面的子视图进行紧凑的自动排列。
        flowLayout3.tg_space = 10;
        flowLayout3.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        scrollView3.addSubview(flowLayout3)
        self.createItems(titles, in:flowLayout3)

        
        //垂直瀑布流2
        let scrollView4 = UIScrollView()
        scrollView4.tg_height.equal(50%)  //这里可以设置滚动视图的高度为包裹属性，表示他的高度依赖于布局视图的高度。
        rootLayout.addSubview(scrollView4)
        
        let flowLayout4 = TGFlowLayout(.vert,arrangedCount:3)
        flowLayout4.backgroundColor = CFTool.color(5)
        flowLayout4.tg_height.equal(.wrap).min(scrollView4.tg_height) //虽然是包裹尺寸，但是最小不能小于父视图的高度。
        flowLayout4.tg_width.equal(.fill)
        flowLayout4.tg_gravity = TGGravity.horz.fill //均分宽度。
        flowLayout4.tg_arrangedGravity = TGGravity.vert.between
        flowLayout4.tg_space = 10
        flowLayout4.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        scrollView4.addSubview(flowLayout4)
        self.createItems(titles, in:flowLayout4)

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
