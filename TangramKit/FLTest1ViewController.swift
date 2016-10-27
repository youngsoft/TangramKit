//
//  FLTest1ViewController.swift
//  TangramKit
//
//  Created by yant on 28/4/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


class FLTest1ViewController: UIViewController {

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
         这个例子主要介绍了框架布局的功能。框架布局里面的所有子视图的布局位置都只跟框架布局相关。
         框架布局中的子视图可以层叠显示，因此框架布局常用来作为视图控制器里面的根视图。
         */

        
        let frameLayout = TGFrameLayout()
        frameLayout.tg_padding = UIEdgeInsetsMake(20, 20, 20, 20)
        frameLayout.backgroundColor = .gray
        self.view = frameLayout
        
        //全部填充。 all fill subview
        let fill = UILabel()
        fill.backgroundColor = .blue
        fill.tg_width.equal(.fill)  //你也可以设置为fill.tg_width.equal(frameLayout.tg_width) 效果一致。
        fill.tg_height.equal(.fill)
        frameLayout.addSubview(fill)
        
        //左右填充。 width fill subview
        let horzFill = UILabel()
        horzFill.text = "Horz Fill"
        horzFill.textAlignment = .center
        horzFill.backgroundColor = .green
        horzFill.tg_top.equal(40)  //这里偏移40为了看清楚一些。
        horzFill.tg_width.equal(.fill)
        horzFill.tg_height.equal(.wrap)
        frameLayout.addSubview(horzFill)
        
        //上下填充。 height fill subview
        let vertFill = UILabel()
        vertFill.text = "Vert Fill"
        vertFill.textAlignment = .center
        vertFill.backgroundColor = .red
        vertFill.numberOfLines = 0;
        vertFill.tg_left.equal(90)  //这里偏移90为了看清楚一些。
        vertFill.tg_width.equal(10)
        vertFill.tg_height.equal(.fill)
        frameLayout.addSubview(vertFill)
        
        
        //左上。 top left subview
        let topLeft = UILabel();
        topLeft.text = "topLeft"
        topLeft.backgroundColor = .white
        topLeft.tg_top.equal(0)
        topLeft.tg_left.equal(0)
        topLeft.sizeToFit()  //这个等价于宽度和高度都wrap。
        frameLayout.addSubview(topLeft)
        
        //左中。center left subview
        let centerLeft = UILabel();
        centerLeft.text = "centerLeft"
        centerLeft.backgroundColor = .white
        centerLeft.tg_centerY.equal(0)
        centerLeft.tg_left.equal(0)
        centerLeft.sizeToFit()
        frameLayout.addSubview(centerLeft)
        
        //左下。bottom left subview
        let bottomLeft = UILabel()
        bottomLeft.text = "bottomLeft"
        bottomLeft.backgroundColor = .white
        bottomLeft.tg_bottom.equal(0)
        bottomLeft.tg_left.equal(0)
        bottomLeft.sizeToFit()
        frameLayout.addSubview(bottomLeft)
        
        
        //中上。  top center subview
        let topCenter = UILabel()
        topCenter.text = "topCenter";
        topCenter.backgroundColor = .green
        topCenter.tg_top.equal(0)
        topCenter.tg_centerX.equal(0)
        topCenter.sizeToFit()
        frameLayout.addSubview(topCenter)
        
        
        //中中。 center center subview
        let centerCenter = UILabel()
        centerCenter.text = "centerCenter"
        centerCenter.backgroundColor = .green
        centerCenter.tg_centerY.equal(0)
        centerCenter.tg_centerX.equal(0)
        centerCenter.sizeToFit()
        frameLayout.addSubview(centerCenter)
        
        
        //中下。 bottom center subview
        let bottomCenter = UILabel()
        bottomCenter.text = "bottomCenter"
        bottomCenter.backgroundColor = .green
        bottomCenter.tg_bottom.equal(0)
        bottomCenter.tg_centerX.equal(0)
        bottomCenter.sizeToFit()
        frameLayout.addSubview(bottomCenter)
        
        
        //右上。 top right subview
        let topRight = UILabel()
        topRight.text = "topRight"
        topRight.backgroundColor = .orange
        topRight.tg_top.equal(0)
        topRight.tg_right.equal(0)
        topRight.sizeToFit()
        frameLayout.addSubview(topRight)
        
        
        //右中。center right subview
        let centerRight = UILabel()
        centerRight.text = "centerRight"
        centerRight.backgroundColor = .orange
        centerRight.tg_centerY.equal(0)
        centerRight.tg_right.equal(0)
        centerRight.sizeToFit()
        frameLayout.addSubview(centerRight)
        
        //右下。 bottom right subview
        let bottomRight = UILabel()
        bottomRight.text = "bottomRight"
        bottomRight.backgroundColor = .orange
        bottomRight.tg_bottom.equal(0)
        bottomRight.tg_right.equal(0)
        bottomRight.sizeToFit()
        frameLayout.addSubview(bottomRight)
        
        
    }
    
    
    
}
