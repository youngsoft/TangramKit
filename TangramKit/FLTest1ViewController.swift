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
    
    override func loadView() {
        
        /*
         这个例子主要介绍了框架布局的功能。框架布局里面的所有子视图的布局位置都只跟框架布局相关。
         框架布局中的子视图可以层叠显示，因此框架布局常用来作为视图控制器里面的根视图。
         */

        
        let frameLayout = TGFrameLayout()
        frameLayout.tg_padding = UIEdgeInsetsMake(20, 20, 20, 20)
        self.view = frameLayout
        
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
        vertFill.tg_left.equal(90)  //这里偏移90为了看清楚一些。
        vertFill.tg_width.equal(10)
        vertFill.tg_height.equal(.fill)
        frameLayout.addSubview(vertFill)
        
        
        //左上。 top left subview
        let topLeft = self.createLabel("top left", backgroundColor: CFTool.color(5))
        topLeft.tg_top.equal(0)
        topLeft.tg_left.equal(0)
        frameLayout.addSubview(topLeft)
        
        //左中。center left subview
        let centerLeft = self.createLabel("center left", backgroundColor: CFTool.color(5))
        centerLeft.tg_centerY.equal(0)
        centerLeft.tg_left.equal(0)
        frameLayout.addSubview(centerLeft)
        
        //左下。bottom left subview
        let bottomLeft = self.createLabel("bottom left", backgroundColor: CFTool.color(5))
        bottomLeft.tg_bottom.equal(0)
        bottomLeft.tg_left.equal(0)
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
        
        
        //右上。 top right subview
        let topRight = self.createLabel("top right", backgroundColor: CFTool.color(7))
        topRight.tg_top.equal(0)
        topRight.tg_right.equal(0)
        frameLayout.addSubview(topRight)
        
        
        //右中。center right subview
        let centerRight = self.createLabel("center right", backgroundColor: CFTool.color(7))
        centerRight.tg_centerY.equal(0)
        centerRight.tg_right.equal(0)
        frameLayout.addSubview(centerRight)
        
        //右下。 bottom right subview
        let bottomRight = self.createLabel("bottom right", backgroundColor: CFTool.color(7))
        bottomRight.tg_bottom.equal(0)
        bottomRight.tg_right.equal(0)
        frameLayout.addSubview(bottomRight)
        
        
    }
    
    
    
}
