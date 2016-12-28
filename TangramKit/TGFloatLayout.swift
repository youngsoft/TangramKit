//
//  TGFloatLayout.swift
//  TangramKit
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

extension UIView
{
    /**
     *是否反方向浮动，这个属性只有在浮动布局下才有意义。默认是false表示正向浮动，具体方向则根据浮动布局视图的方向。如果是垂直布局则默认是向左浮动的，如果是水平布局则默认是向上浮动的。
     如果这个值设置为true则当布局是垂直布局时则向右浮动，而如果是水平布局则向下浮动。
     */
    public var tg_reverseFloat:Bool
        {
        get
        {
            return self.tgCurrentSizeClass.tg_reverseFloat
        }
        set
        {
            let sc = self.tgCurrentSizeClass
            if sc.tg_reverseFloat != newValue
            {
                
                sc.tg_reverseFloat = newValue
                if let sView = self.superview
                {
                    sView.setNeedsLayout()
                }
            }
        }
    }
    
    /**
     *清除浮动，这个属性只有在浮动布局下才有意义。默认是false。这个属性也跟布局视图的方向相关。如果设置为了清除浮动属性则表示本子视图不会在浮动方向上紧跟在前一个浮动子视图的后面，而是会另外新起一行或者一列来进行布局。tg_reverseFloat和tg_clearFloat这两个属性的定义是完全参考CSS样式表中浮动布局中的float和clear这两个属性。
     */
    public var tg_clearFloat:Bool
        {
        get
        {
            return self.tgCurrentSizeClass.tg_clearFloat
        }
        set
        {
            let sc = self.tgCurrentSizeClass
            if sc.tg_clearFloat != newValue
            {
                
                sc.tg_clearFloat = newValue
                if let sView = self.superview
                {
                    sView.setNeedsLayout()
                }
            }
        }
    }

}

/**
 * 浮动布局是一种里面的子视图按照约定的方向浮动停靠，当尺寸不足以被容纳时会自动寻找最佳的位置进行浮动停靠的布局视图。
 *浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。
 *根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。
 */
open class TGFloatLayout: TGBaseLayout,TGFloatLayoutViewSizeClass {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    public init(_ orientation:TGOrientation = .vert)
    {
        super.init(frame: CGRect.zero)
        
        (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClass).tg_orientation = orientation
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    /**
     *浮动布局的方向。
     *如果是.vert则表示从左到右，从上到下的垂直布局方式，这个方式是默认方式。
     *如果是.horz则表示从上到下，从左到右的水平布局方式
     */
    public var tg_orientation:TGOrientation
        {
        get
        {
            return (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClass).tg_orientation
        }
        set
        {
            (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClass).tg_orientation = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *浮动布局内所有子视图的整体停靠对齐位置设定，默认是.none
     *如果视图方向为.vert时则水平方向的停靠失效。只能设置TGGravity.vert.top,TGGravity.vert.center,TGGravity.vert.bottom 三个值。
     *如果视图方向为.horz时则垂直方向的停靠失效。只能设置TGGravity.horz.left,TGGravity.horz.center,TGGravity.horz.right
     */
    public var tg_gravity:TGGravity
        {
        get
        {
            return (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClass).tg_gravity
        }
        set
        {
            (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClass).tg_gravity = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *不做布局边界的限制，子视图不会自动换行，因此当设置为true时，子视图需要设置tg_clearFloat来实现主动换行的处理。默认为false。
     *当布局的orientation为.vert并且tg_width.equal(.wrap)时,这个属性设置为true才生效。
     *当布局的orientation为.horz并且tg_height.equal(.wrap)时，这个属性设置为true才生效。
     *当属性设置为true时，子视图不能将扩展属性tg_reverseFloat设置为true，否则将导致结果异常。
     *这个属性设置为true时，在左右浮动布局中，子视图只能向左浮动，并且没有右边界的限制，因此如果子视图没有tg_clearFloat时则总是排列在前一个子视图的右边，并不会自动换行,因此为了让这个属性生效，布局视图必须要同时设置tg_width.equal(.wrap)。
     *这个属性设置为true时，在上下浮动布局中，子视图只能向上浮动，并且没有下边界的限制，因此如果子视图没有设置tg_clearFloat时则总是排列在前一个子视图的下边，并不会自动换行，因此为了让这个属性生效，布局视图必须要同时设置tg_height.equal(.wrap).
     */
    public var tg_noBoundaryLimit:Bool
    {
        get
        {
            return (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClass).tg_noBoundaryLimit
        }
        set
        {
            (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClass).tg_noBoundaryLimit = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *根据浮动布局视图的方向设置子视图的固定尺寸和视图之间的最小间距。在一些应用场景我们有时候希望某些子视图的宽度是固定的情况下，子视图的间距是浮动的而不是固定的，这样就可以尽可能的容纳更多的子视图。比如每个子视图的宽度是固定80，那么在小屏幕下每行只能放3个，而我们希望大屏幕每行能放4个或者5个子视图。因此您可以通过如下方法来设置浮动间距。这个方法会根据您当前布局的orientation方向不同而意义不同：
     1.如果您的布局方向是MyLayoutViewOrientation_Vert表示设置的是子视图的水平间距，其中的subviewSize指定的是子视图的宽度，minSpace指定的是最小的水平间距，maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的宽度。
     2.如果您的布局方向是MyLayoutViewOrientation_Horz表示设置的是子视图的垂直间距，其中的subviewSize指定的是子视图的高度，minSpace指定的是最小的垂直间距，maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的高度。
     3.如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
     */
    public func tg_setSubviews(size:CGFloat, minSpace:CGFloat, maxSpace:CGFloat = .greatestFiniteMagnitude, inSizeClass type:TGSizeClassType = .default)
    {
        let sc = self.tg_fetchSizeClass(with: type) as! TGFloatLayoutViewSizeClassImpl
        sc.tgSubviewSize = size
        sc.tgMinSpace = minSpace
        sc.tgMaxSpace = maxSpace
        
        self.setNeedsLayout()
    }
    

    //MARK: override method

    override internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, type :TGSizeClassType) ->(selfSize:CGSize, hasSubLayout:Bool)
    {
        var (selfSize, hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate:isEstimate, type:type)
        
        
        let  sbs = self.tgGetLayoutSubviews()
        
        for sbv in sbs
        {
            if (!isEstimate)
            {
                sbv.tgFrame.frame = sbv.bounds;
                self.tgCalcSizeFromSizeWrapSubview(sbv)
                
            }
            
            if let sbvl:TGBaseLayout = sbv as? TGBaseLayout
            {
                if sbvl.tg_width.isWrap || sbvl.tg_height.isWrap
                {
                   hasSubLayout = true
                }
                
                if isEstimate && (sbvl.tg_width.isWrap || sbvl.tg_height.isWrap)
                {
                    _ = sbvl.tg_sizeThatFits(sbvl.tgFrame.frame.size,inSizeClass:type)
                    sbvl.tgFrame.sizeClass = sbvl.tgMatchBestSizeClass(type) //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                }
            }
        }
        
        
        if (self.tg_orientation == .vert)
        {
            selfSize = self.tgLayoutSubviewsForVert(selfSize,sbs:sbs);
        }
        else
        {
            selfSize = self.tgLayoutSubviewsForHorz(selfSize,sbs:sbs);
        }
        
        
        
        
        selfSize.height = self.tgValidMeasure(self.tg_height,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.tgValidMeasure(self.tg_width,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        
        return (selfSize,hasSubLayout)
    }
    
    
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGFloatLayoutViewSizeClassImpl()
    }
    
    
    
}


extension TGFloatLayout
{
    
    
    
    fileprivate func tgFindRightCandidatePoint(_ leftCandidateRect:CGRect, width:CGFloat, rightBoundary:CGFloat, rightCandidateRects:[CGRect], hasWeight:Bool) ->CGPoint
    {
        
        var retPoint = CGPoint(x: rightBoundary,y: CGFloat.greatestFiniteMagnitude)
        
        var lastHeight = self.tg_topPadding;
        
        var i = rightCandidateRects.count - 1
        while i >= 0
        {
            //CGFloat
            let rightCandidateRect = rightCandidateRects[i]
            //如果有比重则不能相等只能小于。
            if (hasWeight ? leftCandidateRect.maxX + width < rightCandidateRect.minX : /*leftCandidateRect.maxX + width <= rightCandidateRect.minX*/ _tgCGFloatLessOrEqual(leftCandidateRect.maxX + width, rightCandidateRect.minX)) &&
                leftCandidateRect.maxY > lastHeight
            {
                
                retPoint.y = max(leftCandidateRect.minY,lastHeight);
                retPoint.x = rightCandidateRect.minX;
                break;
            }
            
            lastHeight = rightCandidateRect.maxY;
            i-=1
        }
        
        if retPoint.y == CGFloat.greatestFiniteMagnitude
        {
            if (hasWeight ? leftCandidateRect.maxX + width < rightBoundary : /*leftCandidateRect.maxX + width <= rightBoundary*/_tgCGFloatLessOrEqual(leftCandidateRect.maxX + width, rightBoundary) ) &&
                leftCandidateRect.maxY > lastHeight
            {
                retPoint.y =  max(leftCandidateRect.minY,lastHeight);
            }
        }
        
        return retPoint;
    }
    
    
    fileprivate func tgFindBottomCandidatePoint(_ topCandidateRect:CGRect, height:CGFloat, bottomBoundary:CGFloat, bottomCandidateRects:[CGRect], hasWeight:Bool) ->CGPoint
    {
        
        var  retPoint = CGPoint(x: CGFloat.greatestFiniteMagnitude,y: bottomBoundary)
        
        var lastWidth = self.tg_leftPadding;
        var i = bottomCandidateRects.count - 1
        while i >= 0
        {
            
            let bottomCandidateRect = bottomCandidateRects[i]
            
            if (hasWeight ? topCandidateRect.maxY + height < bottomCandidateRect.minY : /*topCandidateRect.maxY + height <= bottomCandidateRect.minY*/ _tgCGFloatLessOrEqual(topCandidateRect.maxY + height, bottomCandidateRect.minY) ) &&
                topCandidateRect.maxX > lastWidth
            {
                retPoint.x = max(topCandidateRect.minX,lastWidth);
                retPoint.y = bottomCandidateRect.minY;
                break;
            }
            
            lastWidth = bottomCandidateRect.maxX;
            i -= 1
        }
        
        if (retPoint.x == CGFloat.greatestFiniteMagnitude)
        {
            if ((hasWeight ? topCandidateRect.maxY + height < bottomBoundary : /*topCandidateRect.maxY + height <= bottomBoundary*/ _tgCGFloatLessOrEqual(topCandidateRect.maxY + height, bottomBoundary) ) &&
                topCandidateRect.maxX > lastWidth)
            {
                retPoint.x =  max(topCandidateRect.minX,lastWidth);
            }
        }
        
        return retPoint;
    }
    
    
    fileprivate func tgFindLeftCandidatePoint(_ rightCandidateRect:CGRect, width:CGFloat, leftBoundary:CGFloat, leftCandidateRects:[CGRect], hasWeight:Bool) ->CGPoint
    {
        
        var retPoint = CGPoint(x: leftBoundary,y: CGFloat.greatestFiniteMagnitude)
        
        var lastHeight = self.tg_topPadding;
        var i = leftCandidateRects.count - 1
        while i >= 0
        {
            
            let  leftCandidateRect = leftCandidateRects[i]
            if ((hasWeight ? rightCandidateRect.minX - width > leftCandidateRect.maxX : /*rightCandidateRect.minX - width >= leftCandidateRect.maxX*/ _tgCGFloatGreatOrEqual(rightCandidateRect.minX - width, leftCandidateRect.maxX)) &&
                rightCandidateRect.maxY > lastHeight)
            {
                retPoint.y = max(rightCandidateRect.minY,lastHeight);
                retPoint.x = leftCandidateRect.maxX;
                break;
            }
            
            lastHeight = leftCandidateRect.maxY;
            i -= 1
            
        }
        
        if (retPoint.y == CGFloat.greatestFiniteMagnitude)
        {
            if ((hasWeight ? rightCandidateRect.minX - width > leftBoundary : /*rightCandidateRect.minX - width >= leftBoundary*/ _tgCGFloatGreatOrEqual(rightCandidateRect.minX - width, leftBoundary)) &&
                rightCandidateRect.maxY > lastHeight)
            {
                retPoint.y =  max(rightCandidateRect.minY,lastHeight);
            }
        }
        
        return retPoint;
    }
    
    fileprivate func tgFindTopCandidatePoint(_ bottomCandidateRect:CGRect, height:CGFloat, topBoundary:CGFloat, topCandidateRects:[CGRect], hasWeight:Bool) ->CGPoint
    {
        
        var retPoint = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: topBoundary)
        
        var lastWidth = self.tg_leftPadding;
        var i = topCandidateRects.count - 1
        while i >= 0
        {
            
            let topCandidateRect = topCandidateRects[i]
            if ((hasWeight ? bottomCandidateRect.minY - height > topCandidateRect.maxY : /*bottomCandidateRect.minY - height >= topCandidateRect.maxY*/ _tgCGFloatGreatOrEqual(bottomCandidateRect.minY - height, topCandidateRect.maxY)) &&
                bottomCandidateRect.maxX > lastWidth)
            {
                retPoint.x = max(bottomCandidateRect.minX,lastWidth);
                retPoint.y = topCandidateRect.maxY;
                break;
            }
            
            lastWidth = topCandidateRect.maxX;
            i -= 1
            
        }
        
        if (retPoint.x == CGFloat.greatestFiniteMagnitude)
        {
            if ((hasWeight ? bottomCandidateRect.minY - height > topBoundary : /*bottomCandidateRect.minY - height >= topBoundary*/ _tgCGFloatGreatOrEqual(bottomCandidateRect.minY - height, topBoundary)) &&
                bottomCandidateRect.maxX > lastWidth)
            {
                retPoint.x =  max(bottomCandidateRect.minX,lastWidth);
            }
        }
        
        return retPoint;
    }
    
    
    fileprivate func tgLayoutSubviewsForVert(_ selfSize:CGSize, sbs:[UIView]) -> CGSize
    {
        let padding = self.tg_padding;
        var selfSize = selfSize
        var hasBoundaryLimit = true
        if self.tg_width.isWrap && self.tg_noBoundaryLimit
        {
            hasBoundaryLimit = false
        }
        
        if !hasBoundaryLimit
        {
            selfSize.width = CGFloat.greatestFiniteMagnitude
        }
        
        
        //遍历所有的子视图，查看是否有子视图的宽度会比视图自身要宽，如果有且有包裹属性则扩充自身的宽度
        if (self.tg_width.isWrap && hasBoundaryLimit)
        {
            var maxContentWidth = selfSize.width - padding.left - padding.right;
            for sbv in sbs
            {
                let leftMargin = sbv.tg_left.margin
                let rightMargin = sbv.tg_right.margin
                
                var rect = sbv.tgFrame.frame;
                
                //这里有可能设置了固定的宽度
                if (sbv.tg_width.dimeNumVal != nil)
                {
                    rect.size.width = sbv.tg_width.measure;
                }
                
                //有可能宽度是和他的高度相等。
                if sbv.tg_height === sbv.tg_width.dimeRelaVal
                {
                    if (sbv.tg_height.dimeNumVal != nil)
                    {
                        rect.size.height = sbv.tg_height.measure;
                    }
                    
                    if (sbv.tg_height.dimeRelaVal === self.tg_height)
                    {
                        rect.size.height = sbv.tg_height.measure(selfSize.height - padding.top - padding.bottom)
                    }
                    
                    rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    rect.size.width = sbv.tg_width.measure(rect.size.height)
                }
                
                rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                
                if (leftMargin + rect.size.width + rightMargin > maxContentWidth &&
                    sbv.tg_width.dimeRelaVal !== self.tg_width &&
                    sbv.tg_width.dimeWeightVal == nil &&
                    !sbv.tg_width.isFill)
                {
                    maxContentWidth = leftMargin + rect.size.width + rightMargin;
                }
            }
            
            selfSize.width = padding.left + maxContentWidth + padding.right;
        }
        
        let vertSpace = self.tg_vspace;
        var horzSpace = self.tg_hspace;
        var subviewSize = (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClassImpl).tgSubviewSize
        if (subviewSize != 0)
        {
            #if DEBUG
                //异常崩溃：当布局视图设置了tg_noBoundaryLimit为true时，不能设置最小垂直间距。
                assert(hasBoundaryLimit, "Constraint exception！！, vertical float layout:\(self) can not set tg_noBoundaryLimit to true when call  tg_setSubviews(size:CGFloat,minSpace:CGFloat,maxSpace:CGFloat)  method")
            #endif
            
            let minSpace = (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClassImpl).tgMinSpace
            let maxSpace = (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClassImpl).tgMaxSpace

            
            let rowCount =  floor((selfSize.width - padding.left - padding.right  + minSpace) / (subviewSize + minSpace));
            if (rowCount > 1)
            {
                horzSpace = (selfSize.width - padding.left - padding.right - subviewSize * rowCount)/(rowCount - 1);
                
                if horzSpace > maxSpace
                {
                    horzSpace = maxSpace
                    
                    subviewSize = (selfSize.width - padding.left - padding.right -  horzSpace * (rowCount - 1)) / rowCount
                }
            }
        }
        
        
        //左边候选区域数组，保存的是CGRect值。
        var leftCandidateRects:[CGRect] = [CGRect]()
        //为了计算方便总是把最左边的个虚拟区域作为一个候选区域
        leftCandidateRects.append(CGRect(x: padding.left, y: padding.top, width: 0, height: CGFloat.greatestFiniteMagnitude));
        
        //右边候选区域数组，保存的是CGRect值。
        var rightCandidateRects:[CGRect] = [CGRect]()
        //为了计算方便总是把最右边的个虚拟区域作为一个候选区域
        rightCandidateRects.append(CGRect(x: selfSize.width - padding.right, y: padding.top, width: 0, height: CGFloat.greatestFiniteMagnitude));
        
        //分别记录左边和右边的最后一个视图在Y轴的偏移量
        var leftLastYOffset = padding.top
        var rightLastYOffset = padding.top
        
        //分别记录左右边和全局浮动视图的最高占用的Y轴的值
        var leftMaxHeight = padding.top
        var rightMaxHeight = padding.top
        var maxHeight = padding.top
        var maxWidth = padding.left
        
        for sbv in sbs
        {
            let topMargin = sbv.tg_top.margin;
            let leftMargin = sbv.tg_left.margin;
            let bottomMargin = sbv.tg_bottom.margin;
            let rightMargin = sbv.tg_right.margin;
            var rect = sbv.tgFrame.frame;
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill
            let isHeightWeight = sbv.tg_height.dimeWeightVal != nil || sbv.tg_height.isFill
            
            
            if subviewSize != 0
            {
                rect.size.width = subviewSize
            }
            
            if (sbv.tg_width.dimeNumVal != nil)
            {
                rect.size.width = sbv.tg_width.measure;
            }
            
            if (sbv.tg_height.dimeNumVal != nil)
            {
                rect.size.height = sbv.tg_height.measure;
            }
            
            if isHeightWeight && !self.tg_height.isWrap
            {

                rect.size.height = sbv.tg_height.measure((selfSize.height - maxHeight - padding.bottom) * (sbv.tg_height.isFill ? 1.0 : sbv.tg_height.dimeWeightVal.rawValue/100) - topMargin - bottomMargin)
            }
            
            if (sbv.tg_height.dimeRelaVal === self.tg_height && !self.tg_height.isWrap)
            {
                rect.size.height = sbv.tg_height.measure(selfSize.height - padding.top - padding.bottom)
            }
            
            if (sbv.tg_width.dimeRelaVal === self.tg_width)
            {
                rect.size.width = sbv.tg_width.measure(selfSize.width - padding.left - padding.right)
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tg_height.dimeRelaVal === sbv.tg_width)
            {
                rect.size.height = sbv.tg_height.measure(rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tg_width.dimeRelaVal === sbv.tg_height)
            {
                rect.size.width = sbv.tg_width.measure(rect.size.height)
            }
            
            if (sbv.tg_width.dimeRelaVal != nil &&  sbv.tg_width.dimeRelaVal.view != nil &&  sbv.tg_width.dimeRelaVal.view != self && sbv.tg_width.dimeRelaVal.view != sbv)
            {
                rect.size.width = sbv.tg_width.measure(sbv.tg_width.dimeRelaVal.view.tgFrame.width)
            }
            
            if (sbv.tg_height.dimeRelaVal != nil &&  sbv.tg_height.dimeRelaVal.view != nil &&  sbv.tg_height.dimeRelaVal.view != self && sbv.tg_height.dimeRelaVal.view != sbv)
            {
                rect.size.height = sbv.tg_height.measure(sbv.tg_height.dimeRelaVal.view.tgFrame.height)
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //如果高度是浮动的则需要调整高度。
            if (sbv.tg_height.isFlexHeight)
            {
                
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tg_reverseFloat)
            {
                #if DEBUG
                    //异常崩溃：当布局视图设置了tg_noBoundaryLimit为true时子视图不能设置逆向浮动
                    assert(hasBoundaryLimit, "Constraint exception！！, vertical float layout:\(self) can not set tg_noBoundaryLimit to true when the subview:\(sbv) set tg_reverseFloat to true.")
                #endif
                
                var nextPoint = CGPoint(x: selfSize.width - padding.right, y: leftLastYOffset);
                var leftCandidateXBoundary = padding.left;
                if (sbv.tg_clearFloat)
                {
                    
                    //找到最底部的位置。
                    nextPoint.y = max(rightMaxHeight, leftLastYOffset);
                    let leftPoint = self.tgFindLeftCandidatePoint(CGRect(x: selfSize.width - padding.right, y: nextPoint.y, width: 0, height: CGFloat.greatestFiniteMagnitude), width:leftMargin + (isWidthWeight ? 0 : rect.size.width) + rightMargin,leftBoundary:padding.left,leftCandidateRects:leftCandidateRects,hasWeight:false)
                    if (leftPoint.y != CGFloat.greatestFiniteMagnitude)
                    {
                        nextPoint.y = max(rightMaxHeight, leftPoint.y);
                        leftCandidateXBoundary = leftPoint.x;
                    }
                }
                else
                {
                    //依次从后往前，每个都比较右边的。
                    var i = rightCandidateRects.count - 1
                    while i >= 0
                    {
                        let candidateRect = rightCandidateRects[i]
                        let leftPoint = self.tgFindLeftCandidatePoint(candidateRect,width:leftMargin + (isWidthWeight ? 0 : rect.size.width) + rightMargin,leftBoundary:padding.left, leftCandidateRects:leftCandidateRects,hasWeight:isWidthWeight)
                        if (leftPoint.y != CGFloat.greatestFiniteMagnitude)
                        {
                            nextPoint = CGPoint(x: candidateRect.minX, y: max(nextPoint.y, leftPoint.y));
                            leftCandidateXBoundary = leftPoint.x;
                            break;
                        }
                        
                        nextPoint.y = candidateRect.maxY;
                        i -= 1
                    }
                }
                
                //重新设置宽度
                if isWidthWeight
                {
                    var widthWeight:CGFloat = 1.0
                    if sbv.tg_width.dimeWeightVal != nil
                    {
                        widthWeight = sbv.tg_width.dimeWeightVal.rawValue / 100
                    }
                    
                    rect.size.width =  self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: (nextPoint.x - leftCandidateXBoundary + sbv.tg_width.addVal) * widthWeight - leftMargin - rightMargin, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    if (sbv.tg_height.dimeRelaVal === sbv.tg_width)
                    {
                        rect.size.height = sbv.tg_height.measure(rect.size.width)
                    }
                    
                    if (sbv.tg_height.isFlexHeight)
                    {
                        
                        rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                    }
                    
                    rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                }
                
                
                rect.origin.x = nextPoint.x - rightMargin - rect.size.width;
                rect.origin.y = min(nextPoint.y, maxHeight) + topMargin;
                
                //如果有智能边界线则找出所有智能边界线。
                if (self.tg_intelligentBorderline != nil)
                {
                    //优先绘制左边和上边的。绘制左边的和上边的。
                    if let sbvl = sbv as? TGBaseLayout
                    {
                        if (!sbvl.tg_notUseIntelligentBorderline)
                        {
                            sbvl.tg_bottomBorderline = nil;
                            sbvl.tg_topBorderline = nil;
                            sbvl.tg_rightBorderline = nil;
                            sbvl.tg_leftBorderline = nil;
                            
                            if (rect.origin.x + rect.size.width + rightMargin < selfSize.width - padding.right)
                            {
                                sbvl.tg_rightBorderline = self.tg_intelligentBorderline;
                            }
                            
                            if (rect.origin.y + rect.size.height + bottomMargin < selfSize.height - padding.bottom)
                            {
                                sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                            }
                            
                            if (rect.origin.x > leftCandidateXBoundary && sbvl == sbs.last)
                            {
                                sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                            }
                        }
                        
                    }
                }
                
                
                
                //这里有可能子视图本身的宽度会超过布局视图本身，但是我们的候选区域则不存储超过的宽度部分。
                let cRect = CGRect(x: max(rect.origin.x - leftMargin - horzSpace,padding.left), y: rect.origin.y - topMargin, width: min((rect.size.width + leftMargin + rightMargin),(selfSize.width - padding.left - padding.right)), height: rect.size.height + topMargin + bottomMargin + vertSpace);
                
                
                //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
                rightCandidateRects = rightCandidateRects.filter({$0.maxY > cRect.maxY})
                
                
                //删除左边高度小于新添加区域的顶部的候选区域
                leftCandidateRects = leftCandidateRects.filter({$0.maxY > cRect.minY})
               
            
                rightCandidateRects.append(cRect)
                rightLastYOffset = rect.origin.y - topMargin;
                
                if (rect.origin.y + rect.size.height + bottomMargin + vertSpace > rightMaxHeight)
                {
                    rightMaxHeight = rect.origin.y + rect.size.height + bottomMargin + vertSpace;
                }
            }
            else
            {
                var nextPoint = CGPoint(x: padding.left, y: rightLastYOffset)
                var rightCandidateXBoundary = selfSize.width - padding.right;
                
                //如果是清除了浮动则直换行移动到最下面。
                if (sbv.tg_clearFloat)
                {
                    //找到最低点。
                    nextPoint.y = max(leftMaxHeight, rightLastYOffset);
                    
                    let rightPoint = self.tgFindRightCandidatePoint(CGRect(x: padding.left, y: nextPoint.y, width: 0, height: CGFloat.greatestFiniteMagnitude), width:leftMargin + (isWidthWeight ? 0 : rect.size.width) + rightMargin, rightBoundary:rightCandidateXBoundary, rightCandidateRects:rightCandidateRects, hasWeight:false)
                    if (rightPoint.y != CGFloat.greatestFiniteMagnitude)
                    {
                        nextPoint.y = max(leftMaxHeight, rightPoint.y);
                        rightCandidateXBoundary = rightPoint.x;
                    }
                }
                else
                {
                    
                    //依次从后往前，每个都比较右边的。
                    var i = leftCandidateRects.count - 1
                    while i >= 0
                    {
                        let candidateRect = leftCandidateRects[i]
                        let rightPoint = self.tgFindRightCandidatePoint(candidateRect, width:leftMargin + (isWidthWeight ? 0 : rect.size.width) + rightMargin,rightBoundary:selfSize.width - padding.right,rightCandidateRects:rightCandidateRects,hasWeight:isWidthWeight)
                        if (rightPoint.y != CGFloat.greatestFiniteMagnitude)
                        {
                            nextPoint = CGPoint(x: candidateRect.maxX, y: max(nextPoint.y, rightPoint.y));
                            rightCandidateXBoundary = rightPoint.x;
                            break;
                        }
                        
                        nextPoint.y = candidateRect.maxY;
                        i -= 1
                    }
                }
                
                //重新设置宽度
                if isWidthWeight
                {
                    #if DEBUG
                        //异常崩溃：当布局视图设置了tg_noBoundaryLimit为true时子视图不能设置tg_width为TGWeight类型和.fill类型
                        assert(hasBoundaryLimit, "Constraint exception！！, vertical float layout:\(self) can not set tg_noBoundaryLimit to true when the subview:\(sbv) set tg_width to TGWeight or .fill type value.")
                    #endif
                    
                    
                    var widthWeight:CGFloat = 1.0
                    if sbv.tg_width.dimeWeightVal != nil
                    {
                        widthWeight = sbv.tg_width.dimeWeightVal.rawValue / 100
                    }

                    
                    rect.size.width =  self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: (rightCandidateXBoundary - nextPoint.x + sbv.tg_width.addVal) * widthWeight - leftMargin - rightMargin, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    if (sbv.tg_height.dimeRelaVal === sbv.tg_width)
                    {
                        rect.size.height = sbv.tg_height.measure(rect.size.width)
                    }
                    
                    if (sbv.tg_height.isFlexHeight)
                    {
                        
                        rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                    }
                    
                    rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                }
                
                rect.origin.x = nextPoint.x + leftMargin;
                rect.origin.y = min(nextPoint.y,maxHeight) + topMargin;
                
                
                if (self.tg_intelligentBorderline != nil)
                {
                    //优先绘制左边和上边的。绘制左边的和上边的。
                    if let sbvl = sbv as? TGBaseLayout
                    {
                        if (!sbvl.tg_notUseIntelligentBorderline)
                        {
                            sbvl.tg_bottomBorderline = nil;
                            sbvl.tg_topBorderline = nil;
                            sbvl.tg_rightBorderline = nil;
                            sbvl.tg_leftBorderline = nil;
                            
                            //如果自己的上边和左边有子视图。
                            if (rect.origin.x - leftMargin > padding.left)
                            {
                                sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                            }
                            
                            if (rect.origin.y - topMargin > padding.top)
                            {
                                sbvl.tg_topBorderline = self.tg_intelligentBorderline;
                            }
                        }
                        
                    }
                }
                
                
                
                let cRect = CGRect(x: rect.origin.x - leftMargin, y: rect.origin.y - topMargin, width: min((rect.size.width + leftMargin + rightMargin + horzSpace),(selfSize.width - padding.left - padding.right)), height: rect.size.height + topMargin + bottomMargin + vertSpace);
                
                
                //把新添加到候选中去。并删除高度小于的候选键。和高度
                leftCandidateRects = leftCandidateRects.filter({$0.maxY > cRect.maxY})
                //删除右边高度小于新添加区域的顶部的候选区域
                rightCandidateRects = rightCandidateRects.filter({$0.maxY > cRect.minY})
               
                
                leftCandidateRects.append(cRect);
                leftLastYOffset = rect.origin.y - topMargin;
                
                if (rect.origin.y + rect.size.height + bottomMargin + vertSpace > leftMaxHeight)
                {
                    leftMaxHeight = rect.origin.y + rect.size.height + bottomMargin + vertSpace;
                }
                
            }
            
            if rect.origin.y + rect.size.height + bottomMargin + vertSpace > maxHeight
            {
                maxHeight = rect.origin.y + rect.size.height + bottomMargin + vertSpace;
            }
            
            if rect.origin.x + rect.size.width + rightMargin + horzSpace > maxWidth
            {
                maxWidth = rect.origin.x + rect.size.width + rightMargin + horzSpace
            }
            
            sbv.tgFrame.frame = rect;
            
        }
        
        if sbs.count > 0
        {
            maxHeight -= vertSpace
            maxWidth -= horzSpace
        }
        
        maxHeight += padding.bottom
        maxWidth += padding.right
        
        if !hasBoundaryLimit
        {
            selfSize.width = maxWidth
        }
        
        if (self.tg_height.isWrap)
        {
            selfSize.height = maxHeight
        }
        else
        {
            var addYPos:CGFloat = 0;
            let mgvert = self.tg_gravity & TGGravity.horz.mask;
            if (mgvert == TGGravity.vert.center)
            {
                addYPos = (selfSize.height - maxHeight) / 2;
            }
            else if (mgvert == TGGravity.vert.bottom)
            {
                addYPos = selfSize.height - maxHeight;
            }
            
            if (addYPos != 0)
            {
                for i in 0 ..< sbs.count
                {
                    sbs[i].tgFrame.top += addYPos
                }
            }
            
        }
        
        return selfSize;
    }
    
    fileprivate func tgLayoutSubviewsForHorz(_ selfSize:CGSize, sbs:[UIView]) ->CGSize
    {
        
        let padding = self.tg_padding
        var selfSize = selfSize
        
        var hasBoundaryLimit = true
        if (self.tg_height.isWrap && self.tg_noBoundaryLimit)
        {
            hasBoundaryLimit = false
        }
        
        if !hasBoundaryLimit
        {
            selfSize.height = CGFloat.greatestFiniteMagnitude
        }
        
        //遍历所有的子视图，查看是否有子视图的宽度会比视图自身要宽，如果有且有包裹属性则扩充自身的宽度
        if (self.tg_height.isWrap && hasBoundaryLimit)
        {
            var maxContentHeight = selfSize.height - padding.top - padding.bottom;
            for sbv in sbs
            {
                let topMargin = sbv.tg_top.margin;
                let bottomMargin = sbv.tg_bottom.margin;
                var rect = sbv.tgFrame.frame;
                
                
                //这里有可能设置了固定的高度
                if (sbv.tg_height.dimeNumVal != nil)
                {
                    rect.size.height = sbv.tg_height.measure;
                }
                
                rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                
                //有可能高度是和他的宽度相等。
                if (sbv.tg_height.dimeRelaVal === sbv.tg_width)
                {
                    
                    if (sbv.tg_width.dimeNumVal != nil)
                    {
                        rect.size.width = sbv.tg_width.measure;
                    }
                    
                    if (sbv.tg_width.dimeRelaVal === self.tg_width)
                    {
                        rect.size.width = sbv.tg_width.measure(selfSize.width - padding.left - padding.right)
                    }
                    
                    rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    
                    rect.size.height = sbv.tg_height.measure(rect.size.width)
                }
                
                if (sbv.tg_height.isFlexHeight)
                {
                    
                    rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                }
                
                rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                
                if (topMargin + rect.size.height + bottomMargin > maxContentHeight &&
                    sbv.tg_height.dimeRelaVal !== self.tg_height &&
                    sbv.tg_height.dimeWeightVal == nil &&
                    !sbv.tg_height.isFill)
                {
                    maxContentHeight = topMargin + rect.size.height + bottomMargin;
                }
            }
            
            selfSize.height = padding.top + maxContentHeight + padding.bottom;
        }
        
        
        //支持浮动垂直间距。
        let horzSpace = self.tg_hspace
        var vertSpace = self.tg_vspace
        var subviewSize = (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClassImpl).tgSubviewSize;
        if (subviewSize != 0)
        {
            #if DEBUG
                //异常崩溃：当布局视图设置了tg_noBoundaryLimit为true时，不能设置最小垂直间距。
                assert(hasBoundaryLimit, "Constraint exception！！, horizontal float layout:\(self) can not set tg_noBoundaryLimit to true when call  tg_setSubviews(size:CGFloat,minSpace:CGFloat,maxSpace:CGFloat)  method");
            #endif
            
            let minSpace = (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClassImpl).tgMinSpace
            let maxSpace = (self.tgCurrentSizeClass as! TGFloatLayoutViewSizeClassImpl).tgMaxSpace

            let rowCount =  floor((selfSize.height - padding.top - padding.bottom  + minSpace) / (subviewSize + minSpace))
            if (rowCount > 1)
            {
                vertSpace = (selfSize.height - padding.top - padding.bottom - subviewSize * rowCount)/(rowCount - 1)
                
                if (vertSpace > maxSpace)
                {
                    vertSpace = maxSpace
                    
                    subviewSize =  (selfSize.height - padding.top - padding.bottom -  vertSpace * (rowCount - 1)) / rowCount
                    
                }

            }
        }
        
        
        //上边候选区域数组，保存的是CGRect值。
        var topCandidateRects:[CGRect] = [CGRect]()
        
        //为了计算方便总是把最上边的个虚拟区域作为一个候选区域
        topCandidateRects.append(CGRect(x: padding.left, y: padding.top,width: CGFloat.greatestFiniteMagnitude,height: 0))
        
        //右边候选区域数组，保存的是CGRect值。
        var bottomCandidateRects:[CGRect] = [CGRect]()
        //为了计算方便总是把最下边的个虚拟区域作为一个候选区域
        bottomCandidateRects.append(CGRect(x: padding.left, y: selfSize.height - padding.bottom,width: CGFloat.greatestFiniteMagnitude, height: 0))
        
        //分别记录上边和下边的最后一个视图在X轴的偏移量
        var topLastXOffset = padding.left;
        var bottomLastXOffset = padding.left;
        
        //分别记录上下边和全局浮动视图的最宽占用的X轴的值
        var topMaxWidth = padding.left
        var bottomMaxWidth = padding.left
        var maxWidth = padding.left
        var maxHeight = padding.top
        
        for sbv in sbs
        {
            let  topMargin = sbv.tg_top.margin;
            let leftMargin = sbv.tg_left.margin;
            let bottomMargin = sbv.tg_bottom.margin;
            let rightMargin = sbv.tg_right.margin;
            var rect = sbv.tgFrame.frame;
            let isHeightWeight = sbv.tg_height.dimeWeightVal != nil || sbv.tg_height.isFill
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill
            
            
            if (sbv.tg_width.dimeNumVal != nil)
            {
                rect.size.width = sbv.tg_width.measure;
            }
            
            if subviewSize != 0
            {
                rect.size.height = subviewSize
            }
            
            if (sbv.tg_height.dimeNumVal != nil)
            {
                rect.size.height = sbv.tg_height.measure;
            }
            
            if (sbv.tg_height.dimeRelaVal === self.tg_height)
            {
                rect.size.height = sbv.tg_height.measure(selfSize.height - padding.top - padding.bottom)
            }
            
            if (sbv.tg_width.dimeRelaVal === self.tg_width && !self.tg_width.isWrap)
            {
                rect.size.width = sbv.tg_width.measure(selfSize.width - padding.left - padding.right)
            }
            
            if isWidthWeight && !self.tg_width.isWrap
            {
                rect.size.width = sbv.tg_width.measure((selfSize.width - maxWidth - padding.right) * (sbv.tg_width.isFill ? 1.0 : sbv.tg_width.dimeWeightVal.rawValue/100) - leftMargin - rightMargin)

            }
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tg_height.dimeRelaVal === sbv.tg_width)
            {
                rect.size.height = sbv.tg_height.measure(rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tg_width.dimeRelaVal === sbv.tg_height)
            {
                rect.size.width = sbv.tg_width.measure(rect.size.height)
            }
            
            if (sbv.tg_width.dimeRelaVal != nil &&  sbv.tg_width.dimeRelaVal.view != nil &&  sbv.tg_width.dimeRelaVal.view != self && sbv.tg_width.dimeRelaVal.view != sbv)
            {
                rect.size.width = sbv.tg_width.measure(sbv.tg_width.dimeRelaVal.view.tgFrame.width)
            }
            
            if (sbv.tg_height.dimeRelaVal != nil &&  sbv.tg_height.dimeRelaVal.view != nil &&  sbv.tg_height.dimeRelaVal.view != self && sbv.tg_height.dimeRelaVal.view != sbv)
            {
                rect.size.height = sbv.tg_height.measure(sbv.tg_height.dimeRelaVal.view.tgFrame.height)
            }
            
            
            //如果高度是浮动的则需要调整高度。
            if (sbv.tg_height.isFlexHeight)
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tg_reverseFloat)
            {
                #if DEBUG
                    //异常崩溃：当布局视图设置了tg_noBoundaryLimit为true时子视图不能设置逆向浮动
                    assert(hasBoundaryLimit, "Constraint exception！！, horizontal float layout:\(self) can not set tg_noBoundaryLimit to true when the subview:\(sbv) set tg_reverseFloat to true.")
                #endif
                
                var nextPoint = CGPoint(x: topLastXOffset, y: selfSize.height - padding.bottom)
                var topCandidateYBoundary = padding.top;
                if (sbv.tg_clearFloat)
                {
                    //找到最底部的位置。
                    nextPoint.x = max(bottomMaxWidth, topLastXOffset);
                    let topPoint = self.tgFindTopCandidatePoint(CGRect(x: nextPoint.x, y: selfSize.height - padding.bottom, width: CGFloat.greatestFiniteMagnitude, height: 0), height:topMargin + (isHeightWeight ? 0 : rect.size.height) + bottomMargin,topBoundary:topCandidateYBoundary,topCandidateRects:topCandidateRects,hasWeight:false)
                    if (topPoint.x != CGFloat.greatestFiniteMagnitude)
                    {
                        nextPoint.x = max(bottomMaxWidth, topPoint.x);
                        topCandidateYBoundary = topPoint.y;
                    }
                }
                else
                {
                    //依次从后往前，每个都比较右边的。
                    var i = bottomCandidateRects.count - 1
                    while i >= 0
                    {
                        let candidateRect = bottomCandidateRects[i]
                        let topPoint = self.tgFindTopCandidatePoint(candidateRect,height:topMargin + (isHeightWeight ? 0 : rect.size.height) + bottomMargin,topBoundary:padding.top,topCandidateRects:topCandidateRects,hasWeight:isHeightWeight)
                        if (topPoint.x != CGFloat.greatestFiniteMagnitude)
                        {
                            nextPoint = CGPoint(x: max(nextPoint.x, topPoint.x),y: candidateRect.minY);
                            topCandidateYBoundary = topPoint.y;
                            break;
                        }
                        
                        nextPoint.x = candidateRect.maxX;
                        i -= 1
                    }
                }
                
                if isHeightWeight
                {
                    
                    var heightWeight:CGFloat = 1.0
                    if sbv.tg_height.dimeWeightVal != nil
                    {
                        heightWeight = sbv.tg_height.dimeWeightVal.rawValue/100
                    }
                    
                    rect.size.height =  self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: (nextPoint.y - topCandidateYBoundary + sbv.tg_height.addVal) * heightWeight - topMargin - bottomMargin, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    if (sbv.tg_width.dimeRelaVal === sbv.tg_height)
                    {
                        rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure(rect.size.height), sbvSize: rect.size, selfLayoutSize: selfSize)
                    }
                    
                }
                
                
                rect.origin.y = nextPoint.y - bottomMargin - rect.size.height;
                rect.origin.x = min(nextPoint.x, maxWidth) + leftMargin;
                
                //如果有智能边界线则找出所有智能边界线。
                if (self.tg_intelligentBorderline != nil)
                {
                    //优先绘制左边和上边的。绘制左边的和上边的。
                    if let sbvl = sbv as? TGBaseLayout
                    {
                        
                        if (!sbvl.tg_notUseIntelligentBorderline)
                        {
                            sbvl.tg_bottomBorderline = nil;
                            sbvl.tg_topBorderline = nil;
                            sbvl.tg_rightBorderline = nil;
                            sbvl.tg_leftBorderline = nil;
                            
                            //如果自己的上边和左边有子视图。
                            if (rect.origin.x + rect.size.width + rightMargin < selfSize.width - padding.right)
                            {
                                sbvl.tg_rightBorderline = self.tg_intelligentBorderline;
                            }
                            
                            if (rect.origin.y + rect.size.height + bottomMargin < selfSize.height - padding.bottom)
                            {
                                sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                            }
                            
                            if (rect.origin.y > topCandidateYBoundary && sbvl == sbs.last)
                            {
                                sbvl.tg_topBorderline = self.tg_intelligentBorderline;
                            }
                        }
                        
                    }
                }
                
                
                //这里有可能子视图本身的宽度会超过布局视图本身，但是我们的候选区域则不存储超过的宽度部分。
                let cRect = CGRect(x: rect.origin.x - leftMargin, y: max(rect.origin.y - topMargin - vertSpace, padding.top), width: rect.size.width + leftMargin + rightMargin + horzSpace, height: min((rect.size.height + topMargin + bottomMargin),(selfSize.height - padding.top - padding.bottom)));
                
                //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
                bottomCandidateRects = bottomCandidateRects.filter({$0.maxX > cRect.maxX})
                
                //删除顶部宽度小于新添加区域的顶部的候选区域
                topCandidateRects = topCandidateRects.filter({$0.maxX > cRect.minX})
                
                bottomCandidateRects.append(cRect)
                bottomLastXOffset = rect.origin.x - leftMargin;
                
                if (rect.origin.x + rect.size.width + rightMargin + horzSpace > bottomMaxWidth)
                {
                    bottomMaxWidth = rect.origin.x + rect.size.width + rightMargin + horzSpace;
                }
            }
            else
            {
                var nextPoint = CGPoint(x: bottomLastXOffset,y: padding.top);
                var bottomCandidateYBoundary = selfSize.height - padding.bottom;
                //如果是清除了浮动则直换行移动到最下面。
                if (sbv.tg_clearFloat)
                {
                    //找到最低点。
                    nextPoint.x = max(topMaxWidth, bottomLastXOffset);
                    
                    let bottomPoint = self.tgFindBottomCandidatePoint(CGRect(x: nextPoint.x, y: padding.top,width: CGFloat.greatestFiniteMagnitude,height: 0),height:topMargin + (isHeightWeight ? 0: rect.size.height) + bottomMargin,bottomBoundary:bottomCandidateYBoundary,bottomCandidateRects:bottomCandidateRects,hasWeight:false)
                    if (bottomPoint.x != CGFloat.greatestFiniteMagnitude)
                    {
                        nextPoint.x = max(topMaxWidth, bottomPoint.x);
                        bottomCandidateYBoundary = bottomPoint.y;
                    }
                }
                else
                {
                    
                    //依次从后往前，每个都比较右边的。
                    var i = topCandidateRects.count - 1
                    while i >= 0
                    {
                        let candidateRect = topCandidateRects[i]
                        let bottomPoint = self.tgFindBottomCandidatePoint(candidateRect,height:topMargin + (isHeightWeight ? 0: rect.size.height) + bottomMargin, bottomBoundary:selfSize.height - padding.bottom,bottomCandidateRects:bottomCandidateRects, hasWeight:isHeightWeight);
                        if (bottomPoint.x != CGFloat.greatestFiniteMagnitude)
                        {
                            nextPoint = CGPoint(x: max(nextPoint.x, bottomPoint.x),y: candidateRect.maxY);
                            bottomCandidateYBoundary = bottomPoint.y;
                            break;
                        }
                        
                        nextPoint.x = candidateRect.maxX;
                        i -= 1
                    }
                }
                
                if isHeightWeight
                {
                    #if DEBUG
                        //异常崩溃：当布局视图设置了noBoundaryLimit为YES时子视图不能设置weight大于0
                        assert(hasBoundaryLimit, "Constraint exception！！, horizontal float layout:\(self) can not set tg_noBoundaryLimit to true when the subview:\(sbv) set tg_height to TGWeight type value.")
                    #endif
                    
                    
                    var heightWeight:CGFloat = 1.0
                    if sbv.tg_height.dimeWeightVal != nil
                    {
                        heightWeight = sbv.tg_height.dimeWeightVal.rawValue/100
                    }
                    
                    rect.size.height =  self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: (bottomCandidateYBoundary - nextPoint.y + sbv.tg_height.addVal) * heightWeight - topMargin - bottomMargin, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    if (sbv.tg_width.dimeRelaVal === sbv.tg_height)
                    {
                        rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: sbv.tg_width.measure(rect.size.height), sbvSize: rect.size, selfLayoutSize: selfSize)
                    }
                    
                    
                }
                
                rect.origin.y = nextPoint.y + topMargin;
                rect.origin.x = min(nextPoint.x,maxWidth) + leftMargin;
                
                //如果有智能边界线则找出所有智能边界线。
                if (self.tg_intelligentBorderline != nil)
                {
                    //优先绘制左边和上边的。绘制左边的和上边的。
                    if let sbvl = sbv as? TGBaseLayout
                    {
                        if (!sbvl.tg_notUseIntelligentBorderline)
                        {
                            sbvl.tg_bottomBorderline = nil;
                            sbvl.tg_topBorderline = nil;
                            sbvl.tg_rightBorderline = nil;
                            sbvl.tg_leftBorderline = nil;
                            
                            //如果自己的上边和左边有子视图。
                            if (rect.origin.x - leftMargin > padding.left)
                            {
                                sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                            }
                            
                            if (rect.origin.y - topMargin > padding.top)
                            {
                                sbvl.tg_topBorderline = self.tg_intelligentBorderline;
                            }
                        }
                        
                    }
                }
                
                
                let cRect = CGRect(x: rect.origin.x - leftMargin, y: rect.origin.y - topMargin,width: rect.size.width + leftMargin + rightMargin + horzSpace,height: min((rect.size.height + topMargin + bottomMargin + vertSpace),(selfSize.height - padding.top - padding.bottom)));
                
                
                //把新添加到候选中去。并删除宽度小于的最新候选区域的候选区域
                topCandidateRects = topCandidateRects.filter({$0.maxX > cRect.maxX})
                
                //删除顶部宽度小于新添加区域的顶部的候选区域
                bottomCandidateRects = bottomCandidateRects.filter({$0.maxX > cRect.minX})
                
                topCandidateRects.append(cRect)
                topLastXOffset = rect.origin.x - leftMargin;
                
                if (rect.origin.x + rect.size.width + rightMargin + horzSpace > topMaxWidth)
                {
                    topMaxWidth = rect.origin.x + rect.size.width + rightMargin + horzSpace;
                }
                
            }
            
            if rect.origin.y + rect.size.height + bottomMargin + vertSpace > maxHeight
            {
                maxHeight = rect.origin.y + rect.size.height + bottomMargin + vertSpace;
            }
            
            if rect.origin.x + rect.size.width + rightMargin + horzSpace > maxWidth
            {
                maxWidth = rect.origin.x + rect.size.width + rightMargin + horzSpace
            }

            
            
            
            sbv.tgFrame.frame = rect;
            
        }
        
        if (sbs.count > 0)
        {
            maxWidth -= horzSpace
            maxHeight -= vertSpace
        }
        
        maxWidth += padding.right;
        maxHeight += padding.bottom;
        
        if !hasBoundaryLimit
        {
            selfSize.height = maxHeight
        }
        
        if (self.tg_width.isWrap)
        {
            selfSize.width = maxWidth;
        }
        else
        {
            var addXPos:CGFloat = 0;
            let  mghorz = self.tg_gravity & TGGravity.vert.mask;
            if (mghorz == TGGravity.horz.center)
            {
                addXPos = (selfSize.width - maxWidth) / 2;
            }
            else if (mghorz == TGGravity.horz.right)
            {
                addXPos = selfSize.width - maxWidth;
            }
            
            if (addXPos != 0)
            {
                for i in 0 ..< sbs.count
                {
                    sbs[i].tgFrame.left += addXPos
                    
                }
            }
            
        }
        
        
        return selfSize;
    }
    
    
}
