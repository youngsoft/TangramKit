//
//  FOLTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *6.FloatLayout - User Profiles
 */
class FOLTest6ViewController: UIViewController {
    
    
    override func loadView() {
        
        /**
         *  这个例子用浮动布局来实现各种用户个人信息的页面布局，当然浮动布局不是万能的，这里只是为了强调用浮动布局实现的机制。
         *  在很多界面中，有人诟病用线性布局来实现时会要嵌套很多的子布局，因此在一些场景中其实您不必全部都用线性布局，可以用浮动布局、流式布局或者相对布局来实现一些复杂一点的界面布局。
         */
        let scrollView = UIScrollView()
        self.view = scrollView
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .lightGray
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap).min(scrollView.tg_height) //默认虽然高度包裹，但是最小的高度要和滚动视图相等。
        rootLayout.tg_vspace = 10
        scrollView.addSubview(rootLayout)
        
        //Create First User Profile type。
        self.createUserProfile1Layout(rootLayout)
        
        //Create Second User Profile type.
        self.createUserProfile2Layout(rootLayout)
        
        self.createUserProfile3Layout(rootLayout)
        
        self.createUserProfile4Layout(rootLayout)
        
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
extension FOLTest6ViewController
{
    func createUserProfile1Layout(_ rootLayout:TGLinearLayout)
    {
        //这个例子建立一个只向上浮动的浮动布局视图，注意这里要想布局高度由子视图包裹的话则必须要同时设置tg_noBoundaryLimit为true。
        //在常规情况下，如果使用左右浮动布局时，要求必须有明确的宽度，宽度不能.wrap。同样使用上下浮动布局时，要求必须要有明确的高度，也就是高度不能.wrap。这样设置明确宽度或者高度的原因是浮动布局需要根据这些宽度或者高度的约束自动换行浮动。但是在实践的场景中，有时候我们在浮动方向上没有尺寸约束限制，而是人为的来控制子视图的换行，并且还要布局视图的宽度和高度具有包裹属性，那么这时候我们就可以用浮动布局的tg_noBoundaryLimit属性来进行控制了。
        //设置tg_noBoundaryLimit为true时必要同时设置包裹属性。具体情况见属性tg_noBoundaryLimit的说明。
        
        let contentLayout = TGFloatLayout(.horz)
        contentLayout.backgroundColor = UIColor.white
        contentLayout.tg_noBoundaryLimit = true
        contentLayout.tg_height.equal(.wrap) //对于上下浮动布局来说，如果只想向上浮动，而高度又希望是由子视图决定，则必须要设置tg_noBoundaryLimit的值为true。
        
        
        contentLayout.tg_leading.equal(0)
        contentLayout.tg_trailing.equal(0)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
        contentLayout.tg_hspace = 5
        contentLayout.tg_vspace = 5
        rootLayout.addSubview(contentLayout)
        
        
        let headImageView = UIImageView(image:UIImage(named:"head1"))
        headImageView.tg_width.equal(40)
        headImageView.tg_height.equal(40) //头像部分固定尺寸。。
        contentLayout.addSubview(headImageView)
        
        let nameLabel = UILabel()
        nameLabel.text = "欧阳大哥"
        nameLabel.font = CFTool.font(17)
        nameLabel.textColor = CFTool.color(4)
        nameLabel.tg_clearFloat = true; //注意这里要另外起一行。
        nameLabel.tg_width.equal(contentLayout.tg_width, increment:-45) //40的头像宽度外加5的左右间距。
        nameLabel.sizeToFit()
        contentLayout.addSubview(nameLabel)
        
        let nickNameLabel = UILabel()
        nickNameLabel.text = "醉里挑灯看键"
        nickNameLabel.font = CFTool.font(15)
        nickNameLabel.textColor = CFTool.color(3)
        nickNameLabel.sizeToFit()
        contentLayout.addSubview(nickNameLabel)
        
        let addressLabel = UILabel()
        addressLabel.text = "联系地址：中华人民共和国北京市朝阳区盈科中心B座2楼,其他的我就不会再告诉你了。"
        addressLabel.font = CFTool.font(15)
        addressLabel.textColor = CFTool.color(4)
        addressLabel.tg_height.equal(.wrap)
        addressLabel.tg_width.equal(contentLayout.tg_width, increment:-45) //40的头像宽度外加5的左右间距。
        contentLayout.addSubview(addressLabel)
        
        let qqlabel = UILabel()
        qqlabel.text = "QQ群:178573773"
        qqlabel.font = CFTool.font(15)
        qqlabel.textColor = CFTool.color(4)
        qqlabel.sizeToFit();
        contentLayout.addSubview(qqlabel)
        
        let githublabel = UILabel()
        githublabel.text = "github: https://github.com/youngsoft"
        githublabel.font = CFTool.font(15)
        githublabel.textColor = CFTool.color(9)
        githublabel.tg_width.equal(contentLayout.tg_width, increment:-45) //40的头像宽度外加5的左右间距。
        githublabel.adjustsFontSizeToFitWidth = true
        githublabel.sizeToFit()
        contentLayout.addSubview(githublabel)
        
        let detailLabel = UILabel()
        detailLabel.text = "坚持原创，以造轮子为乐!"
        detailLabel.font = CFTool.font(20)
        detailLabel.textColor = CFTool.color(2)
        detailLabel.tg_width.equal(contentLayout.tg_width, increment:-45) //40的头像宽度外加5的左右间距。
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.sizeToFit()
        contentLayout.addSubview(detailLabel)
    }
    
    
    func createUserProfile2Layout(_ rootLayout:TGLinearLayout)
    {
        //浮动布局的一个缺点是居中对齐难以实现，所以这里需要对子视图做一些特殊处理。
        
        let contentLayout = TGFloatLayout(.vert)
        contentLayout.backgroundColor = .white
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_leading.equal(0)
        contentLayout.tg_trailing.equal(0)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
        rootLayout.addSubview(contentLayout)
        
        let headImageView = UIImageView(image:UIImage(named:"minions4"))
        headImageView.contentMode = .center
        headImageView.tg_width.equal(100%) //占据全部宽度。
        headImageView.tg_height.equal(80)
        contentLayout.addSubview(headImageView)
        
        
        let nameLabel = UILabel()
        nameLabel.text = "欧阳大哥"
        nameLabel.font = CFTool.font(17)
        nameLabel.textColor = CFTool.color(4)
        nameLabel.textAlignment = .center
        nameLabel.tg_width.equal(100%)
        nameLabel.tg_top.equal(10)
        nameLabel.sizeToFit()
        contentLayout.addSubview(nameLabel)
        
        
        let nickNameLabel = UILabel()
        nickNameLabel.text = "醉里挑灯看键"
        nickNameLabel.font = CFTool.font(15)
        nickNameLabel.textColor = CFTool.color(3)
        nickNameLabel.textAlignment = .center
        nickNameLabel.tg_width.equal(100%)
        nickNameLabel.tg_top.equal(5)
        nickNameLabel.tg_bottom.equal(15)
        nickNameLabel.sizeToFit()
        contentLayout.addSubview(nickNameLabel)
        
        
        let images = ["section1","section2", "section3"];
        let menus = ["Followers","Starred", "Following"];
        let values = ["140","5","0"];
        
        //三个小图标均分宽度。
        for i in 0 ..< 3
        {
            let imageView = UIImageView(image:UIImage(named:images[i]))
            imageView.contentMode = .center
            imageView.tg_height.equal(20)
            imageView.tg_width.equal(TGWeight(100.0/(CGFloat(3-i)))) //这里三个，第一个占用全部的1/3，第二个占用剩余的1/2，第三个占用剩余的1/1。这样就实现了均分宽度的效果。
            contentLayout.addSubview(imageView)
        }
        
        //文本均分宽度
        for i in 0 ..< 3
        {
            let menuLabel = UILabel()
            menuLabel.text = menus[i];
            menuLabel.font = CFTool.font(14)
            menuLabel.textColor = CFTool.color(2)
            menuLabel.textAlignment = .center
            menuLabel.adjustsFontSizeToFitWidth = true
            menuLabel.tg_width.equal(TGWeight(100.0/(CGFloat(3-i))))
            menuLabel.tg_top.equal(10)
            menuLabel.sizeToFit()
            contentLayout.addSubview(menuLabel)
        }
        
        //文本均分宽度。
        for i in 0 ..< 3
        {
            let valueLabel = UILabel()
            valueLabel.text = values[i];
            valueLabel.font = CFTool.font(14)
            valueLabel.textColor = CFTool.color(2)
            valueLabel.textAlignment = .center
            valueLabel.adjustsFontSizeToFitWidth = true
            valueLabel.tg_width.equal(TGWeight(100.0/(CGFloat(3-i))))
            valueLabel.tg_top.equal(5)
            valueLabel.sizeToFit()
            contentLayout.addSubview(valueLabel)
        }
        
        
        
    }
    
    func createUserProfile3Layout(_ rootLayout:TGLinearLayout)
    {
        //这个例子里面上下浮动布局还是可以设置高度为.wrap，并且这里用了tg_layoutCompletedDo来实现一些特殊化处理。
        
        let contentLayout = TGFloatLayout(.horz)
        contentLayout.backgroundColor = .white
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_leading.equal(0)
        contentLayout.tg_trailing.equal(0)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
        rootLayout.addSubview(contentLayout)
        
        
        let headImageView = UIImageView(image:UIImage(named:"minions4"))
        headImageView.layer.cornerRadius = 5;
        headImageView.layer.borderColor = UIColor.lightGray.cgColor
        headImageView.layer.borderWidth = 1;
        headImageView.tg_width.equal(80)
        headImageView.tg_height.equal(80)
        headImageView.tg_trailing.equal(10)
        contentLayout.addSubview(headImageView)
        headImageView.tg_layoutCompletedDo{(layout:TGBaseLayout, sbv:UIView) in
            //这里我们建立一个特殊的子视图，我们可以在这个block里面建立子视图，不会影响到这次的子视图的布局。
            let label = UILabel()
            label.tg_useFrame = true   //这里我们设置useFrame为YES表示他不会参与布局，这样这个视图就可以摆脱浮动布局视图的约束。
            label.text = "99";
            label.font = CFTool.font(12)
            label.textColor = .white
            label.backgroundColor = .red
            label.sizeToFit() //这里内部会设置frame值。
            label.layer.cornerRadius = label.frame.height/2;
            label.layer.masksToBounds = true
            var labelRect = label.frame;
            labelRect.origin.x = sbv.frame.maxX - label.frame.width / 2;
            labelRect.origin.y = sbv.frame.minY - label.frame.height / 2;
            label.frame = labelRect;
            layout.addSubview(label)
            
        }
        
        
        let nameLabel = UILabel()
        nameLabel.text = "欧阳大哥";
        nameLabel.font = CFTool.font(17)
        nameLabel.textColor = CFTool.color(4)
        nameLabel.sizeToFit()
        contentLayout.addSubview(nameLabel)
        
        let nickNameLabel = UILabel()
        nickNameLabel.text = "醉里挑灯看键"
        nickNameLabel.font = CFTool.font(15)
        nickNameLabel.textColor = CFTool.color(3)
        nickNameLabel.sizeToFit()
        contentLayout.addSubview(nickNameLabel)
        
        
        let detailLabel =  UILabel()
        detailLabel.text = "坚持原创，以造轮子为乐!";
        detailLabel.font = CFTool.font(20)
        detailLabel.textColor = CFTool.color(2)
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.tg_reverseFloat = true
        detailLabel.sizeToFit()
        contentLayout.addSubview(detailLabel)
        
    }
    
    
    func createUserProfile4Layout(_ rootLayout:TGLinearLayout)
    {
        let contentLayout = TGFloatLayout(.vert)
        contentLayout.backgroundColor = .white
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_leading.equal(0)
        contentLayout.tg_trailing.equal(0)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        rootLayout.addSubview(contentLayout)
        
        let headImageView = UIImageView(image:UIImage(named:"minions4"))
        headImageView.layer.cornerRadius = 5;
        headImageView.layer.borderColor = UIColor.lightGray.cgColor
        headImageView.layer.borderWidth = 1;
        headImageView.tg_width.equal(80)
        headImageView.tg_height.equal(80)
        headImageView.tg_trailing.equal(10)
        contentLayout.addSubview(headImageView)
        
        
        let editButton = UILabel()
        editButton.text = "Edit"
        editButton.textAlignment = .center
        editButton.backgroundColor = .green
        editButton.textColor = .white
        editButton.layer.cornerRadius = 5
        editButton.layer.masksToBounds = true
        editButton.tg_width.equal(.wrap, increment:20)
        editButton.tg_height.equal(.wrap, increment:4)
        editButton.tg_reverseFloat = true
        contentLayout.addSubview(editButton)
        
        let nameLabel = UILabel()
        nameLabel.text = "欧阳大哥";
        nameLabel.font = CFTool.font(17)
        nameLabel.textColor = CFTool.color(4)
        nameLabel.tg_width.equal(100%)
        nameLabel.sizeToFit()
        contentLayout.addSubview(nameLabel)
        
        let nickNameImageView = UIImageView(image:UIImage(named:"edit"))
        nickNameImageView.sizeToFit()
        nickNameImageView.tg_top.equal(5)
        contentLayout.addSubview(nickNameImageView)
        
        let nickNameLabel = UILabel()
        nickNameLabel.text = "醉里挑灯看键";
        nickNameLabel.font = CFTool.font(15)
        nickNameLabel.textColor = CFTool.color(3)
        nickNameLabel.sizeToFit()
        nickNameLabel.tg_top.equal(5)
        contentLayout.addSubview(nickNameLabel)
        
        
        let detailLabel = UILabel()
        detailLabel.text = "坚持原创，以造轮子为乐!";
        detailLabel.font = CFTool.font(20)
        detailLabel.textColor = CFTool.color(2)
        detailLabel.adjustsFontSizeToFitWidth = true
        detailLabel.sizeToFit()
        detailLabel.tg_width.equal(.fill)  //等价于tg_width.equal(100%)
        detailLabel.tg_clearFloat = true
        detailLabel.tg_top.equal(5)
        contentLayout.addSubview(detailLabel)
    }
    
    
    
    
}

