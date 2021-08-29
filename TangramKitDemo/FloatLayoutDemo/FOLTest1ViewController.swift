//
//  FOLTest1ViewController.swift
//  TangramKit
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 * 1.FloatLayout - Float
 */
class FOLTest1ViewController: UIViewController {

    weak var floatLayout: TGFloatLayout!
    weak var whTextField: UITextField!
    weak var reverseFloatSwitch: UISwitch!
    weak var clearFloatSwitch: UISwitch!
    weak var widthWeightStepper: UIStepper!
    weak var widthWeightLabel: UILabel!
    weak var heightWeightStepper: UIStepper!
    weak var heightWeightLabel: UILabel!

    override func loadView() {

        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        let rootLayout = TGFloatLayout(.vert)
        rootLayout.backgroundColor = .white
        self.view = rootLayout

        let adjOriButton = UIButton(type: .system)
        adjOriButton.setTitle("Orien", for: .normal)
        adjOriButton.sizeToFit()
        adjOriButton.addTarget(self, action: #selector(handleChangeOrientation), for: .touchUpInside)
        adjOriButton.tg.reverseFloat(value: true) //向右浮动。
        adjOriButton.tg.trailing.equal(10)
        adjOriButton.tg.leading.equal(10)
        rootLayout.addSubview(adjOriButton)

        let addViewButton = UIButton(type: .system)
        addViewButton.setTitle("Add View", for: .normal)
        addViewButton.sizeToFit()
        addViewButton.addTarget(self, action: #selector(handleAddSubview), for: .touchUpInside)
        addViewButton.tg.reverseFloat(value: true)  //向右浮动
        addViewButton.tg.trailing.equal(10)
        addViewButton.tg.leading.equal(10)
        rootLayout.addSubview(addViewButton)

        let tempwhTextField = UITextField()
        tempwhTextField.borderStyle = .roundedRect
        tempwhTextField.placeholder = "input:width,height"
        tempwhTextField.tg.height.equal(30)
        tempwhTextField.tg.width.equal(.fill)   //宽度占用剩余空间。
        tempwhTextField.tg.leading.equal(5)
        tempwhTextField.tg.top.equal(5)
        tempwhTextField.tg.bottom.equal(5)
        rootLayout.addSubview(tempwhTextField)
        self.whTextField = tempwhTextField

        let reverseFloatTip = UILabel()
        reverseFloatTip.text = "Reverse:"
        reverseFloatTip.font = CFTool.font(13)
        reverseFloatTip.sizeToFit()
        reverseFloatTip.tg.clearFloat(value: true)  //换行
        reverseFloatTip.tg.top.equal(3)
        reverseFloatTip.tg.leading.equal(5)
        reverseFloatTip.tg.trailing.equal(5)
        rootLayout.addSubview(reverseFloatTip)

        let reverseFloatSwitch = UISwitch()
        rootLayout.addSubview(reverseFloatSwitch)
        self.reverseFloatSwitch = reverseFloatSwitch

        let clearFloatTip = UILabel()
        clearFloatTip.text = "Clear:"
        clearFloatTip.font = CFTool.font(13)
        clearFloatTip.sizeToFit()
        clearFloatTip.tg.leading.equal(40)
        clearFloatTip.tg.top.equal(3)
        clearFloatTip.tg.trailing.equal(5)
        rootLayout.addSubview(clearFloatTip)

        let clearFloatSwitch = UISwitch()
        rootLayout.addSubview(clearFloatSwitch)
        self.clearFloatSwitch = clearFloatSwitch

        let widthWeightStepperTip = UILabel()
        widthWeightStepperTip.text = "Width Weight:"
        widthWeightStepperTip.font = CFTool.font(13)
        widthWeightStepperTip.sizeToFit()
        widthWeightStepperTip.tg.top.equal(8)
        widthWeightStepperTip.tg.clearFloat(value: true)  //换行
        rootLayout.addSubview(widthWeightStepperTip)

        let widthWeightStepper = UIStepper()
        widthWeightStepper.minimumValue = 0
        widthWeightStepper.stepValue = 1
        widthWeightStepper.maximumValue = 100
        widthWeightStepper.addTarget(self, action: #selector(handleWeightStepper(_:)), for: .valueChanged)
        widthWeightStepper.tg.top.equal(5)
        rootLayout.addSubview(widthWeightStepper)
        self.widthWeightStepper = widthWeightStepper

        let widthWeightLabel = UILabel()
        widthWeightLabel.text = "0"
        widthWeightLabel.tg.top.equal(8)
        widthWeightLabel.sizeToFit()
        rootLayout.addSubview(widthWeightLabel)
        self.widthWeightLabel = widthWeightLabel

        let heightWeightStepperTip = UILabel()
        heightWeightStepperTip.text = "Height Weight:"
        heightWeightStepperTip.font = CFTool.font(13)
        heightWeightStepperTip.sizeToFit()
        heightWeightStepperTip.tg.top.equal(8)
        heightWeightStepperTip.tg.clearFloat(value: true)  //换行
        rootLayout.addSubview(heightWeightStepperTip)

        let heightWeightStepper = UIStepper()
        heightWeightStepper.minimumValue = 0
        heightWeightStepper.stepValue = 1
        heightWeightStepper.maximumValue = 100
        heightWeightStepper.addTarget(self, action: #selector(handleWeightStepper(_:)), for: .valueChanged)
        heightWeightStepper.tg.top.equal(5)
        rootLayout.addSubview(heightWeightStepper)
        self.heightWeightStepper = heightWeightStepper

        let heightWeightLabel = UILabel()
        heightWeightLabel.text = "0"
        heightWeightLabel.sizeToFit()
        heightWeightLabel.tg.top.equal(8)
        rootLayout.addSubview(heightWeightLabel)
        self.heightWeightLabel = heightWeightLabel

        let floatLayout = TGFloatLayout(.vert)
        floatLayout.backgroundColor = CFTool.color(0)
        floatLayout.tg.clearFloat(value: true)  //换行
        floatLayout.tg.padding(value: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        floatLayout.tg.width.equal(100%)   //高度和宽度都占用剩余空间。
        floatLayout.tg.height.equal(.fill)
        rootLayout.addSubview(floatLayout)
        self.floatLayout = floatLayout

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func createTagButton(_ text: String) {
        //你可以输入: “宽,高” 来指定一个视图的宽度和高度
        //你也可以输入: “宽,高,左边距,上边距,右边距,下边距“ 来指定一个视图的尺寸和边距。

        let arr = text.components(separatedBy: ",")
        if arr.count != 2 && arr.count != 6 {
            return
        }

        let tagButton = UIButton(frame: CGRect(x: 0, y: 0, width: CGFloat(atof(arr[0])), height: CGFloat(atof(arr[1]))))
        tagButton.setTitle(text, for: UIControl.State())
        tagButton.titleLabel?.adjustsFontSizeToFitWidth = true
        tagButton.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1)

        tagButton.addTarget(self, action: #selector(FOLTest1ViewController.handleDelTag(_:)), for: .touchUpInside)
        self.floatLayout.addSubview(tagButton)

        if arr.count == 6 {
            tagButton.tg.leading.equal(CGFloat(atof(arr[2])))
            tagButton.tg.top.equal(CGFloat(atof(arr[3])))
            tagButton.tg.trailing.equal(CGFloat(atof(arr[4])))
            tagButton.tg.bottom.equal(CGFloat(atof(arr[5])))

        }

        tagButton.tg.reverseFloat(value: self.reverseFloatSwitch.isOn)
        tagButton.tg.clearFloat(value: self.clearFloatSwitch.isOn)
        if self.widthWeightStepper.value != 0 {
           tagButton.tg.width.equal(TGWeight(self.widthWeightStepper.value))
        }

        if self.heightWeightStepper.value != 0 {
            tagButton.tg.height.equal(TGWeight(self.heightWeightStepper.value))

        }

        self.widthWeightStepper.value = 0
        self.widthWeightLabel.text = "0"

        self.heightWeightStepper.value = 0
        self.heightWeightLabel.text = "0"

        self.reverseFloatSwitch.isOn = false
        self.clearFloatSwitch.isOn = false

        self.floatLayout.tg.layoutAnimationWithDuration(0.3)
    }

    @objc func handleAddSubview(_ sender: AnyObject) {

        if self.whTextField.text!.isEmpty {
            return
        }

        self.createTagButton(self.whTextField.text!)

        self.whTextField.text = ""

    }

    @objc func handleChangeOrientation(_ sender: AnyObject) {

        //调整布局方向
        if self.floatLayout.tg.orientation() == .vert {
            self.floatLayout.tg.orientation(value: .horz)
        } else {
            self.floatLayout.tg.orientation(value: .vert)
        }

        self.floatLayout.tg.layoutAnimationWithDuration(0.3)

    }

    @objc func handleWeightStepper(_ sender: UIStepper) {

        if sender == self.widthWeightStepper {
            self.widthWeightLabel.text = String(sender.value)
            self.widthWeightLabel.sizeToFit()

        } else {
            self.heightWeightLabel.text = String(sender.value)
            self.heightWeightLabel.sizeToFit()

        }

    }

    @objc func handleDelTag(_ sender: UIButton) {
        sender.removeFromSuperview()

        self.floatLayout.tg.layoutAnimationWithDuration(0.3)
    }

}
