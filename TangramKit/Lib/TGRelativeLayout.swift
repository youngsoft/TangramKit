//
//  TGRelativeLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 *相对布局是一种里面的子视图通过相互之间的约束和依赖来进行布局和定位的布局视图。
 *相对布局里面的子视图的布局位置和添加的顺序无关，而是通过设置子视图的相对依赖关系来进行定位和布局的。
 *相对布局提供和AutoLayout等价的功能。
 */
open class TGRelativeLayout: TGBaseLayout,TGRelativeLayoutViewSizeClass {
    
    /**
     *子视图调用tg_width.equal([TGLayoutSize])均分宽度时当有子视图隐藏时是否参与宽度计算,这个属性只有在参与均分视图的子视图隐藏时才有效,默认是false
     */
    public var tg_autoLayoutViewGroupWidth: Bool {
        
        get {
            return (self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClass).tg_autoLayoutViewGroupWidth
        }
        
        set {
            let sc = self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClass
            if sc.tg_autoLayoutViewGroupWidth != newValue
            {
                sc.tg_autoLayoutViewGroupWidth = newValue;
                setNeedsLayout()
            }
        }
    }
    
    /**
     *子视图调用tg_height.equal([TGLayoutSize])均分高度时当有子视图隐藏时是否参与高度计算,这个属性只有在参与均分视图的子视图隐藏时才有效,默认是false
     */
    public var tg_autoLayoutViewGroupHeight: Bool {
        
        get {
            return (self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClass).tg_autoLayoutViewGroupHeight
        }
        
        set {
            let sc = self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClass
            if sc.tg_autoLayoutViewGroupHeight != newValue
            {
                sc.tg_autoLayoutViewGroupHeight = newValue
                setNeedsLayout()
            }
        }
    }
    
    //MARK: override method
    
    override func calcLayoutRect(_ size: CGSize, isEstimate: Bool, type: TGSizeClassType) -> (selfSize: CGSize, hasSubLayout: Bool) {
        
        var (selfSize, hasSubLayout) = super.calcLayoutRect(size, isEstimate: isEstimate, type: type)
        
        for sbv: UIView in self.subviews
        {
            if sbv.tg_useFrame
            {
                continue
            }
            
            if !isEstimate {
                sbv.tgFrame.reset()
            }
            
            if (sbv.tg_left.hasValue && sbv.tg_right.hasValue) {
                
                sbv.tg_width._dimeVal = nil
            }
            
            if (sbv.tg_top.hasValue && sbv.tg_bottom.hasValue) {
                sbv.tg_height._dimeVal = nil
            }
            
            
            if let sbvl: TGBaseLayout = sbv as? TGBaseLayout
            {
                
                if sbvl.tg_width.isWrap || sbvl.tg_height.isWrap
                {
                    hasSubLayout = true
                }
                
                if isEstimate && (sbvl.tg_width.isWrap || sbvl.tg_height.isWrap)
                {
                    
                    _ = sbvl.tg_sizeThatFits(sbvl.tgFrame.frame.size, inSizeClass:type)
                    
                    sbvl.tgFrame.left = CGFloat.greatestFiniteMagnitude
                    sbvl.tgFrame.right = CGFloat.greatestFiniteMagnitude
                    sbvl.tgFrame.top = CGFloat.greatestFiniteMagnitude
                    sbvl.tgFrame.bottom = CGFloat.greatestFiniteMagnitude;
                    
                    sbvl.tgFrame.sizeClass = sbvl.tgMatchBestSizeClass(type)
                }
            }
        }
        
        let (maxSize,reCalc) = calcLayout(selfSize)
        
        if self.tg_width.isWrap || self.tg_height.isWrap {
            if selfSize.height != maxSize.height || selfSize.width != maxSize.width
            {
                if self.tg_width.isWrap {
                    selfSize.width = maxSize.width
                }
                
                if self.tg_height.isWrap {
                    selfSize.height = maxSize.height
                }
                
                if reCalc
                {
                    for sbv: UIView in self.subviews {
                        
                        if let sbvl = sbv as? TGBaseLayout , isEstimate
                        {
                            sbvl.tgFrame.left = CGFloat.greatestFiniteMagnitude
                            sbvl.tgFrame.right = CGFloat.greatestFiniteMagnitude
                            sbvl.tgFrame.top = CGFloat.greatestFiniteMagnitude
                            sbvl.tgFrame.bottom = CGFloat.greatestFiniteMagnitude;
                        }
                        else
                        {
                            sbv.tgFrame.reset()
                        }
                    }
                    
                    _ = calcLayout(selfSize)
                }
            }
        }
        
        selfSize.height = self.validMeasure(self.tg_height,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.validMeasure(self.tg_width,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        return (selfSize, hasSubLayout)
    }
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGRelativeLayoutViewSizeClassImpl()
    }
}

extension TGRelativeLayout
{
    fileprivate func calcSubViewLeftRight(_ sbv: UIView, selfSize: CGSize) {
        
        
        if (sbv.tgFrame.left != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.right != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude){
            return
        }
        
        if calcWidth(sbv, selfSize: selfSize) {
            return
        }
        
        if sbv.tg_centerX.posRelaVal != nil {
            let relaView = sbv.tg_centerX.posRelaVal.view
            
            sbv.tgFrame.left = calcSubView(relaView, gravity: sbv.tg_centerX.posRelaVal._type, selfSize: selfSize) - sbv.tgFrame.width / 2 + sbv.tg_centerX.margin
            
            if relaView != self && self.isNoLayoutSubview(relaView)
            {
                sbv.tgFrame.left -= sbv.tg_centerX.margin;
            }
            
            
            sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
            return
        }
        else if sbv.tg_centerX.posNumVal != nil
        {
            sbv.tgFrame.left = (selfSize.width - self.tg_rightPadding - self.tg_leftPadding - sbv.tgFrame.width) / 2 + self.tg_leftPadding + sbv.tg_centerX.margin
            sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
            return
        }
        else {
            if sbv.tg_left.posRelaVal != nil
            {
                let relaView = sbv.tg_left.posRelaVal.view
                sbv.tgFrame.left = calcSubView(relaView, gravity:sbv.tg_left.posRelaVal._type, selfSize: selfSize) + sbv.tg_left.margin
                
                if relaView != self && self.isNoLayoutSubview(relaView)
                {
                    sbv.tgFrame.left -= sbv.tg_left.margin;
                }
                
                sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
                return
            }
            else if sbv.tg_left.posNumVal != nil {
                sbv.tgFrame.left = sbv.tg_left.margin + self.tg_leftPadding
                sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
                return
            }
            
            if sbv.tg_right.posRelaVal != nil
            {
                let relaView = sbv.tg_right.posRelaVal.view
                
                
                sbv.tgFrame.right = calcSubView(relaView, gravity: sbv.tg_right.posRelaVal._type, selfSize: selfSize) - sbv.tg_right.margin + sbv.tg_left.margin
                
                if relaView != self && self.isNoLayoutSubview(relaView)
                {
                    sbv.tgFrame.right += sbv.tg_right.margin;
                }
                
                
                sbv.tgFrame.left = sbv.tgFrame.right - sbv.tgFrame.width
                return
            }
            else if sbv.tg_right.posNumVal != nil {
                sbv.tgFrame.right = selfSize.width - self.tg_rightPadding - sbv.tg_right.margin + sbv.tg_left.margin
                sbv.tgFrame.left = sbv.tgFrame.right - sbv.tgFrame.width
                return
            }
            
            sbv.tgFrame.left = sbv.tg_left.margin + self.tg_leftPadding
            sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
        }
    }
    
    fileprivate func calcSubViewTopBottom(_ sbv: UIView, selfSize: CGSize) {
        
        
        if sbv.tgFrame.top != CGFloat.greatestFiniteMagnitude &&
            sbv.tgFrame.bottom != CGFloat.greatestFiniteMagnitude &&
            sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude
        {
            return
        }
        
        if calcHeight(sbv, selfSize: selfSize) {
            return
        }
        
        if sbv.tg_centerY.posRelaVal != nil
        {
            let relaView = sbv.tg_centerY.posRelaVal.view
            
            sbv.tgFrame.top = calcSubView(relaView, gravity: sbv.tg_centerY.posRelaVal._type, selfSize: selfSize) - sbv.tgFrame.height / 2 + sbv.tg_centerY.margin
            
            
            if  relaView != self && self.isNoLayoutSubview(relaView)
            {
                sbv.tgFrame.top -= sbv.tg_centerY.margin;
            }
            
            
            sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
            return
        }
        else if sbv.tg_centerY.posNumVal != nil {
            sbv.tgFrame.top = (selfSize.height - self.tg_topPadding - self.tg_bottomPadding - sbv.tgFrame.height) / 2 + self.tg_topPadding + sbv.tg_centerY.margin
            sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
            return
        }
        else {
            if sbv.tg_top.posRelaVal != nil
            {
                let relaView = sbv.tg_top.posRelaVal.view
                
                
                sbv.tgFrame.top = calcSubView(relaView, gravity: sbv.tg_top.posRelaVal._type, selfSize: selfSize) + sbv.tg_top.margin
                
                if  relaView != self && self.isNoLayoutSubview(relaView)
                {
                    sbv.tgFrame.top -= sbv.tg_top.margin;
                }
                
                
                sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
                return
            }
            else if sbv.tg_top.posNumVal != nil {
                sbv.tgFrame.top = sbv.tg_top.margin
                sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
                return
            }
            
            if sbv.tg_bottom.posRelaVal != nil
            {
                let relaView = sbv.tg_bottom.posRelaVal.view
                
                sbv.tgFrame.bottom = calcSubView(relaView, gravity: sbv.tg_bottom.posRelaVal._type, selfSize: selfSize) - sbv.tg_bottom.margin + sbv.tg_top.margin
                
                if  relaView != self && self.isNoLayoutSubview(relaView)
                {
                    sbv.tgFrame.bottom += sbv.tg_bottom.margin;
                }
                
                sbv.tgFrame.top = sbv.tgFrame.bottom - sbv.tgFrame.height
                return
            }
            else if sbv.tg_bottom.posNumVal != nil {
                sbv.tgFrame.bottom = selfSize.height - sbv.tg_bottom.margin - self.tg_bottomPadding + sbv.tg_top.margin
                sbv.tgFrame.top = sbv.tgFrame.bottom - sbv.tgFrame.height
                return
            }
            
            sbv.tgFrame.top = sbv.tg_top.margin + self.tg_topPadding
            sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
        }
    }
    
    
    fileprivate func calcWidth(_ sbv: UIView, selfSize: CGSize) -> Bool {
        if sbv.tgFrame.width == CGFloat.greatestFiniteMagnitude {
            if sbv.tg_width.dimeRelaVal != nil {
                sbv.tgFrame.width = sbv.tg_width.measure(calcSubView(sbv.tg_width.dimeRelaVal.view, gravity:sbv.tg_width.dimeRelaVal._type, selfSize: selfSize))
                sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_width.dimeNumVal != nil {
                sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_width.isFill
            {
                sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure(selfSize.width - self.tg_leftPadding - self.tg_rightPadding), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_width.dimeWeightVal != nil
            {
                sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure((selfSize.width - self.tg_leftPadding - self.tg_rightPadding) * sbv.tg_width.dimeWeightVal.rawValue/100), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.isNoLayoutSubview(sbv)
            {
                sbv.tgFrame.width = 0
            }
            
            if sbv.tg_left.hasValue && sbv.tg_right.hasValue {
                if sbv.tg_left.posRelaVal != nil {
                    sbv.tgFrame.left = calcSubView(sbv.tg_left.posRelaVal.view, gravity:sbv.tg_left.posRelaVal._type, selfSize: selfSize) + sbv.tg_left.margin
                }
                else {
                    sbv.tgFrame.left = sbv.tg_left.margin + self.tg_leftPadding
                }
                
                if sbv.tg_right.posRelaVal != nil {
                    sbv.tgFrame.right = calcSubView(sbv.tg_right.posRelaVal.view, gravity:sbv.tg_right.posRelaVal._type, selfSize: selfSize) - sbv.tg_right.margin
                }
                else {
                    sbv.tgFrame.right = selfSize.width - sbv.tg_right.margin - self.tg_rightPadding
                }
                
                sbv.tgFrame.width = sbv.tgFrame.right - sbv.tgFrame.left
                sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.isNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.width = 0
                    sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
                }
                
                return true
            }
            
            if sbv.tgFrame.width == CGFloat.greatestFiniteMagnitude {
                sbv.tgFrame.width = sbv.bounds.size.width
                sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbv.tg_width.lBoundVal.dimeNumVal != nil && sbv.tg_width.lBoundVal.dimeNumVal != -CGFloat.greatestFiniteMagnitude) || (sbv.tg_width.uBoundVal.dimeNumVal != nil && sbv.tg_width.uBoundVal.dimeNumVal != CGFloat.greatestFiniteMagnitude))
        {
            sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        
        return false
    }
    
    fileprivate func calcHeight(_ sbv: UIView, selfSize: CGSize) -> Bool {
        if sbv.tgFrame.height == CGFloat.greatestFiniteMagnitude {
            if sbv.tg_height.dimeRelaVal != nil {
                sbv.tgFrame.height = sbv.tg_height.measure(self.calcSubView(sbv.tg_height.dimeRelaVal.view, gravity:sbv.tg_height.dimeRelaVal._type, selfSize: selfSize))
                sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_height.dimeNumVal != nil {
                sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tg_height.measure, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_height.isFill
            {
                sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tg_height.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_height.dimeWeightVal != nil
            {
                sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tg_height.measure((selfSize.height - self.tg_topPadding - self.tg_bottomPadding) * sbv.tg_height.dimeWeightVal.rawValue/100), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.isNoLayoutSubview(sbv)
            {
                sbv.tgFrame.height = 0
            }
            
            if sbv.tg_top.hasValue && sbv.tg_bottom.hasValue {
                if sbv.tg_top.posRelaVal != nil {
                    sbv.tgFrame.top = self.calcSubView(sbv.tg_top.posRelaVal.view, gravity:sbv.tg_top.posRelaVal._type, selfSize: selfSize) + sbv.tg_top.margin
                }
                else {
                    sbv.tgFrame.top = sbv.tg_top.margin + self.tg_topPadding
                }
                
                if sbv.tg_bottom.posRelaVal != nil {
                    sbv.tgFrame.bottom = self.calcSubView(sbv.tg_bottom.posRelaVal.view, gravity:sbv.tg_bottom.posRelaVal._type, selfSize: selfSize) - sbv.tg_bottom.margin
                }
                else {
                    sbv.tgFrame.bottom = selfSize.height - sbv.tg_bottom.margin - self.tg_bottomPadding
                }
                
                sbv.tgFrame.height = sbv.tgFrame.bottom - sbv.tgFrame.top
                sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.isNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.height = 0
                    sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
                }
                
                
                return true
            }
            
            if sbv.tgFrame.height == CGFloat.greatestFiniteMagnitude {
                sbv.tgFrame.height = sbv.bounds.size.height
                sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbv.tg_height.lBoundVal.dimeNumVal != nil && sbv.tg_height.lBoundVal.dimeNumVal != -CGFloat.greatestFiniteMagnitude) || (sbv.tg_height.uBoundVal.dimeNumVal != nil && sbv.tg_height.uBoundVal.dimeNumVal != CGFloat.greatestFiniteMagnitude))
        {
            sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        return false
    }
    
    fileprivate func calcLayout(_ selfSize: CGSize) -> (selfSize: CGSize, reCalc: Bool) {
        
        var recalc: Bool = false
        
        
        for sbv:UIView in self.subviews
        {
            self.calcSizeOfWrapContentSubview(sbv);
            
            if (sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude)
            {
                if (sbv.tg_width.uBoundVal.dimeRelaVal != nil && sbv.tg_width.uBoundVal.dimeRelaVal.view != self)
                {
                    _ = self.calcWidth(sbv.tg_width.uBoundVal.dimeRelaVal.view, selfSize:selfSize)
                }
                
                if (sbv.tg_width.lBoundVal.dimeRelaVal != nil && sbv.tg_width.lBoundVal.dimeRelaVal.view != self)
                {
                    _ = self.calcWidth(sbv.tg_width.lBoundVal.dimeRelaVal.view, selfSize:selfSize)
                }
                
                sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv:sbv, calcSize:sbv.tgFrame.width, sbvSize:sbv.tgFrame.frame.size,selfLayoutSize:selfSize)
            }
            
            if (sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude)
            {
                if (sbv.tg_height.uBoundVal.dimeRelaVal != nil && sbv.tg_height.uBoundVal.dimeRelaVal.view != self)
                {
                    _ = self.calcHeight(sbv.tg_height.uBoundVal.dimeRelaVal.view,selfSize:selfSize)
                }
                
                if (sbv.tg_height.lBoundVal.dimeRelaVal != nil && sbv.tg_height.lBoundVal.dimeRelaVal.view != self)
                {
                    _ = self.calcHeight(sbv.tg_height.lBoundVal.dimeRelaVal.view,selfSize:selfSize)
                }
                
                sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            
        }
        
        
        for sbv: UIView in self.subviews {
            
            if sbv.tg_width.dimeArrVal != nil {
                recalc = true
                
                let dimeArray: [TGLayoutSize] = sbv.tg_width.dimeArrVal
                var  isViewHidden = self.isNoLayoutSubview(sbv) && self.tg_autoLayoutViewGroupWidth
                var totalMutil: CGFloat = isViewHidden ? 0 : sbv.tg_width.mutilVal
                var totalAdd: CGFloat = isViewHidden ? 0 : sbv.tg_width.addVal
                
                for dime:TGLayoutSize in dimeArray {
                    isViewHidden = self.isNoLayoutSubview(dime.view) && self.tg_autoLayoutViewGroupWidth
                    if !isViewHidden {
                        if dime.dimeNumVal != nil {
                            totalAdd += (-1 * dime.dimeNumVal)
                        }
                        else if (dime.view as? TGBaseLayout) == nil && dime.isWrap
                        {
                            totalAdd += -1 * dime.view.tgFrame.width
                        }
                        else {
                            totalMutil += dime.mutilVal
                        }
                        
                        totalAdd += dime.addVal
                    }
                }
                
                var floatWidth: CGFloat = selfSize.width - self.tg_leftPadding - self.tg_rightPadding + totalAdd
                if floatWidth <= 0 {
                    floatWidth = 0
                }
                
                if totalMutil != 0 {
                    sbv.tgFrame.width = self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: floatWidth * (sbv.tg_width.mutilVal / totalMutil), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.isNoLayoutSubview(sbv)
                    {
                        sbv.tgFrame.width = 0
                    }
                    
                    for dime:TGLayoutSize in dimeArray {
                        if dime.dimeNumVal == nil {
                            dime.view.tgFrame.width = floatWidth * (dime.mutilVal / totalMutil)
                        }
                        else {
                            dime.view.tgFrame.width = dime.dimeNumVal
                        }
                        
                        dime.view.tgFrame.width = self.validMeasure(dime.view.tg_width, sbv: dime.view, calcSize: dime.view.tgFrame.width, sbvSize: dime.view.tgFrame.frame.size, selfLayoutSize: selfSize)
                        
                        if self.isNoLayoutSubview(dime.view)
                        {
                            dime.view.tgFrame.width = 0
                        }
                        
                    }
                }
            }
            
            
            if sbv.tg_height.dimeArrVal != nil {
                recalc = true
                
                let dimeArray: [TGLayoutSize] = sbv.tg_height.dimeArrVal
                var isViewHidden: Bool = self.isNoLayoutSubview(sbv) && self.tg_autoLayoutViewGroupHeight
                var totalMutil = isViewHidden ? 0 : sbv.tg_height.mutilVal
                var totalAdd = isViewHidden ? 0 : sbv.tg_height.addVal
                for dime:TGLayoutSize in dimeArray {
                    isViewHidden =  self.isNoLayoutSubview(dime.view) && self.tg_autoLayoutViewGroupHeight
                    if !isViewHidden {
                        if dime.dimeNumVal != nil {
                            totalAdd += (-1 * dime.dimeNumVal!)
                        }
                        else if (dime.view as? TGBaseLayout) == nil && dime.isWrap
                        {
                            totalAdd += -1 * dime.view.tgFrame.height;
                        }
                        else {
                            totalMutil += dime.mutilVal
                        }
                        
                        totalAdd += dime.addVal
                    }
                }
                
                var floatHeight = selfSize.height - self.tg_topPadding - self.tg_bottomPadding + totalAdd
                if floatHeight <= 0 {
                    floatHeight = 0
                }
                if totalMutil != 0 {
                    sbv.tgFrame.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: floatHeight * (sbv.tg_height.mutilVal / totalMutil), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.isNoLayoutSubview(sbv)
                    {
                        sbv.tgFrame.height = 0
                    }
                    
                    for dime: TGLayoutSize in dimeArray {
                        if dime.dimeNumVal == nil {
                            dime.view.tgFrame.height = floatHeight * (dime.mutilVal / totalMutil)
                        }
                        else {
                            dime.view.tgFrame.height = dime.dimeNumVal
                        }
                        
                        dime.view.tgFrame.height = self.validMeasure(dime.view.tg_height, sbv: dime.view, calcSize: dime.view.tgFrame.height, sbvSize: dime.view.tgFrame.frame.size, selfLayoutSize: selfSize)
                        
                        if self.isNoLayoutSubview(dime.view)
                        {
                            dime.view.tgFrame.height = 0
                        }
                        
                    }
                }
            }
            
            
            if sbv.tg_centerX.posArrVal != nil
            {
                
                let centerArray: [TGLayoutPos] = sbv.tg_centerX.posArrVal
                var totalWidth: CGFloat = 0.0
                var totalOffset:CGFloat = 0.0
                
                var nextPos:TGLayoutPos! = nil
                var i = centerArray.count - 1
                while (i >= 0)
                {
                    let pos = centerArray[i]
                    if !self.isNoLayoutSubview(pos.view)
                    {
                        if totalWidth != 0
                        {
                            if nextPos != nil
                            {
                                totalOffset += nextPos.view.tg_centerX.margin
                            }
                        }
                        
                        _ = self.calcWidth(pos.view, selfSize: selfSize)
                        totalWidth += pos.view.tgFrame.width
                    }
                    
                    nextPos = pos
                    i -= 1
                }
                
                if !self.isNoLayoutSubview(sbv)
                {
                    if totalWidth != 0
                    {
                        if nextPos != nil
                        {
                            totalOffset += nextPos.view.tg_centerX.margin
                        }
                    }
                    
                    _ = self.calcWidth(sbv, selfSize: selfSize)
                    totalWidth += sbv.tgFrame.width
                    totalOffset += sbv.tg_centerX.margin
                    
                }
                
                var leftOffset: CGFloat = (selfSize.width - self.tg_leftPadding - self.tg_rightPadding - totalWidth - totalOffset) / 2.0
                leftOffset += self.tg_leftPadding
                
                var prev:AnyObject! = leftOffset as AnyObject!
                sbv.tg_left.equal(leftOffset)
                prev = sbv.tg_right
                
                for pos: TGLayoutPos in centerArray
                {
                    if let prevf = prev as? CGFloat
                    {
                        pos.view.tg_left.equal(prevf,offset:pos.view.tg_centerX.margin)
                        
                    }
                    else
                    {
                        pos.view.tg_left.equal(prev as? TGLayoutPos, offset:pos.view.tg_centerX.margin)
                    }
                    
                    prev = pos.view.tg_right
                }
            }
            
            if sbv.tg_centerY.posArrVal != nil
            {
                let centerArray: [TGLayoutPos] = sbv.tg_centerY.posArrVal
                var totalHeight: CGFloat = 0.0
                var totalOffset:CGFloat = 0.0
                
                var nextPos:TGLayoutPos! = nil
                var i = centerArray.count - 1
                while (i >= 0)
                {
                    let pos = centerArray[i]
                    if !self.isNoLayoutSubview(pos.view)
                    {
                        if totalHeight != 0
                        {
                            if nextPos != nil
                            {
                                totalOffset += nextPos.view.tg_centerY.margin
                            }
                        }
                        
                        _  = self.calcHeight(pos.view, selfSize: selfSize)
                        totalHeight += pos.view.tgFrame.height
                    }
                    
                    nextPos = pos
                    i -= 1
                }
                
                if !self.isNoLayoutSubview(sbv)
                {
                    if totalHeight != 0
                    {
                        if nextPos != nil
                        {
                            totalOffset += nextPos.view.tg_centerY.margin
                        }
                    }
                    
                    _ = self.calcHeight(sbv, selfSize: selfSize)
                    totalHeight += sbv.tgFrame.height
                    totalOffset += sbv.tg_centerY.margin
                    
                }
                
                var topOffset: CGFloat = (selfSize.height - self.tg_topPadding - self.tg_bottomPadding - totalHeight - totalOffset) / 2.0
                topOffset += self.tg_topPadding
                
                var prev:AnyObject! = topOffset as AnyObject!
                sbv.tg_top.equal(topOffset)
                prev = sbv.tg_bottom
                
                for pos: TGLayoutPos in centerArray
                {
                    if let prevf = prev as? CGFloat
                    {
                        pos.view.tg_top.equal(prevf,offset:pos.view.tg_centerY.margin)
                        
                    }
                    else
                    {
                        pos.view.tg_top.equal(prev as? TGLayoutPos, offset:pos.view.tg_centerY.margin)
                    }
                    
                    prev = pos.view.tg_bottom
                }
                
            }
        }
        
        
        var maxWidth = self.tg_leftPadding
        var maxHeight = self.tg_topPadding
        
        for sbv: UIView in self.subviews {
            var canCalcMaxWidth = true
            var canCalcMaxHeight = true
            
            calcSubViewLeftRight(sbv, selfSize: selfSize)
            if sbv.tg_right.posRelaVal != nil && sbv.tg_right.posRelaVal.view == self {
                recalc = true
            }
            
            if sbv.tg_width.dimeRelaVal != nil && sbv.tg_width.dimeRelaVal.view == self {
                canCalcMaxWidth = false
                recalc = true
            }
            
            if sbv.tg_left.posRelaVal != nil && sbv.tg_left.posRelaVal.view == self && sbv.tg_right.posRelaVal != nil && sbv.tg_right.posRelaVal.view == self {
                canCalcMaxWidth = false
            }
            
            if sbv.tg_width.isFill || sbv.tg_width.dimeWeightVal != nil
            {
                canCalcMaxWidth = false
                recalc = true
            }
            
            
            if sbv.tg_height.isFlexHeight {
                sbv.tgFrame.height = self.heightFromFlexedHeightView(sbv, width: sbv.tgFrame.width)
            }
            
            calcSubViewTopBottom(sbv, selfSize: selfSize)
            
            if sbv.tg_bottom.posRelaVal != nil && sbv.tg_bottom.posRelaVal.view == self {
                recalc = true
            }
            
            if sbv.tg_height.dimeRelaVal != nil && sbv.tg_height.dimeRelaVal.view == self {
                recalc = true
                canCalcMaxHeight = false
            }
            
            if sbv.tg_height.isFill || sbv.tg_height.dimeWeightVal != nil
            {
                canCalcMaxHeight = false
                recalc = true
            }

            
            if sbv.tg_top.posRelaVal != nil && sbv.tg_top.posRelaVal.view == self && sbv.tg_bottom.posRelaVal != nil && sbv.tg_bottom.posRelaVal.view == self {
                canCalcMaxHeight = false
            }
            
            if self.isNoLayoutSubview(sbv)
            {
                continue
            }
            
            
            if canCalcMaxWidth && maxWidth < sbv.tgFrame.right + sbv.tg_right.margin {
                maxWidth = sbv.tgFrame.right + sbv.tg_right.margin
            }
            
            if canCalcMaxHeight && maxHeight < sbv.tgFrame.bottom + sbv.tg_bottom.margin {
                maxHeight = sbv.tgFrame.bottom + sbv.tg_bottom.margin
            }
        }
        
        maxWidth += self.tg_rightPadding
        maxHeight += self.tg_bottomPadding
        return (CGSize(width: maxWidth, height: maxHeight), recalc);
    }
    
    fileprivate func calcSubView(_ sbv: UIView!, gravity:TGGravity, selfSize: CGSize) -> CGFloat {
        switch gravity {
        case TGGravity.horz.left:
            if sbv == self || sbv == nil {
                return self.tg_leftPadding
            }
            
            if sbv.tgFrame.left != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.left
            }
            
            
            calcSubViewLeftRight(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.left
            
            
        case TGGravity.horz.right:
            if sbv == self || sbv == nil {
                return selfSize.width - self.tg_rightPadding
            }
            
            
            if sbv.tgFrame.right != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.right
            }
            
            calcSubViewLeftRight(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.right
            
        case TGGravity.vert.top:
            if sbv == self || sbv == nil {
                return self.tg_topPadding
            }
            
            if sbv.tgFrame.top != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.top
            }
            
            calcSubViewTopBottom(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.top
            
        case TGGravity.vert.bottom:
            if sbv == self || sbv == nil {
                return selfSize.height - self.tg_bottomPadding
            }
            
            if sbv.tgFrame.bottom != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.bottom
            }
            calcSubViewTopBottom(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.bottom
            
        case TGGravity.horz.fill:
            
            if sbv == self || sbv == nil {
                return selfSize.width - self.tg_leftPadding - self.tg_rightPadding
            }
            
            if sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.width
            }
            
            calcSubViewLeftRight(sbv, selfSize: selfSize)
            return sbv.tgFrame.width
            
        case TGGravity.vert.fill:
            if sbv == self || sbv == nil {
                return selfSize.height - self.tg_topPadding - self.tg_bottomPadding
            }
            
            if sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.height
            }
            
            calcSubViewTopBottom(sbv, selfSize: selfSize)
            return sbv.tgFrame.height
            
        case TGGravity.horz.center:
            if sbv == self || sbv == nil {
                return (selfSize.width - self.tg_leftPadding - self.tg_rightPadding) / 2 + self.tg_leftPadding
            }
            
            
            if sbv.tgFrame.left != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.right != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.left + sbv.tgFrame.width / 2
            }
            
            calcSubViewLeftRight(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.left + sbv.tgFrame.width / 2.0
            
        case TGGravity.vert.center:
            if sbv == self || sbv == nil {
                return (selfSize.height - self.tg_topPadding - self.tg_bottomPadding) / 2 + self.tg_topPadding
            }
            
            
            if sbv.tgFrame.top != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.bottom != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.top + sbv.tgFrame.height / 2.0
            }
            
            calcSubViewTopBottom(sbv, selfSize: selfSize)
            return sbv.tgFrame.top + sbv.tgFrame.height / 2
            
        default:
            print("do nothing")
        }
        
        return 0
    }
    
    
    
    
}
