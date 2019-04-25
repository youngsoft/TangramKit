//
//  PLTest2ViewController.swift
//  TangramKit
//
//  Created by 韩威 on 2016/12/12.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 * 您可以重载TGPathLayout，并重载其中的layerClass属性，返回一个CAShapeLayer类，并且在初始化时设置这个类的属性，这样系统和就会自动生成一条和路径布局一致的曲线了。
 */
class TGLocusPathLayout: TGPathLayout {
    
    override class var layerClass: Swift.AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        let shapeLayer = layer as! CAShapeLayer
        //您可以在这里设置路径曲线的颜色、大小、填充方案等等。
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = nil
    }

}

/**
 *2.PathLayout - Curves
 */
class PLTest2ViewController: UIViewController {
    
    var myPathLayout: TGLocusPathLayout!
    
    override func loadView() {
        let scrollView = UIScrollView()
        view = scrollView
        
        myPathLayout = TGLocusPathLayout()
        myPathLayout.backgroundColor = .white
        myPathLayout.tg_height.equal(.wrap).min(scrollView).and().tg_width.equal(.wrap).min(scrollView) // 这里用了 and() 用于链式语法
        myPathLayout.tg_padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        scrollView.addSubview(myPathLayout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(PLTest2ViewController.handleRevrse(sender:))),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(PLTest2ViewController.handleAction(sender:))),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PLTest2ViewController.handleAdd(sender:)))
        ]
        
        changeFunc(index: .straight_line)
    }
    
    @objc func handleRevrse(sender: UIBarButtonItem) {
        myPathLayout.tg_coordinateSetting.isReverse = !myPathLayout.tg_coordinateSetting.isReverse
        myPathLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    enum CurveType: String {
        case straight_line
        case sin
        case cycloid
        case spiral_like
        case cardioid
        case astroid
        case cancle
    }
    
    let titles: [CurveType] = [.straight_line, .sin, .cycloid, .spiral_like, .cardioid, .astroid, .cancle]
    
    @objc func handleAction(sender: UIBarButtonItem) {
        
        let sheet = UIAlertController(title: "Curve Type", message: nil, preferredStyle: .actionSheet)
        
        for title in titles {
            var style: UIAlertAction.Style = .default
            if title == .cancle {
                style = .cancel
            }
            
            let action = UIAlertAction(title: title.rawValue, style: style, handler: { action in
                
                switch action.title! {
                case "straight_line":
                    self.actionSheetAction(type: .straight_line)
                case "sin":
                    self.actionSheetAction(type: .sin)
                case "cycloid":
                    self.actionSheetAction(type: .cycloid)
                case "spiral_like":
                    self.actionSheetAction(type: .spiral_like)
                case "cardioid":
                    self.actionSheetAction(type: .cardioid)
                case "astroid":
                    self.actionSheetAction(type: .astroid)
                case "cancle": break
                default: break
                }
            })
            
            sheet.addAction(action)
        }
        
        present(sheet, animated: true, completion: nil)
        
    }
    
    let colors: [UIColor] = [.red, .gray, .blue, .orange, .black, .purple]
    
    var randomColor: UIColor {
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }
    
    @objc func handleAdd(sender: UIBarButtonItem) {
        
        var pt = CGPoint.zero
        if myPathLayout.tg_pathSubviews.count > 0 {
            //这里不取subviews的原因是，有可能会出现设置了原点视图的情况。
            pt = myPathLayout.tg_pathSubviews.last!.frame.origin
        }
        
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.center = pt
        btn.tg_width.equal(40)
        btn.tg_height.equal(40)
        btn.backgroundColor = randomColor
        btn.addTarget(self, action: #selector(PLTest2ViewController.handleDel(sender:)), for: .touchUpInside)
        
        myPathLayout.addSubview(btn)
        
        myPathLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    @objc func handleDel(sender: UIButton) {
        sender.removeFromSuperview()
        myPathLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    func actionSheetAction(type: CurveType) {
        changeFunc(index: type)
        myPathLayout.setNeedsLayout()
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    func changeFunc(index of: CurveType) {
        
        switch of {
        case .straight_line: //直线函数 y = a * x + b;
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 0)
            myPathLayout.tg_coordinateSetting.isMath = false
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(60)
            myPathLayout.tg_rectangularEquation = { $0 * 2 }
            
        case .sin: //正玄函数 y = sin(x);
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(60)
            myPathLayout.tg_rectangularEquation = { 100 * sin(TGRadian(angle:$0).value) }  //TGRadian是角度转化为弧度的类
            
        case .cycloid: //摆线函数, 用参数方程： x = a * (t - sin(t); y = a *(1 - cos(t));
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(100)
            myPathLayout.tg_parametricEquation = {
                let t = TGRadian(angle:$0).value
                let a: CGFloat = 50
                return CGPoint(x: a * (t - sin(t)), y: a * (1 - cos(t)))
            }
            
        case .spiral_like: //阿基米德螺旋线函数: r = a * θ   用的是极坐标。
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = false
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(60)
            myPathLayout.tg_polarEquation = { 20 * $0 }
            
        case .cardioid: //心形线 r = a *(1 + cos(θ)
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.2, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .flexed
            myPathLayout.tg_polarEquation = { 120 * (1 + cos(CGFloat($0))) }
            
        case .astroid: //星型线 x = a * cos^3(θ); y =a * sin^3(θ);
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = 0
            myPathLayout.tg_coordinateSetting.end = 360
            myPathLayout.tg_spaceType = .flexed
            myPathLayout.tg_parametricEquation = { CGPoint(x: 150 * pow(cos(TGRadian(angle:$0).value), 3), y: 150 * pow(sin(TGRadian(angle:$0).value), 3)) }
            
        default: break
            
        }
    }

}
