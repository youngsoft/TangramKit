//
//  RLTest3ViewController.swift
//  TangramKit
//
//  Created by zhangguangkai on 16/5/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class RLTest3ViewController: UIViewController {

    override func loadView() {
        
        /*
         这个例子展示的相对布局里面某些视图整体居中的实现机制。这个可以通过设置子视图的扩展属性的TGLayoutPos对象的equal方法的值为数组来实现。
         对于AutoLayout来说一直被诟病的是要实现某些视图整体在父视图中居中时，需要在外层包裹一个视图，然后再将这个包裹的视图在父视图中居中。而对于TGRelativeLayout来说实现起来则非常的简单。
         */
        
        let rootLayout = TGRelativeLayout()
        self.view = rootLayout
        
        let layout1 = createLayout1()  //子视图整体水平居中的布局
        let layout2 = createLayout2()  //子视图整体垂直居中的布局
        let layout3 = createLayout3()  //子视图整体居中的布局。
        
        layout1.backgroundColor = .red
        layout2.backgroundColor = .green
        layout3.backgroundColor = .blue
        
        layout1.tg_width.equal(rootLayout.tg_width)
        layout2.tg_width.equal(rootLayout.tg_width)
        layout3.tg_width.equal(rootLayout.tg_width)
        
        //均分三个布局的高度。
        layout1.tg_height.equal([layout2.tg_height, layout3.tg_height])
        layout2.tg_top.equal(layout1.tg_bottom)
        layout3.tg_top.equal(layout2.tg_bottom)
        
        rootLayout.addSubview(layout1)
        rootLayout.addSubview(layout2)
        rootLayout.addSubview(layout3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


//MARK: - Layout Construction
extension RLTest3ViewController
{
    //子视图整体水平居中的布局
    func createLayout1() -> TGRelativeLayout {
        let layout = TGRelativeLayout()
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("subviews horz centered in superview", comment:"")
        titleLabel.sizeToFit()
        layout.addSubview(titleLabel)
        
        let v1 = UIView()
        v1.backgroundColor = .green
        v1.tg_width.equal(100)
        v1.tg_height.equal(50)
        v1.tg_centerY.equal(0)
        layout.addSubview(v1)
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        v2.tg_width.equal(50)
        v2.tg_height.equal(50)
        v2.tg_centerY.equal(0)
        layout.addSubview(v2)
        
        //通过为tg_centerX等于一个数组值，表示他们之间整体居中,还可以设置其他视图的偏移量。
        v2.tg_centerX.offset(20)
        v1.tg_centerX.equal([v2.tg_centerX])
        
        return layout
    }
    
    //子视图整体垂直居中的布局
    func createLayout2() -> TGRelativeLayout {
        let layout = TGRelativeLayout()
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("subviews vert centered in superview", comment:"")
        titleLabel.sizeToFit()
        layout.addSubview(titleLabel)
        
        let v1 = UIView()
        v1.backgroundColor = .red
        v1.tg_width.equal(200)
        v1.tg_height.equal(50)
        v1.tg_centerX.equal(0)
        layout.addSubview(v1)
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        v2.tg_width.equal(200)
        v2.tg_height.equal(30)
        v2.tg_centerX.equal(0)
        layout.addSubview(v2)
        
        //通过为tg_centerY等于一个数组值，表示他们之间整体居中,还可以设置其他视图的偏移量。
        v2.tg_centerY.offset(20)
        v1.tg_centerY.equal([v2.tg_centerY])
        
        return layout
    }
    
    //子视图整体居中布局
    func createLayout3() -> TGRelativeLayout {
        let layout = TGRelativeLayout()
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("subviews centered in superview", comment:"")
        titleLabel.sizeToFit()
        layout.addSubview(titleLabel)
        
        let lb1up = UILabel()
        lb1up.text = "TopLeft"
        lb1up.backgroundColor = UIColor.red
        lb1up.font = UIFont.systemFont(ofSize: 17)
        lb1up.sizeToFit()
        layout.addSubview(lb1up)
        
        let lb1down = UILabel()
        lb1down.text = "BottomLeft"
        lb1down.backgroundColor = UIColor.red
        lb1down.font = UIFont.systemFont(ofSize: 17)
        lb1down.sizeToFit()
        layout.addSubview(lb1down)
        
        let lb2up = UILabel()
        lb2up.text = "TopCenter"
        lb2up.backgroundColor = UIColor.red
        lb2up.font = UIFont.systemFont(ofSize: 12)
        lb2up.sizeToFit()
        layout.addSubview(lb2up)
        
        let lb2down = UILabel()
        lb2down.text = "Center"
        lb2down.backgroundColor = UIColor.green
        lb2down.sizeToFit()
        layout.addSubview(lb2down)
        
        let lb3up = UILabel()
        lb3up.text = "TopRight"
        lb3up.backgroundColor = UIColor.red
        lb3up.sizeToFit()
        layout.addSubview(lb3up)
        
        let lb3down = UILabel()
        lb3down.text = "BottomRight"
        lb3down.backgroundColor = UIColor.green
        lb3down.font = UIFont.systemFont(ofSize: 16)
        lb3down.sizeToFit()
        layout.addSubview(lb3down)
        
        //左，中，右三组视图分别垂直居中显示，并且下面和上面间隔10
        lb1down.tg_centerY.offset(10)
        lb2down.tg_centerY.offset(10)
        lb3down.tg_centerY.offset(10)
        
        lb1up.tg_centerY.equal([lb1down.tg_centerY])
        lb2up.tg_centerY.equal([lb2down.tg_centerY])
        lb3up.tg_centerY.equal([lb3down.tg_centerY])
        
        //上面的三个视图水平居中显示并且间隔60
        lb2up.tg_centerX.offset(60)
        lb3up.tg_centerX.offset(60)
        lb1up.tg_centerX.equal([lb2up.tg_centerX, lb3up.tg_centerX])
        
        //下面的三个视图的水平中心点和上面三个视图的水平中心点对齐
        lb1down.tg_centerX.equal(lb1up.tg_centerX)
        lb2down.tg_centerX.equal(lb2up.tg_centerX)
        lb3down.tg_centerX.equal(lb3up.tg_centerX)
        
        return layout
    }
    
}

