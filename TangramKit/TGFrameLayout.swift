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
        return TGFrameLayoutViewSizeClassImpl()
    }
    
    internal override func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool , sbs:[UIView]!, type:TGSizeClassType) -> (selfSize:CGSize, hasSubLayout:Bool)
    {
        var (selfSize,hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate: isEstimate, sbs:sbs, type: type)
        
        var maxWidth = self.tg_leftPadding
        var maxHeight = self.tg_topPadding
        
        var sbs:[UIView]! = sbs
        if sbs == nil
        {
            sbs = self.tgGetLayoutSubviews()
        }
        
        for sbv in sbs
        {
            
            if (sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)
            {
                sbv.tgHeight?._dimeVal = nil
            }
            
            if (sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false)
            {
                sbv.tgWidth?._dimeVal = nil
            }
            
            if !isEstimate
            {
                sbv.tgFrame.frame = sbv.bounds
                self.tgCalcSizeFromSizeWrapSubview(sbv)
            }
            
            
            if let sbvl = sbv as? TGBaseLayout
            {
                
                if (sbvl.tgWidth?.isWrap ?? false) || (sbvl.tgHeight?.isWrap ?? false)
                {
                    hasSubLayout = true
                }
                
                if (isEstimate && ((sbvl.tgWidth?.isWrap ?? false) || (sbvl.tgHeight?.isWrap ?? false)))
                {
                    _ = sbvl.tg_sizeThatFits(sbvl.tgFrame.frame.size,inSizeClass:type)
                    sbvl.tgFrame.sizeClass = sbvl.tgMatchBestSizeClass(type)
                }
                
            }
            
            //计算视图的位置和尺寸
            sbv.tgFrame.frame = self.tgCalcSubviewRect(sbv, rect:sbv.tgFrame.frame, selfSize:selfSize)
            
            //如果子视图的宽度不依赖于父视图则参与最大宽度计算。
            if !((sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false)) &&
                (sbv.tgWidth?.dimeRelaVal == nil || sbv.tgWidth!.dimeRelaVal !== self.tgWidth) &&
                !(sbv.tgWidth?.isFill ?? false) &&
                sbv.tgWidth?.dimeWeightVal == nil
            {
                if (maxWidth < sbv.tgFrame.frame.maxX)
                {
                    maxWidth = sbv.tgFrame.frame.maxX;
                }
            }
            
            //如果子视图的高度不依赖于父视图则参与最大高度计算。
            if !((sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)) &&
                (sbv.tgHeight?.dimeRelaVal == nil || sbv.tgHeight!.dimeRelaVal !== self.tgHeight) &&
                !(sbv.tgHeight?.isFill ?? false) &&
                sbv.tgHeight?.dimeWeightVal == nil
            {
                if (maxHeight < sbv.tgFrame.frame.maxY)
                {
                    maxHeight = sbv.tgFrame.frame.maxY;
                }
            }
            
        }
        
        //如果自身的宽度和高度是包裹属性则尺寸由子视图最大的尺寸给出。
        if (self.tgWidth?.isWrap ?? false)
        {
            selfSize.width = maxWidth + self.tg_rightPadding;
        }
        
        if (self.tgHeight?.isWrap ?? false)
        {
            selfSize.height = maxHeight + self.tg_bottomPadding;
        }
        
        selfSize.height = self.tgValidMeasure(self.tgHeight,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.tgValidMeasure(self.tgWidth,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        //因为还存在有部分子视图依赖于布局视图尺寸的情况，所以如果布局视图本身是wrap的则需要更新那部分依赖的子视图的尺寸。
        if (self.tgWidth?.isWrap ?? false) || (self.tgHeight?.isWrap ?? false)
        {
            for  sbv:UIView in sbs
            {
                
                if ((sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false)) ||
                    (sbv.tgWidth?.dimeRelaVal != nil && sbv.tgWidth!.dimeRelaVal === self.tgWidth) ||
                    (sbv.tgWidth?.isFill ?? false) ||
                    sbv.tgWidth?.dimeWeightVal != nil ||
                    ((sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)) ||
                    (sbv.tgHeight?.dimeRelaVal != nil && sbv.tgHeight!.dimeRelaVal === self.tgHeight) ||
                    (sbv.tgHeight?.isFill ?? false) ||
                    sbv.tgHeight?.dimeWeightVal != nil
                {
                    sbv.tgFrame.frame = self.tgCalcSubviewRect(sbv,rect:sbv.tgFrame.frame, selfSize:selfSize)
                }
            }
        }
        
        return (self.tgAdjustSizeWhenNoSubviews(size: selfSize, sbs: sbs),hasSubLayout)
        
    }
    
}

//internal and private method
extension TGFrameLayout
{
    fileprivate func tgCalcSubviewRect(_ sbv: UIView, rect:CGRect, selfSize:CGSize) -> CGRect
    {
        
        let selfFloatWidth = selfSize.width - self.tg_leftPadding - self.tg_rightPadding
        let selfFloatHeight = selfSize.height - self.tg_topPadding - self.tg_bottomPadding
        let leftMargin = (sbv.tgLeft?.realMarginInSize(selfFloatWidth) ?? 0)
        let rightMargin = (sbv.tgRight?.realMarginInSize(selfFloatWidth) ?? 0)
        let topMargin = (sbv.tgTop?.realMarginInSize(selfFloatHeight) ?? 0)
        let bottomMargin = (sbv.tgBottom?.realMarginInSize(selfFloatHeight) ?? 0)
        
        var retRect = rect
        
        //明确宽度的情况。
        if sbv.tgWidth?.dimeNumVal != nil {
            retRect.size.width = sbv.tgWidth!.measure;
        }
        else if sbv.tgWidth?.dimeRelaVal != nil && sbv.tgWidth!.dimeRelaVal.view !== sbv
        {
            if sbv.tgWidth!.dimeRelaVal.view === self
            {
                retRect.size.width =  sbv.tgWidth!.measure(selfFloatWidth)
            }
            else
            {
                retRect.size.width = sbv.tgWidth!.measure(sbv.tgWidth!.dimeRelaVal.view.tg_estimatedFrame.width)
            }
        }
        else if (sbv.tgWidth?.isFill ?? false)
        {
            retRect.size.width = sbv.tgWidth!.measure(selfFloatWidth - leftMargin - rightMargin)
        }
        else if sbv.tgWidth?.dimeWeightVal != nil
        {
            retRect.size.width = sbv.tgWidth!.measure(selfFloatWidth * sbv.tgWidth!.dimeWeightVal.rawValue / 100)
        }
        
        
        //明确高度的情况
        if sbv.tgHeight?.dimeNumVal != nil
        {
            retRect.size.height = sbv.tgHeight!.measure;
        }
        else if sbv.tgHeight?.dimeRelaVal != nil && sbv.tgHeight!.dimeRelaVal.view != sbv
        { //高度依赖其他视图
            
            if sbv.tgHeight!.dimeRelaVal.view === self
            {
                retRect.size.height =  sbv.tgHeight!.measure(selfFloatHeight)
            }
            else
            {
                retRect.size.height = sbv.tgHeight!.measure(sbv.tgHeight!.dimeRelaVal.view.tg_estimatedFrame.height)
            }
            
        }
        else if (sbv.tgHeight?.isFill ?? false)
        {
            retRect.size.height = sbv.tgHeight!.measure(selfFloatHeight - topMargin - bottomMargin)
        }
        else if (sbv.tgHeight?.dimeWeightVal != nil)
        {//比重高度
            retRect.size.height = sbv.tgHeight!.measure(selfFloatHeight * sbv.tgHeight!.dimeWeightVal.rawValue/100)
        }
        
        
        //宽度有效性调整。
        retRect.size.width = self.tgValidMeasure(sbv.tgWidth, sbv:sbv, calcSize:retRect.size.width, sbvSize:retRect.size, selfLayoutSize:selfSize)
        
        //左右位置处理，特殊处理如果设置了左右边距则确定了视图的宽度
        var horz:TGGravity = .none
        if (sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false)
        {
            horz = TGGravity.horz.fill;
        }
        else if (sbv.tgCenterX?.hasValue ?? false)
        {
            horz = TGGravity.horz.center
        }
        else if (sbv.tgLeft?.hasValue ?? false)
        {
            horz = TGGravity.horz.left
        }
        else if (sbv.tgRight?.hasValue ?? false)
        {
            horz = TGGravity.horz.right
        }
        retRect = self.tgCalcHorzGravity(horz, selfSize:selfSize, sbv: sbv, rect: retRect)
        
        
        if (sbv.tgHeight?.isFlexHeight ?? false)
        {
            retRect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: retRect.size.width)
        }
        
        retRect.size.height = self.tgValidMeasure(sbv.tgHeight,sbv:sbv,calcSize:retRect.size.height,sbvSize:retRect.size, selfLayoutSize:selfSize)
        
        
        var vert:TGGravity = .none
        if (sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)
        {
            vert = TGGravity.vert.fill;
        }
        else if (sbv.tgCenterY?.hasValue ?? false)
        {
            vert = TGGravity.vert.center
        }
        else if (sbv.tgTop?.hasValue ?? false)
        {
            vert = TGGravity.vert.top
        }
        else if (sbv.tgBottom?.hasValue ?? false)
        {
            vert = TGGravity.vert.bottom
        }
        retRect = self.tgCalcVertGravity(vert, selfSize:selfSize, sbv: sbv, rect: retRect)
        
        
        //特殊处理宽度等于自身高度的情况。
        if (sbv.tgWidth?.dimeRelaVal != nil && sbv.tgWidth!.dimeRelaVal.view == sbv && sbv.tgWidth!.dimeRelaVal._type == TGGravity.vert.fill)
        {
            retRect.size.width =   self.tgValidMeasure(sbv.tgWidth, sbv: sbv, calcSize: sbv.tgWidth!.measure(retRect.size.height), sbvSize: retRect.size, selfLayoutSize: selfSize)
            
            retRect = self.tgCalcHorzGravity(horz, selfSize:selfSize, sbv: sbv, rect: retRect)

        }
        
        //特殊处理高度等于自身宽度的情况。
        if sbv.tgHeight?.dimeRelaVal != nil && sbv.tgHeight!.dimeRelaVal.view == sbv
        {
            retRect.size.height = sbv.tgHeight!.measure(retRect.size.width)
            
            if (sbv.tgHeight?.isFlexHeight ?? false)
            {
                retRect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: retRect.size.width)
            }
            
            
            retRect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: retRect.size.height, sbvSize: retRect.size, selfLayoutSize: selfSize)
            
            retRect = self.tgCalcVertGravity(vert, selfSize:selfSize, sbv: sbv, rect: retRect)

            
        }
        return retRect
    }
}
