//
//  TLTest4ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



class TLTest4ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        self.view = scrollView
        
        
        if #available(iOS 11.0, *) {            
        } else {
            // Fallback on earlier versions
            
            self.edgesForExtendedLayout = UIRectEdge(rawValue:0)

        }
        
        
        let tableLayout = TGTableLayout(.vert)
        tableLayout.tg_height.equal(.wrap)
        //这里设置表格的左边和右边以及顶部的边距都是在父视图的安全区域外再缩进10个点的位置。你会注意到这里面定义了一个特殊的位置TGLayoutPos.tg_safeAreaMargin。
        //TGLayoutPos.tg_safeAreaMargin表示视图的边距不是一个固定的值而是所在的父视图的安全区域。这样布局视图就不会延伸到安全区域以外去了。
        //TGLayoutPos.tg_safeAreaMargin是同时支持iOS11和以下的版本的，对于iOS11以下的版本则顶部安全区域是状态栏以下的位置。
        //因此只要你设置边距为MyLayoutPos.safeAreaMargin则可以同时兼容所有iOS的版本。。
        tableLayout.tg_leading.equal(TGLayoutPos.tg_safeAreaMargin, offset: 10)
        tableLayout.tg_trailing.equal(TGLayoutPos.tg_safeAreaMargin, offset: 10)
        tableLayout.tg_top.equal(TGLayoutPos.tg_safeAreaMargin, offset: 10)
        scrollView.addSubview(tableLayout)
        
        //建立一个表格外边界的边界线。颜色为黑色，粗细为3.
        tableLayout.tg_boundBorderline = TGBorderline(color:CFTool.color(4), thick: 3)
        //建立智能边界线。所谓智能边界线就是布局里面的如果有子布局视图，则子布局视图会根据自身的布局位置智能的设置边界线。
        //智能边界线只支持表格布局、线性布局、流式布局、浮动布局。
        //如果要想完美使用智能分界线，则请将cellview建立为一个布局视图。
        tableLayout.tg_intelligentBorderline = TGBorderline(color:CFTool.color(5))
        
        
         let titles = ["身高(Height)(cm)", "体重(Weight)(kg)", "胸围(Bust)(cm)","腰围(Waist)(cm)","臀围(Hip)(cm)","鞋码(Shoes Size)(欧码)"]
         let values = ["177","54","88","88","88","43"]
        
        //第一行
        let row1 = tableLayout.tg_addRow(size:TGLayoutSize.wrap, colCount:titles.count)
        row1.tg_gravity = TGGravity.vert.top
        row1.backgroundColor = CFTool.color(8)
        titles.forEach({tableLayout.addSubview(self.itemFrom(text: $0, alignment: .center)) })
        
    
        
        //第二行
        let row2 = tableLayout.tg_addRow(size:TGLayoutSize.wrap, colCount:titles.count)
        row2.tg_gravity = TGGravity.vert.center
        titles.forEach({tableLayout.addSubview(self.itemFrom(text: $0, alignment: .center)) })

        
        //第三行
        let row3 = tableLayout.tg_addRow(size:TGLayoutSize.wrap, colCount:titles.count)
        row3.tg_gravity = TGGravity.vert.bottom
        titles.forEach({tableLayout.addSubview(self.itemFrom(text: $0, alignment: .center)) })

        
        //第四行
        _ = tableLayout.tg_addRow(size:50, colCount:titles.count)
        titles.forEach({tableLayout.addSubview(self.itemFrom(text: $0, alignment: .center, isFitWidth:true)) })
        
        
        //第五行
        _ = tableLayout.tg_addRow(size:TGLayoutSize.wrap, colCount:values.count)
        values.forEach({tableLayout.addSubview(self.itemFrom(text: $0, alignment: .left)) })

        
        //第六行
        _ = tableLayout.tg_addRow(size:TGLayoutSize.wrap, colCount:values.count)
        values.forEach({tableLayout.addSubview(self.itemFrom(text: $0, alignment: .center)) })

        
        //第7行
        _ = tableLayout.tg_addRow(size:TGLayoutSize.wrap, colCount:values.count)
        values.forEach({tableLayout.addSubview(self.itemFrom(text: $0, alignment: .right)) })
        
    
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

extension TLTest4ViewController
{
  
    func itemFrom(text:String, alignment:NSTextAlignment, isFitWidth:Bool = false) -> TGBaseLayout
    {
        let  itemLayout = TGFrameLayout()
        itemLayout.tg_topPadding = 10
        itemLayout.tg_bottomPadding = 10
        itemLayout.tg_leadingPadding = 10
        itemLayout.tg_trailingPadding = 5
        
        let label = UILabel()
        label.text = text
        label.textAlignment = alignment
        label.textColor = CFTool.color(4)
        itemLayout.addSubview(label)
        
        if isFitWidth
        {
            itemLayout.tg_gravity = TGGravity.fill
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
        }
        else
        {
            itemLayout.tg_gravity = TGGravity.horz.fill
            itemLayout.tg_height.equal(.wrap)
            label.tg_height.equal(.wrap)
        }
        
        
        return itemLayout
    }


}
