//
//  PLTest3ViewController.swift
//  TangramKit
//
//  Created by 韩威 on 2016/12/12.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

//class PLTest3View: TGRelativeLayout {
//    init(withImageName imageName: String, title: String, index: Int) {
//        super.init()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class PLTest3ViewController: UIViewController {
    
    func angle(_ r: CGFloat) -> CGFloat {
        return r / 180.0 * CGFloat.pi
    }

    var myPathLayout: TGPathLayout!
    
    override func loadView() {
        myPathLayout = TGPathLayout()
        view = myPathLayout
        
        myPathLayout.tg_backgroundImage = #imageLiteral(resourceName: "bk1")
        myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5)
        myPathLayout.tg_coordinateSetting.start = angle(-90)
        myPathLayout.tg_coordinateSetting.end = angle(270)
        myPathLayout.tg_padding = UIEdgeInsets.init(top: 30, left: 30, bottom: 30, right: 30)
        // CGFloat radius = (CGRectGetWidth(weakPathLayout.bounds) - 60) / 2;  //半径为视图的宽度减去两边的内边距30再除2。这里需要注意block的循环引用的问题。
        myPathLayout.tg_polarEquation = { [weak myPathLayout] (_) -> CGFloat? in
            (myPathLayout!.bounds.width - 60) / 2
        }
        
        let btn = UIButton.init(type: .custom)
        btn.setTitle("Click me", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.8332832456, green: 0.1707184911, blue: 0.146825999, alpha: 1)
        btn.addTarget(self, action: #selector(PLTest3ViewController.handleClick(sender:)), for: .touchUpInside)
        
        btn.tg_width.equal(myPathLayout, increment: -30, multiple: 0.5) //宽度是父视图宽度的一半再减去30
        btn.tg_layoutCompletedDo { (layout, sbv) in
            //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            sbv.layer.borderWidth = sbv.frame.width / 2
            sbv.tg_height.equal(sbv.tg_width)
        }
        
        myPathLayout.tg_originView = btn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleClick(sender: UIButton) {
        
    }

}
