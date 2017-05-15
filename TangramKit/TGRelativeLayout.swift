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
            let lsc = self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClass
            if lsc.tg_autoLayoutViewGroupWidth != newValue
            {
                lsc.tg_autoLayoutViewGroupWidth = newValue;
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
            let lsc = self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClass
            if lsc.tg_autoLayoutViewGroupHeight != newValue
            {
                lsc.tg_autoLayoutViewGroupHeight = newValue
                setNeedsLayout()
            }
        }
    }
    
    //MARK: override method
    
    override func tgCalcLayoutRect(_ size: CGSize, isEstimate: Bool, sbs:[UIView]!, type: TGSizeClassType) -> (selfSize: CGSize, hasSubLayout: Bool) {
        
        var (selfSize, hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate: isEstimate, sbs:sbs, type: type)
        
        let lsc = self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClassImpl
        
        let selftgWidthIsWrap = lsc.tgWidth?.isWrap ?? false
        let selftgHeightIsWrap = lsc.tgHeight?.isWrap ?? false
        
        for sbv: UIView in self.subviews
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
           
            if sbvsc.tg_useFrame
            {
                continue
            }
            
            if !isEstimate {
                sbvtgFrame.reset()
            }
            
            
            let sbvtgWidthIsWrap = sbvsc.tgWidth?.isWrap ?? false
            let sbvtgHeightIsWrap = sbvsc.tgHeight?.isWrap ?? false
            let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
            let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
            let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
            let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false
            
        
            if sbvtgLeadingHasValue && sbvtgTrailingHasValue {
                
                sbvsc.tgWidth?._dimeVal = nil
            }
            
            if sbvtgTopHasValue && sbvtgBottomHasValue
            {
                sbvsc.tgHeight?._dimeVal = nil
            }
            
            
            if let sbvl: TGBaseLayout = sbv as? TGBaseLayout
            {
                
                if sbvtgWidthIsWrap || sbvtgHeightIsWrap
                {
                    hasSubLayout = true
                }
                
                if isEstimate && (sbvtgWidthIsWrap || sbvtgHeightIsWrap)
                {
                    
                    _ = sbvl.tg_sizeThatFits(sbvtgFrame.frame.size, inSizeClass:type)
                    
                    sbvtgFrame.leading = CGFloat.greatestFiniteMagnitude
                    sbvtgFrame.trailing = CGFloat.greatestFiniteMagnitude
                    sbvtgFrame.top = CGFloat.greatestFiniteMagnitude
                    sbvtgFrame.bottom = CGFloat.greatestFiniteMagnitude;
                    
                    if sbvtgFrame.multiple
                    {
                        sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)  //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    }
                }
            }
        }
        
        let isWrap = selftgWidthIsWrap || selftgHeightIsWrap
        
        let (maxSize,recalc) = tgCalcLayoutRectHelper(selfSize, lsc:lsc, isWrap: isWrap)
        
        if isWrap
        {
            if _tgCGFloatNotEqual(selfSize.height, maxSize.height) ||  _tgCGFloatNotEqual(selfSize.width, maxSize.width)
            {
                if selftgWidthIsWrap {
                    selfSize.width = maxSize.width
                }
                
                if selftgHeightIsWrap {
                    selfSize.height = maxSize.height
                }
                
                if recalc
                {
                    for sbv: UIView in self.subviews {
                        
                        let sbvtgFrame = sbv.tgFrame
                        
                        if let _ = sbv as? TGBaseLayout , isEstimate
                        {
                            sbvtgFrame.leading = CGFloat.greatestFiniteMagnitude
                            sbvtgFrame.trailing = CGFloat.greatestFiniteMagnitude
                            sbvtgFrame.top = CGFloat.greatestFiniteMagnitude
                            sbvtgFrame.bottom = CGFloat.greatestFiniteMagnitude
                        }
                        else
                        {
                            sbvtgFrame.reset()
                        }
                    }
                    
                    _ = tgCalcLayoutRectHelper(selfSize, lsc:lsc, isWrap: false)
                }
            }
        }
        
        
        let sbs2 = self.tgGetLayoutSubviews()
        tgAdjustLayoutSelfSize(selfSize: &selfSize, lsc: lsc)
        
        tgAdjustSubviewsRTLPos(sbs: sbs2, selfWidth: selfSize.width)
        
        return (self.tgAdjustSizeWhenNoSubviews(size: selfSize, sbs: sbs2, lsc:lsc), hasSubLayout)
    }
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGRelativeLayoutViewSizeClassImpl(view:self)
    }
}

extension TGRelativeLayout
{
    fileprivate func tgCalcSubviewLeadingTrailing(_ sbv: UIView, sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame, lsc:TGRelativeLayoutViewSizeClassImpl, selfSize: CGSize) {
        
        
        if sbvtgFrame.leading != CGFloat.greatestFiniteMagnitude &&
            sbvtgFrame.trailing != CGFloat.greatestFiniteMagnitude &&
            sbvtgFrame.width != CGFloat.greatestFiniteMagnitude
        {
            return
        }
        
        if tgCalcSubviewWidth(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
        {
            return
        }
        
        let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
        let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
        let sbvtgCenterXHasValue = sbvsc.tgCenterX?.hasValue ?? false
        let sbvLeadingMargin = sbvsc.tgLeading?.margin ?? 0
        let sbvTrailingMargin = sbvsc.tgTrailing?.margin ?? 0
        let sbvCenterXMargin = sbvsc.tgCenterX?.margin ?? 0

        
        if sbvtgCenterXHasValue
        {
            if let t = sbvsc.tgWidth, t.isFill && !self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.width = sbvsc.tgWidth!.measure(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding)
            }
        }
        
        if sbvsc.tgCenterX?.posRelaVal != nil
        {
            let relaView = sbvsc.tgCenterX!.posRelaVal.view
            
            sbvtgFrame.leading = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: sbvsc.tgCenterX!.posRelaVal._type, selfSize: selfSize) - sbvtgFrame.width / 2 + sbvCenterXMargin
            
            if relaView != self && self.tgIsNoLayoutSubview(relaView)
            {
                sbvtgFrame.leading -= sbvCenterXMargin
            }
            
            if let t = lsc.tgWidth, t.isWrap && sbvtgFrame.leading < 0 && relaView === self
            {
                sbvtgFrame.leading = 0
            }
            
            
            sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
        }
        else if sbvsc.tgCenterX?.posNumVal != nil
        {
            sbvtgFrame.leading = (selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding - sbvtgFrame.width) / 2 + lsc.tg_leadingPadding + sbvCenterXMargin
            
            
            if let t = lsc.tgWidth, t.isWrap &&  sbvtgFrame.leading < 0
            {
                sbvtgFrame.leading = 0
            }
            
            sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
        }
        else if sbvsc.tgCenterX?.posWeightVal != nil
        {
            sbvtgFrame.leading = (selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding - sbvtgFrame.width) / 2 + lsc.tg_leadingPadding + sbvsc.tgCenterX!.realMarginInSize(selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding)
            
            
            if let t = lsc.tgWidth, t.isWrap &&  sbvtgFrame.leading < 0
            {
                sbvtgFrame.leading = 0
            }
            
            sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
        }
        else
        {
            if sbvtgLeadingHasValue
            {
                if sbvsc.tgLeading?.posRelaVal != nil
                {
                    let relaView = sbvsc.tgLeading!.posRelaVal.view
                    sbvtgFrame.leading = tgCalcRelationalSubview(relaView, lsc:lsc, gravity:sbvsc.tgLeading!.posRelaVal._type, selfSize: selfSize) + sbvLeadingMargin
                    
                    if relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.leading -= sbvLeadingMargin
                    }
                }
                else if sbvsc.tgLeading?.posNumVal != nil
                {
                    sbvtgFrame.leading = sbvLeadingMargin + lsc.tg_leadingPadding
                }
                else if sbvsc.tgLeading?.posWeightVal != nil
                {
                    sbvtgFrame.leading = sbvsc.tgLeading!.realMarginInSize(selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding) + lsc.tg_leadingPadding
                }
                
                if let t = sbvsc.tgWidth, t.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    //lsc.tg_leadingPadding 这里因为sbvtgFrame.leading已经包含了leftPadding所以这里不需要再减
                    sbvtgFrame.width = sbvsc.tgWidth!.measure(selfSize.width - lsc.tg_trailingPadding - sbvtgFrame.leading)
                }
                
                sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
            }
            
            if sbvtgTrailingHasValue
            {
                if sbvsc.tgTrailing?.posRelaVal != nil
                {
                    let relaView = sbvsc.tgTrailing!.posRelaVal.view
                    
                    
                    sbvtgFrame.trailing = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: sbvsc.tgTrailing!.posRelaVal._type, selfSize: selfSize) - sbvTrailingMargin + sbvLeadingMargin
                    
                    if relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.trailing += sbvTrailingMargin
                    }
                    
                }
                else if sbvsc.tgTrailing?.posNumVal != nil
                {
                    sbvtgFrame.trailing = selfSize.width - lsc.tg_trailingPadding - sbvTrailingMargin + sbvLeadingMargin
                }
                else if sbvsc.tgTrailing?.posWeightVal != nil
                {
                    sbvtgFrame.trailing = selfSize.width - lsc.tg_trailingPadding - sbvsc.tgTrailing!.realMarginInSize(selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding) + sbvLeadingMargin
                }
                
                if let t = sbvsc.tgWidth, t.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.width = sbvsc.tgWidth!.measure(sbvtgFrame.trailing - sbvLeadingMargin - lsc.tg_leadingPadding)
                }
                
                sbvtgFrame.leading = sbvtgFrame.trailing - sbvtgFrame.width
                
            }
            
            if !sbvtgLeadingHasValue && !sbvtgTrailingHasValue
            {
                if let t = sbvsc.tgWidth, t.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.width = sbvsc.tgWidth!.measure(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding)
                }
                
                sbvtgFrame.leading =  sbvLeadingMargin + lsc.tg_leadingPadding
                sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
            }
        }
        
        
        //这里要更新左边最小和右边最大约束的情况。
        
        if (sbvsc.tgLeading?.tgMinVal?.posRelaVal != nil && sbvsc.tgTrailing?.tgMaxVal?.posRelaVal != nil)
        {
            //让宽度缩小并在最小和最大的中间排列。
            let minLeading = self.tgCalcRelationalSubview(sbvsc.tgLeading!.tgMinVal!.posRelaVal.view, lsc:lsc, gravity: sbvsc.tgLeading!.tgMinVal!.posRelaVal._type, selfSize: selfSize) + sbvsc.tgLeading!.tgMinVal!.offsetVal
        
            
            let maxTrailing = self.tgCalcRelationalSubview(sbvsc.tgTrailing!.tgMaxVal!.posRelaVal.view, lsc:lsc,  gravity: sbvsc.tgTrailing!.tgMaxVal!.posRelaVal._type, selfSize: selfSize) - sbvsc.tgTrailing!.tgMaxVal!.offsetVal
            
            
            //用maxTrailing减去minLeading得到的宽度再减去视图的宽度，然后让其居中。。如果宽度超过则缩小视图的宽度。
            if (maxTrailing - minLeading < sbvtgFrame.width)
            {
                sbvtgFrame.width = maxTrailing - minLeading
                sbvtgFrame.leading = minLeading
            }
            else
            {
                sbvtgFrame.leading = (maxTrailing - minLeading - sbvtgFrame.width) / 2 + minLeading
            }
            
            sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
            
        }
        else if (sbvsc.tgLeading?.tgMinVal?.posRelaVal != nil)
        {
            //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
            let minLeading = self.tgCalcRelationalSubview(sbvsc.tgLeading!.tgMinVal!.posRelaVal.view, lsc:lsc, gravity: sbvsc.tgLeading!.tgMinVal!.posRelaVal._type, selfSize: selfSize) + sbvsc.tgLeading!.tgMinVal!.offsetVal
            
            if (sbvtgFrame.leading < minLeading)
            {
                sbvtgFrame.leading = minLeading
                sbvtgFrame.width = sbvtgFrame.trailing - sbvtgFrame.leading
            }
            
        }
        else if (sbvsc.tgTrailing?.tgMaxVal?.posRelaVal != nil)
        {
            //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
            let maxTrailing = self.tgCalcRelationalSubview(sbvsc.tgTrailing!.tgMaxVal!.posRelaVal.view, lsc:lsc, gravity: sbvsc.tgTrailing!.tgMaxVal!.posRelaVal._type, selfSize: selfSize) - sbvsc.tgTrailing!.tgMaxVal!.offsetVal
            
            if (sbvtgFrame.trailing > maxTrailing)
            {
                sbvtgFrame.trailing = maxTrailing;
                sbvtgFrame.width = sbvtgFrame.trailing - sbvtgFrame.leading
            }
            
        }

        
    }
    
    fileprivate func tgCalcSubviewTopBottom(_ sbv: UIView, sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame, lsc:TGRelativeLayoutViewSizeClassImpl,selfSize: CGSize) {
        
        
        
        
        if sbvtgFrame.top != CGFloat.greatestFiniteMagnitude &&
            sbvtgFrame.bottom != CGFloat.greatestFiniteMagnitude &&
            sbvtgFrame.height != CGFloat.greatestFiniteMagnitude
        {
            return
        }
        
        if tgCalcSubviewHeight(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
        {
            return
        }
        
        let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
        let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false
        let sbvtgCenterYHasValue = sbvsc.tgCenterY?.hasValue ?? false
        let sbvTopMargin = sbvsc.tgTop?.margin ?? 0
        let sbvBottomMargin = sbvsc.tgBottom?.margin ?? 0
        let sbvCenterYMargin = sbvsc.tgCenterY?.margin ?? 0
        
        if sbvtgCenterYHasValue
        {
            if let t = sbvsc.tgHeight, t.isFill && !self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.height = sbvsc.tgHeight!.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
            }
        }
        if sbvsc.tgCenterY?.posRelaVal != nil
        {
            let relaView = sbvsc.tgCenterY!.posRelaVal.view
            
            sbvtgFrame.top = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: sbvsc.tgCenterY!.posRelaVal._type, selfSize: selfSize) - sbvtgFrame.height / 2 + sbvCenterYMargin
            
            
            if  relaView != self && self.tgIsNoLayoutSubview(relaView)
            {
                sbvtgFrame.top -= sbvCenterYMargin
            }
            
            if let t = lsc.tgHeight, t.isWrap &&  sbvtgFrame.top < 0 && relaView === self
            {
                sbvtgFrame.top = 0
            }
            
            sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
        }
        else if sbvsc.tgCenterY?.posNumVal != nil
        {
            sbvtgFrame.top = (selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding - sbvtgFrame.height) / 2 + lsc.tg_topPadding + sbvCenterYMargin
            
            if  let t = lsc.tgHeight, t.isWrap &&  sbvtgFrame.top < 0
            {
                sbvtgFrame.top = 0
            }
            
            sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
        }
        else if sbvsc.tgCenterY?.posWeightVal != nil
        {
            sbvtgFrame.top = (selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding - sbvtgFrame.height) / 2 + lsc.tg_topPadding + sbvsc.tgCenterY!.realMarginInSize(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
            
            if  let t = lsc.tgHeight, t.isWrap &&  sbvtgFrame.top < 0
            {
                sbvtgFrame.top = 0
            }
            
            sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
        }
        else
        {
            if sbvtgTopHasValue
            {
                if sbvsc.tgTop?.posRelaVal != nil
                {
                    let relaView = sbvsc.tgTop!.posRelaVal.view
                    
                    
                    sbvtgFrame.top = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: sbvsc.tgTop!.posRelaVal._type, selfSize: selfSize) + sbvTopMargin
                    
                    if  relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.top -= sbvTopMargin
                    }
                    
                }
                else if sbvsc.tgTop?.posNumVal != nil
                {
                    sbvtgFrame.top = sbvTopMargin + lsc.tg_topPadding
                }
                else if sbvsc.tgTop?.posWeightVal != nil
                {
                    sbvtgFrame.top = sbvsc.tgTop!.realMarginInSize(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) + lsc.tg_topPadding
                }
                
                if let t = sbvsc.tgHeight, t.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    //lsc.tg_topPadding 这里因为sbvtgFrame.top已经包含了topPadding所以这里不需要再减
                    sbvtgFrame.height = sbvsc.tgHeight!.measure(selfSize.height - lsc.tg_topPadding - sbvtgFrame.top)
                }
                
                sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height

            }
            
            if sbvtgBottomHasValue
            {
                if sbvsc.tgBottom!.posRelaVal != nil
                {
                    let relaView = sbvsc.tgBottom!.posRelaVal.view
                    
                    sbvtgFrame.bottom = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: sbvsc.tgBottom!.posRelaVal._type, selfSize: selfSize) - sbvBottomMargin + sbvTopMargin
                    
                    if  relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.bottom += sbvBottomMargin
                    }
                    
                }
                else if sbvsc.tgBottom!.posNumVal != nil
                {
                    sbvtgFrame.bottom = selfSize.height - sbvBottomMargin - lsc.tg_bottomPadding + sbvTopMargin
                }
                else if sbvsc.tgBottom!.posWeightVal != nil
                {
                    sbvtgFrame.bottom = selfSize.height - sbvsc.tgBottom!.realMarginInSize(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) - lsc.tg_bottomPadding + sbvTopMargin
                }
                
                if let t = sbvsc.tgHeight, t.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.height = sbvsc.tgHeight!.measure(sbvtgFrame.bottom - sbvTopMargin - lsc.tg_topPadding)
                }
                
                sbvtgFrame.top = sbvtgFrame.bottom - sbvtgFrame.height

            }
        
            if !sbvtgTopHasValue && !sbvtgBottomHasValue
            {
                if let t = sbvsc.tgHeight, t.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.height = sbvsc.tgHeight!.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
                }
                
                sbvtgFrame.top = sbvTopMargin + lsc.tg_topPadding
                sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
            }
        }
        
        
        //这里要更新上边最小和下边最大约束的情况。
        if (sbvsc.tgTop?.tgMinVal?.posRelaVal != nil && sbvsc.tgBottom?.tgMaxVal?.posRelaVal != nil)
        {
            //让高度缩小并在最小和最大的中间排列。
            let minTop = self.tgCalcRelationalSubview(sbvsc.tgTop!.tgMinVal!.posRelaVal.view,lsc:lsc, gravity: sbvsc.tgTop!.tgMinVal!.posRelaVal._type, selfSize: selfSize) + sbvsc.tgTop!.tgMinVal!.offsetVal
            
            
            let maxBottom = self.tgCalcRelationalSubview(sbvsc.tgBottom!.tgMaxVal!.posRelaVal.view, lsc:lsc, gravity: sbvsc.tgBottom!.tgMaxVal!.posRelaVal._type, selfSize: selfSize) - sbvsc.tgBottom!.tgMaxVal!.offsetVal
            
            
            //用maxBottom减去minTop得到的高度再减去视图的高度，然后让其居中。。如果高度超过则缩小视图的高度。
            if (maxBottom - minTop < sbvtgFrame.height)
            {
                sbvtgFrame.height = maxBottom - minTop
                sbvtgFrame.top = minTop
            }
            else
            {
                sbvtgFrame.top = (maxBottom - minTop - sbvtgFrame.height) / 2 + minTop
            }
            
            sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
            
        }
        else if (sbvsc.tgTop?.tgMinVal?.posRelaVal != nil)
        {
            //得到上边的最小位置。如果当前的上边距小于这个位置则缩小视图的高度。
            let minTop = self.tgCalcRelationalSubview(sbvsc.tgTop!.tgMinVal!.posRelaVal.view, lsc:lsc, gravity: sbvsc.tgTop!.tgMinVal!.posRelaVal._type, selfSize: selfSize) + sbvsc.tgTop!.tgMinVal!.offsetVal
        
            
            if (sbvtgFrame.top < minTop)
            {
                sbvtgFrame.top = minTop
                sbvtgFrame.height = sbvtgFrame.bottom - sbvtgFrame.top
            }
            
        }
        else if (sbvsc.tgBottom?.tgMaxVal?.posRelaVal != nil)
        {
            //得到下边的最大位置。如果当前的下边距大于了这个位置则缩小视图的高度。
            let maxBottom = self.tgCalcRelationalSubview(sbvsc.tgBottom!.tgMaxVal!.posRelaVal.view, lsc:lsc, gravity: sbvsc.tgBottom!.tgMaxVal!.posRelaVal._type, selfSize: selfSize) - sbvsc.tgBottom!.tgMaxVal!.offsetVal
            
            if (sbvtgFrame.bottom > maxBottom)
            {
                sbvtgFrame.bottom = maxBottom;
                sbvtgFrame.height = sbvtgFrame.bottom - sbvtgFrame.top
            }
            
        }

    }
    
    
    fileprivate func tgCalcSubviewWidth(_ sbv: UIView, sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame, lsc:TGRelativeLayoutViewSizeClassImpl,  selfSize: CGSize) -> Bool {
        if sbvtgFrame.width == CGFloat.greatestFiniteMagnitude {
            if sbvsc.tgWidth?.dimeRelaVal != nil {
                sbvtgFrame.width = sbvsc.tgWidth!.measure(tgCalcRelationalSubview(sbvsc.tgWidth!.dimeRelaVal.view, lsc:lsc, gravity:sbvsc.tgWidth!.dimeRelaVal._type, selfSize: selfSize))
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbvsc.tgWidth?.dimeNumVal != nil {
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: sbvsc.tgWidth!.measure, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbvsc.tgWidth?.dimeWeightVal != nil
            {
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: sbvsc.tgWidth!.measure((selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding) * sbvsc.tgWidth!.dimeWeightVal.rawValue/100), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.width = 0
            }
            
            let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
            let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
            
            if sbvtgLeadingHasValue && sbvtgTrailingHasValue
            {
                if sbvsc.tgLeading?.posRelaVal != nil {
                    sbvtgFrame.leading = tgCalcRelationalSubview(sbvsc.tgLeading!.posRelaVal.view, lsc:lsc, gravity:sbvsc.tgLeading!.posRelaVal._type, selfSize: selfSize) + sbvsc.tgLeading!.margin
                }
                else {
                    sbvtgFrame.leading = sbvsc.tgLeading!.realMarginInSize(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding) + lsc.tg_leadingPadding
                }
                
                if sbvsc.tgTrailing?.posRelaVal != nil {
                    sbvtgFrame.trailing = tgCalcRelationalSubview(sbvsc.tgTrailing!.posRelaVal.view, lsc:lsc, gravity:sbvsc.tgTrailing!.posRelaVal._type, selfSize: selfSize) - sbvsc.tgTrailing!.margin
                }
                else {
                    sbvtgFrame.trailing = selfSize.width - sbvsc.tgTrailing!.realMarginInSize(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding) - lsc.tg_trailingPadding
                }
                
                sbvtgFrame.width = sbvtgFrame.trailing - sbvtgFrame.leading
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.width = 0
                    sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
                }
                
                return true
            }
            
            if sbvtgFrame.width == CGFloat.greatestFiniteMagnitude {
                sbvtgFrame.width = sbv.bounds.size.width
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbvsc.tgWidth?.tgMinVal?.dimeNumVal != nil && sbvsc.tgWidth!.tgMinVal!.dimeNumVal != -CGFloat.greatestFiniteMagnitude) || (sbvsc.tgWidth?.tgMaxVal?.dimeNumVal != nil && sbvsc.tgWidth!.tgMaxVal!.dimeNumVal != CGFloat.greatestFiniteMagnitude))
        {
            sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        
        return false
    }
    
    fileprivate func tgCalcSubviewHeight(_ sbv: UIView, sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame, lsc:TGRelativeLayoutViewSizeClassImpl,selfSize: CGSize) -> Bool {
        if sbvtgFrame.height == CGFloat.greatestFiniteMagnitude {
            if sbvsc.tgHeight?.dimeRelaVal != nil {
                sbvtgFrame.height = sbvsc.tgHeight!.measure(self.tgCalcRelationalSubview(sbvsc.tgHeight!.dimeRelaVal.view, lsc:lsc, gravity:sbvsc.tgHeight!.dimeRelaVal._type, selfSize: selfSize))
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbvsc.tgHeight?.dimeNumVal != nil {
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvsc.tgHeight!.measure, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbvsc.tgHeight?.dimeWeightVal != nil
            {
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvsc.tgHeight!.measure((selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) * sbvsc.tgHeight!.dimeWeightVal.rawValue/100), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.height = 0
            }
            
            let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
            let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false

            
            if sbvtgTopHasValue && sbvtgBottomHasValue {
                if sbvsc.tgTop?.posRelaVal != nil {
                    sbvtgFrame.top = self.tgCalcRelationalSubview(sbvsc.tgTop!.posRelaVal.view,lsc:lsc, gravity:sbvsc.tgTop!.posRelaVal._type, selfSize: selfSize) + sbvsc.tgTop!.margin
                }
                else {
                    sbvtgFrame.top = sbvsc.tgTop!.realMarginInSize(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) + lsc.tg_topPadding
                }
                
                if sbvsc.tgBottom?.posRelaVal != nil {
                    sbvtgFrame.bottom = self.tgCalcRelationalSubview(sbvsc.tgBottom!.posRelaVal.view,lsc:lsc, gravity:sbvsc.tgBottom!.posRelaVal._type, selfSize: selfSize) - sbvsc.tgBottom!.margin
                }
                else {
                    sbvtgFrame.bottom = selfSize.height - sbvsc.tgBottom!.realMarginInSize(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) - lsc.tg_bottomPadding
                }
                
                sbvtgFrame.height = sbvtgFrame.bottom - sbvtgFrame.top
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.height = 0
                    sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
                }
                
                
                return true
            }
            
            if sbvtgFrame.height == CGFloat.greatestFiniteMagnitude {
                sbvtgFrame.height = sbv.bounds.size.height
                
                
                if let t = sbvsc.tgHeight, t.isFlexHeight && !self.tgIsNoLayoutSubview(sbv)
                {
                    if sbvtgFrame.width == CGFloat.greatestFiniteMagnitude
                    {
                        _ = self.tgCalcSubviewWidth(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
                    }
                    
                    sbvtgFrame.height = self.tgCalcHeightFromHeightWrapView(sbv,sbvsc:sbvsc, width: sbvtgFrame.width)
                }
                
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbvsc.tgHeight?.tgMinVal?.dimeNumVal != nil && sbvsc.tgHeight!.tgMinVal!.dimeNumVal != -CGFloat.greatestFiniteMagnitude) || (sbvsc.tgHeight?.tgMaxVal?.dimeNumVal != nil && sbvsc.tgHeight!.tgMaxVal!.dimeNumVal != CGFloat.greatestFiniteMagnitude))
        {
            sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        return false
    }
    
    fileprivate func tgCalcLayoutRectHelper(_ selfSize: CGSize, lsc:TGRelativeLayoutViewSizeClassImpl, isWrap:Bool) -> (selfSize: CGSize, reCalc: Bool) {
        

        var recalc = false
        
        for sbv:UIView in self.subviews
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            self.tgCalcSizeFromSizeWrapSubview(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame);
            
            if (sbvtgFrame.width != CGFloat.greatestFiniteMagnitude)
            {
                let maxRela = sbvsc.tgWidth?.tgMaxVal?.dimeRelaVal
                if (maxRela != nil && maxRela!.view !== self)
                {
                    _ = self.tgCalcSubviewWidth(maxRela!.view,sbvsc:maxRela!.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:maxRela!.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                let minRela = sbvsc.tgWidth?.tgMinVal?.dimeRelaVal
                if (minRela != nil &&  minRela!.view != self)
                {
                    _ = self.tgCalcSubviewWidth(minRela!.view, sbvsc:minRela!.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:minRela!.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv:sbv, calcSize:sbvtgFrame.width, sbvSize:sbvtgFrame.frame.size,selfLayoutSize:selfSize)
            }
            
            if (sbvtgFrame.height != CGFloat.greatestFiniteMagnitude)
            {
                let maxRela = sbvsc.tgHeight?.tgMaxVal?.dimeRelaVal
                if (maxRela != nil && maxRela!.view !== self)
                {
                    _ = self.tgCalcSubviewHeight(maxRela!.view,sbvsc:maxRela!.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:maxRela!.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                let minRela = sbvsc.tgHeight?.tgMinVal?.dimeRelaVal
                if (minRela != nil && minRela!.view !== self)
                {
                    _ = self.tgCalcSubviewHeight(minRela!.view, sbvsc:minRela!.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:minRela!.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            
        }
        
        
        for sbv: UIView in self.subviews {
            
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            if sbvsc.tgWidth?.dimeArrVal != nil {
                recalc = true
                
                let dimeArray: [TGLayoutSize] = sbvsc.tgWidth!.dimeArrVal
                var  isViewHidden = self.tgIsNoLayoutSubview(sbv) && lsc.tg_autoLayoutViewGroupWidth
                var totalMulti: CGFloat = isViewHidden ? 0 : sbvsc.tgWidth!.multiVal
                var totalAdd: CGFloat = isViewHidden ? 0 : sbvsc.tgWidth!.addVal
                
                for dime:TGLayoutSize in dimeArray
                {
                    if dime.isActive
                    {
                        isViewHidden = self.tgIsNoLayoutSubview(dime.view) && lsc.tg_autoLayoutViewGroupWidth
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
                
                var floatWidth: CGFloat = selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding + totalAdd
                if _tgCGFloatLessOrEqual(floatWidth, 0)
                {
                    floatWidth = 0
                }
                
                if totalMulti != 0 {
                    sbvtgFrame.width = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: floatWidth * (sbvsc.tgWidth!.multiVal / totalMulti), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.tgIsNoLayoutSubview(sbv)
                    {
                        sbvtgFrame.width = 0
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
                            
                            dime.view.tgFrame.width = self.tgValidMeasure(dime.view.tgWidth, sbv: dime.view, calcSize: dime.view.tgFrame.width, sbvSize: dime.view.tgFrame.frame.size, selfLayoutSize: selfSize)
                            
                            if self.tgIsNoLayoutSubview(dime.view)
                            {
                                dime.view.tgFrame.width = 0
                            }
                        }
                        
                    }
                }
            }
            
            
            if sbvsc.tgHeight?.dimeArrVal != nil {
                recalc = true
                
                let dimeArray: [TGLayoutSize] = sbvsc.tgHeight!.dimeArrVal
                var isViewHidden: Bool = self.tgIsNoLayoutSubview(sbv) && lsc.tg_autoLayoutViewGroupHeight
                var totalMulti = isViewHidden ? 0 : sbvsc.tgHeight!.multiVal
                var totalAdd = isViewHidden ? 0 : sbvsc.tgHeight!.addVal
                for dime:TGLayoutSize in dimeArray
                {
                    if dime.isActive
                    {
                        isViewHidden =  self.tgIsNoLayoutSubview(dime.view) && lsc.tg_autoLayoutViewGroupHeight
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
                
                var floatHeight = selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding + totalAdd
                if _tgCGFloatLessOrEqual(floatHeight, 0)
                {
                    floatHeight = 0
                }
                if totalMulti != 0 {
                    sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: floatHeight * (sbvsc.tgHeight!.multiVal / totalMulti), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.tgIsNoLayoutSubview(sbv)
                    {
                        sbvtgFrame.height = 0
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
                            
                            dime.view.tgFrame.height = self.tgValidMeasure(dime.view.tgHeight, sbv: dime.view, calcSize: dime.view.tgFrame.height, sbvSize: dime.view.tgFrame.frame.size, selfLayoutSize: selfSize)
                            
                            if self.tgIsNoLayoutSubview(dime.view)
                            {
                                dime.view.tgFrame.height = 0
                            }
                        }
                        
                    }
                }
            }
            
            
            if sbvsc.tgCenterX?.posArrVal != nil
            {
                
                let centerArray: [TGLayoutPos] = sbvsc.tgCenterX!.posArrVal
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
                                totalOffset += nextPos.view.tgCenterX!.margin
                            }
                        }
                        
                        _ = self.tgCalcSubviewWidth(pos.view, sbvsc:pos.view.tgCurrentSizeClass as! TGViewSizeClassImpl, sbvtgFrame: pos.view.tgFrame, lsc:lsc, selfSize: selfSize)
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
                            totalOffset += nextPos.view.tgCenterX!.margin
                        }
                    }
                    
                    _ = self.tgCalcSubviewWidth(sbv,sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
                    totalWidth += sbvtgFrame.width
                    totalOffset += sbvsc.tgCenterX!.margin
                    
                }
                
                var leadingOffset: CGFloat = (selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding - totalWidth - totalOffset) / 2.0
                leadingOffset += lsc.tg_leadingPadding
                
                var prev:AnyObject! = leadingOffset as AnyObject!
                sbv.tg_leading.equal(leadingOffset)
                prev = sbv.tg_trailing
                
                for pos: TGLayoutPos in centerArray
                {
                    if let prevf = prev as? CGFloat
                    {
                        pos.view.tg_leading.equal(prevf,offset:pos.view.tgCenterX!.margin)
                        
                    }
                    else
                    {
                        pos.view.tg_leading.equal(prev as? TGLayoutPos, offset:pos.view.tgCenterX!.margin)
                    }
                    
                    prev = pos.view.tg_trailing
                }
            }
            
            if sbvsc.tgCenterY?.posArrVal != nil
            {
                let centerArray: [TGLayoutPos] = sbvsc.tgCenterY!.posArrVal
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
                                totalOffset += nextPos.view.tgCenterY!.margin
                            }
                        }
                        
                        _  = self.tgCalcSubviewHeight(pos.view,sbvsc:pos.view.tgCurrentSizeClass as! TGViewSizeClassImpl, sbvtgFrame: pos.view.tgFrame, lsc:lsc, selfSize: selfSize)
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
                            totalOffset += nextPos.view.tgCenterY!.margin
                        }
                    }
                    
                    _ = self.tgCalcSubviewHeight(sbv,sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
                    totalHeight += sbvtgFrame.height
                    totalOffset += sbvsc.tgCenterY!.margin
                    
                }
                
                var topOffset: CGFloat = (selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding - totalHeight - totalOffset) / 2.0
                topOffset += lsc.tg_topPadding
                
                var prev:AnyObject! = topOffset as AnyObject!
                sbv.tg_top.equal(topOffset)
                prev = sbv.tg_bottom
                
                for pos: TGLayoutPos in centerArray
                {
                    if let prevf = prev as? CGFloat
                    {
                        pos.view.tg_top.equal(prevf,offset:pos.view.tgCenterY!.margin)
                        
                    }
                    else
                    {
                        pos.view.tg_top.equal(prev as? TGLayoutPos, offset:pos.view.tgCenterY!.margin)
                    }
                    
                    prev = pos.view.tg_bottom
                }
                
            }
        }
        
        
        var maxWidth = lsc.tg_leadingPadding + lsc.tg_trailingPadding
        var maxHeight = lsc.tg_topPadding + lsc.tg_bottomPadding
        
        for sbv: UIView in self.subviews {
            
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            tgCalcSubviewLeadingTrailing(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame, lsc:lsc, selfSize: selfSize)
            
            if let t = sbvsc.tgHeight,t.isFlexHeight
            {
                sbvtgFrame.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: sbvtgFrame.width)
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            tgCalcSubviewTopBottom(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame, lsc:lsc,selfSize: selfSize)

            
            if self.tgIsNoLayoutSubview(sbv)
            {
                continue
            }

            if isWrap
            {
                maxWidth = self.tgCalcMaxWrapSize(sbvHead: sbvsc.tgLeading, sbvCenter: sbvsc.tgCenterX, sbvTail: sbvsc.tgTrailing, sbvSize: sbvsc.tgWidth, sbvMeasure: sbvtgFrame.width, sbvMinPos: sbvtgFrame.leading, sbvMaxPos: sbvtgFrame.trailing, headPadding: lsc.tg_leadingPadding, tailPadding: lsc.tg_trailingPadding, lscSize: lsc.tgWidth, maxSize: maxWidth, recalc: &recalc)
                
                maxHeight = self.tgCalcMaxWrapSize(sbvHead: sbvsc.tgTop, sbvCenter: sbvsc.tgCenterY, sbvTail: sbvsc.tgBottom, sbvSize: sbvsc.tgHeight, sbvMeasure: sbvtgFrame.height, sbvMinPos: sbvtgFrame.top, sbvMaxPos: sbvtgFrame.bottom, headPadding: lsc.tg_topPadding, tailPadding: lsc.tg_bottomPadding, lscSize: lsc.tgHeight, maxSize: maxHeight, recalc: &recalc)
            }
            
        }
        
        return (CGSize(width: maxWidth, height: maxHeight),recalc)
    }
    
    fileprivate func tgCalcMaxWrapSize(sbvHead:TGLayoutPos?,
                                       sbvCenter:TGLayoutPos?,
                                       sbvTail:TGLayoutPos?,
                                       sbvSize:TGLayoutSize?,
                                       sbvMeasure:CGFloat,
                                       sbvMinPos:CGFloat,
                                       sbvMaxPos:CGFloat,
                                       headPadding:CGFloat,
                                       tailPadding:CGFloat,
                                       lscSize:TGLayoutSize?,
                                       maxSize:CGFloat,
                                       recalc:inout Bool) -> CGFloat
    {
        var maxSize = maxSize
        if let t = lscSize, t.isWrap
        {
            let headMargin = sbvHead?.margin ?? 0
            let tailMargin = sbvTail?.margin ?? 0
            let sbvIsFill = sbvSize?.isFill ?? false
            let sbvHeadHasValue = sbvHead?.hasValue ?? false
            let sbvTailHasValue = sbvTail?.hasValue ?? false
            
            
            
            if (sbvTail?.posNumVal != nil ||
                sbvTail?.posRelaVal?.view === self ||
                sbvTail?.posWeightVal != nil ||
                sbvCenter?.posNumVal != nil ||
                sbvCenter?.posRelaVal?.view === self ||
                sbvCenter?.posWeightVal != nil ||
                sbvSize?.dimeRelaVal === self ||
                sbvSize?.dimeWeightVal != nil ||
                sbvIsFill
                )
            {
                recalc = true
            }
            
            
            if maxSize < headMargin + tailMargin + headPadding + tailPadding
            {
                maxSize = headMargin + tailMargin + headPadding + tailPadding
            }
            
            //宽度没有相对约束或者宽度不依赖父视图并且没有指定比重并且不是填充时才计算最大宽度。
            if (sbvSize?.dimeRelaVal == nil ||
                sbvSize!.dimeRelaVal !== lscSize) &&
                sbvSize?.dimeWeightVal == nil &&
                !sbvIsFill
            {
                
                if let t = sbvCenter, t.hasValue
                {
                    if maxSize < sbvMeasure + headMargin + tailMargin + headPadding + tailPadding
                    {
                        maxSize = sbvMeasure + headMargin + tailMargin + headPadding + tailPadding
                    }
                }
                else if sbvHeadHasValue && sbvTailHasValue
                {
                    if maxSize < fabs(sbvMaxPos) + headMargin + headPadding
                    {
                        maxSize = fabs(sbvMaxPos) + headMargin + headPadding
                    }
                }
                else if sbvTailHasValue
                {
                    if maxSize < fabs(sbvMinPos) + headPadding
                    {
                        maxSize = fabs(sbvMinPos) + headPadding
                    }
                }
                else
                {
                    if maxSize < fabs(sbvMaxPos) + tailPadding
                    {
                        maxSize = fabs(sbvMaxPos) + tailPadding
                    }
                }
                
                if maxSize < sbvMaxPos + tailMargin + tailPadding
                {
                    maxSize = sbvMaxPos + tailMargin + tailPadding
                }
                
                
            }
            
        }

        return maxSize
    }
    
    fileprivate func tgCalcRelationalSubview(_ sbv: UIView!, lsc:TGRelativeLayoutViewSizeClassImpl, gravity:TGGravity, selfSize: CGSize) -> CGFloat {
        
        let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
        let sbvtgFrame = sbv.tgFrame
        
        switch gravity {
        case TGGravity.horz.leading:
            if sbv == self || sbv == nil {
                return lsc.tg_leadingPadding
            }
            
            if sbvtgFrame.leading != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.leading
            }
            
            
            tgCalcSubviewLeadingTrailing(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            
            return sbvtgFrame.leading
            
            
        case TGGravity.horz.trailing:
            if sbv == self || sbv == nil {
                return selfSize.width - lsc.tg_trailingPadding
            }
            
            
            if sbvtgFrame.trailing != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.trailing
            }
            
            tgCalcSubviewLeadingTrailing(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            
            return sbvtgFrame.trailing
            
        case TGGravity.vert.top:
            if sbv == self || sbv == nil {
                return lsc.tg_topPadding
            }
            
            if sbvtgFrame.top != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.top
            }
            
            tgCalcSubviewTopBottom(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            
            return sbvtgFrame.top
            
        case TGGravity.vert.bottom:
            if sbv == self || sbv == nil {
                return selfSize.height - lsc.tg_bottomPadding
            }
            
            if sbvtgFrame.bottom != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.bottom
            }
            tgCalcSubviewTopBottom(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            
            return sbvtgFrame.bottom
            
        case TGGravity.horz.fill:
            
            if sbv == self || sbv == nil {
                return selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding
            }
            
            if sbvtgFrame.width != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.width
            }
            
            tgCalcSubviewLeadingTrailing(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            return sbvtgFrame.width
            
        case TGGravity.vert.fill:
            if sbv == self || sbv == nil {
                return selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding
            }
            
            if sbvtgFrame.height != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.height
            }
            
            tgCalcSubviewTopBottom(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            return sbvtgFrame.height
            
        case TGGravity.horz.center:
            if sbv == self || sbv == nil {
                return (selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding) / 2 + lsc.tg_leadingPadding
            }
            
            
            if sbvtgFrame.leading != CGFloat.greatestFiniteMagnitude && sbvtgFrame.trailing != CGFloat.greatestFiniteMagnitude && sbvtgFrame.width != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.leading + sbvtgFrame.width / 2
            }
            
            tgCalcSubviewLeadingTrailing(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            
            return sbvtgFrame.leading + sbvtgFrame.width / 2.0
            
        case TGGravity.vert.center:
            if sbv == self || sbv == nil {
                return (selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) / 2 + lsc.tg_topPadding
            }
            
            
            if sbvtgFrame.top != CGFloat.greatestFiniteMagnitude && sbvtgFrame.bottom != CGFloat.greatestFiniteMagnitude && sbvtgFrame.height != CGFloat.greatestFiniteMagnitude {
                return sbvtgFrame.top + sbvtgFrame.height / 2.0
            }
            
            tgCalcSubviewTopBottom(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
            return sbvtgFrame.top + sbvtgFrame.height / 2
            
        default:
            print("do nothing")
        }
        
        return 0
    }
    
    
    
    
}
