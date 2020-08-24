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
         
         1.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图都和父视图右对齐。第一个方法是分别为每个子视图设置tg_trailing ~= 0来实现；第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.Horizontal.right就可以实现了。
         2.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图整体水平居中对齐。第一个方法是分别为每个子视图设置tg_centerX~=0来实现；第二个方法是只需要设置布局视图的gravity的值为TGGravity.Horizontal.center就可以实现了。
         3.假设某个垂直线性布局有A,B,C三个子视图，并且我们希望这三个子视图整体垂直居中。第一个方法是为设置A的tg_top~=50%和设置C的tg_bottom ~=50%;第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.Vertical.center就可以实现了。
         4.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图整体居中。我们就只需要将布局视图的tg_gravity值设置为TGGravity.center就可以了。
         5.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图的宽度都和布局视图一样宽。第一个方法是分别为每个子视图的tg_leading和tg_trailing设置为0;第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.Horizontal.fill就可以了。
         
         通过上面的几个场景我们可以看出tg_gravity属性的设置可以在很大程度上简化布局视图里面的子视图的布局属性的设置的，通过tg_gravity属性的设置我们可以控制布局视图里面所有子视图的整体停靠方向和填充的尺寸。在使用tg_gravity属性时需要明确如下几个条件：
         
         1.当使用tg_gravity属性时意味着布局视图必须要有明确的尺寸才有意义，因为有确定的尺寸才能决定里面的子视图的停靠的方位。
         2.布局视图的tg_height设置为.wrap时是和tg_gravity上设置垂直停靠方向以及垂直填充是互斥的；而布局视图的tg_width设置为.wrap时是和tg_gravity上设置水平停靠方向和水平填充是互斥的。
         3.布局视图的tg_gravity的属性的优先级要高于子视图的停靠和尺寸设置，但是低于子视图的tg_alignment属性的设置。
         */

        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView;
        
        var rootLayout = TGLinearLayout(.vert)
        rootLayout.tg.width.equal(.fill)
        rootLayout.tg.height.equal(.wrap)
        rootLayout.tg.gravity = TGGravity.Horizontal.fill  //设置这个属性后rootLayout的所有子视图都不需要指定宽度了，这个值的意义是所有子视图的宽度都填充满布局。也就是说设置了这个值后不需要为每个子视图设置tg_leading, tg_trailing来指定宽度了。
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
        actionTitleLabel.tg.height.equal(.wrap)
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
            NSLocalizedString("around",comment:""),
            NSLocalizedString("among",comment:""),
            NSLocalizedString("horz fill",comment:""),
            NSLocalizedString("vert fill",comment:"")
        ]
        
        //用流式布局创建动作菜单。
        var actionLayout = TGFlowLayout(.vert, arrangedCount: 3) //每行3个子视图
        actionLayout.tg.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        actionLayout.tg.height.equal(.wrap)
        actionLayout.tg.gravity = TGGravity.Horizontal.fill //里面的子视图的宽度平均分配。
        actionLayout.tg.hspace = 5
        actionLayout.tg.vspace = 5   //设置子视图之间的水平和垂直间距。
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
        vertGravitySetLabel.text = "vertGravityLayout.tg.gravity = "
        vertGravitySetLabel.sizeToFit()
        vertGravitySetLabel.numberOfLines = 2;
        contentLayout.addSubview(vertGravitySetLabel)
        self.vertGravitySetLabel = vertGravitySetLabel

    
        var vertGravityLayout = TGLinearLayout(.vert)
        vertGravityLayout.backgroundColor = CFTool.color(0)
        vertGravityLayout.tg.top.equal(10)
        vertGravityLayout.tg.leading.equal(20)
        vertGravityLayout.tg.height.equal(200)
        vertGravityLayout.tg.vspace = 10  //设置每个子视图之间的垂直间距为10，这样子视图就不再需要设置间距了。
        contentLayout.addSubview(vertGravityLayout)
        self.vertGravityLayout = vertGravityLayout
        
        
        let v1 = self.createLabel(NSLocalizedString("test text1", comment:""), color: CFTool.color(5))
        v1.tg.height.equal(20)
        vertGravityLayout.addSubview(v1)
        
        var v2 = self.createLabel(NSLocalizedString("always alignment to left", comment:""), color: CFTool.color(6))
        v2.tg.height.equal(20)
        v2.tg.alignment = TGGravity.Horizontal.left  //对于垂直布局里面的子视图可以通过这个属性来设置水平对齐的方位，这样即使布局视图设置了gravity属性，这个视图的对齐都不会受到影响
        vertGravityLayout.addSubview(v2)
        
        
        let v3 = self.createLabel(NSLocalizedString("test text3 test text3 test text3", comment:""), color: CFTool.color(7))
        v3.tg.height.equal(30)
        vertGravityLayout.addSubview(v3)
        
        let v4 = self.createLabel(NSLocalizedString("set left and right margin to determine width", comment:""), color: CFTool.color(8))
        v4.tg.leading.equal(20)
        v4.tg.trailing.equal(30) //这两行代码能决定视图的宽度，自己定义。
        v4.tg.height.equal(25)
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
        actionTitleLabel.tg.height.equal(.wrap)
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
            NSLocalizedString("around",comment:""),
            NSLocalizedString("among",comment:""),
            NSLocalizedString("horz fill",comment:""),
            NSLocalizedString("vert fill",comment:"")
        ]
        

        var actionLayout = TGFlowLayout(.vert, arrangedCount: 3)
        actionLayout.tg.gravity = TGGravity.Horizontal.fill  //平均分配里面所有子视图的宽度
        actionLayout.tg.height.equal(.wrap)
        actionLayout.tg.hspace = 5
        actionLayout.tg.vspace = 5
        actionLayout.tg.padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
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
        horzGravitySetLabel.text = "horzGravityLayout.tg.gravity = "
        horzGravitySetLabel.sizeToFit()
        horzGravitySetLabel.numberOfLines = 2;
        contentLayout.addSubview(horzGravitySetLabel)
        self.horzGravitySetLabel = horzGravitySetLabel
        
        var horzGravityLayout = TGLinearLayout(.horz)
        horzGravityLayout.backgroundColor = CFTool.color(0)
        horzGravityLayout.tg.height.equal(200)
        horzGravityLayout.tg.top.equal(10)
        horzGravityLayout.tg.leading.equal(20)
        horzGravityLayout.tg.hspace = 5  //设置子视图之间的水平间距为5
        contentLayout.addSubview(horzGravityLayout)
        self.horzGravityLayout = horzGravityLayout
        
        let v1 = self.createLabel(NSLocalizedString("test text1", comment:""), color: CFTool.color(5))
        v1.tg.height.equal(.wrap)
        v1.tg.width.equal(60)
        horzGravityLayout.addSubview(v1)
        
        var v2 = self.createLabel(NSLocalizedString("always alignment to top", comment:""), color: CFTool.color(6))
        v2.tg.height.equal(.wrap)
        v2.tg.width.equal(60)
        v2.tg.alignment = TGGravity.Vertical.top  //对于水平布局里面的子视图可以通过这个属性来设置垂直对齐的方位，这样即使布局视图设置了gravity属性，这个视图的对齐都不会受到影响。
        horzGravityLayout.addSubview(v2)
        
        
        let v3 = self.createLabel(NSLocalizedString("test text3 test text3 test text3", comment:""), color: CFTool.color(7))
        v3.tg.height.equal(.wrap)
        v3.tg.width.equal(60)
        horzGravityLayout.addSubview(v3)
        
        let v4 = self.createLabel(NSLocalizedString("set top and bottom margin to determine height", comment:""), color: CFTool.color(8))
        v4.tg.top.equal(20)
        v4.tg.bottom.equal(10)
        v4.tg.height.equal(.wrap)
        v4.tg.width.equal(60)
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
        var vertGravity = self.vertGravityLayout.tg.gravity & TGGravity.Horizontal.mask
        var horzGravity = self.vertGravityLayout.tg.gravity & TGGravity.Vertical.mask
        
        switch (button.tag) {
        case 1:  //上
            vertGravity = TGGravity.Vertical.top;
            break;
        case 2:  //垂直
            vertGravity = TGGravity.Vertical.center;
            break;
        case 3:   //下
            vertGravity = TGGravity.Vertical.bottom;
            break;
        case 4:  //左
            horzGravity = TGGravity.Horizontal.left;
            break;
        case 5:  //水平
            horzGravity = TGGravity.Horizontal.center;
            break;
        case 6:   //右
            horzGravity =  TGGravity.Horizontal.right;
            break;
        case 7:   //窗口垂直居中
            vertGravity = TGGravity.Vertical.windowCenter;
            break;
        case 8:   //窗口水平居中
            horzGravity = TGGravity.Horizontal.windowCenter;
            break;
        case 9:  //垂直间距拉伸
            vertGravity = TGGravity.Vertical.between;
            break;
        case 10:  //垂直间距环绕
            vertGravity = TGGravity.Vertical.around;
            break;
        case 11:  //垂直间距等分
            vertGravity = TGGravity.Vertical.among;
            break;
        case 12:   //水平填充
            horzGravity  = TGGravity.Horizontal.fill;
            break;
        case 13:  //垂直填充
            vertGravity = TGGravity.Vertical.fill;  //这里模拟器顶部出现黑线，真机是不会出现的。。
            break;
        default:
            break;
        }
        
        self.vertGravityLayout.tg.gravity = [vertGravity,horzGravity]
        
        self.vertGravityLayout.tg.layoutAnimationWithDuration(0.2)
        self.vertGravitySetLabel.text = self.gravityText(gravity: self.vertGravityLayout.tg.gravity, prefixText: "vertGravityLayout.tg.gravity")
        self.vertGravitySetLabel.sizeToFit()
        
    }
    
    @objc func handleHorzLayoutGravity(_ button:UIButton)
    {
        //分别取出垂直和水平方向的停靠设置。
        var vertGravity = self.horzGravityLayout.tg.gravity & TGGravity.Horizontal.mask
        var horzGravity = self.horzGravityLayout.tg.gravity & TGGravity.Vertical.mask
        
        switch (button.tag) {
        case 1:  //上
            vertGravity = TGGravity.Vertical.top;
            break;
        case 2:  //垂直
            vertGravity = TGGravity.Vertical.center;
            break;
        case 3:   //下
            vertGravity = TGGravity.Vertical.bottom;
            break;
        case 4:  //左
            horzGravity = TGGravity.Horizontal.left;
            break;
        case 5:  //水平
            horzGravity = TGGravity.Horizontal.center;
            break;
        case 6:   //右
            horzGravity =  TGGravity.Horizontal.right;
            break;
        case 7:   //窗口垂直居中
            vertGravity = TGGravity.Vertical.windowCenter;
            break;
        case 8:   //窗口水平居中
            horzGravity = TGGravity.Horizontal.windowCenter;
            break;
        case 9:  //水平间距拉伸
            horzGravity = TGGravity.Horizontal.between;
            break;
        case 10:  //水平间距环绕
            horzGravity = TGGravity.Horizontal.around;
            break;
        case 11:  //水平间距等分
            horzGravity = TGGravity.Horizontal.among;
            break;
        case 12:   //水平填充
            horzGravity  = TGGravity.Horizontal.fill;
            break;
        case 13:  //垂直填充
            vertGravity = TGGravity.Vertical.fill;  //这里模拟器顶部出现黑线，真机是不会出现的。。
            break;
        default:
            break;
        }
        
        self.horzGravityLayout.tg.gravity = [vertGravity, horzGravity]
        
        self.horzGravityLayout.tg.layoutAnimationWithDuration(0.2)
        
        self.horzGravitySetLabel.text = self.gravityText(gravity: self.horzGravityLayout.tg.gravity, prefixText: "horzGravityLayout.tg.gravity")
        self.horzGravitySetLabel.sizeToFit()
        
    }

    
    @objc func handleNavigationTitleCentre(_ sender: AnyObject!)
    {
        let navigationItemLayout = TGLinearLayout(.vert)
        //通过TGGravity.Horizontal.windowCenter的设置总是保证在窗口的中间而不是布局视图的中间。
        navigationItemLayout.tg_gravity = [TGGravity.Horizontal.windowCenter , TGGravity.Vertical.center]
        navigationItemLayout.frame = self.navigationController!.navigationBar.bounds
        
        let topLabel = UILabel()
        topLabel.text = NSLocalizedString("title center in the screen", comment:"")
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.textAlignment = .center
        topLabel.textColor = CFTool.color(4)
        topLabel.font = CFTool.font(17)
        topLabel.tg.leading.equal(10)
        topLabel.tg.trailing.equal(10)
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
        case TGGravity.Vertical.windowCenter:
            vertGravityStr = "TGGravity.Vertical.windowCenter"
            break;
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
        case TGGravity.Horizontal.windowCenter:
            horzGravityStr = "TGGravity.Horizontal.WindowCenter"
            break
        default:
            horzGravityStr = "TGGravity.Horizontal.left"
            break;
        }
        
        return prefixText + "=\n" + vertGravityStr + " | " + horzGravityStr
    }

    
}
