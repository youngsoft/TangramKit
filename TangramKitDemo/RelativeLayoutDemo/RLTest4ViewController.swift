//
//  RLTest3ViewController.swift
//  TangramKit
//
//  Created by zhangguangkai on 16/5/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



class RLTest4ViewController: UIViewController {

    var testTopDockView:UIView!
    var testView1:UIView!    //记录浮动的视图的上个位置的视图。
    
    
    func createLabel(_ title: String, backgroundColor color: UIColor) -> UILabel {
        let v = UILabel()
        v.text = title
        v.backgroundColor = color
        v.textColor = CFTool.color(0)
        v.font = CFTool.font(17)
        v.numberOfLines = 0
        return v
    }
    
    override func loadView() {
        
        /*
         这个例子用来介绍相对布局和滚动视图的结合，来实现滚动以及子视图的停靠的实现，其中主要的方式是通过子视图的属性tg_noLayout来简单的实现这个功能。
         
         这里之所以用相对布局来实现滚动和停靠的原因是，线性布局、流式布局、浮动布局这几种布局都是根据添加的顺序来排列的。一般情况下，前面添加的子视图会显示在底部，而后面添加的子视图则会显示在顶部，所以一旦我们出现这种滚动，且某个子视图固定停靠时，我们一般要求这个停靠的子视图要放在最上面，也就是最后一个.
         */
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView;
        scrollView.delegate = self;
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        let rootLayout = TGRelativeLayout()
        rootLayout.tg_insetsPaddingFromSafeArea = [.left, .right, .top] //为了防止拉到底部时iPhoneX设备的抖动发生，不能将底部安全区叠加到padding中去。
        rootLayout.tg_padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_width.equal(.fill)
        scrollView.addSubview(rootLayout)
        
        //添加色块。
        let v1 = self.createLabel(NSLocalizedString("Scroll the view please", comment: ""), backgroundColor: CFTool.color(1))
        v1.tg_width.equal(.fill)  //填充父视图的剩余宽度。
        v1.tg_height.equal(80)
        rootLayout.addSubview(v1)
        self.testView1 = v1
        
        
        let v2 = self.createLabel("", backgroundColor: CFTool.color(2))
        v2.tg_width.equal(100%)  //占用父视图宽度的100%
        v2.tg_height.equal(200);
        rootLayout.addSubview(v2)
        
        
        let v3 = self.createLabel("", backgroundColor: CFTool.color(3))
        v3.tg_leading.equal(0)
        v3.tg_trailing.equal(0)    //左右边距为0表示宽度和父视图相等。
        v3.tg_height.equal(800)
        v3.tg_top.equal(v2.tg_bottom)
        rootLayout.addSubview(v3)
        
        
        //这里最后一个加入的子视图作为滚动时的停靠视图。。
        let v4 = self.createLabel(NSLocalizedString("This view will Dock to top when scroll", comment:""), backgroundColor: CFTool.color(4))
        v4.tg_width.equal(rootLayout.tg_width)   //和父视图一样宽。
        v4.tg_height.equal(80)
        v4.tg_top.equal(v1.tg_bottom)
        rootLayout.addSubview(v4)
        self.testTopDockView = v4;
        
        v2.tg_top.equal(v4.tg_bottom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


//MARK: - Layout Construction
extension RLTest4ViewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //v4的上面视图是v1。所以这里如果偏移超过v1的最大则开始固定v4了
        if (scrollView.contentOffset.y > self.testView1.frame.maxY)
        {
            
            /*
             当滚动条偏移的位置大于某个值后，我们将特定的子视图的tg_noLayout设置为YES，表示特定的子视图虽然会参与布局，但是在布局完成后不会更新frame值。
             因为参与了布局，所以不会影响到依赖这个视图的其他视图，所以整体布局结构是保持不变，这时候虽然设置为了tg_noLayout的视图留出了一个空挡，但是却可以通过frame值来进行任意的定位而不受到布局的控制。
             
             上面的代码中我们可以看到v4视图的位置和尺寸设置如下：
             v4.tg_width.equal(rootLayout.tg_width);  //宽度和父视图相等。
             v4.tg_height.equal(80);              //高度等于80。
             v4.tg_top.equalTo(v1.tg_bottom);         //总是位于v1的下面。
             。。。。
             v2.tg_top.equalTo(v4.tg_bottom);         //v2则总是位于v4的下面。
             
             而当我们将v4的tg_noLayout设置为了YES后，这时候v4仍然会参与布局，也就是说v4的那块区域和位置是保持不变的，v2还是会在v4的下面。但是v4却可以通过frame值进行任意位置和尺寸的改变。 这样就实现了当滚动时我们调整v4的真实frame值来达到悬停的功能，但是v2却保持了不变，还是向往常一样保持在那个v4假位置的下面，而随着滚动条滚动而滚动。
             
             ***需要注意的是这个特定的子视图一定要最后加入到布局视图中去。***
             */
           
                self.testTopDockView.tg_noLayout = true
            
                let rect = self.testTopDockView.frame;
                self.testTopDockView.frame = CGRect(x:rect.origin.x, y:scrollView.contentOffset.y, width:rect.size.width, height:rect.size.height)
            
        }
        else
        {
            self.testTopDockView.tg_noLayout = false
        }

    }

}

