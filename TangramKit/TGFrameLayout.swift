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
        
        let selftgWidthIsWrap = lsc.tgWidth?.isWrap ?? false
        let selftgHeightIsWrap = lsc.tgHeight?.isWrap ?? false
        
        
        var maxWrapSize:CGSize! = nil
        if selftgWidthIsWrap || selftgHeightIsWrap
        {
           maxWrapSize = CGSize(width: lsc.tg_leadingPadding + lsc.tg_trailingPadding, height: lsc.tg_topPadding + lsc.tg_bottomPadding)
        }
        
        for sbv in sbs
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
            let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
            let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
            let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false

            
            if sbvtgTopHasValue && sbvtgBottomHasValue
            {
                sbvsc.tgHeight?._dimeVal = nil
            }
            
            if sbvtgLeadingHasValue && sbvtgTrailingHasValue
            {
                sbvsc.tgWidth?._dimeVal = nil
            }
            
            if !isEstimate
            {
                sbvtgFrame.frame = sbv.bounds
                self.tgCalcSizeFromSizeWrapSubview(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame)
            }
            
            
            if let sbvl = sbv as? TGBaseLayout
            {
                let sbvtgWidthIsWrap = sbvsc.tgWidth?.isWrap ?? false
                let sbvtgHeightIsWrap = sbvsc.tgHeight?.isWrap ?? false
                
                
                if sbvtgWidthIsWrap || sbvtgHeightIsWrap
                {
                    hasSubLayout = true
                }
                
                if (isEstimate && (sbvtgWidthIsWrap || sbvtgHeightIsWrap))
                {
                    _ = sbvl.tg_sizeThatFits(sbvtgFrame.frame.size,inSizeClass:type)
                    if sbvtgFrame.multiple
                    {
                        sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)
                    }
                }
                
            }
            
            //计算视图的位置和尺寸
            self.tgCalcSubviewRect(sbv, sbvsc:sbvsc, sbvtgFrame:sbvtgFrame, lsc:lsc,selfSize:selfSize, maxWrapSize:&maxWrapSize)
            
        }
        
        //如果自身的宽度和高度是包裹属性则尺寸由子视图最大的尺寸给出。
        if selftgWidthIsWrap
        {
            selfSize.width = maxWrapSize.width
        }
        
        if selftgHeightIsWrap
        {
            selfSize.height = maxWrapSize.height
        }
        
        maxWrapSize = nil
        
        tgAdjustLayoutSelfSize(selfSize: &selfSize, lsc: lsc)
         
        //因为还存在有部分子视图依赖于布局视图尺寸的情况，所以如果布局视图本身是wrap的则需要更新那部分依赖的子视图的尺寸。
        if selftgWidthIsWrap || selftgHeightIsWrap
        {
            for  sbv:UIView in sbs
            {
                let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
                let sbvtgFrame = sbv.tgFrame
                
                let sbvtgWidthIsFill = sbvsc.tgWidth?.isFill ?? false
                let sbvtgHeightIsFill = sbvsc.tgHeight?.isFill ?? false
                let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
                let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
                let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
                let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false

                
                if (sbvtgLeadingHasValue && sbvtgTrailingHasValue) ||
                    (sbvsc.tgWidth?.dimeRelaVal != nil && sbvsc.tgWidth!.dimeRelaVal === lsc.tgWidth) ||
                    sbvtgWidthIsFill ||
                    sbvsc.tgWidth?.dimeWeightVal != nil ||
                    (sbvtgTopHasValue && sbvtgBottomHasValue) ||
                    (sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === lsc.tgHeight) ||
                    sbvtgHeightIsFill ||
                    sbvsc.tgHeight?.dimeWeightVal != nil
                {
                    self.tgCalcSubviewRect(sbv,sbvsc:sbvsc,sbvtgFrame:sbvtgFrame,lsc:lsc, selfSize:selfSize, maxWrapSize:&maxWrapSize)
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
    fileprivate func tgCalcSubviewRect(_ sbv: UIView, sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame, lsc:TGFrameLayoutViewSizeClassImpl!, selfSize:CGSize, maxWrapSize:inout CGSize!)
    {
        
        let selfFloatWidth = selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding
        let selfFloatHeight = selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding
        let leadingMargin = (sbvsc.tgLeading?.realMarginInSize(selfFloatWidth) ?? 0)
        let trailingMargin = (sbvsc.tgTrailing?.realMarginInSize(selfFloatWidth) ?? 0)
        let topMargin = (sbvsc.tgTop?.realMarginInSize(selfFloatHeight) ?? 0)
        let bottomMargin = (sbvsc.tgBottom?.realMarginInSize(selfFloatHeight) ?? 0)
        
        
        let sbvtgWidthIsFill = sbvsc.tgWidth?.isFill ?? false
        let sbvtgHeightIsFill = sbvsc.tgHeight?.isFill ?? false
        let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
        let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
        let sbvtgCenterXHasValue = sbvsc.tgCenterX?.hasValue ?? false
        let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
        let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false
        let sbvtgCenterYHasValue = sbvsc.tgCenterY?.hasValue ?? false

        
        var retRect = sbvtgFrame.frame
        
        //明确宽度的情况。
        if sbvsc.tgWidth?.dimeNumVal != nil {
            retRect.size.width = sbvsc.tgWidth!.measure;
        }
        else if sbvsc.tgWidth?.dimeRelaVal != nil && sbvsc.tgWidth!.dimeRelaVal.view !== sbv
        {
            if sbvsc.tgWidth!.dimeRelaVal === lsc.tgWidth
            {
                retRect.size.width =  sbvsc.tgWidth!.measure(selfFloatWidth)
            }
            else
            {
                retRect.size.width = sbvsc.tgWidth!.measure(sbvsc.tgWidth!.dimeRelaVal.view.tg_estimatedFrame.width)
            }
        }
        else if sbvtgWidthIsFill
        {
            retRect.size.width = sbvsc.tgWidth!.measure(selfFloatWidth - leadingMargin - trailingMargin)
        }
        else if sbvsc.tgWidth?.dimeWeightVal != nil
        {
            retRect.size.width = sbvsc.tgWidth!.measure(selfFloatWidth * sbvsc.tgWidth!.dimeWeightVal.rawValue / 100)
        }
        
        
        //明确高度的情况
        if sbvsc.tgHeight?.dimeNumVal != nil
        {
            retRect.size.height = sbvsc.tgHeight!.measure;
        }
        else if sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal.view != sbv
        { //高度依赖其他视图
            
            if sbvsc.tgHeight!.dimeRelaVal === lsc.tgHeight
            {
                retRect.size.height =  sbvsc.tgHeight!.measure(selfFloatHeight)
            }
            else
            {
                retRect.size.height = sbvsc.tgHeight!.measure(sbvsc.tgHeight!.dimeRelaVal.view.tg_estimatedFrame.height)
            }
            
        }
        else if sbvtgHeightIsFill
        {
            retRect.size.height = sbvsc.tgHeight!.measure(selfFloatHeight - topMargin - bottomMargin)
        }
        else if (sbvsc.tgHeight?.dimeWeightVal != nil)
        {//比重高度
            retRect.size.height = sbvsc.tgHeight!.measure(selfFloatHeight * sbvsc.tgHeight!.dimeWeightVal.rawValue/100)
        }
        
        
        //宽度有效性调整。
        retRect.size.width = self.tgValidMeasure(sbvsc.tgWidth, sbv:sbv, calcSize:retRect.size.width, sbvSize:retRect.size, selfLayoutSize:selfSize)
        
        //左右位置处理，特殊处理如果设置了左右边距则确定了视图的宽度
        var horz:TGGravity = TGGravity.horz.leading
        if sbvtgLeadingHasValue && sbvtgTrailingHasValue
        {
            horz = TGGravity.horz.fill;
        }
        else if sbvtgCenterXHasValue
        {
            horz = TGGravity.horz.center
        }
        else if sbvtgLeadingHasValue
        {
            horz = TGGravity.horz.leading
        }
        else if sbvtgTrailingHasValue
        {
            horz = TGGravity.horz.trailing
        }
        self.tgCalcHorzGravity(horz, selfSize:selfSize, sbv: sbv, sbvsc:sbvsc, lsc:lsc, rect: &retRect)
        
        
        if let t = sbvsc.tgHeight, t.isFlexHeight
        {
            retRect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: retRect.size.width)
        }
        
        retRect.size.height = self.tgValidMeasure(sbvsc.tgHeight,sbv:sbv,calcSize:retRect.size.height,sbvSize:retRect.size, selfLayoutSize:selfSize)
        
        
        var vert:TGGravity = TGGravity.vert.top
        if sbvtgTopHasValue && sbvtgBottomHasValue
        {
            vert = TGGravity.vert.fill;
        }
        else if sbvtgCenterYHasValue
        {
            vert = TGGravity.vert.center
        }
        else if sbvtgTopHasValue
        {
            vert = TGGravity.vert.top
        }
        else if sbvtgBottomHasValue
        {
            vert = TGGravity.vert.bottom
        }
        self.tgCalcVertGravity(vert, selfSize:selfSize, sbv: sbv, sbvsc:sbvsc, lsc:lsc,rect: &retRect)
        
        
        //特殊处理宽度等于自身高度的情况。
        if (sbvsc.tgWidth?.dimeRelaVal != nil && sbvsc.tgWidth!.dimeRelaVal.view == sbv && sbvsc.tgWidth!.dimeRelaVal._type == TGGravity.vert.fill)
        {
            retRect.size.width =  self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: sbvsc.tgWidth!.measure(retRect.size.height), sbvSize: retRect.size, selfLayoutSize: selfSize)
            
            self.tgCalcHorzGravity(horz, selfSize:selfSize, sbv: sbv, sbvsc:sbvsc, lsc:lsc, rect: &retRect)

        }
        
        //特殊处理高度等于自身宽度的情况。
        if sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal.view == sbv
        {
            retRect.size.height = sbvsc.tgHeight!.measure(retRect.size.width)
            
            if let t = sbvsc.tgHeight, t.isFlexHeight
            {
                retRect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: retRect.size.width)
            }
            
            
            retRect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: retRect.size.height, sbvSize: retRect.size, selfLayoutSize: selfSize)
            
             self.tgCalcVertGravity(vert, selfSize:selfSize, sbv: sbv,sbvsc:sbvsc, lsc:lsc, rect: &retRect)

            
        }
        
        sbvtgFrame.frame = retRect
        
        if (maxWrapSize != nil)
        {
            
            maxWrapSize.width = self.tgCalcMaxWrapSize(sbvHead:sbvsc.tgLeading,
                                                        sbvCenter:sbvsc.tgCenterX,
                                                        sbvTail:sbvsc.tgTrailing,
                                                        sbvSize:sbvsc.tgWidth,
                                                        sbvMeasure:sbvtgFrame.width,
                                                        sbvMaxPos:sbvtgFrame.trailing,
                                                        headPadding:lsc.tg_leadingPadding,
                                                        tailPadding:lsc.tg_trailingPadding,
                                                        lscSize:lsc.tgWidth,
                                                        maxSize:maxWrapSize.width)
            
            maxWrapSize.height = self.tgCalcMaxWrapSize(sbvHead:sbvsc.tgTop,
                                                        sbvCenter:sbvsc.tgCenterY,
                                                        sbvTail:sbvsc.tgBottom,
                                                        sbvSize:sbvsc.tgHeight,
                                                        sbvMeasure:sbvtgFrame.height,
                                                        sbvMaxPos:sbvtgFrame.bottom,
                                                        headPadding:lsc.tg_topPadding,
                                                        tailPadding:lsc.tg_bottomPadding,
                                                        lscSize:lsc.tgHeight,
                                                        maxSize:maxWrapSize.height)
        }
    }
    
    fileprivate func tgCalcMaxWrapSize(sbvHead:TGLayoutPos?,
                                       sbvCenter:TGLayoutPos?,
                                       sbvTail:TGLayoutPos?,
                                       sbvSize:TGLayoutSize?,
                                       sbvMeasure:CGFloat,
                                       sbvMaxPos:CGFloat,
                                       headPadding:CGFloat,
                                       tailPadding:CGFloat,
                                       lscSize:TGLayoutSize?,
                                       maxSize:CGFloat) -> CGFloat
    {
        var maxSize = maxSize
        
        let lscSizeIsWrap = lscSize?.isWrap ?? false
        let sbvHeadHasValue = sbvHead?.hasValue ?? false
        let sbvTailHasValue = sbvTail?.hasValue ?? false
        let sbvSizeIsFill = sbvSize?.isFill ?? false
        let sbvHeadMargin = sbvHead?.margin ?? 0
        let sbvTailMargin = sbvTail?.margin ?? 0
        let sbvCenterMargin = sbvCenter?.margin ?? 0
        
        if (lscSizeIsWrap)
        {
            if sbvHeadHasValue && sbvTailHasValue
            {
                let m1 = sbvHeadMargin + sbvTailMargin + headPadding + tailPadding
                if maxSize < m1
                {
                    maxSize = m1
                }
            }
            
            //如果子视图的尺寸不依赖于父视图则参与最大尺寸计算。
            if !(sbvHeadHasValue && sbvTailHasValue) &&
                (sbvSize?.dimeRelaVal == nil || sbvSize!.dimeRelaVal !== lscSize) &&
                !sbvSizeIsFill &&
                sbvSize?.dimeWeightVal == nil
            {
                let m1 = sbvMeasure + sbvHeadMargin + sbvCenterMargin + sbvTailMargin + headPadding + tailPadding
                if maxSize < m1
                {
                   maxSize = m1
                }
                
                let m2 = sbvMaxPos + sbvTailMargin + tailPadding
                if maxSize < m2
                {
                    maxSize = m2
                }
            }
        }
        
        return maxSize
    }
}
