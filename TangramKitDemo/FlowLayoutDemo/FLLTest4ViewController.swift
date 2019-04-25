//
//  FLLTest4ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *4.FlowLayout - Weight
 */
class FLLTest4ViewController: UIViewController {

    override func loadView() {
        
        /*
         这个例子主要展示流式布局对子视图的TGLayoutSize设置为TGWeight类型的值的支持。对于垂直流式布局来说，子视图的tg_width值设置为TGWeight时用来指定子视图的宽度在当前行剩余空间所占用的比例值，比如某个流式布局的宽度是100，而每行的数量为2个，且假如第一个子视图的宽度为20，则如果第二个子视图的tg_width设置为100%的话则第二个子视图的真实宽度 = （100-20）*1 = 80。而假如第二个子视图的tg_width设置为50%的话则第二个子视图的真实宽度 = (100 - 20) * 0.5 = 40。
         对于水平流式布局来说tg_height设置为TGWeight类型的值用来指定一列内的剩余高度的比重值。
         通过对子视图的尺寸设置为TGWeight类型的值的合理使用，可以很方便的替换掉需要用线性布局来实现的嵌套布局的能力。
         
         
         */

        
        let scrollView = UIScrollView()
        self.view = scrollView;
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = CFTool.color(11)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_vspace = 10
        rootLayout.tg_gravity = TGGravity.horz.fill
        scrollView.addSubview(rootLayout)
        
        //这里一个模拟的用户登录界面，用垂直流式布局来实现。
        self.createFlowLayout1(rootLayout: rootLayout)
        //这是一个水平流式布局的例子。
        self.createFlowLayout2(rootLayout: rootLayout)
        //这是一个内容填充布局的例子。通过weight来进行均分处理。可以看出内容约束流式布局中的子视图的weight和数量约束流式布局中的子视图的weight之间的差异。
        self.createFlowLayout3(rootLayout: rootLayout)
        
        //这是一个综合的例子
        self.createFlowLayout4(rootLayout: rootLayout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension FLLTest4ViewController {
    
    //创建流式布局例子1
    func createFlowLayout1(rootLayout: TGLinearLayout)
    {
        //如果是我们用线性布局来实现这个登录界面，一般用法是建立一个垂直线性布局，然后其中的用户和密码部分则通过建立2个子的水平线性布局来实现。但是如果我们用流式布局的话则不再需要用嵌套子布局来实现了。

        //每行2列的垂直流式布局。
        let flowLayout = TGFlowLayout(.vert, arrangedCount: 2)
        flowLayout.backgroundColor = .white
        flowLayout.tg_height.equal(.wrap)
        flowLayout.tg_gravity = TGGravity.horz.center  //所有子视图整体水平居中
        flowLayout.tg_arrangedGravity = TGGravity.vert.center  //每行子视图垂直居中对齐。您可以这里尝试设置为：TGGravity.vert.top, TGGravity.vert.bottom的效果。
        flowLayout.tg_padding = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)  //四周内边距设置为20
        rootLayout.addSubview(flowLayout)
        
        //the first line: head image
        let headerImageView = UIImageView(image: UIImage(named: "minions1"))
        headerImageView.tg_top.equal(20)
        headerImageView.tg_bottom.equal(20)
        flowLayout.addSubview(headerImageView)
        
        let placeHolerView1 = UIView() //因为流式布局这里面每行两列，所以这里建立一个宽高为0的占位视图。我们可以在流式布局中通过使用占位视图来充满行的数量。
        flowLayout.addSubview(placeHolerView1)
        
        //the second line: user name
        let userNameLabel = UILabel()
        userNameLabel.text = "User Name:"
        userNameLabel.textColor = CFTool.color(4)
        userNameLabel.font = CFTool.font(15)
        userNameLabel.sizeToFit()
        flowLayout.addSubview(userNameLabel)
        
        let userNameTextField = UITextField()
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.tg_width.equal(.fill) //这里表示宽度用来占用流式布局每行的剩余宽度，这样就不需要明确的设置宽度了。
        userNameTextField.tg_height.equal(44)
        userNameTextField.tg_leading.equal(20)  //文本输入框距的左边间距为20
        flowLayout.addSubview(userNameTextField)
        
        //the third line: password
        let passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.textColor = CFTool.color(4)
        passwordLabel.font = CFTool.font(15)
        passwordLabel.tg_width.min(userNameLabel.tg_width) //注意这里，因为"password"的长度要小于"User name",所以我们这里设定passwordLabel的最小宽度要和userNameLabel相等。这样目的是为了让后面的输入框具有左对齐的效果。
        passwordLabel.tg_top.equal(20)
        passwordLabel.sizeToFit()
        flowLayout.addSubview(passwordLabel)
        
        let passwordTextField = UITextField()
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.tg_width.equal(.fill)  //表示宽度用来占用流式布局每行的剩余宽度，这样就不需要明确的设置宽度了。
        passwordTextField.tg_height.equal(44)
        passwordTextField.tg_top.equal(20)  //距离上行的顶部间距为20,注意这里要和passwordLabel设置的顶部间距一致，否则可能导致无法居中对齐.
        passwordTextField.tg_leading.equal(20)
        flowLayout.addSubview(passwordTextField)
        
        //the fourth line: forgot password.
        let placeHolderView2 = UIView()
        placeHolderView2.tg_width.equal(.fill) //因为流式布局这里面每行两列，所以这里建立一个宽高为0的占位视图。我们可以在流式布局中通过使用占位视图来充满行的数量。
        flowLayout.addSubview(placeHolderView2)
        
        let forgetPasswordButton = UIButton.init(type: .system)
        forgetPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgetPasswordButton.sizeToFit()
        flowLayout.addSubview(forgetPasswordButton)
        
        //the fifth line: remember me
        let rememberLabel = UILabel()
        rememberLabel.text = "Remember me:"
        rememberLabel.textColor = CFTool.color(4)
        rememberLabel.font = CFTool.font(15)
        rememberLabel.tg_width.equal(.fill)
        rememberLabel.tg_alignment = TGGravity.vert.bottom   //流式布局通过tg_arrangedGravity设置每行的对齐方式，如果某个子视图不想使用默认的对齐方式则可以通过tg_alignment属性来单独设置对齐方式，这个例子中所有都是居中对齐，但是这个标题则是底部对齐。
        rememberLabel.sizeToFit()
        flowLayout.addSubview(rememberLabel)
        
        let rememberSwitch = UISwitch()
        flowLayout.addSubview(rememberSwitch)
        
        //the sixth line: submit button
        let submitButton = UIButton.init(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel!.font = CFTool.font(15)
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderColor = CFTool.color(3).cgColor
        submitButton.layer.borderWidth = 0.5
        submitButton.tg_top.equal(20)
        submitButton.tg_height.equal(44)
        submitButton.tg_width.equal(flowLayout.tg_width, increment: -40)  //宽度等于父视图的宽度再减去40。
        //你也可以设置如下：
        //submitButton.tg_width.equal(100%, increment: -40)
        //或者
        //submitButton.tg_width.equal(.fill, increment: -40)

        
        flowLayout.addSubview(submitButton)
        
        //第六行因为最后只有一个按钮，所以这里不需要建立占位视图。

    }
    
    //流式布局例子2
    func createFlowLayout2(rootLayout: TGLinearLayout)
    {
        //这个例子建立一个水平流式布局来
        let flowLayout = TGFlowLayout(.horz, arrangedCount: 3)
        flowLayout.backgroundColor = CFTool.color(7)
        flowLayout.tg_height.equal(240)
        flowLayout.tg_gravity = [TGGravity.horz.center,TGGravity.vert.bottom]  //子视图整体垂直底部对齐，水平居中对齐。
        flowLayout.tg_arrangedGravity = TGGravity.horz.center //每列子视图水平居中对齐。
        flowLayout.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 5, right: 10)
        rootLayout.addSubview(flowLayout)

        //the first col
        let headerImageView = UIImageView(image: UIImage(named: "minions4"))
        headerImageView.tg_width.equal(80)
        headerImageView.tg_height.equal(80)
        headerImageView.layer.cornerRadius = 40
        headerImageView.layer.masksToBounds = true
        flowLayout.addSubview(headerImageView)
        
        let lineView = UIView()
        lineView.tg_width.equal(2)
        lineView.tg_height.equal(.fill)  //高度占用剩余空间
        lineView.backgroundColor = CFTool.color(2)
        flowLayout.addSubview(lineView)
        
        let placeHoloderView1 = UIView()
        flowLayout.addSubview(placeHoloderView1)
        
        //the second，third, fourth cols
        let images = ["image2", "image3", "image4", "image4"]
        for i in 0 ..< 9 {
            let imageView = UIImageView(image: UIImage(named: images[Int(arc4random_uniform(UInt32(images.count)))]))
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
            imageView.tg_leading.equal(10)
            imageView.tg_trailing.equal(10)
            imageView.tg_top.equal(10)
            imageView.tg_height.equal(.average)  //每个子视图的高度都一样，也就是意味着均分处理。
            imageView.tg_width.equal(imageView.tg_height) //宽度等于高度，对于水平流式布局来说，子视图的宽度可以等于高度，反之不可以；而对于垂直流式布局来说则高度可以等于宽度，反之则不可以。
            if i % flowLayout.tg_arrangedCount == 0 {
                imageView.tg_top.equal(60)  //每列的第一个增加缩进量。。
            }
            flowLayout.addSubview(imageView)
        }
        
        //the last col
        let addButton = UIButton(type: .contactAdd)
        addButton.tg_leading.equal(10)
        flowLayout.addSubview(addButton)
    }
    
    func createFlowLayout3(rootLayout: TGLinearLayout)
    {
        let flowLayout = TGFlowLayout(.vert, arrangedCount: 0)
        flowLayout.backgroundColor = CFTool.color(0)
        flowLayout.tg_height.equal(.wrap)
        flowLayout.tg_space = 10
        flowLayout.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        rootLayout.addSubview(flowLayout)
        
        //第一行占据全部
        let v1 = UIView()
        v1.backgroundColor = CFTool.color(5)
        v1.tg_width.equal(100%)
        v1.tg_height.equal(50)
        flowLayout.addSubview(v1)
        
        //第二行第一个固定，剩余的占据全部
        let v2 = UIView()
        v2.backgroundColor = CFTool.color(6)
        v2.tg_width.equal(50)
        v2.tg_height.equal(50)
        flowLayout.addSubview(v2)
        
        let v3 = UIView()
        v3.backgroundColor = CFTool.color(7)
        v3.tg_width.equal(100%)
        v3.tg_height.equal(50)
        flowLayout.addSubview(v3)
        
        //第三行，三个子视图均分。
        let v4 = UIView()
        v4.backgroundColor = CFTool.color(5)
        v4.tg_width.equal((100/3.0)%, increment: -20)  //因为要均分为3部分，而我们设置了水平间距为10.所以我们这里要减去20。也就是减去2个间隔。
        v4.tg_height.equal(50)
        flowLayout.addSubview(v4)
        
        let v5 = UIView()
        v5.backgroundColor = CFTool.color(6)
        v5.tg_width.equal((100/2.0)%, increment: -10) //因为剩下的要均分为2部分，而我们设置了水平间距为10.所以我们这里要减去10。也就是减去1个间隔。
        v5.tg_height.equal(50)
        flowLayout.addSubview(v5)
        
        let v6 = UIView()
        v6.backgroundColor = CFTool.color(7)
        v6.tg_width.equal(100%)  //最后一个占用剩余的所有空间。这里没有间距了，所以不需要再减。
        v6.tg_height.equal(50)
        flowLayout.addSubview(v6)
    }
    
    func createFlowLayout4(rootLayout: TGLinearLayout)
    {
        /**
         这个例子中有2行，每行2列，这个符合流式布局的规律。因此你不需要用一个垂直布局套两个水平线性布局来实现，而是一个流式布局就好了。另外这个例子里面还展示了边界线的功能，你可以设置边界线的首尾缩进，还可以设置边界线的偏移。这样在一些场合您可以用边界线来代替横线的视图。
         */
        
        let flowLayout = TGFlowLayout(.vert, arrangedCount:2)
        flowLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(flowLayout)
        flowLayout.tg_height.equal(.wrap)
        flowLayout.tg_space = 10
        flowLayout.tg_arrangedGravity = TGGravity.vert.center
        flowLayout.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        
        //边界线：下面的边界线往上偏移45，头部缩进10，尾部缩进30
        flowLayout.tg_bottomBorderline = TGBorderline(color:CFTool.color(5),headIndent:10, tailIndent:30, offset:45)
        
        //第一行占据全部
        let titleLabel = UILabel()
        titleLabel.text = "这个例子里面有2行，每行有2个子视图，这样符合流式布局的规则。因此可以用一个流式布局来实现而不必要用一个垂直线性布局套2个水平线性布局来实现。"
        titleLabel.textColor = CFTool.color(5)
        titleLabel.font = CFTool.font(14)
        titleLabel.tg_width.equal(.fill)   //对于指定数量的流式布局来说这个weight的是剩余的占比。
        titleLabel.tg_height.equal(.wrap)
        flowLayout.addSubview(titleLabel)
        
        //第二行第一个固定，剩余的占据全部
        let editImageView = UIImageView(image: #imageLiteral(resourceName: "edit"))
        flowLayout.addSubview(editImageView)
        
        let priceLabel = UILabel()
        priceLabel.text = "$123.23 - $200.12"
        priceLabel.textColor = .red
        priceLabel.font = CFTool.font(13)
        priceLabel.tg_width.equal(.wrap)
        priceLabel.tg_height.equal(30)
        flowLayout.addSubview(priceLabel)
        
        //第三行，三个子视图均分。
        let buyButton = UILabel()
        buyButton.text = "Buy"
        buyButton.font =  CFTool.font(12)
        buyButton.tg_width.equal(.wrap)
        buyButton.tg_height.equal(30)
        buyButton.tg_leading.equal(20)
        flowLayout.addSubview(buyButton)
        
        
    }
    

}
