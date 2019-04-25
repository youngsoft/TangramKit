//
//  FOLTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *4.FloatLayout - Tag cloud
 */
class FOLTest4ViewController: UIViewController {

    static var sTagHeight:CGFloat = 40
    static var sTagWidth:CGFloat = 70
    
    weak var contentLayout:TGLinearLayout!
    
    lazy var datas:[[String:AnyObject]] = {
        
        let file:String! =  Bundle.main.path(forResource: "FOLTest4DataModel",ofType:"plist")
        return NSArray(contentsOfFile: file) as! [[String:AnyObject]]
        
    }()
    
    override func viewDidLoad() {
        
        /*
         这个例子介绍用浮动布局来实现一个标签流的效果。因为浮动布局里面的子视图也是按照添加到布局中的顺序来进行布局定位的，所以浮动布局也具有实现标签流的能力。对于流式布局来说，里面的子视图不能出现跨行排列的情况。而浮动布局则能很方便的实现这个功能。
         */

        
        super.viewDidLoad()
        let scrollView = UIScrollView(frame:self.view.bounds)
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(scrollView)
        
        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .white
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_gravity = TGGravity.horz.fill
        scrollView.addSubview(rootLayout)
        
        //添加操作提示布局
        rootLayout.addSubview(self.createActionLayout())
        
        
        //添加数据内容布局
        let contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.backgroundColor = CFTool.color(0)
        contentLayout.tg_gravity = TGGravity.horz.fill
        contentLayout.tg_vspace = 10
        contentLayout.tg_padding = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0);
        rootLayout.addSubview(contentLayout)
        self.contentLayout = contentLayout
        
        //默认第一个风格。
        self.style1Layout(self.contentLayout)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Layout Construction
extension FOLTest4ViewController
{
    //样式1布局： 每行放4个标签，标签宽度不固定，标签之间的间距固定。
    func style1Layout(_ contentLayout:TGLinearLayout)
    {
        var  partIndex = 0
        for dict in self.datas
        {
            let floatLayout = TGFloatLayout(.vert)
            floatLayout.backgroundColor = .white
            floatLayout.tg_padding = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10);
            floatLayout.tg_height.equal(.wrap)
            floatLayout.tg_hspace = 30 //设置浮动布局里面子视图之间的水平间距。
            floatLayout.tg_vspace = 10 //设置浮动布局里面子视图之间的垂直间距。
            contentLayout.addSubview(floatLayout)
            
            //添加标题文本。
            let titleLabel = UILabel()
            titleLabel.text = dict["title"] as? String
            titleLabel.textColor = CFTool.color(4)
            titleLabel.font = CFTool.font(16)
            titleLabel.tg_width.equal(100%)  //标题部分占据全部的宽度，独占一行。所以
            titleLabel.tg_bottom.equal(5) //设置底部边距，这样下面的内容都和这个视图距离5个点。
            titleLabel.sizeToFit()
            floatLayout.addSubview(titleLabel)
            
            var lastTagView:UIView! = nil  //记录一下每个section的最后的tag视图。原因是每个section的开头都和前一部分有一定的距离。
            var sectionIndex = 0
            let sectionDicts = dict["sections"] as! [[String:AnyObject]]
            for sectionDict:[String:AnyObject] in sectionDicts
            {
                //创建Section部分的视图。
                let sectionTitle = sectionDict["sectionTitle"] as! String
                if !sectionTitle.isEmpty
                {
                    let sectionView = self.createSectionView(title:sectionTitle,image:sectionDict["sectionImage"] as! String)
                    //宽度是布局视图宽度的1/4，因为视图之间是有间距的，所以这里每个视图的宽度都要再减去3/4的间距值。
                    sectionView.tg_width.equal(floatLayout.tg_width, increment:-3.0/4.0 * floatLayout.tg_hspace, multiple:1.0/4.0)
                    //高度是标签的2倍，但因为中间还包括了一个垂直间距的高度，所以这里要加上垂直间距的值。
                    sectionView.tg_height.equal(FOLTest4ViewController.sTagHeight * 2 + floatLayout.tg_vspace)
                    sectionView.tg_clearFloat = true  //因为每个section总是新的一行开始。所以这里要把clearFloat设置为YES。
                    floatLayout.addSubview(sectionView)
                    sectionView.tag = partIndex * 1000 + sectionIndex;
                    
                    if (lastTagView != nil)
                    {
                        lastTagView.tg_bottom.equal(20) //最后一个tag视图的底部间距是20,这样下一个section的位置就会有一定的偏移。。
                    }
                    
                    
                    
                }
                
                //创建tag部分的视图。
                lastTagView = nil
                var tagIndex = 0
                let tagstrs = sectionDict["tags"] as! [String]
                for tagstr in tagstrs
                {
                    let tagView = self.createTagView(tagstr)
                    //宽度是布局视图宽度的1/4，因为视图之间是有间距的，所以这里每个视图的宽度都要再减去3/4的间距值。
                    tagView.tg_width.equal(floatLayout.tg_width, increment:-3.0 / 4.0 * floatLayout.tg_hspace, multiple:1.0/4.0)
                    //高度是固定的40
                    tagView.tg_height.equal(FOLTest4ViewController.sTagHeight)
                    floatLayout.addSubview(tagView)
                    lastTagView = tagView;
                    
                    tagView.tag = (partIndex * 1000 + sectionIndex) * 1000 + tagIndex;
                    tagIndex += 1
                }
                
                sectionIndex += 1
            }
            
            partIndex += 1
            
        }
        
    }
    
    //样式2布局：标签宽度固定为70，然后根据屏幕大小算出每行应该排列的数量，以及动态间距，但是间距不能小于8，如果间距小于8则每行的数量应该减少1个，同时增加间距。
    func style2Layout(_ contentLayout:TGLinearLayout)
    {
    /*
     通过对浮动布局的tg_setSubviews的使用，可以很方便的设置浮动间距值。布局会根据布局的宽度值，和你设置的子视图的固定宽度值，以及虽小间距值来自动算出您的子视图间距。需要注意的是如果当前的浮动布局的方向是.vert,则tg_setSubviews设置的是水平浮动间距，否则设置的将是垂直浮动间距。
     */
    
        var  partIndex = 0
        for dict in self.datas
        {
            let floatLayout = TGFloatLayout(.vert)
            
            floatLayout.backgroundColor = UIColor.white
            floatLayout.tg_padding = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10);
            floatLayout.tg_height.equal(.wrap)
            floatLayout.tg_vspace = 10 //设置浮动布局里面子视图之间的垂直间距。
            floatLayout.tg_setSubviews(size:FOLTest4ViewController.sTagWidth, minSpace: 8)
            contentLayout.addSubview(floatLayout)
            
            //在学习DEMO时您可以尝试着把下面两句代码解除注释！然后看看横竖屏的区别，这里面用到了SizeClass。表示横屏时的最小间距是不一样的。
            //当然如果您要改变子视图的尺寸的话，则要将下面的子视图也要实现对SIZECLASS的支持！！！
//            _ = floatLayout.tg_fetchSizeClass(with:.landscape, from: .default)
//            floatLayout.tg_setSubviews(size: FOLTest4ViewController.sTagWidth, minSpace: 40, inSizeClass:.landscape)
            
            //添加标题文本。
            let titleLabel = UILabel()
            titleLabel.text = dict["title"] as? String
            titleLabel.textColor = CFTool.color(4)
            titleLabel.font = CFTool.font(16)
            titleLabel.tg_width.equal(100%)  //标题部分占据全部的宽度，独占一行。所以
            titleLabel.tg_bottom.equal(5) //设置底部边距，这样下面的内容都和这个视图距离5个点。
            titleLabel.sizeToFit()
            floatLayout.addSubview(titleLabel)
            
            var lastTagView:UIView! = nil  //记录一下每个section的最后的tag视图。原因是每个section的开头都和前一部分有一定的距离。
            var sectionIndex = 0
            let sectionDicts = dict["sections"] as! [[String:AnyObject]]
            for sectionDict:[String:AnyObject] in sectionDicts
            {
                //创建Section部分的视图。
                let sectionTitle = sectionDict["sectionTitle"] as! String
                if !sectionTitle.isEmpty
                {
                    let sectionView = self.createSectionView(title:sectionTitle,image:sectionDict["sectionImage"] as! String)
                    sectionView.tg_width.equal(FOLTest4ViewController.sTagWidth) //固定宽度
                    sectionView.tg_height.equal(FOLTest4ViewController.sTagHeight * 2 + floatLayout.tg_vspace)
                    sectionView.tg_clearFloat = true  //因为每个section总是新的一行开始。所以这里要把clearFloat设置为YES。
                    floatLayout.addSubview(sectionView)
                    sectionView.tag = partIndex * 1000 + sectionIndex;
                    
                    if (lastTagView != nil)
                    {
                        lastTagView.tg_bottom.equal(20) //最后一个tag视图的底部间距是20,这样下一个section的位置就会有一定的偏移。。
                    }
                    
                    
                    
                }
                
                //创建tag部分的视图。
                lastTagView = nil
                var tagIndex = 0
                let tagstrs = sectionDict["tags"] as! [String]
                for tagstr in tagstrs
                {
                    let tagView = self.createTagView(tagstr)
                    tagView.tg_width.equal(FOLTest4ViewController.sTagWidth) //固定宽度
                    //高度是固定的40
                    tagView.tg_height.equal(FOLTest4ViewController.sTagHeight)
                    floatLayout.addSubview(tagView)
                    lastTagView = tagView;
                    
                    tagView.tag = (partIndex * 1000 + sectionIndex) * 1000 + tagIndex;
                    tagIndex += 1
                }
                
                sectionIndex += 1
            }
            
            partIndex += 1
            
        }

        
    }
    
    //创建操作动作布局。
    func createActionLayout() -> UIView
    {
        let actionLayout = TGFloatLayout(.vert)
        actionLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
        actionLayout.tg_hspace = 5;
        
        actionLayout.tg_height.equal(.wrap)
        actionLayout.tg_bottomBorderline = TGBorderline(color: UIColor.black)
        
        let actions = [NSLocalizedString("flexed width, fixed spacing", comment:""),
                       NSLocalizedString("fixed width, flexed spacing", comment:"")]
        
        for i in 0 ..< actions.count
        {
            let button = UIButton()
            button.setTitle(actions[i], for:.normal)
            button.setTitleColor(CFTool.color(7), for: .normal)
            button.setTitleColor(CFTool.color(2), for: .selected)
            button.titleLabel?.font = CFTool.font(14)
            button.layer.cornerRadius = 5;
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 0.5;
            button.tg_height.equal(44)
            button.tg_width.equal(actionLayout.tg_width, increment:-2.5, multiple:1.0/CGFloat(actions.count))
            button.tag = i + 100;
            button.addTarget(self,action:#selector(handleStyleChange),for:.touchUpInside)
            actionLayout.addSubview(button)
        }
        
        return actionLayout
    }
    
    //建立片段视图
    func createSectionView(title:String,image:String) -> UIView
    {
        
        let sectionLayout = TGLinearLayout(.vert)
        sectionLayout.layer.cornerRadius = 5;
        sectionLayout.layer.borderColor = UIColor.lightGray.cgColor
        sectionLayout.layer.borderWidth = 0.5
        sectionLayout.tg_gravity = .center
        sectionLayout.tg_setTarget(self,action:#selector(handleSectionViewTap), for:.touchUpInside)
        
        let sectionImageView = UIImageView(image: UIImage(named:image))
        sectionLayout.addSubview(sectionImageView)
        
        let sectionLabel = UILabel()
        sectionLabel.text = title;
        sectionLabel.textColor = UIColor.lightGray
        sectionLabel.adjustsFontSizeToFitWidth = true
        sectionLabel.textAlignment = .center
        sectionLabel.tg_leading.equal(0)
        sectionLabel.tg_trailing.equal(0)
        sectionLabel.sizeToFit()
        sectionLayout.addSubview(sectionLabel)
        
        return sectionLayout
    }
    
    //建立标签视图
    func createTagView(_ title:String) ->UIView
    {
        let tagButton = UIButton()
        tagButton.setTitle(title,for:.normal)
        tagButton.setTitleColor(CFTool.color(9),for:.normal)
        tagButton.titleLabel?.adjustsFontSizeToFitWidth = true
        tagButton.titleLabel?.font = CFTool.font(14)
        tagButton.layer.cornerRadius = 20;
        tagButton.layer.borderColor = UIColor.lightGray.cgColor
        tagButton.layer.borderWidth = 0.5;
        tagButton.addTarget(self,action:#selector(handleTagViewTap),for:.touchUpInside)
        
        return tagButton;
    }
    

}

//MARK: Handle Method
extension FOLTest4ViewController
{
    @objc func handleTagViewTap(sender:UIView!)
    {
        let  partIndex = sender.tag / 1000 / 1000;
        let  sectionIndex = (sender.tag / 1000) % 1000;
        let  tagIndex = sender.tag % 1000;
        let message = "you have select:\npartIndex:\(partIndex)\nsectionIndex:\(sectionIndex)\ntagIndex:\(tagIndex)"
        
        UIAlertView(title:nil, message:message, delegate:nil, cancelButtonTitle:"OK").show()
        
        
    }
    
    @objc func handleSectionViewTap(sender:UIView!)
    {
        let  partIndex = sender.tag / 1000;
        let  sectionIndex = sender.tag % 1000;
        let message = "You have select:\npartIndex:\(partIndex)\nsectionIndex:\(sectionIndex)"
        
        UIAlertView(title:nil, message:message, delegate:nil, cancelButtonTitle:"OK").show()
        
    }
    
    @objc func handleStyleChange(sender:UIButton!)
    {
        self.contentLayout.subviews.forEach {$0.removeFromSuperview()}
        
        if sender.tag == 100
        {
            sender.isSelected = true
            (sender.superview!.viewWithTag(101) as? UIButton)?.isSelected = false
            self.style1Layout(self.contentLayout)
        }
        else
        {
            sender.isSelected = true
            (sender.superview!.viewWithTag(100) as? UIButton)?.isSelected = false
            self.style2Layout(self.contentLayout)
        }
        
    }

}

