//
//  RLTest1ViewController.swift
//  TangramKit
//
//  Created by zhangguangkai on 16/5/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class RLTest1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func loadView() {
        
        /*
         这个DEMO，主要介绍相对布局里面的子视图如果通过扩展属性TGLayoutPos对象属性来设置各视图之间的依赖关系。
         苹果系统原生的AutoLayout其本质就是一套相对布局体系。但是TGRelativeLayout所具有的功能比AutoLayout还要强大。
         */
        
        
        let rootLayout: TGRelativeLayout = TGRelativeLayout()
        rootLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        rootLayout.backgroundColor = .gray
        self.view = rootLayout
        
        /*
         顶部区域部分
         */
        let todayLabel: UILabel = UILabel()
        todayLabel.text = "Today"
        todayLabel.sizeToFit()
        todayLabel.tg_centerX.equal(0)  //水平中心点在父布局水平中心点的偏移为0，意味着和父视图水平居中对齐。
        todayLabel.tg_top.equal(20)    //顶部离父视图的边距为20
        rootLayout.addSubview(todayLabel)

        /*
         左上角区域部分
         */
        let greenCircle: UIView = UIView()
        greenCircle.backgroundColor = .green
        greenCircle.tg_width.equal(rootLayout.tg_width, multiple:3/5.0)
        greenCircle.tg_width.max(200)  //宽度是父视图宽度的3/5,且最大只能是200。
        greenCircle.tg_height.equal(greenCircle.tg_width) //高度和自身宽度相等。
        greenCircle.tg_left.equal(10) //左边距离父视图10
        greenCircle.tg_top.equal(90)  //顶部距离父视图90
        greenCircle.tg_layoutCompletedDo{(_, view:UIView) in
            //tg_layoutCompletedDo是在子视图布局完成后给子视图一个机会进行一些特殊设置的block。这里面我们将子视图的半径设置为尺寸的一半，这样就可以实现在任意的屏幕上，这个子视图总是呈现为圆形。tg_layoutCompletedDo只会在布局完成后调用一次，就会被布局系统销毁。
            view.layer.cornerRadius = view.frame.width / 2
        }
        rootLayout.addSubview(greenCircle)

        
        let walkLabel: UILabel = UILabel()
        walkLabel.text = "walk"
        walkLabel.textColor = .green
        walkLabel.sizeToFit()
        walkLabel.tg_centerX.equal(greenCircle.tg_centerX)  //水平中心点和greenCircle水平中心点一致，意味着和greenCircle水平居中对齐。
        walkLabel.tg_bottom.equal(greenCircle.tg_top, offset:5) //底部是greenCircle的顶部再往上偏移5个点。
        rootLayout.addSubview(walkLabel)
        
        let walkSteps: UILabel = UILabel()
        walkSteps.text = "9,362"
        walkSteps.textColor = .white
        walkSteps.font = .systemFont(ofSize: 30)
        walkSteps.sizeToFit()
        walkSteps.tg_centerX.equal(greenCircle.tg_centerX)
        walkSteps.tg_centerY.equal(greenCircle.tg_centerY) //水平中心点和垂直中心点都和greenCircle一样，意味着二者居中对齐。
        rootLayout.addSubview(walkSteps)
        
        let steps: UILabel = UILabel()
        steps.text = "steps"
        steps.textColor = .white
        steps.font = .systemFont(ofSize: 15)
        steps.sizeToFit()
        steps.tg_centerX.equal(walkSteps.tg_centerX) //和walkSteps水平居中对齐。
        steps.tg_top.equal(walkSteps.tg_bottom)  //顶部是walkSteps的底部。
        rootLayout.addSubview(steps)
        
        /*
         右上角区域部分
         */
        let bluecircle: UIView = UIView()
        bluecircle.backgroundColor = .blue
        bluecircle.layer.cornerRadius = 60
        bluecircle.tg_top.equal(greenCircle.tg_top, offset:-10)  //顶部和greenCircle顶部对齐，并且往上偏移10个点。
        bluecircle.tg_right.equal(rootLayout.tg_right, offset:10)//右边和布局视图右对齐，并且往左边偏移10个点.
        bluecircle.tg_width.equal(120)
        bluecircle.tg_height.equal(bluecircle.tg_width)
        bluecircle.tg_layoutCompletedDo{(_, view:UIView) in
            //tg_layoutCompletedDo是在子视图布局完成后给子视图一个机会进行一些特殊设置的block。这里面我们将子视图的半径设置为尺寸的一半，这样就可以实现在任意的屏幕上，这个子视图总是呈现为圆形。tg_layoutCompletedDo只会在布局完成后调用一次，就会被布局系统销毁。

            view.layer.cornerRadius = view.frame.width / 2
        }
        rootLayout.addSubview(bluecircle)
        
        let cycleLabel: UILabel = UILabel()
        cycleLabel.text = "Cycle"
        cycleLabel.textColor = .blue
        cycleLabel.sizeToFit()
        cycleLabel.tg_centerX.equal(bluecircle.tg_centerX)
        cycleLabel.tg_bottom.equal(bluecircle.tg_top, offset:5) //底部在blueCircle的上面，再往下偏移5个点。
        rootLayout.addSubview(cycleLabel)
        
        let cycleMin: UILabel = UILabel()
        cycleMin.text = "39 Min"
        cycleMin.textColor = .white
        cycleMin.font = UIFont.systemFont(ofSize: 18)
        cycleMin.sizeToFit()
        cycleMin.tg_left.equal(bluecircle.tg_left)
        cycleMin.tg_centerY.equal(bluecircle.tg_centerY)
        rootLayout.addSubview(cycleMin)
        
        
        /*
         中间区域部分
         */
        let lineView1: UIView = UIView()
        lineView1.backgroundColor = .red
        lineView1.tg_left.equal(0)
        lineView1.tg_right.equal(0) //和父布局的左右边距为0，这个也同时确定了视图的宽度和父视图一样。
        //您也可以如下设置：
        //lineView1.tg_width.equal(.fill)   //填充父视图的剩余宽度
        //您也可以如下设置：
        //lineView1.tg_width.equal(100%)
        lineView1.tg_height.equal(2)
        lineView1.tg_centerY.equal(0)
        rootLayout.addSubview(lineView1)
        
        let lineView2: UIView = UIView()
        lineView2.backgroundColor = .green
        lineView2.tg_width.equal(rootLayout.tg_width,increment:-20)  //宽度等于父视图的宽度减20
        lineView2.tg_height.equal(2)
        lineView2.tg_top.equal(lineView1.tg_bottom, offset:2)
        lineView2.tg_centerX.equal(rootLayout.tg_centerX)
        rootLayout.addSubview(lineView2)
        
        
        /*
         左下角区域部分。
         */
        let bottomHalfCircleView = UIView()
        bottomHalfCircleView.backgroundColor = .white
        bottomHalfCircleView.layer.cornerRadius = 25
        bottomHalfCircleView.tg_width.equal(50)
        bottomHalfCircleView.tg_height.equal(bottomHalfCircleView.tg_width)
        bottomHalfCircleView.tg_centerY.equal(rootLayout.tg_bottom, offset:10) //垂直中心点和父布局的底部对齐，并且往下偏移10个点。 因为rootLayout设置了bottomPadding为10，所以这里要偏移10，否则不需要设置偏移。
        bottomHalfCircleView.tg_left.equal(rootLayout.tg_left, offset:50)
        rootLayout.addSubview(bottomHalfCircleView)
        
        let lineView3 = UIView()
        lineView3.backgroundColor = .green
        lineView3.tg_width.equal(5)
        lineView3.tg_height.equal(50)
        lineView3.tg_bottom.equal(bottomHalfCircleView.tg_top)
        lineView3.tg_centerX.equal(bottomHalfCircleView.tg_centerX)
        rootLayout.addSubview(lineView3)
        
        let walkLabel2 = UILabel()
        walkLabel2.text = "walk"
        walkLabel2.textColor = .green
        walkLabel2.sizeToFit()
        walkLabel2.tg_left.equal(lineView3.tg_right,offset:15)
        walkLabel2.tg_centerY.equal(lineView3.tg_centerY)
        rootLayout.addSubview(walkLabel2)
        
        let walkLabel3 = UILabel()
        walkLabel3.text = "18 Min"
        walkLabel3.textColor = .white
        walkLabel3.sizeToFit()
        walkLabel3.tg_left.equal(walkLabel2.tg_right,offset:5)
        walkLabel3.tg_centerY.equal(walkLabel2.tg_centerY)
        rootLayout.addSubview(walkLabel3)
        
        let timeLabel1 = UILabel()
        timeLabel1.text = "9:12"
        timeLabel1.textColor = .white
        timeLabel1.sizeToFit()
        timeLabel1.tg_right.equal(lineView3.tg_left,offset:25)
        timeLabel1.tg_centerY.equal(lineView3.tg_top)
        rootLayout.addSubview(timeLabel1)
        
        let timeLabel2 = UILabel()
        timeLabel2.text = "9:30"
        timeLabel2.textColor = .lightGray
        timeLabel2.sizeToFit()
        timeLabel2.tg_right.equal(timeLabel1.tg_right)
        timeLabel2.tg_centerY.equal(lineView3.tg_bottom)
        rootLayout.addSubview(timeLabel2)
        
        let lineView4 = UIView()
        lineView4.backgroundColor = .white
        lineView4.layer.cornerRadius = 25
        lineView4.tg_width.equal(bottomHalfCircleView.tg_width)
        lineView4.tg_height.equal(lineView4.tg_width, increment:30)
        lineView4.tg_bottom.equal(lineView3.tg_top)
        lineView4.tg_centerX.equal(lineView3.tg_centerX)
        rootLayout.addSubview(lineView4)
        
        let imageView4 = UIImageView(image: UIImage(named: "user"))
        imageView4.sizeToFit()
        imageView4.tg_width.equal(lineView4.tg_width, multiple:1.0/3.0)
        imageView4.tg_height.equal(imageView4.tg_width)
        imageView4.tg_centerX.equal(lineView4.tg_centerX)
        imageView4.tg_centerY.equal(lineView4.tg_centerY)
        rootLayout.addSubview(imageView4)
        
        let homeLabel = UILabel()
        homeLabel.text = "Home"
        homeLabel.textColor = .white
        homeLabel.sizeToFit()
        homeLabel.tg_left.equal(lineView4.tg_right,offset:10)
        homeLabel.tg_centerY.equal(lineView4.tg_centerY)
        rootLayout.addSubview(homeLabel)
        
        /*
         右下角区域部分。
         */
        let bottomRightImageView = UIImageView(image: UIImage(named: "head1"))
        bottomRightImageView.backgroundColor = .white
        bottomRightImageView.sizeToFit()
        bottomRightImageView.tg_right.equal(rootLayout.tg_right)
        bottomRightImageView.tg_bottom.equal(rootLayout.tg_bottom)
        rootLayout.addSubview(bottomRightImageView)
        
    }

}
