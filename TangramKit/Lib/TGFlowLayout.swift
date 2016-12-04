//
//  TGFlowLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 *流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一行再重新排列的多行多列展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，而换行的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。
 1.垂直数量约束流式布局
 tg_orientation为.vert,tg_arrangedCount不为0,不支持tg_autoArrange。
 
 2.垂直内容约束流式布局.
 tg_orientation为.vert,tg_arrangedCount为0,支持tg_autoArrange。
 
 
 3.水平数量约束流式布局。
 tg_orientation为.horz,tg_arrangedCount不为0,不支持tg_autoArrange。
 
 4.水平内容约束流式布局
 tg_orientation为.horz,tg_arrangedCount为0,支持tg_autoArrange。
 
 流式布局支持子视图的宽度依赖于高度或者高度依赖于宽度,以及高度或者宽度依赖于流式布局本身的高度或者宽度
 */
open class TGFlowLayout:TGBaseLayout,TGFlowLayoutViewSizeClass {
    
    /**
     *初始化一个流式布局并指定布局的方向和布局的数量,如果数量为0则表示内容约束流式布局
     */
    public init(_ orientation:TGOrientation = .vert, arrangedCount:Int = 0) {
        
        super.init(frame:CGRect.zero)
        
        (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_orientation = orientation
        (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_arrangedCount = arrangedCount
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     *流式布局的方向：
     *如果是.vert则表示从左到右，从上到下的垂直布局方式，这个方式是默认方式。
     *如果是.horz则表示从上到下，从左到右的水平布局方式
     */
    public var tg_orientation:TGOrientation {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_orientation
        }
        set {
            (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_orientation = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *指定方向上的子视图的数量，默认是0表示为内容约束流式布局，当数量不为0时则是数量约束流式布局。当值为0时则表示当子视图在方向上的尺寸超过布局视图时则会新起一行或者一列。而如果数量不为0时则：
     如果方向为.vert，则表示从左到右的数量，当子视图从左往右满足这个数量后新的子视图将会换行再排列
     如果方向为.horz，则表示从上到下的数量，当子视图从上往下满足这个数量后新的子视图将会换列再排列
     */
    public var tg_arrangedCount:Int {   //get/set方法
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_arrangedCount
        }
        set {
            (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_arrangedCount = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *子视图自动排列,这个属性只有在内容填充约束流式布局下才有用,默认为false.当设置为YES时则根据子视图的内容自动填充，而不是根据加入的顺序来填充，以便保证不会出现多余空隙的情况。
     *请在将所有子视图添加完毕并且初始布局完成后再设置这个属性，否则如果预先设置这个属性则在后续添加子视图时非常耗性能。
     */
    public var tg_autoArrange:Bool
        {
        get
        {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_autoArrange
        }
        set
        {
            (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_autoArrange = newValue
            setNeedsLayout()
        }
    }
    
    
    /**
     *流式布局内所有子视图的整体停靠对齐位置设定。
     *MyMarginGravity_Vert_Top,MyMarginGravity_Vert_Center,MyMarginGravity_Vert_Bottom 表示整体垂直居上，居中，居下
     *MyMarginGravity_Horz_Left,MyMarginGravity_Horz_Center,MyMarginGravity_Horz_Right 表示整体水平居左，居中，居右
     *MyMarginGravity_Vert_Between 表示在流式布局里面，每行之间的行间距都被拉伸，以便使里面的子视图垂直方向填充满整个布局视图。
     *MyMarginGravity_Horz_Between 表示在流式布局里面，每列之间的列间距都被拉伸，以便使里面的子视图水平方向填充满整个布局视图。
     *MyMarginGravity_Vert_Fill 在垂直流式布局里面表示布局会拉伸每行子视图的高度，以便使里面的子视图垂直方向填充满整个布局视图的高度；在水平数量流式布局里面表示每列的高度都相等并且填充满整个布局视图的高度；在水平内容约束布局里面表示布局会自动拉升每列的高度，以便垂直方向填充满布局视图的高度(这种设置方法代替过期的方法：averageArrange)。
     *MyMarginGravity_Horz_Fill 在水平流式布局里面表示布局会拉伸每行子视图的宽度，以便使里面的子视图水平方向填充满整个布局视图的宽度；在垂直数量流式布局里面表示每行的宽度都相等并且填充满整个布局视图的宽度；在垂直内容约束布局里面表示布局会自动拉升每行的宽度，以便水平方向填充满布局视图的宽度(这种设置方法代替过期的方法：averageArrange)。
     */
    public var tg_gravity:TGGravity {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_gravity
        }
        set {
            (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_gravity = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *流式布局中每排子视图的停靠对齐位置设定。
     如果是.vert则只用于表示每行子视图的上中下停靠对齐位置，这个属性只支持TGGravity.vert.top，TGGravity.vert.center,TGGravity.vert.bottom,TGGravity.vert.fill这里的对齐基础是以每行中的最高的子视图为基准。
     如果是.horz则只用于表示每列子视图的左中右停靠对齐位置，这个属性只支持TGGravity.horz.left，TGGravity.horz.center,TGGravity.horz.right,TGGravity.horz.fill这里的对齐基础是以每列中的最宽的子视图为基准。
     */
    public var tg_arrangedGravity:TGGravity {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_arrangedGravity
        }
        set {
            (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_arrangedGravity = newValue
            setNeedsLayout()
        }
    }
    
    
    /**
     *在内容约束流式布局的一些应用场景中我们有时候希望某些子视图的宽度是固定的情况下，子视图的间距是浮动的而不是固定的，这样就可以尽可能的容纳更多的子视图。比如每个子视图的宽度是固定80，那么在小屏幕下每行只能放3个，而我们希望大屏幕每行能放4个或者5个子视图。 因此您可以通过如下方法来设置浮动间距，这个方法会根据您当前布局的orientation方向不同而意义不同：
     1.如果您的布局方向是.vert表示设置的是子视图的水平间距，其中的size指定的是子视图的宽度，minSpace指定的是最小的水平间距,maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的宽度。
     2.如果您的布局方向是.horz表示设置的是子视图的垂直间距，其中的size指定的是子视图的高度，minSpace指定的是最小的垂直间距,maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的高度。
     3.如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
     4.这个方法只在内容约束流式布局里面设置才有意义。
     */
    public func tg_setSubviews(size:CGFloat, minSpace:CGFloat, maxSpace:CGFloat = .greatestFiniteMagnitude, inSizeClass type:TGSizeClassType = .default)
    {
        let sc = self.tg_fetchSizeClass(with: type) as! TGFlowLayoutViewSizeClassImpl
        sc.tgSubviewSize = size
        sc.tgMinSpace = minSpace
        sc.tgMaxSpace = maxSpace
        
        self.setNeedsLayout()
    }

    
    
    
    override internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, type:TGSizeClassType) ->(selfSize:CGSize, hasSubLayout:Bool) {
        var (selfSize, hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate: isEstimate, type: type)
        
        var sbs = self.tgGetLayoutSubviews()
        
        for sbv:UIView in sbs {
            
            
            if !isEstimate {
                sbv.tgFrame.frame = sbv.bounds
                
                self.tgCalcSizeFromSizeWrapSubview(sbv)
            }
            
            if let sbvl:TGBaseLayout = sbv as? TGBaseLayout
            {
                hasSubLayout = true
                
                if (sbvl.tg_width.isWrap)
                {
                    if ((self.tg_orientation == .horz && (self.tg_arrangedGravity & TGGravity.vert.mask) == TGGravity.horz.fill) ||
                        (self.tg_orientation == .vert && ((self.tg_gravity & TGGravity.vert.mask) == TGGravity.horz.fill)))
                    {
                        sbvl.tg_width._dimeVal = nil
                    }
                }
                
                if (sbvl.tg_height.isWrap)
                {
                    if ((self.tg_orientation == .vert && (self.tg_arrangedGravity & TGGravity.horz.mask) == TGGravity.vert.fill) ||
                        (self.tg_orientation == .horz && ((self.tg_gravity & TGGravity.horz.mask) == TGGravity.vert.fill)))
                    {
                        sbvl.tg_height._dimeVal = nil
                    }
                }
                
                
                
                if (isEstimate)
                {
                    _ = sbvl.tg_sizeThatFits(sbvl.tgFrame.frame.size,inSizeClass:type)
                    sbvl.tgFrame.sizeClass = sbvl.tgMatchBestSizeClass(type) //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                }
            }
        }
        
        if self.tg_orientation == .vert {
            if self.tg_arrangedCount == 0 {
                
                
                if (self.tg_autoArrange)
                {
                    //计算出每个子视图的宽度。
                    for sbv in sbs
                    {
                        let leftMargin = sbv.tg_left.margin;
                        let rightMargin = sbv.tg_right.margin;
                        var rect = sbv.tgFrame.frame;
                        
                        if (sbv.tg_width.dimeNumVal != nil)
                        {
                            rect.size.width = sbv.tg_width.measure;
                        }
                        
                        
                        if (sbv.tg_width.dimeRelaVal === self.tg_width && !self.tg_width.isWrap)
                        {
                            rect.size.width = sbv.tg_width.measure(selfSize.width - self.tg_padding.left - self.tg_padding.right)
                        }
                        
                        rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                        //暂时把宽度存放sbv.tgFrame.right上。因为浮动布局来说这个属性无用。
                        sbv.tgFrame.right = leftMargin + rect.size.width + rightMargin;
                        if (sbv.tgFrame.right > selfSize.width - self.tg_leftPadding - self.tg_rightPadding)
                        {
                            sbv.tgFrame.right = selfSize.width - self.tg_leftPadding - self.tg_rightPadding;
                        }
                    }
                    
                    let tempSbs:NSMutableArray = NSMutableArray(array: sbs)
                    sbs = self.tgGetAutoArrangeSubviews(tempSbs, selfSize:selfSize.width - self.tg_leftPadding - self.tg_rightPadding, margin: self.tg_hspace) as! [UIView]
                    
                }
                
                
                
                selfSize = self.tgLayoutSubviewsForVertContent(selfSize, sbs: sbs)
            }
            else {
                selfSize = self.tgLayoutSubviewsForVert(selfSize, sbs: sbs)
            }
        }
        else {
            if self.tg_arrangedCount == 0 {
                
                
                if (self.tg_autoArrange)
                {
                    //计算出每个子视图的宽度。
                    for sbv in sbs
                    {
                        
                        let topMargin = sbv.tg_top.margin;
                        let bottomMargin = sbv.tg_bottom.margin;
                        var rect = sbv.tgFrame.frame;
                        
                        if (sbv.tg_width.dimeNumVal != nil)
                        {
                            rect.size.width = sbv.tg_width.measure;
                        }
                        
                        if (sbv.tg_height.dimeNumVal != nil)
                        {
                            rect.size.height = sbv.tg_height.measure;
                        }
                        
                        if (sbv.tg_width.dimeRelaVal === self.tg_width && !self.tg_width.isWrap)
                        {
                            rect.size.width = sbv.tg_width.measure(selfSize.width - self.tg_padding.left - self.tg_padding.right)
                        }
                        
                        if (sbv.tg_height.dimeRelaVal === self.tg_height && !self.tg_height.isWrap)
                        {
                            rect.size.height = sbv.tg_height.measure(selfSize.height - self.tg_padding.top - self.tg_padding.bottom)
                        }
                        
                        rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                        if (sbv.tg_width.dimeRelaVal === sbv.tg_height)
                        {
                            rect.size.width = sbv.tg_width.measure(rect.size.height)
                        }
                        
                        
                        rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                        //如果高度是浮动的则需要调整高度。
                        if (sbv.tg_height.isFlexHeight)
                        {
                            rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                            
                            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                        }
                        
                        
                        //暂时把宽度存放sbv.tgFrame.right上。因为浮动布局来说这个属性无用。
                        sbv.tgFrame.right = topMargin + rect.size.height + bottomMargin;
                        if (sbv.tgFrame.right > selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
                        {
                            sbv.tgFrame.right = selfSize.height - self.tg_topPadding - self.tg_bottomPadding;
                        }
                    }
                    
                    let tempSbs:NSMutableArray = NSMutableArray(array: sbs)
                    sbs = self.tgGetAutoArrangeSubviews(tempSbs, selfSize:selfSize.height - self.tg_topPadding - self.tg_bottomPadding, margin: self.tg_vspace) as! [UIView]
                }
                
                
                
                selfSize = self.tgLayoutSubviewsForHorzContent(selfSize, sbs: sbs)
            }
            else {
                selfSize = self.tgLayoutSubviewsForHorz(selfSize, sbs: sbs)
            }
        }
        selfSize.height = self.tgValidMeasure(self.tg_height,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.tgValidMeasure(self.tg_width,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        return (selfSize,hasSubLayout)
    }
    
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGFlowLayoutViewSizeClassImpl()
    }

}

extension TGFlowLayout
{
    fileprivate  func tgCalcSingleLineSize(_ sbs:NSArray, margin:CGFloat) ->CGFloat
    {
        var size:CGFloat = 0;
        
        for i in 0..<sbs.count
        {
            let sbv = sbs[i] as! UIView
            
            size += sbv.tgFrame.right;
            if (sbv != sbs.lastObject as! UIView)
            {
                size += margin
            }
        }
        
        return size;
    }
    
    
    fileprivate func tgGetAutoArrangeSubviews(_ sbs:NSMutableArray, selfSize:CGFloat, margin:CGFloat) ->NSArray
    {
        
        let retArray:NSMutableArray = NSMutableArray(capacity: sbs.count)
        
        let bestSingleLineArray:NSMutableArray = NSMutableArray(capacity: sbs.count / 2)
        
        while (sbs.count > 0)
        {
            
            self.tgGetAutoArrangeSingleLineSubviews(sbs,
                                                   index:0,
                                                   calcArray:NSArray(),
                                                   selfSize:selfSize,
                                                   margin:margin,
                                                   bestSingleLineArray:bestSingleLineArray)
            
            retArray.addObjects(from: bestSingleLineArray as [AnyObject])
            
            bestSingleLineArray.forEach({ (obj) -> () in
                
                sbs.remove(obj)
            })
            
            bestSingleLineArray.removeAllObjects()
        }
        
        return retArray;
    }
    
    fileprivate func tgGetAutoArrangeSingleLineSubviews(_ sbs:NSMutableArray,index:Int,calcArray:NSArray,selfSize:CGFloat,margin:CGFloat,bestSingleLineArray:NSMutableArray)
    {
        if (index >= sbs.count)
        {
            let s1 = self.tgCalcSingleLineSize(calcArray, margin:margin)
            let s2 = self.tgCalcSingleLineSize(bestSingleLineArray, margin:margin)
            if (fabs(selfSize - s1) < fabs(selfSize - s2) && /*s1 <= selfSize*/ _tgCGFloatLessOrEqual(s1, selfSize))
            {
                bestSingleLineArray.setArray(calcArray as [AnyObject])
            }
            
            return;
        }
        
        
        for  i in  index ..< sbs.count
        {
            
            
            let calcArray2 =  NSMutableArray(array: calcArray)
            calcArray2.add(sbs[i])
            
            let s1 = self.tgCalcSingleLineSize(calcArray2,margin:margin)
            if (/*s1 <= selfSize*/ _tgCGFloatLessOrEqual(s1, selfSize))
            {
                let s2 = self.tgCalcSingleLineSize(bestSingleLineArray,margin:margin)
                if (fabs(selfSize - s1) < fabs(selfSize - s2))
                {
                    bestSingleLineArray.setArray(calcArray2 as [AnyObject])
                }
                
                if (/*s1 == selfSize*/ _tgCGFloatEqual(s1, selfSize))
                {
                    break;
                }
                
                self.tgGetAutoArrangeSingleLineSubviews(sbs,
                                                       index:i + 1,
                                                       calcArray:calcArray2,
                                                       selfSize:selfSize,
                                                       margin:margin,
                                                       bestSingleLineArray:bestSingleLineArray)
                
            }
            else
            {
                break;
            }
            
        }
        
    }
    
    
    //计算Vert下每行Gravity对其方式
    fileprivate func tgCalcVertLayoutSingleLineGravity(_ selfSize:CGSize, rowMaxHeight:CGFloat, rowMaxWidth:CGFloat, mg:TGGravity, amg:TGGravity, sbs:[UIView], startIndex:Int, count:Int, vertSpace:CGFloat, horzSpace:CGFloat) {
        let padding:UIEdgeInsets = self.tg_padding
        var addXPos:CGFloat = 0
        var addXFill:CGFloat = 0
        
        let averageArrange = (mg == TGGravity.horz.fill)
        
        //处理 对其方式
        if !averageArrange || self.tg_arrangedCount == 0 {
            switch mg {
            case TGGravity.horz.center:
                addXPos = (selfSize.width - padding.left - padding.right - rowMaxWidth)/2
                break
            case TGGravity.horz.right:
                //不用考虑左边距，而原来的位置增加了左边距 因此不用考虑
                addXPos = selfSize.width - padding.left - padding.right - rowMaxWidth
                break
            case TGGravity.horz.between:
                //总宽减去最大的宽度，再除以数量表示每个应该扩展的空间，对最后一行无效
                if startIndex != sbs.count && count > 1 {
                    addXFill = (selfSize.width - padding.left - padding.right - rowMaxWidth)/(CGFloat(count) - 1)
                }
                break
            default:
                break
            }
            //处理内容拉伸的情况
            if self.tg_arrangedCount == 0 && averageArrange {
                if startIndex != sbs.count {
                    addXFill = (selfSize.width - padding.left - padding.right - rowMaxWidth)/CGFloat(count)
                }
            }
        }
        
        //调整 整行子控件的位置
        for j in startIndex - count ..< startIndex
        {
            let sbv:UIView = sbs[j]
            
            if self.tg_intelligentBorderline != nil
            {
                if let sbvl = sbv as? TGBaseLayout {
                    
                    if !sbvl.tg_notUseIntelligentBorderline {
                        sbvl.tg_leftBorderline = nil
                        sbvl.tg_topBorderline = nil
                        sbvl.tg_rightBorderline = nil
                        sbvl.tg_bottomBorderline = nil
                        
                        //如果不是最后一行就画下面，
                        if (startIndex != sbs.count)
                        {
                            sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果不是最后一列就画右边,
                        if (j < startIndex - 1)
                        {
                            sbvl.tg_rightBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果最后一行的最后一个没有满列数时
                        if (j == sbs.count - 1 && self.tg_arrangedCount != count )
                        {
                            sbvl.tg_rightBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果有垂直间距则不是第一行就画上
                        if (vertSpace != 0 && startIndex - count != 0)
                        {
                            sbvl.tg_topBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果有水平间距则不是第一列就画左
                        if (horzSpace != 0 && j != startIndex - count)
                        {
                            sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                        }
                        
                        
                    }
                }
            }
            
            if (amg != TGGravity.none && amg != TGGravity.vert.top) || /*addXPos != 0*/_tgCGFloatNotEqual(addXPos, 0)  || /*addXFill != 0*/ _tgCGFloatNotEqual(addXFill, 0)
            {
                sbv.tgFrame.left += addXPos
                
                if self.tg_arrangedCount == 0 && averageArrange {
                    //只拉伸宽度 不拉伸间距
                    sbv.tgFrame.width += addXFill
                    
                    if j != startIndex - count
                    {
                        sbv.tgFrame.left += addXFill * (CGFloat(j) - (CGFloat(startIndex) - CGFloat(count)))
                    }
                }
                else {
                    //只拉伸间距
                    sbv.tgFrame.left += addXFill * (CGFloat(j) - (CGFloat(startIndex) - CGFloat(count)))
                }
                
                switch amg {
                case TGGravity.vert.center:
                    sbv.tgFrame.top += (rowMaxHeight - sbv.tg_top.margin - sbv.tg_bottom.margin - sbv.tgFrame.height) / 2
                    break
                case TGGravity.vert.bottom:
                    sbv.tgFrame.top += rowMaxHeight - sbv.tg_top.margin - sbv.tg_bottom.margin - sbv.tgFrame.height
                    break
                case TGGravity.vert.fill:
                    sbv.tgFrame.height =  self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rowMaxHeight - sbv.tg_top.margin - sbv.tg_bottom.margin, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    break
                default:
                    break
                }
            }
        }
    }

    
    //计算Horz下每行Gravity对其方式
    fileprivate func tgCalcHorzLayoutSingleLineGravity(_ selfSize:CGSize, colMaxHeight:CGFloat, colMaxWidth:CGFloat, mg:TGGravity, amg:TGGravity, sbs:[UIView], startIndex:Int, count:Int, vertSpace:CGFloat, horzSpace:CGFloat) {
        var addYPos:CGFloat = 0
        var addYFill:CGFloat = 0
        let padding:UIEdgeInsets = self.tg_padding
        let averageArrange = (mg == TGGravity.vert.fill)
        
        if !averageArrange || self.tg_arrangedCount == 0 {
            switch mg {
            case TGGravity.vert.center:
                addYPos = (selfSize.height - padding.top - padding.bottom - colMaxHeight)/2
                break
            case TGGravity.vert.bottom:
                addYPos = selfSize.height - padding.top - padding.bottom - colMaxHeight
                break
            case TGGravity.vert.between:
                //总高减去最大高度，再除以数量表示每个应该扩展的空气，最后一列无效
                if startIndex != sbs.count && count > 1 {
                    addYFill = (selfSize.height - padding.top - padding.bottom - colMaxHeight)/(CGFloat(count) - 1)
                }
                break
            default:
                break
            }
            
            //处理内容拉伸的情况
            if self.tg_arrangedCount == 0 && averageArrange {
                if startIndex != sbs.count {
                    addYFill = (selfSize.height - padding.top - padding.bottom - colMaxHeight)/CGFloat(count)
                }
            }
        }
        
        //调整位置
        for j in startIndex - count ..< startIndex {
            let sbv:UIView = sbs[j]
            
            if self.tg_intelligentBorderline != nil {
                
                
                if let sbvl = sbv as? TGBaseLayout {
                    if !sbvl.tg_notUseIntelligentBorderline {
                        sbvl.tg_leftBorderline = nil
                        sbvl.tg_topBorderline = nil
                        sbvl.tg_rightBorderline = nil
                        sbvl.tg_bottomBorderline = nil
                        
                        //如果不是最后一行就画下面，
                        if (j < startIndex - 1)
                        {
                            sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果不是最后一列就画右边,
                        if (startIndex != sbs.count )
                        {
                            sbvl.tg_rightBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果最后一行的最后一个没有满列数时
                        if (j == sbs.count - 1 && self.tg_arrangedCount != count )
                        {
                            sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果有垂直间距则不是第一行就画上
                        if (vertSpace != 0 && j != startIndex - count)
                        {
                            sbvl.tg_topBorderline = self.tg_intelligentBorderline
                        }
                        
                        //如果有水平间距则不是第一列就画左
                        if (horzSpace != 0 && startIndex - count != 0  )
                        {
                            sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                        }
                        
                    }
                }
            }
            
            if (amg != TGGravity.none && amg != TGGravity.horz.left) || /*addYPos != 0*/ _tgCGFloatNotEqual(addYPos, 0) || /*addYFill != 0*/
               _tgCGFloatNotEqual(addYFill, 0) {
                sbv.tgFrame.top += addYPos
                
                if self.tg_arrangedCount == 0 && averageArrange {
                    //只拉伸宽度不拉伸间距
                    sbv.tgFrame.height += addYFill
                    
                    if j != startIndex - count {
                        sbv.tgFrame.top += addYFill * (CGFloat(j) - (CGFloat(startIndex) - CGFloat(count)))
                    }
                }
                else {
                    //只拉伸间距
                    sbv.tgFrame.top += addYFill * (CGFloat(j) - (CGFloat(startIndex) - CGFloat(count)))
                }
                
                switch amg {
                case TGGravity.horz.center:
                    sbv.tgFrame.left += (colMaxWidth - sbv.tg_left.margin - sbv.tg_right.margin - sbv.tgFrame.width)/2
                    break
                case TGGravity.horz.right:
                    sbv.tgFrame.left += colMaxWidth - sbv.tg_left.margin - sbv.tg_right.margin - sbv.tgFrame.width
                    break
                case TGGravity.horz.fill:
                    sbv.tgFrame.width =  self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: colMaxWidth - sbv.tg_left.margin - sbv.tg_right.margin, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    break
                default:
                    break
                }
                
            }
        }
    }
    
    
    fileprivate func tgCalcVertLayoutSingleLineWeight(selfSize:CGSize, totalFloatWidth:CGFloat, totalWeight:CGFloat,sbs:[UIView],startIndex:NSInteger, count:NSInteger)
    {
        for j in startIndex - count ..< startIndex {
            let sbv:UIView = sbs[j]
            
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill
            if isWidthWeight
            {
                var widthWeight:CGFloat = 1.0
                if sbv.tg_width.dimeWeightVal != nil
                {
                    widthWeight = sbv.tg_width.dimeWeightVal.rawValue/100
                }
                
                sbv.tgFrame.width =  self.tgValidMeasure(sbv.tg_width, sbv:sbv,calcSize:sbv.tg_width.measure(totalFloatWidth * widthWeight / totalWeight),sbvSize:sbv.tgFrame.frame.size,selfLayoutSize:selfSize)
                sbv.tgFrame.right = sbv.tgFrame.left + sbv.tgFrame.width;
            }
        }
    }
    
    fileprivate func tgCalcHorzLayoutSingleLineWeight(selfSize:CGSize, totalFloatHeight:CGFloat, totalWeight:CGFloat,sbs:[UIView],startIndex:NSInteger, count:NSInteger)
    {
        for j in startIndex - count ..< startIndex {
            let sbv:UIView = sbs[j]
            let isHeightWeight = sbv.tg_height.dimeWeightVal != nil || sbv.tg_height.isFill

            
            if isHeightWeight
            {
                var heightWeight:CGFloat = 1.0
                if sbv.tg_height.dimeWeightVal != nil
                {
                    heightWeight = sbv.tg_height.dimeWeightVal.rawValue / 100
                }
                
                sbv.tgFrame.height =  self.tgValidMeasure(sbv.tg_height,sbv:sbv,calcSize:sbv.tg_height.measure(totalFloatHeight * heightWeight / totalWeight),sbvSize:sbv.tgFrame.frame.size,selfLayoutSize:selfSize)
                sbv.tgFrame.bottom = sbv.tgFrame.top + sbv.tgFrame.height;
                
                if (sbv.tg_width.dimeRelaVal === sbv.tg_height)
                {
                    sbv.tgFrame.width = self.tgValidMeasure(sbv.tg_width,sbv:sbv,calcSize:sbv.tg_width.measure(sbv.tgFrame.height),sbvSize:sbv.tgFrame.frame.size,selfLayoutSize:selfSize)
                }
                
            }
        }
    }
    
    //arrangedCount = 0；orientation = vert
    fileprivate func tgLayoutSubviewsForVert(_ selfSize:CGSize, sbs:[UIView])->CGSize {
        var selfSize = selfSize
        let padding:UIEdgeInsets = self.tg_padding
        let arrangedCount:Int = self.tg_arrangedCount
        var xPos:CGFloat = padding.left
        var yPos:CGFloat = padding.top
        var rowMaxHeight:CGFloat = 0
        var rowMaxWidth:CGFloat = 0
        var maxWidth = padding.left
        
        let mgvert:TGGravity = self.tg_gravity & TGGravity.horz.mask
        let mghorz:TGGravity = self.tg_gravity & TGGravity.vert.mask
        let amgvert:TGGravity = self.tg_arrangedGravity & TGGravity.horz.mask
        
        let horzSpace = self.tg_hspace
        let vertSpace = self.tg_vspace
        
        let averageArrange = (mghorz == TGGravity.horz.fill)
        
        var arrangedIndex:Int = 0
        var rowTotalWeight:CGFloat = 0
        var rowTotalFixedWidth:CGFloat = 0
        
        for i in 0..<sbs.count
        {
            let sbv:UIView = sbs[i]
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill
            
            if (arrangedIndex >= arrangedCount)
            {
                arrangedIndex = 0;
                
                if (rowTotalWeight != 0 && !averageArrange)
                {
                    self.tgCalcVertLayoutSingleLineWeight(selfSize:selfSize,totalFloatWidth:selfSize.width - padding.left - padding.right - rowTotalFixedWidth,totalWeight:rowTotalWeight,sbs:sbs,startIndex:i,count:arrangedCount)
                }
                
                rowTotalWeight = 0;
                rowTotalFixedWidth = 0;
                
            }
            
            let  leftMargin = sbv.tg_left.margin
            let  rightMargin = sbv.tg_right.margin
            var  rect = sbv.tgFrame.frame
            
            
            if isWidthWeight
            {
                if sbv.tg_width.isFill
                {
                    rowTotalWeight += 1.0
                }
                else
                {
                    rowTotalWeight += sbv.tg_width.dimeWeightVal.rawValue / 100
                }
            }
            else
            {
                
                if (sbv.tg_width.dimeNumVal != nil && !averageArrange)
                {
                    rect.size.width = sbv.tg_width.measure;
                }
                
                if (sbv.tg_width.dimeRelaVal === self.tg_width && !self.tg_width.isWrap)
                {
                    rect.size.width = sbv.tg_width.measure(selfSize.width - padding.left - padding.right)
                }
                
                rect.size.width = self.tgValidMeasure(sbv.tg_width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
                
                rowTotalFixedWidth += rect.size.width;
            }
            
            rowTotalFixedWidth += leftMargin + rightMargin;
            
            if (arrangedIndex != (arrangedCount - 1))
            {
                rowTotalFixedWidth += horzSpace
            }
            
            sbv.tgFrame.frame = rect;
            
            arrangedIndex += 1
            
        }
        
        //最后一行。
        if (rowTotalWeight != 0 && !averageArrange)
        {
            //如果最后一行没有填满则应该减去一个间距的值。
            if arrangedIndex < arrangedCount
            {
                rowTotalFixedWidth -= horzSpace
            }
            
            self.tgCalcVertLayoutSingleLineWeight(selfSize:selfSize,totalFloatWidth:selfSize.width - padding.left - padding.right - rowTotalFixedWidth,totalWeight:rowTotalWeight,sbs:sbs,startIndex:sbs.count, count:arrangedIndex)
        }
        
        
        let averageWidth:CGFloat = (selfSize.width - padding.left - padding.right - (CGFloat(arrangedCount) - 1) * horzSpace) / CGFloat(arrangedCount)
        
        arrangedIndex = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            
            //换行
            if arrangedIndex >= arrangedCount {
                arrangedIndex = 0
                xPos = padding.left
                yPos += rowMaxHeight
                yPos += vertSpace
                
                //计算每行的gravity情况
                self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex: i, count: arrangedCount, vertSpace: vertSpace, horzSpace: horzSpace)
                
                rowMaxHeight = 0
                rowMaxWidth = 0
            }
            
            let topMargin = sbv.tg_top.margin
            let leftMargin = sbv.tg_left.margin
            let bottomMargin = sbv.tg_bottom.margin
            let rightMargin = sbv.tg_right.margin
            let isHeightWeight = sbv.tg_height.dimeWeightVal != nil || sbv.tg_height.isFill
            
            var rect = sbv.tgFrame.frame
            
            
            let isFlexedHeight:Bool = sbv.tg_height.isFlexHeight
            
            if sbv.tg_height.dimeNumVal != nil {
                rect.size.height = sbv.tg_height.measure
            }
            
            
            if averageArrange {
                rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: averageWidth - leftMargin - rightMargin, sbvSize: rect.size, selfLayoutSize:selfSize)
            }
            
            if sbv.tg_height.dimeRelaVal === self.tg_height && !self.tg_height.isWrap {
                rect.size.height = sbv.tg_height.measure(selfSize.height - padding.top - padding.bottom)
            }
            
            
            if sbv.tg_height.dimeRelaVal === sbv.tg_width {
                rect.size.height = sbv.tg_height.measure(rect.size.width)
            }
            
            //如果高度是浮动的 则需要调整陶都
            if isFlexedHeight {
                
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            if isHeightWeight
            {
                var heightWeight:CGFloat = 1.0
                if sbv.tg_height.dimeWeightVal != nil
                {
                    heightWeight = sbv.tg_height.dimeWeightVal.rawValue/100
                }
                
                rect.size.height = sbv.tg_height.measure((selfSize.height - yPos - padding.bottom)*heightWeight - topMargin - bottomMargin)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            rect.origin.x = (xPos + leftMargin)
            rect.origin.y = (yPos + topMargin)
            xPos += (leftMargin + rect.size.width + rightMargin)
            
            if arrangedIndex != (arrangedCount - 1) {
                xPos += horzSpace
            }
            
            if rowMaxHeight < (topMargin + bottomMargin + rect.size.height) {
                rowMaxHeight = (topMargin + bottomMargin + rect.size.height)
            }
            
            if rowMaxWidth < (xPos - padding.left) {
                rowMaxWidth = (xPos - padding.left)
            }
            if maxWidth < xPos {
                maxWidth = xPos
            }
            
            sbv.tgFrame.frame = rect
            arrangedIndex += 1
        }
        
        //最后一行 布局
        self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex: sbs.count, count: arrangedIndex,vertSpace: vertSpace, horzSpace: horzSpace)
        
        if self.tg_height.isWrap {
            selfSize.height = yPos + padding.bottom + rowMaxHeight
        }
        else {
            var addYPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            let arranges = floor(CGFloat(sbs.count + arrangedCount - 1) / CGFloat(arrangedCount))
            
            if mgvert == TGGravity.vert.center {
                addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos)/2
            }
            else if mgvert == TGGravity.vert.bottom {
                addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos
            }
            else if (mgvert == TGGravity.vert.fill)
            {
                if (arranges > 0)
                {
                   fill = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / arranges
                }
            }
            else if (mgvert == TGGravity.vert.between)
            {
                
                if (arranges > 1)
                {
                   between = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / (arranges - 1)
                }
            }
            

            
            if addYPos != 0 || between != 0 || fill != 0
            {
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    
                    let line = i / arrangedCount
                    
                    sbv.tgFrame.height += fill
                    sbv.tgFrame.top += fill * CGFloat(line)
                    sbv.tgFrame.top += addYPos
                    sbv.tgFrame.top += between * CGFloat(line)
                }
            }
        }
        
        if self.tg_width.isWrap && !averageArrange {
            selfSize.width = maxWidth + padding.right
        }
        return selfSize
    }

    fileprivate func tgLayoutSubviewsForVertContent(_ selfSize:CGSize, sbs:[UIView])->CGSize {
        
        var selfSize = selfSize
        let padding:UIEdgeInsets = self.tg_padding
        var xPos:CGFloat = padding.left
        var yPos:CGFloat = padding.top
        var rowMaxHeight:CGFloat = 0
        var rowMaxWidth:CGFloat = 0
        
        let mgvert:TGGravity = self.tg_gravity & TGGravity.horz.mask
        let mghorz:TGGravity = self.tg_gravity & TGGravity.vert.mask
        let amgvert:TGGravity = self.tg_arrangedGravity & TGGravity.horz.mask
        
        
        let vertSpace = self.tg_vspace
        var horzSpace = self.tg_hspace
        var subviewSize = (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClassImpl).tgSubviewSize
        if (subviewSize != 0)
        {
            
            let minSpace = (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClassImpl).tgMinSpace
            let maxSpace = (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClassImpl).tgMaxSpace

            
            let rowCount =  floor((selfSize.width - padding.left - padding.right  + minSpace) / (subviewSize + minSpace))
            if (rowCount > 1)
            {
                horzSpace = (selfSize.width - padding.left - padding.right - subviewSize * rowCount)/(rowCount - 1)
                
                if (horzSpace > maxSpace)
                {
                    horzSpace = maxSpace;
                    
                    subviewSize =  (selfSize.width - padding.left - padding.right -  horzSpace * (rowCount - 1)) / rowCount;
                    
                }
            }
        }

        var arrangeIndexSet = IndexSet()
        var arrangeIndex:Int = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            
            let topMargin:CGFloat = sbv.tg_top.margin
            let leftMargin:CGFloat = sbv.tg_left.margin
            let bottomMargin:CGFloat = sbv.tg_bottom.margin
            let rightMargin:CGFloat = sbv.tg_right.margin
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill
            let isHeightWeight = sbv.tg_height.dimeWeightVal != nil || sbv.tg_height.isFill
            var rect:CGRect = sbv.tgFrame.frame
            
            if subviewSize != 0
            {
                rect.size.width = subviewSize
            }
            
            if sbv.tg_width.dimeNumVal != nil {
                rect.size.width = sbv.tg_width.measure
            }
            if sbv.tg_height.dimeNumVal != nil {
                rect.size.height = sbv.tg_height.measure
            }
            if sbv.tg_width.dimeRelaVal === self.tg_width && !self.tg_width.isWrap {
                rect.size.width = sbv.tg_width.measure(selfSize.width - padding.left - padding.right)
            }
            if sbv.tg_height.dimeRelaVal === self.tg_height && !self.tg_height.isWrap {
                rect.size.height = sbv.tg_height.measure(selfSize.height - padding.top - padding.bottom)
            }
            
            if isHeightWeight
            {
                var heightWeight:CGFloat = 1.0
                if sbv.tg_height.dimeWeightVal != nil
                {
                    heightWeight = sbv.tg_height.dimeWeightVal.rawValue/100
                }
                
               rect.size.height = sbv.tg_height.measure((selfSize.height - yPos - padding.bottom)*heightWeight - topMargin - bottomMargin)
            }
            
            if isWidthWeight
            {
                //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
                var floatWidth = selfSize.width - padding.left - padding.right - rowMaxWidth;
                if /*floatWidth <= 0*/ _tgCGFloatLessOrEqual(floatWidth, 0)
                {
                    floatWidth += rowMaxWidth
                    arrangeIndex = 0
                }
                
                if (arrangeIndex != 0)
                {
                    floatWidth -= horzSpace
                }
                
                var widthWeight:CGFloat = 1.0
                if sbv.tg_width.dimeWeightVal != nil
                {
                    widthWeight = sbv.tg_width.dimeWeightVal.rawValue/100
                }
                
                rect.size.width = (floatWidth + sbv.tg_width.addVal) * widthWeight - leftMargin - rightMargin;
            }
            
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if sbv.tg_height.dimeRelaVal === sbv.tg_width {
                rect.size.height = sbv.tg_height.measure(rect.size.width)
            }
            
            //如果高度是浮动则需要调整
            if sbv.tg_height.isFlexHeight {
                
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算xPos的值加上leftMargin + rect.size.width + rightMargin + self.tg_hspace 的值要小于整体的宽度。
            var place:CGFloat = xPos + leftMargin + rect.size.width + rightMargin
            if arrangeIndex != 0 {
                place += horzSpace
            }
            place += padding.right
            
            //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
            if place - selfSize.width > 0.0001
            {
                xPos = padding.left
                yPos += vertSpace
                yPos += rowMaxHeight
                
                arrangeIndexSet.insert(i - arrangeIndex)
                //计算每行Gravity情况
                self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex: i, count: arrangeIndex, vertSpace: vertSpace, horzSpace: horzSpace)
                
                //计算单独的sbv的宽度是否大于整体的宽度。如果大于则缩小宽度。
                if leftMargin + rightMargin + rect.size.width > selfSize.width - padding.left - padding.right
                {
                    rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: selfSize.width - padding.left - padding.right - leftMargin - rightMargin, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    if sbv.tg_height.isFlexHeight {
                        rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                        rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                    }
                }
                
                rowMaxHeight = 0
                rowMaxWidth = 0
                arrangeIndex = 0
            }
            
            if arrangeIndex != 0 {
                xPos += horzSpace
            }
            
            rect.origin.x = xPos + leftMargin
            rect.origin.y = yPos + topMargin
            xPos += leftMargin + rect.size.width + rightMargin
            
            if rowMaxHeight < topMargin + bottomMargin + rect.size.height {
                rowMaxHeight = topMargin + bottomMargin + rect.size.height;
            }
            if rowMaxWidth < (xPos - padding.left) {
                rowMaxWidth = (xPos - padding.left);
            }
            
            sbv.tgFrame.frame = rect;
            arrangeIndex += 1
        }
        
        //设置最后一行
        arrangeIndexSet.insert(sbs.count - arrangeIndex)
        self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex:sbs.count, count: arrangeIndex, vertSpace: vertSpace, horzSpace: horzSpace)
        
        if self.tg_height.isWrap {
            selfSize.height = yPos + padding.bottom + rowMaxHeight;
        }
        else {
            var addYPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            
            if mgvert == TGGravity.vert.center {
                addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos)/2
            }
            else if mgvert == TGGravity.vert.bottom {
                addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos
            }
            else if mgvert == TGGravity.vert.fill {
            
                if arrangeIndexSet.count > 0
                {
                   fill = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / CGFloat(arrangeIndexSet.count)
                }
            }
            else if (mgvert == TGGravity.vert.between)
            {
                if arrangeIndexSet.count > 1
                {
                   between = (selfSize.height - padding.bottom - rowMaxHeight - yPos) / CGFloat(arrangeIndexSet.count - 1)
                }
            }
                
            
            if addYPos != 0 || between != 0  || fill != 0
            {
                var line:CGFloat = 0
                var lastIndex:Int = 0
                
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    sbv.tgFrame.top += addYPos
                    
                    let index = arrangeIndexSet.integerLessThanOrEqualTo(i)
                    if lastIndex != index
                    {
                        lastIndex = index!
                        line += 1
                    }
                    
                    sbv.tgFrame.height += fill
                    sbv.tgFrame.top += fill * line
                    sbv.tgFrame.top += between * line
                    
                }
            }
        }
        
        return selfSize
    }
    
    fileprivate func tgLayoutSubviewsForHorz(_ selfSize:CGSize, sbs:[UIView])->CGSize {
        
        let padding:UIEdgeInsets = self.tg_padding
        let arrangedCount:Int = self.tg_arrangedCount
        var xPos:CGFloat = padding.left
        var yPos:CGFloat = padding.top
        var colMaxWidth:CGFloat = 0
        var colMaxHeight:CGFloat = 0
        var maxHeight:CGFloat = padding.top
        var selfSize = selfSize
        
        let mgvert:TGGravity = self.tg_gravity & TGGravity.horz.mask
        let mghorz:TGGravity = self.tg_gravity & TGGravity.vert.mask
        let amghorz:TGGravity = self.tg_arrangedGravity & TGGravity.vert.mask
        
        let vertSpace = self.tg_vspace
        let horzSpace = self.tg_hspace
        
        let averageArrange = (mgvert == TGGravity.vert.fill)
        
        var arrangedIndex:Int = 0
        var rowTotalWeight:CGFloat = 0
        var rowTotalFixedHeight:CGFloat = 0
        for i in 0..<sbs.count
        {
            let sbv:UIView = sbs[i]
            let isHeightWeight = sbv.tg_height.dimeWeightVal != nil || sbv.tg_height.isFill

            
            if (arrangedIndex >= arrangedCount)
            {
                arrangedIndex = 0;
                
                if (rowTotalWeight != 0 && !averageArrange)
                {
                    self.tgCalcHorzLayoutSingleLineWeight(selfSize:selfSize,totalFloatHeight:selfSize.height - padding.top - padding.bottom - rowTotalFixedHeight,totalWeight:rowTotalWeight,sbs:sbs,startIndex:i,count:arrangedCount)
                }
                
                rowTotalWeight = 0;
                rowTotalFixedHeight = 0;
                
            }
            
            let  topMargin = sbv.tg_top.margin;
            let  bottomMargin = sbv.tg_bottom.margin;
            var  rect = sbv.tgFrame.frame;
            
            
            if (sbv.tg_width.dimeNumVal != nil)
            {
                rect.size.width = sbv.tg_width.measure
            }
            
            
            if (sbv.tg_width.dimeRelaVal === self.tg_width && !self.tg_width.isWrap)
            {
                rect.size.width = sbv.tg_width.measure(selfSize.width - padding.left - padding.right)
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            
            if isHeightWeight
            {
                if sbv.tg_height.isFill
                {
                    rowTotalWeight += 1.0
                }
                else
                {
                  rowTotalWeight += sbv.tg_height.dimeWeightVal.rawValue/100
                }
            }
            else
            {
                
                let  isFlexedHeight = sbv.tg_height.isFlexHeight
                
                
                if (sbv.tg_height.dimeNumVal != nil && !averageArrange)
                {
                    rect.size.height = sbv.tg_height.measure;
                }
                
                if (sbv.tg_height.dimeRelaVal === self.tg_height && !self.tg_height.isWrap)
                {
                    rect.size.height = sbv.tg_height.measure(selfSize.height - padding.top - padding.bottom)
                }
                
                
                //如果高度是浮动的则需要调整高度。
                if (isFlexedHeight)
                {
                    rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                }
                
                rect.size.height = self.tgValidMeasure(sbv.tg_height,sbv:sbv,calcSize:rect.size.height,sbvSize:rect.size,selfLayoutSize:selfSize)
                
                if (sbv.tg_width.dimeRelaVal === sbv.tg_height)
                {
                    rect.size.width = self.tgValidMeasure(sbv.tg_width,sbv:sbv,calcSize:sbv.tg_width.measure(rect.size.height),sbvSize:rect.size,selfLayoutSize:selfSize)
                }
                
                rowTotalFixedHeight += rect.size.height;
            }
            
            rowTotalFixedHeight += topMargin + bottomMargin
            
            
            if (arrangedIndex != (arrangedCount - 1))
            {
                rowTotalFixedHeight += vertSpace
            }
            
            
            sbv.tgFrame.frame = rect;
            
            arrangedIndex += 1
            
        }
        
        //最后一行。
        if (rowTotalWeight != 0 && !averageArrange)
        {
            if arrangedIndex < arrangedCount
            {
                rowTotalFixedHeight -= vertSpace
            }
            
            self.tgCalcHorzLayoutSingleLineWeight(selfSize:selfSize,totalFloatHeight:selfSize.height - padding.top - padding.bottom - rowTotalFixedHeight,totalWeight:rowTotalWeight,sbs:sbs,startIndex:sbs.count,count:arrangedIndex)
        }
        
        
        let averageHeight:CGFloat = (selfSize.height - padding.top - padding.bottom - (CGFloat(arrangedCount) - 1) * vertSpace) / CGFloat(arrangedCount)
        
        arrangedIndex = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            
            if arrangedIndex >= arrangedCount {
                arrangedIndex = 0
                xPos += colMaxWidth
                xPos += horzSpace
                yPos = padding.top
                
                //计算每行Gravity情况
                self.tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: i, count: arrangedCount, vertSpace: vertSpace, horzSpace: horzSpace)
                
                colMaxWidth = 0
                colMaxHeight = 0
            }
            
            let topMargin:CGFloat = sbv.tg_top.margin
            let leftMargin:CGFloat = sbv.tg_left.margin
            let bottomMargin:CGFloat = sbv.tg_bottom.margin
            let rightMargin:CGFloat = sbv.tg_right.margin
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill

            var rect:CGRect = sbv.tgFrame.frame
            
            if averageArrange {
                rect.size.height = (averageHeight - topMargin - bottomMargin)
                
                if sbv.tg_width.dimeRelaVal === sbv.tg_height {
                    rect.size.width = sbv.tg_width.measure(rect.size.height)
                    rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                }
            }
            
            if isWidthWeight
            {
                var widthWeight:CGFloat = 1.0
                if sbv.tg_width.dimeWeightVal != nil
                {
                    widthWeight = sbv.tg_width.dimeWeightVal.rawValue/100
                }
                
                rect.size.width = sbv.tg_width.measure((selfSize.width - xPos - padding.right)*widthWeight - leftMargin - rightMargin)
                rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            }

            
            rect.origin.y = yPos + topMargin
            rect.origin.x = xPos + leftMargin
            yPos += topMargin + rect.size.height + bottomMargin
            
            if arrangedIndex != (arrangedCount - 1) {
                yPos += vertSpace
            }
            
            if colMaxWidth < (leftMargin + rightMargin + rect.size.width) {
                colMaxWidth = leftMargin + rightMargin + rect.size.width
            }
            if colMaxHeight < (yPos - padding.top) {
                colMaxHeight = yPos - padding.top
            }
            if maxHeight < yPos {
                maxHeight = yPos
            }
            
            sbv.tgFrame.frame = rect
            
            arrangedIndex += 1
        }
        
        //最后一列
        self .tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: sbs.count, count: arrangedIndex, vertSpace: vertSpace, horzSpace: horzSpace)
        
        if self.tg_height.isWrap && !averageArrange {
            selfSize.width = maxHeight + padding.bottom
        }
        if self.tg_width.isWrap {
            selfSize.width = xPos + padding.right + colMaxWidth
        }
        else {
            var addXPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            let arranges = floor(CGFloat(sbs.count + arrangedCount - 1) / CGFloat(arrangedCount))

            
            if mghorz == TGGravity.horz.center {
                addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2
            }
            else if mghorz == TGGravity.horz.right {
                addXPos = selfSize.width - padding.right - colMaxWidth - xPos
            }
            else if (mghorz == TGGravity.horz.fill)
            {
                if (arranges > 0)
                {
                    fill = (selfSize.width - padding.right - colMaxWidth - xPos) / arranges
                }
            }
            else if (mghorz == TGGravity.horz.between)
            {
                if (arranges > 1)
                {
                   between = (selfSize.width - padding.left - colMaxWidth - xPos) / (arranges - 1)
                }
            }

            
            
            if addXPos != 0 || between != 0 || fill != 0 {
                for i:Int in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    
                    let line = i / arrangedCount
                    
                    sbv.tgFrame.width += fill
                    sbv.tgFrame.left += fill * CGFloat(line)
                    sbv.tgFrame.left += addXPos
                    sbv.tgFrame.left += between * CGFloat(line)
                }
            }
        }
        return selfSize
    }

    fileprivate func tgLayoutSubviewsForHorzContent(_ selfSize:CGSize, sbs:[UIView])->CGSize {
        let padding:UIEdgeInsets = self.tg_padding
        var xPos:CGFloat = padding.left
        var yPos:CGFloat = padding.top
        var colMaxWidth:CGFloat = 0
        var colMaxHeight:CGFloat = 0
        
        var selfSize = selfSize
        let mgvert:TGGravity = self.tg_gravity & TGGravity.horz.mask
        let mghorz:TGGravity = self.tg_gravity & TGGravity.vert.mask
        let amghorz:TGGravity = self.tg_arrangedGravity & TGGravity.vert.mask

        
        //支持浮动垂直间距。
        let horzSpace = self.tg_hspace
        var vertSpace = self.tg_vspace
        var subviewSize = (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClassImpl).tgSubviewSize;
        if (subviewSize != 0)
        {
            
            let minSpace = (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClassImpl).tgMinSpace
            let maxSpace = (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClassImpl).tgMaxSpace

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
        

        var arrangeIndexSet = IndexSet()
        var arrangedIndex:Int = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            
            let topMargin:CGFloat = sbv.tg_top.margin
            let leftMargin:CGFloat = sbv.tg_left.margin
            let bottomMargin:CGFloat = sbv.tg_bottom.margin
            let rightMargin:CGFloat = sbv.tg_right.margin
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill
            let isHeightWeight = sbv.tg_height.dimeWeightVal != nil || sbv.tg_height.isFill
            var rect:CGRect = sbv.tgFrame.frame
            
            
            if sbv.tg_width.dimeNumVal != nil {
                rect.size.width = sbv.tg_width.measure
            }
            
            
            if subviewSize != 0
            {
                rect.size.height = subviewSize
            }
            
            if sbv.tg_height.dimeNumVal != nil {
                rect.size.height = sbv.tg_height.measure
            }
            if sbv.tg_width.dimeRelaVal === self.tg_width && !self.tg_width.isWrap {
                rect.size.width = sbv.tg_width.measure(selfSize.width - padding.left - padding.right)
            }
            if sbv.tg_height.dimeRelaVal === self.tg_height && !self.tg_height.isWrap {
                rect.size.height = sbv.tg_height.measure(selfSize.height - padding.top - padding.bottom)
            }
            
            if isHeightWeight
            {
                //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
                var floatHeight = selfSize.height - padding.top - padding.bottom - colMaxHeight;
                if (/*floatHeight <= 0*/ _tgCGFloatLessOrEqual(floatHeight, 0))
                {
                    floatHeight += colMaxHeight;
                    arrangedIndex = 0;
                }
                
                if (arrangedIndex != 0)
                {
                    floatHeight -= vertSpace
                }
                
                var heightWeight:CGFloat = 1.0
                if sbv.tg_height.dimeWeightVal != nil
                {
                    heightWeight = sbv.tg_height.dimeWeightVal.rawValue/100
                }
                
                rect.size.height = (floatHeight + sbv.tg_height.addVal) * heightWeight - topMargin - bottomMargin;
                
            }
            
            
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if sbv.tg_width.dimeRelaVal === sbv.tg_height {
                rect.size.width = sbv.tg_width.measure(rect.size.height)
            }
            
            
            if isWidthWeight
            {
                var widthWeight:CGFloat = 1.0
                if sbv.tg_width.dimeWeightVal != nil
                {
                    widthWeight = sbv.tg_width.dimeWeightVal.rawValue / 100
                }
                
                rect.size.width = sbv.tg_width.measure((selfSize.width - xPos - padding.right)*widthWeight - leftMargin - rightMargin)
            }

            
            rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            
            //如果高度是浮动则调整
            if sbv.tg_height.isFlexHeight {
                
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                
            }
            
            //计算yPos的值加上topMargin + rect.size.height + bottomMargin + self.tg_vspace 的值要小于整体的宽度。
            var place:CGFloat = yPos + topMargin + rect.size.height + bottomMargin
            if arrangedIndex != 0 {
                place += vertSpace
            }
            place += padding.bottom
            
            //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
            if place - selfSize.height > 0.0001
            {
                yPos = padding.top
                xPos += horzSpace
                xPos += colMaxWidth
                
                //计算每行Gravity情况
                arrangeIndexSet.insert(i - arrangedIndex)
                self.tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: i, count: arrangedIndex, vertSpace: vertSpace, horzSpace: horzSpace)
                
                //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
                if (topMargin + bottomMargin + rect.size.height > selfSize.height - padding.top - padding.bottom)
                {
                    rect.size.height = selfSize.height - padding.top - padding.bottom - topMargin - bottomMargin
                    rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                }
                
                colMaxWidth = 0;
                colMaxHeight = 0;
                arrangedIndex = 0;
            }
            
            if arrangedIndex != 0 {
                yPos += vertSpace
            }
            rect.origin.x = xPos + leftMargin
            rect.origin.y = yPos + topMargin
            yPos += topMargin + rect.size.height + bottomMargin
            
            if (colMaxWidth < leftMargin + rightMargin + rect.size.width) {
                colMaxWidth = leftMargin + rightMargin + rect.size.width;
            }
            
            if (colMaxHeight < (yPos - padding.top)) {
                colMaxHeight = (yPos - padding.top);
            }
            sbv.tgFrame.frame = rect;
            
            arrangedIndex += 1;
        }
        
        //最后一行
        arrangeIndexSet.insert(sbs.count - arrangedIndex)
        self.tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: sbs.count, count: arrangedIndex, vertSpace: vertSpace, horzSpace: horzSpace)
        
        if self.tg_width.isWrap {
            selfSize.width = xPos + padding.right + colMaxWidth
        }
        else {
            var addXPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            
            if (mghorz == TGGravity.horz.center)
            {
                addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2;
            }
            else if (mghorz == TGGravity.horz.right)
            {
                addXPos = selfSize.width - padding.right - colMaxWidth - xPos;
            }
            else if (mghorz == TGGravity.horz.fill)
            {
                if (arrangeIndexSet.count > 0)
                {
                   fill = (selfSize.width - padding.right - colMaxWidth - xPos) / CGFloat(arrangeIndexSet.count)
                }
            }
            else if (mghorz == TGGravity.horz.between)
            {
                if (arrangeIndexSet.count > 1)
                {
                  between = (selfSize.width - padding.right - colMaxWidth - xPos) / CGFloat(arrangeIndexSet.count - 1)
                }
            }

            
            if (addXPos != 0 || between != 0 || fill != 0)
            {
                var line:CGFloat = 0
                var lastIndex:Int = 0
                
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    sbv.tgFrame.left += addXPos
                    
                    let index = arrangeIndexSet.integerLessThanOrEqualTo(i)
                    if lastIndex != index
                    {
                        lastIndex = index!
                        line += 1
                    }
                    
                    sbv.tgFrame.width += fill
                    sbv.tgFrame.left += fill * line
                    sbv.tgFrame.left += between * line
                }
            }
        }
        
        return selfSize
    }
}
