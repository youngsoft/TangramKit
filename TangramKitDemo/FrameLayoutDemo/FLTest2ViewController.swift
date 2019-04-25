//
//  FLTest2ViewController.swift
//  TangramKit
//
//  Created by yant on 5/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 * 2.FrameLayout - Complex UI
 */
class FLTest2ViewController: UIViewController {

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
         这个例子里面我们可以用框架布局来实现一些复杂的界面布局。框架布局中的子视图还可以利用tg_width和tg_height属性来确定自己的尺寸，其中的equal方法的值可以是一个确定的数字，也可以是父布局视图，也可以是自己,也可以是一个比重值TGWeight
         */
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        
        let rootLayout = TGFrameLayout()
        rootLayout.backgroundColor = CFTool.color(15)
        rootLayout.tg_insetsPaddingFromSafeArea = [.left, .right, .top] //默认情况下底部的安全区会和布局视图的底部padding进行叠加，当这样设置后底部安全区将不会叠加到底部的padding上去。您可以注释这句代码看看效果。
        self.view = rootLayout
        
        /*

          对于框架布局里面的子视图来说，如果某个子视图的尺寸依赖于父视图则可以有多少设置的方法，比如某个子视图的高度是父视图高度的一半则如下设置都可以：
            sbv.tg_height.equal(superview, multiple:0.5)
            sbv.tg_height.equal(superview.tg_height, multiple:0.5)  //父视图比例方式
            sbv.tg_height.equal(.fill, multiple:0.5)      //填充比例方式
            sbv.tg_height.equal(50%)   //比重方式。
            sbv.tg_height.equal(100%, multiple:0.5)
            sbv.tg_height ~= 50%        //运算符方式。
           
           可以看出设置的方式有非常多的种类，使用灵活。
         
         */
        
        let backImageView = UIImageView(image: UIImage(named: "bk1"))
        backImageView.contentMode = UIView.ContentMode.scaleToFill
        backImageView.tg_height.equal(50%)
        //您也可以采用如下的方法来设置高度：
        //backImageView.tg_height.equal(rootLayout, multiple:0.5)
        //backImageView.tg_height.equal(rootLayout.tg_height, multiple:0.5)
        //backImageView.tg_height.equal(.fill, multiple:0.5)
        //backImageView.tg_height.equal(50%)
        //backImageView.tg_height ~= 50%
        backImageView.tg_width.equal(.fill)  //填充父视图剩余宽度，对于框架布局来说就是全部宽度。
        rootLayout.addSubview(backImageView)
        
        let rightImageView = UIImageView(image: UIImage(named: "user")) //这种方式初始化一个UIImageView会自动计算出视图的尺寸。
        rightImageView.backgroundColor = .white
        rightImageView.layer.cornerRadius = 16
        rightImageView.tg_top.equal(10)
        rightImageView.tg_trailing.equal(10) //距离父视图顶部和右边偏离10
        rootLayout.addSubview(rightImageView)
        
        let headImage = UIImageView(image: UIImage(named: "minions1"))
        headImage.layer.borderColor = CFTool.color(0).cgColor
        headImage.layer.masksToBounds = true
        headImage.layer.cornerRadius = 5
        headImage.layer.borderWidth = 0.5
        headImage.tg_centerX.equal(0)
        headImage.tg_centerY.equal(0)   //整体在父布局中居中。
        headImage.tg_height.equal((100.0/3)%) //等价于headImage.tg_height.equal(.fill, multiple:1.0/3)
        headImage.tg_width.equal(headImage.tg_height)  //自身的宽度等于自身的高度。
        rootLayout.addSubview(headImage)
        
        let nickName = UILabel()
        nickName.text = "欧阳大哥"
        nickName.textColor = CFTool.color(0)
        nickName.font = CFTool.font(17)
        nickName.sizeToFit();
        nickName.tg_centerX.equal(0)
        //因为上面的headImage的高度是布局视图高度的1/3并且居中。所以我们这里的文字的中心点就要往下偏移图片的高度的一半也就是1/6，右因为文字本身有高度所以中心点还要再往下偏移文字本身高度的一半。所以这里的效果就实现了文字在图片的下面。这里面TGWeight类型的值设置表示用的是相对的偏移值。
        nickName.tg_centerY.equal((100.0/6)%, offset:nickName.frame.height / 2)
        rootLayout.addSubview(nickName)
        
        
        let leftView = UIImageView(image: UIImage(named: "image1"))
        leftView.tg_leading.equal(0)
        leftView.tg_bottom.equal(0)  //左下位置
        leftView.tg_width.equal((100.0/3)%)  //左边视图宽度占用1/3
        leftView.tg_height.equal(leftView.tg_width) //高度等于自身的宽度
        leftView.tg_height.max(80) //高度最大只能是80，
        //您也可以使用运算符方式来进行设置:
       // leftView.tg_height <= 80
        rootLayout.addSubview(leftView)
        
        let centerView = UIImageView(image: UIImage(named: "image2"))
        centerView.tg_centerX.equal(0)
        centerView.tg_bottom.equal(0) //中下位置
        centerView.tg_width.equal((100.0/3)%)
        centerView.tg_height.equal(centerView.tg_width)  //高度等于自身的宽度
        centerView.tg_height.max(80)
        rootLayout.addSubview(centerView)
        
        
        let rightView = UIImageView(image: UIImage(named: "image3"))
        rightView.tg_trailing.equal(0)
        rightView.tg_bottom.equal(0)
        rightView.tg_width.equal((100.0/3)%)
        rightView.tg_height.equal(rightView.tg_width)
        rightView.tg_height.max(80)
        rootLayout.addSubview(rightView)
    }
    
    
    
}
