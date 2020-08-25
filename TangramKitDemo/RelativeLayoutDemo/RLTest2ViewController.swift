//
//  RLTest2ViewController.swift
//  TangramKit
//
//  Created by zhangguangkai on 16/5/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 * 2.RelativeLayout - Prorate size
 */
class RLTest2ViewController: UIViewController {

    weak var visibilityButton: UIButton!
    weak var visibilitySwitch: UISwitch!
    
    
    func createButton(_ title: String, backgroundColor color: UIColor) -> UIButton {
        let v = UIButton()
        v.backgroundColor = color
        v.setTitle(title, for: .normal)
        v.setTitleColor(CFTool.color(4), for: .normal)
        v.titleLabel!.font = CFTool.font(14)
        v.titleLabel!.numberOfLines = 2
        v.titleLabel!.adjustsFontSizeToFitWidth = true
        v.layer.shadowOffset = CGSize(width: CGFloat(3), height: CGFloat(3))
        v.layer.shadowColor = CFTool.color(4).cgColor
        v.layer.shadowRadius = 2
        v.layer.shadowOpacity = 0.3
        return v
    }
    
    override func loadView()
    {
        /*
         这个例子展示的是相对布局里面 多个子视图按比例分配宽度或者高度的实现机制，通过对子视图扩展的TGLayoutSize尺寸对象的equal方法的值设置为一个数组对象，即可实现尺寸的按比例分配能力。而这个方法要比AutoLayout实现起来要简单的多。
         */
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        
        let rootLayout = TGRelativeLayout()
        rootLayout.tg.trailingPadding(value: 10)
        rootLayout.backgroundColor = .white
        self.view = rootLayout
        
        let visibilitySwitch = UISwitch()
        visibilitySwitch.tg.trailing.equal(0)
        visibilitySwitch.tg.top.equal(10)
        rootLayout.addSubview(visibilitySwitch)
        self.visibilitySwitch = visibilitySwitch
        
        let visibilitySwitchLabel = UILabel()
        visibilitySwitchLabel.text = NSLocalizedString("flex size when subview hidden switch:", comment:"")
        visibilitySwitchLabel.textColor = CFTool.color(4)
        visibilitySwitchLabel.font = CFTool.font(15)
        visibilitySwitchLabel.sizeToFit()
        visibilitySwitchLabel.tg.leading.equal(10)
        visibilitySwitchLabel.tg.centerY.equal(visibilitySwitch.tg.centerY)
        rootLayout.addSubview(visibilitySwitchLabel)
        
        /**水平平分3个子视图**/
        let v1 = self.createButton(NSLocalizedString("average 1/3 width\nturn above switch", comment: ""), backgroundColor: CFTool.color(5))
        v1.tg.height.equal(40)
        v1.tg.top.equal(60)
        v1.tg.leading.equal(10)
        rootLayout.addSubview(v1)
        
        let v2 = self.createButton(NSLocalizedString("average 1/3 width\nhide me", comment: ""), backgroundColor: CFTool.color(6))
        v2.addTarget(self, action: #selector(handleHidden), for: .touchUpInside)
        v2.tg.height.equal(v1.tg.height)
        v2.tg.top.equal(v1.tg.top)
        v2.tg.leading.equal(v1.tg.trailing, offset:10)
        rootLayout.addSubview(v2)
        self.visibilityButton = v2
        
        let v3 = self.createButton(NSLocalizedString("average 1/3 width\nshow me", comment: ""), backgroundColor: CFTool.color(7))
        v3.addTarget(self, action:#selector(handleShow), for: .touchUpInside)
        v3.tg.height.equal(v1.tg.height)
        v3.tg.top.equal(v1.tg.top)
        v3.tg.leading.equal(v2.tg.trailing, offset:10)
        rootLayout.addSubview(v3)
        
        //v1,v2,v3平分父视图的宽度。因为每个子视图之间都有10的间距，因此平分时要减去这个间距值。这里的宽度通过设置等于数组来完成均分。
        v1.tg.width.equal([v2.tg.width.add(-10),v3.tg.width.add(-10)], increment:-10)
        
        /**某个视图宽度固定其他平分**/
        let v4 = self.createButton(NSLocalizedString("width equal to 260", comment: ""), backgroundColor: CFTool.color(5))
        v4.tg.top.equal(v1.tg.bottom, offset:30)
        v4.tg.leading.equal(10)
        v4.tg.height.equal(40)
        v4.tg.width.equal(160)  //第一个视图宽度固定
        rootLayout.addSubview(v4)
        
        let v5 =  self.createButton(NSLocalizedString("1/2 with of free superview", comment: ""), backgroundColor: CFTool.color(6))
        v5.tg.top.equal(v4.tg.top)
        v5.tg.leading.equal(v4.tg.trailing, offset:10)
        v5.tg.height.equal(v4.tg.height)
        rootLayout.addSubview(v5)
        
        let v6 = self.createButton(NSLocalizedString("1/2 with of free superview", comment: ""), backgroundColor: CFTool.color(7))
        v6.tg.top.equal(v4.tg.top)
        v6.tg.leading.equal(v5.tg.trailing, offset:10)
        v6.tg.height.equal(v4.tg.height)
        rootLayout.addSubview(v6)
        
        //v4固定宽度,v5,v6按一定的比例来平分父视图的宽度，这里同样也是因为每个子视图之间有间距，因此都要减10
        v5.tg.width.equal([v4.tg.width.add(-10), v6.tg.width.add(-10)], increment:-10)
        
        /**子视图按比例平分**/
        let v7 = self.createButton(NSLocalizedString("20% with of superview", comment: ""), backgroundColor: CFTool.color(5))
        v7.tg.top.equal(v4.tg.bottom, offset:30)
        v7.tg.leading.equal(10)
        v7.tg.height.equal(40)
        rootLayout.addSubview(v7)
        
        let v8 = self.createButton(NSLocalizedString("30% with of superview", comment: ""), backgroundColor: CFTool.color(6))
        v8.tg.top.equal(v7.tg.top)
        v8.tg.leading.equal(v7.tg.trailing, offset:10)
        v8.tg.height.equal(v7.tg.height)
        rootLayout.addSubview(v8)
        
        let v9 = self.createButton(NSLocalizedString("50% with of superview", comment: ""), backgroundColor: CFTool.color(7))
        v9.tg.top.equal(v7.tg.top)
        v9.tg.leading.equal(v8.tg.trailing, offset:10)
        v9.tg.height.equal(v7.tg.height)
        rootLayout.addSubview(v9)
        
        //v7,v8,v9按照2：3：5的比例均分父视图。这里统一减去10的目的是每个子视图之间还要保留出10的间距。
        v7.tg.width.equal([v8.tg.width.multiply(0.3).add(-10), v9.tg.width.multiply(0.5).add(-10)], increment:-10, multiple:0.2)
        
        
        /*
         下面部分是一个高度均分的实现方法。
         */
        let bottomLayout = TGRelativeLayout()
        bottomLayout.backgroundColor = CFTool.color(0)
        bottomLayout.tg.leading.equal(10)
        bottomLayout.tg.trailing.equal(0)
        bottomLayout.tg.top.equal(v7.tg.bottom, offset:30)
        bottomLayout.tg.bottom.equal(10)
        rootLayout.addSubview(bottomLayout)
        
        let v10 = self.createButton("1/2", backgroundColor: CFTool.color(5))
        v10.tg.width.equal(40)
        v10.tg.trailing.equal(bottomLayout.tg.centerX, offset:50)
        v10.tg.top.equal(10)
        bottomLayout.addSubview(v10)
        
        let v11 = self.createButton("1/2", backgroundColor: CFTool.color(6))
        v11.tg.width.equal(v10.tg.width)
        v11.tg.trailing.equal(v10.tg.trailing)
        v11.tg.top.equal(v10.tg.bottom, offset:10)
        bottomLayout.addSubview(v11)

        //V10,V11实现了高度均分
        v10.tg.height.equal([v11.tg.height.add(-20)], increment:-10)
        
        
        let v12 = self.createButton("1/3", backgroundColor: CFTool.color(5))
        v12.tg.width.equal(40)
        v12.tg.leading.equal(bottomLayout.tg.centerX, offset:50)
        v12.tg.top.equal(10)
        bottomLayout.addSubview(v12)
        
        let v13 = self.createButton("1/3", backgroundColor: CFTool.color(6))
        v13.tg.width.equal(v12.tg.width)
        v13.tg.leading.equal(v12.tg.leading)
        v13.tg.top.equal(v12.tg.bottom,offset:10)
        bottomLayout.addSubview(v13)
        
        let v14 = self.createButton("1/3", backgroundColor: CFTool.color(7))
        v14.tg.width.equal(v12.tg.width)
        v14.tg.leading.equal(v12.tg.leading)
        v14.tg.top.equal(v13.tg.bottom, offset:10)
        bottomLayout.addSubview(v14)
        
        //注意这里最后一个偏移-20，也能达到和底部边距的效果。
        v12.tg.height.equal([v13.tg.height.add(-10), v14.tg.height.add(-20)], increment:-10)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - Handle Method
extension RLTest2ViewController
{
    
    @objc func handleHidden(_ sender: UIButton) {
        
        if self.visibilitySwitch.isOn
        {
            self.visibilityButton.tg.visibility(value: .gone)
        }
        else
        {
            self.visibilityButton.tg.visibility(value: .invisible)
        }
        
    }
    
    @objc func handleShow(_ sender: UIButton) {

        self.visibilityButton.tg.visibility(value: .visible)
    }

}
