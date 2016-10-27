//
//  FwTest1ViewController.swift
//  TangramKit
//
//  Created by 佳达 on 16/5/6.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class FLLTest1ViewController: UIViewController {
    
    weak var flowLayout:TGFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func loadView() {
       
        /*
         这个例子用来介绍流式布局的特性，流式布局中的子视图总是按一定的规则一次排列，当数量到达一定程度或者内容到达一定程度时就会自动换行从新排列。
         */
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_gravity = TGGravity.horz.fill  //里面的子视图的宽度和父视图保持一致。
        self.view = rootLayout
        
        //添加操作按钮。
        let actionLayout = TGFlowLayout(.vert, arrangedCount: 2)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tg_averageArrange = true
        actionLayout.tg_padding = UIEdgeInsetsMake(5, 5, 5, 5)
        actionLayout.tg_hspace = 5
        actionLayout.tg_vspace = 5
        rootLayout.addSubview(actionLayout)
        
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust orientation", comment:""), action:#selector(handleAdjustOrientation)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust arrangedCount", comment:""),action:#selector(handleAdjustArrangedCount)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("average size", comment:""),
        action:#selector(handleAdjustAverageMeasure)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust gravity", comment:""),
        action:#selector(handleAdjustGravity)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust align", comment:""),
        action:#selector(handleAdjustArrangeGravity)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust spacing", comment:""),
        action:#selector(handleAdjustMargin)))
        
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.tg_height.equal(.fill) //占用剩余的高度。
        scrollView.tg_top.equal(10)
        rootLayout.addSubview(scrollView)
        
        
        let flowLayout = TGFlowLayout(.vert,arrangedCount: 3)
        flowLayout.backgroundColor = .lightGray
        flowLayout.tg_width.equal(800)
        flowLayout.tg_height.equal(800)
        flowLayout.tg_padding = UIEdgeInsetsMake(5, 5, 5, 5)
        flowLayout.tg_vspace = 5
        flowLayout.tg_hspace = 5
        scrollView.addSubview(flowLayout)
        self.flowLayout = flowLayout
        
        let imageArray = ["minions1","minions2","minions3","minions4","head1"]
        
        for _ in 0 ..< 60
        {
            let imageView = UIImageView(image:UIImage(named:imageArray[Int(arc4random()%5)]))
            imageView.layer.borderColor = UIColor.red.cgColor
            imageView.layer.borderWidth = 1
            self.flowLayout.addSubview(imageView)
        }
        
    }
}

//MAKR: -Layout Construction
extension FLLTest1ViewController
{
    //创建动作操作按钮。
    func createActionButton(_ title:String,action:Selector) ->UIButton
    {
        let button = UIButton(type:.system)
        button.setTitle(title, for: UIControlState())
        button.addTarget(self,action:action, for:.touchUpInside)
        button.tg_height.equal(44)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    
    }
    

}

//MARK: -Handle Method
extension FLLTest1ViewController
{
    func handleAdjustOrientation(_ sender:AnyObject?)
    {
        //调整流式布局的方向。
        if (self.flowLayout.tg_orientation == .vert)
        {
          self.flowLayout.tg_orientation = .horz
        }
        else
        {
          self.flowLayout.tg_orientation = .vert
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)

    }
    
    func handleAdjustArrangedCount(_ sender:AnyObject?)
    {
        
        //调整流式布局的每行的数量。
        self.flowLayout.tg_arrangedCount = (self.flowLayout.tg_arrangedCount + 1) % 6
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)

    }
    
    func handleAdjustAverageMeasure(_ sender:AnyObject?)
    {
        //调整是否均分子视图的尺寸。
        self.flowLayout.tg_averageArrange = !self.flowLayout.tg_averageArrange;
        
        if (!self.flowLayout.tg_averageArrange)
        {
            //当不均分子视图的尺寸时，就需要子视图自己指定明确的尺寸。
            for vv in self.flowLayout.subviews
            {
                vv.sizeToFit()
            }
            
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)
        
    }
    
    func handleAdjustGravity(_ sender:AnyObject?)
    {
        //所有子视图的停靠位置的调整。
        if (self.flowLayout.tg_gravity == .none)
        {
            self.flowLayout.tg_gravity = TGGravity.vert.center
        }
        else if (self.flowLayout.tg_gravity == TGGravity.vert.center)
        {
            self.flowLayout.tg_gravity = TGGravity.vert.bottom
        }
        else if (self.flowLayout.tg_gravity == TGGravity.vert.bottom)
        {
            self.flowLayout.tg_gravity = TGGravity.horz.center
        }
        else if (self.flowLayout.tg_gravity == TGGravity.horz.center)
        {
            self.flowLayout.tg_gravity = TGGravity.horz.right
        }
        else if (self.flowLayout.tg_gravity == TGGravity.horz.right)
        {
            self.flowLayout.tg_gravity = .center
        }
        else if (self.flowLayout.tg_gravity == .center)
        {
            self.flowLayout.tg_gravity = .none
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)

        
    }
    
    func handleAdjustArrangeGravity(_ sender:AnyObject?)
    {
        //每行的对齐方式的调整。
        if (self.flowLayout.tg_orientation == .vert)
        {
            let  mg = self.flowLayout.tg_arrangedGravity & TGGravity.horz.mask
            
            if (mg == .none || mg == TGGravity.vert.top)
            {
                self.flowLayout.tg_arrangedGravity = [(self.flowLayout.tg_arrangedGravity & TGGravity.vert.mask), TGGravity.vert.center]
            }
            else if (mg == TGGravity.vert.center)
            {
                self.flowLayout.tg_arrangedGravity = [(self.flowLayout.tg_arrangedGravity & TGGravity.vert.mask), TGGravity.vert.bottom]
            }
            else if (mg  == TGGravity.vert.bottom)
            {
                self.flowLayout.tg_arrangedGravity = [(self.flowLayout.tg_arrangedGravity & TGGravity.vert.mask), TGGravity.vert.fill]
            }
            else if (mg == TGGravity.vert.fill)
            {
                self.flowLayout.tg_arrangedGravity = [(self.flowLayout.tg_arrangedGravity & TGGravity.vert.mask), TGGravity.vert.top]
                
                for vv in self.flowLayout.subviews
                {
                    vv.sizeToFit()
                }
                
            }
        }
        else
        {
            let  mg = self.flowLayout.tg_arrangedGravity & TGGravity.vert.mask
            
            if (mg == .none || mg == TGGravity.horz.left)
            {
                self.flowLayout.tg_arrangedGravity = [self.flowLayout.tg_arrangedGravity & TGGravity.horz.mask, TGGravity.horz.center]
            }
            else if (mg == TGGravity.horz.center)
            {
                self.flowLayout.tg_arrangedGravity = [self.flowLayout.tg_arrangedGravity & TGGravity.horz.mask, TGGravity.horz.right]
            }
            else if (mg  == TGGravity.horz.right)
            {
                self.flowLayout.tg_arrangedGravity = [self.flowLayout.tg_arrangedGravity & TGGravity.horz.mask, TGGravity.horz.fill]
            }
            else if (mg == TGGravity.horz.fill)
            {
                self.flowLayout.tg_arrangedGravity = [self.flowLayout.tg_arrangedGravity & TGGravity.horz.mask, TGGravity.horz.left]
                
                for vv in self.flowLayout.subviews
                {
                    vv.sizeToFit()
                }
                
            }
            
            
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)
    }
    
    func handleAdjustMargin(_ sender:AnyObject?)
    {
        //调整子视图之间的间距
        
        if (self.flowLayout.tg_hspace == 0)
        {
          self.flowLayout.tg_hspace = 5
        }
        else
        {
          self.flowLayout.tg_hspace = 0
        }
        
        if (self.flowLayout.tg_vspace == 0)
        {
            self.flowLayout.tg_vspace = 5
        }
        else
        {
            self.flowLayout.tg_vspace = 0
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)

    }

}

