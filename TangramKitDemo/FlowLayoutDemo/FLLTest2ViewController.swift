//
//  FLLTest2ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *2.FlowLayout - Tag cloud
 */
class FLLTest2ViewController: UIViewController {
    
    weak var tagTextField:UITextField!
    weak var flowLayout:TGFlowLayout!
    
    override func loadView() {
        
        /*
         这个例子用来介绍流式布局中的内容填充流式布局，主要用来实现标签流的功能。内容填充流式布局的每行的数量是不固定的，而是根据其内容的尺寸来自动换行。
         */

        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。

        
        let rootLayout = TGFlowLayout(.vert,arrangedCount:2)
        rootLayout.backgroundColor = .white
        rootLayout.tg_arrangedGravity = TGGravity.vert.center
        rootLayout.tg_vspace = 4
        rootLayout.tg_hspace = 4
        self.view = rootLayout
        
        //第一行
        let tempTagTextField = UITextField()
        tempTagTextField.placeholder = "input tag here"
        tempTagTextField.borderStyle = .roundedRect
        tempTagTextField.tg_leading.equal(2)
        tempTagTextField.tg_top.equal(2)
        tempTagTextField.tg_height.equal(30)
        tempTagTextField.tg_width.equal(.fill)  //宽度占用剩余父视图宽度。
        rootLayout.addSubview(tempTagTextField)
        self.tagTextField = tempTagTextField
        
        let addTagButton = UIButton(type: .system)
        addTagButton.setTitle("Add Tag", for: .normal)
        addTagButton.addTarget(self, action: #selector(handleAddTag), for: .touchUpInside)
        addTagButton.tg_trailing.equal(2)
        addTagButton.sizeToFit()             //因为每行2个子视图，这个子视图的宽度是固定的，而上面的兄弟视图占用了剩余的宽度。这样这两个子视图将均分父视图。
        rootLayout.addSubview(addTagButton)
        
        //第二行
        let stretchSpacingLabel = UILabel()
        stretchSpacingLabel.text = "Stretch Spacing:"
        stretchSpacingLabel.font = CFTool.font(15)
        stretchSpacingLabel.tg_leading.equal(2)
        stretchSpacingLabel.tg_width.equal(140)
        stretchSpacingLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(stretchSpacingLabel)
        
        let stretchSpacingSwitch = UISwitch()
        stretchSpacingSwitch.addTarget(self, action: #selector(handleStretchSpace), for: .valueChanged)
        rootLayout.addSubview(stretchSpacingSwitch)
        
        //第三行
        let stretchSizeLabel = UILabel()
        stretchSizeLabel.text = "Stretch Size:"
        stretchSizeLabel.font = CFTool.font(15)
        stretchSizeLabel.tg_leading.equal(2)
        stretchSizeLabel.tg_width.equal(140)
        stretchSizeLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(stretchSizeLabel)
        
        let stretchSizeSwitch = UISwitch()
        stretchSizeSwitch.addTarget(self, action: #selector(handleStretchContent), for: .valueChanged)
        rootLayout.addSubview(stretchSizeSwitch)
        
        //第四行
        let autoArrangeLabel = UILabel()
        autoArrangeLabel.text = "Auto Arrange:"
        autoArrangeLabel.font = CFTool.font(15)
        autoArrangeLabel.tg_leading.equal(2)
        autoArrangeLabel.tg_width.equal(140)
        autoArrangeLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(autoArrangeLabel)
        
        let autoArrangeSwitch = UISwitch()
        autoArrangeSwitch.addTarget(self, action: #selector(handleAutoArrange), for: .valueChanged)
        rootLayout.addSubview(autoArrangeSwitch)
        
        //最后一行。
        let flowLayout = TGFlowLayout()
        flowLayout.backgroundColor = CFTool.color(0)
        flowLayout.tg_space = 10
        flowLayout.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.tg_width.equal(.fill)
        flowLayout.tg_height.equal(.fill)
        rootLayout.addSubview(flowLayout)
        self.flowLayout = flowLayout
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.createTagButton(NSLocalizedString("click to remove tag", comment:""))
        self.createTagButton(NSLocalizedString("tag2", comment:""))
        self.createTagButton(NSLocalizedString("TGLayout can used in XIB&SB", comment:""))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension FLLTest2ViewController
{
    
    func createTagButton(_ text:String)
    {
        let tagButton = UIButton()
        tagButton.setTitle(text,for:.normal)
        tagButton.titleLabel?.font = CFTool.font(15)
        tagButton.layer.cornerRadius = 15;
        tagButton.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
        
        
        //这里可以看到尺寸宽度等于内容宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
        tagButton.tg_width.equal(.wrap, increment:10).min(40)
        tagButton.tg_height.equal(.wrap, increment:10) //高度等于自身内容的高度加10
        tagButton.addTarget(self,action:#selector(handleDelTag), for:.touchUpInside )
        self.flowLayout.addSubview(tagButton)
        
    }
    
    
    @objc func handleAddTag(sender:Any!)
    {
        if let text = self.tagTextField.text
        {
            self.createTagButton(text)
            
            self.tagTextField.text = ""
            
            self.flowLayout.tg_layoutAnimationWithDuration(0.2)
        }
    }
    
    @objc func handleStretchSpace(sender:UISwitch!)
    {
        
        //间距拉伸
        if sender.isOn
        {
            self.flowLayout.tg_gravity = TGGravity.horz.between //流式布局的tg_gravity如果设置为TGGravity.horz.between表示子视图的间距会被拉伸，以便填充满整个布局。
        }
        else
        {
            self.flowLayout.tg_gravity = .none
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
    }
    
    @objc func handleStretchContent(sender:UISwitch!)
    {
        
        //内容拉伸
        if sender.isOn
        {
            self.flowLayout.tg_gravity = TGGravity.horz.fill  //流式布局的gravity如果设置为TGGravity.horz.fill表示子视图的间距会被拉伸，以便填充满整个布局。
        }
        else
        {
            self.flowLayout.tg_gravity = TGGravity.none
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
        
    }
    
    @objc func handleAutoArrange(sender:UISwitch!)
    {
        
        //自动调整位置。
        if (sender.isOn)
        {
            self.flowLayout.tg_autoArrange = true  //tg_autoArrange属性会根据子视图的内容自动调整，以便以最合适的布局来填充布局。
        }
        else
        {
            self.flowLayout.tg_autoArrange = false
        }
        
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
        
    }
    
    @objc func handleDelTag(sender:UIButton!)
    {
        sender.removeFromSuperview()
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
    }
    
    
}
