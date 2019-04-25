//
//  FLLTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *3.FlowLayout - Drag
 */
class FLLTest3ViewController: UIViewController {

    weak var flowLayout: TGFlowLayout!
    var oldIndex: Int = 0
    var currentIndex: Int = 0
    var hasDrag: Bool = false
    weak var addButton: UIButton!
    
    override func loadView() {
        
        /*
         这个例子用来介绍布局视图对动画的支持，以及通过布局视图的autoresizesSubviews属性，以及子视图的扩展属性tg_useFrame和tg_noLayout来实现子视图布局的个性化设置。
         
         布局视图的autoresizesSubviews属性用来设置当布局视图被激发要求重新布局时，是否会对里面的所有子视图进行重新布局。
         子视图的扩展属性tg_useFrame表示某个子视图不受布局视图的布局控制，而是用最原始的frame属性设置来实现自定义的位置和尺寸的设定。
         子视图的扩展属性tg_noLayout表示某个子视图会参与布局，但是并不会正真的调整布局后的frame值。
         
         */

        
        let rootLayout = TGLinearLayout(.vert)
        rootLayout.backgroundColor = .white
        rootLayout.tg_gravity = TGGravity.horz.fill
        self.view = rootLayout
        
        let tipLabel = UILabel()
        tipLabel.font = CFTool.font(13)
        tipLabel.text = NSLocalizedString("  You can drag the following tag to adjust location in layout, MyLayout can use subview's useFrame,noLayout property and layout view's autoresizesSubviews propery to complete some position adjustment and the overall animation features: \n useFrame set to YES indicates subview is not controlled by the layout view but use its own frame to set the location and size instead.\n \n autoresizesSubviews set to NO indicate layout view will not do any layout operation, and will remain in the position and size of all subviews.\n \n noLayout set to YES indicate subview in the layout view just only take up the position and size but not real adjust the position and size when layouting.", comment: "")
        tipLabel.textColor = CFTool.color(4)
        tipLabel.tg_height.equal(.wrap)  //高度动态确定。
        tipLabel.tg_top.equal(self.topLayoutGuide)
        rootLayout.addSubview(tipLabel)
        
        let tip2Label = UILabel()
        tip2Label.text = NSLocalizedString("double click to remove tag", comment: "")
        tip2Label.font = CFTool.font(13)
        tip2Label.textColor = CFTool.color(3)
        tip2Label.textAlignment = .center
        tip2Label.sizeToFit()
        tip2Label.tg_top.equal(3)
        rootLayout.addSubview(tip2Label)
        
        let flowLayout = TGFlowLayout.init(.vert, arrangedCount: 4)
        flowLayout.backgroundColor = CFTool.color(0)
        flowLayout.tg_padding = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.tg_space = 10  //流式布局里面的子视图的水平和垂直间距设置为10
        flowLayout.tg_gravity = TGGravity.horz.fill  //流式布局里面的子视图的宽度将平均分配。
        flowLayout.tg_height.equal(.fill) //占用剩余的高度。
        flowLayout.tg_top.equal(10)
        rootLayout.addSubview(flowLayout)
        self.flowLayout = flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...10 {
            let label = NSLocalizedString("drag me \(index)", comment: "")
            self.flowLayout.addSubview(self.createTagButton(text: label))
        }
        
        //最后添加添加按钮。
        let addButton = self.createAddButton()
        self.flowLayout.addSubview(addButton)
        self.addButton = addButton
    }
    
    //创建标签按钮
    internal func createTagButton(text: String) -> UIButton
    {
        let tagButton = UIButton()
        tagButton.setTitle(text, for: .normal)
        tagButton.titleLabel?.font = CFTool.font(14)
        tagButton.layer.cornerRadius = 20
        tagButton.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        tagButton.tg_height.equal(44)
        tagButton.addTarget(self, action: #selector(handleTouchDrag(sender:event:)), for: .touchDragInside) //注册拖动事件。
        tagButton.addTarget(self, action: #selector(handleTouchDrag(sender:event:)), for: .touchDragOutside) //注册拖动事件。
        tagButton.addTarget(self, action: #selector(handleTouchDown(sender:event:)), for: .touchDown) //注册按下事件
        tagButton.addTarget(self, action: #selector(handleTouchUp), for: .touchUpInside)  //注册抬起事件
        tagButton.addTarget(self, action: #selector(handleTouchUp), for: .touchCancel)  //注册抬起事件
        tagButton.addTarget(self, action: #selector(handleTouchDownRepeat(sender:event:)), for: .touchDownRepeat) //注册多次点击事件
        return tagButton;
    }
    
    //创建添加按钮
    private func createAddButton() -> UIButton
    {
        let addButton = UIButton()
        addButton.setTitle(NSLocalizedString("add tag", comment: ""), for: .normal)
        addButton.titleLabel?.font = CFTool.font(14)
        addButton.setTitleColor(.blue, for: .normal)
        addButton.layer.cornerRadius = 20
        addButton.layer.borderWidth = 0.5
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        addButton.tg_height.equal(44)
        addButton.addTarget(self, action: #selector(handleAddTagButton(sender:)), for: .touchUpInside)
        return addButton
    }
}

extension FLLTest3ViewController {
    
    @objc func handleAddTagButton(sender: AnyObject)
    {
        let label = NSLocalizedString("drag me \(self.flowLayout.subviews.count-1)", comment: "")
        self.flowLayout.insertSubview(self.createTagButton(text: label), at: self.flowLayout.subviews.count-1)
    }
    
    @objc func handleTouchDrag(sender: UIButton, event: UIEvent) {
        self.hasDrag = true
        
        //取出拖动时当前的位置点。
        let touch: UITouch = (event.touches(for: sender)! as NSSet).anyObject() as! UITouch
        let pt = touch.location(in: self.flowLayout)
        
        var sbv2: UIView!  //sbv2保存拖动时手指所在的视图。
        //判断当前手指在具体视图的位置。这里要排除self.addButton的位置(因为这个按钮将固定不调整)。
        for sbv: UIView in self.flowLayout.subviews
        {
            if sbv != sender && sender.tg_useFrame && sbv != self.addButton
            {
                let rect1 = sbv.frame
                if rect1.contains(pt) {
                    sbv2 = sbv
                    break
                }
            }
        }
        
        
        //如果拖动的控件sender和手指下当前其他的兄弟控件有重合时则意味着需要将当前控件插入到手指下的sbv2所在的位置，并且调整sbv2的位置。
        if sbv2 != nil
        {
            self.flowLayout.tg_layoutAnimationWithDuration(0.2)
            
            //得到要移动的视图的位置索引。
            self.currentIndex = self.flowLayout.subviews.firstIndex(of: sbv2)!
            if self.oldIndex != self.currentIndex {
                self.oldIndex = self.currentIndex
            }
            else {
                self.currentIndex = self.oldIndex + 1
            }
            
            //因为sender在bringSubviewToFront后变为了最后一个子视图，因此要调整正确的位置。
            for index in ((self.currentIndex + 1)...self.flowLayout.subviews.count-1).reversed() {
                self.flowLayout.exchangeSubview(at: index, withSubviewAt: index-1)
            }
            
            //经过上面的sbv2的位置调整完成后，需要重新激发布局视图的布局，因此这里要设置autoresizesSubviews为YES。
            self.flowLayout.autoresizesSubviews = true
            sender.tg_useFrame = false
            sender.tg_noLayout = true //这里设置为true表示布局时不会改变sender的真实位置而只是在布局视图中占用一个位置和尺寸，正是因为只是占用位置，因此会调整其他视图的位置。
            
            self.flowLayout.layoutIfNeeded()
        }
        
        
        //在进行sender的位置调整时，要把sender移动到最顶端，也就子视图数组的的最后，这时候布局视图不能布局，因此要把autoresizesSubviews设置为false，同时因为要自定义
        //sender的位置，因此要把tg_useFrame设置为true，并且恢复tg_noLayout为false。

        self.flowLayout.bringSubviewToFront(sender)   //把拖动的子视图放在最后，这样这个子视图在移动时就会在所有兄弟视图的上面。
        self.flowLayout.autoresizesSubviews = false //在拖动时不要让布局视图激发布局
        sender.tg_useFrame = true //因为拖动时，拖动的控件需要自己确定位置，不能被布局约束，因此必须要将useFrame设置为YES下面的center设置才会有效。
        sender.tg_noLayout = false //因为useFrame设置为了YES所有这里可以直接调整center，从而实现了位置的自定义设置。
        sender.center = pt  //因为tg_useFrame设置为了YES所有这里可以直接调整center，从而实现了位置的自定义设置。
    }
    
    @objc func handleTouchDown(sender: UIButton, event: UIEvent)
    {
        //在按下时记录当前要拖动的控件的索引。
        self.oldIndex = self.flowLayout.subviews.firstIndex(of: sender)!
        self.currentIndex = self.oldIndex
        self.hasDrag = false
    }
    
    @objc func handleTouchUp(sender: UIButton, event: UIEvent) {
        if !self.hasDrag {
            return
        }
        
        //当抬起时，需要让拖动的子视图调整到正确的顺序，并重新参与布局，因此这里要把拖动的子视图的tg_useFrame设置为false，同时把布局视图的autoresizesSubviews还原为YES。
        
        //调整索引。
        
        for index in ((self.currentIndex+1)...(self.flowLayout.subviews.count-1)).reversed() {
            self.flowLayout.exchangeSubview(at: index, withSubviewAt: index-1)
        }
        
        sender.tg_useFrame = false  //让拖动的子视图重新参与布局，将tg_useFrame设置为false
        self.flowLayout.autoresizesSubviews = true  //让布局视图可以重新激发布局，这里还原为true。

    }
    
    @objc func handleTouchDownRepeat(sender: UIButton, event: UIEvent) {
        sender.removeFromSuperview()
        self.flowLayout.tg_layoutAnimationWithDuration(0.2)
    }
}
