//
//  TLTest2ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



class TLTest2ViewController: UIViewController {

    weak var rootLayout:TGTableLayout!
    
    var sTag:Int = 1000

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("add cell", comment:""), style: .plain, target: self, action: #selector(handleAddColLayout))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func loadView() {
        
        super.loadView()
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = CFTool.color(5)
        self.view.addSubview(scrollView)
        
        /*
         创建一个水平的表格布局，水平表格布局主要用于建立瀑布流视图。需要注意的是水平表格中row也就是行是从左到右排列的，而每行中的col也就是列是从上到下排列的。
         */
        
        let rootLayout = TGTableLayout(.horz)
        rootLayout.tg_hspace = 5
        rootLayout.tg_vspace = 10  //指定表格中的行间距和列间距。
        rootLayout.tg_padding = UIEdgeInsetsMake(5, 5, 5, 5)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        scrollView.addSubview(rootLayout)
        self.rootLayout = rootLayout

        //为瀑布流建立3个平均分配的行，每行的列的尺寸由内容决定。
         _ = rootLayout.tg_addRow(size:TGLayoutSize.average, colSize: TGLayoutSize.wrap)
         _ = rootLayout.tg_addRow(size:TGLayoutSize.average, colSize: TGLayoutSize.wrap)
         _ = rootLayout.tg_addRow(size:TGLayoutSize.average, colSize: TGLayoutSize.wrap)

    }
   
}

//MARK: - Layout Construction
extension TLTest2ViewController
{
    func createColLayout(image:String, title:String) ->UIView
    {
        let colLayout = TGLinearLayout(.vert)
        colLayout.backgroundColor = CFTool.color(0)
        colLayout.tg_gravity = TGGravity.horz.fill  //里面所有子视图的宽度都跟父视图保持一致，这样子视图就不需要设置宽度了。
        colLayout.tg_height.equal(.wrap)
        colLayout.tg_vspace = 5 //设置布局视图里面子视图之间的垂直间距为5个点。
        colLayout.tg_setTarget(self,action:#selector(handleColLayoutTap), for:.touchUpInside)
        colLayout.tg_highlightedOpacity = 0.3 //设置触摸事件按下时的不透明度，来响应按下状态。
        
        
        let imageView = UIImageView(image:UIImage(named:image))
        imageView.tg_height.equal(.wrap) //这个属性重点注意！！ 对于UIImageView来说，如果我们设置了这个属性为.wrap的话，表示视图的高度会根据视图的宽度进行等比例的缩放来确定，从而防止图片显示时出现变形的情况。
        colLayout.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = CFTool.font(14)
        titleLabel.textColor = CFTool.color(4)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.tg_bottom.equal(2)
        titleLabel.sizeToFit()
        colLayout.addSubview(titleLabel)
        

        return colLayout
    }

}

//MARK: - Handle Method
extension TLTest2ViewController
{
    
    @objc func handleAddColLayout(_ sender:AnyObject?)
    {
        //获取表格布局中的每行的高度，找到高度最小的一行，如果高度都相等则选择索引号小的行。
        var  minHeight:CGFloat = CGFloat.greatestFiniteMagnitude
        var  rowIndex = 0
        for i in 0..<self.rootLayout.tg_rowCount
        {
            let rowView = self.rootLayout.tg_rowView(at:i)
            
            if (rowView.frame.maxY < minHeight)
            {
                minHeight = rowView.frame.maxY
                rowIndex = i
            }
        }
        
        let images:[String] = [
            "p1-11",
            "p1-12",
            "p1-21",
            "p1-31",
            "p1-32",
            "p1-33",
            "p1-34",
            "p1-35",
            "image1",
            "image2",
            "image3",
            "image4"
        ]
        
        let colLayout = self.createColLayout(image:images[Int(arc4random_uniform(UInt32(images.count)))], title:String(format:NSLocalizedString("cell title:%03ld", comment:""), sTag))
        colLayout.tag = sTag
        sTag += 1
        self.rootLayout.tg_addCol(colLayout, inRow:rowIndex)
    }
    
    @objc func handleColLayoutTap(sender:UIView!)
    {
        let alertView = UIAlertView(title:"", message: String(format:NSLocalizedString("cell:%03ld be selected", comment:""), sender.tag), delegate: nil, cancelButtonTitle: "OK")
        
        alertView.show()
        
    }

}
