//
//  RLTest5ViewController.swift
//  TangramKit
//
//  Created by zhangguangkai on 16/5/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



class RLTest5ViewController: UIViewController {

    
       override func loadView() {
        
        /*
         本例子是要用来介绍在相对布局中的子视图可以使用TGLayoutPos对象的max,min方法设置来实现最大和最小边界约束。
         */
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_vspace = 10
        scrollView.addSubview(rootLayout)
        
        //最小最大间距限制例子。segment的简易实现。
        self.createDemo1(rootLayout)
        //右边边距限制的例子。
        self.createDemo2(rootLayout)
        //左边边距限制和上下边距限制的例子。
        self.createDemo3(rootLayout)

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @objc func handleButtonSelect(_ button: UIButton) {
        if button.isSelected {
            return
        }
        
        let containerLayout = button.superview! as! TGRelativeLayout
        let leftButton = containerLayout.viewWithTag(1)! as! UIButton
        let  rightButton = containerLayout.viewWithTag(2)! as! UIButton
        let  underLineView = containerLayout.viewWithTag(3)!
        let  tag = button.tag
        leftButton.isSelected = (tag == 1)
        rightButton.isSelected = (tag == 2)
        
        //调整underLineView的位置。
        underLineView.tg_leading.equal(button.tg_leading)
        underLineView.tg_width.equal(button.tg_width)
        
        containerLayout.tg_layoutAnimationWithDuration(0.3)
        
    }
    
    func createDemo1(_ rootLayout: UIView) {
        /*
         本例子实现一个带动画效果的segment的简单实现。只有在相对布局中的子视图才支持使用MyLayoutPos中的lBound和uBound方法。
         通过这个方法能设置视图的最小和最大的边距。
         */
        let containerLayout = TGRelativeLayout()
        containerLayout.tg_width.equal(.fill).and().tg_height.equal(.wrap)
        containerLayout.tg_topPadding = 6
        containerLayout.tg_bottomPadding = 6
        containerLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(containerLayout)
        
        let leftButton = UIButton(type: .custom)
        leftButton.setTitle("Left button", for: .normal)
        leftButton.setTitleColor(CFTool.color(4), for: .normal)
        leftButton.setTitleColor(CFTool.color(7), for: .selected)
        leftButton.tag = 1
        leftButton.addTarget(self, action: #selector(self.handleButtonSelect), for: .touchUpInside)
        leftButton.sizeToFit()
        //根据内容得到高度和宽度
        leftButton.tg_leading.min(containerLayout.tg_leading)
        //左边最小边界是父视图左边偏移0
        leftButton.tg_trailing.max(containerLayout.tg_centerX)
        //右边最大的边界是父视图中心点偏移0
        //在相对布局中子视图可以不设置左右边距而是设置最小和最大的边界值，就可以让子视图在指定的边界范围内居中，并且如果宽度超过最小和最大的边界设定时会自动压缩子视图的宽度。在这个例子中leftButton始终在父视图的左边和父视图的水平中心这个边界内居中显示。
        containerLayout.addSubview(leftButton)
        leftButton.isSelected = true
        
        
        let  rightButton = UIButton(type: .custom)
        rightButton.setTitle("Right button", for: .normal)
        rightButton.setTitleColor(CFTool.color(4), for: .normal)
        rightButton.setTitleColor(CFTool.color(7), for: .selected)
        rightButton.tag = 2
        rightButton.addTarget(self, action: #selector(self.handleButtonSelect), for: .touchUpInside)
        rightButton.sizeToFit() //根据内容得到高度和宽度
        rightButton.tg_leading.min(containerLayout.tg_centerX) //左边最小边界是父视图中心点偏移0
        rightButton.tg_trailing.max(containerLayout.tg_trailing)//右边最大边界是父视图右边偏移0
        //在相对布局中子视图可以不设置左右边距而是设置最小和最大的边界值，就可以让子视图在指定的边界范围内居中，并且如果宽度超过最小和最大的边界设定时会自动压缩子视图的宽度。在这个例子中rightButton始终在父视图的水平中心和父视图的右边这个边界内居中显示。
        containerLayout.addSubview(rightButton)
        
        //添加下划线视图。
        let underLineView = UIView()
        underLineView.backgroundColor = CFTool.color(7)
        underLineView.tag = 3
        underLineView.tg_height.equal(1)
        underLineView.tg_width.equal(leftButton.tg_width)
        underLineView.tg_leading.equal(leftButton.tg_leading)
        underLineView.tg_top.equal(leftButton.tg_bottom, offset:6)
        containerLayout.addSubview(underLineView)

    }
    
    
    func createDemo2(_ rootLayout: UIView) {
        /*
         这个例子通常用于UITableViewCell中的某些元素的最大尺寸的限制，您可以横竖屏切换，看看效果。
         对于某些布局场景中，某个子视图的尺寸是不确定的，因此你不能设置一个固定的值，同时这个尺寸又不能无限制的延生而会受到某些边界的约束控制。因此可以用如下的方法来进行视图的尺寸设置。
         */
        let containerLayout = TGRelativeLayout()
        containerLayout.tg_width.equal(.fill).and().tg_height.equal(.wrap)
        containerLayout.tg_topPadding = 6
        containerLayout.tg_bottomPadding = 6
        containerLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(containerLayout)
        
        /*
         这个例子中，水平方向一共有leftImageView,flexedLabel,editImageView,rightLabel四个子视图水平排列。其中leftImageView在最左边且宽度固定，flexedLabel则跟在leftImageView的右边但是宽度是不确定的，editImageView则是跟在flexedLabel的后面宽度是固定的，rightLabel则总是在屏幕的右边且宽度是固定的，但是其中的flexedLabel的宽度最宽不能无限制的延生，且不能和rightLabel进行重叠。
         */


        let images = ["minions1", "minions2", "minions3", "minions4"]
        let  texts = ["test text1",
                      "test text1 test text2",
                      "test text1 test text2 test text3 test text4",
                      "test text1 test text2 test text3 test text4 test text5"]
        let  rightTexts = ["100.00", "1000.00", "10000.00", "100000.00"]
        
        for i in 0..<images.count {
            
            let  leftImageView = UIImageView(image: UIImage(named: images[Int(arc4random() % 4)])!)
            leftImageView.tg_top.equal(90 * i)
            containerLayout.addSubview(leftImageView)
            
            let flexedLabel = UILabel()
            flexedLabel.text = texts[Int(arc4random() % 4)]
            flexedLabel.font = CFTool.font(17)
            flexedLabel.textColor = CFTool.color(4)
            flexedLabel.lineBreakMode = .byCharWrapping
            flexedLabel.tg_height.equal(.wrap) //高度自动计算。
            flexedLabel.tg_leading.equal(leftImageView.tg_trailing, offset:5) //左边等于leftImageView的右边
            flexedLabel.tg_top.equal(leftImageView.tg_top) //顶部和leftImageView相等。
            containerLayout.addSubview(flexedLabel)
            
            
            let  editImageView = UIImageView(image: UIImage(named: "edit")!)
            editImageView.tg_leading.equal(flexedLabel.tg_trailing)//这个图片总是跟随在flexedLabel的后面。
            editImageView.tg_top.equal(leftImageView.tg_top, offset:4)
            containerLayout.addSubview(editImageView)
            
            
            let rightLabel = UILabel()
            rightLabel.text = rightTexts[Int(arc4random() % 4)]
            rightLabel.font = CFTool.font(15)
            rightLabel.textColor = CFTool.color(7)
            rightLabel.sizeToFit()
            rightLabel.tg_trailing.equal(containerLayout.tg_trailing) //右边等于父视图的右边，也就是现实在最右边。
            rightLabel.tg_top.equal(leftImageView.tg_top, offset:4)
            containerLayout.addSubview(rightLabel)
            
            flexedLabel.tg_width.equal(.wrap) //宽度等于自身的宽度
            flexedLabel.tg_trailing.max(rightLabel.tg_leading, offset:editImageView.frame.width + 10)//右边的最大的边界就等于rightLabel的最左边再减去editImageView的尺寸外加上10,这里的10是视图之间的间距，为了让视图之间保持有足够的间距。这样当flexedLabel的宽度超过这个最大的右边界时，系统自动会缩小flexedLabel的宽度，以便来满足右边界的限制。 这个场景非常适合某个UITableViewCell里面的两个子视图之间有尺寸长度约束的情况。
        }
    }
    
    
    @objc func handleClick(_ sender: UITapGestureRecognizer) {
        
        let label = (sender.view as! UILabel)
        let text = label.text
        label.text = text?.appending("+++")
    }
    
    func createDemo3(_ rootLayout: UIView) {
        /*
         这个例子用来了解上下边距的约束和左边边距的约束的场景。这些约束的设置特别适合那些有尺寸依赖以及位置依赖的UITableViewCell的场景。
         */
        let  containerLayout = TGRelativeLayout()
        containerLayout.tg_width.equal(.fill)
        containerLayout.tg_height.equal(150)
        containerLayout.tg_padding = UIEdgeInsets.init(top: 6, left: 6, bottom: 6, right: 6)
        containerLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(containerLayout)
        
        //左边文字居中并且根据内容变化。
        let leftLabel = UILabel()
        leftLabel.backgroundColor = CFTool.color(5)
        leftLabel.text = "Click me:"
        leftLabel.textColor = CFTool.color(4)
        leftLabel.tg_width.equal(100)//宽度固定为100
        leftLabel.tg_height.equal(.wrap) //高度由子视图的内容确定，自动计算高度。
        leftLabel.tg_top.min(containerLayout.tg_top)//最小的顶部位置是父布局的顶部。
        leftLabel.tg_bottom.max(containerLayout.tg_bottom) //最大的底部位置是父布局的底部
        //通过这两个位置的最小最大约束，视图leftLabel将会在这个范围内居中，并且当高度超过这个约束时，会自动的压缩子视图的高度。
        containerLayout.addSubview(leftLabel)
        
        //添加手势处理。
        let leftLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleClick))
        leftLabel.isUserInteractionEnabled = true
        leftLabel.addGestureRecognizer(leftLabelTapGesture)
        
        //右边按钮
        let  rightLabel = UILabel()
        rightLabel.backgroundColor = CFTool.color(6)
        rightLabel.text = "Click me:"
        rightLabel.textColor = CFTool.color(4)
        rightLabel.tg_trailing.equal(containerLayout.tg_trailing) //和父布局视图右对齐。
        rightLabel.tg_centerY.equal(leftLabel.tg_centerY) //和左边视图垂直居中对齐。
        rightLabel.tg_leading.min(leftLabel.tg_trailing, offset:10) //右边视图的最小左边界是等于左边视图的右边偏移10，这样当右边视图的宽度超过这个最小边界时则会自动压缩视图的宽度。
        
        rightLabel.tg_width.equal(.wrap) //宽度等于自身的宽度。这个设置和上面的tg_leading.min方法配合使用实现子视图宽度的压
        rightLabel.tg_height.equal(.wrap).max(containerLayout.tg_height) //但是最大的高度等于父布局视图的高度(注意这里内部自动减去了padding的值)
        containerLayout.addSubview(rightLabel)
        //添加手势处理。
        let  rightLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleClick))
        rightLabel.isUserInteractionEnabled = true
        rightLabel.addGestureRecognizer(rightLabelTapGesture)
        
    }

}

