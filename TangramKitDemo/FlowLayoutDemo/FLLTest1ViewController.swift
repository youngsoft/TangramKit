//
//  FwTest1ViewController.swift
//  TangramKit
//
//  Created by 佳达 on 16/5/6.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 * 1.FlowLayout - Regular arrangement
 */
class FLLTest1ViewController: UIViewController {
   
    weak var flowLayoutSetLabel:UILabel!
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
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        let rootLayout = TGLinearLayout(.vert)
        //里面所有子视图的宽度都填充为和父视图一样宽。
        rootLayout.tg.gravity(value: TGGravity.Horizontal.fill)
        rootLayout.backgroundColor = .white
        self.view = rootLayout

        
        //添加操作按钮。
        let actionLayout = TGFlowLayout(.vert, arrangedCount: 2)
        actionLayout.tg.height.equal(.wrap)
        //所有子视图水平填充，也就是所有子视图的宽度相等。
        actionLayout.tg.gravity(value: TGGravity.Horizontal.fill)
        actionLayout.tg.padding(value: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        actionLayout.tg.hspace(value: 5)
        actionLayout.tg.vspace(value: 5)
        rootLayout.addSubview(actionLayout)
        
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust orientation", comment:""), action:#selector(handleAdjustOrientation)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust arrangedCount", comment:""),action:#selector(handleAdjustArrangedCount)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust vert gravity", comment:""),
        action:#selector(handleAdjustVertGravity)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust horz gravity", comment:""),
        action:#selector(handleAdjustHorzGravity)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust align", comment:""),
        action:#selector(handleAdjustArrangeGravity)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust spacing", comment:""),
        action:#selector(handleAdjustSpace)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("adjust gravity policy", comment:""),
                                                        action:#selector(handleAdjustGravityPolicy)))
        
        let flowLayoutSetLabel = UILabel()
        flowLayoutSetLabel.font = CFTool.font(13)
        flowLayoutSetLabel.textColor = .red
        flowLayoutSetLabel.adjustsFontSizeToFitWidth = true
        flowLayoutSetLabel.tg.height.equal(.wrap)
        flowLayoutSetLabel.numberOfLines = 6
        rootLayout.addSubview(flowLayoutSetLabel)
        self.flowLayoutSetLabel = flowLayoutSetLabel
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.tg.height.equal(.fill) //占用剩余的高度。
        scrollView.tg.top.equal(10)
        rootLayout.addSubview(scrollView)
        
        
        let flowLayout = TGFlowLayout(.vert,arrangedCount: 3)
        flowLayout.backgroundColor = CFTool.color(0)
        flowLayout.tg.width.equal(800)
        flowLayout.tg.height.equal(800)
        flowLayout.tg.padding(value: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        flowLayout.tg.vspace(value: 5)
        flowLayout.tg.hspace(value: 5)
        scrollView.addSubview(flowLayout)
        self.flowLayout = flowLayout
        
        let imageArray = ["minions1","minions2","minions3","minions4","head1"]
        
        for _ in 0 ..< 30
        {
            let imageView = UIImageView(image:UIImage(named:imageArray[Int(arc4random()%5)]))
            imageView.layer.borderColor = CFTool.color(5).cgColor
            imageView.layer.borderWidth = 0.5
            self.flowLayout.addSubview(imageView)
        }
        
        self.flowlayoutInfo()
    }
}

//MAKR: -Layout Construction
extension FLLTest1ViewController
{
    //创建动作操作按钮。
    func createActionButton(_ title:String,action:Selector) ->UIButton
    {
        let button = UIButton(type:.system)
        button.setTitle(title, for: UIControl.State())
        button.titleLabel?.font = CFTool.font(14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self,action:action, for:.touchUpInside)
        button.tg.height.equal(30)
        return button
    
    }
    
}

//MARK: -Handle Method
extension FLLTest1ViewController
{
    @objc func handleAdjustOrientation(_ sender:AnyObject?)
    {
        //调整流式布局的方向。
        if (self.flowLayout.tg.orientation() == .vert)
        {
            self.flowLayout.tg.orientation(value: .horz)
        }
        else
        {
            self.flowLayout.tg.orientation(value: .vert)
        }
        
        self.flowLayout.tg.layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()

    }
    
    @objc func handleAdjustArrangedCount(_ sender:AnyObject?)
    {
        
        //调整流式布局的每行的数量。
        self.flowLayout.tg.arrangedCount(value: (self.flowLayout.tg.arrangedCount() + 1) % 6)
        self.flowLayout.tg.layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()

    }
    
    @objc func handleAdjustVertGravity(_ sender:AnyObject?)
    {
        //调整整体垂直方向的停靠
        
        var vertGravity = self.flowLayout.tg.gravity() & TGGravity.Horizontal.mask
        let horzGravity = self.flowLayout.tg.gravity() & TGGravity.Vertical.mask
        
        switch (vertGravity) {
        case TGGravity.none:
            vertGravity = TGGravity.Vertical.center;
            break
        case TGGravity.Vertical.top:
            vertGravity = TGGravity.Vertical.center;
            break;
        case TGGravity.Vertical.center:
            vertGravity = TGGravity.Vertical.bottom;
            break;
        case TGGravity.Vertical.bottom:
            vertGravity = TGGravity.Vertical.between;
            break;
        case TGGravity.Vertical.between:
            vertGravity = TGGravity.Vertical.around
            break;
        case TGGravity.Vertical.around:
            vertGravity = TGGravity.Vertical.among
            break
        case TGGravity.Vertical.among:
            vertGravity = TGGravity.Vertical.fill
            break
        case TGGravity.Vertical.fill:
                vertGravity = TGGravity.Vertical.top;
                self.flowLayout.subviews.forEach({ (v:UIView) in
                    v.sizeToFit()
                })
           break
        default:
            break;
        }
        
        self.flowLayout.tg.gravity(value: [horzGravity,vertGravity])
        self.flowLayout.tg.layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()

        
    }

    
    
    @objc func handleAdjustHorzGravity(_ sender:AnyObject?)
    {
        //调整整体水平方向的停靠。
        
        let vertGravity = self.flowLayout.tg.gravity() & TGGravity.Horizontal.mask;
        var horzGravity = self.flowLayout.tg.gravity() & TGGravity.Vertical.mask;
        
        switch (horzGravity) {
        case TGGravity.none:
            horzGravity = TGGravity.Horizontal.center;
            break
        case TGGravity.Horizontal.left:
            horzGravity = TGGravity.Horizontal.center;
            break;
        case TGGravity.Horizontal.center:
            horzGravity = TGGravity.Horizontal.right;
            break;
        case TGGravity.Horizontal.right:
            horzGravity = TGGravity.Horizontal.between;
            break;
        case TGGravity.Horizontal.between:
            horzGravity = TGGravity.Horizontal.around;
            break;
        case TGGravity.Horizontal.around:
            horzGravity = TGGravity.Horizontal.among;
            break
        case TGGravity.Horizontal.among:
            horzGravity = TGGravity.Horizontal.fill
            break
        case TGGravity.Horizontal.fill:
            horzGravity = TGGravity.Horizontal.left;
            self.flowLayout.subviews.forEach({ (v:UIView) in
                v.sizeToFit()
            })
            break
        default:
            break;
        }
        
        self.flowLayout.tg.gravity(value: [horzGravity,vertGravity])
        self.flowLayout.tg.layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()


        
    }
    
    @objc func handleAdjustArrangeGravity(_ sender:AnyObject?)
    {
        var vertArrangeGravity = self.flowLayout.tg.arrangedGravity() & TGGravity.Horizontal.mask
        var horzArrangeGravity = self.flowLayout.tg.arrangedGravity() & TGGravity.Vertical.mask
        
        //每行的对齐方式的调整。
        if (self.flowLayout.tg.orientation() == .vert)
        {
            
            if (vertArrangeGravity == .none || vertArrangeGravity == TGGravity.Vertical.top)
            {
                vertArrangeGravity =  TGGravity.Vertical.center
            }
            else if (vertArrangeGravity == TGGravity.Vertical.center)
            {
                vertArrangeGravity =  TGGravity.Vertical.bottom

            }
            else if (vertArrangeGravity  == TGGravity.Vertical.bottom)
            {
                vertArrangeGravity =  TGGravity.Vertical.fill
            }
            else if (vertArrangeGravity == TGGravity.Vertical.fill)
            {
                vertArrangeGravity = TGGravity.Vertical.top
                
                self.flowLayout.subviews.forEach({ (v:UIView) in
                    v.sizeToFit()
                })
                
            }
        }
        else
        {
            
            if (horzArrangeGravity == .none || horzArrangeGravity == TGGravity.Horizontal.left)
            {
                horzArrangeGravity = TGGravity.Horizontal.center
            }
            else if (horzArrangeGravity == TGGravity.Horizontal.center)
            {
                horzArrangeGravity = TGGravity.Horizontal.right
            }
            else if (horzArrangeGravity  == TGGravity.Horizontal.right)
            {
                horzArrangeGravity = TGGravity.Horizontal.fill
            }
            else if (horzArrangeGravity == TGGravity.Horizontal.fill)
            {
                horzArrangeGravity = TGGravity.Horizontal.left
                
                self.flowLayout.subviews.forEach({ (v:UIView) in
                    v.sizeToFit()
                })
            }
            
            
        }
        
        self.flowLayout.tg.arrangedGravity(value: [vertArrangeGravity, horzArrangeGravity])
        self.flowLayout.tg.layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()
    }
    
    @objc func handleAdjustSpace(_ sender:AnyObject?)
    {
        //调整子视图之间的间距
        
        if (self.flowLayout.tg.hspace() == 0)
        {
          self.flowLayout.tg.hspace(value: 5)
        }
        else
        {
          self.flowLayout.tg.hspace(value: 0)
        }
        
        if (self.flowLayout.tg.vspace() == 0)
        {
            self.flowLayout.tg.vspace(value: 5)
        }
        else
        {
            self.flowLayout.tg.vspace(value: 0)
        }
        
        self.flowLayout.tg.layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()
    }
    
    @objc func handleAdjustGravityPolicy(_ sender:AnyObject?) {
        
        switch self.flowLayout.tg.lastlineGravityPolicy() {
        case TGGravityPolicy.always:
            self.flowLayout.tg.lastlineGravityPolicy(value: TGGravityPolicy.auto)
            break
        case TGGravityPolicy.auto:
            self.flowLayout.tg.lastlineGravityPolicy(value: TGGravityPolicy.no)
            break
        case TGGravityPolicy.no:
            self.flowLayout.tg.lastlineGravityPolicy(value: TGGravityPolicy.always)
            break
        }
        
        self.flowLayout.subviews.forEach({ (v:UIView) in
            v.sizeToFit()
        })
        
        self.flowLayout.tg.layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()
    }

}

//MARK: -Private Method
extension FLLTest1ViewController
{
    func flowlayoutInfo()
    {
        var orientationStr = ""
        if (self.flowLayout.tg.orientation() == .vert)
        {
            orientationStr = "TGOrientation.vert"
        }
        else
        {
            orientationStr = "TGOrientation.horz"
        }
    
    
        let arrangeCountStr = "\(self.flowLayout.tg.arrangedCount())"
    
        let gravityStr = self.gravityInfo(self.flowLayout.tg.gravity())
    
        let arrangedGravityStr = self.gravityInfo(self.flowLayout.tg.arrangedGravity())
    
        let subviewSpaceStr = "vert:\(self.flowLayout.tg.vspace()), horz:\(self.flowLayout.tg.hspace())"
        
        let gravityPolicyStr = self.gravityPolicyInfo(self.flowLayout.tg.lastlineGravityPolicy())

    
        self.flowLayoutSetLabel.text = "flowLayout:\norientation=" + orientationStr + ",arrangedCount=" + arrangeCountStr + "\ngravity="+gravityStr + "\narrangedGravity=" + arrangedGravityStr + "\nsubviewMargin=(" + subviewSpaceStr + ")\n " + gravityPolicyStr
    }
    
    func gravityPolicyInfo(_ gravityPolicy:TGGravityPolicy) ->String {
        
        switch self.flowLayout.tg.lastlineGravityPolicy() {
        case TGGravityPolicy.always:
            return "policy:always"
        case TGGravityPolicy.auto:
            return "policy:auto"
        case TGGravityPolicy.no:
            return "policy:no"
        }
    }
    
    func gravityInfo(_ gravity:TGGravity) ->String
    {
        //分别取出垂直和水平方向的停靠设置。
        let vertGravity = gravity & TGGravity.Horizontal.mask
        let  horzGravity = gravity & TGGravity.Vertical.mask
        
        var vertGravityStr = ""
        switch (vertGravity) {
        case TGGravity.Vertical.top:
            vertGravityStr = "TGGravity.Vertical.top"
            break
        case TGGravity.Vertical.center:
            vertGravityStr = "TGGravity.Vertical.center"
            break
        case TGGravity.Vertical.bottom:
            vertGravityStr = "TGGravity.Vertical.bottom"
            break
        case TGGravity.Vertical.fill:
            vertGravityStr = "TGGravity.Vertical.fill"
            break
        case TGGravity.Vertical.between:
            vertGravityStr = "TGGravity.Vertical.between"
            break
        case TGGravity.Vertical.around:
            vertGravityStr = "TGGravity.Vertical.around"
            break
        case TGGravity.Vertical.among:
            vertGravityStr = "TGGravity.Vertical.among"
            break
        default:
            vertGravityStr = "TGGravity.Vertical.top"
            break
        }
        
        var horzGravityStr = ""
        switch (horzGravity) {
        case TGGravity.Horizontal.left:
            horzGravityStr = "TGGravity.Horizontal.left"
            break
        case TGGravity.Horizontal.center:
            horzGravityStr = "TGGravity.Horizontal.center"
            break
        case TGGravity.Horizontal.right:
            horzGravityStr = "TGGravity.Horizontal.right"
            break
        case TGGravity.Horizontal.fill:
            horzGravityStr = "TGGravity.Horizontal.fill"
            break
        case TGGravity.Horizontal.between:
            horzGravityStr = "TGGravity.Horizontal.between"
            break
        case TGGravity.Horizontal.around:
            horzGravityStr = "TGGravity.Horizontal.around"
            break
        case TGGravity.Horizontal.among:
            horzGravityStr = "TGGravity.Horizontal.among"
            break
        default:
            horzGravityStr = "TGGravity.Horizontal.left"
            break;
        }
        
        return vertGravityStr + "|" + horzGravityStr
        
        
    }
    

}
