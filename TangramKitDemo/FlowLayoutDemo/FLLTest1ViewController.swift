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
        rootLayout.tg_gravity = TGGravity.horz.fill //里面所有子视图的宽度都填充为和父视图一样宽。
        rootLayout.backgroundColor = .white
        self.view = rootLayout

        
        //添加操作按钮。
        let actionLayout = TGFlowLayout(.vert, arrangedCount: 2)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tg_gravity = TGGravity.horz.fill //所有子视图水平填充，也就是所有子视图的宽度相等。
        actionLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        actionLayout.tg_hspace = 5
        actionLayout.tg_vspace = 5
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
        flowLayoutSetLabel.tg_height.equal(.wrap)
        flowLayoutSetLabel.numberOfLines = 6
        rootLayout.addSubview(flowLayoutSetLabel)
        self.flowLayoutSetLabel = flowLayoutSetLabel
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.tg_height.equal(.fill) //占用剩余的高度。
        scrollView.tg_top.equal(10)
        rootLayout.addSubview(scrollView)
        
        
        let flowLayout = TGFlowLayout(.vert,arrangedCount: 3)
        flowLayout.backgroundColor = CFTool.color(0)
        flowLayout.tg_width.equal(800)
        flowLayout.tg_height.equal(800)
        flowLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.tg_vspace = 5
        flowLayout.tg_hspace = 5
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
        button.tg_height.equal(30)
        return button
    
    }
    
}

//MARK: -Handle Method
extension FLLTest1ViewController
{
    @objc func handleAdjustOrientation(_ sender:AnyObject?)
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
        self.flowlayoutInfo()

    }
    
    @objc func handleAdjustArrangedCount(_ sender:AnyObject?)
    {
        
        //调整流式布局的每行的数量。
        self.flowLayout.tg_arrangedCount = (self.flowLayout.tg_arrangedCount + 1) % 6
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()

    }
    
    @objc func handleAdjustVertGravity(_ sender:AnyObject?)
    {
        //调整整体垂直方向的停靠
        
        var vertGravity = self.flowLayout.tg_gravity & TGGravity.horz.mask
        let horzGravity = self.flowLayout.tg_gravity & TGGravity.vert.mask
        
        switch (vertGravity) {
        case TGGravity.none:
            vertGravity = TGGravity.vert.center;
            break
        case TGGravity.vert.top:
            vertGravity = TGGravity.vert.center;
            break;
        case TGGravity.vert.center:
            vertGravity = TGGravity.vert.bottom;
            break;
        case TGGravity.vert.bottom:
            vertGravity = TGGravity.vert.between;
            break;
        case TGGravity.vert.between:
            vertGravity = TGGravity.vert.around
            break;
        case TGGravity.vert.around:
            vertGravity = TGGravity.vert.among
            break
        case TGGravity.vert.among:
            vertGravity = TGGravity.vert.fill
            break
        case TGGravity.vert.fill:
                vertGravity = TGGravity.vert.top;
                self.flowLayout.subviews.forEach({ (v:UIView) in
                    v.sizeToFit()
                })
           break
        default:
            break;
        }
        
        self.flowLayout.tg_gravity = [horzGravity,vertGravity]
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()

        
    }

    
    
    @objc func handleAdjustHorzGravity(_ sender:AnyObject?)
    {
        //调整整体水平方向的停靠。
        
        let vertGravity = self.flowLayout.tg_gravity & TGGravity.horz.mask;
        var horzGravity = self.flowLayout.tg_gravity & TGGravity.vert.mask;
        
        switch (horzGravity) {
        case TGGravity.none:
            horzGravity = TGGravity.horz.center;
            break
        case TGGravity.horz.left:
            horzGravity = TGGravity.horz.center;
            break;
        case TGGravity.horz.center:
            horzGravity = TGGravity.horz.right;
            break;
        case TGGravity.horz.right:
            horzGravity = TGGravity.horz.between;
            break;
        case TGGravity.horz.between:
            horzGravity = TGGravity.horz.around;
            break;
        case TGGravity.horz.around:
            horzGravity = TGGravity.horz.among;
            break
        case TGGravity.horz.among:
            horzGravity = TGGravity.horz.fill
            break
        case TGGravity.horz.fill:
            horzGravity = TGGravity.horz.left;
            self.flowLayout.subviews.forEach({ (v:UIView) in
                v.sizeToFit()
            })
            break
        default:
            break;
        }
        
        self.flowLayout.tg_gravity = [horzGravity,vertGravity]
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()


        
    }
    
    @objc func handleAdjustArrangeGravity(_ sender:AnyObject?)
    {
        var vertArrangeGravity = self.flowLayout.tg_arrangedGravity & TGGravity.horz.mask
        var horzArrangeGravity = self.flowLayout.tg_arrangedGravity & TGGravity.vert.mask
        
        //每行的对齐方式的调整。
        if (self.flowLayout.tg_orientation == .vert)
        {
            
            if (vertArrangeGravity == .none || vertArrangeGravity == TGGravity.vert.top)
            {
                vertArrangeGravity =  TGGravity.vert.center
            }
            else if (vertArrangeGravity == TGGravity.vert.center)
            {
                vertArrangeGravity =  TGGravity.vert.bottom

            }
            else if (vertArrangeGravity  == TGGravity.vert.bottom)
            {
                vertArrangeGravity =  TGGravity.vert.fill
            }
            else if (vertArrangeGravity == TGGravity.vert.fill)
            {
                vertArrangeGravity = TGGravity.vert.top
                
                self.flowLayout.subviews.forEach({ (v:UIView) in
                    v.sizeToFit()
                })
                
            }
        }
        else
        {
            
            if (horzArrangeGravity == .none || horzArrangeGravity == TGGravity.horz.left)
            {
                horzArrangeGravity = TGGravity.horz.center
            }
            else if (horzArrangeGravity == TGGravity.horz.center)
            {
                horzArrangeGravity = TGGravity.horz.right
            }
            else if (horzArrangeGravity  == TGGravity.horz.right)
            {
                horzArrangeGravity = TGGravity.horz.fill
            }
            else if (horzArrangeGravity == TGGravity.horz.fill)
            {
                horzArrangeGravity = TGGravity.horz.left
                
                self.flowLayout.subviews.forEach({ (v:UIView) in
                    v.sizeToFit()
                })
            }
            
            
        }
        
        self.flowLayout.tg_arrangedGravity = [vertArrangeGravity, horzArrangeGravity]
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()
    }
    
    @objc func handleAdjustSpace(_ sender:AnyObject?)
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
        self.flowlayoutInfo()
    }
    
    @objc func handleAdjustGravityPolicy(_ sender:AnyObject?) {
        
        switch self.flowLayout.tg_lastlineGravityPolicy {
        case TGGravityPolicy.always:
            self.flowLayout.tg_lastlineGravityPolicy = TGGravityPolicy.auto
            break
        case TGGravityPolicy.auto:
            self.flowLayout.tg_lastlineGravityPolicy = TGGravityPolicy.no
            break
        case TGGravityPolicy.no:
            self.flowLayout.tg_lastlineGravityPolicy = TGGravityPolicy.always
            break
        }
        
        self.flowLayout.subviews.forEach({ (v:UIView) in
            v.sizeToFit()
        })
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.4)
        self.flowlayoutInfo()
    }

}

//MARK: -Private Method
extension FLLTest1ViewController
{
    func flowlayoutInfo()
    {
        var orientationStr = ""
        if (self.flowLayout.tg_orientation == .vert)
        {
            orientationStr = "TGOrientation.vert"
        }
        else
        {
            orientationStr = "TGOrientation.horz"
        }
    
    
        let arrangeCountStr = "\(self.flowLayout.tg_arrangedCount)"
    
        let gravityStr = self.gravityInfo(self.flowLayout.tg_gravity)
    
        let arrangedGravityStr = self.gravityInfo(self.flowLayout.tg_arrangedGravity)
    
        let subviewSpaceStr = "vert:\(self.flowLayout.tg_vspace), horz:\(self.flowLayout.tg_hspace)"
        
        let gravityPolicyStr = self.gravityPolicyInfo(self.flowLayout.tg_lastlineGravityPolicy)

    
        self.flowLayoutSetLabel.text = "flowLayout:\norientation=" + orientationStr + ",arrangedCount=" + arrangeCountStr + "\ngravity="+gravityStr + "\narrangedGravity=" + arrangedGravityStr + "\nsubviewMargin=(" + subviewSpaceStr + ")\n " + gravityPolicyStr
    }
    
    func gravityPolicyInfo(_ gravityPolicy:TGGravityPolicy) ->String {
        
        switch self.flowLayout.tg_lastlineGravityPolicy {
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
        let vertGravity = gravity & TGGravity.horz.mask
        let  horzGravity = gravity & TGGravity.vert.mask
        
        var vertGravityStr = ""
        switch (vertGravity) {
        case TGGravity.vert.top:
            vertGravityStr = "TGGravity.vert.top"
            break
        case TGGravity.vert.center:
            vertGravityStr = "TGGravity.vert.center"
            break
        case TGGravity.vert.bottom:
            vertGravityStr = "TGGravity.vert.bottom"
            break
        case TGGravity.vert.fill:
            vertGravityStr = "TGGravity.vert.fill"
            break
        case TGGravity.vert.between:
            vertGravityStr = "TGGravity.vert.between"
            break
        case TGGravity.vert.around:
            vertGravityStr = "TGGravity.vert.around"
            break
        case TGGravity.vert.among:
            vertGravityStr = "TGGravity.vert.among"
            break
        default:
            vertGravityStr = "TGGravity.vert.top"
            break
        }
        
        var horzGravityStr = ""
        switch (horzGravity) {
        case TGGravity.horz.left:
            horzGravityStr = "TGGravity.horz.left"
            break
        case TGGravity.horz.center:
            horzGravityStr = "TGGravity.horz.center"
            break
        case TGGravity.horz.right:
            horzGravityStr = "TGGravity.horz.right"
            break
        case TGGravity.horz.fill:
            horzGravityStr = "TGGravity.horz.fill"
            break
        case TGGravity.horz.between:
            horzGravityStr = "TGGravity.horz.between"
            break
        case TGGravity.horz.around:
            horzGravityStr = "TGGravity.horz.around"
            break
        case TGGravity.horz.among:
            horzGravityStr = "TGGravity.horz.among"
            break
        default:
            horzGravityStr = "TGGravity.horz.left"
            break;
        }
        
        return vertGravityStr + "|" + horzGravityStr
        
        
    }
    

}
