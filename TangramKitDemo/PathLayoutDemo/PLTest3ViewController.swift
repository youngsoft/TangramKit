//
//  PLTest3ViewController.swift
//  TangramKit
//
//  Created by 韩威 on 2016/12/12.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class PLTest3View: TGRelativeLayout {

    var circleView: TGPathLayout!

    convenience init(frame: CGRect, imageName: String, title: String, index: Int) {
        self.init(frame: frame)

        tg.height.equal(.wrap)
        tg.width.equal(.wrap)

        circleView = TGPathLayout()
        circleView.tg.width.equal(60).and().tg.height.equal(60)
        circleView.layer.cornerRadius = 30
        circleView.backgroundColor = .lightGray
        circleView.tg.coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5)
        circleView.tg.polarEquation(value: { _ in 30})
        addSubview(circleView)

        let numLabel = UILabel()
        numLabel.tg.width.equal(15).and().tg.height.equal(15)
        numLabel.layer.cornerRadius = 7.5
        numLabel.clipsToBounds = true
        numLabel.backgroundColor = UIColor.white
        numLabel.text = "\(index)"
        numLabel.textAlignment = .center
        circleView.addSubview(numLabel)

        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.sizeToFit()
        imageView.tg.centerX.equal(circleView).and().tg.centerY.equal(circleView)
        addSubview(imageView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.darkGray
        titleLabel.sizeToFit()
        titleLabel.tg.centerX.equal(circleView)
        titleLabel.tg.top.equal(circleView.tg.bottom, offset: 10)
        addSubview(titleLabel)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/**
 *3.PathLayout - Menu in Circle
 */
class PLTest3ViewController: UIViewController {

    var myPathLayout: TGPathLayout!

    override func loadView() {

        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        myPathLayout = TGPathLayout()
        view = myPathLayout

        myPathLayout.tg.backgroundImage(value: #imageLiteral(resourceName: "bk1"))
        myPathLayout.tg.coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5)
        // -90°.value 等同于 TGRadian(angle:-90).value，这是简易写法
        myPathLayout.tg.coordinateSetting.start = -90°.value //极坐标必须用弧度值
        myPathLayout.tg.coordinateSetting.end = 270°.value
        myPathLayout.tg.padding(value: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        myPathLayout.tg.polarEquation(value: { [weak myPathLayout] (_) -> CGFloat? in
            (myPathLayout!.bounds.width - 60) / 2 //半径为视图的宽度减去两边的内边距30再除2。这里需要注意block的循环引用的问题。
        })

        let btn = UIButton(type: .custom)
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.3991502736, blue: 0.3945200147, alpha: 1)
        btn.setTitle("Click me", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(PLTest3ViewController.handleClick(sender:)), for: .touchUpInside)

        btn.tg.width.equal(myPathLayout, increment: -30, multiple: 0.5) //宽度是父视图宽度的一半再减去30
        btn.tg.layoutCompleted { (_, sbv) in
            //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            sbv.layer.cornerRadius = sbv.frame.width / 2
            sbv.tg.height.equal(sbv.frame.width)
        }

        myPathLayout.tg.originView(value: btn)

        let images = ["section1", "section2", "section3"]
        let titles = ["Fllow", "WatchList", "Add", "Center", "Del", "Search", "Other"]

        for (i, title) in titles.enumerated() {

            let image = images[Int(arc4random_uniform(UInt32(images.count)))]

            let plView = PLTest3View(frame: CGRect.zero,
                                      imageName: image,
                                          title: title,
                                          index: i)
            plView.tg.layoutCompleted({ (layout, sbv) in
                let vplv = sbv as! PLTest3View
                let vLayout = layout as! TGPathLayout

                let arg = vLayout.tg.argumentFrom(subview: vplv) //TGPathLayout中的argumentFrom方法的作用是返回子视图在路径布局时所定位的点的自变量的值。上面因为我们用的是极坐标方程来算出每个子视图的位置，因此这里的argumentFrom方法返回的就是子视图所定位的角度。又因为我们的圆环角度是从270度开始的。而PLTest3View的圆环里面的numLabel的初始值又是从180度开始的，所以这里相差了刚好一个M_PI的值，所以我们这里把sbv所在的角度减去M_PI,就是PLTest3View里面的numLabel的开始的角度。
                vplv.circleView.tg.coordinateSetting.start = arg! - .pi
            })

            myPathLayout.addSubview(plView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @objc func handleClick(sender: UIButton) {

        //例子中一共有7个子视图。因此每次旋转都是增加 360 / 7度。如果您要实现拖拽进行调整位置时，也只需要动态改变坐标的开始和结束位置就可以了。
        myPathLayout.tg.coordinateSetting.start! += 2 * CGFloat.pi / CGFloat(myPathLayout.tg.pathSubviews.count)
        myPathLayout.tg.coordinateSetting.end! += 2 * CGFloat.pi / CGFloat(myPathLayout.tg.pathSubviews.count)

        //因为角度的改变，所以这里也要激发PLTest3View里面的numLabel的角度的调整。

        for view in myPathLayout.tg.pathSubviews {

            view.tg.layoutCompleted({ (layout, sbv) in

                let vplv = sbv as! PLTest3View
                let vLayout = layout as! TGPathLayout

                let arg = vLayout.tg.argumentFrom(subview: vplv) //TGPathLayout中的argumentFrom方法的作用是返回子视图在路径布局时所定位的点的自变量的值。上面因为我们用的是极坐标方程来算出每个子视图的位置，因此这里的argumentFrom方法返回的就是子视图所定位的角度。又因为我们的圆环角度是从270度开始的。而PLTest3View的圆环里面的numLabel的初始值又是从180度开始的，所以这里相差了刚好一个M_PI的值，所以我们这里把sbv所在的角度减去M_PI,就是PLTest3View里面的numLabel的开始的角度
                vplv.circleView.tg.coordinateSetting.start = arg! - .pi

                vplv.circleView.tg.layoutAnimationWithDuration(0.2)
            })
        }

        myPathLayout.tg.layoutAnimationWithDuration(0.3)
    }

}
