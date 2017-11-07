//
//  FOLTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit




class FOLTest3DataModel : NSObject
{
    var imageName:String!
    var title:String!
    var source:String!
}


/**
 *3.FloatLayout - Card news
 */
class FOLTest3ViewController: UIViewController {
    
    weak var floatLayout:TGFloatLayout!
    
    lazy var datas:[FOLTest3DataModel] = {
        
        let dataSource = [
            ["imageName":"p1","title":"广西鱼塘现大坑 一夜”吃掉“五万斤鱼"],
            ["title":"习近平发展中国经济两个大局观","source":"专题"],
            ["title":"习近平抵达不拉格开始对捷克国事访问","source":"专题"],
            ["title":"解读：为何数万在缅汉族要入籍缅族","source":"海外网"],
            ["title":"消费贷仍可用于首付银行：不可能杜绝","source":"新闻晨报"],
            ["title":"3代人接力29年养保姆至108岁","source":"人民日报"]
        ]
        
        var _datas = [FOLTest3DataModel]()
        for dict:[String:String] in dataSource
        {
            let model = FOLTest3DataModel()
            
            for (key,val) in dict
            {
                model.setValue(val, forKey: key)
            }
            
            _datas.append(model)
            
        }
        
        return _datas
    }()
    
    override func viewDidLoad() {
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        
        super.viewDidLoad()
        
        let floatLayout = TGFloatLayout(.vert)
        floatLayout.backgroundColor = .white
        floatLayout.tg_margin(TGLayoutPos.tg_safeAreaMargin) ////浮动布局和父视图四周的边界是安全区，也就是说浮动布局的宽度和高度和父视图的安全区相等。 您可以将tg_margin设置为0并在iPhoneX上看看效果和区别。
        //通过智能分界线的使用，浮动布局里面的所有子布局视图的分割线都会进行智能的设置，从而解决了我们需求中需要提供边界线的问题。
        floatLayout.tg_intelligentBorderline = TGBorderline(color: UIColor.lightGray.withAlphaComponent(0.2))
        self.view.addSubview(floatLayout)
        self.floatLayout = floatLayout
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:NSLocalizedString("change style", comment:""), style: .plain, target: self, action: #selector(handleChangeStyle))
        
        self.handleChangeStyle(nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Layout Construction
extension FOLTest3ViewController
{
    //创建宽度和父布局宽度相等且具有图片新闻的浮动布局
    func createPictureNewsItemLayout(_ dataModel:FOLTest3DataModel, tag:Int) ->TGBaseLayout
    {
        //创建一个左右浮动布局。这个DEMO是为了介绍浮动布局,在实践中你可以用其他布局来创建条目布局
        let itemLayout = TGFloatLayout(.vert)
        itemLayout.tag = tag
        itemLayout.tg_setTarget(self, action: #selector(handleItemLayoutClick), for:.touchUpInside)  //这里可以设置布局的点击事件
        itemLayout.tg_highlightedBackgroundColor = .lightGray
        itemLayout.tg_backgroundImage = UIImage(named: dataModel.imageName) //将图片作为布局的背景图片
        itemLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10);
        itemLayout.tg_gravity = TGGravity.vert.bottom //将整个布局中的所有子视图垂直居底部。
        itemLayout.tg_height.equal(self.floatLayout.tg_height,multiple:2.0/5)  //布局的高度是父布局的2/5。
        itemLayout.tg_width.equal(self.floatLayout.tg_width); //布局的宽度和父布局相等。
        
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.textColor = .white
        titleLabel.tg_height.equal(.wrap)
        titleLabel.tg_width.equal(.fill)
        itemLayout.addSubview(titleLabel)
        
        return itemLayout;
    }
    
    //创建宽度和父布局宽度相等只有文字新闻的浮动布局
    func createWholeWidthTextNewsItemLayout(_ dataModel:FOLTest3DataModel, tag:Int) ->TGBaseLayout
    {
        //里面每个元素可以是各种布局，这里为了突出浮动布局，因此条目布局也做成了浮动布局。
        let itemLayout = TGFloatLayout(.vert)
        itemLayout.tag = tag
        itemLayout.tg_setTarget(self, action: #selector(handleItemLayoutClick), for:.touchUpInside)
        itemLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10);
        itemLayout.tg_highlightedBackgroundColor = .lightGray
        itemLayout.tg_gravity = TGGravity.vert.center //将整个布局中的所有子视图整体垂直居中。
        itemLayout.tg_height.equal(self.floatLayout.tg_height,multiple:1.0/5)  //布局高度是父布局的1/5
        itemLayout.tg_width.equal(self.floatLayout.tg_width)  //布局宽度和父布局相等。
        
        //标题文本部分
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.tg_height.equal(.wrap)
        titleLabel.tg_width.equal(.fill)
        itemLayout.addSubview(titleLabel)
        
        //来源部分
        let sourceLabel = UILabel()
        sourceLabel.text = dataModel.source;
        sourceLabel.font = UIFont.systemFont(ofSize: 11)
        sourceLabel.textColor = UIColor.lightGray
        sourceLabel.sizeToFit()
        sourceLabel.tg_clearFloat = true; //换行
        sourceLabel.tg_top.equal(5)
        itemLayout.addSubview(sourceLabel)
        
        
        return itemLayout;
        
    }
    
    //创建宽度是父布局宽度一半的只有文字新闻的浮动布局
    func createHalfWidthTextNewsItemLayout(_ dataModel:FOLTest3DataModel,tag:Int) ->TGBaseLayout
    {
        //里面每个元素可以是各种布局，这里为了突出浮动布局，因此条目布局也做成了浮动布局。
        let itemLayout = TGFloatLayout(.vert)
        itemLayout.tag = tag
        itemLayout.tg_setTarget(self, action: #selector(handleItemLayoutClick), for:.touchUpInside)
        itemLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10);
        itemLayout.tg_highlightedBackgroundColor = .lightGray
        itemLayout.tg_gravity = TGGravity.vert.center  ////将整个布局中的所有子视图整体垂直居中。
        itemLayout.tg_height.equal(self.floatLayout.tg_height,multiple:1.0/5)
        itemLayout.tg_width.equal(self.floatLayout.tg_width,multiple:0.5)
        
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.tg_height.equal(.wrap)
        titleLabel.tg_width.equal(.fill)
        itemLayout.addSubview(titleLabel)
        
        let sourceLabel = UILabel()
        sourceLabel.text = dataModel.source;
        sourceLabel.font = UIFont.systemFont(ofSize: 11)
        sourceLabel.textColor = UIColor.lightGray
        sourceLabel.sizeToFit()
        sourceLabel.tg_clearFloat = true;
        sourceLabel.tg_top.equal(5)
        itemLayout.addSubview(sourceLabel)
        
        
        return itemLayout;
        
    }
    
}

//MARK: Handle Method
extension FOLTest3ViewController
{
    
    
    @objc func handleChangeStyle(_ sender:AnyObject!)
    {
        
        //zaker的每页新闻中都有6条新闻，其中一条图片新闻和5条文字新闻。在布局上则高度分为5份，其中的图片新闻则占据了2/5，而高度则是全屏。
        //其他的5条新闻则分为3行来均分剩余的高度，而宽度则是有4条是屏幕宽度的一半，一条是全部屏幕的宽度。然后zaker通过配置好的模板来展示每个
        //不同的页，我们的例子为了展现效果。我们将随机产生4条半屏和1条全屏文字新闻和一张图片新闻。
        
        //6条新闻中，我们有有一条图片新闻的宽度和屏幕宽度一致，高度是屏幕高度的2/5。 有一条新闻的宽度和屏幕宽度一致，高度为屏幕高度的1/5。另外四条新闻
        //的宽度是屏幕宽度的一半，高度是屏幕高度的1/5。
        //我们将宽度为全屏宽度的文字新闻定义为1，而将半屏宽度的文字新闻视图定义为2，而将图片新闻的视图定义为3 这样就会形成1322,3122,1232,3212,1223,3221,2123,2321, 2132,2312, 2213,2231 一共12种布局
        //这样我们可以随机选取一种布局方式
        
        //所有可能的布局数组。
        let layoutStyless:[[Int]] = [
            [1,3,2,2],
            [3,1,2,2],
            [1,2,3,2],
            [3,2,1,2],
            [1,2,2,3],
            [3,2,2,1],
            [2,1,2,3],
            [2,3,2,1],
            [2,1,3,2],
            [2,3,1,2],
            [2,2,1,3],
            [2,2,3,1]]
        
        
        
        //随机取得一个布局。
        let pLayoutStyles:[Int] = layoutStyless[Int(arc4random_uniform(12))]
        
        
        while (self.floatLayout.subviews.count > 0) {
            self.floatLayout.subviews.last!.removeFromSuperview()
        }
        
        var index:Int = 1;
        for i in 0 ..< 4
        {
            let layoutStyle = pLayoutStyles[i];
            
            if (layoutStyle == 1)  //全部宽度文字新闻布局
            {
                self.floatLayout.addSubview(self.createWholeWidthTextNewsItemLayout(self.datas[index],tag:index))
                index += 1;
            }
            else if (layoutStyle == 3)  //图片新闻布局
            {
                self.floatLayout.addSubview(self.createPictureNewsItemLayout(self.datas[0],tag:0))
            }
            else   //半宽文字新闻布局
            {
                self.floatLayout.addSubview(self.createHalfWidthTextNewsItemLayout(self.datas[index],tag:index))
                index += 1;
                self.floatLayout.addSubview(self.createHalfWidthTextNewsItemLayout(self.datas[index],tag:index))
                index += 1;
            }
        }
    }
    
    
    @objc func handleItemLayoutClick(_ sender:UIView!)
    {
        let message = "You click:\(sender.tag)"
        UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
}

