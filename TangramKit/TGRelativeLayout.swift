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
     *这个属性在新版本将失效并且无任何意义了。如果想让子视图隐藏时是否继续占据位置则请参考使用子视图的tg_visibility属性来设置。
     */
    @available(*, deprecated:1.0.6, message: "this property was invalid, please use subview's tg_visibility to instead")
    public var tg_autoLayoutViewGroupWidth: Bool {
        get {
            return false
        }
        set {
            
            print("tg_autoLayoutViewGroupWidth is invalid please use subview's tg_visibility to instead")

        }
    }
    
    /**
     *这个属性在新版本将失效并且无任何意义了。如果想让子视图隐藏时是否继续占据位置则请参考使用子视图的tg_visibility属性来设置。
     */
    @available(*, deprecated:1.0.6, message: "this property was invalid, please use subview's tg_visibility to instead")
    public var tg_autoLayoutViewGroupHeight: Bool {
        
        get {
            return false
        }
        
        set {
            print("tg_autoLayoutViewGroupHeight is invalid please use subview's tg_visibility to instead")

            }
    }
    
    //MARK: override method
    
    override func tgCalcLayoutRect(_ size: CGSize, isEstimate: Bool, sbs:[UIView]!, type: TGSizeClassType) -> (selfSize: CGSize, hasSubLayout: Bool) {
        
        var (selfSize, hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate: isEstimate, sbs:sbs, type: type)
        
        let lsc = self.tgCurrentSizeClass as! TGRelativeLayoutViewSizeClassImpl
        
        for sbv: UIView in self.subviews
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

           
            if sbvsc.tg_useFrame
            {
                continue
            }
            
            if !isEstimate {
                sbvtgFrame.reset()
            }
            
            
            if sbvsc.isHorzMarginHasValue {
                
                sbvsc.width.resetValue()
            }
            
            if sbvsc.isVertMarginHasValue
            {
                sbvsc.height.resetValue()
            }
            
            
            if let sbvl: TGBaseLayout = sbv as? TGBaseLayout
            {
                
                if sbvsc.isSomeSizeWrap
                {
                    hasSubLayout = true
                }
                
                if isEstimate && (sbvsc.isSomeSizeWrap)
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
        
        let isWrap = lsc.isSomeSizeWrap
        
        let (maxSize,recalc) = tgCalcLayoutRectHelper(selfSize, lsc:lsc, isWrap: isWrap)
        
        if isWrap
        {
            if _tgCGFloatNotEqual(selfSize.height, maxSize.height) ||  _tgCGFloatNotEqual(selfSize.width, maxSize.width)
            {
                if lsc.width.isWrap {
                    selfSize.width = maxSize.width
                }
                
                if lsc.height.isWrap {
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
        
        let sbvLeadingMargin = sbvsc.leading.absPos
        let sbvTrailingMargin = sbvsc.trailing.absPos
        let sbvCenterXMargin = sbvsc.centerX.absPos

        
        if sbvsc.centerX.hasValue
        {
            if sbvsc.width.isFill && !self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.width = sbvsc.width.measure(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding)
            }
        }
        
        if let t = sbvsc.centerX.posVal
        {
            let relaView = t.view
            
            sbvtgFrame.leading = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: t.type, selfSize: selfSize) - sbvtgFrame.width / 2 + sbvCenterXMargin
            
            if relaView != self && self.tgIsNoLayoutSubview(relaView)
            {
                sbvtgFrame.leading -= sbvCenterXMargin
            }
            
            if lsc.width.isWrap && sbvtgFrame.leading < 0 && relaView === self
            {
                sbvtgFrame.leading = 0
            }
            
            
            sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
        }
        else if sbvsc.centerX.numberVal != nil
        {
            sbvtgFrame.leading = (selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding - sbvtgFrame.width) / 2 + lsc.tg_leadingPadding + sbvCenterXMargin
            
            
            if lsc.width.isWrap &&  sbvtgFrame.leading < 0
            {
                sbvtgFrame.leading = 0
            }
            
            sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
        }
        else if sbvsc.centerX.weightVal != nil
        {
            sbvtgFrame.leading = (selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding - sbvtgFrame.width) / 2 + lsc.tg_leadingPadding + sbvsc.centerX.weightPosIn(selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding)
            
            
            if lsc.width.isWrap &&  sbvtgFrame.leading < 0
            {
                sbvtgFrame.leading = 0
            }
            
            sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
        }
        else
        {
            if sbvsc.leading.hasValue
            {
                if let t = sbvsc.leading.posVal
                {
                    let relaView = t.view
                    sbvtgFrame.leading = tgCalcRelationalSubview(relaView, lsc:lsc, gravity:t.type, selfSize: selfSize) + sbvLeadingMargin
                    
                    if relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.leading -= sbvLeadingMargin
                    }
                }
                else if sbvsc.leading.numberVal != nil
                {
                    sbvtgFrame.leading = sbvLeadingMargin + lsc.tg_leadingPadding
                }
                else if sbvsc.leading.weightVal != nil
                {
                    sbvtgFrame.leading = sbvsc.leading.weightPosIn(selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding) + lsc.tg_leadingPadding
                }
                
                if sbvsc.width.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    //lsc.tg_leadingPadding 这里因为sbvtgFrame.leading已经包含了leftPadding所以这里不需要再减
                    sbvtgFrame.width = sbvsc.width.measure(selfSize.width - lsc.tg_trailingPadding - sbvtgFrame.leading)
                }
                
                sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
            }
            
            if sbvsc.trailing.hasValue
            {
                if let t = sbvsc.trailing.posVal
                {
                    let relaView = t.view
                    
                    
                    sbvtgFrame.trailing = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: t.type, selfSize: selfSize) - sbvTrailingMargin + sbvLeadingMargin
                    
                    if relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.trailing += sbvTrailingMargin
                    }
                    
                }
                else if sbvsc.trailing.numberVal != nil
                {
                    sbvtgFrame.trailing = selfSize.width - lsc.tg_trailingPadding - sbvTrailingMargin + sbvLeadingMargin
                }
                else if sbvsc.trailing.weightVal != nil
                {
                    sbvtgFrame.trailing = selfSize.width - lsc.tg_trailingPadding - sbvsc.trailing.weightPosIn(selfSize.width - lsc.tg_trailingPadding - lsc.tg_leadingPadding) + sbvLeadingMargin
                }
                
                if sbvsc.width.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.width = sbvsc.width.measure(sbvtgFrame.trailing - sbvLeadingMargin - lsc.tg_leadingPadding)
                }
                
                sbvtgFrame.leading = sbvtgFrame.trailing - sbvtgFrame.width
                
            }
            
            if !sbvsc.leading.hasValue && !sbvsc.trailing.hasValue
            {
                if sbvsc.width.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.width = sbvsc.width.measure(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding)
                }
                
                sbvtgFrame.leading =  sbvLeadingMargin + lsc.tg_leadingPadding
                sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
            }
        }
        
        
        //这里要更新左边最小和右边最大约束的情况。
        if case let(minrt?, maxrt?) = (sbvsc.leading.minVal?.posVal , sbvsc.trailing.maxVal?.posVal)
        {
            //让宽度缩小并在最小和最大的中间排列。
            let minLeading = self.tgCalcRelationalSubview(minrt.view, lsc:lsc, gravity: minrt.type, selfSize: selfSize) + sbvsc.leading.minVal!.offset
        
            
            let maxTrailing = self.tgCalcRelationalSubview(maxrt.view, lsc:lsc,  gravity: maxrt.type, selfSize: selfSize) - sbvsc.trailing.maxVal!.offset
            
            
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
        else if let t = sbvsc.leading.minVal?.posVal
        {
            //得到左边的最小位置。如果当前的左边距小于这个位置则缩小视图的宽度。
            let minLeading = self.tgCalcRelationalSubview(t.view, lsc:lsc, gravity: t.type, selfSize: selfSize) + sbvsc.leading.minVal!.offset
            
            if (sbvtgFrame.leading < minLeading)
            {
                sbvtgFrame.leading = minLeading
                sbvtgFrame.width = sbvtgFrame.trailing - sbvtgFrame.leading
            }
            
        }
        else if let t = sbvsc.trailing.maxVal?.posVal
        {
            //得到右边的最大位置。如果当前的右边距大于了这个位置则缩小视图的宽度。
            let maxTrailing = self.tgCalcRelationalSubview(t.view, lsc:lsc, gravity: t.type, selfSize: selfSize) - sbvsc.trailing.maxVal!.offset
            
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
        
        let sbvTopMargin = sbvsc.top.absPos
        let sbvBottomMargin = sbvsc.bottom.absPos
        let sbvCenterYMargin = sbvsc.centerY.absPos
        
        if sbvsc.centerY.hasValue
        {
            if sbvsc.height.isFill && !self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.height = sbvsc.height.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
            }
        }
        if let t = sbvsc.centerY.posVal
        {
            let relaView = t.view
            
            sbvtgFrame.top = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: t.type, selfSize: selfSize) - sbvtgFrame.height / 2 + sbvCenterYMargin
            
            
            if  relaView != self && self.tgIsNoLayoutSubview(relaView)
            {
                sbvtgFrame.top -= sbvCenterYMargin
            }
            
            if lsc.height.isWrap &&  sbvtgFrame.top < 0 && relaView === self
            {
                sbvtgFrame.top = 0
            }
            
            sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
        }
        else if sbvsc.centerY.numberVal != nil
        {
            sbvtgFrame.top = (selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding - sbvtgFrame.height) / 2 + lsc.tg_topPadding + sbvCenterYMargin
            
            if  lsc.height.isWrap &&  sbvtgFrame.top < 0
            {
                sbvtgFrame.top = 0
            }
            
            sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
        }
        else if sbvsc.centerY.weightVal != nil
        {
            sbvtgFrame.top = (selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding - sbvtgFrame.height) / 2 + lsc.tg_topPadding + sbvsc.centerY.weightPosIn(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
            
            if  lsc.height.isWrap &&  sbvtgFrame.top < 0
            {
                sbvtgFrame.top = 0
            }
            
            sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
        }
        else
        {
            if sbvsc.top.hasValue
            {
                if let t = sbvsc.top.posVal
                {
                    let relaView = t.view
                    
                    
                    sbvtgFrame.top = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: t.type, selfSize: selfSize) + sbvTopMargin
                    
                    if  relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.top -= sbvTopMargin
                    }
                    
                }
                else if sbvsc.top.numberVal != nil
                {
                    sbvtgFrame.top = sbvTopMargin + lsc.tg_topPadding
                }
                else if sbvsc.top.weightVal != nil
                {
                    sbvtgFrame.top = sbvsc.top.weightPosIn(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) + lsc.tg_topPadding
                }
                
                if sbvsc.height.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    //lsc.tg_topPadding 这里因为sbvtgFrame.top已经包含了topPadding所以这里不需要再减
                    sbvtgFrame.height = sbvsc.height.measure(selfSize.height - lsc.tg_topPadding - sbvtgFrame.top)
                }
                
                sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height

            }
            
            if sbvsc.bottom.hasValue
            {
                if let t = sbvsc.bottom.posVal
                {
                    let relaView = t.view
                    
                    sbvtgFrame.bottom = tgCalcRelationalSubview(relaView, lsc:lsc, gravity: t.type, selfSize: selfSize) - sbvBottomMargin + sbvTopMargin
                    
                    if  relaView != self && self.tgIsNoLayoutSubview(relaView)
                    {
                        sbvtgFrame.bottom += sbvBottomMargin
                    }
                    
                }
                else if sbvsc.bottom.numberVal != nil
                {
                    sbvtgFrame.bottom = selfSize.height - sbvBottomMargin - lsc.tg_bottomPadding + sbvTopMargin
                }
                else if sbvsc.bottom.weightVal != nil
                {
                    sbvtgFrame.bottom = selfSize.height - sbvsc.bottom.weightPosIn(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) - lsc.tg_bottomPadding + sbvTopMargin
                }
                
                if sbvsc.height.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.height = sbvsc.height.measure(sbvtgFrame.bottom - sbvTopMargin - lsc.tg_topPadding)
                }
                
                sbvtgFrame.top = sbvtgFrame.bottom - sbvtgFrame.height

            }
        
            if !sbvsc.top.hasValue && !sbvsc.bottom.hasValue
            {
                if sbvsc.height.isFill && !self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.height = sbvsc.height.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
                }
                
                sbvtgFrame.top = sbvTopMargin + lsc.tg_topPadding
                sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
            }
        }
        
        
        //这里要更新上边最小和下边最大约束的情况。
        if case let(minrt?, maxrt?) = (sbvsc.top.minVal?.posVal , sbvsc.bottom.maxVal?.posVal)
        {
            //让高度缩小并在最小和最大的中间排列。
            let minTop = self.tgCalcRelationalSubview(minrt.view,lsc:lsc, gravity: minrt.type, selfSize: selfSize) + sbvsc.top.minVal!.offset
            
            
            let maxBottom = self.tgCalcRelationalSubview(maxrt.view, lsc:lsc, gravity: maxrt.type, selfSize: selfSize) - sbvsc.bottom.maxVal!.offset
            
            
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
        else if let t = sbvsc.top.minVal?.posVal
        {
            //得到上边的最小位置。如果当前的上边距小于这个位置则缩小视图的高度。
            let minTop = self.tgCalcRelationalSubview(t.view, lsc:lsc, gravity: t.type, selfSize: selfSize) + sbvsc.top.minVal!.offset
        
            
            if (sbvtgFrame.top < minTop)
            {
                sbvtgFrame.top = minTop
                sbvtgFrame.height = sbvtgFrame.bottom - sbvtgFrame.top
            }
            
        }
        else if let t = sbvsc.bottom.maxVal?.posVal
        {
            //得到下边的最大位置。如果当前的下边距大于了这个位置则缩小视图的高度。
            let maxBottom = self.tgCalcRelationalSubview(t.view, lsc:lsc, gravity: t.type, selfSize: selfSize) - sbvsc.bottom.maxVal!.offset
            
            if (sbvtgFrame.bottom > maxBottom)
            {
                sbvtgFrame.bottom = maxBottom;
                sbvtgFrame.height = sbvtgFrame.bottom - sbvtgFrame.top
            }
            
        }

    }
    
    
    fileprivate func tgCalcSubviewWidth(_ sbv: UIView, sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame, lsc:TGRelativeLayoutViewSizeClassImpl,  selfSize: CGSize) -> Bool {
        if sbvtgFrame.width == CGFloat.greatestFiniteMagnitude {
            if let t = sbvsc.width.sizeVal
            {
                sbvtgFrame.width = sbvsc.width.measure(tgCalcRelationalSubview(t.view, lsc:lsc, gravity:t.type, selfSize: selfSize))
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbvsc.width.numberVal != nil {
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: sbvsc.width.measure, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if let t = sbvsc.width.weightVal
            {
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: sbvsc.width.measure((selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding) * t.rawValue/100), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.width = 0
            }
            
            if sbvsc.isHorzMarginHasValue
            {
                if let t = sbvsc.leading.posVal
                {
                    sbvtgFrame.leading = tgCalcRelationalSubview(t.view, lsc:lsc, gravity:t.type, selfSize: selfSize) + sbvsc.leading.absPos
                }
                else {
                    sbvtgFrame.leading = sbvsc.leading.weightPosIn(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding) + lsc.tg_leadingPadding
                }
                
                if let t = sbvsc.trailing.posVal {
                    sbvtgFrame.trailing = tgCalcRelationalSubview(t.view, lsc:lsc, gravity:t.type, selfSize: selfSize) - sbvsc.trailing.absPos
                }
                else {
                    sbvtgFrame.trailing = selfSize.width - sbvsc.trailing.weightPosIn(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding) - lsc.tg_trailingPadding
                }
                
                sbvtgFrame.width = sbvtgFrame.trailing - sbvtgFrame.leading
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.width = 0
                    sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
                }
                
                return true
            }
            
            if sbvtgFrame.width == CGFloat.greatestFiniteMagnitude {
                sbvtgFrame.width = sbv.bounds.size.width
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbvsc.width.minVal?.numberVal != nil && sbvsc.width.minVal!.numberVal != -CGFloat.greatestFiniteMagnitude) || (sbvsc.width.maxVal?.numberVal != nil && sbvsc.width.maxVal!.numberVal != CGFloat.greatestFiniteMagnitude))
        {
            sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: sbvtgFrame.width, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        
        return false
    }
    
    fileprivate func tgCalcSubviewHeight(_ sbv: UIView, sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame, lsc:TGRelativeLayoutViewSizeClassImpl,selfSize: CGSize) -> Bool {
        if sbvtgFrame.height == CGFloat.greatestFiniteMagnitude {
            if let t = sbvsc.height.sizeVal
            {
                sbvtgFrame.height = sbvsc.height.measure(self.tgCalcRelationalSubview(t.view, lsc:lsc, gravity:t.type, selfSize: selfSize))
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if sbvsc.height.numberVal != nil {
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvsc.height.measure, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            else if let t = sbvsc.height.weightVal
            {
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvsc.height.measure((selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) * t.rawValue/100), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            if self.tgIsNoLayoutSubview(sbv)
            {
                sbvtgFrame.height = 0
            }
        
            
            if sbvsc.isVertMarginHasValue {
                if let t = sbvsc.top.posVal {
                    sbvtgFrame.top = self.tgCalcRelationalSubview(t.view,lsc:lsc, gravity:t.type, selfSize: selfSize) + sbvsc.top.absPos
                }
                else {
                    sbvtgFrame.top = sbvsc.top.weightPosIn(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) + lsc.tg_topPadding
                }
                
                if let t = sbvsc.bottom.posVal {
                    sbvtgFrame.bottom = self.tgCalcRelationalSubview(t.view,lsc:lsc, gravity:t.type, selfSize: selfSize) - sbvsc.bottom.absPos
                }
                else {
                    sbvtgFrame.bottom = selfSize.height - sbvsc.bottom.weightPosIn(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding) - lsc.tg_bottomPadding
                }
                
                sbvtgFrame.height = sbvtgFrame.bottom - sbvtgFrame.top
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                
                if self.tgIsNoLayoutSubview(sbv)
                {
                    sbvtgFrame.height = 0
                    sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
                }
                
                
                return true
            }
            
            if sbvtgFrame.height == CGFloat.greatestFiniteMagnitude {
                sbvtgFrame.height = sbv.bounds.size.height
                
                
                if sbvsc.height.isFlexHeight && !self.tgIsNoLayoutSubview(sbv)
                {
                    if sbvtgFrame.width == CGFloat.greatestFiniteMagnitude
                    {
                        _ = self.tgCalcSubviewWidth(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
                    }
                    
                    sbvtgFrame.height = self.tgCalcHeightFromHeightWrapView(sbv,sbvsc:sbvsc, width: sbvtgFrame.width)
                }
                
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
        }
        
        if ( (sbvsc.height.minVal?.numberVal != nil && sbvsc.height.minVal!.numberVal != -CGFloat.greatestFiniteMagnitude) || (sbvsc.height.maxVal?.numberVal != nil && sbvsc.height.maxVal!.numberVal != CGFloat.greatestFiniteMagnitude))
        {
            sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
        }
        
        return false
    }
    
    fileprivate func tgCalcLayoutRectHelper(_ selfSize: CGSize, lsc:TGRelativeLayoutViewSizeClassImpl, isWrap:Bool) -> (selfSize: CGSize, reCalc: Bool) {
        

        var recalc = false
        
        for sbv:UIView in self.subviews
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            
            self.tgCalcSizeFromSizeWrapSubview(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame);
            
            if (sbvtgFrame.width != CGFloat.greatestFiniteMagnitude)
            {
                if let maxRela = sbvsc.width.maxVal?.sizeVal, maxRela.view !== self
                {
                    _ = self.tgCalcSubviewWidth(maxRela.view,sbvsc:maxRela.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:maxRela.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                if let minRela = sbvsc.width.minVal?.sizeVal, minRela.view != self
                {
                    _ = self.tgCalcSubviewWidth(minRela.view, sbvsc:minRela.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:minRela.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv:sbv, calcSize:sbvtgFrame.width, sbvSize:sbvtgFrame.frame.size,selfLayoutSize:selfSize)
            }
            
            if (sbvtgFrame.height != CGFloat.greatestFiniteMagnitude)
            {
                if let maxRela = sbvsc.height.maxVal?.sizeVal, maxRela.view !== self
                {
                    _ = self.tgCalcSubviewHeight(maxRela.view,sbvsc:maxRela.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:maxRela.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                if let minRela = sbvsc.height.minVal?.sizeVal, minRela.view != self
                {
                    _ = self.tgCalcSubviewHeight(minRela.view, sbvsc:minRela.view.tgCurrentSizeClass as! TGViewSizeClassImpl,sbvtgFrame:minRela.view.tgFrame, lsc:lsc, selfSize:selfSize)
                }
                
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            
        }
        
        
        for sbv: UIView in self.subviews {
            
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            
            if let dimeArray: [TGLayoutSize] = sbvsc.width.arrayVal
            {
                recalc = true
                
                var  isViewHidden = self.tgIsNoLayoutSubview(sbv)
                var totalMulti: CGFloat = isViewHidden ? 0 : sbvsc.width.multiple
                var totalAdd: CGFloat = isViewHidden ? 0 : sbvsc.width.increment
                
                for dime:TGLayoutSize in dimeArray
                {
                    if dime.isActive
                    {
                        isViewHidden = self.tgIsNoLayoutSubview(dime.view)
                        if !isViewHidden {
                            if dime.numberVal != nil {
                                totalAdd += (-1 * dime.numberVal)
                            }
                            else if (dime.view as? TGBaseLayout) == nil && dime.isWrap
                            {
                                totalAdd += -1 * dime.view.tgFrame.width
                            }
                            else {
                                totalMulti += dime.multiple
                            }
                            
                            totalAdd += dime.increment
                        }
                    }
                }
                
                var floatWidth: CGFloat = selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding + totalAdd
                if _tgCGFloatLessOrEqual(floatWidth, 0)
                {
                    floatWidth = 0
                }
                
                if totalMulti != 0 {
                    sbvtgFrame.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: floatWidth * (sbvsc.width.multiple / totalMulti), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.tgIsNoLayoutSubview(sbv)
                    {
                        sbvtgFrame.width = 0
                    }
                    
                    for dime:TGLayoutSize in dimeArray
                    {
                        if dime.isActive
                        {
                            let (dimetgFrame, dimesbvsc) = self.tgGetSubviewFrameAndSizeClass(dime.view)
                            
                            if dime.numberVal == nil {
                                dimetgFrame.width = floatWidth * (dime.multiple / totalMulti)
                            }
                            else {
                                dimetgFrame.width = dime.numberVal
                            }
                            
                            dimetgFrame.width = self.tgValidMeasure(dimesbvsc.width, sbv: dime.view, calcSize: dimetgFrame.width, sbvSize: dimetgFrame.frame.size, selfLayoutSize: selfSize)
                            
                            if self.tgIsNoLayoutSubview(dime.view)
                            {
                                dimetgFrame.width = 0
                            }
                        }
                        
                    }
                }
            }
            
            
            if let dimeArray: [TGLayoutSize] = sbvsc.height.arrayVal
            {
                recalc = true
                
                var isViewHidden: Bool = self.tgIsNoLayoutSubview(sbv)
                var totalMulti = isViewHidden ? 0 : sbvsc.height.multiple
                var totalAdd = isViewHidden ? 0 : sbvsc.height.increment
                for dime:TGLayoutSize in dimeArray
                {
                    if dime.isActive
                    {
                        isViewHidden =  self.tgIsNoLayoutSubview(dime.view)
                        if !isViewHidden {
                            if dime.numberVal != nil {
                                totalAdd += (-1 * dime.numberVal!)
                            }
                            else if (dime.view as? TGBaseLayout) == nil && dime.isWrap
                            {
                                totalAdd += -1 * dime.view.tgFrame.height;
                            }
                            else {
                                totalMulti += dime.multiple
                            }
                            
                            totalAdd += dime.increment
                        }
                    }
                }
                
                var floatHeight = selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding + totalAdd
                if _tgCGFloatLessOrEqual(floatHeight, 0)
                {
                    floatHeight = 0
                }
                if totalMulti != 0 {
                    sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: floatHeight * (sbvsc.height.multiple / totalMulti), sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    if self.tgIsNoLayoutSubview(sbv)
                    {
                        sbvtgFrame.height = 0
                    }
                    
                    for dime: TGLayoutSize in dimeArray
                    {
                        if dime.isActive
                        {
                            let (dimetgFrame, dimesbvsc) = self.tgGetSubviewFrameAndSizeClass(dime.view)

                            if dime.numberVal == nil {
                                dimetgFrame.height = floatHeight * (dime.multiple / totalMulti)
                            }
                            else {
                                dimetgFrame.height = dime.numberVal
                            }
                            
                            dimetgFrame.height = self.tgValidMeasure(dimesbvsc.height, sbv: dime.view, calcSize: dimetgFrame.height, sbvSize: dimetgFrame.frame.size, selfLayoutSize: selfSize)
                            
                            if self.tgIsNoLayoutSubview(dime.view)
                            {
                                dimetgFrame.height = 0
                            }
                        }
                        
                    }
                }
            }
            
            
            if let centerArray: [TGLayoutPos] = sbvsc.centerX.arrayVal
            {
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
                                totalOffset += nextPos.view.tg_centerX.absPos
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
                            totalOffset += nextPos.view.tg_centerX.absPos
                        }
                    }
                    
                    _ = self.tgCalcSubviewWidth(sbv,sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
                    totalWidth += sbvtgFrame.width
                    totalOffset += sbvsc.centerX.absPos
                    
                }
                
                var leadingOffset: CGFloat = (selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding - totalWidth - totalOffset) / 2.0
                leadingOffset += lsc.tg_leadingPadding
                
                var prev:AnyObject! = leadingOffset as AnyObject!
                sbv.tg_leading.equal(leadingOffset)
                prev = sbv.tg_trailing
                
                for pos: TGLayoutPos in centerArray
                {
                    let (_, possbvsc) = self.tgGetSubviewFrameAndSizeClass(pos.view)
                    if let prevf = prev as? CGFloat
                    {
                        pos.view.tg_leading.equal(prevf,offset:possbvsc.centerX.absPos)
                        
                    }
                    else
                    {
                        pos.view.tg_leading.equal(prev as? TGLayoutPos, offset:possbvsc.centerX.absPos)
                    }
                    
                    prev = pos.view.tg_trailing
                }
            }
            
            if let centerArray: [TGLayoutPos] = sbvsc.centerY.arrayVal
            {
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
                                totalOffset += nextPos.view.tg_centerY.absPos
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
                            totalOffset += nextPos.view.tg_centerY.absPos
                        }
                    }
                    
                    _ = self.tgCalcSubviewHeight(sbv,sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc, selfSize: selfSize)
                    totalHeight += sbvtgFrame.height
                    totalOffset += sbvsc.centerY.absPos
                    
                }
                
                var topOffset: CGFloat = (selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding - totalHeight - totalOffset) / 2.0
                topOffset += lsc.tg_topPadding
                
                var prev:AnyObject! = topOffset as AnyObject!
                sbv.tg_top.equal(topOffset)
                prev = sbv.tg_bottom
                
                for pos: TGLayoutPos in centerArray
                {
                    let (_, possbvsc) = self.tgGetSubviewFrameAndSizeClass(pos.view)

                    if let prevf = prev as? CGFloat
                    {
                        pos.view.tg_top.equal(prevf,offset:possbvsc.centerY.absPos)
                        
                    }
                    else
                    {
                        pos.view.tg_top.equal(prev as? TGLayoutPos, offset:possbvsc.centerY.absPos)
                    }
                    
                    prev = pos.view.tg_bottom
                }
                
            }
        }
        
        
        var maxWidth = lsc.tg_leadingPadding + lsc.tg_trailingPadding
        var maxHeight = lsc.tg_topPadding + lsc.tg_bottomPadding
        
        for sbv: UIView in self.subviews {
            
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            
            tgCalcSubviewLeadingTrailing(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame, lsc:lsc, selfSize: selfSize)
            
            if sbvsc.height.isFlexHeight
            {
                sbvtgFrame.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: sbvtgFrame.width)
                sbvtgFrame.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: sbvtgFrame.height, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
            }
            
            tgCalcSubviewTopBottom(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame, lsc:lsc,selfSize: selfSize)

            
            if self.tgIsNoLayoutSubview(sbv)
            {
                continue
            }

            if isWrap
            {
                maxWidth = self.tgCalcMaxWrapSize(sbvHead: sbvsc.leading, sbvCenter: sbvsc.centerX, sbvTail: sbvsc.trailing, sbvSize: sbvsc.width, sbvMeasure: sbvtgFrame.width, sbvMinPos: sbvtgFrame.leading, sbvMaxPos: sbvtgFrame.trailing, headPadding: lsc.tg_leadingPadding, tailPadding: lsc.tg_trailingPadding, lscSize: lsc.width, maxSize: maxWidth, recalc: &recalc)
                
                maxHeight = self.tgCalcMaxWrapSize(sbvHead: sbvsc.top, sbvCenter: sbvsc.centerY, sbvTail: sbvsc.bottom, sbvSize: sbvsc.height, sbvMeasure: sbvtgFrame.height, sbvMinPos: sbvtgFrame.top, sbvMaxPos: sbvtgFrame.bottom, headPadding: lsc.tg_topPadding, tailPadding: lsc.tg_bottomPadding, lscSize: lsc.height, maxSize: maxHeight, recalc: &recalc)
            }
            
        }
        
        return (CGSize(width: maxWidth, height: maxHeight),recalc)
    }
    
    fileprivate func tgCalcMaxWrapSize(sbvHead:TGLayoutPosValue2,
                                       sbvCenter:TGLayoutPosValue2,
                                       sbvTail:TGLayoutPosValue2,
                                       sbvSize:TGLayoutSizeValue2,
                                       sbvMeasure:CGFloat,
                                       sbvMinPos:CGFloat,
                                       sbvMaxPos:CGFloat,
                                       headPadding:CGFloat,
                                       tailPadding:CGFloat,
                                       lscSize:TGLayoutSizeValue2,
                                       maxSize:CGFloat,
                                       recalc:inout Bool) -> CGFloat
    {
        var maxSize = maxSize
        if lscSize.isWrap
        {
            let headMargin = sbvHead.absPos
            let tailMargin = sbvTail.absPos
            
        
            if (sbvTail.numberVal != nil ||
                sbvTail.posVal?.view === self ||
                sbvTail.weightVal != nil ||
                sbvCenter.numberVal != nil ||
                sbvCenter.posVal?.view === self ||
                sbvCenter.weightVal != nil ||
                sbvSize.sizeVal === self ||
                sbvSize.weightVal != nil ||
                sbvSize.isFill
                )
            {
                recalc = true
            }
            
            
            if maxSize < headMargin + tailMargin + headPadding + tailPadding
            {
                maxSize = headMargin + tailMargin + headPadding + tailPadding
            }
            
            //宽度没有相对约束或者宽度不依赖父视图并且没有指定比重并且不是填充时才计算最大宽度。
            if (sbvSize.sizeVal == nil ||
                sbvSize.sizeVal !== lscSize.realSize) &&
                sbvSize.weightVal == nil &&
                !sbvSize.isFill
            {
                
                if sbvCenter.hasValue
                {
                    if maxSize < sbvMeasure + headMargin + tailMargin + headPadding + tailPadding
                    {
                        maxSize = sbvMeasure + headMargin + tailMargin + headPadding + tailPadding
                    }
                }
                else if sbvHead.hasValue && sbvTail.hasValue
                {
                    if maxSize < fabs(sbvMaxPos) + headMargin + headPadding
                    {
                        maxSize = fabs(sbvMaxPos) + headMargin + headPadding
                    }
                }
                else if sbvTail.hasValue
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
        
        let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
        
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
