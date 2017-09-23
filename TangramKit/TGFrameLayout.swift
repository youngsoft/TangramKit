//
//  TGFrameLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//


import UIKit

/**
 *框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，只跟父视图建立布局约束依赖关系。
 *框架布局是一种简化的相对布局。也就是里面子视图的TGLayoutPos对象所设置的值都是距离父布局视图的边距值，里面的TGLayoutSize对象所设置的值都是相对于父视图的尺寸来处理的。
 */
open class TGFrameLayout: TGBaseLayout,TGFrameLayoutViewSizeClass {
    
    
    //MARK: override
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGFrameLayoutViewSizeClassImpl(view:self)
    }
    
    
    internal override func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool , sbs:[UIView]!, type:TGSizeClassType) -> (selfSize:CGSize, hasSubLayout:Bool)
    {
        var (selfSize,hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate: isEstimate, sbs:sbs, type: type)
        
        var sbs:[UIView]! = sbs
        if sbs == nil
        {
            sbs = self.tgGetLayoutSubviews()
        }
        
        let lsc = self.tgCurrentSizeClass as! TGFrameLayoutViewSizeClassImpl
        
        let horzGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let vertGravity = lsc.tg_gravity & TGGravity.horz.mask

        
        
        var maxWrapSize:CGSize! = nil
        if lsc.isSomeSizeWrap
        {
           maxWrapSize = CGSize(width: lsc.tgLeadingPadding + lsc.tgTrailingPadding, height: lsc.tgTopPadding + lsc.tgBottomPadding)
        }
        
        for sbv in sbs
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            if sbvsc.isVertMarginHasValue
            {
                sbvsc.height.resetValue()
            }
            
            if sbvsc.isHorzMarginHasValue
            {
                sbvsc.width.resetValue()
            }
            
            if !isEstimate
            {
                sbvtgFrame.frame = sbv.bounds
                self.tgCalcSizeFromSizeWrapSubview(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame)
            }
            
            
            if let sbvl = sbv as? TGBaseLayout
            {
                
                if sbvsc.isSomeSizeWrap
                {
                    hasSubLayout = true
                }
                
                if isEstimate && sbvsc.isSomeSizeWrap
                {
                    _ = sbvl.tg_sizeThatFits(sbvtgFrame.frame.size,inSizeClass:type)
                    if sbvtgFrame.multiple
                    {
                        sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)
                    }
                }
                
            }
            
            //计算视图的位置和尺寸
            self.tgCalcSubviewRect(sbv,
                                   sbvsc:sbvsc,
                                   sbvtgFrame:sbvtgFrame,
                                   lsc:lsc,
                                   vertGravity:vertGravity,
                                   horzGravity:horzGravity,
                                   selfSize:selfSize,
                                   maxWrapSize:&maxWrapSize)
            
        }
        
        //如果自身的宽度和高度是包裹属性则尺寸由子视图最大的尺寸给出。
        if lsc.width.isWrap
        {
            selfSize.width = maxWrapSize.width
        }
        
        if lsc.height.isWrap
        {
            selfSize.height = maxWrapSize.height
        }
        
        maxWrapSize = nil
        
        tgAdjustLayoutSelfSize(selfSize: &selfSize, lsc: lsc)
         
        //因为还存在有部分子视图依赖于布局视图尺寸的情况，所以如果布局视图本身是wrap的则需要更新那部分依赖的子视图的尺寸。
        if (lsc.width.isWrap && horzGravity != TGGravity.horz.fill) || (lsc.height.isWrap && vertGravity != TGGravity.vert.fill)
        {
            for  sbv:UIView in sbs
            {
                let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
                
                
                if (sbvsc.isHorzMarginHasValue) ||
                    sbvsc.width.isDependOther(lsc.width) ||
                    (sbvsc.isVertMarginHasValue) ||
                    sbvsc.height.isDependOther(lsc.height)
                {
                    self.tgCalcSubviewRect(sbv,
                                           sbvsc:sbvsc,
                                           sbvtgFrame:sbvtgFrame,
                                           lsc:lsc,
                                           vertGravity:vertGravity,
                                           horzGravity:horzGravity,
                                           selfSize:selfSize,
                                           maxWrapSize:&maxWrapSize)

                }
            }
        }
        
        tgAdjustSubviewsRTLPos(sbs: sbs, selfWidth: selfSize.width)
        
        return (self.tgAdjustSizeWhenNoSubviews(size: selfSize, sbs: sbs, lsc:lsc),hasSubLayout)
        
    }
    
}

//internal and private method
extension TGFrameLayout
{
    fileprivate func tgCalcSubviewRect(_ sbv: UIView,
                                       sbvsc:TGViewSizeClassImpl,
                                       sbvtgFrame:TGFrame,
                                       lsc:TGFrameLayoutViewSizeClassImpl!,
                                       vertGravity:TGGravity,
                                       horzGravity:TGGravity,
                                       selfSize:CGSize,
                                       maxWrapSize:inout CGSize!)
    {
        
        let selfFloatWidth = selfSize.width - lsc.tgLeadingPadding - lsc.tgTrailingPadding
        let selfFloatHeight = selfSize.height - lsc.tgTopPadding - lsc.tgBottomPadding
        let leadingMargin = sbvsc.leading.weightPosIn(selfFloatWidth)
        let trailingMargin = sbvsc.trailing.weightPosIn(selfFloatWidth)
        let topMargin = sbvsc.top.weightPosIn(selfFloatHeight)
        let bottomMargin = sbvsc.bottom.weightPosIn(selfFloatHeight)
        
    
        var rect = sbvtgFrame.frame
        
        //明确宽度的情况
        rect.size.width = sbvsc.width.numberSize(rect.size.width)
        rect.size.width = sbvsc.width.fillSize(rect.size.width, in: selfFloatWidth - leadingMargin - trailingMargin)
        rect.size.width = sbvsc.width.weightSize(rect.size.width, in: selfFloatWidth)
        if let t = sbvsc.width.sizeVal, t.view !== sbv
        {//宽度依赖其他视图
            if t === lsc.width.realSize
            {
                rect.size.width =  sbvsc.width.measure(selfFloatWidth)
            }
            else if t === lsc.height.realSize
            {
                rect.size.width =  sbvsc.width.measure(selfFloatHeight)
            }
            else
            {
                rect.size.width = sbvsc.width.measure(t.view.tg_estimatedFrame.width)
            }
        }
        
        
        //明确高度的情况
        rect.size.height = sbvsc.height.numberSize(rect.size.height)
        rect.size.height = sbvsc.height.fillSize(rect.size.height, in: selfFloatHeight - topMargin - bottomMargin)
        rect.size.height = sbvsc.height.weightSize(rect.size.height, in: selfFloatHeight)
        if let t = sbvsc.height.sizeVal, t.view !== sbv
        { //高度依赖其他视图
            
            if t === lsc.height.realSize
            {
                rect.size.height =  sbvsc.height.measure(selfFloatHeight)
            }
            else if t === lsc.width.realSize
            {
                rect.size.height =  sbvsc.height.measure(selfFloatWidth)
            }
            else
            {
                rect.size.height = sbvsc.height.measure(t.view.tg_estimatedFrame.height)
            }
        }
        
        
        //宽度有效性调整。
        rect.size.width = self.tgValidMeasure(sbvsc.width, sbv:sbv, calcSize:rect.size.width, sbvSize:rect.size, selfLayoutSize:selfSize)
        self.tgCalcHorzGravity(self.tgGetSubviewHorzGravity(sbv, sbvsc: sbvsc, horzGravity: horzGravity), selfSize:selfSize, sbv: sbv, sbvsc:sbvsc, lsc:lsc, rect: &rect)
        
        
        if sbvsc.height.isFlexHeight
        {
            rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
        }
        
        rect.size.height = self.tgValidMeasure(sbvsc.height,sbv:sbv,calcSize:rect.size.height,sbvSize:rect.size, selfLayoutSize:selfSize)
        
        
        self.tgCalcVertGravity(self.tgGetSubviewVertGravity(sbv, sbvsc: sbvsc, vertGravity: vertGravity), selfSize:selfSize, sbv: sbv, sbvsc:sbvsc, lsc:lsc,rect: &rect)
        
        
        //特殊处理宽度等于自身高度的情况。
        if let t = sbvsc.width.sizeVal, t.view == sbv && t.type == TGGravity.vert.fill
        {
            rect.size.width =  self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: sbvsc.width.measure(rect.size.height), sbvSize: rect.size, selfLayoutSize: selfSize)
            
            self.tgCalcHorzGravity(self.tgGetSubviewHorzGravity(sbv, sbvsc: sbvsc, horzGravity: horzGravity), selfSize:selfSize, sbv: sbv, sbvsc:sbvsc, lsc:lsc, rect: &rect)

        }
        
        //特殊处理高度等于自身宽度的情况。
        if let t = sbvsc.height.sizeVal, t.view == sbv
        {
            rect.size.height = sbvsc.height.measure(rect.size.width)
            
            if sbvsc.height.isFlexHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
             self.tgCalcVertGravity(self.tgGetSubviewVertGravity(sbv, sbvsc: sbvsc, vertGravity: vertGravity), selfSize:selfSize, sbv: sbv,sbvsc:sbvsc, lsc:lsc, rect: &rect)
            
        }
        
        sbvtgFrame.frame = rect
        
        if (maxWrapSize != nil)
        {
            
            maxWrapSize.width = self.tgCalcMaxWrapSize(sbvHead:sbvsc.leading,
                                                        sbvCenter:sbvsc.centerX,
                                                        sbvTail:sbvsc.trailing,
                                                        sbvSize:sbvsc.width,
                                                        sbvMeasure:sbvtgFrame.width,
                                                        sbvMaxPos:sbvtgFrame.trailing,
                                                        headPadding:lsc.tgLeadingPadding,
                                                        tailPadding:lsc.tgTrailingPadding,
                                                        lscSize:lsc.width,
                                                        maxSize:maxWrapSize.width)
            
            maxWrapSize.height = self.tgCalcMaxWrapSize(sbvHead:sbvsc.top,
                                                        sbvCenter:sbvsc.centerY,
                                                        sbvTail:sbvsc.bottom,
                                                        sbvSize:sbvsc.height,
                                                        sbvMeasure:sbvtgFrame.height,
                                                        sbvMaxPos:sbvtgFrame.bottom,
                                                        headPadding:lsc.tgTopPadding,
                                                        tailPadding:lsc.tgBottomPadding,
                                                        lscSize:lsc.height,
                                                        maxSize:maxWrapSize.height)
        }
    }
    
    fileprivate func tgCalcMaxWrapSize(sbvHead:TGLayoutPosValue2,
                                       sbvCenter:TGLayoutPosValue2,
                                       sbvTail:TGLayoutPosValue2,
                                       sbvSize:TGLayoutSizeValue2,
                                       sbvMeasure:CGFloat,
                                       sbvMaxPos:CGFloat,
                                       headPadding:CGFloat,
                                       tailPadding:CGFloat,
                                       lscSize:TGLayoutSizeValue2,
                                       maxSize:CGFloat) -> CGFloat
    {
        var maxSize = maxSize
        let sbvHeadMargin = sbvHead.absPos
        let sbvTailMargin = sbvTail.absPos
        let sbvCenterMargin = sbvCenter.absPos
        
        if lscSize.isWrap
        {
            if sbvHead.hasValue && sbvTail.hasValue
            {
                let m1 = sbvHeadMargin + sbvTailMargin + headPadding + tailPadding
                if _tgCGFloatLess(maxSize , m1)
                {
                    maxSize = m1
                }
            }
            
            //如果子视图的尺寸不依赖于父视图则参与最大尺寸计算。
            if !(sbvHead.hasValue && sbvTail.hasValue) &&
                (sbvSize.sizeVal == nil || sbvSize.sizeVal !== lscSize.realSize) &&
                !sbvSize.isFill &&
                sbvSize.weightVal == nil
            {
                let m1 = sbvMeasure + sbvHeadMargin + sbvCenterMargin + sbvTailMargin + headPadding + tailPadding
                if _tgCGFloatLess(maxSize , m1)
                {
                   maxSize = m1
                }
                
                let m2 = sbvMaxPos + sbvTailMargin + tailPadding
                if _tgCGFloatLess(maxSize , m2)
                {
                    maxSize = m2
                }
            }
        }
        
        return maxSize
    }
}
