//
//  LLTest5ViewController.swift
//  TangramKit
//
//  Created by yant on 10/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *5.LinearLayout - Weight & Relative margin
 */
class LLTest5ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLabel(_ title: String, color backgroundColor: UIColor) -> UILabel {
        let v = UILabel()
        v.text = title
        v.adjustsFontSizeToFitWidth = true
        v.textAlignment = .center
        v.backgroundColor = backgroundColor
        v.font = CFTool.font(15)
        v.layer.shadowOffset = CGSize(width: CGFloat(3), height: CGFloat(3))
        v.layer.shadowColor = CFTool.color(4).cgColor
        v.layer.shadowRadius = 2
        v.layer.shadowOpacity = 0.3
        return v
    }
    
    override func loadView() {
        
        /*
         这个例子主要用来介绍布局视图里面子视图的相对尺寸和相对间距的概念。对于线性布局来说子视图的相对尺寸我们需要将尺寸和位置的值设置为TGWeight类型。
         所谓子视图的相对值表示的是值不是一个明确的绝对值，而是一个比例或者比重值，最终的结果则会根据布局视图的剩余尺寸计算出来。布局视图的剩余尺寸是指将布局视图的尺寸扣除掉那些有绝对尺寸或者有绝对间距的子视图的尺寸和间距后剩余下来的空间。所有子视图的相对值的比重就是在布局视图的剩余尺寸下的比重。
         
         对于垂直线性布局来说当某个子视图的tg_height设置为TGWeight类型的值时则表示其高度是相对尺寸，而对于水平线性布局来说当某个子视图的tg_width设置为TGWeight类型的值时则表示其宽度是相对尺寸。
         对于线性布局和框架布局来说当某个子视图的位置TGLayoutPos对象的值设置为TGWeight类型时使用的相对的间距，否则使用的将是绝对的间距。
         
         下面的例子说明了相对尺寸和相对间距的概念：
         假如某个垂直线性布局的高度是200，其中里面有A,B,C,D四个子视图。其中：
         A的tg_top ~= 10,  tg_height ~= 20,   tg_bottom ~= 10%
         B的tg_top ~= 20%, tg_height ~= 30,  tg_bottom ~= 0
         C的tg_top ~= 5,   tg_height ~= 30%, tg_bottom ~= 10
         D的tg_top ~= 30%, tg_height ~= 20%, tg_bottom ~= 40%
         
         上面例子中：
         绝对部分的高度总和=A.tg_top + A.tg_height + B.tg_height + B.tg_bottom + C.tg_top + C.tg_bottom = 75
         相对部分的比重和为 = A.tg_bottom + B.tg_top + C.tg_height + D.tg_top + D.tg_height + D.tg_bottom = 1.5
         布局视图的剩余空间 = 总高度 - 绝对高度 = 200 - 75 = 125
         因此最终的上图中的各相对比重的转化为绝对值后的结果如下：
         A.tg_bottom = 125 * 0.1/1.5 ≈ 8
         B.tg_top = 125 * 0.2/1.5  ≈ 17
         C.tg_height = 125 * 0.3/1.5 ≈  25
         D.tg_top = 125 *0.3/1.5 ≈ 25
         D.tg_height = 125 *0.2/1.5 ≈ 17
         D.tg_bottom ≈ 33
         
         
         如果布局视图里面的子视图使用了相对尺寸和相对间距我们必须要满足如下的条件：
         
         1.垂直线性布局里面如果有子视图的tg_height设置为了TGWeight或者指定了垂直相对间距，则布局视图的tg_height的.wrap将失效；水平线性布局里面如果有子视图的宽度tg_width设置为了TGWeight或者指定了水平相对间距，则布局视图的tg_width的.wrap将失效。
         2.如果布局视图里面的子视图使用了相对间距和相对尺寸则必须要明确指定布局视图的宽度或者高度，否则相对设置可能会失效。
         
         */

        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = CFTool.color(0)
        self.view = rootLayout
        
        
        let  v1 = self.createLabel(NSLocalizedString("width equal to superview, height equal to 20% of free height of superview", comment: ""), color:CFTool.color(5))
        v1.numberOfLines = 3
        v1.tg_top.equal(self.topLayoutGuide, offset:10)
        v1.tg_width.equal(100%)  //等价于v1.tg_width.equal(.fill)
        //您可以设置为:
        //v1.tg_width ~= 100%
        v1.tg_height.equal(20%)  // 等价于 v1.tg_height.equal(TGWeight(20)) %这是是将数字转化为TGWeight的运算符。
        rootLayout.addSubview(v1)
        
        
        let  v2 = self.createLabel(NSLocalizedString("width equal to 80% of superview, height equal to 30% of free height of superview", comment: ""), color:CFTool.color(6))
        v2.numberOfLines = 2
        v2.tg_top.equal(10)
        v2.tg_centerX.equal(0)
        v2.tg_width.equal(80%)  //父视图的宽度的0.8
        v2.tg_height.equal(30%)
        rootLayout.addSubview(v2)
        
        
        let  v3 = self.createLabel(NSLocalizedString("width equal to superview - 20, height equal to 50% of free height of superview", comment: ""), color:CFTool.color(7))
        v3.numberOfLines = 0
        v3.tg_top.equal(10)
        v3.tg_trailing.equal(0)  //右对齐。
        v3.tg_width.equal(100%, increment:-20)  //等价于v3.tg_width.equal(.fill, increment:-20)
        v3.tg_height.equal(50%)
        rootLayout.addSubview(v3)
        
        
        let  v4 = self.createLabel(NSLocalizedString("width equal to 200, height equal to 50", comment: ""), color:CFTool.color(8))
        v4.numberOfLines = 2
        v4.tg_top.equal(10)
        v4.tg_width.equal(200)
        v4.tg_height.equal(50)
        rootLayout.addSubview(v4)
        
        
        let  v5 = self.createLabel(NSLocalizedString("left margin equal to 20% of superview, right margin equal to 30% of superview, width equal to 50% of superview, top spacing equal to 5% of free height of superview, bottom spacing equal to 10% of free height of superview", comment: ""), color:CFTool.color(9))
        v5.numberOfLines = 0
        v5.tg_leading.equal(20%)
        v5.tg_trailing.equal(30%)
        v5.tg_top.equal(5%)
        v5.tg_bottom.equal(10%)
        v5.tg_height.equal(10%)
        rootLayout.addSubview(v5)

    }
    
    
}
