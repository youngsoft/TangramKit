//
//  AllTest1TableViewHeaderFooterView.swift
//  TangramKit
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



class AllTest1TableViewHeaderFooterView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var underLineView:UIView!
    
    var itemChangedAction:((_ index:Int)->Void)!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let rootLayout = TGFrameLayout()
        rootLayout.tg_height.equal(.fill)
        rootLayout.tg_width.equal(.fill)
        self.contentView.addSubview(rootLayout)
        
        let leftItemLayout = self.createItemLayout(NSLocalizedString("Show", comment: ""), withTag: 0)
        leftItemLayout.tg_leading.equal(0)
        leftItemLayout.tg_height.equal(.fill)
        leftItemLayout.tg_width.equal(TGWeight(100.0/3))
        leftItemLayout.tg_highlightedOpacity = 0.5
        rootLayout.addSubview(leftItemLayout)
        
        let bld = TGBorderline(color: UIColor.lightGray, headIndent:5, tailIndent:5)
        
        let centerItemLayout = self.createItemLayout(NSLocalizedString("Topic", comment: ""), withTag: 1)
        centerItemLayout.tg_centerX.equal(0)
        centerItemLayout.tg_height.equal(.fill)
        centerItemLayout.tg_width.equal(TGWeight(100.0/3))
        centerItemLayout.tg_leadingBorderline = bld
        centerItemLayout.tg_highlightedOpacity = 0.5
        rootLayout.addSubview(centerItemLayout)
        
        let rightItemLayout = self.createItemLayout(NSLocalizedString("Follow", comment: ""), withTag: 2)
        rightItemLayout.tg_trailing.equal(0)
        rightItemLayout.tg_height.equal(.fill)
        rightItemLayout.tg_width.equal(TGWeight(100.0/3))
        rightItemLayout.tg_leadingBorderline = bld
        rightItemLayout.tg_highlightedOpacity = 0.5
        rootLayout.addSubview(rightItemLayout)
        
        //底部的横线
        let underLineView = UIView()
        underLineView.tg_height.equal(2)
        underLineView.tg_width.equal(TGWeight(100.0/3))
        underLineView.tg_leading.equal(0)
        underLineView.tg_bottom.equal(0)
        underLineView.backgroundColor = UIColor.red
        rootLayout.addSubview(underLineView)
        self.underLineView = underLineView
        
        let rootLayoutBld = TGBorderline(color: .lightGray)
        rootLayout.tg_bottomBorderline = rootLayoutBld
        rootLayout.tg_topBorderline = rootLayoutBld

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        
    }
    
    
    @objc func handleTap(_ sender: TGBaseLayout) {
        switch sender.tag {
        case 0:
            self.underLineView.tg_leading.equal(0)
            self.underLineView.tg_centerX.equal(nil)
            self.underLineView.tg_trailing.equal(nil)
            break
        case 1:
            self.underLineView.tg_leading.equal(nil)
            self.underLineView.tg_centerX.equal(0)
            self.underLineView.tg_trailing.equal(nil)
            break
        case 2:
            self.underLineView.tg_leading.equal(nil)
            self.underLineView.tg_centerX.equal(nil)
            self.underLineView.tg_trailing.equal(0)
            break
        default:
            assert(false, "oops!")
        }
        
        let layout = sender.superview as! TGBaseLayout
        layout.tg_layoutAnimationWithDuration(0.2)
        
        self.itemChangedAction(sender.tag)
        
    }
    
    func createItemLayout(_ title: String, withTag tag: Int) -> TGFrameLayout {
        //创建一个框架条目布局，并设置触摸处理事件
        let itemLayout = TGFrameLayout()
        itemLayout.tag = tag
        itemLayout.tg_setTarget(self, action: #selector(self.handleTap),for:.touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.sizeToFit()
        titleLabel.tg_centerX.equal(0)
        titleLabel.tg_centerY.equal(0) //标题尺寸由内容包裹，位置在布局视图中居中。
        itemLayout.addSubview(titleLabel)
        
        return itemLayout
    }
}
