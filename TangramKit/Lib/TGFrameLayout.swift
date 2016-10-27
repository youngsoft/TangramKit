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
    
    internal override func calcLayoutRect(_ size:CGSize, isEstimate:Bool ,type:TGSizeClassType) -> (selfSize:CGSize, hasSubLayout:Bool)
    {
        var (selfSize,hasSubLayout) = super.calcLayoutRect(size, isEstimate: isEstimate, type: type)
        
        var maxWidth = self.tg_leftPadding
        var maxHeight = self.tg_topPadding
        
        let sbs = self.getLayoutSubviews()
        for sbv in sbs
        {
            
            if sbv.tg_top.hasValue && sbv.tg_bottom.hasValue
            {
                sbv.tg_height._dimeVal = nil
            }
            
            if sbv.tg_left.hasValue && sbv.tg_right.hasValue
            {
                sbv.tg_width._dimeVal = nil
            }
            
            if !isEstimate
            {
                sbv.tgFrame.frame = sbv.bounds
                self.calcSizeOfWrapContentSubview(sbv)
            }
            
            
            if let sbvl = sbv as? TGBaseLayout
            {
                
                if (sbvl.tg_width.isWrap || sbvl.tg_height.isWrap)
                {
                    hasSubLayout = true
                }
                
                if (isEstimate && (sbvl.tg_width.isWrap || sbvl.tg_height.isWrap))
                {
                    _ = sbvl.tg_sizeThatFits(sbvl.tgFrame.frame.size,inSizeClass:type)
                    sbvl.tgFrame.sizeClass = sbvl.tgMatchBestSizeClass(type)
                }
                
            }
            
            //计算视图的位置和尺寸
            sbv.tgFrame.frame = self.calcSubView(sbv, rect:sbv.tgFrame.frame, selfSize:selfSize)
            
            //如果子视图的宽度不依赖于父视图则参与最大宽度计算。
            if !(sbv.tg_left.hasValue && sbv.tg_right.hasValue) && sbv.tg_width.dimeRelaVal !== self.tg_width && !sbv.tg_width.isFill
            {
                if (maxWidth < sbv.tgFrame.frame.maxX)
                {
                    maxWidth = sbv.tgFrame.frame.maxX;
                }
            }
            
            //如果子视图的高度不依赖于父视图则参与最大高度计算。
            if !(sbv.tg_top.hasValue && sbv.tg_bottom.hasValue) && sbv.tg_height.dimeRelaVal !== self.tg_height && !sbv.tg_height.isFill
            {
                if (maxHeight < sbv.tgFrame.frame.maxY)
                {
                    maxHeight = sbv.tgFrame.frame.maxY;
                }
            }
            
        }
        
        //如果自身的宽度和高度是包裹属性则尺寸由子视图最大的尺寸给出。
        if (self.tg_width.isWrap)
        {
            selfSize.width = maxWidth + self.tg_rightPadding;
        }
        
        if (self.tg_height.isWrap)
        {
            selfSize.height = maxHeight + self.tg_bottomPadding;
        }
        
        selfSize.height = self.validMeasure(self.tg_height,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.validMeasure(self.tg_width,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        //因为还存在有部分子视图依赖于布局视图尺寸的情况，所以如果布局视图本身是wrap的则需要更新那部分依赖的子视图的尺寸。
        if (self.tg_width.isWrap || self.tg_height.isWrap)
        {
            for  sbv:UIView in sbs
            {
                
                if (sbv.tg_left.hasValue && sbv.tg_right.hasValue) ||
                    sbv.tg_width.dimeRelaVal === self.tg_width ||
                    sbv.tg_width.isFill ||
                    (sbv.tg_top.hasValue && sbv.tg_bottom.hasValue) ||
                    sbv.tg_height.dimeRelaVal === self.tg_height ||
                    sbv.tg_height.isFill
                {
                    sbv.tgFrame.frame = self.calcSubView(sbv,rect:sbv.tgFrame.frame, selfSize:selfSize)
                }
            }
        }
        
        return (selfSize,hasSubLayout)
        
    }
    
}

//internal and private method
extension TGFrameLayout
{
    fileprivate func calcSubView(_ sbv: UIView, rect:CGRect, selfSize:CGSize) -> CGRect
    {
        
        let selfFloatWidth = selfSize.width - self.tg_leftPadding - self.tg_rightPadding - sbv.tg_left.margin - sbv.tg_right.margin
        let selfFloatHeight = selfSize.height - self.tg_topPadding - self.tg_bottomPadding - sbv.tg_top.margin - sbv.tg_bottom.margin
        
        
        var retRect = rect
        
        //明确宽度的情况。
        if sbv.tg_width.dimeNumVal != nil {
            retRect.size.width = sbv.tg_width.measure;
        }
        
        //宽度依赖其他视图
        if (sbv.tg_width.dimeRelaVal != nil && sbv.tg_width.dimeRelaVal.view != sbv) || sbv.tg_width.isFill
        {
            if sbv.tg_width.isFill || sbv.tg_width.dimeRelaVal.view === self
            {
                retRect.size.width =  sbv.tg_width.measure(selfFloatWidth)
            }
            else
            {
                retRect.size.width = sbv.tg_width.measure(sbv.tg_width.dimeRelaVal.view.tg_estimatedFrame.width)
            }
        }
        
        //比重宽度
        if (sbv.tg_width.dimeWeightVal != nil)
        {
            retRect.size.width = sbv.tg_width.measure(selfFloatWidth * sbv.tg_width.dimeWeightVal.rawValue / 100)
        }
        
        
        
        //明确高度的情况
        if sbv.tg_height.dimeNumVal != nil{
            retRect.size.height = sbv.tg_height.measure;
        }
        
        //高度依赖其他视图
        if (sbv.tg_height.dimeRelaVal != nil && sbv.tg_height.dimeRelaVal.view != sbv) || sbv.tg_height.isFill
        {
            if sbv.tg_height.isFill || sbv.tg_height.dimeRelaVal.view === self
            {
                retRect.size.height =  sbv.tg_height.measure(selfFloatHeight)
                
            }
            else
            {
                retRect.size.height = sbv.tg_height.measure(sbv.tg_height.dimeRelaVal.view.tg_estimatedFrame.height)
                
            }
            
        }
        
        //比重高度
        if (sbv.tg_height.dimeWeightVal != nil)
        {
            retRect.size.height = sbv.tg_height.measure(selfFloatHeight * sbv.tg_height.dimeWeightVal.rawValue/100)
        }
        
        
        //宽度有效性调整。
        retRect.size.width = self.validMeasure(sbv.tg_width, sbv:sbv, calcSize:retRect.size.width, sbvSize:retRect.size, selfLayoutSize:selfSize)
        
        //左右位置处理，特殊处理如果设置了左右边距则确定了视图的宽度
        var horz:TGGravity = .none
        if (sbv.tg_left.hasValue && sbv.tg_right.hasValue)
        {
            horz = TGGravity.horz.fill;
        }
        else if (sbv.tg_centerX.hasValue)
        {
            horz = TGGravity.horz.center
        }
        else if (sbv.tg_left.hasValue)
        {
            horz = TGGravity.horz.left
        }
        else if (sbv.tg_right.hasValue)
        {
            horz = TGGravity.horz.right
        }
        retRect = self.horzGravity(horz, selfSize:selfSize, sbv: sbv, rect: retRect)
        
        
        if sbv.tg_height.isFlexHeight
        {
            retRect.size.height = self.heightFromFlexedHeightView(sbv, width: retRect.size.width)
        }
        
        retRect.size.height = self.validMeasure(sbv.tg_height,sbv:sbv,calcSize:retRect.size.height,sbvSize:retRect.size, selfLayoutSize:selfSize)
        
        
        var vert:TGGravity = .none
        if (sbv.tg_top.hasValue && sbv.tg_bottom.hasValue)
        {
            vert = TGGravity.vert.fill;
        }
        else if (sbv.tg_centerY.hasValue)
        {
            vert = TGGravity.vert.center
        }
        else if (sbv.tg_top.hasValue)
        {
            vert = TGGravity.vert.top
        }
        else if (sbv.tg_bottom.hasValue)
        {
            vert = TGGravity.vert.bottom
        }
        retRect = self.vertGravity(vert, selfSize:selfSize, sbv: sbv, rect: retRect)
        
        
        //特殊处理宽度等于自身高度的情况。
        if (sbv.tg_width.dimeRelaVal != nil && sbv.tg_width.dimeRelaVal.view == sbv && sbv.tg_width.dimeRelaVal._type == TGGravity.vert.fill)
        {
            retRect.size.width =   self.validMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure(retRect.size.height), sbvSize: retRect.size, selfLayoutSize: selfSize)
        }
        
        //特殊处理高度等于自身宽度的情况。
        if sbv.tg_height.dimeRelaVal != nil && sbv.tg_height.dimeRelaVal!.view == sbv
        {
            retRect.size.height = sbv.tg_height.measure(retRect.size.width)
            
            if sbv.tg_height.isFlexHeight
            {
                retRect.size.height = self.heightFromFlexedHeightView(sbv, width: retRect.size.width)
            }
            
            retRect.size.height = self.validMeasure(sbv.tg_height, sbv: sbv, calcSize: retRect.size.height, sbvSize: retRect.size, selfLayoutSize: selfSize)
            
        }
        return retRect
    }
}
