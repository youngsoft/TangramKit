//
//  LLTest7ViewController.swift
//  TangramKit
//
//  Created by yant on 10/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 * 7.LinearLayout - Average size&space
 */
class LLTest7ViewController: UIViewController {

    weak var testLayout: TGLinearLayout!
    
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
         这个例子用来介绍线性布局提供的均分尺寸和均分间距的功能。这可以通过线性布局里面的tg_equalizeSubviews和tg_equalizeSubviewsSpace方法来实现。
         需要注意的是这两个方法只能对当前已经加入了线性布局中的子视图有效。对后续再加入的子视图不会进行均分。因此要想后续加入的子视图也均分就需要再次调用者两个方法。
         */

        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .white
        rootLayout.tg_gravity = TGGravity.horz.fill
        rootLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        self.view = rootLayout
        
        
        let action1Layout = TGLinearLayout(.horz)
        action1Layout.tg_height.equal(.wrap)
        action1Layout.tg_top.equal(self.topLayoutGuide)
        rootLayout.addSubview(action1Layout)
        
        action1Layout.addSubview(self.createActionButton(NSLocalizedString("average size&space no centered", comment:"") ,tag:100))
        action1Layout.addSubview(self.createActionButton(NSLocalizedString("average size&space centered", comment:""), tag:200))
        action1Layout.addSubview(self.createActionButton(NSLocalizedString("average size no centered",comment:""), tag:300))
        action1Layout.tg_equalizeSubviews(centered: false, withSpace: 5) //均分action1Layout中的所有子视图的宽度,视图之间的间距为5
        
        
        let action2Layout = TGLinearLayout(.horz)
        action2Layout.tg_top.equal(5)
        action2Layout.tg_height.equal(.wrap)
        rootLayout.addSubview(action2Layout)
        
        action2Layout.addSubview(self.createActionButton(NSLocalizedString("average size centered",comment:""), tag:400))
        action2Layout.addSubview(self.createActionButton(NSLocalizedString("average space no centered",comment:""), tag:500))
        action2Layout.addSubview(self.createActionButton(NSLocalizedString("average space centered",comment:""), tag:600))
        action2Layout.tg_equalizeSubviews(centered: false, withSpace: 5) //均分action1Layout中的所有子视图的宽度
        
        
    
        let testLayout = TGLinearLayout(.vert)
        testLayout.tg_gravity = TGGravity.horz.fill  //所有子视图水平宽度充满布局，这样就不需要分别设置每个子视图的宽度了。
        testLayout.backgroundColor = CFTool.color(0)
        testLayout.tg_height.equal(.fill)   //高度填充父布局的所有剩余空间。
        testLayout.tg_leadingPadding = 10
        testLayout.tg_trailingPadding = 10
        testLayout.tg_top.equal(5)
        rootLayout.addSubview(testLayout)
        self.testLayout = testLayout
        
        let testLayoutLandscapeSC = self.testLayout.tg_fetchSizeClass(with: .landscape, from: .default) as! TGLinearLayoutViewSizeClass
        testLayoutLandscapeSC.tg_orientation = .horz
        testLayoutLandscapeSC.tg_gravity = TGGravity.vert.fill
        
        
        let v1 = self.createView(CFTool.color(5),title:"A")
        v1.tg_height.equal(100)  //默认情况下设置高度100
        v1.tg_fetchSizeClass(with: .landscape).tg_width.equal(100) //在横屏下设置宽度为100
        self.testLayout.addSubview(v1)
        
        
        let v2 = self.createView(CFTool.color(6), title:"B")
        v2.tg_height.equal(50)
        v2.tg_fetchSizeClass(with: .landscape).tg_width.equal(50) //在横屏下设置宽度为50
        self.testLayout.addSubview(v2)
        
        let v3 = self.createView(CFTool.color(7), title:"C")
        v3.tg_height.equal(70)
        v3.tg_fetchSizeClass(with: .landscape).tg_width.equal(70) //在横屏下设置宽度为70
        self.testLayout.addSubview(v3)

    }
    
}

//MARK: - Layout Construction
extension LLTest7ViewController
{
    
    func createView(_ color: UIColor, title:String) -> UIView {
        let v = UILabel()
        v.backgroundColor = color
        v.layer.shadowOffset = CGSize(width:3, height:3)
        v.layer.shadowColor = CFTool.color(4).cgColor
        v.layer.shadowRadius = 2
        v.layer.shadowOpacity = 0.3
        v.text = title
        v.textAlignment = .center
        return v
    }
    
    func createActionButton(_ title :String , tag:NSInteger) -> UIButton
    {
        let button = UIButton(type:.system)
        button.setTitle(title, for:.normal)
        button.addTarget(self, action:#selector(handleAction), for:.touchUpInside)
        button.tag = tag
        button.titleLabel!.numberOfLines = 2
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.titleLabel!.font = CFTool.font(14)
        button.sizeToFit()
        button.tg_height.equal(.wrap, increment:5) //高度等于内容的高度再加5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 4
        
        return button
    }

}

//MARK: - Handle Method
extension LLTest7ViewController
{
    
   @objc func handleAction(_ sender: UIButton)
    {
        //恢复原来的设置。
        let arr = self.testLayout.subviews;
        
        let v1 = arr[0];
        let v2 = arr[1];
        let v3 = arr[2];
        
        //清除所有之前的布局
        v1.tg_clearLayout()
        v2.tg_clearLayout()
        v3.tg_clearLayout()
        
        v1.tg_height.equal(100)
        v2.tg_height.equal(50)
        v3.tg_height.equal(70)
        
        //清除所有横屏模式下的布局约束设置。
        v1.tg_clearLayout(inSizeClass: .landscape)
        v2.tg_clearLayout(inSizeClass: .landscape)
        v3.tg_clearLayout(inSizeClass: .landscape)

        v1.tg_fetchSizeClass(with: .landscape).tg_width.equal(100) //在横屏下设置宽度为100
        v2.tg_fetchSizeClass(with: .landscape).tg_width.equal(50) //在横屏下设置宽度为50
        v3.tg_fetchSizeClass(with: .landscape).tg_width.equal(70) //在横屏下设置宽度为70

        
        
        switch (sender.tag) {
        case 100:
            self.testLayout.tg_equalizeSubviews(centered: false) //均分所有子视图尺寸和间距不留最外面间距
            self.testLayout.tg_equalizeSubviews(centered: false,inSizeClass:.landscape) //均分所有子视图尺寸和间距不留最外面间距,横屏模式
            break;
        case 200:
            self.testLayout.tg_equalizeSubviews(centered: true) //均分所有子视图的尺寸和间距保留最外间距
            self.testLayout.tg_equalizeSubviews(centered: true,inSizeClass:.landscape) //均分所有子视图的尺寸和间距保留最外间距，横屏模式
            break;
        case 300:
            self.testLayout.tg_equalizeSubviews(centered: false, withSpace: 40) //均分所有子视图尺寸，固定间距，不保留最外间距
            self.testLayout.tg_equalizeSubviews(centered: false, withSpace: 40,inSizeClass:.landscape) //均分所有子视图尺寸，固定间距，不保留最外间距，横屏模式
            break;
        case 400:
            self.testLayout.tg_equalizeSubviews(centered:true, withSpace: 40) //均分所有子视图尺寸，固定间距，保留最外间距
            self.testLayout.tg_equalizeSubviews(centered:true, withSpace: 40, inSizeClass:.landscape) //均分所有子视图尺寸，固定间距，保留最外间距,横屏模式
            break;
        case 500:
            self.testLayout.tg_equalizeSubviewsSpace(centered: false) //均分所有间距，子视图尺寸不变，不保留最外间距
            self.testLayout.tg_equalizeSubviewsSpace(centered: false,inSizeClass:.landscape) //均分所有间距，子视图尺寸不变，不保留最外间距,横屏模式
            break;
        case 600:
            self.testLayout.tg_equalizeSubviewsSpace(centered: true) //均分所有间距，子视图尺寸不变，保留最外间距。
            self.testLayout.tg_equalizeSubviewsSpace(centered: true,inSizeClass:.landscape) //均分所有间距，子视图尺寸不变，保留最外间距。横屏模式
            break;
        default:
            break;
        }
    
        self.testLayout.tg_layoutAnimationWithDuration(0.2)
        
    }
    

}
