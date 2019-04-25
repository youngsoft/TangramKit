//
//  AllTest4ViewController.swift
//  TangramKit
//
//  Created by yant on 22/7/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



private let sBaseTag:NSInteger = 100000

/**
 *  4.Replacement of UICollectionView
 */
class AllTest4ViewController: UIViewController {

    var rootLayout : TGLinearLayout!
    var containerLayouts : [TGFlowLayout]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = CFTool.color(0)
        
        var sections:[String] = ["品牌推荐",
                                 "时尚风格",
                                 "特价处理",
                                 "这是一段很长很长很长很长很长很长很长很长很长很长很长很长的文字"
                                ]
        
        var images:[String] = ["p1-11",
                               "p1-12",
                               "p1-21",
                               "p1-31",
                               "p1-32",
                               "p1-33",
                               "p1-34",
                               "p1-35",
                               "p1-36",
                               "image1",
                               "image2",
                               "image3"
                                ]
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight] //让uiscrollView的尺寸总是保持和父视图一致。
        self.view.addSubview(scrollView)
        
        
        rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_gravity = TGGravity.horz.fill //设置垂直线性布局的水平填充值表明布局视图里面的所有子视图的宽度都和布局视图相等。
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        scrollView.addSubview(rootLayout)
        
        
        self.containerLayouts = [TGFlowLayout]()
        for index in 0..<sections.count {
            //添加辅助视图
            rootLayout.addSubview(self.createSupplementaryLayout(sectionTitle: sections[index]))

            //添加单元格容器视图
            let cellContainerLayout = self.createCellContainerLayout(arrangedCount: index + 2)
            cellContainerLayout.tg_bottom.equal(10)
            self.containerLayouts.append(cellContainerLayout)
            rootLayout.addSubview(cellContainerLayout)
            
            //添加单元格视图
            let cellCount = arc4random_uniform(8) + 8 //随机数量，最少8个最多16个
            for index2 in 0..<cellCount
            {
                let cellLayout = self.createCellLayout1(image: images[(NSInteger)(arc4random_uniform((UInt32)(images.count)))], title:String.init(format: NSLocalizedString("cell title:%03ld",comment: ""), index2))
                cellLayout.tag = (sBaseTag * index) + (NSInteger)(index2) //用于确定所在的辅助编号和单元格编号。
                
                cellContainerLayout.addSubview(cellLayout)
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Reverse",style:UIBarButtonItem.Style.done, target:self, action:#selector(AllTest4ViewController.handleReverse(_:)));
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Layout Construction
extension AllTest4ViewController
{
    //创建辅助布局视图
    func createSupplementaryLayout(sectionTitle: String) -> TGRelativeLayout {
        //建立一个相对布局
        let supplementaryLayout = TGRelativeLayout()
        supplementaryLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        supplementaryLayout.tg_height.equal(40)
        supplementaryLayout.tg_boundBorderline = TGBorderline(color: UIColor.lightGray) //设置底部边界线。
        supplementaryLayout.backgroundColor = UIColor.white
        
        let imageView = UIImageView(image:UIImage(named:"next"))
        imageView.tg_centerY.equal(supplementaryLayout.tg_centerY)  //垂直居中
        imageView.tg_trailing.equal(supplementaryLayout.tg_trailing)     //和父视图右对齐。
        supplementaryLayout.addSubview(imageView);
        
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.text = sectionTitle
        sectionTitleLabel.adjustsFontSizeToFitWidth = true
        sectionTitleLabel.textColor = CFTool.color(4)
        sectionTitleLabel.font = CFTool.font(17)
        sectionTitleLabel.minimumScaleFactor = 0.7
        sectionTitleLabel.lineBreakMode = .byTruncatingMiddle
        sectionTitleLabel.tg_centerY.equal(supplementaryLayout.tg_centerY)  //垂直居中
        sectionTitleLabel.tg_leading.equal(supplementaryLayout.tg_leading)       //左边和父视图左对齐
        sectionTitleLabel.tg_trailing.equal(imageView.tg_trailing)                //右边是图标的左边。
        sectionTitleLabel.sizeToFit()
        supplementaryLayout.addSubview(sectionTitleLabel)
        
        return supplementaryLayout
    }
    
    //创建单元格容器布局视图，并指定每行的数量。
    func createCellContainerLayout(arrangedCount:NSInteger) -> TGFlowLayout
    {
        let containerLayout = TGFlowLayout(.vert, arrangedCount:arrangedCount)
        containerLayout.tg_height.equal(.wrap)
        containerLayout.tg_gravity = TGGravity.horz.fill //平均分配里面每个子视图的宽度或者拉伸子视图的宽度以便填充满整个布局。
        containerLayout.tg_hspace = 5
        containerLayout.tg_vspace = 5
        containerLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
        return containerLayout
    }
    
    func createCellLayout1(image:String, title:String) -> TGBaseLayout
    {
        let cellLayout = TGLinearLayout(.vert)
        cellLayout.tg_gravity = TGGravity.horz.fill  //里面所有子视图的宽度都跟父视图保持一致，这样子视图就不需要设置宽度了。
        cellLayout.tg_height.equal(100)
        cellLayout.tg_space = 5  //设置布局视图里面子视图之间的间距为5个点。
        cellLayout.backgroundColor = UIColor.white
        cellLayout.tg_setTarget(self, action:#selector(handleCellLayoutTap(_:)), for:.touchUpInside)
        cellLayout.tg_highlightedOpacity = 0.3; //设置触摸事件按下时的不透明度，来响应按下状态。
        
        
        
        let imageView = UIImageView(image:UIImage(named:image))
        imageView.tg_height.equal(100%)   //图片视图占用剩余的高度。
        cellLayout.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = CFTool.font(14)
        titleLabel.textColor = CFTool.color(4)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.tg_bottom.equal(2)
        titleLabel.sizeToFit()
        cellLayout.addSubview(titleLabel)
        
        return cellLayout
    }

}

//MARK: - Handle Method
extension AllTest4ViewController
{
    @objc func handleReverse(_ sender:UIView) -> Void {
        //TGBaseLayout的属性tg_reverseLayout可以将子视图按照添加的顺序逆序布局。
        for layout in self.containerLayouts
        {
            layout.tg_reverseLayout = !layout.tg_reverseLayout
            layout.tg_layoutAnimationWithDuration(0.3)
        }

    }
    
    
    func showClickAlert(_ sender:UIView)
    {
        let supplementaryIndex = sender.tag / sBaseTag
        let cellIndex = sender.tag % sBaseTag
        
        let message = String(format:"You have select:\nSupplementaryIndex:%ld CellIndex:%ld",supplementaryIndex, cellIndex)
        
        let alertView = UIAlertView(title:"", message:message, delegate:nil ,cancelButtonTitle:"OK")
        
        alertView.show()
    }
    
    func exchangeSubview(_ sender:UIView, from fromLayout:TGBaseLayout, to toLayout:TGBaseLayout)
    {
        //往下移动时，有可能会上面缩小而下面整体往上移动,结束位置不正确。 也就是移动的视图开始位置正确，结束位置不正确。
        //往上移动时，有可能会上面撑大而下面整体往下移动,开始位置不正确。 也就是移动的视图开始位置不正确，结束位置正确。
        //因此为了解决这个问题，我们在删除子视图时不让布局视图进行布局，这可以通过设置布局视图的autoresizesSubviews为NO。
        
        
        //得到当前的sender在self.view中的frame，这里进行坐标的转换。
        let rectOld = fromLayout.convert(sender.frame, to: self.view)
        
        //得到将sender加入到toLayout后的评估的frame值，注意这时候sender还没有加入到toLayout。因为是加入到最后面，因此只能用这个方法来评估加入后的值，如果不是添加到最后则是可以很简单的得到应该插入的位置的。
        var rectNew = toLayout.tg_estimatedFrame(of: sender)
        rectNew = toLayout.convert(rectNew, to: self.view) //将新位置的评估的frame值，进行坐标转换。
        
        //在动画的过程中，我们将sender作为self.view的子视图来实现移动的效果。
        fromLayout.autoresizesSubviews = false
        sender.removeFromSuperview()
        sender.frame = rectOld
        sender.tg_useFrame = true  //设置为true表示sender不再受到布局视图的约束，而是可以自由设置frame值。
        self.view.addSubview(sender)
        
        UIView.animate(withDuration: 0.3, animations: { 
            sender.frame = rectNew
        }) { _ in
            
            //恢复重新布局。
            fromLayout.autoresizesSubviews = true
            fromLayout.setNeedsLayout()
            
            //动画结束后再将sender移植到toLayout中。
            sender.removeFromSuperview()
            sender.tg_useFrame = false  //还原tg_useFrame，因为加入到toLayout后将受到布局视图的约束。
            toLayout.addSubview(sender)
        }
        
    }
    
    @objc func handleCellLayoutTap(_ sender:UIView) -> Void {
        
        //这里是为了节省，所以将两个不同的功能放在一起。。。
        
        let superFlowLayout = sender.superview as! TGFlowLayout
        
        //第一个和第二个里面的子视图点击后弹出当前点击的cell的提示信息。
        if (superFlowLayout == self.containerLayouts[0] || superFlowLayout == self.containerLayouts[1])
        {
            self.showClickAlert(sender)
        }
        else
        {
            //第三个第四个里面的子视图点击后进行互相移动的场景。
            let flowLayout2 = self.containerLayouts[2]
            let flowLayout3 = self.containerLayouts[3]
            if (superFlowLayout == flowLayout2)
            {
                self.exchangeSubview(sender,from:flowLayout2,to:flowLayout3)
            }
            else
            {
                self.exchangeSubview(sender,from:flowLayout3,to:flowLayout2)
            }
        }
        
        
    }
    
}


