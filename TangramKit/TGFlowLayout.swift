//
//  TGFlowLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 *流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一排再重新排列的多行多列展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，排列的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。
 1.垂直数量约束流式布局
 tg_orientation=.vert,tg_arrangedCount>0
 
 
 每排数量为3的垂直数量约束流式布局
         =>
 +------+---+-----+
 |  A   | B |  C  |
 +---+--+-+-+-----+
 | D |  E |   F   |  |
 +---+-+--+--+----+  v
 |  G  |  H  | I  |
 +-----+-----+----+
 
 2.垂直内容约束流式布局.
 tg_orientation = .vert,tg_arrangedCount = 0
 
 垂直内容约束流式布局
          =>
 +-----+-----------+
 |  A  |     B     |
 +-----+-----+-----+
 |  C  |  D  |  E  |  |
 +-----+-----+-----+  v
 |        F        |
 +-----------------+
 
 
 
 3.水平数量约束流式布局。
 tg_orientation = .horz,tg_arrangedCount > 0
 
 每排数量为3的水平数量约束流式布局
            =>
    +-----+----+-----+
    |  A  | D  |     |
    |     |----|  G  |
    |-----|    |     |
 |  |  B  | E  |-----|
 V  |-----|    |     |
    |     |----|  H  |
    |  C  |    |-----|
    |     | F  |  I  |
    +-----+----+-----+
 
 
 
 4.水平内容约束流式布局
 tg_orientation = .horz,arrangedCount = 0
 
 
 水平内容约束流式布局
         =>
    +-----+----+-----+
    |  A  | C  |     |
    |     |----|     |
    |-----|    |     |
 |  |     | D  |     |
 V  |     |    |  F  |
    |  B  |----|     |
    |     |    |     |
    |     | E  |     |
    +-----+----+-----+
 
 
 
 
 流式布局中排的概念是一个通用的称呼，对于垂直方向的流式布局来说一排就是一行，垂直流式布局每排依次从上到下排列，每排内的子视图则是由左往右依次排列；对于水平方向的流式布局来说一排就是一列，水平流式布局每排依次从左到右排列，每排内的子视图则是由上往下依次排列
 
 */
open class TGFlowLayout:TGBaseLayout,TGFlowLayoutViewSizeClass {
    
    /**
     *初始化一个流式布局并指定布局的方向和布局的数量,如果数量为0则表示内容约束流式布局
     */
    public convenience init(_ orientation:TGOrientation = TGOrientation.vert, arrangedCount:Int = 0) {
        self.init(frame:CGRect.zero, orientation:orientation, arrangedCount:arrangedCount)
    }
    
    
    public init(frame: CGRect, orientation:TGOrientation = TGOrientation.vert, arrangedCount:Int = 0) {
        
        super.init(frame:frame)
        let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass
        lsc.tg_orientation = orientation
        lsc.tg_arrangedCount = arrangedCount
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     *流式布局的布局方向
     *如果是.vert则表示每排先从左到右，再从上到下的垂直布局方式，这个方式是默认方式。
     *如果是.horz则表示每排先从上到下，在从左到右的水平布局方式。
     */
    public var tg_orientation:TGOrientation {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_orientation
        }
        set {
            let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass
            if (lsc.tg_orientation != newValue)
            {
                lsc.tg_orientation = newValue
                setNeedsLayout()
            }
        }
    }
    
    /**
     *指定方向上的子视图的数量，默认是0表示为内容约束流式布局，当数量不为0时则是数量约束流式布局。当值为0时则表示当子视图在方向上的尺寸超过布局视图时则会新起一排。而如果数量不为0时则：
     如果方向为.vert，则表示从左到右的数量，当子视图从左往右满足这个数量后新的子视图将会新起一排
     如果方向为.horz，则表示从上到下的数量，当子视图从上往下满足这个数量后新的子视图将会新起一排
     */
    public var tg_arrangedCount:Int {   //get/set方法
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_arrangedCount
        }
        set {
            let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass
            if (lsc.tg_arrangedCount != newValue)
            {
                lsc.tg_arrangedCount = newValue
                setNeedsLayout()
            }
        }
    }
    
    
    
    /**
     *为流式布局提供分页展示的能力,默认是0表不支持分页展示，当设置为非0时则要求必须是tg_arrangedCount的整数倍数，表示每页的子视图的数量。而tg_arrangedCount则表示每排的子视图的数量。当启用tg_pagedCount时要求将流式布局加入到UIScrollView或者其派生类中才能生效。只有数量约束流式布局才支持分页展示的功能，tg_pagedCount和tg_height.isWrap以及tg_width.isWrap配合使用能实现不同的分页展示能力:
     
     1.垂直数量约束流式布局的tg_height设置为.wrap时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从左到右再从上到下排列，新页往下滚动继续排列)：
     1  2  3
     4  5  6
     -------  ↓
     7  8  9
     10 11 12
     
     2.垂直数量约束流式布局的tg_width设置为.wrap时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从左到右再从上到下排列，新页往右滚动继续排列)
     1  2  3 | 7  8  9
     4  5  6 | 10 11 12
     →
     1.水平数量约束流式布局的tg_width设置为.wrap时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的高度你也可以自定义)，整体的分页滚动是从左到右滚动。(每页布局时从上到下再从左到右排列，新页往右滚动继续排列)
     1  3  5 | 7  9   11
     2  4  6 | 8  10  12
     →
     
     2.水平数量约束流式布局的tg_height设置为.wrap时则以UIScrollView的尺寸作为一页展示的大小，因为指定了一页的子视图数量，以及指定了一排的子视图数量，因此默认也会自动计算出子视图的宽度和高度，而不需要单独指出高度和宽度(子视图的宽度你也可以自定义)，整体的分页滚动是从上到下滚动。(每页布局时从上到下再从左到右排列，新页往下滚动继续排列)
     
     1  3  5
     2  4  6
     --------- ↓
     7  9  11
     8  10 12
     
     */
    public var tg_pagedCount:Int {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_pagedCount
        }
        set {
            let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass
            if (lsc.tg_pagedCount != newValue)
            {
                lsc.tg_pagedCount = newValue
                setNeedsLayout()
            }
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
            let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass
            if (lsc.tg_autoArrange != newValue)
            {
                lsc.tg_autoArrange = newValue
                setNeedsLayout()
            }
        }
    }
    
    
    /**
     *设置流式布局中每排子视图的对齐方式。
     如果布局的方向是.vert则表示每排子视图的上中下对齐方式，这里的对齐基础是以每排中的最高的子视图为基准。这个属性只支持：
     TGGravity.vert.top     顶部对齐
     TGGravity.vert.center  垂直居中对齐
     TGGravity.vert.bottom  底部对齐
     TGGravity.vert.fill    两端对齐
     如果布局的方向是.horz则表示每排子视图的左中右对齐方式，这里的对齐基础是以每排中的最宽的子视图为基准。这个属性只支持：
     TGGravity.horz.left    左边对齐
     TGGravity.horz.center  水平居中对齐
     TGGravity.horz.right   右边对齐
     TGGravity.horz.fill    两端对齐
     */
    public var tg_arrangedGravity:TGGravity {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_arrangedGravity
        }
        set {
            let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass
            if (lsc.tg_arrangedGravity != newValue)
            {
                lsc.tg_arrangedGravity = newValue
                setNeedsLayout()
            }
        }
    }
    
    
    /**
     * 指定流式布局最后一行的尺寸或间距的拉伸策略。默认值是TGGravityPolicy.no表示最后一行的尺寸或间接拉伸策略不生效。
       在流式布局中我们可以通过tg_gravity属性来对每一行的尺寸或间距进行拉伸处理。但是在实际情况中最后一行的子视图数量可能会小于等于前面行的数量。
       在这种情况下如果对最后一行进行相同的尺寸或间距的拉伸处理则有可能会影响整体的布局效果。因此我们可通过这个属性来指定最后一行的尺寸或间距的生效策略。
        这个策略在不同的流式布局中效果不一样：
     
        1.在数量约束布局中如果最后一行的子视图数量小于tg_arrangedCount的值时，那么当我们使用tg_gravity来对行内视图进间距拉伸时(between,around,among)
          可以指定三种策略：no表示最后一行不进行任何间距拉伸处理，always表示最后一行总是进行间距拉伸处理，auto表示最后一行的每个子视图都和上一行对应位置视图左对齐。
     
        2.在内容约束布局中因为每行的子视图数量不固定,所以只有no和always两种策略有效，并且这两种策略不仅影响子视图的尺寸的拉伸(fill)还影响间距的拉伸效果(between,around,among)。
     */
    public var tg_lastlineGravityPolicy:TGGravityPolicy {
        get {
            return (self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass).tg_lastlineGravityPolicy
        }
        set {
            let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClass
            if (lsc.tg_lastlineGravityPolicy != newValue)
            {
                lsc.tg_lastlineGravityPolicy = newValue
                setNeedsLayout()
            }
        }
    }
    
    
    /**
     *在流式布局的一些应用场景中我们有时候希望某些子视图的宽度或者高度是固定的情况下，子视图的间距是浮动的而不是固定的。比如每个子视图的宽度是固定80，那么在小屏幕下每行只能放3个，而我们希望大屏幕每行能放4个或者5个子视图。 因此您可以通过如下方法来设置浮动间距，这个方法会根据您当前布局的orientation方向不同而意义不同：
     1.如果您的布局方向是.vert表示设置的是子视图的水平间距，其中的size指定的是子视图的宽度，minSpace指定的是最小的水平间距,maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的宽度。
     2.如果您的布局方向是.horz表示设置的是子视图的垂直间距，其中的size指定的是子视图的高度，minSpace指定的是最小的垂直间距,maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的高度。
     3.如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
     4.对于数量约束流式布局来说，因为每行和每列的数量的固定的，因此不存在根据屏幕的大小自动换行的能力以及进行最佳数量的排列，但是可以使用这个方法来实现所有子视图尺寸固定但是间距是浮动的功能需求。
        5. centered属性指定这个浮动间距是否包括最左边和最右边两个区域，也就是说当设置为true时视图之间以及视图与父视图之间的间距都是相等的，而设置为false时则只有视图之间的间距相等而视图与父视图之间的间距则为0。
     */
    public func tg_setSubviews(size:CGFloat, minSpace:CGFloat, maxSpace:CGFloat = CGFloat.greatestFiniteMagnitude, centered:Bool = false, inSizeClass type:TGSizeClassType = TGSizeClassType.default)
    {
        let lsc = self.tg_fetchSizeClass(with: type) as! TGFlowLayoutViewSizeClassImpl
        
        if size == 0.0 {
            lsc.tgFlexSpace = nil
        }
        else {
            
            if lsc.tgFlexSpace == nil {
                lsc.tgFlexSpace = TGSequentLayoutFlexSpace()
            }
            
            lsc.tgFlexSpace.subviewSize = size
            lsc.tgFlexSpace.minSpace = minSpace
            lsc.tgFlexSpace.maxSpace = maxSpace
            lsc.tgFlexSpace.centered = centered
        }
        
        self.setNeedsLayout()
    }

    
    
    
    override internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, hasSubLayout:inout Bool!, sbs:[UIView]!, type :TGSizeClassType) -> CGSize
    {
        var selfSize = super.tgCalcLayoutRect(size, isEstimate:isEstimate, hasSubLayout:&hasSubLayout, sbs:sbs, type:type)
        
        var sbs:[UIView]! = sbs
        if sbs == nil
        {
          sbs = self.tgGetLayoutSubviews()
        }
        
        let lsc = self.tgCurrentSizeClass as! TGFlowLayoutViewSizeClassImpl
        
        
        for sbv:UIView in sbs {
            
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            
            if !isEstimate {
                sbvtgFrame.frame = sbv.bounds
                
                self.tgCalcSizeFromSizeWrapSubview(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame)
            }
            
            if let sbvl:TGBaseLayout = sbv as? TGBaseLayout
            {
                if sbvsc.width.isWrap
                {
                    if (lsc.tg_pagedCount > 0 || (lsc.tg_orientation == TGOrientation.horz && (lsc.tg_arrangedGravity & TGGravity.vert.mask) == TGGravity.horz.fill) ||
                        (lsc.tg_orientation == TGOrientation.vert && ((lsc.tg_gravity & TGGravity.vert.mask) == TGGravity.horz.fill)))
                    {
                        sbvsc.width.resetValue()
                    }
                }
                
                if sbvsc.height.isWrap
                {
                    if (lsc.tg_pagedCount > 0 || (lsc.tg_orientation == TGOrientation.vert && (lsc.tg_arrangedGravity & TGGravity.horz.mask) == TGGravity.vert.fill) ||
                        (lsc.tg_orientation == TGOrientation.horz && ((lsc.tg_gravity & TGGravity.horz.mask) == TGGravity.vert.fill)))
                    {
                        sbvsc.height.resetValue()
                    }
                }
                
                if hasSubLayout != nil && sbvsc.isSomeSizeWrap
                {
                    hasSubLayout = true
                }
                
                if isEstimate && sbvsc.isSomeSizeWrap
                {
                    _ = sbvl.tg_sizeThatFits(sbvtgFrame.frame.size,inSizeClass:type)
                    if sbvtgFrame.multiple
                    {
                        sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)  //因为tg_sizeThatFits执行后会还原，所以这里要重新设置
                    }
                }
            }
        }
        
        if lsc.tg_orientation == TGOrientation.vert {
            if lsc.tg_arrangedCount == 0 {
                
                
                if (lsc.tg_autoArrange)
                {
                    //计算出每个子视图的宽度。
                    for sbv in sbs
                    {
                        let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
                        let leadingSpace = sbvsc.leading.absPos
                        let trailingSpace = sbvsc.trailing.absPos
                        var rect = sbvtgFrame.frame
                        
                        rect.size.width = sbvsc.width.numberSize(rect.size.width)
                        
                        
                        rect = tgSetSubviewRelativeSize(sbvsc.width, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc, rect: rect)
                        
                        rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                        //暂时把宽度存放sbvtgFrame.trailing上。因为浮动布局来说这个属性无用。
                        sbvtgFrame.trailing = leadingSpace + rect.size.width + trailingSpace;
                        if _tgCGFloatGreat(sbvtgFrame.trailing , selfSize.width - lsc.tgLeadingPadding - lsc.tgTrailingPadding)
                        {
                            sbvtgFrame.trailing = selfSize.width - lsc.tgLeadingPadding - lsc.tgTrailingPadding;
                        }
                    }
                    
                    let tempSbs:NSMutableArray = NSMutableArray(array: sbs)
                    sbs = self.tgGetAutoArrangeSubviews(tempSbs, selfSize:selfSize.width - lsc.tgLeadingPadding - lsc.tgTrailingPadding, space: lsc.tg_hspace) as? [UIView]
                    
                }
                
                
                
                selfSize = self.tgLayoutSubviewsForVertContent(selfSize, sbs: sbs, isEstimate:isEstimate, lsc:lsc)
            }
            else {
                selfSize = self.tgLayoutSubviewsForVert(selfSize, sbs: sbs, isEstimate:isEstimate, lsc:lsc)
            }
        }
        else {
            if lsc.tg_arrangedCount == 0 {
                
                
                if (lsc.tg_autoArrange)
                {
                    //计算出每个子视图的宽度。
                    for sbv in sbs
                    {
                        let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)


                        let topSpace = sbvsc.top.absPos
                        let bottomSpace = sbvsc.bottom.absPos
                        var rect = sbvtgFrame.frame;
                        
                        rect.size.width = sbvsc.width.numberSize(rect.size.width)
                        
                        rect.size.height = sbvsc.height.numberSize(rect.size.height)

                        
                        
                        rect = tgSetSubviewRelativeSize(sbvsc.height, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc, rect: rect)
                        
                        rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                       
                        rect = tgSetSubviewRelativeSize(sbvsc.width, selfSize: selfSize,sbvsc:sbvsc,lsc:lsc, rect: rect)
                        
                        rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                        //如果高度是浮动的则需要调整高度。
                        if sbvsc.height.isFlexHeight
                        {
                            rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
                            
                            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                        }
                        
                        
                        //暂时把宽度存放sbvtgFrame.trailing上。因为浮动布局来说这个属性无用。
                        sbvtgFrame.trailing = topSpace + rect.size.height + bottomSpace;
                        if _tgCGFloatGreat(sbvtgFrame.trailing, selfSize.height - lsc.tgTopPadding - lsc.tgBottomPadding)
                        {
                            sbvtgFrame.trailing = selfSize.height - lsc.tgTopPadding - lsc.tgBottomPadding
                        }
                    }
                    
                    let tempSbs:NSMutableArray = NSMutableArray(array: sbs)
                    sbs = self.tgGetAutoArrangeSubviews(tempSbs, selfSize:selfSize.height - lsc.tgTopPadding - lsc.tgBottomPadding, space: lsc.tg_vspace) as? [UIView]
                }
                
                
                
                selfSize = self.tgLayoutSubviewsForHorzContent(selfSize, sbs: sbs, isEstimate:isEstimate, lsc:lsc)
            }
            else {
                selfSize = self.tgLayoutSubviewsForHorz(selfSize, sbs: sbs, isEstimate:isEstimate, lsc:lsc)
            }
        }
        
        tgAdjustLayoutSelfSize(selfSize: &selfSize, lsc: lsc)
        tgAdjustSubviewsLayoutTransform(sbs: sbs, lsc: lsc, selfSize: selfSize)
        tgAdjustSubviewsRTLPos(sbs: sbs, selfWidth: selfSize.width)
        
        return self.tgAdjustSizeWhenNoSubviews(size: selfSize, sbs: sbs, lsc:lsc)
    }
    
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGFlowLayoutViewSizeClassImpl(view:self)
    }

}

extension TGFlowLayout
{
    fileprivate  func tgCalcSinglelineSize(_ sbs:NSArray, space:CGFloat) ->CGFloat
    {
        var size:CGFloat = 0;
        
        for i in 0..<sbs.count
        {
            let sbv = sbs[i] as! UIView
            
            size += sbv.tgFrame.trailing;
            if (sbv != sbs.lastObject as! UIView)
            {
                size += space
            }
        }
        
        return size;
    }
    
    
    fileprivate func tgGetAutoArrangeSubviews(_ sbs:NSMutableArray, selfSize:CGFloat, space:CGFloat) ->NSArray
    {
        
        let retArray:NSMutableArray = NSMutableArray(capacity: sbs.count)
        
        let bestSinglelineArray:NSMutableArray = NSMutableArray(capacity: sbs.count / 2)
        
        while (sbs.count > 0)
        {
            
            self.tgGetAutoArrangeSinglelineSubviews(sbs,
                                                   index:0,
                                                   calcArray:NSArray(),
                                                   selfSize:selfSize,
                                                   space:space,
                                                   bestSinglelineArray:bestSinglelineArray)
            
            retArray.addObjects(from: bestSinglelineArray as [AnyObject])
            
            bestSinglelineArray.forEach({ (obj) -> () in
                
                sbs.remove(obj)
            })
            
            bestSinglelineArray.removeAllObjects()
        }
        
        return retArray;
    }
    
    fileprivate func tgGetAutoArrangeSinglelineSubviews(_ sbs:NSMutableArray,index:Int,calcArray:NSArray,selfSize:CGFloat,space:CGFloat,bestSinglelineArray:NSMutableArray)
    {
        if (index >= sbs.count)
        {
            let s1 = self.tgCalcSinglelineSize(calcArray, space:space)
            let s2 = self.tgCalcSinglelineSize(bestSinglelineArray, space:space)
            if _tgCGFloatLess(abs(selfSize - s1) , abs(selfSize - s2)) && _tgCGFloatLessOrEqual(s1, selfSize)
            {
                bestSinglelineArray.setArray(calcArray as [AnyObject])
            }
            
            return;
        }
        
        
        for  i in  index ..< sbs.count
        {
            
            
            let calcArray2 =  NSMutableArray(array: calcArray)
            calcArray2.add(sbs[i])
            
            let s1 = self.tgCalcSinglelineSize(calcArray2,space:space)
            if ( _tgCGFloatLessOrEqual(s1, selfSize))
            {
                let s2 = self.tgCalcSinglelineSize(bestSinglelineArray,space:space)
                if _tgCGFloatLess(abs(selfSize - s1) , abs(selfSize - s2))
                {
                    bestSinglelineArray.setArray(calcArray2 as [AnyObject])
                }
                
                if ( _tgCGFloatEqual(s1, selfSize))
                {
                    break;
                }
                
                self.tgGetAutoArrangeSinglelineSubviews(sbs,
                                                       index:i + 1,
                                                       calcArray:calcArray2,
                                                       selfSize:selfSize,
                                                       space:space,
                                                       bestSinglelineArray:bestSinglelineArray)
                
            }
            else
            {
                break;
            }
            
        }
        
    }
    
    
    //计算Vert下每行的对齐方式
    fileprivate func tgCalcVertLayoutSinglelineAlignment(_ selfSize:CGSize, rowMaxHeight:CGFloat, rowMaxWidth:CGFloat, horzGravity:TGGravity, vertAlignment:TGGravity, sbs:[UIView], startIndex:Int, count:Int,vertSpace:CGFloat, horzSpace:CGFloat, horzPadding:CGFloat, isEstimate:Bool, lsc:TGFlowLayoutViewSizeClassImpl) {
        var addXPos:CGFloat = 0
        var addXPosInc:CGFloat = 0
        var addXFill:CGFloat = 0
        let averageArrange = (horzGravity == TGGravity.horz.fill)
        //只有最后一行，并且数量小于tg_arrangedCount，并且不是第一行才应用策略。
        let applyLastlineGravityPolicy:Bool = (startIndex == sbs.count &&
            count != lsc.tg_arrangedCount &&
        (horzGravity == TGGravity.horz.between || horzGravity == TGGravity.horz.around || horzGravity == TGGravity.horz.among || horzGravity == TGGravity.horz.fill))
        
        
        //处理 对其方式
        if !averageArrange || lsc.tg_arrangedCount == 0 {
            switch horzGravity {
            case TGGravity.horz.center:
                addXPos = (selfSize.width - horzPadding - rowMaxWidth)/2
                break
            case TGGravity.horz.trailing:
                //不用考虑左边距，而原来的位置增加了左边距 因此不用考虑
                addXPos = selfSize.width - horzPadding - rowMaxWidth
                break
            case TGGravity.horz.between:
                if count > 1 && (!applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always) {
                    addXPosInc = (selfSize.width - horzPadding - rowMaxWidth)/(CGFloat(count) - 1)
                }
                break
            case TGGravity.horz.around:
                if !applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always {
                    if count > 1 {
                        addXPosInc = (selfSize.width - horzPadding - rowMaxWidth)/CGFloat(count)
                        addXPos = addXPosInc / 2.0
                    } else {
                        addXPos = (selfSize.width - horzPadding - rowMaxWidth) / 2.0
                    }
                }
                break
            case TGGravity.horz.among:
                if !applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always {
                    if count > 1 {
                        addXPosInc = (selfSize.width - horzPadding - rowMaxWidth)/CGFloat(count + 1)
                        addXPos = addXPosInc
                    } else {
                        addXPos = (selfSize.width - horzPadding - rowMaxWidth) / 2.0
                    }
                }
                break
                
            default:
                break
            }
            //处理内容拉伸的情况
            if lsc.tg_arrangedCount == 0 && averageArrange && count > 0 {
                if !applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always {
                    addXFill = (selfSize.width - horzPadding - rowMaxWidth)/CGFloat(count)
                }
            }
        }
        
        //调整 整行子控件的位置
        for j in startIndex - count ..< startIndex
        {
            let sbv:UIView = sbs[j]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            
            if !isEstimate && self.tg_intelligentBorderline != nil
            {
                if let sbvl = sbv as? TGBaseLayout {
                    
                    if !sbvl.tg_notUseIntelligentBorderline {
                        sbvl.tg_leadingBorderline = nil
                        sbvl.tg_topBorderline = nil
                        sbvl.tg_trailingBorderline = nil
                        sbvl.tg_bottomBorderline = nil
                        
                        //如果不是最后一行就画下面，
                        if (startIndex != sbs.count)
                        {
                            sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果不是最后一列就画右边,
                        if (j < startIndex - 1)
                        {
                            sbvl.tg_trailingBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果最后一行的最后一个没有满列数时
                        if (j == sbs.count - 1 && lsc.tg_arrangedCount != count )
                        {
                            sbvl.tg_trailingBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果有垂直间距则不是第一行就画上
                        if (vertSpace != 0 && startIndex - count != 0)
                        {
                            sbvl.tg_topBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果有水平间距则不是第一列就画左
                        if (horzSpace != 0 && j != startIndex - count)
                        {
                            sbvl.tg_leadingBorderline = self.tg_intelligentBorderline;
                        }
                    }
                }
            }
            
            //为子视图设置单独的对齐方式
            var sbvVertAlignment = sbvsc.tg_alignment & TGGravity.horz.mask
            if sbvVertAlignment == TGGravity.none
            {
                sbvVertAlignment = vertAlignment
            }
            if vertAlignment == TGGravity.vert.between
            {
                sbvVertAlignment = vertAlignment
            }
            
            if (sbvVertAlignment != TGGravity.none && sbvVertAlignment != TGGravity.vert.top) || _tgCGFloatNotEqual(addXPos, 0)  || _tgCGFloatNotEqual(addXFill, 0) || _tgCGFloatNotEqual(addXPosInc, 0) || applyLastlineGravityPolicy
            {
                sbvtgFrame.leading += addXPos
                
                if lsc.tg_arrangedCount == 0 && averageArrange {
                    //只拉伸宽度 不拉伸间距
                    sbvtgFrame.width += addXFill
                    
                    if j != startIndex - count
                    {
                        sbvtgFrame.leading += addXFill * CGFloat(j - (startIndex - count))
                    }
                }
                else {
                    //只拉伸间距
                    sbvtgFrame.leading += addXPosInc * CGFloat(j - (startIndex - count))
                    if (startIndex - count) > 0 && applyLastlineGravityPolicy && lsc.tg_lastlineGravityPolicy == TGGravityPolicy.auto {
                        //对齐前一行对应位置的
                        sbvtgFrame.leading = sbs[j - lsc.tg_arrangedCount].tgFrame.leading
                    }
                }
                
                let topSpace = sbvsc.top.absPos
                let bottomSpace = sbvsc.bottom.absPos
                
                switch sbvVertAlignment {
                case TGGravity.vert.center:
                    sbvtgFrame.top += (rowMaxHeight - topSpace - bottomSpace - sbvtgFrame.height) / 2
                    break
                case TGGravity.vert.bottom:
                    sbvtgFrame.top += rowMaxHeight - topSpace - bottomSpace - sbvtgFrame.height
                    break
                case TGGravity.vert.fill:
                    sbvtgFrame.height =  self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rowMaxHeight - topSpace - bottomSpace, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    break
                default:
                    break
                }
            }
        }
    }

    
    //计算Horz下每行的水平对齐方式。
    fileprivate func tgCalcHorzLayoutSinglelineAlignment(_ selfSize:CGSize, colMaxHeight:CGFloat, colMaxWidth:CGFloat, vertGravity:TGGravity, horzAlignment:TGGravity, sbs:[UIView], startIndex:Int, count:Int, vertSpace:CGFloat, horzSpace:CGFloat, vertPadding:CGFloat, isEstimate:Bool, lsc:TGFlowLayoutViewSizeClassImpl) {
        var addYPos:CGFloat = 0
        var addYPosInc:CGFloat = 0
        var addYFill:CGFloat = 0
        let averageArrange = (vertGravity == TGGravity.vert.fill)
        //只有最后一行，并且数量小于tg_arrangedCount，并且不是第一行才应用策略。
        let applyLastlineGravityPolicy:Bool = (startIndex == sbs.count &&
            count != lsc.tg_arrangedCount &&
            (vertGravity == TGGravity.vert.between || vertGravity == TGGravity.vert.around || vertGravity == TGGravity.vert.among || vertGravity == TGGravity.vert.fill))

        
        if !averageArrange || lsc.tg_arrangedCount == 0 {
            switch vertGravity {
            case TGGravity.vert.center:
                addYPos = (selfSize.height - vertPadding - colMaxHeight)/2
                break
            case TGGravity.vert.bottom:
                addYPos = selfSize.height - vertPadding - colMaxHeight
                break
            case TGGravity.vert.between:
                if count > 1 && (!applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always) {
                    addYPosInc = (selfSize.height - vertPadding - colMaxHeight)/(CGFloat(count) - 1)
                }
                break
            case TGGravity.vert.around:
                if !applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always {
                    if count > 1 {
                        addYPosInc = (selfSize.height - vertPadding - colMaxHeight)/CGFloat(count)
                        addYPos = addYPosInc / 2.0
                    } else {
                        addYPos = (selfSize.height - vertPadding - colMaxHeight) / 2.0
                    }
                }
                break
            case TGGravity.vert.among:
                if !applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always {
                    if count > 1 {
                        addYPosInc = (selfSize.height - vertPadding - colMaxHeight)/CGFloat(count + 1)
                        addYPos = addYPosInc
                    } else {
                        addYPos = (selfSize.height - vertPadding - colMaxHeight) / 2.0
                    }
                }
                break
            default:
                break
            }
            
            //处理内容拉伸的情况
            if lsc.tg_arrangedCount == 0 && averageArrange && count > 0 {
                if !applyLastlineGravityPolicy || lsc.tg_lastlineGravityPolicy == TGGravityPolicy.always {
                    addYFill = (selfSize.height - vertPadding - colMaxHeight)/CGFloat(count)
                }
            }
        }
        
        //调整位置
        for j in startIndex - count ..< startIndex {
            let sbv:UIView = sbs[j]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            
            if !isEstimate && self.tg_intelligentBorderline != nil {
                
                
                if let sbvl = sbv as? TGBaseLayout {
                    if !sbvl.tg_notUseIntelligentBorderline {
                        sbvl.tg_leadingBorderline = nil
                        sbvl.tg_topBorderline = nil
                        sbvl.tg_trailingBorderline = nil
                        sbvl.tg_bottomBorderline = nil
                        
                        //如果不是最后一行就画下面，
                        if (j < startIndex - 1)
                        {
                            sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果不是最后一列就画右边,
                        if (startIndex != sbs.count )
                        {
                            sbvl.tg_trailingBorderline = self.tg_intelligentBorderline;
                        }
                        
                        //如果最后一行的最后一个没有满列数时
                        if (j == sbs.count - 1 && lsc.tg_arrangedCount != count )
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
                            sbvl.tg_leadingBorderline = self.tg_intelligentBorderline;
                        }
                        
                    }
                }
            }
            
            //为子视图设置单独的对齐方式
            var sbvHorzAlignment = self.tgConvertLeftRightGravityToLeadingTrailing(sbvsc.tg_alignment & TGGravity.vert.mask)
            if sbvHorzAlignment == TGGravity.none
            {
                sbvHorzAlignment = horzAlignment
            }
            if horzAlignment == TGGravity.vert.between
            {
                sbvHorzAlignment = horzAlignment
            }
            
            if (sbvHorzAlignment != TGGravity.none && sbvHorzAlignment != TGGravity.horz.leading) || _tgCGFloatNotEqual(addYPos, 0) ||
               _tgCGFloatNotEqual(addYFill, 0) ||
            _tgCGFloatNotEqual(addYPosInc, 0) || applyLastlineGravityPolicy
            {
                sbvtgFrame.top += addYPos
                
                if lsc.tg_arrangedCount == 0 && averageArrange {
                    //只拉伸宽度不拉伸间距
                    sbvtgFrame.height += addYFill
                    
                    if j != startIndex - count {
                        sbvtgFrame.top += addYFill * CGFloat(j - (startIndex - count))
                    }
                }
                else {
                    //只拉伸间距
                    sbvtgFrame.top += addYPosInc * CGFloat(j - (startIndex - count))
                    if (startIndex - count) > 0 && applyLastlineGravityPolicy && lsc.tg_lastlineGravityPolicy == TGGravityPolicy.auto {
                        //对齐前一行对应位置的
                        sbvtgFrame.top = sbs[j - lsc.tg_arrangedCount].tgFrame.top
                    }
                }
                
                let leadingSpace = sbvsc.leading.absPos
                let trailingSpace = sbvsc.trailing.absPos
                
                switch sbvHorzAlignment {
                case TGGravity.horz.center:
                    sbvtgFrame.leading += (colMaxWidth - leadingSpace  - trailingSpace - sbvtgFrame.width)/2
                    break
                case TGGravity.horz.trailing:
                    sbvtgFrame.leading += colMaxWidth - leadingSpace - trailingSpace - sbvtgFrame.width
                    break
                case TGGravity.horz.fill:
                    sbvtgFrame.width =  self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: colMaxWidth - leadingSpace - trailingSpace, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    break
                default:
                    break
                }
                
            }
        }
    }
    
    
    fileprivate func tgCalcVertLayoutSinglelineWeight(selfSize:CGSize, totalFloatWidth:CGFloat, totalWeight:CGFloat,sbs:[UIView],startIndex:NSInteger, count:NSInteger)
    {
        var totalFloatWidth = totalFloatWidth
        var totalWeight = totalWeight
        for j in startIndex - count ..< startIndex {
            let sbv:UIView = sbs[j]
            
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            if sbvsc.width.weightVal != nil || sbvsc.width.isFill
            {
                var widthWeight:CGFloat = 1.0
                if let t = sbvsc.width.weightVal
                {
                    widthWeight = t.rawValue/100
                }
                
                let tempWidth = sbvsc.width.measure(_tgRoundNumber(totalFloatWidth * ( widthWeight / totalWeight)))
                
                totalFloatWidth -= tempWidth
                totalWeight -= widthWeight
                
                sbvtgFrame.width =  self.tgValidMeasure(sbvsc.width, sbv:sbv,calcSize:tempWidth,sbvSize:sbvtgFrame.frame.size,selfLayoutSize:selfSize)
                sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width;
            }
        }
    }
    
    fileprivate func tgCalcHorzLayoutSinglelineWeight(selfSize:CGSize, totalFloatHeight:CGFloat, totalWeight:CGFloat,sbs:[UIView],startIndex:NSInteger, count:NSInteger)
    {
        var totalFloatHeight = totalFloatHeight
        var totalWeight = totalWeight
        
        for j in startIndex - count ..< startIndex {
            let sbv:UIView = sbs[j]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            if sbvsc.height.weightVal != nil || sbvsc.height.isFill
            {
                var heightWeight:CGFloat = 1.0
                if let t = sbvsc.height.weightVal
                {
                    heightWeight = t.rawValue / 100
                }
                
                let tempHeight = sbvsc.height.measure(_tgRoundNumber(totalFloatHeight * ( heightWeight / totalWeight)))
                
                totalFloatHeight -= tempHeight
                totalWeight -= heightWeight
                
                sbvtgFrame.height =  self.tgValidMeasure(sbvsc.height,sbv:sbv,calcSize:tempHeight,sbvSize:sbvtgFrame.frame.size,selfLayoutSize:selfSize)
                sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height;
                
                if sbvsc.width.isRelaSizeEqualTo(sbvsc.height)
                {
                    sbvtgFrame.width = self.tgValidMeasure(sbvsc.width,sbv:sbv,calcSize:sbvsc.width.measure(sbvtgFrame.height),sbvSize:sbvtgFrame.frame.size,selfLayoutSize:selfSize)
                }
                
            }
        }
    }
    
    fileprivate func tgLayoutSubviewsForVert(_ selfSize:CGSize, sbs:[UIView], isEstimate:Bool, lsc:TGFlowLayoutViewSizeClassImpl)->CGSize {
        
        var selfSize = selfSize
        let autoArrange:Bool = lsc.tg_autoArrange
        let arrangedCount:Int = lsc.tg_arrangedCount
        
        var leadingPadding:CGFloat = lsc.tgLeadingPadding
        var trailingPadding:CGFloat = lsc.tgTrailingPadding
        let topPadding:CGFloat = lsc.tgTopPadding
        let bottomPadding:CGFloat = lsc.tgBottomPadding
        
        var vertGravity:TGGravity = lsc.tg_gravity & TGGravity.horz.mask
        let horzGravity:TGGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let vertAlignment:TGGravity = lsc.tg_arrangedGravity & TGGravity.horz.mask
        
        var horzSpace = lsc.tg_hspace
        let vertSpace = lsc.tg_vspace
        var subviewSize:CGFloat = 0.0
        if let t = lsc.tgFlexSpace, sbs.count > 0 {
           (subviewSize,leadingPadding,trailingPadding,horzSpace) = t.calcMaxMinSubviewSize(selfSize.width, arrangedCount: arrangedCount, startPadding: leadingPadding, endPadding: trailingPadding, space: horzSpace)
        }
        
        var rowMaxHeight:CGFloat = 0
        var rowMaxWidth:CGFloat = 0
        var xPos:CGFloat = leadingPadding
        var yPos:CGFloat = topPadding
        var maxWidth = leadingPadding
        var maxHeight = topPadding
        
        //判断父滚动视图是否分页滚动
        var isPagingScroll = false
        if let scrolv = self.superview as? UIScrollView, scrolv.isPagingEnabled
        {
            isPagingScroll = true
        }
        
        var pagingItemHeight:CGFloat = 0
        var pagingItemWidth:CGFloat = 0
        var isVertPaging = false
        var isHorzPaging = false
        if lsc.tg_pagedCount > 0 && self.superview != nil
        {
            let rows = CGFloat(lsc.tg_pagedCount / arrangedCount)  //每页的行数。
            
            //对于垂直流式布局来说，要求要有明确的宽度。因此如果我们启用了分页又设置了宽度包裹时则我们的分页是从左到右的排列。否则分页是从上到下的排列。
            if lsc.width.isWrap
            {
                isHorzPaging = true
                if isPagingScroll
                {
                    pagingItemWidth = (self.superview!.bounds.width - leadingPadding - trailingPadding - CGFloat(arrangedCount - 1) * horzSpace ) / CGFloat(arrangedCount)
                }
                else
                {
                    pagingItemWidth = (self.superview!.bounds.width - leadingPadding - CGFloat(arrangedCount) * horzSpace ) / CGFloat(arrangedCount)
                }
                
                pagingItemHeight = (selfSize.height - topPadding - bottomPadding - (rows - 1) * vertSpace) / rows
            }
            else
            {
                isVertPaging = true
                pagingItemWidth = (selfSize.width - leadingPadding - trailingPadding - CGFloat(arrangedCount - 1) * horzSpace) / CGFloat(arrangedCount)
                //分页滚动时和非分页滚动时的高度计算是不一样的。
                if (isPagingScroll)
                {
                    pagingItemHeight = (self.superview!.bounds.height - topPadding - bottomPadding - (rows - 1) * vertSpace) / CGFloat(rows)
                }
                else
                {
                    pagingItemHeight = (self.superview!.bounds.height - topPadding - rows * vertSpace) / rows
                }
            }
        }

        
        let averageArrange = (horzGravity == TGGravity.horz.fill)
        
        var arrangedIndex:Int = 0
        var rowTotalWeight:CGFloat = 0
        var rowTotalFixedWidth:CGFloat = 0
        
        for i in 0..<sbs.count
        {
            let sbv:UIView = sbs[i]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            if (arrangedIndex >= arrangedCount)
            {
                arrangedIndex = 0;
                
                if (rowTotalWeight != 0 && !averageArrange)
                {
                    self.tgCalcVertLayoutSinglelineWeight(selfSize:selfSize,totalFloatWidth:selfSize.width - leadingPadding - trailingPadding - rowTotalFixedWidth,totalWeight:rowTotalWeight,sbs:sbs,startIndex:i,count:arrangedCount)
                }
                
                rowTotalWeight = 0;
                rowTotalFixedWidth = 0;
                
            }
            
            let  leadingSpace = sbvsc.leading.absPos
            let  trailingSpace = sbvsc.trailing.absPos
            var  rect = sbvtgFrame.frame
            
            
            if sbvsc.width.weightVal != nil || sbvsc.width.isFill
            {
                if sbvsc.width.isFill
                {
                    rowTotalWeight += 1.0
                }
                else
                {
                    rowTotalWeight += sbvsc.width.weightVal.rawValue / 100
                }
            }
            else
            {
                if subviewSize != 0
                {
                    rect.size.width = subviewSize - leadingSpace - trailingSpace
                }
                
                if pagingItemWidth != 0
                {
                    rect.size.width = pagingItemWidth - leadingSpace - trailingSpace
                }
                
                if sbvsc.width.numberVal != nil && !averageArrange
                {
                    rect.size.width = sbvsc.width.measure;
                }
                
                rect = tgSetSubviewRelativeSize(sbvsc.width, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc,rect: rect)
                
                rect.size.width = self.tgValidMeasure(sbvsc.width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
                
                rowTotalFixedWidth += rect.size.width;
            }
            
            rowTotalFixedWidth += leadingSpace + trailingSpace;
            
            if (arrangedIndex != (arrangedCount - 1))
            {
                rowTotalFixedWidth += horzSpace
            }
            
            sbvtgFrame.frame = rect;
            
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
            
            self.tgCalcVertLayoutSinglelineWeight(selfSize:selfSize,totalFloatWidth:selfSize.width - leadingPadding - trailingPadding - rowTotalFixedWidth,totalWeight:rowTotalWeight,sbs:sbs,startIndex:sbs.count, count:arrangedIndex)
        }
        
        var nextPointOfRows:[CGPoint]! = nil
        if autoArrange
        {
            nextPointOfRows = [CGPoint]()
            for _ in 0 ..< arrangedCount
            {
                nextPointOfRows.append(CGPoint(x:leadingPadding, y: topPadding))
            }
        }
        
        var pageWidth:CGFloat = 0;  //页宽
        let averageWidth:CGFloat = (selfSize.width - leadingPadding - trailingPadding - (CGFloat(arrangedCount) - 1) * horzSpace) / CGFloat(arrangedCount)
        
        arrangedIndex = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            //换行
            if arrangedIndex >= arrangedCount {
                arrangedIndex = 0
                yPos += rowMaxHeight
                yPos += vertSpace
                
                
                //分别处理水平分页和垂直分页。
                if (isHorzPaging)
                {
                    if (i % lsc.tg_pagedCount == 0)
                    {
                        pageWidth += self.superview!.bounds.width
                        
                        if (!isPagingScroll)
                        {
                            pageWidth -= leadingPadding
                        }
                        
                        yPos = topPadding
                    }
                    
                }
                
                if (isVertPaging)
                {
                    //如果是分页滚动则要多添加垂直间距。
                    if (i % lsc.tg_pagedCount == 0)
                    {
                        
                        if (isPagingScroll)
                        {
                            yPos -= vertSpace
                            yPos += bottomPadding
                            yPos += topPadding
                        }
                    }
                }
                
                
                xPos = leadingPadding + pageWidth

                
                //计算每行的gravity情况
                self .tgCalcVertLayoutSinglelineAlignment(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, horzGravity: horzGravity, vertAlignment: vertAlignment, sbs: sbs, startIndex: i, count: arrangedCount, vertSpace: vertSpace, horzSpace: horzSpace, horzPadding: leadingPadding + trailingPadding, isEstimate: isEstimate, lsc:lsc)
                
                rowMaxHeight = 0
                rowMaxWidth = 0
            }
            
            let topSpace = sbvsc.top.absPos
            let leadingSpace = sbvsc.leading.absPos
            let bottomSpace = sbvsc.bottom.absPos
            let trailingSpace = sbvsc.trailing.absPos
            
            var rect = sbvtgFrame.frame
            
            if (pagingItemHeight != 0)
            {
                rect.size.height = pagingItemHeight - topSpace - bottomSpace
            }


            rect.size.height = sbvsc.height.numberSize(rect.size.height)

            
            if averageArrange {
                rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: averageWidth - leadingSpace - trailingSpace, sbvSize: rect.size, selfLayoutSize:selfSize)
            }
            
            rect = tgSetSubviewRelativeSize(sbvsc.height, selfSize: selfSize,sbvsc:sbvsc,lsc:lsc, rect: rect)
            
            //如果高度是浮动的 则需要调整陶都
            if sbvsc.height.isFlexHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            if sbvsc.height.weightVal != nil || sbvsc.height.isFill
            {
                var heightWeight:CGFloat = 1.0
                if let t = sbvsc.height.weightVal
                {
                    heightWeight = t.rawValue/100
                }
                
                rect.size.height = sbvsc.height.measure((selfSize.height - yPos - bottomPadding)*heightWeight - topSpace - bottomSpace)
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if _tgCGFloatLess(rowMaxHeight , topSpace + bottomSpace + rect.size.height) {
                rowMaxHeight = topSpace + bottomSpace + rect.size.height
            }
            
            if autoArrange
            {
                var minPt:CGPoint = CGPoint(x:CGFloat.greatestFiniteMagnitude, y:CGFloat.greatestFiniteMagnitude)
                var minNextPointIndex:Int = 0
                for idx in 0 ..< arrangedCount
                {
                    let pt = nextPointOfRows[idx]
                    if minPt.y > pt.y
                    {
                        minPt = pt
                        minNextPointIndex = idx
                    }
                }
                
                xPos = minPt.x
                yPos = minPt.y
                
                minPt.y = minPt.y + topSpace + rect.size.height + bottomSpace + vertSpace
                nextPointOfRows[minNextPointIndex] = minPt
                if minNextPointIndex + 1 <= arrangedCount - 1
                {
                    minPt = nextPointOfRows[minNextPointIndex + 1]
                    minPt.x = xPos + leadingSpace + rect.size.width + trailingSpace + horzSpace
                    nextPointOfRows[minNextPointIndex + 1] = minPt
                }
                
                if _tgCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace)
                {
                    maxHeight = yPos + topSpace + rect.size.height + bottomSpace
                }
                
            }
            else if vertAlignment == TGGravity.vert.between
            {
                //当行是紧凑排行时需要特殊处理当前的垂直位置。
                //第0行特殊处理。
                if (i - arrangedCount < 0)
                {
                    yPos = topPadding
                }
                else
                {
                    //取前一行的对应的列的子视图。
                    let (prevSbvtgFrame, prevSbvsc) = self.tgGetSubviewFrameAndSizeClass(sbs[i - arrangedCount])
                    //当前子视图的位置等于前一行对应列的最大y的值 + 前面对应列的尾部间距 + 子视图之间的行间距。
                    yPos =  prevSbvtgFrame.frame.maxY + prevSbvsc.bottom.absPos + vertSpace
                }
                
                if _tgCGFloatLess(maxHeight, yPos + topSpace + rect.size.height + bottomSpace)
                {
                    maxHeight = yPos + topSpace + rect.size.height + bottomSpace
                }
            }
            else
            {
                maxHeight = yPos + rowMaxHeight
            }
            
            rect.origin.x = (xPos + leadingSpace)
            rect.origin.y = (yPos + topSpace)
            xPos += (leadingSpace + rect.size.width + trailingSpace)
            
            if _tgCGFloatLess(rowMaxWidth , xPos - leadingPadding) {
                rowMaxWidth = xPos - leadingPadding
            }
            if _tgCGFloatLess(maxWidth , xPos)
            {
                maxWidth = xPos
            }
            
            if arrangedIndex != (arrangedCount - 1) && !autoArrange {
                xPos += horzSpace
            }
            
            sbvtgFrame.frame = rect
            arrangedIndex += 1
        }
        
        //最后一行 布局
        self .tgCalcVertLayoutSinglelineAlignment(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, horzGravity: horzGravity, vertAlignment: vertAlignment, sbs: sbs, startIndex: sbs.count, count: arrangedIndex, vertSpace: vertSpace, horzSpace: horzSpace, horzPadding: leadingPadding + trailingPadding, isEstimate: isEstimate, lsc:lsc)
        
        maxHeight = maxHeight + bottomPadding
        
        if lsc.height.isWrap
        {
            selfSize.height = maxHeight
            
            //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
            if (isVertPaging && isPagingScroll)
            {
                //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
                let totalPages:CGFloat = floor(CGFloat(sbs.count + lsc.tg_pagedCount - 1 ) / CGFloat(lsc.tg_pagedCount))
                if _tgCGFloatLess(selfSize.height , totalPages * self.superview!.bounds.height)
                {
                    selfSize.height = totalPages * self.superview!.bounds.height
                }
            }

            
        }
        else {
            var addYPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            let arranges = floor(CGFloat(sbs.count + arrangedCount - 1) / CGFloat(arrangedCount))
            
            if arranges <= 1 && vertGravity == TGGravity.vert.around
            {
                vertGravity = TGGravity.vert.center
            }
            
            if vertGravity == TGGravity.vert.center {
                addYPos = (selfSize.height - maxHeight)/2
            }
            else if vertGravity == TGGravity.vert.bottom {
                addYPos = selfSize.height - maxHeight
            }
            else if (vertGravity == TGGravity.vert.fill)
            {
                if (arranges > 0)
                {
                   fill = (selfSize.height - maxHeight) / arranges
                }
            }
            else if (vertGravity == TGGravity.vert.between)
            {
                if (arranges > 1)
                {
                   between = (selfSize.height - maxHeight) / (arranges - 1)
                }
            }
            else if (vertGravity == TGGravity.vert.around)
            {
                between = (selfSize.height - maxHeight) / arranges
            }
            else if (vertGravity == TGGravity.vert.among)
            {
                between = (selfSize.height - maxHeight) / (arranges + 1)
            }

            
            if addYPos != 0 || between != 0 || fill != 0
            {
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    let sbvtgFrame = sbv.tgFrame
                    let line = i / arrangedCount
                    
                    sbvtgFrame.height += fill
                    sbvtgFrame.top += fill * CGFloat(line)
                    sbvtgFrame.top += addYPos
                    sbvtgFrame.top += between * CGFloat(line)
                    
                    //如果是vert_around那么所有行都应该添加一半的between值。
                    if (vertGravity == TGGravity.vert.around)
                    {
                        sbvtgFrame.top += (between / 2.0)
                    }
                    
                    if (vertGravity == TGGravity.vert.among)
                    {
                        sbvtgFrame.top += between
                    }
                }
            }
        }
        
        if lsc.width.isWrap && !averageArrange
        {
            selfSize.width = maxWidth + trailingPadding
            
            //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
            if (isHorzPaging && isPagingScroll)
            {
                //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
                let totalPages:CGFloat = floor(CGFloat(sbs.count + lsc.tg_pagedCount - 1 ) / CGFloat(lsc.tg_pagedCount))
                if _tgCGFloatLess(selfSize.width , totalPages * self.superview!.bounds.width)
                {
                    selfSize.width = totalPages * self.superview!.bounds.width
                }
            }
        }
        return selfSize
    }

    fileprivate func tgLayoutSubviewsForVertContent(_ selfSize:CGSize, sbs:[UIView], isEstimate:Bool, lsc:TGFlowLayoutViewSizeClassImpl)->CGSize {
        
        var selfSize = selfSize
        var leadingPadding:CGFloat = lsc.tgLeadingPadding
        var trailingPadding:CGFloat = lsc.tgTrailingPadding
        let topPadding:CGFloat = lsc.tgTopPadding
        let bottomPadding:CGFloat = lsc.tgBottomPadding
        
        var vertGravity:TGGravity = lsc.tg_gravity & TGGravity.horz.mask
        let horzGravity:TGGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let vertAlignment:TGGravity = lsc.tg_arrangedGravity & TGGravity.horz.mask
    
        
        var horzSpace = lsc.tg_hspace
        let vertSpace = lsc.tg_vspace
        var subviewSize:CGFloat = 0.0
        if let t = lsc.tgFlexSpace, sbs.count > 0 {
           (subviewSize,leadingPadding,trailingPadding,horzSpace) = t.calcMaxMinSubviewSizeForContent(selfSize.width, startPadding: leadingPadding, endPadding: trailingPadding, space: horzSpace)
        }
        
        var xPos:CGFloat = leadingPadding
        var yPos:CGFloat = topPadding
        var rowMaxHeight:CGFloat = 0
        var rowMaxWidth:CGFloat = 0

        var arrangeIndexSet = IndexSet()
        var arrangeIndex:Int = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            let topSpace:CGFloat = sbvsc.top.absPos
            let leadingSpace:CGFloat = sbvsc.leading.absPos
            let bottomSpace:CGFloat = sbvsc.bottom.absPos
            let trailingSpace:CGFloat = sbvsc.trailing.absPos
            
            var rect:CGRect = sbvtgFrame.frame
            
            if subviewSize != 0
            {
                rect.size.width = subviewSize - leadingSpace - trailingSpace
            }
            
            rect.size.width = sbvsc.width.numberSize(rect.size.width)
            rect.size.height = sbvsc.height.numberSize(rect.size.height)

            
            rect = tgSetSubviewRelativeSize(sbvsc.width, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc, rect: rect)
            rect = tgSetSubviewRelativeSize(sbvsc.height, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc, rect: rect)

            if sbvsc.height.weightVal != nil || sbvsc.height.isFill
            {
                var heightWeight:CGFloat = 1.0
                if let t = sbvsc.height.weightVal
                {
                    heightWeight = t.rawValue/100
                }
                
               rect.size.height = sbv.tg_height.measure((selfSize.height - yPos - bottomPadding)*heightWeight - topSpace - bottomSpace)
            }
            
            if sbvsc.width.weightVal != nil || sbvsc.width.isFill
            {
                //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
                var floatWidth = selfSize.width - trailingPadding - xPos - leadingSpace - trailingSpace;
                if arrangeIndex != 0 {
                    floatWidth -= horzSpace
                }
                
                if  _tgCGFloatLessOrEqual(floatWidth, 0){
                    floatWidth  = selfSize.width - leadingPadding - trailingPadding
                }
                
                var widthWeight:CGFloat = 1.0
                if let t = sbvsc.width.weightVal{
                    widthWeight = t.rawValue/100
                }
                
                rect.size.width = (floatWidth + sbvsc.width.increment) * widthWeight - leadingSpace - trailingSpace;
            }
            
            
            rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if sbvsc.height.isRelaSizeEqualTo(sbvsc.width)
            {
                rect.size.height = sbvsc.height.measure(rect.size.width)
            }
            
            //如果高度是浮动则需要调整
            if sbvsc.height.isFlexHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算xPos的值加上leadingSpace + rect.size.width + trailingSpace + lsc.tg_hspace 的值要小于整体的宽度。
            var place:CGFloat = xPos + leadingSpace + rect.size.width + trailingSpace
            if arrangeIndex != 0 {
                place += horzSpace
            }
            place += trailingPadding
            
            //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
            if place - selfSize.width > 0.0001
            {
                xPos = leadingPadding
                yPos += vertSpace
                yPos += rowMaxHeight
                
                arrangeIndexSet.insert(i - arrangeIndex)
                //计算每行Gravity情况
                self .tgCalcVertLayoutSinglelineAlignment(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, horzGravity: horzGravity, vertAlignment: vertAlignment, sbs: sbs, startIndex: i, count: arrangeIndex, vertSpace: vertSpace, horzSpace: horzSpace, horzPadding: leadingPadding + trailingPadding, isEstimate: isEstimate, lsc:lsc)
                
                //计算单独的sbv的宽度是否大于整体的宽度。如果大于则缩小宽度。
                if _tgCGFloatGreat(leadingSpace + trailingSpace + rect.size.width , selfSize.width - leadingPadding - trailingPadding)
                {
                    rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: selfSize.width - leadingPadding - trailingPadding - leadingSpace - trailingSpace, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                    if sbvsc.height.isFlexHeight
                    {
                        rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
                        rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                        
                    }
                }
                
                rowMaxHeight = 0
                rowMaxWidth = 0
                arrangeIndex = 0
            }
            
            if arrangeIndex != 0 {
                xPos += horzSpace
            }
            
            rect.origin.x = xPos + leadingSpace
            rect.origin.y = yPos + topSpace
            xPos += leadingSpace + rect.size.width + trailingSpace
            
            if _tgCGFloatLess(rowMaxHeight , topSpace + bottomSpace + rect.size.height) {
                rowMaxHeight = topSpace + bottomSpace + rect.size.height;
            }
            if _tgCGFloatLess(rowMaxWidth , xPos - leadingPadding) {
                rowMaxWidth = xPos - leadingPadding
            }
            
            sbvtgFrame.frame = rect;
            arrangeIndex += 1
        }
        
        //设置最后一行
        arrangeIndexSet.insert(sbs.count - arrangeIndex)
        self .tgCalcVertLayoutSinglelineAlignment(selfSize, rowMaxHeight: rowMaxHeight, rowMaxWidth: rowMaxWidth, horzGravity: horzGravity, vertAlignment: vertAlignment, sbs: sbs, startIndex:sbs.count, count: arrangeIndex, vertSpace: vertSpace, horzSpace: horzSpace, horzPadding:leadingPadding + trailingPadding, isEstimate: isEstimate, lsc:lsc)
        
        if lsc.height.isWrap {
            selfSize.height = yPos + bottomPadding + rowMaxHeight;
        }
        else {
            var addYPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            
            if arrangeIndexSet.count <= 1 && vertGravity == TGGravity.vert.around
            {
                vertGravity = TGGravity.vert.center
            }
            
            if vertGravity == TGGravity.vert.center {
                addYPos = (selfSize.height - bottomPadding - rowMaxHeight - yPos)/2
            }
            else if vertGravity == TGGravity.vert.bottom {
                addYPos = selfSize.height - bottomPadding - rowMaxHeight - yPos
            }
            else if vertGravity == TGGravity.vert.fill {
            
                if arrangeIndexSet.count > 0
                {
                   fill = (selfSize.height - bottomPadding - rowMaxHeight - yPos) / CGFloat(arrangeIndexSet.count)
                }
            }
            else if (vertGravity == TGGravity.vert.between)
            {
                if arrangeIndexSet.count > 1
                {
                   between = (selfSize.height - bottomPadding - rowMaxHeight - yPos) / CGFloat(arrangeIndexSet.count - 1)
                }
            }
            else if (vertGravity == TGGravity.vert.around)
            {
                between = (selfSize.height - bottomPadding - rowMaxHeight - yPos) / CGFloat(arrangeIndexSet.count)
            }
            else if (vertGravity == TGGravity.vert.among)
            {
                between = (selfSize.height - bottomPadding - rowMaxHeight - yPos) / CGFloat(arrangeIndexSet.count + 1)
            }
                
            
            if addYPos != 0 || between != 0  || fill != 0
            {
                var line:CGFloat = 0
                var lastIndex:Int = 0
                
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    let sbvtgFrame = sbv.tgFrame
                    sbvtgFrame.top += addYPos
                    
                    let index = arrangeIndexSet.integerLessThanOrEqualTo(i)
                    if lastIndex != index
                    {
                        lastIndex = index!
                        line += 1
                    }
                    
                    sbvtgFrame.height += fill
                    sbvtgFrame.top += fill * line
                    sbvtgFrame.top += between * line
                    
                    //如果是vert_around那么所有行都应该添加一半的between值。
                    if (vertGravity == TGGravity.vert.around)
                    {
                        sbvtgFrame.top += (between / 2.0)
                    }
                    
                    if (vertGravity == TGGravity.vert.among)
                    {
                        sbvtgFrame.top += between
                    }
                }
            }
        }
        
        return selfSize
    }
    
    fileprivate func tgLayoutSubviewsForHorz(_ selfSize:CGSize, sbs:[UIView], isEstimate:Bool, lsc:TGFlowLayoutViewSizeClassImpl)->CGSize {
        
        var selfSize = selfSize
        let autoArrange:Bool = lsc.tg_autoArrange
        let arrangedCount:Int = lsc.tg_arrangedCount
        
        let leadingPadding:CGFloat = lsc.tgLeadingPadding
        let trailingPadding:CGFloat = lsc.tgTrailingPadding
        var topPadding:CGFloat = lsc.tgTopPadding
        var bottomPadding:CGFloat = lsc.tgBottomPadding
        
        let vertGravity:TGGravity = lsc.tg_gravity & TGGravity.horz.mask
        var horzGravity:TGGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let horzAlignment:TGGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_arrangedGravity & TGGravity.vert.mask)

        let horzSpace = lsc.tg_hspace
        var vertSpace = lsc.tg_vspace
        var subviewSize:CGFloat = 0.0
        if let t = lsc.tgFlexSpace, sbs.count > 0 {
           (subviewSize,topPadding,bottomPadding,vertSpace) = t.calcMaxMinSubviewSize(selfSize.height, arrangedCount: arrangedCount, startPadding: topPadding, endPadding: bottomPadding, space: vertSpace)
        }
        
        var colMaxWidth:CGFloat = 0
        var colMaxHeight:CGFloat = 0
        var xPos:CGFloat = leadingPadding
        var yPos:CGFloat = topPadding
        var maxHeight:CGFloat = topPadding
        var maxWidth:CGFloat = leadingPadding
        
        //判断父滚动视图是否分页滚动
        var isPagingScroll = false
        if let scrolv = self.superview as? UIScrollView, scrolv.isPagingEnabled
        {
            isPagingScroll = true
        }
        
        var pagingItemHeight:CGFloat = 0
        var pagingItemWidth:CGFloat = 0
        var isVertPaging = false
        var isHorzPaging = false
        if lsc.tg_pagedCount > 0 && self.superview != nil
        {
            let cols = CGFloat(lsc.tg_pagedCount / arrangedCount)  //每页的列数。
            
            //对于水平流式布局来说，要求要有明确的高度。因此如果我们启用了分页又设置了高度包裹时则我们的分页是从上到下的排列。否则分页是从左到右的排列。
            if lsc.height.isWrap
            {
                isVertPaging = true
                if isPagingScroll
                {
                    pagingItemHeight = (self.superview!.bounds.height - topPadding - bottomPadding - CGFloat(arrangedCount - 1) * vertSpace ) / CGFloat(arrangedCount)
                }
                else
                {
                    pagingItemHeight = (self.superview!.bounds.height - topPadding - CGFloat(arrangedCount) * vertSpace ) / CGFloat(arrangedCount)
                }
                
                pagingItemWidth = (selfSize.width - leadingPadding - trailingPadding - (cols - 1) * horzSpace) / cols
            }
            else
            {
                isHorzPaging = true
                pagingItemHeight = (selfSize.height - topPadding - bottomPadding - CGFloat(arrangedCount - 1) * vertSpace) / CGFloat(arrangedCount)
                //分页滚动时和非分页滚动时的高度计算是不一样的。
                if (isPagingScroll)
                {
                    pagingItemWidth = (self.superview!.bounds.width - leadingPadding - trailingPadding - (cols - 1) * horzSpace) / cols
                }
                else
                {
                    pagingItemWidth = (self.superview!.bounds.width - leadingPadding - cols * horzSpace) / cols
                }
                
            }
            
        }

        
        let averageArrange = (vertGravity == TGGravity.vert.fill)
        
        var arrangedIndex:Int = 0
        var rowTotalWeight:CGFloat = 0
        var rowTotalFixedHeight:CGFloat = 0
        for i in 0..<sbs.count
        {
            let sbv:UIView = sbs[i]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            if (arrangedIndex >= arrangedCount)
            {
                arrangedIndex = 0;
                
                if (rowTotalWeight != 0 && !averageArrange)
                {
                    self.tgCalcHorzLayoutSinglelineWeight(selfSize:selfSize,totalFloatHeight:selfSize.height - topPadding - bottomPadding - rowTotalFixedHeight,totalWeight:rowTotalWeight,sbs:sbs,startIndex:i,count:arrangedCount)
                }
                
                rowTotalWeight = 0;
                rowTotalFixedHeight = 0;
                
            }
            
            let  topSpace = sbvsc.top.absPos
            let  bottomSpace = sbvsc.bottom.absPos
            let  leadingSpace = sbvsc.leading.absPos
            let  trailingSpace = sbvsc.trailing.absPos
            var  rect = sbvtgFrame.frame
            
            if (pagingItemWidth != 0)
            {
                rect.size.width = pagingItemWidth - leadingSpace - trailingSpace
            }
            
            rect.size.width = sbvsc.width.numberSize(rect.size.width)
            
            rect = tgSetSubviewRelativeSize(sbvsc.width, selfSize: selfSize,sbvsc:sbvsc,lsc:lsc, rect: rect)
            
            rect.size.width = self.tgValidMeasure(sbvsc.width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            
            if sbvsc.height.weightVal != nil || sbvsc.height.isFill
            {
                if sbvsc.height.isFill
                {
                    rowTotalWeight += 1.0
                }
                else
                {
                  rowTotalWeight += sbvsc.height.weightVal.rawValue/100
                }
            }
            else
            {
                
                if subviewSize != 0
                {
                  rect.size.height = subviewSize - topSpace - bottomSpace
                }
                
                if (pagingItemHeight != 0)
                {
                    rect.size.height = pagingItemHeight - topSpace - bottomSpace
                }

            
                if (sbvsc.height.numberVal != nil && !averageArrange)
                {
                    rect.size.height = sbvsc.height.measure;
                }
                
                
                rect = tgSetSubviewRelativeSize(sbvsc.height, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc, rect: rect)
                
                
                //如果高度是浮动的则需要调整高度。
                if sbvsc.height.isFlexHeight
                {
                    rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
                }
                
                rect.size.height = self.tgValidMeasure(sbvsc.height,sbv:sbv,calcSize:rect.size.height,sbvSize:rect.size,selfLayoutSize:selfSize)
                
                if sbvsc.width.isRelaSizeEqualTo(sbvsc.height)
                {
                    rect.size.width = self.tgValidMeasure(sbvsc.width,sbv:sbv,calcSize:sbvsc.width.measure(rect.size.height),sbvSize:rect.size,selfLayoutSize:selfSize)
                }
                
                rowTotalFixedHeight += rect.size.height;
            }
            
            rowTotalFixedHeight += topSpace + bottomSpace
            
            
            if (arrangedIndex != (arrangedCount - 1))
            {
                rowTotalFixedHeight += vertSpace
            }
            
            
            sbvtgFrame.frame = rect;
            
            arrangedIndex += 1
            
        }
        
        //最后一行。
        if (rowTotalWeight != 0 && !averageArrange)
        {
            if arrangedIndex < arrangedCount
            {
                rowTotalFixedHeight -= vertSpace
            }
            
            self.tgCalcHorzLayoutSinglelineWeight(selfSize:selfSize,totalFloatHeight:selfSize.height - topPadding - bottomPadding - rowTotalFixedHeight,totalWeight:rowTotalWeight,sbs:sbs,startIndex:sbs.count,count:arrangedIndex)
        }
        
        var nextPointOfRows:[CGPoint]! = nil
        if autoArrange
        {
            nextPointOfRows = [CGPoint]()
            for _ in 0 ..< arrangedCount
            {
                nextPointOfRows.append(CGPoint(x:leadingPadding, y: topPadding))
            }
        }
        
        var pageHeight:CGFloat = 0
        let averageHeight:CGFloat = (selfSize.height - topPadding - bottomPadding - (CGFloat(arrangedCount) - 1) * vertSpace) / CGFloat(arrangedCount)
        
        arrangedIndex = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            if arrangedIndex >= arrangedCount {
                arrangedIndex = 0
                xPos += colMaxWidth
                xPos += horzSpace

                
                //分别处理水平分页和垂直分页。
                if (isVertPaging)
                {
                    if (i % lsc.tg_pagedCount == 0)
                    {
                        pageHeight += self.superview!.bounds.height
                        
                        if (!isPagingScroll)
                        {
                            pageHeight -= topPadding
                        }
                        
                        xPos = leadingPadding;
                    }
                    
                }
                
                if (isHorzPaging)
                {
                    //如果是分页滚动则要多添加垂直间距。
                    if (i % lsc.tg_pagedCount == 0)
                    {
                        
                        if (isPagingScroll)
                        {
                            xPos -= horzSpace
                            xPos += trailingPadding
                            xPos += leadingPadding
                        }
                    }
                }
                
                
                yPos = topPadding + pageHeight;

                
                
                
                //计算每行Gravity情况
                self.tgCalcHorzLayoutSinglelineAlignment(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, vertGravity: vertGravity, horzAlignment: horzAlignment, sbs: sbs, startIndex: i, count: arrangedCount, vertSpace: vertSpace, horzSpace: horzSpace, vertPadding:topPadding+bottomPadding, isEstimate: isEstimate, lsc:lsc)
                
                colMaxWidth = 0
                colMaxHeight = 0
            }
            
            let topSpace:CGFloat = sbvsc.top.absPos
            let leadingSpace:CGFloat = sbvsc.leading.absPos
            let bottomSpace:CGFloat = sbvsc.bottom.absPos
            let trailingSpace:CGFloat = sbvsc.trailing.absPos

            var rect:CGRect = sbvtgFrame.frame
            
            if averageArrange {
                rect.size.height = (averageHeight - topSpace - bottomSpace)
                
                if sbvsc.width.isRelaSizeEqualTo(sbvsc.height) {
                    rect.size.width = sbvsc.width.measure(rect.size.height)
                    rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                }
            }
            
            if sbvsc.width.weightVal != nil || sbvsc.width.isFill
            {
                var widthWeight:CGFloat = 1.0
                if let t = sbvsc.width.weightVal
                {
                    widthWeight = t.rawValue/100
                }
                
                rect.size.width = sbvsc.width.measure((selfSize.width - xPos - trailingPadding)*widthWeight - leadingSpace - trailingSpace)
                rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            }

            if _tgCGFloatLess(colMaxWidth , leadingSpace + trailingSpace + rect.size.width)
            {
                colMaxWidth = leadingSpace + trailingSpace + rect.size.width
            }
            
            if autoArrange
            {
                var minPt:CGPoint = CGPoint(x:CGFloat.greatestFiniteMagnitude, y:CGFloat.greatestFiniteMagnitude)
                var minNextPointIndex:Int = 0
                for idx in 0 ..< arrangedCount
                {
                    let pt = nextPointOfRows[idx]
                    if minPt.x > pt.x
                    {
                        minPt = pt
                        minNextPointIndex = idx
                    }
                }
                
                xPos = minPt.x
                yPos = minPt.y
                
                minPt.x = minPt.x + leadingSpace + rect.size.width + trailingSpace + horzSpace;
                nextPointOfRows[minNextPointIndex] = minPt
                if minNextPointIndex + 1 <= arrangedCount - 1
                {
                    minPt = nextPointOfRows[minNextPointIndex + 1]
                    minPt.y = yPos + topSpace + rect.size.height + bottomSpace + vertSpace
                    nextPointOfRows[minNextPointIndex + 1] = minPt
                }
                
                if _tgCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace)
                {
                    maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace
                }

            }
            else if horzAlignment == TGGravity.horz.between
            {
                //当列是紧凑排列时需要特殊处理当前的水平位置。
                //第0列特殊处理。
                if (i - arrangedCount < 0)
                {
                    xPos = leadingPadding
                }
                else
                {
                    //取前一列的对应的行的子视图。
                    let (prevSbvtgFrame, prevSbvsc) = self.tgGetSubviewFrameAndSizeClass(sbs[i - arrangedCount])
                    //当前子视图的位置等于前一列对应行的最大x的值 + 前面对应行的尾部间距 + 子视图之间的列间距。
                    xPos =  prevSbvtgFrame.frame.maxX + prevSbvsc.trailing.absPos + horzSpace
                }
                
                if _tgCGFloatLess(maxWidth, xPos + leadingSpace + rect.size.width + trailingSpace)
                {
                    maxWidth = xPos + leadingSpace + rect.size.width + trailingSpace
                }
            }
            else
            {
                maxWidth = xPos + colMaxWidth
            }
            
            rect.origin.y = yPos + topSpace
            rect.origin.x = xPos + leadingSpace
            yPos += topSpace + rect.size.height + bottomSpace
        
            if _tgCGFloatLess(colMaxHeight , (yPos - topPadding)) {
                colMaxHeight = yPos - topPadding
            }
            if _tgCGFloatLess(maxHeight , yPos)
            {
                maxHeight = yPos
            }
            
            if arrangedIndex != (arrangedCount - 1) && !autoArrange {
                yPos += vertSpace
            }
        
            sbvtgFrame.frame = rect
            
            arrangedIndex += 1
        }
        
        //最后一列
        self.tgCalcHorzLayoutSinglelineAlignment(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, vertGravity: vertGravity, horzAlignment: horzAlignment, sbs: sbs, startIndex: sbs.count, count: arrangedIndex, vertSpace: vertSpace, horzSpace: horzSpace, vertPadding:topPadding+bottomPadding, isEstimate: isEstimate, lsc:lsc)
        
        if lsc.height.isWrap  && !averageArrange
        {
            selfSize.height = maxHeight + bottomPadding
            
            //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
            if (isVertPaging && isPagingScroll)
            {
                //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
                let totalPages:CGFloat = floor(CGFloat(sbs.count + lsc.tg_pagedCount - 1 ) / CGFloat(lsc.tg_pagedCount))
                if _tgCGFloatLess(selfSize.height , totalPages * self.superview!.bounds.height)
                {
                    selfSize.height = totalPages * self.superview!.bounds.height
                }
            }

        }
        
        maxWidth = maxWidth + trailingPadding
        
        if lsc.width.isWrap
        {
            selfSize.width = maxWidth
            
            //只有在父视图为滚动视图，且开启了分页滚动时才会扩充具有包裹设置的布局视图的宽度。
            if (isHorzPaging && isPagingScroll)
            {
                //算出页数来。如果包裹计算出来的宽度小于指定页数的宽度，因为要分页滚动所以这里会扩充布局的宽度。
                let totalPages:CGFloat = floor(CGFloat(sbs.count + lsc.tg_pagedCount - 1 ) / CGFloat(lsc.tg_pagedCount))
                if _tgCGFloatLess(selfSize.width , totalPages * self.superview!.bounds.width)
                {
                    selfSize.width = totalPages * self.superview!.bounds.width
                }
            }

            
        }
        else {
            var addXPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            let arranges = floor(CGFloat(sbs.count + arrangedCount - 1) / CGFloat(arrangedCount))

            if arranges <= 1 && horzGravity == TGGravity.horz.around
            {
                horzGravity = TGGravity.horz.center
            }
            
            if horzGravity == TGGravity.horz.center {
                addXPos = (selfSize.width - maxWidth) / 2
            }
            else if horzGravity == TGGravity.horz.trailing {
                addXPos = selfSize.width - maxWidth
            }
            else if (horzGravity == TGGravity.horz.fill)
            {
                if (arranges > 0)
                {
                    fill = (selfSize.width - maxWidth) / arranges
                }
            }
            else if (horzGravity == TGGravity.horz.between)
            {
                if (arranges > 1)
                {
                   between = (selfSize.width - maxWidth) / (arranges - 1)
                }
            }
            else if (horzGravity == TGGravity.horz.around)
            {
                between = (selfSize.width - maxWidth) / arranges
            }
            else if (horzGravity == TGGravity.horz.among)
            {
                between = (selfSize.width - maxWidth) / (arranges + 1)
            }
            
            
            if addXPos != 0 || between != 0 || fill != 0 {
                for i:Int in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    let sbvtgFrame = sbv.tgFrame
                    
                    let line = i / arrangedCount
                    
                    sbvtgFrame.width += fill
                    sbvtgFrame.leading += fill * CGFloat(line)
                    sbvtgFrame.leading += addXPos
                    sbvtgFrame.leading += between * CGFloat(line)
                    
                    //如果是vert_around那么所有行都应该添加一半的between值。
                    if (horzGravity == TGGravity.horz.around)
                    {
                        sbvtgFrame.leading += (between / 2.0)
                    }
                    
                    if (horzGravity == TGGravity.horz.among)
                    {
                        sbvtgFrame.leading += between
                    }
                }
            }
        }
        return selfSize
    }

    fileprivate func tgLayoutSubviewsForHorzContent(_ selfSize:CGSize, sbs:[UIView], isEstimate:Bool, lsc:TGFlowLayoutViewSizeClassImpl)->CGSize {
        
        var selfSize = selfSize
        let leadingPadding:CGFloat = lsc.tgLeadingPadding
        let trailingPadding:CGFloat = lsc.tgTrailingPadding
        var topPadding:CGFloat = lsc.tgTopPadding
        var bottomPadding:CGFloat = lsc.tgBottomPadding
        
        let vertGravity:TGGravity = lsc.tg_gravity & TGGravity.horz.mask
        var horzGravity:TGGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let horzAlignment:TGGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_arrangedGravity & TGGravity.vert.mask)

        
        //支持浮动垂直间距。
        let horzSpace = lsc.tg_hspace
        var vertSpace = lsc.tg_vspace
        var subviewSize:CGFloat = 0.0
        if let t = lsc.tgFlexSpace, sbs.count > 0 {
            (subviewSize,topPadding,bottomPadding,vertSpace) = t.calcMaxMinSubviewSizeForContent(selfSize.height, startPadding: topPadding, endPadding: bottomPadding, space: vertSpace)
        }
        
        var xPos:CGFloat = leadingPadding
        var yPos:CGFloat = topPadding
        var colMaxWidth:CGFloat = 0
        var colMaxHeight:CGFloat = 0
        

        var arrangeIndexSet = IndexSet()
        var arrangedIndex:Int = 0
        for i in 0..<sbs.count {
            let sbv:UIView = sbs[i]
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            let topSpace:CGFloat = sbvsc.top.absPos
            let leadingSpace:CGFloat = sbvsc.leading.absPos
            let bottomSpace:CGFloat = sbvsc.bottom.absPos
            let trailingSpace:CGFloat = sbvsc.trailing.absPos
            var rect:CGRect = sbvtgFrame.frame
            
            
            rect.size.width = sbvsc.width.numberSize(rect.size.width)
            
            if subviewSize != 0
            {
                rect.size.height = subviewSize - topSpace - bottomSpace
            }
            
            rect.size.height = sbvsc.height.numberSize(rect.size.height)

            
            rect = tgSetSubviewRelativeSize(sbvsc.height, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc, rect: rect)
            
            rect = tgSetSubviewRelativeSize(sbvsc.width, selfSize: selfSize, sbvsc:sbvsc, lsc:lsc, rect: rect)
            
            if  sbvsc.height.weightVal != nil || sbvsc.height.isFill
            {
                //如果过了，则表示当前的剩余空间为0了，所以就按新的一行来算。。
                var floatHeight = selfSize.height - bottomPadding - yPos - topSpace - bottomSpace
                if arrangedIndex != 0 {
                    floatHeight -= vertSpace
                }
                
                if (_tgCGFloatLessOrEqual(floatHeight, 0)){
                    floatHeight = selfSize.height - topPadding - bottomPadding
                }
                
                var heightWeight:CGFloat = 1.0
                if let t = sbvsc.height.weightVal{
                    heightWeight = t.rawValue/100
                }
                
                rect.size.height = (floatHeight + sbvsc.height.increment) * heightWeight - topSpace - bottomSpace;
            }
            
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if sbvsc.width.isRelaSizeEqualTo(sbvsc.height) {
                rect.size.width = sbvsc.width.measure(rect.size.height)
            }
            
            
            if sbvsc.width.weightVal != nil || sbvsc.width.isFill
            {
                var widthWeight:CGFloat = 1.0
                if let t = sbvsc.width.weightVal
                {
                    widthWeight = t.rawValue / 100
                }
                
                rect.size.width = sbvsc.width.measure((selfSize.width - xPos - trailingPadding)*widthWeight - leadingSpace - trailingSpace)
            }

            
            rect.size.width = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            
            //如果高度是浮动则调整
            if sbvsc.height.isFlexHeight
            {
                
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
                rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                
            }
            
            //计算yPos的值加上topSpace + rect.size.height + bottomSpace + lsc.tg_vspace 的值要小于整体的宽度。
            var place:CGFloat = yPos + topSpace + rect.size.height + bottomSpace
            if arrangedIndex != 0 {
                place += vertSpace
            }
            place += bottomPadding
            
            //sbv所占据的宽度要超过了视图的整体宽度，因此需要换行。但是如果arrangedIndex为0的话表示这个控件的整行的宽度和布局视图保持一致。
            if place - selfSize.height > 0.0001
            {
                yPos = topPadding
                xPos += horzSpace
                xPos += colMaxWidth
                
                //计算每行Gravity情况
                arrangeIndexSet.insert(i - arrangedIndex)
                self.tgCalcHorzLayoutSinglelineAlignment(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, vertGravity: vertGravity, horzAlignment: horzAlignment, sbs: sbs, startIndex: i, count: arrangedIndex, vertSpace: vertSpace, horzSpace: horzSpace, vertPadding:topPadding+bottomPadding, isEstimate: isEstimate, lsc:lsc)
                
                //计算单独的sbv的高度是否大于整体的高度。如果大于则缩小高度。
                if _tgCGFloatGreat(topSpace + bottomSpace + rect.size.height , selfSize.height - topPadding - bottomPadding)
                {
                    rect.size.height = selfSize.height - topPadding - bottomPadding - topSpace - bottomSpace
                    rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
                }
                
                colMaxWidth = 0;
                colMaxHeight = 0;
                arrangedIndex = 0;
            }
            
            if arrangedIndex != 0 {
                yPos += vertSpace
            }
            rect.origin.x = xPos + leadingSpace
            rect.origin.y = yPos + topSpace
            yPos += topSpace + rect.size.height + bottomSpace
            
            if _tgCGFloatLess(colMaxWidth , leadingSpace + trailingSpace + rect.size.width)
            {
                colMaxWidth = leadingSpace + trailingSpace + rect.size.width
            }
            
            if _tgCGFloatLess(colMaxHeight , (yPos - topPadding))
            {
                colMaxHeight = (yPos - topPadding);
            }
            sbvtgFrame.frame = rect;
            
            arrangedIndex += 1;
        }
        
        //最后一行
        arrangeIndexSet.insert(sbs.count - arrangedIndex)
        self.tgCalcHorzLayoutSinglelineAlignment(selfSize, colMaxHeight: colMaxHeight, colMaxWidth: colMaxWidth, vertGravity: vertGravity, horzAlignment: horzAlignment, sbs: sbs, startIndex: sbs.count, count: arrangedIndex, vertSpace: vertSpace, horzSpace: horzSpace, vertPadding:topPadding + bottomPadding, isEstimate: isEstimate, lsc:lsc)
        
        if lsc.width.isWrap {
            selfSize.width = xPos + trailingPadding + colMaxWidth
        }
        else {
            var addXPos:CGFloat = 0
            var between:CGFloat = 0
            var fill:CGFloat = 0
            
            if arrangeIndexSet.count <= 1 && horzGravity == TGGravity.horz.around
            {
                horzGravity = TGGravity.horz.center
            }
            
            if (horzGravity == TGGravity.horz.center)
            {
                addXPos = (selfSize.width - trailingPadding - colMaxWidth - xPos) / 2;
            }
            else if (horzGravity == TGGravity.horz.trailing)
            {
                addXPos = selfSize.width - trailingPadding - colMaxWidth - xPos;
            }
            else if (horzGravity == TGGravity.horz.fill)
            {
                if (arrangeIndexSet.count > 0)
                {
                   fill = (selfSize.width - trailingPadding - colMaxWidth - xPos) / CGFloat(arrangeIndexSet.count)
                }
            }
            else if (horzGravity == TGGravity.horz.between)
            {
                if (arrangeIndexSet.count > 1)
                {
                  between = (selfSize.width - trailingPadding - colMaxWidth - xPos) / CGFloat(arrangeIndexSet.count - 1)
                }
            }
            else if (horzGravity == TGGravity.horz.around)
            {
                between = (selfSize.width - trailingPadding - colMaxWidth - xPos) / CGFloat(arrangeIndexSet.count)
            }
            else if (horzGravity == TGGravity.horz.among)
            {
                between = (selfSize.width - trailingPadding - colMaxWidth - xPos) / CGFloat(arrangeIndexSet.count + 1)
            }

            
            if (addXPos != 0 || between != 0 || fill != 0)
            {
                var line:CGFloat = 0
                var lastIndex:Int = 0
                
                for i in 0..<sbs.count {
                    let sbv:UIView = sbs[i]
                    let sbvtgFrame = sbv.tgFrame
                    sbvtgFrame.leading += addXPos
                    
                    let index = arrangeIndexSet.integerLessThanOrEqualTo(i)
                    if lastIndex != index
                    {
                        lastIndex = index!
                        line += 1
                    }
                    
                    sbvtgFrame.width += fill
                    sbvtgFrame.leading += fill * line
                    sbvtgFrame.leading += between * line
                    
                    if (horzGravity == TGGravity.horz.around)
                    {
                        sbvtgFrame.leading += (between / 2.0)
                    }
                    
                    if (horzGravity == TGGravity.horz.among)
                    {
                        sbvtgFrame.leading += between
                    }
                }
            }
        }
        
        return selfSize
    }
}
