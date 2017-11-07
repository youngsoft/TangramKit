//
//  PLTest1ViewController.swift
//  TangramKit
//
//  Created by 韩威 on 2016/12/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


/**
 *1.PathLayout - Animations
 */
class PLTest1ViewController: UIViewController {
    
    var myPathLayout: TGPathLayout!
    
    override func loadView() {
        /**
         *  本例子是介绍TGPathLayout布局视图的。用来建立曲线布局。
         */
        
        if #available(iOS 11.0, *) {
        } else {
            // Fallback on earlier versions
            self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        }
        
        myPathLayout = TGPathLayout()
        myPathLayout.backgroundColor = UIColor.white
        view = myPathLayout
        
        /// 因为路径布局里面的点算的都是子视图的中心点，所以为了避免子视图被遮盖这里设置了4个内边距。
        myPathLayout.tg_padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let btn = UIButton(type: .contactAdd)
        btn.addTarget(self, action: #selector(PLTest1ViewController.addAction), for: .touchUpInside)
        myPathLayout.tg_originView = btn
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(PLTest1ViewController.handleStretch1(sender:))),
            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(PLTest1ViewController.handleStretch2(sender:)))
        ]
        
        toolbarItems = [
            UIBarButtonItem.init(title: "Circle", style: .done, target: self, action: #selector(PLTest1ViewController.handleCircle(sender:))),
            
            UIBarButtonItem.init(title: "Arc", style: .plain, target: self, action: #selector(PLTest1ViewController.handleArc(sender:))),
            UIBarButtonItem.init(title: "Arc2", style: .plain, target: self, action: #selector(PLTest1ViewController.handleArc2(sender:))),
            
            UIBarButtonItem.init(title: "Line1", style: .plain, target: self, action: #selector(PLTest1ViewController.handleLine1(sender:))),
            UIBarButtonItem.init(title: "Line2", style: .plain, target: self, action: #selector(PLTest1ViewController.handleLine2(sender:))),
            
            UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            
            UIBarButtonItem.init(title: "Flexed", style: .done, target: self, action: #selector(PLTest1ViewController.handleFlexed(sender:))),
            UIBarButtonItem.init(title: "Fixed", style: .plain, target: self, action: #selector(PLTest1ViewController.handleFixed(sender:))),
            
            UIBarButtonItem.init(title: "Count", style: .plain, target: self, action: #selector(PLTest1ViewController.handleCount(sender:))),
        ]
        
        changeToCircleStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    fileprivate func changeToCircleStyle() {
        myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5) //坐标原点居中。默认y轴往下是正值。。
        myPathLayout.tg_coordinateSetting.isMath = false //为false 表示y轴下是正值。
        myPathLayout.tg_coordinateSetting.isReverse = false //变量为x轴，值为y轴。
        myPathLayout.tg_coordinateSetting.start = 0 //极坐标开始和结束是0和2π。
        myPathLayout.tg_coordinateSetting.end = 2 * .pi

        //提供一个计算圆的极坐标函数。
        myPathLayout.tg_polarEquation = { _ in
            let radius = (self.view.bounds.width - 40) / 2 //半径是视图的宽度 - 两边的左右边距 再除2
            return radius
        }

    }
    
    fileprivate func changeToArcStyle1() {
        
        myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 1)   //坐标原点在视图的左下角。
        myPathLayout.tg_coordinateSetting.isMath = true  //为true 表示y轴往上是正值。
        myPathLayout.tg_coordinateSetting.isReverse = false
        myPathLayout.tg_coordinateSetting.start = nil
        myPathLayout.tg_coordinateSetting.end = nil
        
        //提供一个计算圆弧的极坐标函数
        myPathLayout.tg_polarEquation = { radian in
            let radius = self.view.bounds.width - 40  //半径是视图的宽度 - 两边的左右边距
            if radian.angle >= 0 && radian.angle <= 90 { //angle的单位是弧度，这里我们只处理0度 - 90度之间的路径，其他返回nil。如果coordinateSetting.isMath设置为false则需要把有效角度改为270到360度。
                return radius
            } else {
                return nil //如果我们不想要某个区域或者某个点的值则可以直接函数返回nil
            }
        }
    }
    
    fileprivate func changeToArcStyle2() {
        
        myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 1)   //坐标原点x轴居中，y轴在最下面。
        myPathLayout.tg_coordinateSetting.isMath = true  //为true 表示y轴往上是正值。
        myPathLayout.tg_coordinateSetting.isReverse = false
        myPathLayout.tg_coordinateSetting.start = nil
        myPathLayout.tg_coordinateSetting.end = nil
        
        
        //提供一个计算圆弧的极坐标函数
        myPathLayout.tg_polarEquation = { radian in
            let radius = (self.view.bounds.width - 40) / 2 //半径是视图的宽度 - 两边的左右边距 再除2
            if radian.angle >= 0 && radian.angle <= 180 { //radian的类型是弧度，这里我们只处理0度 - 180度之间的路径，因为用的是数学坐标系
                return radius
            } else {
                return nil //如果我们不想要某个区域或者某个点的值则可以直接函数返回nil
            }
        }
    }
    
    fileprivate func changeToLine1() {
        
        myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 1)   //坐标原点x轴居中，y轴在最下面。
        myPathLayout.tg_coordinateSetting.isMath = true  //为YES 表示y轴往上是正值。
        myPathLayout.tg_coordinateSetting.isReverse = true //这里设置为YES表示方程的入参是y轴的变量，返回的是x轴的值。
        myPathLayout.tg_coordinateSetting.start = 40 //因为最底下的按钮是原点，所以这里要往上偏移40
        myPathLayout.tg_coordinateSetting.end = nil //结束位置默认。
        
        //提供一个  x = 0;  的方程，注意这里面是因为将isReverse设置为YES表示变量为y轴，值为x轴。
        myPathLayout.tg_rectangularEquation = { _ in 0 }
    }
    
    fileprivate func changeToLine2() {
        
        myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 1)   //坐标原点x轴居左，y轴在最下面。
        myPathLayout.tg_coordinateSetting.isMath = true  //为YES 表示y轴往上是正值。
        myPathLayout.tg_coordinateSetting.isReverse = false
        myPathLayout.tg_coordinateSetting.start = 0
        myPathLayout.tg_coordinateSetting.end = nil
        
        //提供一个： y = sqrt(200 * x) + 40的方程。
        myPathLayout.tg_rectangularEquation = { sqrt(200 * $0) + 40 }
    }
    
    let colors: [UIColor] = [.red, .gray, .blue, .orange, .black, .purple]
    
    var randomColor: UIColor {
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }
    
    // MARK: - Actions
    
    @objc func addAction() {
        let btn = UIButton(type: .custom)
        btn.center = myPathLayout.tg_originView!.center
        btn.tg_width.equal(40)
        btn.tg_height.equal(40)
        btn.backgroundColor = randomColor
        
        myPathLayout.insertSubview(btn, at: 0)
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
        
        btn.addTarget(self, action: #selector(PLTest1ViewController.handleDel(sender:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(PLTest1ViewController.handleDrag(sender:)), for: .touchDragInside)
    }
    
    @objc func handleDel(sender: UIButton) {
        sender.tg_useFrame = true
        
        UIView.animate(withDuration: 0.3, animations: {
            
            sender.center = self.myPathLayout.tg_originView!.center
            sender.alpha = 0
            
        }, completion: { _ in
            
            sender.removeFromSuperview()
        })
        
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    @objc func handleDrag(sender: UIButton) {
        //这个效果只有在圆环中才有效果，你拖动时可以通过调整坐标的开始和结束点来很轻易的实现转动的效果。
        myPathLayout.tg_coordinateSetting.start! += .pi/180.0
        myPathLayout.tg_coordinateSetting.end! += .pi/180.0
    }
    
    @objc func handleStretch1(sender: UIBarButtonItem) {
        guard let originView = myPathLayout.tg_originView else {
            return
        }
        
        if sender.style == .plain
        {
            sender.style = .done
            
            let originCenterPoint = originView.center
            
            let pathSuviews = myPathLayout.tg_pathSubviews //只对所有曲线路径中的子视图做动画处理。
            
            for subview in pathSuviews {
                subview.tg_useFrame = true //设置为true表示布局不控制子视图的布局了。
                subview.tg_layoutCompletedDo({ (layout, v) in
                    v.alpha = 0
                    v.center = originCenterPoint
                    v.transform = CGAffineTransform(rotationAngle: .pi)
                })
            }
            myPathLayout.tg_layoutAnimationWithDuration(0.4)
        }
        else
        {
            sender.style = .plain
            
            let pathSuviews = myPathLayout.tg_pathSubviews
            
            for subview in pathSuviews {
                subview.tg_useFrame = false
                subview.tg_layoutCompletedDo({ (layout, v) in
                    v.alpha = 1
                    v.transform = CGAffineTransform.identity
                })
            }
            
            UIView.animate(
                withDuration: 1.5,
                delay: 0,
                usingSpringWithDamping: 0.15,
                initialSpringVelocity: 3.0,
                options: .curveEaseInOut,
                animations: {
                    self.myPathLayout.layoutIfNeeded()
            })
        }
    }
    
    @objc func handleStretch2(sender: UIBarButtonItem) {
        guard let _ = myPathLayout.tg_originView else {
            return
        }
        
        if sender.style == .plain
        {
            sender.style = .done
            
            myPathLayout.tg_beginSubviewPathPoint(full: true) //开始获取所有子视图的路径曲线方法。记得调用getSubviewPathPoint方法前必须要调用beginSubviewPathPoint方法。
            
            let pathSuviews = myPathLayout.tg_pathSubviews
            
            for (i, sbv) in pathSuviews.enumerated().reversed() {
                
                let pts = myPathLayout.tg_getSubviewPathPoint(fromIndex: i, toIndex: 0) //pts返回两个子视图之间的所有点。因为pts是返回两个子视图之间的所有的路劲的点，因此非常适合用来做关键帧动画。
                let ani = CAKeyframeAnimation(keyPath: "position")
                ani.duration = TimeInterval(0.08 * Double(i + 1))
                ani.values = pts
                
                sbv.layer.add(ani, forKey: nil)
                
                UIView.animate(withDuration: TimeInterval(0.08 * Double(i + 1)), animations: { 
                    sbv.alpha = 0
                    sbv.transform = CGAffineTransform(rotationAngle:.pi)
                })
                
            }
            
            myPathLayout.tg_endSubviewPathPoint() //调用完毕后需要调用这个方法来释放一些数据资源。
            
        }
        else
        {
            sender.style = .plain
            
            myPathLayout.tg_beginSubviewPathPoint(full: true)
            
            
            let pathSuviews = myPathLayout.tg_pathSubviews
            
            for (i, sbv) in pathSuviews.enumerated().reversed() {
                
                let pts = myPathLayout.tg_getSubviewPathPoint(fromIndex: 0, toIndex: i) //上面的从i到0，这里是从0到i，因此getSubviewPathPoint方法是可以返回任意两个点之间的路径点的。
                let ani = CAKeyframeAnimation(keyPath: "position")
                ani.duration = TimeInterval(0.08 * Double(i + 1))
                ani.values = pts
                
                sbv.layer.add(ani, forKey: nil)
                
                UIView.animate(withDuration: TimeInterval(0.08 * Double(i + 1)), animations: {
                    sbv.alpha = 1
                    sbv.transform = CGAffineTransform.identity
                })
                
            }
            
            myPathLayout.tg_endSubviewPathPoint() //调用完毕后需要调用这个方法来释放一些数据资源。
        }

    }
    
    @objc func handleCircle(sender: UIBarButtonItem) {
        toolbarItems?[0].style = .done
        toolbarItems?[1].style = .plain
        toolbarItems?[2].style = .plain
        toolbarItems?[3].style = .plain
        toolbarItems?[4].style = .plain
        
        changeToCircleStyle()
        
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    @objc func handleArc(sender: UIBarButtonItem) {
        toolbarItems?[0].style = .plain
        toolbarItems?[1].style = .done
        toolbarItems?[2].style = .plain
        toolbarItems?[3].style = .plain
        toolbarItems?[4].style = .plain
        
        changeToArcStyle1()
        
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }

    @objc func handleArc2(sender: UIBarButtonItem) {
        toolbarItems?[0].style = .plain
        toolbarItems?[1].style = .plain
        toolbarItems?[2].style = .done
        toolbarItems?[3].style = .plain
        toolbarItems?[4].style = .plain
        
        changeToArcStyle2()
        
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    @objc func handleLine1(sender: UIBarButtonItem) {
        toolbarItems?[0].style = .plain
        toolbarItems?[1].style = .plain
        toolbarItems?[2].style = .plain
        toolbarItems?[3].style = .done
        toolbarItems?[4].style = .plain
        
        changeToLine1()
        
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    @objc func handleLine2(sender: UIBarButtonItem) {
        toolbarItems?[0].style = .plain
        toolbarItems?[1].style = .plain
        toolbarItems?[2].style = .plain
        toolbarItems?[3].style = .plain
        toolbarItems?[4].style = .done
        
        changeToLine2()
        
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    
    @objc func handleFlexed(sender: UIBarButtonItem) {
        toolbarItems?[6].style = .done
        toolbarItems?[7].style = .plain
        toolbarItems?[8].style = .plain
        
        myPathLayout.tg_spaceType = .flexed //表示路径布局视图里面的子视图的间距会根据路径曲线自动的调整。
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    @objc func handleFixed(sender: UIBarButtonItem) {
        toolbarItems?[6].style = .plain
        toolbarItems?[7].style = .done
        toolbarItems?[8].style = .plain
        
        myPathLayout.tg_spaceType = .fixed(100) //表示路径布局视图里面的子视图的间距是固定为80的。
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    @objc func handleCount(sender: UIBarButtonItem) {
        toolbarItems?[6].style = .plain
        toolbarItems?[7].style = .plain
        toolbarItems?[8].style = .done
        
        myPathLayout.tg_spaceType = .count(6) //表示路径布局视图里面的子视图的间距会根据尺寸和数量为10来调整。
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }

}

