//
//  PLTest4ViewController.swift
//  TangramKit
//
//  Created by 韩威 on 2016/12/12.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class PLTest4ViewController: UIViewController {
    
    var myPathLayout: TGPathLayout!

    override func loadView() {
        myPathLayout = TGPathLayout()
        view = myPathLayout
        
        myPathLayout.backgroundColor = UIColor.lightGray
        myPathLayout.tg_leftPadding = 20
        myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 0.5)
        myPathLayout.tg_coordinateSetting.start = TGRadian(angle:-60).value
        myPathLayout.tg_coordinateSetting.end = TGRadian(angle:60).value
        myPathLayout.tg_distanceError = 0.01 //因为曲线半径非常的小，为了要求高精度的距离间距，所以要把距离误差调整的非常的小。
        myPathLayout.tg_polarEquation = { _ in 1.0 }
        
        let btn = UIButton.init(type: .contactAdd)
        btn.backgroundColor = UIColor.darkGray
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(PLTest4ViewController.handleAction(sender:)), for: .touchUpInside)
        myPathLayout.tg_originView = btn
        
        for i in 0..<9 {
            let label = UILabel()
            label.layer.anchorPoint = CGPoint(x: 0.05, y: 0.5)
            label.tg_left.equal(-1)
            label.tg_width.equal(200).and().tg_height.equal(30)
            
            label.text = "Text: \(i)"
            label.textAlignment = .right
            label.backgroundColor = .white
            label.layer.cornerRadius = 2
            label.layer.shadowColor = UIColor.darkGray.cgColor
            label.layer.shadowOffset = CGSize.zero
            label.layer.shadowRadius = 3
            label.layer.shadowOpacity = 0.5
            
            label.tg_layoutCompletedDo({ (layout, v) in
                let pLayout = layout as! TGPathLayout
                let _angle = pLayout.tg_argumentFrom(subview: v)!//TGPathLayout的argumentFrom方法能够取得子视图在曲线上的点的方程函数的自变量的输入的值。
                print("angle = \(_angle)")
                
                v.transform = CGAffineTransform.init(rotationAngle: -1 * _angle)
            })
            
            myPathLayout.addSubview(label)
        }
        
    }
    
    func handleAction(sender: UIButton) {
        
        if sender.isSelected {
            
            for (i, sbv) in myPathLayout.tg_pathSubviews.enumerated() {
                
                let duration: TimeInterval = 0.9 / 9.0 * Double(myPathLayout.tg_pathSubviews.count - i)
                let delay: TimeInterval = 0.9 / 9.0 * Double(i)
                
                UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {

                    sbv.transform = CGAffineTransform.init(rotationAngle: -1 * self.myPathLayout.tg_argumentFrom(subview: sbv)!)
                    
                }, completion: { (_) in
                    
                    sbv.tg_useFrame = false
                })
            }
            
        } else {
            
            for (i, sbv) in myPathLayout.tg_pathSubviews.enumerated().reversed() {
                
                sbv.tg_useFrame = true //动画前防止调整可能引起重新布局，因此这里要设置为YES，不让这个子视图重新布局。
                
                let duration: TimeInterval = 0.9 / 9.0 * Double(myPathLayout.tg_pathSubviews.count - i)
                let delay: TimeInterval = 0.9 / 9.0
                
                UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
                    sbv.transform = CGAffineTransform.init(rotationAngle: -.pi/2)
                    
                })
            }
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
