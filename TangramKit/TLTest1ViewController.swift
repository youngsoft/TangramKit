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
    
    override func loadView() {
        super.loadView()
        
        let tableLayout = TGTableLayout(.vert)
        tableLayout.tg_width.equal(.fill)
        tableLayout.tg_height.equal(.fill)
        self.view.addSubview(tableLayout)
        
        
        //第一行固定高度固定为30，每列的宽度固定为70
        tableLayout.tg_addRow(size:30,colSize:70).backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        var colView = UILabel()
        colView.text = "Cell00"
        colView.textAlignment = .center
        colView.tg_left.equal(10)
        colView.tg_right.equal(40) //可以使用TGLayoutPos对象来调整间距。
        colView.tg_top.equal(5)
        colView.tg_bottom.equal(5)
        colView.backgroundColor = .red
        tableLayout.tg_addCol(colView, inRow:0)
        
        colView = UILabel()
        colView.text = "Cell01"
        colView.textAlignment = .center
        colView.backgroundColor = .green
        colView.tg_left.equal(20)
        tableLayout.tg_addCol(colView, inRow:0)
        
        colView = UILabel()
        colView.text = "Cell02"
        colView.textAlignment = .center
        colView.backgroundColor = UIColor.blue
        tableLayout.tg_addCol(colView, inRow:0)
        
        //第二行固定高度为40，每列的宽度都相等。
        tableLayout.tg_addRow(size:40,colSize:TGLayoutSize.average).backgroundColor = UIColor(white: 0.2, alpha: 1)
        
        colView = UILabel()
        colView.text = "Cell10"
        colView.textAlignment = .center
        colView.backgroundColor = .red
        tableLayout.tg_addCol(colView, inRow:1)
        
        colView = UILabel()
        colView.text = "Cell11"
        colView.textAlignment = .center;
        colView.backgroundColor = .green
        tableLayout.tg_addCol(colView, inRow:1)
        
        
        colView = UILabel()
        colView.text = "Cell12"
        colView.textAlignment = .center;
        colView.backgroundColor = .blue
        tableLayout.tg_addCol(colView, inRow:1)
        
        colView = UILabel()
        colView.text = "Cell13";
        colView.textAlignment = .center
        colView.backgroundColor = .yellow
        tableLayout.tg_addCol(colView, inRow:1)
        
        //第三行固定高度为30，每列的宽度自己设置。行的宽度由所有子视图的宽度包裹。
        tableLayout.tg_addRow(size:30,colSize:TGLayoutSize.wrap).backgroundColor = UIColor(white: 0.3, alpha: 1)
        
        colView = UILabel()
        colView.text = "Cell20"
        colView.textAlignment = .center
        colView.backgroundColor = .red
        colView.tg_width.equal(100)
        tableLayout.tg_addCol(colView, inRow:2)
        
        colView = UILabel()
        colView.text = "Cell21";
        colView.textAlignment = .center;
        colView.backgroundColor = .green
        colView.tg_width.equal(200)
        tableLayout.tg_addCol(colView, inRow:2)
        
        //第四行固定高度为30，子视图的宽度自己设置，但是每行的宽度和父视图保持一致。
        tableLayout.tg_addRow(size:30,colSize:TGLayoutSize.fill).backgroundColor = UIColor(white: 0.4, alpha: 1)

        colView = UILabel()
        colView.text = "Cell30"
        colView.textAlignment = .center;
        colView.backgroundColor = .red
        colView.tg_width.equal(80)
        tableLayout.tg_addCol(colView, inRow:3)
        
        colView = UILabel()
        colView.text = "Cell31"
        colView.textAlignment = .center
        colView.backgroundColor = .green
        colView.tg_width.equal(200)
        tableLayout.tg_addCol(colView, inRow:3)
        
        //第五行剩余高度均分。每列的宽度均分,
        let row4 = tableLayout.tg_addRow(size:TGLayoutSize.average, colSize:TGLayoutSize.average)
        //可以设置行的属性.比如padding, 线条颜色，
        row4.tg_padding = UIEdgeInsetsMake(3, 3, 3, 3);
        row4.tg_topBorderline = TGLayoutBorderline(color: UIColor.black, thick: 2)
        row4.backgroundColor = UIColor(white: 0.5, alpha: 1)
        
        colView = UILabel()
        colView.text = "Cell40";
        colView.textAlignment = .center
        colView.backgroundColor = .red
        tableLayout.tg_addCol(colView, inRow:4)
        
        colView = UILabel()
        colView.text = "Cell41";
        colView.textAlignment = .center
        colView.backgroundColor = .green
        tableLayout.tg_addCol(colView, inRow:4)
        
        //第六行高度由子视图的高度决定，列均分宽度
        tableLayout.tg_addRow(size:TGLayoutSize.wrap, colSize:TGLayoutSize.average).backgroundColor = UIColor(white: 0.6, alpha: 1)
        
        colView = UILabel()
        colView.text = "Cell50"
        colView.textAlignment = .center
        colView.backgroundColor = .red
        colView.tg_height.equal(80)
        tableLayout.tg_addCol(colView, inRow:5)
        
        colView = UILabel()
        colView.text = "Cell51"
        colView.textAlignment = .center
        colView.backgroundColor = .green
        colView.tg_height.equal(120)
        tableLayout.tg_addCol(colView, inRow:5)
        
        colView = UILabel()
        colView.text = "Cell52";
        colView.textAlignment = .center
        colView.backgroundColor = .blue
        colView.tg_height.equal(70)
        tableLayout.tg_addCol(colView, inRow:5)
    
        
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
