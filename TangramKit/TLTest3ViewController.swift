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
        super.loadView()
        
        let scrollView = UIScrollView(frame:self.view.bounds.insetBy(dx: 10, dy: 10))
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scrollView)
        
        
        let tableLayout = TGTableLayout(.vert)
        tableLayout.tg_width.equal(.fill)
        tableLayout.tg_height.equal(.wrap)
        scrollView.addSubview(tableLayout)
        self.rootLayout = tableLayout
        
        //建立一个表格外边界的边界线。颜色为黑色，粗细为3.
        tableLayout.tg_boundBorderline = TGLayoutBorderline(color:.black, thick: 3)
        
        //建立智能边界线。所谓智能边界线就是布局里面的如果有子布局视图，则子布局视图会根据自身的布局位置智能的设置边界线。
        //智能边界线只支持表格布局、线性布局、流式布局、浮动布局。
        //如果要想完美使用智能分界线，则请将cellview建立为一个布局视图，比如本例子中的createCellLayout。
        tableLayout.tg_intelligentBorderline = TGLayoutBorderline(color:.red)
        
        //添加第一行。行高为50，每列宽由自己确定。
        let firstRowTitles = ["Name","Mon.","Tues.","Wed.","Thur.","Fri.","Sat.","Sun."];
        let firstRow:TGLinearLayout = tableLayout.tg_addRow(size:50, colSize: TGTableLayout.fill)
        firstRow.tg_notUseIntelligentBorderline = true ////因为智能边界线会影响到里面的所有子布局，包括每行，但是这里我们希望这行不受智能边界线的影响而想自己定义边界线，则将这个属性设置为true。
        firstRow.tg_bottomBorderline = TGLayoutBorderline(color:.blue) //我们自定义第一行的底部边界线为蓝色边界线。
        for i in 0 ..< firstRowTitles.count
        {
            let cellView = self.createCellLayout(value: firstRowTitles[i])
            if (i == 0)
            {
                cellView.tg_width.equal(80)
            }
            else
            {
                cellView.tg_width.equal(100%)  //我们这里定义第一列的宽度为80，而其他的列宽平均分配。
            }
            
            tableLayout.addSubview(cellView)  //表格布局重写了addSubview，表示总是添加到最后一行上。
            
        }
 
        //中间行
        let names = ["欧阳大哥","周杰","{丸の子}","小鱼","Sarisha゛"]
        let values = ["", "10","20"]
        for _ in 0 ..< 10
        {
            let _ = tableLayout.tg_addRow(size:40, colSize: TGTableLayout.fill)
            
            for j in 0 ..< firstRowTitles.count
            {
                var cellView:UIView
                
                if j == 0
                {
                    cellView = self.createCellLayout(value: names[Int(arc4random_uniform(UInt32(names.count)))])
                    cellView.tg_width.equal(80)
                }
                else
                {
                    cellView = self.createCellLayout(value: values[Int(arc4random_uniform(UInt32(values.count)))])
                    cellView.tg_width.equal(100%)
                }
                
                tableLayout.addSubview(cellView)
            }
            
        }
        
        //最后一行
        let lastRow = tableLayout.tg_addRow(size:60, colSize: TGTableLayout.fill)
        lastRow.tg_notUseIntelligentBorderline = true
        lastRow.tg_topBorderline = TGLayoutBorderline(color:UIColor.green)
      
        var cellLayout = self.createCellLayout(value: "Total:")
        cellLayout.tg_width.equal(.fill) //占用剩余宽度您也可以设置为tg_width.equal(100%)
        tableLayout.addSubview(cellLayout)
        
        cellLayout = self.createCellLayout(value: "1234.11")
        cellLayout.tg_width.equal(100)
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
        let cellLayout = TGFrameLayout()
        cellLayout.tg_setTarget(self,action:#selector(handleCellTap), for:.touchUpInside)
        cellLayout.tg_highlightedBackgroundColor = .lightGray
        
        let label = UILabel()
        label.text = value
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.tg_width.equal(cellLayout.tg_width)
        label.tg_height.equal(cellLayout.tg_height)
        cellLayout.addSubview(label)
        
        return cellLayout;
    }
    

}

//MARK: - Handle Method
extension TLTest3ViewController
{
    func handleCellTap(sender:TGBaseLayout)
    {
        let  message = "您单击了:\((sender.subviews.first as! UILabel).text)"
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func handleSpace(sender:Any?)
    {
        //执行间距调整的逻辑。
        if self.rootLayout.tg_vspace == 0
        {
            self.rootLayout.tg_vspace = 5
        }
        else if self.rootLayout.tg_hspace == 0
        {
            self.rootLayout.tg_hspace = 5
        }
        else
        {
            self.rootLayout.tg_vspace = 0
            self.rootLayout.tg_hspace = 0
        }
        
        self.rootLayout.tg_layoutAnimationWithDuration(0.3)
        
    }
    
}
