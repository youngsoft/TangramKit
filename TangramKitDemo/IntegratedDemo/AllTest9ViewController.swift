//
//  AllTest9ViewController.swift
//  TangramKitDemo
//
//  Created by fzy on 2018/8/4.
//  Copyright © 2018年 youngsoft. All rights reserved.
//

import UIKit

/**
 *❁3.Subviews layout transform
 */
class AllTest9ViewController: UIViewController {

    var contentLayout:TGBaseLayout!
    
    override func loadView() {
        
        /*
         
         这个DEMO主要用来演示布局视图的tg_layoutTransform属性的使用和设置方法，这个属性用来对布局视图内所有子视图的位置进行坐标变换。只要你了解CGAffineTransform的设置和使用
         方法，就可以用他来进行各种布局视图内子视图的整体的坐标变换，比如：平移、缩放、水平反转、垂直反转、旋转等以及一些复合的坐标变换。在下面的例子里面我分别列举了一些常见的布局位置
         坐标变换的设置方法以及参数。
         
         
         当你的布局内所有视图都需要有统一的变换的动画时，你可以借助tg_layoutTransform属性并且配合tg_layoutAnimationWithDuration方法来实现动画效果。
         
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
        
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("Identity", comment:""), action:#selector(handleIdentityTransform)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("Translation", comment:""),action:#selector(handleTranslationTransform)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("Scale", comment:""),
                                                        action:#selector(handleScaleTransform)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("Horz Reflection", comment:""),
                                                        action:#selector(handleHorzReflectionTransform)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("Vert Reflection", comment:""),
                                                        action:#selector(handleVertReflectionTransform)))
        actionLayout.addSubview(self.createActionButton(NSLocalizedString("Reverse", comment:""),
                                                        action:#selector(handleReverseTransform)))
        
        
        
        //下面是用于测试的layoutTransform属性的布局视图，本系统中的所有布局视图都支持layoutTransform属性。
        let contentLayout = TGFlowLayout(.vert, arrangedCount: 4)
        contentLayout.backgroundColor = CFTool.color(5)
        contentLayout.tg_height.equal(.fill)
        contentLayout.tg_space = 10
        rootLayout.addSubview(contentLayout)
        self.contentLayout = contentLayout
        
        for i in 0 ..< 14
        {
            let label = UILabel()
            label.text = "\(i)"
            label.backgroundColor = .red
            label.tg_size(CGSize(width:40,height:40))
            label.textAlignment = .center
            contentLayout.addSubview(label)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MAKR: -Layout Construction
extension AllTest9ViewController
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
extension AllTest9ViewController
{
    @objc func handleIdentityTransform(_ sender:AnyObject?)
    {
        //还原位置的坐标变换，这也是默认值。
        self.contentLayout.tg_layoutTransform = .identity
        self.contentLayout.tg_layoutAnimationWithDuration(0.3)
       
    }
    
    @objc func handleTranslationTransform(_ sender:AnyObject?)
    {
        if self.contentLayout.tg_layoutTransform.isIdentity
        {
            self.contentLayout.tg_layoutTransform = CGAffineTransform(translationX: 100, y: 0)
        }
        else if self.contentLayout.tg_layoutTransform == CGAffineTransform(translationX: 100, y: 0)
        {
            self.contentLayout.tg_layoutTransform = CGAffineTransform(translationX: 100, y: 100)
        }
        else
        {
            self.contentLayout.tg_layoutTransform = CGAffineTransform.identity
        }
        
        self.contentLayout.tg_layoutAnimationWithDuration(0.3)
        
    }
    
    @objc func handleScaleTransform(_ sender:AnyObject?)
    {
       
        //布局内子视图位置的放大和缩小的位置变换。因为缩放是以布局视图的中心点为中心进行缩放的，所以如果是想要以某个点为中心进行缩放。所以在缩放的同时还需要进行位移的调整。
        //下面的例子里面，因为缩放默认是以布局视图的中心点为中心进行缩放，但这里是想以第一个子视图保持不变而进行缩放，所以除了要进行缩放外，还需要调整所有子视图的偏移，因为第一个
        //子视图的中心点的位置按照布局视图中心点原点坐标的话位置是：  (20 - 布局视图的宽度/2, 20 - 布局视图的高度/2)，  这里的20是因为视图的高度都是40。
        //所以只要保证第一个子视图的中心点在放大后的位置还是一样，就会实现以第一个子视图为中心进行放大的效果。
        
        
        let size = self.contentLayout.frame.size
        
        //缩放因子。
        let factor:CGFloat = 2.0  //你可以试试0.9看看效果。
        
        self.contentLayout.tg_layoutTransform = CGAffineTransform(a:factor, b:0, c:0, d:factor, tx:(1 - factor) * (20 - size.width / 2.0), ty:(1 - factor) * (20 - size.height / 2));   //这里因为要让第一个子视图的位置保持不变，所以tx,ty参数需要进行特殊设置。
        
        self.contentLayout.tg_layoutAnimationWithDuration(0.3)

        
    }
    
    
    
    @objc func handleHorzReflectionTransform(_ sender:AnyObject?)
    {
        //布局内所有子视图都进行水平翻转排列，也就是水平镜像的效果。
        self.contentLayout.tg_layoutTransform = CGAffineTransform(a:-1,b:0,c:0,d:1,tx:0,ty:0)
        self.contentLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    @objc func handleVertReflectionTransform(_ sender:AnyObject?)
    {
        //布局内所有子视图都进行垂直翻转排列，也就是垂直镜像的效果。
        self.contentLayout.tg_layoutTransform = CGAffineTransform(a:1,b:0,c:0,d:-1,tx:0,ty:0)
        self.contentLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    @objc func handleReverseTransform(_ sender:AnyObject?)
    {
       
        //布局内所有子视图整体翻转180度的效果。
        self.contentLayout.tg_layoutTransform = CGAffineTransform(a:-1,b:0,c:0,d:-1,tx:0,ty:0)
        self.contentLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
}
