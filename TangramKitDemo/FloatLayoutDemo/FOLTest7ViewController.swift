//
//  FOLTest7ViewController.swift
//  TangramKit
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *7.FloatLayout - Alignment
 */
class FOLTest7ViewController: UIViewController {
    
    
    override func loadView() {
        
        /*
         这个例子主要给大家演示，在浮动布局中也可以支持一行(列)内的子视图的对齐方式的设置了。我们可以借助子视图的tg_alignment属性来设置其在浮动布局行(列)内的对齐方式。
         这里的对齐的标准都是以当前行(列)内最高(宽)的子视图为参考来进行(列)对齐的。
         
         在垂直浮动布局里面的子视图的行内对齐只能设置TGGravity.vert.top, TGGravity.vert.center, TGGravity.vert.bottom, TGGravity.vert.fill这几种对齐方式。
         在水平浮动布局里面的子视图的列内对齐只能设置TGGravity.horz.left, TGGravity.horz.center, TGGravity.horz.right, TGGravity.horz.fill这几种对齐方式。
         
         */
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0)
        
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = UIColor.lightGray
        rootLayout.tg_gravity = TGGravity.horz.fill  //所有子视图的宽度都和自己相等。
        rootLayout.tg_vspace = 10
        self.view = rootLayout
        
        let vertLayout = self.createVertFloatLayout(rootLayout)
        vertLayout.backgroundColor = UIColor.white
        vertLayout.tg_height.equal(80%)  //高度占用80%
        rootLayout.addSubview(vertLayout)
        
        let horzLayout =  self.createHorzFloatLayout(rootLayout)
        horzLayout.backgroundColor = UIColor.white
        horzLayout.tg_height.equal(20%) //高度占用20%
        rootLayout.addSubview(horzLayout)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Layout Construction
extension FOLTest7ViewController
{
    func createVertFloatLayout(_ rootLayout:TGLinearLayout) -> TGFloatLayout {
        
        let floatLayout = TGFloatLayout(.vert)
        
        let logoImageView = UIImageView(image: UIImage(named:"p1-12"))
        logoImageView.layer.borderColor = CFTool.color(4).cgColor
        logoImageView.layer.borderWidth = 1
        logoImageView.tg_alignment = TGGravity.vert.center  //在浮动的一行内垂直居中对齐。
        logoImageView.tg_margin(10)  //四周的边距都设置为10.
        logoImageView.tg_size(width: 80, height: 36)
        floatLayout.addSubview(logoImageView)
        
        let brandLabel = UILabel()
        brandLabel.text = "千奈美官方旗舰店"
        brandLabel.sizeToFit()
        brandLabel.tg_alignment = TGGravity.vert.center //在浮动的一行内垂直居中对齐。
        brandLabel.tg_vertMargin(10)
        floatLayout.addSubview(brandLabel)
        
        let attentionButton = UIButton(type:.system)
        attentionButton.setTitle("关注", for:.normal)
        attentionButton.sizeToFit()
        attentionButton.tg_reverseFloat = true   //关注放在右边，所以浮动到右边。
        attentionButton.tg_margin(10)
        attentionButton.tg_alignment = TGGravity.vert.center  //在浮动的一行内垂直居中对齐。
        floatLayout.addSubview(attentionButton)

        //单独一行。
        let line1 = UIView()
        line1.backgroundColor = CFTool.color(5)
        line1.tg_height.equal(2.0)
        line1.tg_width.equal(floatLayout.tg_width) //宽度和父视图一样宽。
        floatLayout.addSubview(line1)

        
        let showImageView1 = UIImageView(image: UIImage(named:"image2"))
        showImageView1.tg_margin(10)  //四周边距是10
        showImageView1.tg_width.equal(60%)   //此时父布局的剩余宽度是屏幕，因此这里的宽度就是屏幕宽度的0.6
        showImageView1.tg_height.equal(showImageView1.tg_width) //高度等于宽度。
        floatLayout.addSubview(showImageView1)

        
        //绘制线
        let line2 = UIView()
        line2.backgroundColor = CFTool.color(5)
        line2.tg_width.equal(2.0)
        line2.tg_height.equal(showImageView1.tg_height, increment:22) //高度和showImageView1高度相等，因为showImageView1还有上下分别为10的边距,还有中间横线的高度2，所以这里要增加22的高度。
        floatLayout.addSubview(line2)

        
        //右边上面的小图。
        let showImageView2 = UIImageView(image: UIImage(named:"image3"))
        showImageView2.tg_margin(10)  //四周边距是10
        showImageView2.tg_width.equal(100%)    //注意这里是剩余宽度的比重，因为这个小图要占用全部的剩余空间，因此这里设置为100%。
        showImageView2.tg_height.equal(showImageView1.tg_height, increment: -10, multiple: 0.5) //高度等于大图高度的一半，再减去多余的边距10
        floatLayout.addSubview(showImageView2)

        
        //中间横线。
        let line3 = UIView()
        line3.backgroundColor = CFTool.color(5)
        line3.tg_size(width: .fill, height: 2)
        floatLayout.addSubview(line3)

        //右边下面的小图
        let showImageView3 = UIImageView(image: UIImage(named:"image4"))
        showImageView3.tg_margin(10)  //四周边距是10
        showImageView3.tg_width.equal(100%)    //注意这里是剩余宽度的比重，因为这个小图要占用全部的剩余空间，因此这里设置为100%。
        showImageView3.tg_height.equal(showImageView1.tg_height, increment: -10, multiple: 0.5) //高度等于大图高度的一半，再减去多余的边距10
        floatLayout.addSubview(showImageView3)
        
        //绘制下面的横线。
        let line4 = UIView()
        line4.backgroundColor = CFTool.color(5)
        line4.tg_size(width: .fill, height: 2) //因为前面的所有内容都占满一行了，所以这条线是单独一行，这里是占用屏幕的全部空间了。
        line4.tg_bottom.equal(10)
        floatLayout.addSubview(line4)

        
        let signatureLabel = UILabel()
        signatureLabel.text = "今日已有137人签到获得好礼"
        signatureLabel.font = CFTool.font(14)
        signatureLabel.textColor = CFTool.color(4)
        signatureLabel.sizeToFit()
        signatureLabel.tg_horzMargin(10)
        signatureLabel.tg_alignment = TGGravity.vert.center
        floatLayout.addSubview(signatureLabel)

        let moreImageView = UIImageView(image: UIImage(named:"next"))
        moreImageView.tg_reverseFloat = true
        moreImageView.tg_horzMargin(10)
        moreImageView.tg_alignment = TGGravity.vert.center
        floatLayout.addSubview(moreImageView)

        
        let moreLabel = UILabel()
        moreLabel.text = "进店看看"
        moreLabel.sizeToFit()
        moreLabel.tg_reverseFloat = true
        moreLabel.tg_alignment = TGGravity.vert.center
        floatLayout.addSubview(moreLabel)

        
        let line5 = UIView()
        line5.backgroundColor = CFTool.color(5)
        line5.tg_height.equal(2)
        line5.tg_vertMargin(10)
        line5.tg_width.equal(floatLayout.tg_width)
        floatLayout.addSubview(line5)

        
        //
        let commentImageView1 = UIImageView(image: UIImage(named:"minions4"))
        commentImageView1.tg_alignment = TGGravity.vert.fill  //这里使用填充对齐，表明会和这行里面高度最高的那个子视图的高度保持一致。
        commentImageView1.tg_left.equal(10)
        floatLayout.addSubview(commentImageView1)

        let commentImageView2 = UIImageView(image: UIImage(named:"minions3"))
        commentImageView2.tg_alignment = TGGravity.vert.fill  //这里使用填充对齐，表明会和这行里面高度最高的那个子视图的高度保持一致。
        commentImageView2.tg_left.equal(10)
        floatLayout.addSubview(commentImageView2)

        let commentImageView3 = UIImageView(image: UIImage(named:"minions3"))
        commentImageView3.tg_left.equal(10)
        floatLayout.addSubview(commentImageView3)

        
        for _ in 0 ..< 4
        {
            let starImageView = UIImageView(image: UIImage(named:"section2"))
            starImageView.tg_size(width: 20, height: 20)
            starImageView.tg_alignment = TGGravity.vert.bottom  //这里底部对齐，表明子视图和一行内最高的子视图保持底部对齐。
            starImageView.tg_left.equal(5)
            floatLayout.addSubview(starImageView)
        }
        
        
        let line6 = UIView()
        line6.backgroundColor = CFTool.color(5)
        line6.tg_height.equal(2)
        line6.tg_width.equal(floatLayout.tg_width)
        floatLayout.addSubview(line6)
        
        
        return floatLayout
        
    }
    
    func createHorzFloatLayout(_ rootLayout:TGLinearLayout) -> TGFloatLayout {
        
        let floatLayout = TGFloatLayout(.horz)
        floatLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        floatLayout.tg_space = 10
        
        let names = ["minions1","minions3","minions2","minions4","p4-23","p4-11"]
        for i in 0 ..< 6
        {
            let imageView = UIImageView(image: UIImage(named:names[i]))
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = CFTool.color(6).cgColor
            imageView.tg_height.equal(floatLayout.tg_height, increment: -5, multiple: 0.5) //高度等于父视图的高度的一半，因为设置了每个子视图的间距为10，所以这里要减去5。
            if i % 2 == 0
            {//这句话的意思一列显示两个子视图，所以当索引下标为偶数时就是换列处理。
                imageView.tg_clearFloat = true
            }
            
            //水平填充,每列两个子视图，每列的对齐方式都不一样。
            switch (i) {
            case 0 ... 1:
                imageView.tg_alignment = TGGravity.horz.center
                break;
            case 2 ... 3:
                imageView.tg_alignment = TGGravity.horz.trailing
                break;
            case 4 ... 5:
                imageView.tg_alignment = TGGravity.horz.fill
            default:
                break;
            }
            
            floatLayout.addSubview(imageView)
            
        }
        
        return floatLayout
        
    }
}

