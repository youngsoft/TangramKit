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
    
    override func tgCalcLayoutRect(_ size: CGSize, isEstimate: Bool, type: TGSizeClassType) -> (selfSize: CGSize, hasSubLayout: Bool) {
        
        var (selfSize, hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate: isEstimate, type: type)
        
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
        
        let (maxSize,reCalc) = tgCalcLayoutRectHelper(selfSize)
        
        if self.tg_width.isWrap || self.tg_height.isWrap {
            if /*selfSize.height != maxSize.height*/ _tgCGFloatNotEqual(selfSize.height, maxSize.height) || /*selfSize.width != maxSize.width*/ _tgCGFloatNotEqual(selfSize.width, maxSize.width)
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
                    
                    _ = tgCalcLayoutRectHelper(selfSize)
                }
            }
        }
        
        selfSize.height = self.tgValidMeasure(self.tg_height,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.tgValidMeasure(self.tg_width,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        return (selfSize, hasSubLayout)
    }
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGRelativeLayoutViewSizeClassImpl()
    }
}

extension TGRelativeLayout
{
    fileprivate func tgCalcSubviewLeftRight(_ sbv: UIView, selfSize: CGSize) {
        
        
        if sbv.tgFrame.left != CGFloat.greatestFiniteMagnitude &&
            sbv.tgFrame.right != CGFloat.greatestFiniteMagnitude &&
            sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude
        {
            return
        }
        
        if tgCalcSubviewWidth(sbv, selfSize: selfSize)
        {
            return
        }
        
        if sbv.tg_centerX.hasValue
        {
            if sbv.tg_width.isFill && !self.tgIsNoLayoutSubview(sbv)
            {
                sbv.tgFrame.width = sbv.tg_width.measure(selfSize.width - self.tg_leftPadding - self.tg_rightPadding)
            }
        }
        
        if sbv.tg_centerX.posRelaVal != nil
        {
            let relaView = sbv.tg_centerX.posRelaVal.view
            
            sbv.tgFrame.left = tgCalcRelationalSubview(relaView, gravity: sbv.tg_centerX.posRelaVal._type, selfSize: selfSize) - sbv.tgFrame.width / 2 + sbv.tg_centerX.margin
            
            if relaView != self && self.tgIsNoLayoutSubview(relaView)
            {
                sbv.tgFrame.left -= sbv.tg_centerX.margin;
            }
            
            
            sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
        }
        else if sbv.tg_centerX.posNumVal != nil
        {
            sbv.tgFrame.left = (selfSize.width - self.tg_rightPadding - self.tg_leftPadding - sbv.tgFrame.width) / 2 + self.tg_leftPadding + sbv.tg_centerX.margin
            sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
        }
        else if sbv.tg_centerX.posWeightVal != nil
        {
            sbv.tgFrame.left = (selfSize.width - self.tg_rightPadding - self.tg_leftPadding - sbv.tgFrame.width) / 2 + self.tg_leftPadding + sbv.tg_centerX.realMarginInSize(selfSize.width - self.tg_rightPadding - self.tg_leftPadding)
            sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
        }
        else
        {
            if sbv.tg_left.hasValue
            {
                if sbv.tg_left.posRelaVal != nil
                {
                    let relaView = sbv.tg_left.posRelaVal.view
                    sbv.tgFrame.left = tgCalcRelationalSubview(relaView, gravity:sbv.tg_left.posRelaVal._type, selfSize: selfSize) + sbv.tg_left.margin
                    
                    if relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbv.tgFrame.left -= sbv.tg_left.margin;
                    }
                }
                else if sbv.tg_left.posNumVal != nil
                {
                    sbv.tgFrame.left = sbv.tg_left.margin + self.tg_leftPadding
                }
                else if sbv.tg_left.posWeightVal != nil
                {
                    sbv.tgFrame.left = sbv.tg_left.realMarginInSize(selfSize.width - self.tg_rightPadding - self.tg_leftPadding) + self.tg_leftPadding
                }
                
                if sbv.tg_width.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    //self.tg_leftPadding 这里因为sbv.tgFrame.left已经包含了leftPadding所以这里不需要再减
                    sbv.tgFrame.width = sbv.tg_width.measure(selfSize.width - self.tg_rightPadding - sbv.tgFrame.left)
                }
                
                sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
            }
            
            if sbv.tg_right.hasValue
            {
                if sbv.tg_right.posRelaVal != nil
                {
                    let relaView = sbv.tg_right.posRelaVal.view
                    
                    
                    sbv.tgFrame.right = tgCalcRelationalSubview(relaView, gravity: sbv.tg_right.posRelaVal._type, selfSize: selfSize) - sbv.tg_right.margin + sbv.tg_left.margin
                    
                    if relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbv.tgFrame.right += sbv.tg_right.margin;
                    }
                    
                }
                else if sbv.tg_right.posNumVal != nil
                {
                    sbv.tgFrame.right = selfSize.width - self.tg_rightPadding - sbv.tg_right.margin + sbv.tg_left.margin
                }
                else if sbv.tg_right.posWeightVal != nil
                {
                    sbv.tgFrame.right = selfSize.width - self.tg_rightPadding - sbv.tg_right.realMarginInSize(selfSize.width - self.tg_rightPadding - self.tg_leftPadding) + sbv.tg_left.margin
                }
                
                if sbv.tg_width.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.width = sbv.tg_width.measure(sbv.tgFrame.right - sbv.tg_left.margin - self.tg_leftPadding)
                }
                
                sbv.tgFrame.left = sbv.tgFrame.right - sbv.tgFrame.width
                
            }
            
            if !sbv.tg_left.hasValue && !sbv.tg_right.hasValue
            {
                if sbv.tg_width.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.width = sbv.tg_width.measure(selfSize.width - self.tg_leftPadding - self.tg_rightPadding)
                }
                
                sbv.tgFrame.left = sbv.tg_left.margin + self.tg_leftPadding
                sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
            }
        }
        
        
        //这里要更新左边最小和右边最大约束的情况。
        
        if (sbv.tg_left.minVal.posRelaVal != nil && sbv.tg_right.maxVal.posRelaVal != nil)
        {
            //让宽度缩小并在最小和最大的中间排列。
            let minLeft = self.tgCalcRelationalSubview(sbv.tg_left.minVal.posRelaVal.view, gravity: sbv.tg_left.minVal.posRelaVal._type, selfSize: selfSize) + sbv.tg_left.minVal.offsetVal
        
            
            let maxRight = self.tgCalcRelationalSubview(sbv.tg_right.maxVal.posRelaVal.view, gravity: sbv.tg_right.maxVal.posRelaVal._type, selfSize: selfSize) - sbv.tg_right.maxVal.offsetVal
            
            
            //用maxRight减去minLeft得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
            if (maxRight - minLeft < sbv.tgFrame.width)
            {
                sbv.tgFrame.width = maxRight - minLeft
                sbv.tgFrame.left = minLeft
            }
            else
            {
                sbv.tgFrame.left = (maxRight - minLeft - sbv.tgFrame.width) / 2 + minLeft
            }
            
            sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
            
        }
        else if (sbv.tg_left.minVal.posRelaVal != nil)
        {
            //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
             let minLeft = self.tgCalcRelationalSubview(sbv.tg_left.minVal.posRelaVal.view, gravity: sbv.tg_left.minVal.posRelaVal._type, selfSize: selfSize) + sbv.tg_left.minVal.offsetVal
            
            if (sbv.tgFrame.left < minLeft)
            {
                sbv.tgFrame.left = minLeft
                sbv.tgFrame.width = sbv.tgFrame.right - sbv.tgFrame.left
            }
            
        }
        else if (sbv.tg_right.maxVal.posRelaVal != nil)
        {
            //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
            let maxRight = self.tgCalcRelationalSubview(sbv.tg_right.maxVal.posRelaVal.view, gravity: sbv.tg_right.maxVal.posRelaVal._type, selfSize: selfSize) - sbv.tg_right.maxVal.offsetVal
            
            if (sbv.tgFrame.right > maxRight)
            {
                sbv.tgFrame.right = maxRight;
                sbv.tgFrame.width = sbv.tgFrame.right - sbv.tgFrame.left
            }
            
        }

        
    }
    
    fileprivate func tgCalcSubviewTopBottom(_ sbv: UIView, selfSize: CGSize) {
        
        
        if sbv.tgFrame.top != CGFloat.greatestFiniteMagnitude &&
            sbv.tgFrame.bottom != CGFloat.greatestFiniteMagnitude &&
            sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude
        {
            return
        }
        
        if tgCalcSubviewHeight(sbv, selfSize: selfSize)
        {
            return
        }
        
        if sbv.tg_centerY.hasValue
        {
            if sbv.tg_height.isFill && !self.tgIsNoLayoutSubview(sbv)
            {
                sbv.tgFrame.height = sbv.tg_height.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
            }
        }
        if sbv.tg_centerY.posRelaVal != nil
        {
            let relaView = sbv.tg_centerY.posRelaVal.view
            
            sbv.tgFrame.top = tgCalcRelationalSubview(relaView, gravity: sbv.tg_centerY.posRelaVal._type, selfSize: selfSize) - sbv.tgFrame.height / 2 + sbv.tg_centerY.margin
            
            
            if  relaView != self && self.tgIsNoLayoutSubview(relaView)
            {
                sbv.tgFrame.top -= sbv.tg_centerY.margin;
            }
            
            
            sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
        }
        else if sbv.tg_centerY.posNumVal != nil
        {
            sbv.tgFrame.top = (selfSize.height - self.tg_topPadding - self.tg_bottomPadding - sbv.tgFrame.height) / 2 + self.tg_topPadding + sbv.tg_centerY.margin
            sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
        }
        else if sbv.tg_centerY.posWeightVal != nil
        {
            sbv.tgFrame.top = (selfSize.height - self.tg_topPadding - self.tg_bottomPadding - sbv.tgFrame.height) / 2 + self.tg_topPadding + sbv.tg_centerY.realMarginInSize(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
            sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
        }
        else
        {
            if sbv.tg_top.hasValue
            {
                if sbv.tg_top.posRelaVal != nil
                {
                    let relaView = sbv.tg_top.posRelaVal.view
                    
                    
                    sbv.tgFrame.top = tgCalcRelationalSubview(relaView, gravity: sbv.tg_top.posRelaVal._type, selfSize: selfSize) + sbv.tg_top.margin
                    
                    if  relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbv.tgFrame.top -= sbv.tg_top.margin;
                    }
                    
                }
                else if sbv.tg_top.posNumVal != nil
                {
                    sbv.tgFrame.top = sbv.tg_top.margin + self.tg_topPadding
                }
                else if sbv.tg_top.posWeightVal != nil
                {
                    sbv.tgFrame.top = sbv.tg_top.realMarginInSize(selfSize.height - self.tg_topPadding - self.tg_bottomPadding) + self.tg_topPadding
                }
                
                if sbv.tg_height.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    //self.tg_topPadding 这里因为sbv.tgFrame.top已经包含了topPadding所以这里不需要再减
                    sbv.tgFrame.height = sbv.tg_height.measure(selfSize.height - self.tg_topPadding - sbv.tgFrame.top)
                }
                
                sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height

            }
            
            if sbv.tg_bottom.hasValue
            {
                if sbv.tg_bottom.posRelaVal != nil
                {
                    let relaView = sbv.tg_bottom.posRelaVal.view
                    
                    sbv.tgFrame.bottom = tgCalcRelationalSubview(relaView, gravity: sbv.tg_bottom.posRelaVal._type, selfSize: selfSize) - sbv.tg_bottom.margin + sbv.tg_top.margin
                    
                    if  relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbv.tgFrame.bottom += sbv.tg_bottom.margin;
                    }
                    
                }
                else if sbv.tg_bottom.posNumVal != nil
                {
                    sbv.tgFrame.bottom = selfSize.height - sbv.tg_bottom.margin - self.tg_bottomPadding + sbv.tg_top.margin
                }
                else if sbv.tg_bottom.posWeightVal != nil
                {
                    sbv.tgFrame.bottom = selfSize.height - sbv.tg_bottom.realMarginInSize(selfSize.height - self.tg_topPadding - self.tg_bottomPadding) - self.tg_bottomPadding + sbv.tg_top.margin
                }
                
                if sbv.tg_height.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.height = sbv.tg_width.measure(sbv.tgFrame.bottom - sbv.tg_top.margin - self.tg_topPadding)
                }
                
                sbv.tgFrame.top = sbv.tgFrame.bottom - sbv.tgFrame.height

            }
        
            if !sbv.tg_top.hasValue && !sbv.tg_bottom.hasValue
            {
                if sbv.tg_height.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.height = sbv.tg_height.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
                }
                
                sbv.tgFrame.top = sbv.tg_top.margin + self.tg_topPadding
                sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
            }
        }
        
        
        //这里要更新上边最小和下边最大约束的情况。
        if (sbv.tg_top.minVal.posRelaVal != nil && sbv.tg_bottom.maxVal.posRelaVal != nil)
        {
            //让高度缩小并在最小和最大的中间排列。
            let minTop = self.tgCalcRelationalSubview(sbv.tg_top.minVal.posRelaVal.view, gravity: sbv.tg_top.minVal.posRelaVal._type, selfSize: selfSize) + sbv.tg_top.minVal.offsetVal
            
            
            let maxBottom = self.tgCalcRelationalSubview(sbv.tg_bottom.maxVal.posRelaVal.view, gravity: sbv.tg_bottom.maxVal.posRelaVal._type, selfSize: selfSize) - sbv.tg_bottom.maxVal.offsetVal
            
            
            //用maxBottom减去minTop得到的高度再减去视图的高度，然后让其居中。。如果高度超过则缩小视图的高度。
            if (maxBottom - minTop < sbv.tgFrame.height)
            {
                sbv.tgFrame.height = maxBottom - minTop
                sbv.tgFrame.top = minTop
            }
            else
            {
                sbv.tgFrame.top = (maxBottom - minTop - sbv.tgFrame.height) / 2 + minTop
            }
            
            sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
            
        }
        else if (sbv.tg_top.minVal.posRelaVal != nil)
        {
            //得到上边的最小位置。如果当前的上边距小于这个位置则缩小视图的高度。
            let minTop = self.tgCalcRelationalSubview(sbv.tg_top.minVal.posRelaVal.view, gravity: sbv.tg_top.minVal.posRelaVal._type, selfSize: selfSize) + sbv.tg_top.minVal.offsetVal
        
            
            if (sbv.tgFrame.top < minTop)
            {
                sbv.tgFrame.top = minTop
                sbv.tgFrame.height = sbv.tgFrame.bottom - sbv.tgFrame.top
            }
            
        }
        else if (sbv.tg_bottom.maxVal.posRelaVal != nil)
        {
            //得到下边的最大位置。如果当前的下边距大于了这个位置则缩小视图的高度。
            let maxBottom = self.tgCalcRelationalSubview(sbv.tg_bottom.maxVal.posRelaVal.view, gravity: sbv.tg_bottom.maxVal.posRelaVal._type, selfSize: selfSize) - sbv.tg_bottom.maxVal.offsetVal
            
            if (sbv.tgFrame.bottom > maxBottom)
            {
                sbv.tgFrame.bottom = maxBottom;
                sbv.tgFrame.height = sbv.tgFrame.bottom - sbv.tgFrame.top
            }
            
        }

    }
    
    
    fileprivate func tgCalcSubviewWidth(_ sbv: UIView, selfSize: CGSize) -> Bool {
        if sbv.tgFrame.width == CGFloat.greatestFiniteMagnitude {
            if sbv.tg_width.dimeRelaVal != nil {
                sbv.tgFrame.width = sbv.tg_width.measure(tgCalcRelationalSubview(sbv.tg_width.dimeRelaVal.view, gravity:sbv.tg_width.dimeRelaVal._type, selfSize: selfSize))
                sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_width.dimeNumVal != nil {
                sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_width.dimeWeightVal != nil
            {
                sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure((selfSize.width - self.tg_leftPadding - self.tg_rightPadding) * sbv.tg_width.dimeWeightVal.rawValue/100), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.tgIsNoLayoutSubview(sbv)
            {
                sbv.tgFrame.width = 0
            }
            
            if sbv.tg_left.hasValue && sbv.tg_right.hasValue
            {
                if sbv.tg_left.posRelaVal != nil {
                    sbv.tgFrame.left = tgCalcRelationalSubview(sbv.tg_left.posRelaVal.view, gravity:sbv.tg_left.posRelaVal._type, selfSize: selfSize) + sbv.tg_left.margin
                }
                else {
                    sbv.tgFrame.left = sbv.tg_left.realMarginInSize(selfSize.width - self.tg_leftPadding - self.tg_rightPadding) + self.tg_leftPadding
                }
                
                if sbv.tg_right.posRelaVal != nil {
                    sbv.tgFrame.right = tgCalcRelationalSubview(sbv.tg_right.posRelaVal.view, gravity:sbv.tg_right.posRelaVal._type, selfSize: selfSize) - sbv.tg_right.margin
                }
                else {
                    sbv.tgFrame.right = selfSize.width - sbv.tg_right.realMarginInSize(selfSize.width - self.tg_leftPadding - self.tg_rightPadding) - self.tg_rightPadding
                }
                
                sbv.tgFrame.width = sbv.tgFrame.right - sbv.tgFrame.left
                sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.tgIsNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.width = 0
                    sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width
                }
                
                return true
            }
            
            if sbv.tgFrame.width == CGFloat.greatestFiniteMagnitude {
                sbv.tgFrame.width = sbv.bounds.size.width
                sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbv.tg_width.minVal.dimeNumVal != nil && sbv.tg_width.minVal.dimeNumVal != -CGFloat.greatestFiniteMagnitude) || (sbv.tg_width.maxVal.dimeNumVal != nil && sbv.tg_width.maxVal.dimeNumVal != CGFloat.greatestFiniteMagnitude))
        {
            sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tgFrame.width, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        
        return false
    }
    
    fileprivate func tgCalcSubviewHeight(_ sbv: UIView, selfSize: CGSize) -> Bool {
        if sbv.tgFrame.height == CGFloat.greatestFiniteMagnitude {
            if sbv.tg_height.dimeRelaVal != nil {
                sbv.tgFrame.height = sbv.tg_height.measure(self.tgCalcRelationalSubview(sbv.tg_height.dimeRelaVal.view, gravity:sbv.tg_height.dimeRelaVal._type, selfSize: selfSize))
                sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_height.dimeNumVal != nil {
                sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tg_height.measure, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbv.tg_height.dimeWeightVal != nil
            {
                sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tg_height.measure((selfSize.height - self.tg_topPadding - self.tg_bottomPadding) * sbv.tg_height.dimeWeightVal.rawValue/100), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.tgIsNoLayoutSubview(sbv)
            {
                sbv.tgFrame.height = 0
            }
            
            if sbv.tg_top.hasValue && sbv.tg_bottom.hasValue {
                if sbv.tg_top.posRelaVal != nil {
                    sbv.tgFrame.top = self.tgCalcRelationalSubview(sbv.tg_top.posRelaVal.view, gravity:sbv.tg_top.posRelaVal._type, selfSize: selfSize) + sbv.tg_top.margin
                }
                else {
                    sbv.tgFrame.top = sbv.tg_top.realMarginInSize(selfSize.height - self.tg_topPadding - self.tg_bottomPadding) + self.tg_topPadding
                }
                
                if sbv.tg_bottom.posRelaVal != nil {
                    sbv.tgFrame.bottom = self.tgCalcRelationalSubview(sbv.tg_bottom.posRelaVal.view, gravity:sbv.tg_bottom.posRelaVal._type, selfSize: selfSize) - sbv.tg_bottom.margin
                }
                else {
                    sbv.tgFrame.bottom = selfSize.height - sbv.tg_bottom.realMarginInSize(selfSize.height - self.tg_topPadding - self.tg_bottomPadding) - self.tg_bottomPadding
                }
                
                sbv.tgFrame.height = sbv.tgFrame.bottom - sbv.tgFrame.top
                sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.tgIsNoLayoutSubview(sbv)
                {
                    sbv.tgFrame.height = 0
                    sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height
                }
                
                
                return true
            }
            
            if sbv.tgFrame.height == CGFloat.greatestFiniteMagnitude {
                sbv.tgFrame.height = sbv.bounds.size.height
                
                
                if sbv.tg_height.isFlexHeight && !self.tgIsNoLayoutSubview(sbv)
                {
                    if sbv.tgFrame.width == CGFloat.greatestFiniteMagnitude
                    {
                        _ = self.tgCalcSubviewWidth(sbv, selfSize: selfSize)
                    }
                    
                    sbv.tgFrame.height = self.tgCalcHeightFromHeightWrapView(sbv, width: sbv.tgFrame.width)
                }
                
                sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbv.tg_height.minVal.dimeNumVal != nil && sbv.tg_height.minVal.dimeNumVal != -CGFloat.greatestFiniteMagnitude) || (sbv.tg_height.maxVal.dimeNumVal != nil && sbv.tg_height.maxVal.dimeNumVal != CGFloat.greatestFiniteMagnitude))
        {
            sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        return false
    }
    
    fileprivate func tgCalcLayoutRectHelper(_ selfSize: CGSize) -> (selfSize: CGSize, reCalc: Bool) {
        
        var recalc: Bool = false
        
        
        for sbv:UIView in self.subviews
        {
            self.tgCalcSizeFromSizeWrapSubview(sbv);
            
            if (sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude)
            {
                if (sbv.tg_width.maxVal.dimeRelaVal != nil && sbv.tg_width.maxVal.dimeRelaVal.view != self)
                {
                    _ = self.tgCalcSubviewWidth(sbv.tg_width.maxVal.dimeRelaVal.view, selfSize:selfSize)
                }
                
                if (sbv.tg_width.minVal.dimeRelaVal != nil && sbv.tg_width.minVal.dimeRelaVal.view != self)
                {
                    _ = self.tgCalcSubviewWidth(sbv.tg_width.minVal.dimeRelaVal.view, selfSize:selfSize)
                }
                
                sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv:sbv, calcSize:sbv.tgFrame.width, sbvSize:sbv.tgFrame.frame.size,selfLayoutSize:selfSize)
            }
            
            if (sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude)
            {
                if (sbv.tg_height.maxVal.dimeRelaVal != nil && sbv.tg_height.maxVal.dimeRelaVal.view != self)
                {
                    _ = self.tgCalcSubviewHeight(sbv.tg_height.maxVal.dimeRelaVal.view,selfSize:selfSize)
                }
                
                if (sbv.tg_height.minVal.dimeRelaVal != nil && sbv.tg_height.minVal.dimeRelaVal.view != self)
                {
                    _ = self.tgCalcSubviewHeight(sbv.tg_height.minVal.dimeRelaVal.view,selfSize:selfSize)
                }
                
                sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            
        }
        
        
        for sbv: UIView in self.subviews {
            
            if sbv.tg_width.dimeArrVal != nil {
                recalc = true
                
                let dimeArray: [TGLayoutSize] = sbv.tg_width.dimeArrVal
                var  isViewHidden = self.tgIsNoLayoutSubview(sbv) && self.tg_autoLayoutViewGroupWidth
                var totalMulti: CGFloat = isViewHidden ? 0 : sbv.tg_width.multiVal
                var totalAdd: CGFloat = isViewHidden ? 0 : sbv.tg_width.addVal
                
                for dime:TGLayoutSize in dimeArray
                {
                    if dime.isActive
                    {
                        isViewHidden = self.tgIsNoLayoutSubview(dime.view) && self.tg_autoLayoutViewGroupWidth
                        if !isViewHidden {
                            if dime.dimeNumVal != nil {
                                totalAdd += (-1 * dime.dimeNumVal)
                            }
                            else if (dime.view as? TGBaseLayout) == nil && dime.isWrap
                            {
                                totalAdd += -1 * dime.view.tgFrame.width
                            }
                            else {
                                totalMulti += dime.multiVal
                            }
                            
                            totalAdd += dime.addVal
                        }
                    }
                }
                
                var floatWidth: CGFloat = selfSize.width - self.tg_leftPadding - self.tg_rightPadding + totalAdd
                if /*floatWidth <= 0*/ _tgCGFloatLessOrEqual(floatWidth, 0)
                {
                    floatWidth = 0
                }
                
                if totalMulti != 0 {
                    sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: floatWidth * (sbv.tg_width.multiVal / totalMulti), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.tgIsNoLayoutSubview(sbv)
                    {
                        sbv.tgFrame.width = 0
                    }
                    
                    for dime:TGLayoutSize in dimeArray
                    {
                        if dime.isActive
                        {
                            if dime.dimeNumVal == nil {
                                dime.view.tgFrame.width = floatWidth * (dime.multiVal / totalMulti)
                            }
                            else {
                                dime.view.tgFrame.width = dime.dimeNumVal
                            }
                            
                            dime.view.tgFrame.width = self.tgValidMeasure(dime.view.tg_width, sbv: dime.view, calcSize: dime.view.tgFrame.width, sbvSize: dime.view.tgFrame.frame.size, selfLayoutSize: selfSize)
                            
                            if self.tgIsNoLayoutSubview(dime.view)
                            {
                                dime.view.tgFrame.width = 0
                            }
                        }
                        
                    }
                }
            }
            
            
            if sbv.tg_height.dimeArrVal != nil {
                recalc = true
                
                let dimeArray: [TGLayoutSize] = sbv.tg_height.dimeArrVal
                var isViewHidden: Bool = self.tgIsNoLayoutSubview(sbv) && self.tg_autoLayoutViewGroupHeight
                var totalMulti = isViewHidden ? 0 : sbv.tg_height.multiVal
                var totalAdd = isViewHidden ? 0 : sbv.tg_height.addVal
                for dime:TGLayoutSize in dimeArray
                {
                    if dime.isActive
                    {
                        isViewHidden =  self.tgIsNoLayoutSubview(dime.view) && self.tg_autoLayoutViewGroupHeight
                        if !isViewHidden {
                            if dime.dimeNumVal != nil {
                                totalAdd += (-1 * dime.dimeNumVal!)
                            }
                            else if (dime.view as? TGBaseLayout) == nil && dime.isWrap
                            {
                                totalAdd += -1 * dime.view.tgFrame.height;
                            }
                            else {
                                totalMulti += dime.multiVal
                            }
                            
                            totalAdd += dime.addVal
                        }
                    }
                }
                
                var floatHeight = selfSize.height - self.tg_topPadding - self.tg_bottomPadding + totalAdd
                if /*floatHeight <= 0*/ _tgCGFloatLessOrEqual(floatHeight, 0)
                {
                    floatHeight = 0
                }
                if totalMulti != 0 {
                    sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: floatHeight * (sbv.tg_height.multiVal / totalMulti), sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.tgIsNoLayoutSubview(sbv)
                    {
                        sbv.tgFrame.height = 0
                    }
                    
                    for dime: TGLayoutSize in dimeArray
                    {
                        if dime.isActive
                        {
                            if dime.dimeNumVal == nil {
                                dime.view.tgFrame.height = floatHeight * (dime.multiVal / totalMulti)
                            }
                            else {
                                dime.view.tgFrame.height = dime.dimeNumVal
                            }
                            
                            dime.view.tgFrame.height = self.tgValidMeasure(dime.view.tg_height, sbv: dime.view, calcSize: dime.view.tgFrame.height, sbvSize: dime.view.tgFrame.frame.size, selfLayoutSize: selfSize)
                            
                            if self.tgIsNoLayoutSubview(dime.view)
                            {
                                dime.view.tgFrame.height = 0
                            }
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
                    if !self.tgIsNoLayoutSubview(pos.view)
                    {
                        if totalWidth != 0
                        {
                            if nextPos != nil
                            {
                                totalOffset += nextPos.view.tg_centerX.margin
                            }
                        }
                        
                        _ = self.tgCalcSubviewWidth(pos.view, selfSize: selfSize)
                        totalWidth += pos.view.tgFrame.width
                    }
                    
                    nextPos = pos
                    i -= 1
                }
                
                if !self.tgIsNoLayoutSubview(sbv)
                {
                    if totalWidth != 0
                    {
                        if nextPos != nil
                        {
                            totalOffset += nextPos.view.tg_centerX.margin
                        }
                    }
                    
                    _ = self.tgCalcSubviewWidth(sbv, selfSize: selfSize)
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
                    if !self.tgIsNoLayoutSubview(pos.view)
                    {
                        if totalHeight != 0
                        {
                            if nextPos != nil
                            {
                                totalOffset += nextPos.view.tg_centerY.margin
                            }
                        }
                        
                        _  = self.tgCalcSubviewHeight(pos.view, selfSize: selfSize)
                        totalHeight += pos.view.tgFrame.height
                    }
                    
                    nextPos = pos
                    i -= 1
                }
                
                if !self.tgIsNoLayoutSubview(sbv)
                {
                    if totalHeight != 0
                    {
                        if nextPos != nil
                        {
                            totalOffset += nextPos.view.tg_centerY.margin
                        }
                    }
                    
                    _ = self.tgCalcSubviewHeight(sbv, selfSize: selfSize)
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
            
            tgCalcSubviewLeftRight(sbv, selfSize: selfSize)
            
            if (sbv.tg_right.posRelaVal != nil && sbv.tg_right.posRelaVal.view == self) || sbv.tg_right.posWeightVal != nil
            {
                recalc = true
            }
            
            if (sbv.tg_width.dimeRelaVal != nil && sbv.tg_width.dimeRelaVal.view == self) || sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill
            {
                canCalcMaxWidth = false
                recalc = true
            }
            
            if sbv.tg_left.posRelaVal != nil && sbv.tg_left.posRelaVal.view == self && sbv.tg_right.posRelaVal != nil && sbv.tg_right.posRelaVal.view == self
            {
                canCalcMaxWidth = false
            }
            
            
            
            if sbv.tg_height.isFlexHeight {
                sbv.tgFrame.height = self.tgCalcHeightFromHeightWrapView(sbv, width: sbv.tgFrame.width)
                sbv.tgFrame.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: sbv.tgFrame.height, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            tgCalcSubviewTopBottom(sbv, selfSize: selfSize)
            
                        
            if (sbv.tg_bottom.posRelaVal != nil && sbv.tg_bottom.posRelaVal.view == self) || sbv.tg_bottom.posWeightVal != nil
            {
                recalc = true
            }
            
            if (sbv.tg_height.dimeRelaVal != nil && sbv.tg_height.dimeRelaVal.view == self) ||  sbv.tg_height.isFill || sbv.tg_height.dimeWeightVal != nil
            {
                recalc = true
                canCalcMaxHeight = false
            }
            
           
            if sbv.tg_top.posRelaVal != nil && sbv.tg_top.posRelaVal.view == self && sbv.tg_bottom.posRelaVal != nil && sbv.tg_bottom.posRelaVal.view == self {
                canCalcMaxHeight = false
            }
            
            if self.tgIsNoLayoutSubview(sbv)
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
    
    fileprivate func tgCalcRelationalSubview(_ sbv: UIView!, gravity:TGGravity, selfSize: CGSize) -> CGFloat {
        switch gravity {
        case TGGravity.horz.left:
            if sbv == self || sbv == nil {
                return self.tg_leftPadding
            }
            
            if sbv.tgFrame.left != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.left
            }
            
            
            tgCalcSubviewLeftRight(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.left
            
            
        case TGGravity.horz.right:
            if sbv == self || sbv == nil {
                return selfSize.width - self.tg_rightPadding
            }
            
            
            if sbv.tgFrame.right != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.right
            }
            
            tgCalcSubviewLeftRight(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.right
            
        case TGGravity.vert.top:
            if sbv == self || sbv == nil {
                return self.tg_topPadding
            }
            
            if sbv.tgFrame.top != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.top
            }
            
            tgCalcSubviewTopBottom(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.top
            
        case TGGravity.vert.bottom:
            if sbv == self || sbv == nil {
                return selfSize.height - self.tg_bottomPadding
            }
            
            if sbv.tgFrame.bottom != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.bottom
            }
            tgCalcSubviewTopBottom(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.bottom
            
        case TGGravity.horz.fill:
            
            if sbv == self || sbv == nil {
                return selfSize.width - self.tg_leftPadding - self.tg_rightPadding
            }
            
            if sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.width
            }
            
            tgCalcSubviewLeftRight(sbv, selfSize: selfSize)
            return sbv.tgFrame.width
            
        case TGGravity.vert.fill:
            if sbv == self || sbv == nil {
                return selfSize.height - self.tg_topPadding - self.tg_bottomPadding
            }
            
            if sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.height
            }
            
            tgCalcSubviewTopBottom(sbv, selfSize: selfSize)
            return sbv.tgFrame.height
            
        case TGGravity.horz.center:
            if sbv == self || sbv == nil {
                return (selfSize.width - self.tg_leftPadding - self.tg_rightPadding) / 2 + self.tg_leftPadding
            }
            
            
            if sbv.tgFrame.left != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.right != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.width != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.left + sbv.tgFrame.width / 2
            }
            
            tgCalcSubviewLeftRight(sbv, selfSize: selfSize)
            
            return sbv.tgFrame.left + sbv.tgFrame.width / 2.0
            
        case TGGravity.vert.center:
            if sbv == self || sbv == nil {
                return (selfSize.height - self.tg_topPadding - self.tg_bottomPadding) / 2 + self.tg_topPadding
            }
            
            
            if sbv.tgFrame.top != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.bottom != CGFloat.greatestFiniteMagnitude && sbv.tgFrame.height != CGFloat.greatestFiniteMagnitude {
                return sbv.tgFrame.top + sbv.tgFrame.height / 2.0
            }
            
            tgCalcSubviewTopBottom(sbv, selfSize: selfSize)
            return sbv.tgFrame.top + sbv.tgFrame.height / 2
            
        default:
            print("do nothing")
        }
        
        return 0
    }
    
    
    
    
}
