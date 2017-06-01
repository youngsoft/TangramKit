//
//  AllTest5ViewController.swift
//  TangramKit
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *1.SizeClass - Demo1
 */
class AllTest5ViewController: UIViewController {

    override func loadView() {
        
        /*
         这个例子用来介绍MyLayout对sizeClasses的支持的能力
         */

        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        
        //默认设置为垂直布局
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .white
        rootLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10);
        rootLayout.tg_vspace = 10
        rootLayout.tg_hspace = 10
        self.view = rootLayout;
        
        
        let v1 = UILabel()
        v1.backgroundColor = CFTool.color(5)
        v1.numberOfLines = 0;
        v1.text = NSLocalizedString("The red、green、blue subwiews is arranged vertically when run in portrait screen on all the iPhone devices,but horizontal arranged when in landscape screen, the blue subview is not showed on any phone devices except on iPhone6plus.", comment:"");
        v1.textColor = CFTool.color(4)
        v1.font = CFTool.font(15)
        v1.tg_height.equal(100%)
        v1.tg_width.equal(100%)
        rootLayout.addSubview(v1)
        
        
        let v2 = UILabel()
        v2.backgroundColor = CFTool.color(6)
        v2.tg_height.equal(100%)
        v2.tg_width.equal(100%)
        rootLayout.addSubview(v2)
        
        
        let v3 = UILabel()
        v3.backgroundColor = CFTool.color(7)
        v3.tg_height.equal(100%)
        v3.tg_width.equal(100%)
        rootLayout.addSubview(v3)
        
        //v3视图在其他任何iPhone设备横屏都不参与布局
        v3.tg_fetchSizeClass(with: .comb(.any, .compact, nil)).tg_visibility = .gone
        //只有iphone6Plus的横屏才参与布局
        v3.tg_fetchSizeClass(with: .comb(.regular, .compact, nil), from: .default).tg_visibility = .visible
        
        //针对iPhone设备的所有横屏的高度都是Compact的，而宽度则是任意，因此下面的设置横屏情况下布局变为水平布局。
        let lsc = rootLayout.tg_fetchSizeClass(with: .comb(.any, .compact, nil), from:.default) as! TGLinearLayoutViewSizeClass
        lsc.tg_orientation = .horz
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
