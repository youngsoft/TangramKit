//
//  LLTest3ViewController.swift
//  TangramKit
//
//  Created by yant on 9/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class LLTest3ViewController: UIViewController {

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
         
         1.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图都和父视图右对齐。第一个方法是分别为每个子视图设置tg_right ~= 0来实现；第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.horz.right就可以实现了。
         2.假设某个垂直线性布局有A,B,C三个子视图，并且希望这三个子视图整体水平居中对齐。第一个方法是分别为每个子视图设置tg_centerX~=0来实现；第二个方法是只需要设置布局视图的gravity的值为TGGravity.horz.center就可以实现了。
         3.假设某个垂直线性布局有A,B,C三个子视图，并且我们希望这三个子视图整体垂直居中。第一个方法是为设置A的tg_top~=50%和设置C的tg_bottom ~=50%;第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.vert.center就可以实现了。
         4.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图整体居中。我们就只需要将布局视图的tg_gravity值设置为TGGravity.center就可以了。
         5.假设某个垂直线性布局有A,B,C三个子视图，我们希望这三个子视图的宽度都和布局视图一样宽。第一个方法是分别为每个子视图的tg_left和tg_right设置为0;第二个方法是只需要设置布局视图的tg_gravity的值为TGGravity.horz.fill就可以了。
         
         通过上面的几个场景我们可以看出tg_gravity属性的设置可以在很大程度上简化布局视图里面的子视图的布局属性的设置的，通过tg_gravity属性的设置我们可以控制布局视图里面所有子视图的整体停靠方向和填充的尺寸。在使用tg_gravity属性时需要明确如下几个条件：
         
         1.当使用tg_gravity属性时意味着布局视图必须要有明确的尺寸才有意义，因为有确定的尺寸才能决定里面的子视图的停靠的方位。
         2.布局视图的tg_height设置为.wrap时是和tg_gravity上设置垂直停靠方向以及垂直填充是互斥的；而布局视图的tg_width设置为.wrap时是和tg_gravity上设置水平停靠方向和水平填充是互斥的。
         3.对于垂直线性布局来说不能设置tg_gravity的值为TGGravity.vert.fill；对于水平线性布局来说不能设置tg_gravity的值为TGGravity.horz.fill。
         4.布局视图的tg_gravity的属性的优先级要高于子视图的停靠和尺寸设置。
         */

        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView;
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_gravity = TGGravity.horz.fill  //设置这个属性后rootLayout的所有子视图都不需要指定宽度了，这个值的意义是所有子视图的宽度都填充满布局。也就是说设置了这个值后不需要为每个子视图设置tg_left, tg_right来指定宽度了。
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
    //创建垂直线性布局停靠操作动作布局。
    func createVertLayoutGravityActionLayout(in contentLayout:TGLinearLayout)
    {
        let actionTitleLabel = UILabel()
        actionTitleLabel.text = NSLocalizedString("Vertical layout gravity control, you can click the following different button to show the effect:", comment:"");
        actionTitleLabel.font = UIFont.systemFont(ofSize: 14)
        actionTitleLabel.numberOfLines = 0
        actionTitleLabel.tg_height.equal(.wrap)
        contentLayout.addSubview(actionTitleLabel)
        
       
        let actions = [
            NSLocalizedString("top",comment:""),
            NSLocalizedString("vert center",comment:""),
            NSLocalizedString("bottom",comment:""),
            NSLocalizedString("left",comment:""),
            NSLocalizedString("horz center",comment:""),
            NSLocalizedString("right",comment:""),
            NSLocalizedString("horz fill",comment:""),
            NSLocalizedString("screen vert center",comment:""),
            NSLocalizedString("screen horz center",comment:""),
            NSLocalizedString("adjust spacing",comment:"")
        ]
        
        //用流式布局创建动作菜单。
        let actionLayout = TGFlowLayout(.vert, arrangedCount: 3) //每行3个子视图
        actionLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tg_averageArrange = true //里面的子视图的宽度平均分配。
        actionLayout.tg_hspace = 5
        actionLayout.tg_vspace = 5   //设置子视图之间的水平和垂直间距。
        contentLayout.addSubview(actionLayout)
        
        for i in 0..<actions.count
        {
            actionLayout.addSubview(createActionButton(actions[i], tag:(i + 1)*100))
        }


    
    }
    
    //创建垂直停靠线性布局
    func createVertGravityLayout(in contentLayout:TGLinearLayout)
    {
    
        let vertGravityLayout = TGLinearLayout(.vert)
        vertGravityLayout.backgroundColor = .gray
        vertGravityLayout.tg_top.equal(10)
        vertGravityLayout.tg_left.equal(20)
        vertGravityLayout.tg_height.equal(200)
        vertGravityLayout.tg_vspace = 10  //设置每个子视图之间的垂直间距为10，这样子视图就不再需要设置间距了。
        contentLayout.addSubview(vertGravityLayout)
        self.vertGravityLayout = vertGravityLayout
        
        
        let v1 = UILabel()
        v1.text = NSLocalizedString("test text1", comment:"")
        v1.backgroundColor = .red
        v1.sizeToFit()
        vertGravityLayout.addSubview(v1)
        
        let v2 = UILabel()
        v2.text = NSLocalizedString("test text2 test text2", comment:"")
        v2.backgroundColor = .green
        v2.sizeToFit()
        vertGravityLayout.addSubview(v2)
        
        
        let v3 = UILabel()
        v3.text = NSLocalizedString("test text3 test text3 test text3", comment:"")
        v3.backgroundColor = .blue
        v3.sizeToFit()
        vertGravityLayout.addSubview(v3)
        
        let v4 = UILabel()
        v4.text = NSLocalizedString("set left and right margin to determine width", comment:"")
        v4.backgroundColor = .orange
        v4.adjustsFontSizeToFitWidth = true
        v4.tg_left.equal(20)
        v4.tg_right.equal(30) //这两行代码能决定视图的宽度，自己定义。
        v4.sizeToFit()
        vertGravityLayout.addSubview(v4)

    }
    
    //创建水平线性布局停靠操作动作布局。
    func createHorzLayoutGravityActionLayout(in contentLayout:TGLinearLayout)
    {
        
        let actionTitleLabel = UILabel()
        actionTitleLabel.text = NSLocalizedString("Horizontal layout gravity control, you can click the following different button to show the effect:", comment:"")
        actionTitleLabel.font = UIFont.systemFont(ofSize: 14)
        actionTitleLabel.adjustsFontSizeToFitWidth = true
        actionTitleLabel.numberOfLines = 0
        actionTitleLabel.tg_height.equal(.wrap)
        contentLayout.addSubview(actionTitleLabel)
        
        
        let actions = [
            NSLocalizedString("left",comment:""),
            NSLocalizedString("horz center",comment:""),
            NSLocalizedString("right",comment:""),
            NSLocalizedString("top",comment:""),
            NSLocalizedString("vert center",comment:""),
            NSLocalizedString("bottom",comment:""),
            NSLocalizedString("vert fill",comment:""),
            NSLocalizedString("screen vert center",comment:""),
            NSLocalizedString("screen horz center",comment:""),
            NSLocalizedString("adjust spacing",comment:"")
        ]
        
        
        let actionLayout = TGFlowLayout(.vert, arrangedCount: 3)
        actionLayout.tg_averageArrange = true
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tg_hspace = 5
        actionLayout.tg_vspace = 5
        actionLayout.tg_padding = UIEdgeInsetsMake(5, 5, 5, 5)
        contentLayout.addSubview(actionLayout)

        for i:Int in 0..<actions.count
        {
            actionLayout.addSubview(createActionButton(actions[i], tag:(i + 1)*100 + 1))
        }

    }

    func createHorzGravityLayout(in contentLayout:TGLinearLayout)
    {
        
        let horzGravityLayout = TGLinearLayout(.horz)
        horzGravityLayout.backgroundColor = .gray
        horzGravityLayout.tg_height.equal(200)
        horzGravityLayout.tg_top.equal(10)
        horzGravityLayout.tg_left.equal(20)
        horzGravityLayout.tg_hspace = 5  //设置子视图之间的水平间距为5
        contentLayout.addSubview(horzGravityLayout)
        self.horzGravityLayout = horzGravityLayout
        
        let v1 = UILabel()
        v1.text = NSLocalizedString("test text1", comment:"")
        v1.backgroundColor = .red
        v1.numberOfLines = 0
        v1.tg_height.equal(.wrap)
        v1.tg_width.equal(60)
        horzGravityLayout.addSubview(v1)
        
        let v2 = UILabel()
        v2.text = NSLocalizedString("test text2 test text2", comment:"")
        v2.backgroundColor = .green
        v2.numberOfLines = 0
        v2.tg_height.equal(.wrap)
        v2.tg_width.equal(60)
        horzGravityLayout.addSubview(v2)
        
        
        let v3 = UILabel()
        v3.text = NSLocalizedString("test text3 test text3 test text3", comment:"")
        v3.backgroundColor = .blue
        v3.numberOfLines = 0
        v3.tg_height.equal(.wrap)
        v3.tg_width.equal(60)
        horzGravityLayout.addSubview(v3)
        
        let v4 = UILabel()
        v4.text = NSLocalizedString("set top and bottom margin to determine height", comment:"")
        v4.backgroundColor = .orange
        v4.adjustsFontSizeToFitWidth = true
        v4.numberOfLines = 0
        v4.tg_top.equal(20)
        v4.tg_bottom.equal(10)
        v4.tg_height.equal(.wrap)
        v4.tg_width.equal(60)
        horzGravityLayout.addSubview(v4)
    }
    
    //创建动作按钮
    func createActionButton(_ title:String,tag:Int) ->UIButton
    {
        let actionButton = UIButton(type:.system)
        actionButton.setTitle(title  ,for:.normal)
        actionButton.titleLabel!.adjustsFontSizeToFitWidth = true
        actionButton.layer.borderColor = UIColor.gray.cgColor;
        actionButton.layer.borderWidth = 1.0
        actionButton.tag = tag
        actionButton.addTarget(self, action: #selector(handleGravity), for:.touchUpInside)
        actionButton.sizeToFit()
        return actionButton
    }

}

//MARK: - Handle Method
extension LLTest3ViewController
{
    func handleGravity(_ button:UIButton)
    {
        switch (button.tag) {
        case 100:  //上
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.top]
            break
        case 200:  //垂直
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.center]
            break
        case 300:   //下
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.bottom]
            break
        case 400:  //左
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.left]
            break
        case 500:  //水平
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.center]
            break
        case 600:   //右
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.right]
            break
        case 700:   //填充
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.fill]
            break
        case 800:   //窗口垂直居中
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.windowCenter]
            break
        case 900:   //窗口水平居中
            self.vertGravityLayout.tg_gravity = [self.vertGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.windowCenter]
            break
        case 1000:
            self.vertGravityLayout.tg_vspace = self.vertGravityLayout.tg_vspace == 10 ? -10 : 10
            self.vertGravityLayout.tg_layoutAnimationWithDuration(0.5)
            break
            
        case 101:  //左
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.left]
            break
        case 201:  //水平
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.center]
            break
        case 301:   //右
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.horz.mask , TGGravity.horz.right]
            break
        case 401:  //上
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.top]
            break
        case 501:  //垂直
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.center]
            break
        case 601:   //下
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.bottom]
            break
        case 701:   //填充
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.fill]
            break
        case 801:   //窗口垂直居中
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.vert.mask , TGGravity.vert.windowCenter]
            break
        case 901:   //窗口水平居中
            self.horzGravityLayout.tg_gravity = [self.horzGravityLayout.tg_gravity & TGGravity.horz.mask, TGGravity.horz.windowCenter]
            break
        case 1001:
            self.horzGravityLayout.tg_hspace = self.horzGravityLayout.tg_hspace == 5 ? -5 : 5
            self.horzGravityLayout.tg_layoutAnimationWithDuration(0.5)
            break
        default:
            break
        }
        
    }
    
    func handleNavigationTitleCentre(_ sender: AnyObject!)
    {
        let navigationItemLayout = TGLinearLayout(.vert)
        //通过TGGravity.horz.windowCenter的设置总是保证在窗口的中间而不是布局视图的中间。
        navigationItemLayout.tg_gravity = [TGGravity.horz.windowCenter , TGGravity.vert.center]
        navigationItemLayout.frame = self.navigationController!.navigationBar.bounds
        
        let topLabel = UILabel()
        topLabel.text = NSLocalizedString("title center in the screen", comment:"")
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.textAlignment = .center
        topLabel.tg_left.equal(10)
        topLabel.tg_right.equal(10)
        topLabel.sizeToFit()
        navigationItemLayout.addSubview(topLabel)
        
        let bottomLabel = UILabel()
        bottomLabel.text = self.title
        bottomLabel.sizeToFit()
        navigationItemLayout.addSubview(bottomLabel)
        
        
        self.navigationItem.titleView = navigationItemLayout
        
    }
    
    func handleNavigationTitleRestore(_ sender: AnyObject!)
    {
        let topLabel = UILabel()
        topLabel.text = NSLocalizedString("title not center in the screen", comment:"")
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.textAlignment = .center
        topLabel.sizeToFit()
        self.navigationItem.titleView = topLabel
    }
    

}
