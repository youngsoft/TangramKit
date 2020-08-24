//
//  TLTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



class TLTest3ViewController: UIViewController {
    
   weak var rootLayout:TGTableLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Space", style: .plain, target: self, action: #selector(handleSpace))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        
        /*
         这个例子是将表格布局和智能边界线的应用结合，实现一个表格界面。
         
         */
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView
        
        
        if #available(iOS 11.0, *) {            
        } else {
            // Fallback on earlier versions
            
            self.edgesForExtendedLayout = UIRectEdge(rawValue:0)

        }
        
        
        var tableLayout = TGTableLayout(.vert)
        tableLayout.tg.height.equal(.wrap)
        //这里设置表格的左边和右边以及顶部的边距都是在父视图的安全区域外再缩进10个点的位置。你会注意到这里面定义了一个特殊的位置TGLayoutPos.tg.safeAreaMargin。
        //TGLayoutPos.tg.safeAreaMargin表示视图的边距不是一个固定的值而是所在的父视图的安全区域。这样布局视图就不会延伸到安全区域以外去了。
        //TGLayoutPos.tg.safeAreaMargin是同时支持iOS11和以下的版本的，对于iOS11以下的版本则顶部安全区域是状态栏以下的位置。
        //因此只要你设置边距为TGLayoutPos.tg.safeAreaMargin则可以同时兼容所有iOS的版本。。
        tableLayout.tg.leading.equal(TGLayoutPos.tg.safeAreaMargin, offset: 10)
        tableLayout.tg.trailing.equal(TGLayoutPos.tg.safeAreaMargin, offset: 10)
        tableLayout.tg.top.equal(TGLayoutPos.tg.safeAreaMargin, offset: 10)

        
        scrollView.addSubview(tableLayout)
        self.rootLayout = tableLayout
        
        //建立一个表格外边界的边界线。颜色为黑色，粗细为3.
        tableLayout.tg.boundBorderline = TGBorderline(color:CFTool.color(4), thick: 3)
        
        //建立智能边界线。所谓智能边界线就是布局里面的如果有子布局视图，则子布局视图会根据自身的布局位置智能的设置边界线。
        //智能边界线只支持表格布局、线性布局、流式布局、浮动布局。
        //如果要想完美使用智能分界线，则请将cellview建立为一个布局视图，比如本例子中的createCellLayout。
        tableLayout.tg.intelligentBorderline = TGBorderline(color:CFTool.color(5))
        
        //添加第一行。行高为50，每列宽由自己确定。
        let firstRowTitles = ["Name","Mon.","Tues.","Wed.","Thur.","Fri.","Sat.","Sun."];
        var firstRow:TGLinearLayout = tableLayout.tg.addRow(size:50, colSize: TGLayoutSize.fill)
        firstRow.tg.notUseIntelligentBorderline = true ////因为智能边界线会影响到里面的所有子布局，包括每行，但是这里我们希望这行不受智能边界线的影响而想自己定义边界线，则将这个属性设置为true。
        firstRow.tg.bottomBorderline = TGBorderline(color:CFTool.color(7)) //我们自定义第一行的底部边界线为蓝色边界线。
        for i in 0 ..< firstRowTitles.count
        {
            let cellView = self.createCellLayout(value: firstRowTitles[i])
            if (i == 0)
            {
                cellView.tg.width.equal(80)
            }
            else
            {
                cellView.tg.width.equal(.average)  //我们这里定义第一列的宽度为80，而其他的列宽平均分配。
            }
            
            tableLayout.addSubview(cellView)  //表格布局重写了addSubview，表示总是添加到最后一行上。
            
        }
 
        //中间行
        let names = ["欧阳大哥","周杰","{丸の子}","小鱼","Sarisha゛"]
        let values = ["", "10","20"]
        for _ in 0 ..< 10
        {
            let _ = tableLayout.tg.addRow(size:40, colSize: TGLayoutSize.fill)
            
            for j in 0 ..< firstRowTitles.count
            {
                var cellView:UIView
                
                if j == 0
                {
                    cellView = self.createCellLayout(value: names[Int(arc4random_uniform(UInt32(names.count)))])
                    cellView.tg.width.equal(80)
                }
                else
                {
                    cellView = self.createCellLayout(value: values[Int(arc4random_uniform(UInt32(values.count)))])
                    cellView.tg.width.equal(.average)
                }
                
                tableLayout.addSubview(cellView)
            }
            
        }
        
        //最后一行
        var lastRow = tableLayout.tg.addRow(size:60, colSize: TGLayoutSize.fill)
        lastRow.tg.notUseIntelligentBorderline = true
        lastRow.tg.topBorderline = TGBorderline(color:.red)
      
        var cellLayout = self.createCellLayout(value: "Total:")
        cellLayout.tg.width.equal(.fill) //占用剩余宽度您也可以设置为tg.width.equal(100%)
        tableLayout.addSubview(cellLayout)
        
        cellLayout = self.createCellLayout(value: "1234.11")
        cellLayout.tg.width.equal(100)
        tableLayout.addSubview(cellLayout)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TLTest3ViewController
{
    func createCellLayout(value:String) -> UIView
    {
        var cellLayout = TGFrameLayout()
        cellLayout.tg.setTarget(self,action:#selector(handleCellTap), for:.touchUpInside)
        cellLayout.tg.highlightedBackgroundColor = CFTool.color(8)
        
        let label = UILabel()
        label.text = value
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = CFTool.font(15)
        label.tg.width.equal(cellLayout.tg.width)
        label.tg.height.equal(cellLayout.tg.height)
       // label.tg.width.equal(.fill)
       // label.tg.height.equal(.fill)
       // label.tg.width.equal(100%)
       // label.tg.height.equal(100%)
        cellLayout.addSubview(label)
        
        return cellLayout;
    }
    

}

//MARK: - Handle Method
extension TLTest3ViewController
{
    @objc func handleCellTap(sender:TGBaseLayout)
    {
        let label = sender.subviews.first as! UILabel
        let  message = "您单击了:\(label.text!)"
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    @objc func handleSpace(sender:Any?)
    {
        //执行间距调整的逻辑。
        if self.rootLayout.tg.vspace == 0
        {
            self.rootLayout.tg.vspace = 5
        }
        else if self.rootLayout.tg.hspace == 0
        {
            self.rootLayout.tg.hspace = 5
        }
        else
        {
            self.rootLayout.tg.vspace = 0
            self.rootLayout.tg.hspace = 0
        }
        
        self.rootLayout.tg.layoutAnimationWithDuration(0.3)
        
    }
    
}
