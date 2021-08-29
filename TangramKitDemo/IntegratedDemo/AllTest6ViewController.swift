//
//  AllTest6ViewController.swift
//  TangramKit
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 *2.SizeClass - Demo2
 */
class AllTest6ViewController: UIViewController {

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
         这个DEMO 主要介绍了Tangram对SizeClass的支持能力。下面的代码分别针对iPhone设备的横竖屏以及iPad设备的横竖屏分别做了适配处理。
         */

        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .white
        rootLayout.tg.gravity(value: TGGravity.Horizontal.fill)
        self.view = rootLayout

        //创建顶部的菜单布局部分。
        let menuLayout = TGFlowLayout(.vert, arrangedCount: 3)
        menuLayout.tg.gravity(value: TGGravity.fill)
        menuLayout.tg.height.equal(.wrap)
        menuLayout.tg.padding(value: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10))
        menuLayout.tg.space(value: 10)
        rootLayout.addSubview(menuLayout)

        let menu1Label = UILabel()
        menu1Label.text = NSLocalizedString("Menu1", comment: "")
        menu1Label.textAlignment = .center
        menu1Label.backgroundColor = CFTool.color(5)
        menu1Label.font = CFTool.font(16)
        menu1Label.tg.height.equal(menu1Label.tg.width)
        menu1Label.tg.width.equal(menu1Label.tg.height)
        menuLayout.addSubview(menu1Label)

        let menu2Label = UILabel()
        menu2Label.text = NSLocalizedString("Menu2", comment: "")
        menu2Label.textAlignment = .center
        menu2Label.backgroundColor = CFTool.color(6)
        menu2Label.font = CFTool.font(16)
        menu2Label.tg.height.equal(menu2Label.tg.width)
        menu2Label.tg.width.equal(menu2Label.tg.height)
        menuLayout.addSubview(menu2Label)

        let menu3Label = UILabel()
        menu3Label.text = NSLocalizedString("Menu3", comment: "")
        menu3Label.textAlignment = .center
        menu3Label.backgroundColor = CFTool.color(7)
        menu3Label.font = CFTool.font(16)
        menu3Label.tg.height.equal(menu3Label.tg.width)
        menu3Label.tg.width.equal(menu3Label.tg.height)
        menuLayout.addSubview(menu3Label)

        //下面创建内容部分。
        let contentLayout = TGRelativeLayout()
        contentLayout.backgroundColor = CFTool.color(0)
        contentLayout.tg.height.equal(.fill)
        contentLayout.tg.width.equal(.fill)
        contentLayout.tg.padding(value: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10))
        rootLayout.addSubview(contentLayout)

        let func1Label = UILabel()
        func1Label.text = NSLocalizedString("Content1", comment: "")
        func1Label.textAlignment = .center
        func1Label.backgroundColor = CFTool.color(5)
        func1Label.font = CFTool.font(16)
        func1Label.tg.height.equal(contentLayout.tg.height, increment: -5, multiple: 0.5)
        contentLayout.addSubview(func1Label)

        let func2Label = UILabel()
        func2Label.text = NSLocalizedString("Content2", comment: "")
        func2Label.textAlignment = .center
        func2Label.backgroundColor = CFTool.color(6)
        func2Label.font = CFTool.font(16)
        func2Label.tg.height.equal(contentLayout.tg.height, increment: -5, multiple: 0.5)
        contentLayout.addSubview(func2Label)

        func1Label.tg.width.equal([func2Label.tg.width])
        func2Label.tg.leading.equal(func1Label.tg.trailing)

        let func3Label = UILabel()
        func3Label.text = NSLocalizedString("Content3:please run in different iPhone&iPad device and change different screen orientation", comment: "")
        func3Label.numberOfLines = 0
        func3Label.textAlignment = .center
        func3Label.backgroundColor = CFTool.color(7)
        func3Label.font = CFTool.font(16)
        func3Label.tg.height.equal(contentLayout.tg.height, increment: -5, multiple: 0.5)
        func3Label.tg.width.equal(contentLayout.tg.width)
        func3Label.tg.top.equal(func1Label.tg.bottom, offset: 10)
        contentLayout.addSubview(func3Label)

        //下面定义iPhone设备横屏时的界面布局。
        let rootLayoutSC = rootLayout.tg.fetchSizeClass(with: .comb(.any, .compact, nil))
        rootLayoutSC.tg.orientation(value: .horz)
        rootLayoutSC.tg.gravity(value: TGGravity.Vertical.fill)

        let menuLayoutSC = menuLayout.tg.fetchSizeClass(with: .comb(.any, .compact, nil), from: .default)
        menuLayoutSC.tg.orientation(value: .horz)
        menuLayoutSC.tg.width.equal(.wrap)

        let contentLayoutSC = contentLayout.tg.fetchSizeClass(with: .comb(.any, .compact, nil), from: .default)
        contentLayoutSC.tg.height.equal(.fill)
        contentLayoutSC.tg.width.equal(.fill)

        let func1LabelSC = func1Label.tg.fetchSizeClass(with: .comb(.any, .compact, nil))
        let func2LabelSC = func2Label.tg.fetchSizeClass(with: .comb(.any, .compact, nil))
        let func3LabelSC = func3Label.tg.fetchSizeClass(with: .comb(.any, .compact, nil))

        func1LabelSC.tg.width.equal([func2LabelSC.tg.width, func3LabelSC.tg.width])
        func2LabelSC.tg.leading.equal(func1LabelSC.tg.trailing)
        func3LabelSC.tg.leading.equal(func2LabelSC.tg.trailing)
        func1LabelSC.tg.height.equal(contentLayout.tg.height)
        func2LabelSC.tg.height.equal(contentLayout.tg.height)
        func3LabelSC.tg.height.equal(contentLayout.tg.height)

       // 下面是定义在iPad上设备的横屏的界面布局，因为iPad上的SizeClass都是regular，所以这里要区分横竖屏的方法是使用.portrait和.landscape
        let menu1LabelSC = menu1Label.tg.fetchSizeClass(with: .comb(.regular, .regular, .landscape), from: .default)
        menu1LabelSC.tg.height.max(200)

        let menu2LabelSC = menu2Label.tg.fetchSizeClass(with: .comb(.regular, .regular, .landscape), from: .default)
        menu2LabelSC.tg.height.max(200)

        let menu3LabelSC = menu3Label.tg.fetchSizeClass(with: .comb(.regular, .regular, .landscape), from: .default)
        menu3LabelSC.tg.height.max(200)

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
