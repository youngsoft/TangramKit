//
//  LLTest6ViewController.swift
//  TangramKit
//
//  Created by yant on 10/5/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class LLTest6ViewController: UIViewController , UITextViewDelegate  {
    
    weak var editButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func loadView() {
        
        //注意这个DEMO进来慢的原因是其中使用了UITextView,和MyLayout无关。UITextView会在第一次使用时非常的慢，后续就快了。。
        
        
        /*
         这个例子主要说的是视图之间的浮动间距设置，以及间距和尺寸的最大最小值限制的应用场景。子视图的布局尺寸类MyLayoutDime可以通过设置min,max的方法来实现最低尺寸和最高尺寸的限制设置。
         */
        
        /*
         1.如果把一个布局视图作为视图控制器根视图请务必将wrapContentHeight和wrapContentWidth设置为NO。
         2.如果想让一个布局视图的宽度和非布局视图的宽度相等则请将布局视图的myLeftMargin = myRightMargin = 0或者widthDime.equalTo(superview.widthDime)
         3.如果想让一个布局视图的高度和非布局视图的高度相等则请将布局视图的myTopMargin = myBottomMargin = 0或者heightDime.equalTo(superview.heightDime)
         */


        super.loadView()
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scrollView)
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .white
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.fill)
        rootLayout.tg_height.min(568 - 64)
        //这个设置可以用运算符来设置： 
        //rootLayout.tg_height >= 504
        
        //设置布局视图的高度等于父视图的高度，并且最低高度不能低于568-64.这两个数字的意思是iPhone5的高度减去导航条的高度部分。这句话的意思也就是说明最低不能低于iPhone5的高度，因此在iPhone4上就会出现滚动的效果！！！通过min,max方法的应用可以很容易实现各种屏幕的完美适配！！。
        //请您分别测试在iPhone4设备和非iPhone4设备上的情况，看看这个神奇的效果。你不再需要写if条件来做适配处理了。
        scrollView.addSubview(rootLayout)
        
        //可以给布局设置触摸事件。
        rootLayout.tg_setTarget(self, action: #selector(handleHideKeyboard), for:.touchUpInside)
        
        
        
        let userInfoLabel = UILabel()
        userInfoLabel.text = NSLocalizedString("user info(run in iPhone4 will have scroll effect)",comment:"")
        userInfoLabel.textColor = CFTool.color(4)
        userInfoLabel.font = CFTool.font(15)
        userInfoLabel.adjustsFontSizeToFitWidth = true
        userInfoLabel.textAlignment = .center
        userInfoLabel.sizeToFit()
        userInfoLabel.tg_top.equal(10)
        userInfoLabel.tg_centerX.equal(0)
        userInfoLabel.tg_width.max(rootLayout.tg_width)
        rootLayout.addSubview(userInfoLabel)
        
        
        
        //头像
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "head1")
        headImageView.backgroundColor  = CFTool.color(1)
        headImageView.sizeToFit()
        headImageView.tg_top.equal(25%)
        headImageView.tg_centerX.equal(0) //距离顶部间隙剩余空间的25%，水平居中对齐。
        rootLayout.addSubview(headImageView)
        
        
        //用户信息
        let nameField = UITextField()
        nameField.borderStyle = .roundedRect
        nameField.placeholder = NSLocalizedString("input user name here", comment:"")
        nameField.textAlignment = .center
        nameField.font = CFTool.font(15)
        nameField.tg_left.equal(10%)
        nameField.tg_right.equal(10%)
        nameField.tg_top.equal(10%)
        nameField.tg_height.equal(40) //高度为40，左右间距为布局的10%, 顶部间距为剩余空间的10%
        rootLayout.addSubview(nameField)
        
        
        /*
         用户描述，距离父视图左边为布局视图宽度的5%,但是最小不能小于17，最大不能超过19。
         如果在iPhone4上左边距按0.05算的话是16,但是因为左边距不能小于17，所以iPhone4上的左边距为17。
         如果在iPhone6+上左边距按0.05算的话是20.7,但是因为左边距不能大于19，所以iPhone6+上的左边距为19。
         如果在iPhone6上左边距按0.05算的话是18.75,没有超过最小最大限制，所以iPhone6上的左边距就是18.75
         */
        let userDescLabel = UILabel()
        userDescLabel.text = NSLocalizedString("desc info", comment:"")
        userDescLabel.textColor = CFTool.color(4)
        userDescLabel.font = CFTool.font(14)
        userDescLabel.sizeToFit()
        userDescLabel.tg_top.equal(10)
        userDescLabel.tg_left.equal(5%)
        userDescLabel.tg_left.min(17)
        userDescLabel.tg_left.max(19)  //最小17最大19
       // userDescLabel.tg_left >= 17
       // userDescLabel.tg_left <= 19
        rootLayout.addSubview(userDescLabel)
        
        
        let textView = UITextView()
        textView.font = CFTool.font(15)
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.text = NSLocalizedString("please try input text and carriage return continuous to see effect", comment:"")
        textView.delegate = self
        
        //左右间距为布局的10%，距离底部间距为65%,浮动高度，但高度最高为300，最低为30
        //高度为.wrap和min,max的结合能做到一些完美的自动伸缩功能。
        textView.tg_left.equal(5%)
        textView.tg_right.equal(5%)
        textView.tg_bottom.equal(65%)
        textView.tg_height.equal(.wrap)
        textView.tg_height.max(300)
        textView.tg_height.min(60)  //虽然高度为.wrap表示高度为动态高度，但是仍然不能超过300的高度以及不能小于60的高度。
        rootLayout.addSubview(textView)
        
        
        
        let copyRightLabel = UILabel()
        copyRightLabel.text = NSLocalizedString("copy rights reserved by Youngsoft", comment:"")
        copyRightLabel.textColor = CFTool.color(4)
        copyRightLabel.font = CFTool.font(15)
        copyRightLabel.tg_bottom.equal(20) //总是固定在底部20的边距,因为上面的textView用了底部相对间距。
        copyRightLabel.tg_centerX.equal(0)
        copyRightLabel.sizeToFit()
        rootLayout.addSubview(copyRightLabel)
        
        
        //因为在垂直线性布局里面每一列只能有一个子视图，但在实际中我们希望某个子视图边缘有一个子视图并列，为了不破坏线性布局的能力，而又能实现这种功能
        //我们可以用如下的方法。
        weak var weakVC:LLTest6ViewController! = self
        weak var weakHeadImageView:UIImageView! = headImageView
        rootLayout.tg_rotationToDeviceOrientationDo{(layout:TGBaseLayout, isFirst:Bool, isPortrait:Bool) in
        //tg_rotationToDeviceOrientationDo方法会在第一次完成布局或者因为屏幕旋转而完成布局时调用这个block。而且布局不会在调用完成后释放这个block。
            //因此需要注意循环引用的问题。
            if (isFirst)
            {
                let editButton = UIButton(type:.system)
                editButton.setTitle("Edit", for:.normal)
                editButton.titleLabel!.font = CFTool.font(15)
                editButton.tg_useFrame = true  //注意这里必须要设置为useFrame为YES，目的是为了不破坏线性布局的概念，而改用直接frame的设置。
                layout.addSubview(editButton)
                weakVC.editButton = editButton
            }
            //下面是直接用frame设置editButton的位置和尺寸。这里设置在头像图片的右边。。
            weakVC.editButton.frame = CGRect(x:weakHeadImageView.frame.maxX + 5, y:weakHeadImageView.frame.maxY - 30, width:50, height:30)
        }

        
        
    }
    
   // MARK: Handle Method
    
    func handleHideKeyboard(_ sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    
    // MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        
        let layout = textView.superview as! TGBaseLayout
        
        layout.setNeedsLayout()
        
        //这里设置在布局结束后将textView滚动到光标所在的位置了。在布局执行布局完毕后如果设置了tg_endLayoutDo的话可以在这个block里面读取布局里面子视图的真实布局位置和尺寸，也就是可以在block内部读取每个子视图的真实的frame的值。
        //这里我们可以实现tg_endLayoutDo来进行一些布局完成后的特殊处理操作。
        layout.tg_endLayoutDo {
            
            let rg = textView.selectedRange
            textView.scrollRangeToVisible(rg)
        }
        
        
    }
    
    
}
