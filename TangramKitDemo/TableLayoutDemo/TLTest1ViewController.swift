//
//  TLTest1ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


class TLTest1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLabel(_ title: String, backgroundColor color: UIColor) -> UILabel {
        let v = UILabel()
        v.text = title
        v.font = CFTool.font(14)
        v.textAlignment = .center
        v.backgroundColor = color
        return v
    }
    
    override func loadView() {
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        super.loadView()
        
        let tableLayout = TGTableLayout(.vert)
        tableLayout.backgroundColor = CFTool.color(0)
        tableLayout.tg_hspace = 2
        tableLayout.tg_vspace = 2
        tableLayout.tg_margin(TGLayoutPos.tg_safeAreaMargin)   //和父视图的安全区域保持一致的尺寸，因为这里和父视图四周的边距都是安全区边距。你可以设置为0看看效果。
        self.view.addSubview(tableLayout)
        
        
        //第一行固定高度固定为30，每列的宽度固定为70
        _ = tableLayout.tg_addRow(size:30,colSize:70)
        
        var  colView = self.createLabel("Cell00", backgroundColor: CFTool.color(1))
        colView.tg_leading.equal(10)
        colView.tg_trailing.equal(40) //可以使用TGLayoutPos对象来调整间距。
        colView.tg_top.equal(5)
        colView.tg_bottom.equal(5)
        tableLayout.tg_addCol(colView, inRow:0)
        
        colView = self.createLabel("Cell01", backgroundColor: CFTool.color(2))
        colView.tg_leading.equal(20)
        tableLayout.tg_addCol(colView, inRow:0)
        
        colView = self.createLabel("Cell02", backgroundColor: CFTool.color(3))
        tableLayout.tg_addCol(colView, inRow:0)
        
        //第二行固定高度为40，每列的宽度都相等。
        _ = tableLayout.tg_addRow(size:40,colSize:TGLayoutSize.average)
        
        colView = self.createLabel("Cell10", backgroundColor: CFTool.color(1))
        tableLayout.tg_addCol(colView, inRow:1)
        
        colView = self.createLabel("Cell11", backgroundColor: CFTool.color(2))
        tableLayout.tg_addCol(colView, inRow:1)
        
        
        colView = self.createLabel("Cell12", backgroundColor: CFTool.color(3))
        tableLayout.tg_addCol(colView, inRow:1)
        
        colView = self.createLabel("Cell13", backgroundColor: CFTool.color(4))
        tableLayout.tg_addCol(colView, inRow:1)
        
        //第三行固定高度为30，每列的宽度自己设置。行的宽度由所有子视图的宽度包裹。
        _ = tableLayout.tg_addRow(size:30,colSize:TGLayoutSize.wrap)
        
        colView = self.createLabel("Cell20", backgroundColor: CFTool.color(1))
        colView.tg_width.equal(100)
        tableLayout.tg_addCol(colView, inRow:2)
        
        colView = self.createLabel("Cell21", backgroundColor: CFTool.color(2))
        colView.tg_width.equal(200)
        tableLayout.tg_addCol(colView, inRow:2)
        
        //第四行固定高度为30，子视图的宽度自己设置，但是每行的宽度和父视图保持一致。
        _ = tableLayout.tg_addRow(size:30,colSize:TGLayoutSize.fill)

        colView = self.createLabel("Cell30", backgroundColor: CFTool.color(1))
        colView.tg_width.equal(80)
        tableLayout.tg_addCol(colView, inRow:3)
        
        colView = self.createLabel("Cell31", backgroundColor: CFTool.color(2))
        colView.tg_width.equal(200)
        tableLayout.tg_addCol(colView, inRow:3)
        
        //第五行剩余高度均分。每列的宽度均分,
        let row4 = tableLayout.tg_addRow(size:TGLayoutSize.average, colSize:TGLayoutSize.average)
        //可以设置行的属性.比如padding, 线条颜色，
        row4.tg_padding = UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3);
        row4.tg_topBorderline = TGBorderline(color: UIColor.black, thick: 2)
        row4.backgroundColor = UIColor(white: 0.5, alpha: 1)
        
        
        colView = self.createLabel("Cell40", backgroundColor: CFTool.color(1))
        tableLayout.tg_addCol(colView, inRow:4)
        
        colView = self.createLabel("Cell41", backgroundColor: CFTool.color(2))
        tableLayout.tg_addCol(colView, inRow:4)
        
        
        //第六行高度固定为30, 列数固定为4。这里只添加了3列，可见列宽是固定的。
        _ = tableLayout.tg_addRow(size:30, colCount:4)
        
        colView = self.createLabel("Cell50", backgroundColor: CFTool.color(1))
        tableLayout.tg_addCol(colView, inRow:5)
        
        colView = self.createLabel("Cell51", backgroundColor: CFTool.color(2))
        tableLayout.tg_addCol(colView, inRow:5)
        
        colView = self.createLabel("Cell52", backgroundColor: CFTool.color(3))
        tableLayout.tg_addCol(colView, inRow:5)
        
        
        //第七行高度由子视图的高度决定，列均分宽度
        _ = tableLayout.tg_addRow(size:TGLayoutSize.wrap, colSize:TGLayoutSize.average)
        
        colView = self.createLabel("Cell60", backgroundColor: CFTool.color(1))
        colView.tg_height.equal(80)
        tableLayout.tg_addCol(colView, inRow:6)
        
        colView = self.createLabel("Cell61", backgroundColor: CFTool.color(2))
        colView.tg_height.equal(120)
        tableLayout.tg_addCol(colView, inRow:6)
        
        colView = self.createLabel("Cell62", backgroundColor: CFTool.color(3))
        colView.tg_height.equal(70)
        tableLayout.tg_addCol(colView, inRow:6)
    
        
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
