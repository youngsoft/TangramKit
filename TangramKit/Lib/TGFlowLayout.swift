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
 tg_orientation为.vert,tg_arrangedCount不为0,支持tg_averageArrange,不支持tg_autoArrange。
 
 2.垂直内容约束流式布局.
 tg_orientation为.vert,tg_arrangedCount为0,支持tg_averageArrange,支持tg_autoArrange。
 
 
 3.水平数量约束流式布局。
 tg_orientation为.horz,tg_arrangedCount不为0,支持tg_averageArrange,不支持tg_autoArrange。
 
 4.水平内容约束流式布局
 tg_orientation为.horz,tg_arrangedCount为0,支持tg_averageArrange,支持tg_autoArrange。
 
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
     *指定是否均分布局方向上的子视图的宽度或者高度，或者拉伸子视图的尺寸，默认是false。
     如果是.vert则表示每行的子视图的宽度会被均分，这样子视图不需要指定宽度，但是布局视图必须要指定一个明确的宽度值，如果设置为true则布局的tg_width不能为wrap。
     如果是.horz则表示每列的子视图的高度会被均分，这样子视图不需要指定高度，但是布局视图必须要指定一个明确的高度值，如果设置为true则布局的tg_height不能为wrap。
     内容填充约束流式布局下tg_averageArrange设置为true时表示拉伸子视图的宽度或者高度以便填充满整个布局视图。
     */
    public var tg_averageArrange:Bool {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_averageArrange
        }
        set {
            (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_averageArrange = newValue
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
     *如果视图方向为.vert时且tg_averageArrange为true时则水平方向的停靠失效。
     *如果视图方向为.horz时且tg_averageArrange为true时则垂直方向的停靠失效。
     *对于内容填充布局来说如果设置为TGGravity.horz.fill或者TGGravity.vert.fill则表示间距的拉伸
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
                        (self.tg_orientation == .vert && self.tg_averageArrange))
                    {
                        sbvl.tg_width._dimeVal = nil
                    }
                }
                
                if (sbvl.tg_height.isWrap)
                {
                    if ((self.tg_orientation == .vert && (self.tg_arrangedGravity & TGGravity.horz.mask) == TGGravity.vert.fill) ||
                        (self.tg_orientation == .horz && self.tg_averageArrange))
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
            if (fabs(selfSize - s1) < fabs(selfSize - s2) && s1 <= selfSize)
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
            if (s1 <= selfSize)
            {
                let s2 = self.tgCalcSingleLineSize(bestSingleLineArray,margin:margin)
                if (fabs(selfSize - s1) < fabs(selfSize - s2))
                {
                    bestSingleLineArray.setArray(calcArray2 as [AnyObject])
                }
                
                if (s1 == selfSize)
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
    fileprivate func tgCalcVertLayoutSingleLineGravity(_ selfSize:CGSize, rowMaxHeight:CGFloat, rowMaxWidth:CGFloat, mg:TGGravity, amg:TGGravity, sbs:[UIView], startIndex:Int, count:Int) {
        let padding:UIEdgeInsets = self.tg_padding
        var addXPos:CGFloat = 0
        var addXFill:CGFloat = 0
        
        //处理 对其方式
        if !self.tg_averageArrange || self.tg_arrangedCount == 0 {
            switch mg {
            case TGGravity.horz.center:
                addXPos = (selfSize.width - padding.left - padding.right - rowMaxWidth)/2
                break
            case TGGravity.horz.right:
                //不用考虑左边距，而原来的位置增加了左边距 因此不用考虑
                addXPos = selfSize.width - padding.left - padding.right - rowMaxWidth
                break
            case TGGravity.horz.fill:
                //总宽减去最大的宽度，再除以数量表示每个应该扩展的空间，对最后一行无效
                if startIndex != sbs.count && count > 1 {
                    addXFill = (selfSize.width - padding.left - padding.right - rowMaxWidth)/(CGFloat(count) - 1)
                }
                break
            default:
                break
            }
            //处理内容拉伸的情况
            if self.tg_arrangedCount == 0 && self.tg_averageArrange {
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
                        if (self.tg_vspace != 0 && startIndex - count != 0)
                        {
                            sbvl.tg_topBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果有水平间距则不是第一列就画左
                        if (self.tg_hspace != 0 && j != startIndex - count)
                        {
                            sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                        }
                        
                        
                    }
                }
            }
            
            if (amg != TGGravity.none && amg != TGGravity.vert.top) || addXPos != 0 || addXFill != 0
            {
                sbv.tgFrame.left += addXPos
                
                if self.tg_arrangedCount == 0 && self.tg_averageArrange {
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
    fileprivate func tgCalcHorzLayoutSingleLineGravity(_ selfSize:CGSize, colMaxHeight:CGFloat, colMaxWidth:CGFloat, mg:TGGravity, amg:TGGravity, sbs:[UIView], startIndex:Int, count:Int) {
        var addYPos:CGFloat = 0
        var addYFill:CGFloat = 0
        let padding:UIEdgeInsets = self.tg_padding
        
        if !self.tg_averageArrange || self.tg_arrangedCount == 0 {
            switch mg {
            case TGGravity.vert.center:
                addYPos = (selfSize.height - padding.top - padding.bottom - colMaxHeight)/2
                break
            case TGGravity.vert.bottom:
                addYPos = selfSize.height - padding.top - padding.bottom - colMaxHeight
                break
            case TGGravity.vert.fill:
                //总高减去最大高度，再除以数量表示每个应该扩展的空气，最后一列无效
                if startIndex != sbs.count && count > 1 {
                    addYFill = (selfSize.height - padding.top - padding.bottom - colMaxHeight)/(CGFloat(count) - 1)
                }
                break
            default:
                break
            }
            
            //处理内容拉伸的情况
            if self.tg_arrangedCount == 0 && self.tg_averageArrange {
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
                        if (self.tg_vspace != 0 && j != startIndex - count)
                        {
                            sbvl.tg_topBorderline = self.tg_intelligentBorderline
                        }
                        
                        //如果有水平间距则不是第一列就画左
                        if (self.tg_hspace != 0 && startIndex - count != 0  )
                        {
                            sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                        }
                        
                    }
                }
            }
            
            if (amg != TGGravity.none && amg != TGGravity.horz.left) || addYPos != 0 || addYFill != 0 {
                sbv.tgFrame.top += addYPos
                
                if self.tg_arrangedCount == 0 && self.tg_averageArrange {
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
                
                if (rowTotalWeight != 0 && !self.tg_averageArrange)
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
                
                if (sbv.tg_width.dimeNumVal != nil && !self.tg_averageArrange)
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
                rowTotalFixedWidth += self.tg_hspace;
            }
            
            sbv.tgFrame.frame = rect;
            
            arrangedIndex += 1
            
        }
        
        //最后一行。
        if (rowTotalWeight != 0 && !self.tg_averageArrange)
        {
            self.tgCalcVertLayoutSingleLineWeight(selfSize:selfSize,totalFloatWidth:selfSize.width - padding.left - padding.right - rowTotalFixedWidth,totalWeight:rowTotalWeight,sbs:sbs,startIndex:sbs.count, count:arrangedIndex)
        }
        
        
        let averageWidth:CGFloat = (selfSize.width - padding.left - padding.right - (CGFloat(arrangedCount) - 1) * self.tg_hspace) / CGFloat(arrangedCount)
        
        arrangedIndex = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            
            //换行
            if arrangedIndex >= arrangedCount {
                arrangedIndex = 0
                xPos = padding.left
                yPos += rowMaxHeight
                yPos += self.tg_vspace
                
                //计算每行的gravity情况
                self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex: i, count: arrangedCount)
                
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
            
            
            if self.tg_averageArrange {
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
                xPos += self.tg_hspace
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
        self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex: sbs.count, count: arrangedIndex)
        
        if self.tg_height.isWrap {
            selfSize.height = yPos + padding.bottom + rowMaxHeight
        }
        else {
            var addYPos:CGFloat = 0
            
            if mgvert == TGGravity.vert.center {
                addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos)/2
            }
            if mgvert == TGGravity.vert.bottom {
                addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos
            }
            if addYPos != 0 {
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    sbv.tgFrame.top += addYPos
                }
            }
        }
        
        if self.tg_width.isWrap && !self.tg_averageArrange {
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
                if floatWidth <= 0
                {
                    floatWidth += rowMaxWidth
                    arrangeIndex = 0
                }
                
                if (arrangeIndex != 0)
                {
                    floatWidth -= self.tg_hspace
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
                place += self.tg_hspace
            }
            place += padding.right
            
            //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
            if place > selfSize.width {
                xPos = padding.left
                yPos += self.tg_vspace
                yPos += rowMaxHeight
                
                //计算每行Gravity情况
                self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex: i, count: arrangeIndex)
                
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
                xPos += self.tg_hspace
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
        
        self .tgCalcVertLayoutSingleLineGravity(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, mg: mghorz, amg: amgvert, sbs: sbs, startIndex:sbs.count, count: arrangeIndex)
        
        if self.tg_height.isWrap {
            selfSize.height = yPos + padding.bottom + rowMaxHeight;
        }
        else {
            var addYPos:CGFloat = 0
            
            if mgvert == TGGravity.vert.center {
                addYPos = (selfSize.height - padding.bottom - rowMaxHeight - yPos)/2
            }
            if mgvert == TGGravity.vert.bottom {
                addYPos = selfSize.height - padding.bottom - rowMaxHeight - yPos
            }
            if addYPos != 0 {
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    sbv.tgFrame.top += addYPos
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
                
                if (rowTotalWeight != 0 && !self.tg_averageArrange)
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
                
                
                if (sbv.tg_height.dimeNumVal != nil && !self.tg_averageArrange)
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
            
            rowTotalFixedHeight += topMargin + bottomMargin;
            
            
            if (arrangedIndex != (arrangedCount - 1))
            {
                rowTotalFixedHeight += self.tg_vspace;
            }
            
            
            sbv.tgFrame.frame = rect;
            
            arrangedIndex += 1
            
        }
        
        //最后一行。
        if (rowTotalWeight != 0 && !self.tg_averageArrange)
        {
            self.tgCalcHorzLayoutSingleLineWeight(selfSize:selfSize,totalFloatHeight:selfSize.height - padding.top - padding.bottom - rowTotalFixedHeight,totalWeight:rowTotalWeight,sbs:sbs,startIndex:sbs.count,count:arrangedIndex)
        }
        
        
        let averageHeight:CGFloat = (selfSize.height - padding.top - padding.bottom - (CGFloat(arrangedCount) - 1) * self.tg_vspace) / CGFloat(arrangedCount)
        
        arrangedIndex = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            
            if arrangedIndex >= arrangedCount {
                arrangedIndex = 0
                xPos += colMaxWidth
                xPos += self.tg_hspace
                yPos = padding.top
                
                //计算每行Gravity情况
                self.tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: i, count: arrangedCount)
                
                colMaxWidth = 0
                colMaxHeight = 0
            }
            
            let topMargin:CGFloat = sbv.tg_top.margin
            let leftMargin:CGFloat = sbv.tg_left.margin
            let bottomMargin:CGFloat = sbv.tg_bottom.margin
            let rightMargin:CGFloat = sbv.tg_right.margin
            let isWidthWeight = sbv.tg_width.dimeWeightVal != nil || sbv.tg_width.isFill

            var rect:CGRect = sbv.tgFrame.frame
            
            if self.tg_averageArrange {
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
                yPos += self.tg_vspace
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
        self .tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: sbs.count, count: arrangedIndex)
        
        if self.tg_height.isWrap && !self.tg_averageArrange {
            selfSize.width = maxHeight + padding.bottom
        }
        if self.tg_width.isWrap {
            selfSize.width = xPos + padding.right + colMaxWidth
        }
        else {
            var addXPos:CGFloat = 0
            
            if mghorz == TGGravity.horz.center {
                addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2
            }
            if mghorz == TGGravity.horz.right {
                addXPos = selfSize.width - padding.right - colMaxWidth - xPos
            }
            
            if addXPos != 0 {
                for i:Int in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    sbv.tgFrame.left += addXPos
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
                if (floatHeight <= 0)
                {
                    floatHeight += colMaxHeight;
                    arrangedIndex = 0;
                }
                
                if (arrangedIndex != 0)
                {
                    floatHeight -= self.tg_vspace;
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
                place += self.tg_vspace
            }
            place += padding.bottom
            
            //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
            if place > selfSize.height {
                yPos = padding.top
                xPos += self.tg_hspace
                xPos += colMaxWidth
                
                //计算每行Gravity情况
                self.tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: i, count: arrangedIndex)
                
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
                yPos += self.tg_vspace
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
        self.tgCalcHorzLayoutSingleLineGravity(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, mg: mgvert, amg: amghorz, sbs: sbs, startIndex: sbs.count, count: arrangedIndex)
        
        if self.tg_width.isWrap {
            selfSize.width = xPos + padding.right + colMaxWidth
        }
        else {
            var addXPos:CGFloat = 0
            if (mghorz == TGGravity.horz.center)
            {
                addXPos = (selfSize.width - padding.right - colMaxWidth - xPos) / 2;
            }
            else if (mghorz == TGGravity.horz.right)
            {
                addXPos = selfSize.width - padding.right - colMaxWidth - xPos;
            }
            
            if (addXPos != 0)
            {
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    sbv.tgFrame.left += addXPos
                }
            }
        }
        
        return selfSize
    }
}
