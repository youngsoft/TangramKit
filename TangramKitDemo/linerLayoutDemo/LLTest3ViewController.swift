//
//  LLTest3ViewController.swift
//  TangramKit
//
//  Created by yant on 9/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *3.LinearLayout - Gravity&Fill
 */
class LLTest3ViewController: UIViewController {

    weak var vertGravitySetLabel:UILabel!
    weak var horzGravitySetLabel:UILabel!

    weak var vertGravityLayout:TGLinearLayout!
    weak var horzGravityLayout:TGLinearLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.handleNavigationTitleCentre(nil)
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title:NSLocalizedString("centered title", comment:""), style:.plain, target:self, action: #selector(handleNavigationTitleCentre)),
            UIBarButtonItem(title:NSLocalizedString("reset", comment:""), style:.plain, target: self, action: #selector(handleNavigationTitleRestore))
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func loadView() {
        
        /*
         这个例子主要用来了解布局视图的tg_gravity这个属性。tg_gravity这个属性主要用来控制布局视图里面的子视图的整体停靠方向以及子视图的填充。我们考虑下面的场景：
         
         1.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图都和父视图右对齐。第一个方法是分别为每个子视图设置tg_trailing ~= 0来实现；第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.horz.right就可以实现了。
         2.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图整体水平居中对齐。第一个方法是分别为每个子视图设置tg_centerX~=0来实现；第二个方法是只需要设置布局视图的gravity的值为TGGravity.horz.center就可以实现了。
         3.假设某个垂直线性布局有A,B,C三个子视图，并且我们希望这三个子视图整体垂直居中。第一个方法是为设置A的tg_top~=50%和设置C的tg_bottom ~=50%;第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.vert.center就可以实现了。
         4.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图整体居中。我们就只需要将布局视图的tg_gravity值设置为TGGravity.center就可以了。
         5.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图的宽度都和布局视图一样宽。第一个方法是分别为每个子视图的tg_leading和tg_trailing设置为0;第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.horz.fill就可以了。
         
         通过上面的几个场景我们可以看出tg_gravity属性的设置可以在很大程度上简化布局视图里面的子视图的布局属性的设置的，通过tg_gravity属性的设置我们可以控制布局视图里面所有子视图的整体停靠方向和填充的尺寸。在使用tg_gravity属性时需要明确如下几个条件：
         
         1.当使用tg_gravity属性时意味着布局视图必须要有明确的尺寸才有意义，因为有确定的尺寸才能决定里面的子视图的停靠的方位。
         2.布局视图的tg_height设置为.wrap时是和tg_gravity上设置垂直停靠方向以及垂直填充是互斥的；而布局视图的tg_width设置为.wrap时是和tg_gravity上设置水平停靠方向和水平填充是互斥的。
         3.布局视图的tg_gravity的属性的优先级要高于子视图的停靠和尺寸设置。
         */

        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView;
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_gravity = TGGravity.horz.fill  //设置这个属性后rootLayout的所有子视图都不需要指定宽度了，这个值的意义是所有子视图的宽度都填充满布局。也就是说设置了这个值后不需要为每个子视图设置tg_leading, tg_trailing来指定宽度了。
        scrollView.addSubview(rootLayout)
        
        //创建垂直布局停靠操作动作布局。
        createVertLayoutGravityActionLayout(in: rootLayout)
        //创建垂直停靠布局。
        createVertGravityLayout(in: rootLayout)
        //创建水平布局停靠操作动作布局。
        createHorzLayoutGravityActionLayout(in: rootLayout)
        //创建水平停靠布局。
        createHorzGravityLayout(in: rootLayout)
        
    
    }

    
}

//MARK: - Layout Construction
extension LLTest3ViewController
{
    func createLabel(_ title:String, color backgroundColor:UIColor) -> UILabel
    {
        let v = UILabel()
        v.text = title
        v.clipsToBounds = true //这里必须要设置为YES，因为UILabel做高度调整动画时，如果不设置为YES则不会固定顶部。。。
        v.font = CFTool.font(15)
        v.adjustsFontSizeToFitWidth = true
        v.backgroundColor =  backgroundColor
        v.sizeToFit()
        return v
    }

    
    //创建垂直线性布局停靠操作动作布局。
    func createVertLayoutGravityActionLayout(in contentLayout:TGLinearLayout)
    {
        let actionTitleLabel = UILabel()
        actionTitleLabel.text = NSLocalizedString("Vertical layout gravity control, you can click the following different button to show the effect:", comment:"");
        actionTitleLabel.font = CFTool.font(15)
        actionTitleLabel.textColor = CFTool.color(4)
        actionTitleLabel.tg_height.equal(.wrap)
        contentLayout.addSubview(actionTitleLabel)
        
       
        let actions = [
            NSLocalizedString("top",comment:""),
            NSLocalizedString("vert center",comment:""),
            NSLocalizedString("bottom",comment:""),
            NSLocalizedString("left",comment:""),
            NSLocalizedString("horz center",comment:""),
            NSLocalizedString("right",comment:""),
            NSLocalizedString("screen vert center",comment:""),
            NSLocalizedString("screen horz center",comment:""),
            NSLocalizedString("between",comment:""),
            NSLocalizedString("horz fill",comment:""),
            NSLocalizedString("vert fill",comment:"")
        ]
        
        //用流式布局创建动作菜单。
        let actionLayout = TGFlowLayout(.vert, arrangedCount: 3) //每行3个子视图
        actionLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tg_gravity = TGGravity.horz.fill //里面的子视图的宽度平均分配。
        actionLayout.tg_hspace = 5
        actionLayout.tg_vspace = 5   //设置子视图之间的水平和垂直间距。
        contentLayout.addSubview(actionLayout)
        
        for i in 0..<actions.count
        {
            actionLayout.addSubview(createActionButton(actions[i], tag:i + 1, action:#selector(handleVertLayoutGravity)))
        }

    
    }
    
    //创建垂直停靠线性布局
    func createVertGravityLayout(in contentLayout:TGLinearLayout)
    {
        
        //这个标签显示设置gravity值。
        let vertGravitySetLabel = UILabel()
        vertGravitySetLabel.adjustsFontSizeToFitWidth = true
        vertGravitySetLabel.font = CFTool.font(13)
        vertGravitySetLabel.text = "vertGravityLayout.tg_gravity = "
        vertGravitySetLabel.sizeToFit()
        vertGravitySetLabel.numberOfLines = 2;
        contentLayout.addSubview(vertGravitySetLabel)
        self.vertGravitySetLabel = vertGravitySetLabel

    
        let vertGravityLayout = TGLinearLayout(.vert)
        vertGravityLayout.backgroundColor = CFTool.color(0)
        vertGravityLayout.tg_top.equal(10)
        vertGravityLayout.tg_leading.equal(20)
        vertGravityLayout.tg_height.equal(200)
        vertGravityLayout.tg_vspace = 10  //设置每个子视图之间的垂直间距为10，这样子视图就不再需要设置间距了。
        contentLayout.addSubview(vertGravityLayout)
        self.vertGravityLayout = vertGravityLayout
        
        
        let v1 = self.createLabel(NSLocalizedString("test text1", comment:""), color: CFTool.color(5))
        v1.tg_height.equal(20)
        vertGravityLayout.addSubview(v1)
        
        let v2 = self.createLabel(NSLocalizedString("always alignment to left", comment:""), color: CFTool.color(6))
        v2.tg_height.equal(20)
        v2.tg_alignment = TGGravity.horz.left  //对于垂直布局里面的子视图可以通过这个属性来设置水平对齐的方位，这样即使布局视图设置了gravity属性，这个视图的对齐都不会受到影响
        vertGravityLayout.addSubview(v2)
        
        
        let v3 = self.createLabel(NSLocalizedString("test text3 test text3 test text3", comment:""), color: CFTool.color(7))
        v3.tg_height.equal(30)
        vertGravityLayout.addSubview(v3)
        
        let v4 = self.createLabel(NSLocalizedString("set left and right margin to determine width", comment:""), color: CFTool.color(8))
        v4.tg_leading.equal(20)
        v4.tg_trailing.equal(30) //这两行代码能决定视图的宽度，自己定义。
        v4.tg_height.equal(25)
        vertGravityLayout.addSubview(v4)

    }
    
    //创建水平线性布局停靠操作动作布局。
    func createHorzLayoutGravityActionLayout(in contentLayout:TGLinearLayout)
    {
        
        let actionTitleLabel = UILabel()
        actionTitleLabel.text = NSLocalizedString("Horizontal layout gravity control, you can click the following different button to show the effect:", comment:"")
        actionTitleLabel.font = CFTool.font(15)
        actionTitleLabel.textColor = CFTool.color(4)
        actionTitleLabel.adjustsFontSizeToFitWidth = true
        actionTitleLabel.tg_height.equal(.wrap)
        contentLayout.addSubview(actionTitleLabel)
        
        
        let actions = [
            NSLocalizedString("top",comment:""),
            NSLocalizedString("vert center",comment:""),
            NSLocalizedString("bottom",comment:""),
            NSLocalizedString("left",comment:""),
            NSLocalizedString("horz center",comment:""),
            NSLocalizedString("right",comment:""),
            NSLocalizedString("screen vert center",comment:""),
            NSLocalizedString("screen horz center",comment:""),
            NSLocalizedString("between",comment:""),
            NSLocalizedString("horz fill",comment:""),
            NSLocalizedString("vert fill",comment:"")
        ]
        

        let actionLayout = TGFlowLayout(.vert, arrangedCount: 3)
        actionLayout.tg_gravity = TGGravity.horz.fill  //平均分配里面所有子视图的宽度
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tg_hspace = 5
        actionLayout.tg_vspace = 5
        actionLayout.tg_padding = UIEdgeInsetsMake(5, 5, 5, 5)
        contentLayout.addSubview(actionLayout)

        for i:Int in 0..<actions.count
        {
            actionLayout.addSubview(createActionButton(actions[i], tag:i + 1, action:#selector(handleHorzLayoutGravity)))
        }

    }

    func createHorzGravityLayout(in contentLayout:TGLinearLayout)
    {
        //这个标签显示设置gravity值。
        let horzGravitySetLabel = UILabel()
        horzGravitySetLabel.adjustsFontSizeToFitWidth = true
        horzGravitySetLabel.font = CFTool.font(13)
        horzGravitySetLabel.text = "horzGravityLayout.tg_gravity = "
        horzGravitySetLabel.sizeToFit()
        horzGravitySetLabel.numberOfLines = 2;
        contentLayout.addSubview(horzGravitySetLabel)
        self.horzGravitySetLabel = horzGravitySetLabel
        
        let horzGravityLayout = TGLinearLayout(.horz)
        horzGravityLayout.backgroundColor = CFTool.color(0)
        horzGravityLayout.tg_height.equal(200)
        horzGravityLayout.tg_top.equal(10)
        horzGravityLayout.tg_leading.equal(20)
        horzGravityLayout.tg_hspace = 5  //设置子视图之间的水平间距为5
        contentLayout.addSubview(horzGravityLayout)
        self.horzGravityLayout = horzGravityLayout
        
        let v1 = self.createLabel(NSLocalizedString("test text1", comment:""), color: CFTool.color(5))
        v1.tg_height.equal(.wrap)
        v1.tg_width.equal(60)
        horzGravityLayout.addSubview(v1)
        
        let v2 = self.createLabel(NSLocalizedString("always alignment to top", comment:""), color: CFTool.color(6))
        v2.tg_height.equal(.wrap)
        v2.tg_width.equal(60)
        v2.tg_alignment = TGGravity.vert.top  //对于水平布局里面的子视图可以通过这个属性来设置垂直对齐的方位，这样即使布局视图设置了gravity属性，这个视图的对齐都不会受到影响。
        horzGravityLayout.addSubview(v2)
        
        
        let v3 = self.createLabel(NSLocalizedString("test text3 test text3 test text3", comment:""), color: CFTool.color(7))
        v3.tg_height.equal(.wrap)
        v3.tg_width.equal(60)
        horzGravityLayout.addSubview(v3)
        
        let v4 = self.createLabel(NSLocalizedString("set top and bottom margin to determine height", comment:""), color: CFTool.color(8))
        v4.tg_top.equal(20)
        v4.tg_bottom.equal(10)
        v4.tg_height.equal(.wrap)
        v4.tg_width.equal(60)
        horzGravityLayout.addSubview(v4)
    }
    
    //创建动作按钮
    func createActionButton(_ title:String,tag:Int, action:Selector) ->UIButton
    {
        let actionButton = UIButton(type:.system)
        actionButton.setTitle(title  ,for:.normal)
        actionButton.titleLabel!.adjustsFontSizeToFitWidth = true
        actionButton.titleLabel!.font = CFTool.font(14)
        actionButton.layer.borderColor = UIColor.gray.cgColor;
        actionButton.layer.borderWidth = 0.5
        actionButton.layer.cornerRadius = 4
        actionButton.tag = tag
        actionButton.addTarget(self, action:action, for:.touchUpInside)
        actionButton.sizeToFit()
        return actionButton
    }

}

//MARK: - Handle Method
extension LLTest3ViewController
{
    @objc func handleVertLayoutGravity(_ button:UIButton)
    {
        //分别取出垂直和水平方向的停靠设置。
        var vertGravity = self.vertGravityLayout.tg_gravity & TGGravity.horz.mask
        var horzGravity = self.vertGravityLayout.tg_gravity & TGGravity.vert.mask
        
        switch (button.tag) {
        case 1:  //上
            vertGravity = TGGravity.vert.top;
            break;
        case 2:  //垂直
            vertGravity = TGGravity.vert.center;
            break;
        case 3:   //下
            vertGravity = TGGravity.vert.bottom;
            break;
        case 4:  //左
            horzGravity = TGGravity.horz.left;
            break;
        case 5:  //水平
            horzGravity = TGGravity.horz.center;
            break;
        case 6:   //右
            horzGravity =  TGGravity.horz.right;
            break;
        case 7:   //窗口垂直居中
            vertGravity = TGGravity.vert.windowCenter;
            break;
        case 8:   //窗口水平居中
            horzGravity = TGGravity.horz.windowCenter;
            break;
        case 9:  //垂直间距拉伸
            vertGravity = TGGravity.vert.between;
            break;
        case 10:   //水平填充
            horzGravity  = TGGravity.horz.fill;
            break;
        case 11:  //垂直填充
            vertGravity = TGGravity.vert.fill;  //这里模拟器顶部出现黑线，真机是不会出现的。。
            break;
        default:
            break;
        }
        
        self.vertGravityLayout.tg_gravity = [vertGravity,horzGravity]
        
        self.vertGravityLayout.tg_layoutAnimationWithDuration(0.2)
        self.vertGravitySetLabel.text = self.gravityText(gravity: self.vertGravityLayout.tg_gravity, prefixText: "vertGravityLayout.tg_gravity")
        self.vertGravitySetLabel.sizeToFit()
        
    }
    
    @objc func handleHorzLayoutGravity(_ button:UIButton)
    {
        //分别取出垂直和水平方向的停靠设置。
        var vertGravity = self.horzGravityLayout.tg_gravity & TGGravity.horz.mask
        var horzGravity = self.horzGravityLayout.tg_gravity & TGGravity.vert.mask
        
        switch (button.tag) {
        case 1:  //上
            vertGravity = TGGravity.vert.top;
            break;
        case 2:  //垂直
            vertGravity = TGGravity.vert.center;
            break;
        case 3:   //下
            vertGravity = TGGravity.vert.bottom;
            break;
        case 4:  //左
            horzGravity = TGGravity.horz.left;
            break;
        case 5:  //水平
            horzGravity = TGGravity.horz.center;
            break;
        case 6:   //右
            horzGravity =  TGGravity.horz.right;
            break;
        case 7:   //窗口垂直居中
            vertGravity = TGGravity.vert.windowCenter;
            break;
        case 8:   //窗口水平居中
            horzGravity = TGGravity.horz.windowCenter;
            break;
        case 9:  //水平间距拉伸
            horzGravity = TGGravity.horz.between;
            break;
        case 10:   //水平填充
            horzGravity  = TGGravity.horz.fill;
            break;
        case 11:  //垂直填充
            vertGravity = TGGravity.vert.fill;  //这里模拟器顶部出现黑线，真机是不会出现的。。
            break;
        default:
            break;
        }
        
        self.horzGravityLayout.tg_gravity = [vertGravity, horzGravity]
        
        self.horzGravityLayout.tg_layoutAnimationWithDuration(0.2)
        
        self.horzGravitySetLabel.text = self.gravityText(gravity: self.horzGravityLayout.tg_gravity, prefixText: "horzGravityLayout.tg_gravity")
        self.horzGravitySetLabel.sizeToFit()
        
    }

    
    @objc func handleNavigationTitleCentre(_ sender: AnyObject!)
    {
        let navigationItemLayout = TGLinearLayout(.vert)
        //通过TGGravity.horz.windowCenter的设置总是保证在窗口的中间而不是布局视图的中间。
        navigationItemLayout.tg_gravity = [TGGravity.horz.windowCenter , TGGravity.vert.center]
        navigationItemLayout.frame = self.navigationController!.navigationBar.bounds
        
        let topLabel = UILabel()
        topLabel.text = NSLocalizedString("title center in the screen", comment:"")
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.textAlignment = .center
        topLabel.textColor = CFTool.color(4)
        topLabel.font = CFTool.font(17)
        topLabel.tg_leading.equal(10)
        topLabel.tg_trailing.equal(10)
        topLabel.sizeToFit()
        navigationItemLayout.addSubview(topLabel)
        
        let bottomLabel = UILabel()
        bottomLabel.text = self.title
        bottomLabel.sizeToFit()
        navigationItemLayout.addSubview(bottomLabel)
        
        
        self.navigationItem.titleView = navigationItemLayout
        
    }
    
    @objc func handleNavigationTitleRestore(_ sender: AnyObject!)
    {
        let topLabel = UILabel()
        topLabel.text = NSLocalizedString("title not center in the screen", comment:"")
        topLabel.textColor = CFTool.color(4)
        topLabel.font = CFTool.font(17)
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.textAlignment = .center
        topLabel.sizeToFit()
        self.navigationItem.titleView = topLabel
    }
    

    func gravityText(gravity:TGGravity, prefixText:String) -> String
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
        case TGGravity.vert.windowCenter:
            vertGravityStr = "TGGravity.vert.windowCenter"
            break;
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
        case TGGravity.horz.windowCenter:
            horzGravityStr = "TGGravity.horz.WindowCenter"
            break
        default:
            horzGravityStr = "TGGravity.horz.left"
            break;
        }
        
        return prefixText + "=\n" + vertGravityStr + " | " + horzGravityStr
    }

    
}
