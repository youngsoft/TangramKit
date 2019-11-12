//
//  FOLTest2ViewController.swift
//  TangramKit
//
//  Created by apple on 16/5/8.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



//布局模型类,用于实现不同的布局展示风格
struct FOLTest2LayoutTemplate
{
    var layoutSelector:Selector  //布局实现的方法
    var width:CGFloat   //布局宽度，如果设置的值<=1则是相对宽度
    var height:CGFloat  //布局高度，如果设置的值<=1则是相对高度
}


//数据模型。
@objcMembers
class FOLTest2DataModel : NSObject
{
    
    @objc var title:String!  //标题
    @objc var subTitle:String!  //副标题
    @objc var desc:String!      //描述
    @objc var price:String!     //价格
    @objc var image:String!      //图片
    @objc var subImage:String!   //子图片
    @objc var templateIndex = 0  //数据模型使用布局的索引。通常由服务端决定使用的布局模型，所以这里作为一个属性保存在模型数据结构中。
}

//数据片段模型
@objcMembers
class FOLTest2SectionModel:NSObject
{
    var title:String!
    var datas:[FOLTest2DataModel]!
}


/**
 *2.FloatLayout - Jagged
 */
class FOLTest2ViewController: UIViewController {
    
    weak var rootLayout:TGLinearLayout!
    
    static var sItemLayoutHeight = 90.0
    static var sBaseTag = 100000
    
    lazy var layoutTemplates:[FOLTest2LayoutTemplate]={  //所有的布局模板数组
       
        let templateSources:[[String:Any]] = [
                [
                    "selector":#selector(createItemLayout1_1),
                    "width":CGFloat(0.5),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight*2)
                    ],
                [
                    "selector":#selector(createItemLayout1_2),
                    "width":CGFloat(0.5),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight),
                    ],
                [
                    "selector":#selector(createItemLayout1_3),
                    "width":CGFloat(0.5),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight),
                    ],
                [
                    "selector":#selector(createItemLayout2_1),
                    "width":CGFloat(0.5),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight * 2),
                    ],
                [
                    "selector":#selector(createItemLayout2_1),
                    "width":CGFloat(0.25),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight * 2),
                    ],
                [
                    "selector":#selector(createItemLayout2_1),
                    "width":CGFloat(1.0),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight),
                    ],
                [
                    "selector":#selector(createItemLayout3_1),
                    "width":CGFloat(0.4),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight * 2),
                    ],
                [
                    "selector":#selector(createItemLayout3_2),
                    "width":CGFloat(0.6),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight),
                    ],
                [
                    "selector":#selector(createItemLayout3_2),
                    "width":CGFloat(0.4),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight),
                    ],
                [
                    "selector":#selector(createItemLayout4_1),
                    "width":CGFloat(0.5),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight),
                    ],
                [
                    "selector":#selector(createItemLayout4_2),
                    "width":CGFloat(0.25),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight + 20),
                    ],
                [
                    "selector":#selector(createItemLayout5_1),
                    "width":CGFloat(0.25),
                    "height":CGFloat(FOLTest2ViewController.sItemLayoutHeight + 20),
                    ]
        ]
        
        
        var _layoutTemplates = [FOLTest2LayoutTemplate]()
        for dict in templateSources
        {
            
            let template = FOLTest2LayoutTemplate(layoutSelector:dict["selector"] as! Selector,
                                                  width:CGFloat(dict["width"] as! CGFloat),
                                                  height:dict["height"] as! CGFloat)
            _layoutTemplates.append(template)
        }
        
        return _layoutTemplates;
        
    }()
   
    lazy var sectionDatas:[FOLTest2SectionModel] = {  //片段数据数组，FOLTest2SectionModel类型的元素。
        
        let file:String! =  Bundle.main.path(forResource: "FOLTest2DataModel",ofType:"plist")
        let dataSources =   NSArray(contentsOfFile: file) as! [[String:AnyObject]]
        
        var _sectionDatas = [FOLTest2SectionModel]()
        for sectionDict:[String:AnyObject] in dataSources
        {
            let sectionModel = FOLTest2SectionModel()
            sectionModel.title = sectionDict["title"] as? String
            sectionModel.datas = [FOLTest2DataModel]()
            
            let dicts = sectionDict["datas"] as! [[String:AnyObject]]
            for dict in dicts
            {
                let model = FOLTest2DataModel()
                for (key,val) in dict
                {
                    model.setValue(val, forKey:key)
                }
             
                sectionModel.datas.append(model);
            }
            
            _sectionDatas.append(sectionModel)
            
        }
        
        return _sectionDatas
        
    }()
    
    
    override func loadView() {

        let scrollView = UIScrollView()
        self.view = scrollView;

        let rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_gravity = TGGravity.horz.fill
        rootLayout.backgroundColor =  UIColor(white:0xe7/255.0, alpha:1)
        rootLayout.tg_intelligentBorderline =  TGBorderline(color: .lightGray) //设置智能边界线，布局里面的子视图会根据布局自动产生边界线。
        scrollView.addSubview(rootLayout)
        self.rootLayout = rootLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

      
        for i in 0 ..< self.sectionDatas.count
        {
            self.addSectionLayout(sectionIndex: i)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Layout Construction
extension FOLTest2ViewController
{
    //添加片段布局
    func addSectionLayout(sectionIndex:Int)
    {
        
        let sectionModel = self.sectionDatas[sectionIndex]
        
        
        //如果有标题则创建标题文本
        if sectionModel.title != nil
        {
            let  sectionTitleLabel = UILabel()
            sectionTitleLabel.text = sectionModel.title;
            sectionTitleLabel.font =  .boldSystemFont(ofSize: 15)
            sectionTitleLabel.backgroundColor = .white
            sectionTitleLabel.tg_height.equal(30)
            sectionTitleLabel.tg_top.equal(10)
            self.rootLayout.addSubview(sectionTitleLabel)
        }
        
        //创建条目容器布局。
        let itemContainerLayout = TGFloatLayout(.vert)
        itemContainerLayout.backgroundColor = .white
        itemContainerLayout.tg_height.equal(.wrap)
        itemContainerLayout.tg_intelligentBorderline = TGBorderline(color: .lightGray)
        self.rootLayout.addSubview(itemContainerLayout)
        
        //创建条目布局，并加入到容器布局中去。
        for i in 0 ..< sectionModel.datas.count
        {
            let model = sectionModel.datas[i];
            
            let  layoutTemplate = self.layoutTemplates[model.templateIndex];  //取出数据模型对应的布局模板对象。
            
            
            //布局模型对象的layoutSelector负责建立布局，并返回一个布局条目布局视图。
            
            let itemLayout = self.perform(layoutTemplate.layoutSelector,with:model).takeUnretainedValue() as! TGBaseLayout
            
            itemLayout.tag = sectionIndex * FOLTest2ViewController.sBaseTag + i;
            itemLayout.tg_setTarget(self,action:#selector(handleItemLayoutTap), for:.touchUpInside)
            itemLayout.tg_highlightedOpacity = 0.4
            
            
            //根据上面布局模型对高度和宽度的定义指定条目布局的尺寸。如果小于等于1则用相对尺寸，否则用绝对尺寸。
            if layoutTemplate.width <= 1
            {
                itemLayout.tg_width.equal(itemContainerLayout.tg_width, multiple:layoutTemplate.width)
                
            }
            else
            {
                itemLayout.tg_width.equal(layoutTemplate.width)
                
            }
            
            
            if layoutTemplate.height <= 1
            {
                
                itemLayout.tg_height.equal(itemContainerLayout.tg_height, multiple:layoutTemplate.height)
                
            }
            else
            {
                itemLayout.tg_height.equal(layoutTemplate.height)
            }
            
            itemContainerLayout.addSubview(itemLayout)
        }
        
        
    }

    
    
    //品牌特卖主条目布局,这是一个从上到下的布局,因此可以用上下浮动来实现。
    @objc func createItemLayout1_1(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        /*
         这个例子是为了重点演示浮动布局，所以里面的所有条目布局都用了浮动布局。您也可以使用其他布局来建立您的条目布局。
         */
        
        //建立上下浮动布局
        let itemLayout = TGFloatLayout(.horz)
        
        //向上浮动，左边顶部边距为5
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)
        
        //向上浮动，左边顶部边距为5，高度为20
        let subImageView = UIImageView(image:UIImage(named:dataModel.subImage))
        subImageView.tg_leading.equal(5)
        subImageView.tg_top.equal(5)
        subImageView.tg_height.equal(20)
        subImageView.sizeToFit()
        itemLayout.addSubview(subImageView)
        
        
        //向上浮动，高度占用剩余的高度，宽度和父布局保持一致。
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_height.equal(.fill)
        imageView.tg_width.equal(itemLayout.tg_width)
        itemLayout.addSubview(imageView)
        
        return itemLayout;
    }
    
    //天猫超时条目布局，这是一个整体左右结构，因此用左右浮动布局来实现。
    @objc func createItemLayout1_2(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        //建立左右浮动布局
        let itemLayout = TGFloatLayout(.vert)
        
        //向左浮动，宽度和父视图宽度保持一致，顶部和左边距为5
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.tg_width.equal(itemLayout.tg_width)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)

        //向左浮动，因为上面占据了全部宽度，这里会自动换行显示并且也是全宽。
        let subTitleLabel = UILabel()
        subTitleLabel.text = dataModel.subTitle;
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.textColor = .lightGray
        subTitleLabel.tg_width.equal(itemLayout.tg_width)
        subTitleLabel.tg_leading.equal(5)
        subTitleLabel.sizeToFit()
        itemLayout.addSubview(subTitleLabel)
        
        //图片向右浮动，并且右边距为5，上面因为占据了全宽，因此这里会另起一行向右浮动。
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_reverseFloat = true
        imageView.tg_trailing.equal(5)
        imageView.sizeToFit()
        itemLayout.addSubview(imageView)
        
        return itemLayout;
        
    }
    
    //建立品牌特卖的其他条目布局，这种布局整体是左右结构，因此建立左右浮动布局。
    @objc func createItemLayout1_3(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        let itemLayout = TGFloatLayout(.vert)
        
        //因为图片要占据全高，所以必须优先向右浮动。
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_height.equal(itemLayout.tg_height)
        imageView.tg_reverseFloat = true;
        imageView.sizeToFit()
        itemLayout.addSubview(imageView)
        
        //向左浮动，并占据剩余的宽度，边距为5
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.tg_width.equal(.fill)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)
        
        //向左浮动，直接另起一行，占据剩余宽度，内容高度动态。
        let subTitleLabel = UILabel()
        subTitleLabel.text = dataModel.subTitle;
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.textColor = UIColor.lightGray;
        subTitleLabel.tg_leading.equal(5)
        subTitleLabel.tg_clearFloat = true;
        subTitleLabel.tg_width.equal(.fill)
        subTitleLabel.tg_height.equal(.wrap)
        itemLayout.addSubview(subTitleLabel)
        
        //如果有小图片则图片另起一行，向左浮动。
        if (dataModel.subImage != nil)
        {
            let subImageView = UIImageView(image:UIImage(named:dataModel.subImage))
            subImageView.tg_clearFloat = true;
            subImageView.tg_leading.equal(5)
            subImageView.sizeToFit()
            itemLayout.addSubview(subImageView)
        }
        
        
        return itemLayout;
    }
    
    //建立超级品牌日布局，这里因为就只有一张图，所以设置布局的背景图片即可。
    @objc func createItemLayout2_1(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        let itemLayout = TGFloatLayout(.vert)
        //直接设置背景图片。
        itemLayout.tg_backgroundImage = UIImage(named:dataModel.image)
        
        return itemLayout;
    }
    
    
    //精选市场主条目布局，这个布局整体从上到下因此用上下浮动布局建立。
    @objc func createItemLayout3_1(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        let itemLayout = TGFloatLayout(.horz)
        
        //向上浮动
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)

        //继续向上浮动。
        let subTitleLabel = UILabel()
        subTitleLabel.text = dataModel.title;
        subTitleLabel.font = UIFont.systemFont(ofSize: 11)
        subTitleLabel.tg_leading.equal(5)
        subTitleLabel.tg_top.equal(5)
        subTitleLabel.sizeToFit()
        itemLayout.addSubview(subTitleLabel)
        
        //价格部分在底部，因此改为向下浮动。
        let priceLabel = UILabel()
        priceLabel.text = dataModel.price;
        priceLabel.font = UIFont.systemFont(ofSize: 11)
        priceLabel.textColor = UIColor.red
        priceLabel.tg_leading.equal(5)
        priceLabel.tg_bottom.equal(5)
        priceLabel.tg_reverseFloat = true
        priceLabel.sizeToFit()
        itemLayout.addSubview(priceLabel)
        
        //描述部分在价格的上面，因此改为向下浮动。
        let descLabel = UILabel()
        descLabel.text = dataModel.desc;
        descLabel.font = UIFont.systemFont(ofSize: 11)
        descLabel.textColor = UIColor.lightGray
        descLabel.tg_leading.equal(5)
        descLabel.tg_reverseFloat = true
        descLabel.sizeToFit()
        itemLayout.addSubview(descLabel)
        
        //向上浮动，并占用剩余的空间高度。
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_width.equal(itemLayout.tg_width);
        imageView.tg_height.equal(100%)
        itemLayout.addSubview(imageView)
        
        return itemLayout;
    }
    
    //建立精选市场其他条目布局，这个布局整体还是从上到下，因此用上下浮动布局
    @objc func createItemLayout3_2(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        let itemLayout = TGFloatLayout(.horz)
        
        //向上浮动
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.tg_width.equal(itemLayout.tg_width,increment:-2.5, multiple:0.5)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)
        
        //继续向上浮动
        let subTitleLabel = UILabel()
        subTitleLabel.text = dataModel.subTitle;
        subTitleLabel.font = UIFont.systemFont(ofSize: 11)
        subTitleLabel.tg_leading.equal(5)
        subTitleLabel.tg_top.equal(5)
        subTitleLabel.tg_width.equal(itemLayout.tg_width,increment:-2.5,multiple:0.5)
        subTitleLabel.sizeToFit()
        itemLayout.addSubview(subTitleLabel)
        
        //价格向下浮动
        let priceLabel = UILabel()
        priceLabel.text = dataModel.price;
        priceLabel.font = UIFont.systemFont(ofSize: 11)
        priceLabel.textColor = UIColor.red
        priceLabel.tg_leading.equal(5)
        priceLabel.tg_bottom.equal(5)
        priceLabel.tg_reverseFloat = true
        priceLabel.tg_width.equal(itemLayout.tg_width,increment:-2.5,multiple:0.5)
        priceLabel.sizeToFit()
        itemLayout.addSubview(priceLabel)
        
        //描述向下浮动
        let descLabel = UILabel()
        descLabel.text = dataModel.desc;
        descLabel.font = UIFont.systemFont(ofSize: 11)
        descLabel.textColor = UIColor.lightGray
        descLabel.tg_leading.equal(5)
        descLabel.tg_reverseFloat = true
        descLabel.tg_width.equal(itemLayout.tg_width,increment:-2.5,multiple:0.5)
        descLabel.sizeToFit()
        itemLayout.addSubview(descLabel)
        
        //向上浮动，因为宽度无法再容纳，所以这里会换列继续向上浮动。
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_width.equal(itemLayout.tg_width,increment:-2.5,multiple:0.5)
        imageView.tg_height.equal(itemLayout.tg_height);
        itemLayout.addSubview(imageView)
        
        
        
        return itemLayout;
    }
    
    //热门市场主条目布局，这个结构可以用上下浮动布局也可以用左右浮动布局。
    @objc func createItemLayout4_1(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        let itemLayout = TGFloatLayout(.horz)
        
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.tg_width.equal(itemLayout.tg_width,increment:-2.5,multiple:0.5)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)

        
        let subTitleLabel = UILabel()
        subTitleLabel.text = dataModel.subTitle;
        subTitleLabel.font = UIFont.systemFont(ofSize: 11)
        subTitleLabel.tg_leading.equal(5)
        subTitleLabel.tg_top.equal(5)
        subTitleLabel.tg_width.equal(itemLayout.tg_width,increment:-2.5,multiple:0.5)
        subTitleLabel.sizeToFit()
        itemLayout.addSubview(subTitleLabel)
        
        //继续向上浮动，这里因为高度和父布局高度一致，因此会换列浮动。
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_width.equal(itemLayout.tg_width,increment:-2.5,multiple:0.5)
        imageView.tg_height.equal(itemLayout.tg_height);
        itemLayout.addSubview(imageView)
        
        return itemLayout;
    }
    
    //热门市场其他条目布局，这个整体是上下布局，因此用上下浮动布局。
    @objc func createItemLayout4_2(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        let itemLayout = TGFloatLayout(.horz)
        
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = dataModel.subTitle;
        subTitleLabel.font = UIFont.systemFont(ofSize: 11)
        subTitleLabel.tg_leading.equal(5)
        subTitleLabel.tg_top.equal(5)
        subTitleLabel.sizeToFit()
        itemLayout.addSubview(subTitleLabel)
        
        //继续向上浮动，占据剩余高度。
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_width.equal(itemLayout.tg_width)
        imageView.tg_height.equal(100%)
        itemLayout.addSubview(imageView)
        
        return itemLayout;
    }
    
    
    
    //主题市场条目布局，这个整体就是上下浮动布局
    @objc func createItemLayout5_1(_ dataModel:FOLTest2DataModel) ->TGFloatLayout
    {
        let itemLayout = TGFloatLayout(.horz)
        
        let titleLabel = UILabel()
        titleLabel.text = dataModel.title;
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.tg_leading.equal(5)
        titleLabel.tg_top.equal(5)
        titleLabel.sizeToFit()
        itemLayout.addSubview(titleLabel)

        
        let subTitleLabel = UILabel()
        subTitleLabel.text = dataModel.subTitle;
        subTitleLabel.font = UIFont.systemFont(ofSize: 11)
        subTitleLabel.textColor = UIColor.red
        subTitleLabel.tg_leading.equal(5)
        subTitleLabel.tg_top.equal(5)
        subTitleLabel.sizeToFit()
        itemLayout.addSubview(subTitleLabel)

        
        let imageView = UIImageView(image:UIImage(named:dataModel.image))
        imageView.tg_width.equal(itemLayout.tg_width)
        imageView.tg_height.equal(100%)   //图片占用剩余的全部高度
        itemLayout.addSubview(imageView)
        
        return itemLayout;
    }

}

//MARK: Handle Method
extension FOLTest2ViewController
{
    
    @objc func handleItemLayoutTap(sender:UIView!)
    {
        let  sectionIndex = sender.tag / FOLTest2ViewController.sBaseTag;
        let  itemIndex = sender.tag % FOLTest2ViewController.sBaseTag;
        let message = "You have select\nSectionIndex:\(sectionIndex) ItemIndex:\(itemIndex)"
        
        UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        
    }
    

    
}
