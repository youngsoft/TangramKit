//
//  AllTest8ViewController.swift
//  TangramKit
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 * ❁2.Screen perfect fit - Demo2
 */
class AllTest8ViewController: UIViewController {
    
    
    func createDemoButton(_ title: String, action: Selector) -> UIButton
    {
        let btn = UIButton(type: .system)
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.setTitle(title, for: .normal)
        btn.titleLabel!.font = CFTool.font(15)
        btn.sizeToFit()
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }
    

    override func viewDidLoad() {
        
        if #available(iOS 11.0, *)
        {
        }
        else
        {
          self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
        }
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .white


        // Do any additional setup after loading the view.
        /*
         本例子演示当把一个布局视图加入到非布局视图时的各种场景。当把一个布局视图加入到非布局父视图时，因为无法完全对非布局父视图进行控制。所以一些布局视图的属性将不再起作用了，但是基本的视图扩展属性： tg_leading,tg_trailing,tg_top,tg_bottom,tg_centerX,tg_centerY，tg_width,tg_height这几个属性仍然有意义，只不过这些属性的equal方法能设置的类型有限，而且这些设置都只是基于父视图的。
         */

        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = self.view.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scrollView)
        
        //按钮用AutoLayout来实现，本例子说明AutoLayout是可以和TangramKit混合使用的。
        let button = self.createDemoButton(NSLocalizedString("Pop layoutview at center", comment: ""), action: #selector(handleDemo1))
        button.translatesAutoresizingMaskIntoConstraints = false  //button使用AutoLayout设置约束
        scrollView.addSubview(button)
        
        //下面的代码是iOS6以来自带的约束布局写法，可以看出代码量较大。
        scrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 10))
        scrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        scrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: -20))
        
        
        //下面的代码是iOS9以后提供的一种简便的约束设置方法。可以看出其中各种属性设置方式和MyLayout是相似的。
        //在iOS9提供的NSLayoutXAxisAnchor，NSLayoutYAxisAnchor，NSLayoutDimension这三个类提供了和TangramKit中的TGLayoutPos,TGLayoutSize类等价的功能。
        
            if #available(iOS 9.0, *) {
                button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                button.topAnchor.constraint(equalTo: scrollView.topAnchor, constant:10).isActive = true
                button.heightAnchor.constraint(equalToConstant: 40).isActive = true
                button.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier:1, constant:-20).isActive = true

            } else {
                // Fallback on earlier versions
            }

        
        //如果您用TangramKit布局。并且button在一个垂直线性布局下那么可以写成如下：
        /*
         button.tg_top.equal(10)
         button.tg_height.equal(40)
         button.tg_leading.equal(10)
         button.tg_trailing.equal(10)
        */

        
        
        /*
         下面例子用来建立一个不规则的功能区块。
         */
        
        //建立一个浮动布局,这个浮动布局不会控制父视图UIScrollView的contentSize。
        let floatLayout = TGFloatLayout(.horz)
        floatLayout.backgroundColor = CFTool.color(0)
        floatLayout.tg_space = 10
        floatLayout.tg_leading.equal(10)
        floatLayout.tg_trailing.equal(10) //同时设定了左边和右边边距，布局视图的宽度就决定了。
        floatLayout.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);  //设置内边距。
        floatLayout.tg_top.equal(60)
        floatLayout.tg_bottom.equal(10) //底部边距为10，这样同样设置了顶部和底部边距后布局的高度就决定了。
        floatLayout.tg_adjustScrollViewContentSizeMode = .no  //布局视图不控制滚动视图的contentSize。
        /*这里面把布局视图加入到滚动视图时不会自动调整滚动视图的contentSize，如果不设置这个属性则当布局视图加入滚动视图时会自动调整滚动视图的contentSize。您可以把tg_adjustScrollViewContentSizeMode属性设置这句话注释掉，可以看到当使用默认设置时，UIScrollView的contentSize的值会完全受到布局视图的尺寸和边距控制，这时候：
         
         contentSize.height = 布局视图的高度+布局视图的tg_top设置的上边距值 + 布局视图的tg_bottom设置的下边距值。
         contentSize.width = 布局视图的宽度+布局视图的tg_leading设置的左距值 + 布局视图的tg_trailing设置的右边距值。
         
         */
        
        scrollView.addSubview(floatLayout)
        
        
        //这里定义高度占父视图的比例，每列分为5份，下面数组定义每个子视图的高度占比。
        let heightscale:[CGFloat] = [0.4, 0.2, 0.2, 0.2, 0.2, 0.4, 0.4]
        //因为分为左右2列，而要求每个视图之间的垂直间距为10，左边列的总间距是30，一共有4个，因此前4个都要减去-30/4的间距高度；右边列总间距为20，一共有3个，因此后3个都要减去-20/3的间距高度。
        let heightinc:[CGFloat] = [-30.0/4, -30.0/4, -30.0/4, -30.0/4, -20.0/3, -20.0/3, -20.0/3]
        for i in 0 ..< 7
        {
            let buttonTag = self.createDemoButton("不规则功能块", action:#selector(handleDemo1))
            buttonTag.contentVerticalAlignment = .top
            buttonTag.contentHorizontalAlignment = .left  //按钮内容左上角对齐。
            buttonTag.backgroundColor = CFTool.color(i + 5)
            buttonTag.tg_width.equal(floatLayout.tg_width, increment:-5, multiple: 0.5) //因为宽度都是父视图的一半，并且水平间距是10，所以这里比例是0.5，分别减去5个间距宽度。
            buttonTag.tg_height.equal(floatLayout.tg_height, increment:heightinc[i], multiple:heightscale[i]) //高度占比和所减的间距在上面数组里面定义。
            floatLayout.addSubview(buttonTag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleDemo1AddTest(sender:UIButton!)
    {
        if let label = sender.superview?.superview?.subviews[1] as? UILabel
        {
            label.text = label.text?.appending("添加文字。")
        }
        
    }
    
    @objc func handleDemo1RemoveLayout(sender:UIButton!)
    {
       UIView.perform(.delete, on: [sender.superview!.superview!], options: .curveLinear, animations: nil, completion: nil)
    }

    
    
    @objc func handleDemo1(sener:UIButton!)
    {
        //布局视图用来实现弹框，这里把一个布局视图放入一个非布局视图里面。
        let layout = TGLinearLayout(.vert)
        layout.backgroundColor = CFTool.color(14)
        layout.layer.cornerRadius = 5
        layout.tg_height.equal(.wrap)
        layout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        //设置布局视图的内边距。
        layout.tg_vspace = 5
        //设置视图之间的间距，这样子视图就不再需要单独设置间距了。
        layout.tg_gravity = TGGravity.horz.fill
        //里面的子视图宽度和自己一样，这样就不再需要设置子视图的宽度了。
        layout.tg_leading.equal(20%)
        layout.tg_trailing.equal(20%)
        //左右边距0.2表示相对边距，也就是左右边距都是父视图总宽度的20%，这样布局视图的宽度就默认为父视图的60%了。
        layout.tg_centerY.equal(0)
        //布局视图在父视图中垂直居中出现。
        //layout.tg_bottom.equal(0)  //布局视图在父视图中底部出现。您可以注释上面居中的代码并解开这句看看效果。
        self.view.addSubview(layout)
        
        //标题
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("Title", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.textColor = CFTool.color(4)
        titleLabel.font = CFTool.font(17)
        titleLabel.sizeToFit()
        layout.addSubview(titleLabel)
        
        //文本
        let label = UILabel()
        label.font = CFTool.font(14)
        label.text = "这是一段具有动态高度的文本，同时他也会影响着布局视图的高度。您可以单击下面的按钮来添加文本来查看效果："
        label.tg_height.equal(.wrap)
        layout.addSubview(label)
        
        //按钮容器。如果您想让两个按钮水平排列则只需在btnContainer初始化中把方向改为：.horz 。您可以尝试看看效果。
        let btnContainer = TGLinearLayout(.vert)
        btnContainer.tg_height.equal(.wrap)
        //高度由子视图确定。
        btnContainer.tg_space = 5
        //视图之间的间距设置为5
        btnContainer.tg_gravity = TGGravity.horz.fill
        //里面的子视图的宽度水平填充，如果是垂直线性布局则里面的所有子视图的宽度都和父视图相等。如果是水平线性布局则会均分所有子视图的宽度。
        layout.addSubview(btnContainer)

        /*
         TangramKit和SizeClass有着紧密的结合。如果你想在横屏时两个按钮水平排列而竖屏时垂直排列则设置如下 ：
         
         因为所有设置的布局属于默认都是基于wAny,hAny这种Size Classes的。所以我们要对按钮容器视图指定一个单独横屏的Size Classes: Landscape
         这里的copyFrom表示系统会拷贝默认的Size Classes，最终方法返回横屏的Size Classes。 这样你只需要设置一下排列的方向就可以了。
         
         您可以将下面两句代码注释掉看看横竖屏切换的结果。
         */
        
        let btnContainerSC = btnContainer.tg_fetchSizeClass(with: .landscape, from: .default) as! TGLinearLayoutViewSizeClass
        btnContainerSC.tg_orientation = .horz
        
        //您可以看到下面的两个按钮没有出现任何的需要进行布局的属性设置，直接添加到父视图就能达到想要的效果，这样就简化了程序的开发。
        btnContainer.addSubview(self.createDemoButton("Add Text", action:#selector(handleDemo1AddTest)))
        btnContainer.addSubview(self.createDemoButton("Remove Layout",action:#selector(handleDemo1RemoveLayout)))
        
        
        //这里把一个布局视图加入到非布局父视图。
        self.view.addSubview(layout)
    
        
        //如果您要移动出现的动画效果则解开如下注释。
         layout.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height/2)
         layout.alpha = 0.5
        
        UIView.animate(withDuration: 0.3, animations: {
        
            layout.transform = .identity
            layout.alpha = 1
        
        })
        
    }
}
