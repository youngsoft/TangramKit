//
//  LLTest2ViewController.swift
//  TangramKit
//
//  Created by 闫涛 on 16/5/8.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *2.LinearLayout - Combine with UIScrollView
 */
class LLTest2ViewController: UIViewController {

    weak var contentLayout:TGLinearLayout!
    weak var shrinkLabel:UILabel!
    weak var hiddenView:UIView!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    override func loadView() {

        /*
         本例子用来实现将一个布局视图嵌入到一个UIScrollView里面的功能。
         我们可以把一个布局视图作为一个子视图加入到UIScrollView中，布局库内部会根据布局视图的尺寸自动调整UIScrollView的contentSize。如果您不想调整contentSize则请在加入到UIScrollView后将布局视图的tg_adjustScrollViewContentSizeMode属性设置为no。
         
         通常对于需要上下滚动的界面来说，我们一般将UIScrollView中的布局视图的宽度设置为.fill, 而将高度设置为.wrap。表示布局视图的宽度和UIScrollView保持一致，而高度则由子视图决定，同时布局系统也会动态的调整UIScrollView的contentSize。
         */

        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView
        
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_padding = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10) //设置布局内的子视图离自己的边距.
        contentLayout.tg_width.equal(.fill);  //设置视图自身的宽度填充父视图的剩余宽度。
        //您可以用如下的方法设置宽度：
        //contentLayout.tg_leading.equal(0)
        //contentLayout.tg_trailing.equal(0)
        //您还可以用如下的方法设置宽度：
        //contentLayout.tg_width.equal(scrollView.tg_width)  //contentLayout.tg_width.equal(scrollView)
        //您还可以用如下的方法设置宽度
        //contentLayout.tg_width.equal(100%)
        
        contentLayout.tg_height.equal(.wrap).min(scrollView.tg_height, increment: 10)  //高度由子视图决定，但是布局视图的最低高度等于scrollView的高度+10
        //您也可以如下的方法设置：
        //contentLayout.tg_height.min(scrollView, increment: 10)
        
        scrollView.addSubview(contentLayout)
        self.contentLayout = contentLayout
        
        /*
         布局视图里面的tg_padding属性用来设置布局视图的内边距。内边距是指布局视图里面的子视图离自己距离。外边距则是视图与父视图之间的距离。
         内边距是在自己的尺寸内离子视图的距离，而外边距则不是自己尺寸内离其他视图的距离。下面是内边距和外边距的效果图：
         
            ^
            | top
            |           width
         +------------------------------+
         |                              |------------>
         |  l                       r   | right
         |  e       topPadding      i   |
         |  f                       g   |
         |  t   +---------------+   h   |
<--------|  P   |               |   t   |
left     |  a   |               |   P   |
         |  d   |   subviews    |   a   |  height
         |  d   |    content    |   d   |
         |  i   |               |   d   |
         |  n   |               |   i   |
         |  g   +---------------+   n   |
         |                          g   |
         |        bottomPadding         |
         +------------------------------+
         |bottom
         |
         V
         
         
         如果一个布局视图中的每个子视图都离自己有一定的距离就可以通过设置布局视图的内边距来实现，而不需要为每个子视图都设置外边距。
         
         */
        
        
        
        
        /*垂直线性布局直接添加子视图*/
        createSection1(in: contentLayout)
        
        /*垂直线性布局套水平线性布局*/
        createSection2(in: contentLayout)
        
        /*垂直线性布局套垂直线性布局*/
        createSection3(in: contentLayout)
        
        /*垂直线性布局套水平线性布局*/
        createSection4(in: contentLayout)
        
        /*垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局*/
        createSection5(in: contentLayout)
        
        /*水平线性布局中的基线对齐*/
        createSection6(in: contentLayout)
        
        /*对子视图的高度的缩放调整*/
        createSection7(in: contentLayout)
        
        /*子视图的显示和隐藏*/
        createSection8(in: contentLayout)

        
         }
}

// MARK: - Layout Construction
extension LLTest2ViewController
{
    //线性布局片段1：上面编号文本，下面一个编辑框
    func createSection1(in contentLayout:TGLinearLayout)
    {
        let numTitleLabel = UILabel()
        numTitleLabel.text =  NSLocalizedString("No.:", comment:"")
        numTitleLabel.font = CFTool.font(15)
        numTitleLabel.tg_leading.equal(5) //左边距为5
        numTitleLabel.sizeToFit()      //尺寸由内容决定
        contentLayout.addSubview(numTitleLabel)
        
        let numField = UITextField()
        numField.borderStyle = .roundedRect
        numField.placeholder = NSLocalizedString("Input the No. here", comment:"")
        numField.font = CFTool.font(15)
        numField.tg_top.equal(5)
        numField.tg_width.equal(.fill)
        numField.tg_height.equal(40)
        contentLayout.addSubview(numField)

    }
    
    //线性布局片段2：垂直线性布局套水平线性布局
    func createSection2(in contentLayout:TGLinearLayout)
    {
        let userInfoLayout = TGLinearLayout(.horz)
        userInfoLayout.layer.borderColor = UIColor.lightGray.cgColor
        userInfoLayout.layer.borderWidth = 0.5
        userInfoLayout.layer.cornerRadius = 4
        userInfoLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        userInfoLayout.tg_top.equal(20)
        userInfoLayout.tg_width.equal(.fill) //这句代码等价于tg_leading.equal(0) tg_trailing.equal(0)，表明宽度和父视图保持一致
        userInfoLayout.tg_height.equal(.wrap) //高度由子视图决定。
        contentLayout.addSubview(userInfoLayout)
        
        
        let headImageView = UIImageView(image: UIImage(named: "head1")) //UIImageView的构造方法能够算出视图的尺寸。
        headImageView.tg_centerY.equal(0)  //在父视图中垂直居中。
        userInfoLayout.addSubview(headImageView)
        
        let nameLayout = TGLinearLayout(.vert)
        nameLayout.tg_leading.equal(10)
        nameLayout.tg_width.equal(.fill)
        nameLayout.tg_height.equal(.wrap)
        userInfoLayout.addSubview(nameLayout)
        
        let userNameLabel = UILabel()
        userNameLabel.text = NSLocalizedString("Name:欧阳大哥", comment:"")
        userNameLabel.font = CFTool.font(15);
        userNameLabel.sizeToFit()
        nameLayout.addSubview(userNameLabel)
        
        let nickNameLabel = UILabel()
        nickNameLabel.text  = NSLocalizedString("Nickname:醉里挑灯看键", comment:"")
        nickNameLabel.textColor = CFTool.color(4)
        nickNameLabel.font = CFTool.font(14);
        nickNameLabel.sizeToFit()
        nameLayout.addSubview(nickNameLabel)
        
        //使用线性布局实现这个功能的一个缺点就是必须使用线性布局嵌套线性布局来完成，这样嵌套层次就可能会比较多，因此您可以尝试改用流式布局局来实现这个功能,从而减少嵌套的问题
        /*
        let userInfoLayout = TGFlowLayout(.horz, arrangedCount:2)
         userInfoLayout.layer.borderColor = UIColor.lightGray.cgColor
         userInfoLayout.layer.borderWidth = 0.5
         userInfoLayout.layer.cornerRadius = 4
         userInfoLayout.tg_padding = UIEdgeInsetsMake(5, 5, 5, 5)
         userInfoLayout.tg_top.equal(20)
         userInfoLayout.tg_width.equal(.fill)
         userInfoLayout.tg_height.equal(.wrap)
         userInfoLayout.tg_hspace = 10  //子视图的水平间距为10
         userInfoLayout.tg_gravity = TGGravity.vert.center; //里面的子视图整体垂直居中。
         contentLayout.addSubview(userInfoLayout)
         
         //第一列： 一个头像视图，一个占位视图。
        let headImageView =  UIImageView(image:#imageLiteral(resourceName: "head1"))
         userInfoLayout.addSubview(headImageView)
         
         //因为数量约束水平流式布局每列必须要2个所以这里建立一个占位视图填满第一列。
         let placeHolderView = UIView()
         userInfoLayout.addSubview(placeHolderView)
         
         
         //第二列： 姓名视图，昵称视图。
         let userNameLabel = UILabel()
         userNameLabel.text = NSLocalizedString("Name:欧阳大哥", comment:"")
         userNameLabel.font = CFTool.font(15)
         userNameLabel.sizeToFit()
         userInfoLayout.addSubview(userNameLabel)
        
         let nickNameLabel = UILabel()
        nickNameLabel.text  = NSLocalizedString("Nickname:醉里挑灯看键", comment:"")
        nickNameLabel.textColor = CFTool.color(4)
        nickNameLabel.font = CFTool.font(14);
        nickNameLabel.sizeToFit()
        userInfoLayout.addSubview(nickNameLabel)
        */
        
    }

    //线性布局片段3：垂直线性布局套垂直线性布局
    func createSection3(in contentLayout:TGLinearLayout)
    {
        
        //垂直线性布局套垂直线性布局
        let ageLayout = TGLinearLayout(.vert)
        ageLayout.layer.borderColor = UIColor.lightGray.cgColor
        ageLayout.layer.borderWidth = 0.5
        ageLayout.layer.cornerRadius = 4
        ageLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        ageLayout.tg_gravity = TGGravity.horz.fill  //布局视图的gravity设置了里面的所有的子视图都是水平填充的，这样所有的子视图都不需要设置宽度了。
        ageLayout.tg_top.equal(20)
        ageLayout.tg_width.equal(.fill)
        ageLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(ageLayout)
        
        
        let ageTitleLabel = UILabel()
        ageTitleLabel.text = NSLocalizedString("Age:", comment:"")
        ageTitleLabel.font = CFTool.font(15)
        ageTitleLabel.sizeToFit()
        ageLayout.addSubview(ageTitleLabel)
        
        //垂直线性布局套水平线性布局
        let ageSelectLayout = TGLinearLayout(.horz)
        ageSelectLayout.tg_hspace = 10  //设置里面所有子视图之间的水平间距都是10，这样里面的子视图就不在需要设置间距了。
        ageSelectLayout.tg_top.equal(5)
        ageSelectLayout.tg_height.equal(.wrap)
        ageLayout.addSubview(ageSelectLayout)
        
        for i in 0...2
        {
            let ageLabel = UILabel()
            ageLabel.text = String(format:"%ld", (i + 2) * 10)
            ageLabel.textAlignment  = .center
            ageLabel.layer.cornerRadius = 15
            ageLabel.layer.borderColor = CFTool.color(3).cgColor
            ageLabel.layer.borderWidth = 0.5
            ageLabel.font = CFTool.font(13)
            ageLabel.tg_height.equal(30)
            ageLabel.tg_width.equal(.average)  //这里面每个子视图的宽度来平均分配父视图的宽度。这样里面所有子视图的宽度都相等。
            ageSelectLayout.addSubview(ageLabel)
        }
        
        //为实现这个功能，线性布局需要2层嵌套来完成，这无疑增加了代码量，因此您可以改为用一个垂直浮动布局来实现相同的能力。
        /*
         let ageLayout = TGFloatLayout(.vert)
        ageLayout.layer.borderColor = UIColor.lightGray.cgColor
        ageLayout.layer.borderWidth = 0.5
        ageLayout.layer.cornerRadius = 4
        ageLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        ageLayout.tg_top.equal(20)
        ageLayout.tg_vspace = 5
        ageLayout.tg_hspace = 10
        ageLayout.tg_width.equal(.fill)
        ageLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(ageLayout)
        
        
        let ageTitleLabel = UILabel()
        ageTitleLabel.text = NSLocalizedString("Age:", comment:"")
        ageTitleLabel.font = CFTool.font(15)
        ageTitleLabel.sizeToFit()
        ageTitleLabel.tg_width.equal(.fill)  //占据整行
        ageLayout.addSubview(ageTitleLabel)

        
        for i in 0...2
        {
            let ageLabel = UILabel()
            ageLabel.text = String(format:"%ld", (i + 2) * 10)
            ageLabel.textAlignment  = .center
            ageLabel.layer.cornerRadius = 15
            ageLabel.layer.borderColor = CFTool.color(3).cgColor
            ageLabel.layer.borderWidth = 0.5
            ageLabel.font = CFTool.font(13)
            ageLabel.tg_height.equal(30)
            //宽度这样设置的原因是：3个子视图要平分布局视图的宽度，这里每个子视图的间距是10。
            //因此每个子视图的宽度 = (布局视图宽度 - 2 * 子视图间距)/3 = 布局视图宽度 * 1/3 - 2*子视图间距/3
            //TGLayoutSize中的equal方法设置布局宽度，multiply方法用来设置1/3，add方法用来设置2*子视图间距/3. 因此可以进行如下设置：
            ageLabel.tg_width.equal(ageLayout.tg_width).multiply(1.0/3).add(-1 * 2 * ageLayout.tg_hspace / 3)
            ageLayout.addSubview(ageLabel)
        }
      */
    }
    
    //线性布局片段4：垂直线性布局套水平线性布局，里面有动态高度的文本。
    func createSection4(in contentLayout:TGLinearLayout)
    {
        /*垂直线性布局套水平线性布局*/
        let addressLayout = TGLinearLayout(.horz)
        addressLayout.layer.borderColor = UIColor.lightGray.cgColor
        addressLayout.layer.borderWidth = 0.5
        addressLayout.layer.cornerRadius = 4
        addressLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        addressLayout.tg_top.equal(20)
        addressLayout.tg_width.equal(.fill)
        addressLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(addressLayout)
        
        
        let addressTitleLabel = UILabel()
        addressTitleLabel.text = NSLocalizedString("Address:", comment:"")
        addressTitleLabel.font = CFTool.font(15)
        addressTitleLabel.sizeToFit() //这里面虽然也会让视图的尺寸由内容决定，但是却没有自动换行的能力。
        addressLayout.addSubview(addressTitleLabel)
        
        
        let addressLabel = UILabel()
        addressLabel.text = NSLocalizedString("Winterless Building, West Dawang Road, Chaoyang district CBD, Beijing, People's Republic of China", comment:"")
        addressLabel.textColor = CFTool.color(4)
        addressLabel.font = CFTool.font(14)
        addressLabel.tg_leading.equal(10)
        addressLabel.tg_width.equal(.fill)
        addressLabel.tg_height.equal(.wrap) //这里面的UILabel的宽度和父视图宽度一致，而高度则由内容决定，这种方式可以实现子视图的高度动态决定。
        addressLayout.addSubview(addressLabel)
        
    }
    
    //线性布局片段5：垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局
    func createSection5(in contentLayout:TGLinearLayout)
    {
        /*垂直线性布局套水平线性布局，水平线性布局利用相对边距实现左右布局*/
        let sexLayout = TGLinearLayout(.horz)
        sexLayout.layer.borderColor = UIColor.lightGray.cgColor
        sexLayout.layer.borderWidth = 0.5
        sexLayout.layer.cornerRadius = 4
        sexLayout.tg_padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        sexLayout.tg_top.equal(20)
        sexLayout.tg_width.equal(.fill)
        sexLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(sexLayout)
        
        
        let sexLabel = UILabel()
        sexLabel.text = NSLocalizedString("Sex:", comment:"")
        sexLabel.font = CFTool.font(15)
        sexLabel.sizeToFit()
        sexLabel.tg_centerY.equal(0)  //垂直居中。
        sexLabel.tg_trailing.equal(50%)  //右边距离占用剩余空间的一半
        sexLayout.addSubview(sexLabel)
        
        
        let sexSwitch = UISwitch()
        sexSwitch.tg_leading.equal(50%) //左边距离占用剩余空间的一半。
        sexLayout.addSubview(sexSwitch)
        
        //在水平线性布局视图中的这种子视图左右布局的实现，我们可以将左右的间距设置为比重值！表明间距占用父布局的剩余宽度。
        //sexLabel, sexSwitch两个子视图在水平线性布局里面一个左一个右的原理是使用了相对间距的原因。假设某个水平线性布局的宽度是100，里面有两个子视图A，B。其中A的宽度是20，B的宽度是30。同时假设A的tg_trailing ~= 20%。B的tg_leading ~=80%。则这时候A的右边距 = (100 - 20 - 30) * 0.2 / (0.2 + 0.8) = 10， B的左边距则是40。通过相对间距可以实现动态的视图之间的间距。


    }
    
    //建立一个基线对齐的水平线性布局
    func createSection6(in contentLayout:TGLinearLayout)
    {
        //这个例子主要介绍基线对齐的使用方法，目前只有水平线性布局和相对布局是支持基线对齐的。水平线性布局里面要实现基线对齐，必须要设置一个基线对齐的标准视图。
        //线性布局里面的tg_baselineBaseView属性用来指定基线的标准视图，设置为tg_baselineBaseView的子视图必须是一个UILabel或者UITextField或者UITextView，并且只能是一行。
        //除了指定基线对齐的标准视图外，还需要为线性布局的tg_gravity属性设置上TGGravity.vert.baseline才可以完成基线对齐的设置。所有其他的UILabel，UITextField，UITextView都将和标准视图的基线进行对齐，而其他类型的子视图则忽略。
        //基线对齐对于中文来说基本没有什么效果，主要是针对英文以及具有基线的字符集。
        
        let baselineLayout = TGLinearLayout(.horz)
        baselineLayout.layer.borderColor = UIColor.lightGray.cgColor
        baselineLayout.layer.borderWidth = 0.5
        baselineLayout.layer.cornerRadius = 4
        baselineLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        baselineLayout.tg_top.equal(20)
        baselineLayout.tg_horzMargin(0)
        baselineLayout.tg_height.equal(50)
        baselineLayout.tg_gravity = [TGGravity.horz.center, TGGravity.vert.baseline]
        contentLayout.addSubview(baselineLayout)
        
        let baselineLabel = UILabel()
        baselineLabel.text = "Baseline view"
        baselineLabel.tg_size(width: .wrap, height: .wrap)
        baselineLabel.font = CFTool.font(20)
        baselineLabel.backgroundColor = CFTool.color(5)
        baselineLabel.tg_alignment = TGGravity.vert.center  //标准视图垂直居中。
        baselineLayout.addSubview(baselineLabel)
        
        let rightLabel = UILabel()
        rightLabel.text = "Right view"
        rightLabel.tg_size(width: .wrap, height: .wrap)
        rightLabel.font = CFTool.font(32)
        rightLabel.backgroundColor = CFTool.color(6)
        baselineLayout.addSubview(rightLabel)
        
        baselineLayout.tg_baselineBaseView = baselineLabel  //这里将左边的视图设置为基线对齐的标准视图。
        
    }

    
    //线性布局片段7：实现子视图的缩放。
    func createSection7(in contentLayout:TGLinearLayout)
    {
        let shrinkLabel = UILabel()
        shrinkLabel.text = NSLocalizedString("This is a can automatically wrap text.To realize this function, you need to set the clear width, and set the flexedHeight to YES and set the numberOfLines to 0.You can try to switch different simulator or different orientation screen to see the effect.", comment:"")
        shrinkLabel.backgroundColor = CFTool.color(2)
        shrinkLabel.font = CFTool.font(14)
        shrinkLabel.clipsToBounds = true  //为了实现文本可缩放，需要将这个标志设置为YES，否则效果无法实现。但要慎重使用这个标志，因为如果设置YES的话会影响性能。
        shrinkLabel.tg_top.equal(20)
        shrinkLabel.tg_width.equal(.fill)
        shrinkLabel.tg_height.equal(.wrap) //在宽度确定的情况下高度动态决定。
        contentLayout.addSubview(shrinkLabel)
        self.shrinkLabel = shrinkLabel
        
        let button = UIButton(type:.system)
        button.addTarget(self, action: #selector(handleLabelShrink), for:.touchUpInside)
        button.setTitle(NSLocalizedString("Show&Hide the Text", comment:""), for:.normal)
        button.titleLabel?.font = CFTool.font(16)
        button.tg_centerX.equal(0)
        button.tg_height.equal(60)
        button.sizeToFit()
        contentLayout.addSubview(button)
        
        
       
    }
    
    //线性布局片段8：子视图的隐藏设置能够激发布局视图的重新布局。
    func createSection8(in contentLayout:TGLinearLayout)
    {
        
        let button = UIButton(type:.system)
        button.setTitle(NSLocalizedString("Show more》", comment:"") ,for:.normal)
        button.titleLabel?.font = CFTool.font(16)
        button.addTarget(self, action: #selector(handleShowMore), for:.touchUpInside)
        button.tg_top.equal(50)
        button.tg_trailing.equal(0)
        button.sizeToFit()
        contentLayout.addSubview(button)

        
        let hiddenView = UIView()
        hiddenView.backgroundColor = CFTool.color(3)
        hiddenView.tg_visibility = .gone
        hiddenView.tg_top.equal(20)
        hiddenView.tg_width.equal(.fill)
        hiddenView.tg_height.equal(800)
        contentLayout.addSubview(hiddenView)
        self.hiddenView = hiddenView

    }

    
}

// MARK: - Handle Method
extension LLTest2ViewController
{
    @objc func handleLabelShrink(_ sender :UIButton)
    {
    
        //如果当前高度是包裹值，则设置为0让高度变为0，否则再设置为.wrap。这样实现文本的高度伸缩。
        if self.shrinkLabel.tg_height.isWrap
        {
            self.shrinkLabel.tg_height.equal(0)
        }
        else
        {
            self.shrinkLabel.tg_height.equal(.wrap)
        }
    
        self.contentLayout.tg_layoutAnimationWithDuration(0.3) //设置完成布局中子视图的属性后可以调用布局视图的这个方法来实现动画效果。
    }
    
    @objc func handleShowMore(_ sender: UIButton)
    {
        //布局里面，如果子视图被隐藏则会引起布局视图的自动布局。
        if self.hiddenView.tg_visibility == .visible
        {
            sender.setTitle(NSLocalizedString("Close up《", comment:"") ,for:.normal)
            self.hiddenView.tg_visibility = .gone
        }
        else
        {
            sender.setTitle(NSLocalizedString("Show more》", comment:"") ,for:.normal)
            self.hiddenView.tg_visibility = .visible
        }
        
    }
    

    
}


