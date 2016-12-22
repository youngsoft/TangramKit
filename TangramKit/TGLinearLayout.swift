//
//  TGLinearLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 *线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单列(单行)布局视图，因此里面的子视图是通过添加的顺序建立约束和依赖关系的。
 *子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而子视图从左到右依次排列的线性布局视图则称为水平线性布局。
 */
open class TGLinearLayout: TGBaseLayout,TGLinearLayoutViewSizeClass {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    public init(_ orientation:TGOrientation) {
        
        super.init(frame:CGRect.zero)
        
        let lsc:TGLinearLayoutViewSizeClass = self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass
        lsc.tg_orientation = orientation
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder:aDecoder)
    }
    
    
    /**
     *线性布局的布局方向。.vert为从上到下的垂直布局，.horz为从左到右的水平布局。
     */
    public var tg_orientation:TGOrientation
        {
        get{
            return (self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass).tg_orientation
            
        }
        set
        {
            (self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass).tg_orientation = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *线性布局里面的所有子视图的整体停靠方向以及填充，所谓停靠是指布局视图里面的所有子视图整体在布局视图中的位置，系统默认的停靠是在布局视图的左上角。
     *MyMarginGravity_Vert_Top,MyMarginGravity_Vert_Center,MyMarginGravity_Vert_Bottom 表示整体垂直居上，居中，居下
     *MyMarginGravity_Horz_Left,MyMarginGravity_Horz_Center,MyMarginGravity_Horz_Right 表示整体水平居左，居中，居右
     *MyMarginGravity_Vert_Between 表示在垂直线性布局里面，每行之间的行间距都被拉伸，以便使里面的子视图垂直方向填充满整个布局视图。水平线性布局里面这个设置无效。
     *MyMarginGravity_Horz_Between 表示在水平线性布局里面，每列之间的列间距都被拉伸，以便使里面的子视图水平方向填充满整个布局视图。垂直线性布局里面这个设置无效。
     *MyMarginGravity_Vert_Fill 在垂直线性布局里面表示布局会拉伸每行子视图的高度，以便使里面的子视图垂直方向填充满整个布局视图的高度；在水平线性布局里面表示每个个子视图的高度都将和父视图保持一致，这样就不再需要设置子视图的高度了。
     *MyMarginGravity_Horz_Fill 在水平线性布局里面表示布局会拉伸每行子视图的宽度，以便使里面的子视图水平方向填充满整个布局视图的宽度；在垂直线性布局里面表示每个子视图的宽度都将和父视图保持一致，这样就不再需要设置子视图的宽度了。
     */
    public var tg_gravity:TGGravity
        {
        get
        {
            return (self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass).tg_gravity
        }
        set
        {
            (self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass).tg_gravity = newValue
            setNeedsLayout()
        }
    }
    
    
    /**
     *设置当子视图的尺寸或者位置设置为TGWeight类型时，并且有固定尺寸和间距的子视图的总和大于布局视图的高度时，如何压缩那些固定尺寸和间距的视图的方式。默认的值是：.average:表明会平均的缩小每个固定的视图的尺寸。在设置时可以进行压缩类型和压缩方式的或运算方法。具体的方法见TGSubviewsShrinkType中的各种值的定义。
     */
    public var tg_shrinkType: TGSubviewsShrinkType
    {
        get
        {
            return (self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass).tg_shrinkType
        }
        set
        {
            (self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass).tg_shrinkType = newValue
            setNeedsLayout()
        }
    }
    
    /**
     *均分子视图和间距,布局会根据里面的子视图的数量来平均分配子视图的高度或者宽度以及间距。
     *这个函数只对已经加入布局的视图有效，函数调用后新加入的子视图无效。
     *@centered参数描述是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距
     *@space参数指定子视图之间的固定间距。
     *@type参数表示设置在指定sizeClass下进行子视图和间距的均分
     */
    public func tg_equalizeSubviews(centered:Bool, withSpace space:CGFloat! = nil, inSizeClass type:TGSizeClassType = .default)
    {
        switch type {
        case .default:
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:type)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:type)
            }
        }
        
        if self.tg_orientation == .vert
        {
            tgEqualizeSubviewsForVert(centered, withSpace: space)
        }
        else
        {
            tgEqualizeSubviewsForHorz(centered, withSpace: space)
            
        }
        
        switch type {
        case .default:
            self.setNeedsLayout()
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:.default)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:.default)
            }
        }

    }
    
    /**
     *均分子视图的间距，上面函数会调整子视图的尺寸以及间距，而这个函数则是子视图的尺寸保持不变而间距自动平均分配，也就是用布局视图的剩余空间来均分间距
     *@centered参数意义同上。
     *@type参数的意义同上。
     */
    public func tg_equalizeSubviewsSpace(centered:Bool, inSizeClass type:TGSizeClassType = .default)
    {
        
        switch type {
        case .default:
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:type)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:type)
            }
        }
        
        if self.tg_orientation == .vert
        {
            tgEqualizeSubviewsSpaceForVert(centered)
        }
        else
        {
            tgEqualizeSubviewsSpaceForHorz(centered)
        }
        
        
        switch type {
        case .default:
            self.setNeedsLayout()
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:.default)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:.default)
            }
        }
    }
    
    //MARK: override method
    override internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, type:TGSizeClassType) ->(selfSize:CGSize, hasSubLayout:Bool)
    {
        var (selfSize, hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate:isEstimate, type:type)
        
        
        let sbs = self.tgGetLayoutSubviews()
        if self.tg_orientation == .vert
        {
            
            //如果是垂直的布局，但是子视图设置了左右的边距或者设置了宽度则wrapContentWidth应该设置为NO
            for sbv in sbs
            {
                
                if (sbv.tg_left.hasValue && sbv.tg_right.hasValue) ||
                    (self.tg_gravity & TGGravity.vert.mask) == TGGravity.horz.fill
                {
                    sbv.tg_width._dimeVal = nil
                }
                
                
                if !isEstimate
                {
                    sbv.tgFrame.frame = sbv.bounds;
                    self.tgCalcSizeFromSizeWrapSubview(sbv)
                }
                
                if let sbvl:TGBaseLayout = sbv as? TGBaseLayout
                {
                    if (sbvl.tg_width.isWrap || sbvl.tg_height.isWrap)
                    {
                       hasSubLayout = true
                    }
                    
                    if (isEstimate && (sbvl.tg_width.isWrap || sbvl.tg_height.isWrap))
                    {
                        _ = sbvl.tg_sizeThatFits(sbvl.tgFrame.frame.size,inSizeClass:type)
                        sbvl.tgFrame.sizeClass = sbvl.tgMatchBestSizeClass(type) //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                    }
                }
                
            }
            
            
            if (self.tg_gravity & TGGravity.horz.mask) != .none
            {
                selfSize = self.tgLayoutSubviewsForVertGravity(selfSize,sbs:sbs)
            }
            else
            {
                selfSize = self.tgLayoutSubviewsForVert(selfSize,sbs:sbs)
            }
            
            //绘制智能线。
            if !isEstimate && self.tg_intelligentBorderline != nil
            {
                for i in 0 ..< sbs.count
                {
                    let sbv = sbs[i]
                    if let sbvl = sbv as? TGBaseLayout
                    {
                        if !sbvl.tg_notUseIntelligentBorderline
                        {
                            sbvl.tg_topBorderline = nil;
                            sbvl.tg_bottomBorderline = nil;
                            
                            //取前一个视图和后一个视图。
                            var prevSiblingView:UIView!
                            var nextSiblingView:UIView!
                            
                            if i != 0
                            {
                                prevSiblingView = sbs[i - 1];
                            }
                            
                            if i + 1 != sbs.count
                            {
                                nextSiblingView = sbs[i + 1];
                            }
                            
                            if prevSiblingView != nil
                            {
                                var ok = true
                                if let prevSiblingLayout = prevSiblingView as? TGBaseLayout, self.tg_vspace == 0
                                {
                                    if (prevSiblingLayout.tg_notUseIntelligentBorderline)
                                    {
                                        ok = false
                                    }
                                }
                                
                                if (ok)
                                {
                                    sbvl.tg_topBorderline = self.tg_intelligentBorderline;
                                }
                            }
                            
                            if nextSiblingView != nil && ((nextSiblingView as? TGBaseLayout) == nil || self.tg_vspace != 0)
                            {
                                sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                            }
                        }
                    }
                    
                }
            }
            
        }
        else
        {
            //如果是水平的布局，但是子视图设置了上下的边距或者设置了高度则wrapContentWidth应该设置为NO
            for sbv in sbs
            {
                
                if (sbv.tg_top.hasValue && sbv.tg_bottom.hasValue) ||
                    (self.tg_gravity & TGGravity.horz.mask) == TGGravity.vert.fill
                {
                    sbv.tg_height._dimeVal = nil
                }
                
                
                if !isEstimate
                {
                    sbv.tgFrame.frame = sbv.bounds;
                    self.tgCalcSizeFromSizeWrapSubview(sbv)
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
                        sbvl.tgFrame.sizeClass = sbvl.tgMatchBestSizeClass(type) //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                        
                    }
                }
                
            }
            

            if (self.tg_gravity & TGGravity.vert.mask) != .none
            {
                selfSize = self.tgLayoutSubviewsForHorzGravity(selfSize,sbs:sbs)
            }
            else
            {
                selfSize = self.tgLayoutSubviewsForHorz(selfSize,sbs:sbs)
            }
            
            //绘制智能线。
            if !isEstimate && self.tg_intelligentBorderline != nil
            {
                for i in 0 ..< sbs.count
                {
                    let sbv = sbs[i];
                    if let sbvl = sbv as? TGBaseLayout
                    {
                        if !sbvl.tg_notUseIntelligentBorderline
                        {
                            sbvl.tg_leftBorderline = nil;
                            sbvl.tg_rightBorderline = nil;
                            
                            //取前一个视图和后一个视图。
                            var prevSiblingView:UIView!
                            var nextSiblingView:UIView!
                            
                            if i != 0
                            {
                                prevSiblingView = sbs[i - 1];
                            }
                            
                            if i + 1 != sbs.count
                            {
                                nextSiblingView = sbs[i + 1];
                            }
                            
                            if prevSiblingView != nil
                            {
                                var ok = true;
                                if  let prevSiblingLayout = prevSiblingView as? TGBaseLayout, self.tg_hspace == 0
                                {
                                    if (prevSiblingLayout.tg_notUseIntelligentBorderline)
                                    {
                                        ok = false;
                                    }
                                }
                                
                                if ok
                                {
                                    sbvl.tg_leftBorderline = self.tg_intelligentBorderline;
                                }
                            }
                            
                            if nextSiblingView != nil && ((nextSiblingView as? TGBaseLayout) == nil || self.tg_hspace != 0)
                            {
                                sbvl.tg_rightBorderline = self.tg_intelligentBorderline;
                            }
                        }
                    }
                    
                }
            }
            
            
        }
        
        
        selfSize.height = self.tgValidMeasure(self.tg_height,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.tgValidMeasure(self.tg_width,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        return (selfSize,hasSubLayout)
        
    }
    
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGLinearLayoutViewSizeClassImpl()
    }
    
}

//internal and private method
extension TGLinearLayout {
    
    fileprivate func tgEqualizeSubviewsForVert(_ centered:Bool, withSpace space:CGFloat!)
    {
        
        var scale:TGWeight
        let sbs = self.tgGetLayoutSubviews()
        if space != nil
        {
            scale = 100%
        }
        else
        {
            let fragments = centered ? (sbs.count * 2 + 1) : (sbs.count * 2 - 1)
            scale = TGWeight(1.0 / CGFloat(fragments))
        }
        
        
        
        for sbv in sbs
        {
            
            sbv.tg_bottom.equal(0)
            if space != nil
            {
                sbv.tg_top.equal(space)
            }
            else
            {
                sbv.tg_top.equal(scale)
            }
            sbv.tg_height.equal(scale)
            
            if sbv == sbs.first && !centered
            {
                sbv.tg_top.equal(0);
            }
            
            if sbv == sbs.last && centered
            {
                if space != nil
                {
                    sbv.tg_bottom.equal(space)
                }
                else
                {
                    sbv.tg_bottom.equal(scale)
                }
            }
        }
        
    }
    
    fileprivate func tgEqualizeSubviewsForHorz(_ centered:Bool, withSpace space:CGFloat!)
    {
        var scale:TGWeight
        let sbs = self.tgGetLayoutSubviews()
        if space != nil
        {
            scale = 100%
        }
        else
        {
            let fragments = centered ? (sbs.count * 2 + 1) : (sbs.count * 2 - 1)
            scale = TGWeight(1.0 / CGFloat(fragments))
        }
        
        
        for sbv in sbs
        {
            
            sbv.tg_right.equal(0)
            if space != nil
            {
                sbv.tg_left.equal(space)
            }
            else
            {
                sbv.tg_left.equal(scale)
            }
            
            sbv.tg_width.equal(scale)
            
            if sbv == sbs.first && !centered
            {
                sbv.tg_left.equal(0);
            }
            
            if sbv == sbs.last && centered
            {
                if space != nil
                {
                    sbv.tg_right.equal(space)
                }
                else
                {
                    sbv.tg_right.equal(scale)
                }
            }
        }
        
    }
    
    fileprivate func tgEqualizeSubviewsSpaceForVert(_ centered:Bool)
    {
        let sbs = self.tgGetLayoutSubviews()
        let fragments = centered ? CGFloat(sbs.count + 1) : CGFloat(sbs.count - 1)
        let scale = TGWeight(1.0 / fragments)
        
        for sbv in sbs
        {
            sbv.tg_top.equal(scale)
            
            if sbv === sbs.first && !centered
            {
                sbv.tg_top.equal(0);
            }
            
            if sbv === sbs.last
            {
                if centered
                {
                  sbv.tg_bottom.equal(scale)
                }
                else
                {
                    sbv.tg_bottom.equal(0)
                }
            }
        }
    }
    
    fileprivate func tgEqualizeSubviewsSpaceForHorz(_ centered:Bool)
    {
        let sbs = self.tgGetLayoutSubviews()
        let fragments = centered ? CGFloat(sbs.count + 1) : CGFloat(sbs.count - 1)
        let scale = TGWeight(1.0 / fragments)
        
        for sbv in sbs
        {
            
            sbv.tg_left.equal(scale)
            
            if sbv === sbs.first && !centered
            {
                sbv.tg_left.equal(0);
            }
            
            if sbv === sbs.last
            {
                if centered
                {
                    sbv.tg_right.equal(scale)
                }
                else
                {
                    sbv.tg_right.equal(0)
                }
            }
        }
        
    }
    
    
    private func tgAdjustSelfWidth(_ sbs:[UIView], selfSize:CGSize) ->CGFloat
    {
        
        var maxSubviewWidth:CGFloat = 0
        var retWidth = selfSize.width
        //计算出最宽的子视图所占用的宽度
        if self.tg_width.isWrap
        {
            for sbv in sbs
            {
                if !sbv.tg_width.isMatchParent && !(sbv.tg_left.hasValue && sbv.tg_right.hasValue) && !sbv.tg_width.isFill && sbv.tg_width.dimeWeightVal == nil
                {
                    
                    var vWidth = sbv.tgFrame.width
                    if sbv.tg_width.dimeNumVal != nil
                    {
                        vWidth = sbv.tg_width.measure
                    }
                    
                    vWidth = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: vWidth, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    //左边 + 中间偏移+ 宽度 + 右边
                    maxSubviewWidth = self.tgCalcSelfSize(maxSubviewWidth,
                                                           subviewMeasure:vWidth,
                                                           headPos:sbv.tg_left,
                                                           centerPos:sbv.tg_centerX,
                                                           tailPos:sbv.tg_right)
                    
                    
                }
            }
            
            retWidth = maxSubviewWidth + self.tg_leftPadding + self.tg_rightPadding;
        }
        
        return retWidth
        
    }
    
    private func tgCalcSelfSize(_ selfMeasure:CGFloat, subviewMeasure:CGFloat, headPos:TGLayoutPos,centerPos:TGLayoutPos,tailPos:TGLayoutPos) ->CGFloat
    {
        
        var  temp:CGFloat = subviewMeasure;
        var tempWeight:TGWeight = .zeroWeight;
        
        let hm:CGFloat = headPos.posNumVal ?? 0
        let cm:CGFloat = centerPos.posNumVal ?? 0
        let tm:CGFloat = tailPos.posNumVal ?? 0
        
        //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
        
        if headPos.posWeightVal != nil
        {
            tempWeight += headPos.posWeightVal
        }
        else
        {
            temp += hm
        }
        
        temp += headPos.offsetVal
        
        if centerPos.posWeightVal != nil
        {
            tempWeight += centerPos.posWeightVal
        }
        else
        {
            temp += cm
            
        }
        
        temp += centerPos.offsetVal
        
        if tailPos.posWeightVal != nil
        {
            tempWeight += tailPos.posWeightVal
            
        }
        else
        {
            temp += tm
        }
        
        temp += tailPos.offsetVal
        
        
        if /*1  <= tempWeight.rawValue/100*/ _tgCGFloatLessOrEqual(1, tempWeight.rawValue/100)
        {
            temp = 0
        }
        else
        {
            temp = temp / (1 - tempWeight.rawValue/100)  //在有相对
        }
        
        
        //得到最真实的
        let headMargin =  self.tgValidMargin(headPos, sbv: headPos.view, calcPos: headPos.realMarginInSize(temp), selfLayoutSize: CGSize.zero)
        let centerMargin = self.tgValidMargin(centerPos, sbv: centerPos.view, calcPos: centerPos.realMarginInSize(temp), selfLayoutSize: CGSize.zero)
        let tailMargin =  self.tgValidMargin(tailPos, sbv: tailPos.view, calcPos: tailPos.realMarginInSize(temp), selfLayoutSize: CGSize.zero)
        temp = subviewMeasure + headMargin + centerMargin + tailMargin
        
        var retMeasure = selfMeasure
        
        if temp > retMeasure
        {
            retMeasure = temp
        }
        
        return retMeasure
        
        
    }
    
    
    
    fileprivate func tgLayoutSubviewsForVert(_ selfSize:CGSize, sbs:[UIView])->CGSize
    {
        var fixedHeight:CGFloat = 0   //计算固定部分的高度
        var floatingHeight:CGFloat = 0 //浮动的高度。
        var totalWeight:TGWeight = .zeroWeight    //剩余部分的总比重
        var selfSize = selfSize
        selfSize.width = self.tgAdjustSelfWidth(sbs, selfSize:selfSize)   //调整自身的宽度
        let floatingWidth = selfSize.width - self.tg_leftPadding - self.tg_rightPadding
        
        var fixedSizeSbs = [UIView]()
        var fixedSizeHeight:CGFloat = 0
        for sbv in sbs
        {
            
            var rect = sbv.tgFrame.frame;
            
            
            let isFlexedHeight:Bool =  sbv.tg_height.isFlexHeight
            
            
            if sbv.tg_width.dimeNumVal != nil
            {
                rect.size.width = sbv.tg_width.measure
            }
            
            if sbv.tg_height.dimeNumVal != nil
            {
                rect.size.height = sbv.tg_height.measure
            }
            
            if (sbv.tg_height.isMatchParent && !self.tg_height.isWrap)
            {
                rect.size.height = sbv.tg_height.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
            }
            
            //和父视图保持一致。
            if sbv.tg_width.isMatchParent
            {
                rect.size.width = sbv.tg_width.measure(floatingWidth)
            }
            
            //占用父视图的宽度的比例。
            if sbv.tg_width.dimeWeightVal != nil
            {
                rect.size.width = sbv.tg_width.measure(floatingWidth*sbv.tg_width.dimeWeightVal.rawValue / 100)
            }
            
            //如果填充
            if sbv.tg_width.isFill
            {
                rect.size.width = sbv.tg_width.measure(floatingWidth - sbv.tg_left.realMarginInSize(floatingWidth) - sbv.tg_right.realMarginInSize(floatingWidth))
            }
            
            
            if (sbv.tg_left.hasValue && sbv.tg_right.hasValue)
            {
                rect.size.width = floatingWidth - sbv.tg_left.margin - sbv.tg_right.margin;
            }
            
            
            var mg:TGGravity = TGGravity.horz.left
            if (self.tg_gravity & TGGravity.vert.mask) != .none
            {
                mg = self.tg_gravity & TGGravity.vert.mask
            }
            else
            {
                if sbv.tg_centerX.hasValue
                {
                    mg = TGGravity.horz.center;
                }
                else if sbv.tg_left.hasValue && sbv.tg_right.hasValue
                {
                    mg = TGGravity.horz.fill;
                }
                else if sbv.tg_left.hasValue
                {
                    mg = TGGravity.horz.left
                }
                else if sbv.tg_right.hasValue
                {
                    mg =  TGGravity.horz.right
                }
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            rect = self.tgCalcHorzGravity(mg, selfSize:selfSize, sbv:sbv, rect:rect)
            
            if sbv.tg_height.dimeRelaVal === sbv.tg_width
            {
                rect.size.height = sbv.tg_height.measure(rect.size.width)
            }
            
            //如果子视图需要调整高度则调整高度
            if isFlexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算固定高度和浮动高度。
            if sbv.tg_top.posWeightVal != nil
            {
                totalWeight += sbv.tg_top.posWeightVal
                fixedHeight += sbv.tg_top.offsetVal
            }
            else
            {
                fixedHeight += sbv.tg_top.margin;
            }
            
            
            
            if sbv.tg_bottom.posWeightVal != nil
            {
                totalWeight += sbv.tg_bottom.posWeightVal
                fixedHeight += sbv.tg_bottom.offsetVal
            }
            else
            {
                fixedHeight += sbv.tg_bottom.margin
            }
            
            
            if sbv.tg_height.dimeWeightVal != nil
            {
                totalWeight += sbv.tg_height.dimeWeightVal
            }
            else if sbv.tg_height.isFill
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                fixedHeight += rect.height
                
                //如果最小高度不为自身则可以进行缩小。
                if !sbv.tg_height.minVal.isWrap
                {
                   fixedSizeHeight += rect.height
                   fixedSizeSbs.append(sbv)
                }
            }
            
            if sbv != sbs.last
            {
                fixedHeight += self.tg_vspace
            }
            
            sbv.tgFrame.frame = rect;
        }
        
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if self.tg_height.isWrap && totalWeight != .zeroWeight
        {
            var tempSelfHeight = self.tg_topPadding + self.tg_bottomPadding
            if sbs.count > 1
            {
              tempSelfHeight += CGFloat(sbs.count - 1) * self.tg_vspace
            }
            
            selfSize.height = self.tgValidMeasure(self.tg_height,sbv:self,calcSize:tempSelfHeight,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
            
        }

        
        //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
        floatingHeight = selfSize.height - fixedHeight - self.tg_topPadding - self.tg_bottomPadding;
        if /*floatingHeight <= 0 || floatingHeight == -0.0*/ _tgCGFloatLessOrEqual(floatingHeight, 0)
        {
            if self.tg_shrinkType != .none
            {
                if (fixedSizeSbs.count > 0 && totalWeight != .zeroWeight && floatingHeight < 0 && selfSize.height > 0)
                {
                    if self.tg_shrinkType == .average
                    {
                        let averageHeight = floatingHeight / CGFloat(fixedSizeSbs.count);
                        for fsbv in fixedSizeSbs
                        {
                            fsbv.tgFrame.height += averageHeight;
                        }
                    }
                    else if /*fixedSizeHeight != 0*/ _tgCGFloatNotEqual(fixedSizeHeight, 0)
                    {
                        for fsbv in fixedSizeSbs
                        {
                            fsbv.tgFrame.height += floatingHeight*(fsbv.tgFrame.height / fixedSizeHeight)
                        }
                    }
                    else
                    {
                        //do nothing...
                    }
                }
            }
            
            floatingHeight = 0;
        }
        
        var pos:CGFloat = self.tg_topPadding
        for sbv in sbs
        {
            
            
            var  topMargin:CGFloat = sbv.tg_top.posNumVal ?? 0
            var  bottomMargin:CGFloat = sbv.tg_bottom.posNumVal ?? 0
            var rect:CGRect =  sbv.tgFrame.frame;
            
            //分别处理相对顶部边距和绝对顶部边距
            if sbv.tg_top.posWeightVal != nil
            {
                topMargin = (sbv.tg_top.posWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                if /*topMargin <= 0 || topMargin == -0.0*/ _tgCGFloatLessOrEqual(topMargin, 0)
                {
                    topMargin = 0
                }
                
            }
            pos +=   self.tgValidMargin(sbv.tg_top, sbv: sbv, calcPos: topMargin + sbv.tg_top.offsetVal, selfLayoutSize: selfSize)
            
            //分别处理相对高度和绝对高度
            rect.origin.y = pos;
            if sbv.tg_height.dimeWeightVal != nil
            {
                var  h:CGFloat = (sbv.tg_height.dimeWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                if /*h <= 0 || h == -0.0*/ _tgCGFloatLessOrEqual(h, 0)
                {
                    h = 0;
                }
                
                rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)
                
            }
            else if sbv.tg_height.isFill
            {
                var  h:CGFloat = (100.0 / totalWeight.rawValue) * floatingHeight;
                if /*h <= 0 || h == -0.0*/ _tgCGFloatLessOrEqual(h, 0)
                {
                    h = 0;
                }
                
                rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)

            }
            
            pos += rect.size.height;
            
            //分别处理相对底部边距和绝对底部边距
            if sbv.tg_bottom.posWeightVal != nil
            {
                bottomMargin = (sbv.tg_bottom.posWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                if /*bottomMargin <= 0 || bottomMargin == -0.0*/ _tgCGFloatLessOrEqual(bottomMargin, 0)
                {
                    bottomMargin = 0;
                }
                
            }
            pos +=  self.tgValidMargin(sbv.tg_bottom,sbv: sbv, calcPos: bottomMargin + sbv.tg_bottom.offsetVal, selfLayoutSize: selfSize)
            
            if sbv != sbs.last
            {
                pos += self.tg_vspace
            }
            
            sbv.tgFrame.frame = rect
        }
        
        pos += self.tg_bottomPadding;
        
        
        if self.tg_height.isWrap
        {
            selfSize.height = pos
        }
        
        return selfSize
        
        
    }
    
    fileprivate func tgLayoutSubviewsForHorz(_ selfSize:CGSize, sbs:[UIView])->CGSize
    {
        
        var fixedWidth:CGFloat = 0;   //计算固定部分的高度
        var floatingWidth:CGFloat = 0; //浮动的高度。
        var totalWeight:TGWeight = .zeroWeight
        
        var maxSubviewHeight:CGFloat = 0;
        var selfSize = selfSize
        
        //计算出固定的子视图宽度的总和以及宽度比例总和
        var fixedSizeSbs = [UIView]()
        var fixedSizeWidth:CGFloat = 0
        for sbv in sbs
        {
            
            if sbv.tg_left.posWeightVal != nil
            {
                totalWeight += sbv.tg_left.posWeightVal
                fixedWidth += sbv.tg_left.offsetVal
            }
            else
            {
                fixedWidth += sbv.tg_left.margin;
            }
            
            if sbv.tg_right.posWeightVal != nil
            {
                totalWeight += sbv.tg_right.posWeightVal
                fixedWidth += sbv.tg_right.offsetVal
            }
            else
            {
                fixedWidth += sbv.tg_right.margin;
            }
            
            if (sbv.tg_width.dimeWeightVal != nil)
            {
                totalWeight += sbv.tg_width.dimeWeightVal
            }
            else if sbv.tg_width.isFill
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                var vWidth = sbv.tgFrame.width;
                if (sbv.tg_width.dimeNumVal != nil)
                {
                    vWidth = sbv.tg_width.measure;
                }
                
                if (sbv.tg_width.isMatchParent && !self.tg_width.isWrap)
                {
                    vWidth = sbv.tg_width.measure(selfSize.width - self.tg_leftPadding - self.tg_rightPadding)
                }
                
                vWidth = self.tgValidMeasure(sbv.tg_width,sbv:sbv,calcSize:vWidth,sbvSize:sbv.tgFrame.frame.size,selfLayoutSize:selfSize)
                
                sbv.tgFrame.width = vWidth
                
                fixedWidth += vWidth
                
                if !sbv.tg_width.minVal.isWrap
                {
                   fixedSizeWidth += vWidth
                   fixedSizeSbs.append(sbv)
                }
            }
            
            if sbv != sbs.last
            {
                fixedWidth += self.tg_hspace;
            }
        }
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if (self.tg_width.isWrap && totalWeight != .zeroWeight)
        {
            var tempSelfWidth = self.tg_leftPadding + self.tg_rightPadding
            if sbs.count > 1
            {
             tempSelfWidth += CGFloat(sbs.count - 1) * self.tg_hspace
            }
            
            selfSize.width = self.tgValidMeasure(self.tg_width,sbv:self,calcSize:tempSelfWidth,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
        }
        
        //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
        floatingWidth = selfSize.width - fixedWidth - self.tg_leftPadding - self.tg_rightPadding;
        if /*floatingWidth <= 0 || floatingWidth == -0.0*/ _tgCGFloatLessOrEqual(floatingWidth, 0)
        {
            if self.tg_shrinkType != .none
            {
                if (fixedSizeSbs.count > 0 && totalWeight != .zeroWeight && floatingWidth < 0 && selfSize.width > 0)
                {
                    if self.tg_shrinkType == .average
                    {
                        let averageWidth = floatingWidth / CGFloat(fixedSizeSbs.count)
                        for fsbv in fixedSizeSbs
                        {
                            fsbv.tgFrame.width += averageWidth;
                        }
                    }
                    else if /*fixedSizeWidth != 0*/ _tgCGFloatNotEqual(fixedSizeWidth, 0)
                    {
                        for fsbv in fixedSizeSbs
                        {
                            fsbv.tgFrame.width += floatingWidth*(fsbv.tgFrame.width / fixedSizeWidth)
                        }
                    }
                    else
                    {
                        //do nothing...
                    }
                }
            }
            
            
            floatingWidth = 0;
        }
        
        //调整所有子视图的宽度
        var pos:CGFloat = self.tg_leftPadding;
        for sbv in sbs
        {
            
            var leftMargin = sbv.tg_left.posNumVal ?? 0
            var rightMargin = sbv.tg_right.posNumVal ?? 0
            var rect:CGRect =  sbv.tgFrame.frame;
            
        
            if sbv.tg_height.dimeNumVal != nil
            {
                rect.size.height = sbv.tg_height.measure;
            }
            
            
            if (sbv.tg_height.isMatchParent)
            {
                rect.size.height = sbv.tg_height.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
            }
            
            
            
            //计算出先对左边边距和绝对左边边距
            if sbv.tg_left.posWeightVal != nil
            {
                leftMargin = (sbv.tg_left.posWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if /*leftMargin <= 0 || leftMargin == -0.0*/ _tgCGFloatLessOrEqual(leftMargin, 0)
                {
                    leftMargin = 0
                }
                
            }
            pos += self.tgValidMargin(sbv.tg_left, sbv: sbv, calcPos: leftMargin + sbv.tg_left.offsetVal, selfLayoutSize: selfSize)
            
            
            //计算出相对宽度和绝对宽度
            rect.origin.x = pos;
            if sbv.tg_width.dimeWeightVal != nil
            {
                var w = (sbv.tg_width.dimeWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if  /*w <= 0 || w == -0.0*/ _tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w
            }
            else if sbv.tg_width.isFill
            {
                var w = (100.0 / totalWeight.rawValue) * floatingWidth;
                if  /*w <= 0 || w == -0.0*/_tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w

            }
            
            rect.size.width =  self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            pos += rect.size.width
            
            //计算相对的右边边距和绝对的右边边距
            if sbv.tg_right.posWeightVal != nil
            {
                rightMargin = (sbv.tg_right.posWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if /*rightMargin <= 0 || rightMargin == -0.0*/ _tgCGFloatLessOrEqual(rightMargin, 0)
                {
                    rightMargin = 0;
                }
                
                
            }
            
            pos +=  self.tgValidMargin(sbv.tg_right, sbv: sbv, calcPos: rightMargin + sbv.tg_right.offsetVal, selfLayoutSize: selfSize)
            
            
            if sbv != sbs.last
            {
                pos += self.tg_hspace
            }
            
            //如果高度是浮动的则需要调整高度。
            if sbv.tg_height.isFlexHeight //sbv.flexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize:rect.size, selfLayoutSize: selfSize)
            
            //计算最高的高度。
            if self.tg_height.isWrap && !sbv.tg_height.isMatchParent && !(sbv.tg_top.hasValue && sbv.tg_bottom.hasValue) && !sbv.tg_height.isFill && sbv.tg_height.dimeWeightVal == nil
            {
                maxSubviewHeight = self.tgCalcSelfSize(maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbv.tg_top, centerPos:sbv.tg_centerY,tailPos:sbv.tg_bottom)
                
            }
            
            sbv.tgFrame.frame = rect;
        }
        
        if self.tg_height.isWrap
        {
            selfSize.height = maxSubviewHeight + self.tg_topPadding + self.tg_bottomPadding;
        }
        
        
        //调整所有子视图的高度
        let floatingHeight = selfSize.height - self.tg_topPadding - self.tg_bottomPadding
        for sbv in sbs
        {
            
            var rect:CGRect = sbv.tgFrame.frame;
            
            if (sbv.tg_height.isMatchParent)
            {
                rect.size.height = sbv.tg_height.measure(floatingHeight)
            }
            else if sbv.tg_height.dimeWeightVal != nil
            {
                rect.size.height = sbv.tg_height.measure(floatingHeight * sbv.tg_height.dimeWeightVal.rawValue/100)
            }
            else if sbv.tg_height.isFill
            {
                rect.size.height = sbv.tg_height.measure(floatingHeight - sbv.tg_top.realMarginInSize(floatingHeight) - sbv.tg_bottom.realMarginInSize(floatingHeight))
            }
            
            
            if (sbv.tg_top.hasValue && sbv.tg_bottom.hasValue)
            {
                rect.size.height = floatingHeight - sbv.tg_top.margin - sbv.tg_bottom.margin
            }
            
            
            
            //优先以容器中的指定为标准
            var mg:TGGravity = TGGravity.vert.top
            if (self.tg_gravity & TGGravity.horz.mask) != .none
            {
                mg = self.tg_gravity & TGGravity.horz.mask
            }
            else
            {
                if sbv.tg_centerY.hasValue
                {
                    mg = TGGravity.vert.center
                }
                else if sbv.tg_top.hasValue && sbv.tg_bottom.hasValue
                {
                    mg = TGGravity.vert.fill;
                }
                else if sbv.tg_top.hasValue
                {
                    
                    mg = TGGravity.vert.top
                }
                else if sbv.tg_bottom.hasValue
                {
                    mg = TGGravity.vert.bottom
                }
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            rect = self.tgCalcVertGravity(mg, selfSize:selfSize, sbv:sbv, rect:rect)
            
            sbv.tgFrame.frame = rect
        }
        
        pos += self.tg_rightPadding;
        
        if self.tg_width.isWrap
        {
            selfSize.width = pos
        }
        
        return selfSize
    }
    
    
    fileprivate func tgLayoutSubviewsForVertGravity(_ selfSize:CGSize, sbs:[UIView]) ->CGSize
    {
     
        let mgvert = self.tg_gravity & TGGravity.horz.mask
        let mghorz = self.tg_gravity & TGGravity.vert.mask
        
        var totalHeight:CGFloat = 0
        
        if sbs.count > 1
        {
            totalHeight += CGFloat(sbs.count - 1) * self.tg_vspace
        }
        
        var selfSize = selfSize
        selfSize.width = self.tgAdjustSelfWidth(sbs, selfSize:selfSize)
        let floatingWidth = selfSize.width - self.tg_leftPadding - self.tg_rightPadding
        
        var floatingHeight:CGFloat = selfSize.height - self.tg_topPadding - self.tg_bottomPadding - totalHeight
        if /*floatingHeight <= 0*/ _tgCGFloatLessOrEqual(floatingHeight, 0)
        {
            floatingHeight = 0
        }
        
        //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
        var noWrapsbsSet = Set<UIView>()
        for sbv in sbs
        {
            var canAddToNoWrapSbs = true
            
            var rect:CGRect =  sbv.tgFrame.frame;
            let isFlexedHeight:Bool = sbv.tg_height.isFlexHeight
            
            
            if sbv.tg_width.dimeNumVal != nil
            {
                rect.size.width = sbv.tg_width.measure
            }
            
            if sbv.tg_height.dimeNumVal != nil
            {
                rect.size.height = sbv.tg_height.measure
            }
            
            
            if (sbv.tg_height.isMatchParent && !self.tg_height.isWrap)
            {
                rect.size.height = sbv.tg_height.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
                canAddToNoWrapSbs = false
            }
            
            //调整子视图的宽度，如果子视图为matchParent的话
            if (sbv.tg_width.isMatchParent)
            {
                rect.size.width = sbv.tg_width.measure(floatingWidth)
            }
            //占用父视图的宽度的比例。
            if sbv.tg_width.dimeWeightVal != nil
            {
                rect.size.width = sbv.tg_width.measure(floatingWidth*sbv.tg_width.dimeWeightVal.rawValue / 100)
            }
            
            //如果填充
            if sbv.tg_width.isFill
            {
                rect.size.width = sbv.tg_width.measure(floatingWidth - sbv.tg_left.realMarginInSize(floatingWidth) - sbv.tg_right.realMarginInSize(floatingWidth))
            }

            
            if (sbv.tg_left.hasValue && sbv.tg_right.hasValue)
            {
                rect.size.width = floatingWidth - sbv.tg_left.margin - sbv.tg_right.margin;
            }
            
            
            //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
            var sbvmghorz:TGGravity = TGGravity.horz.left
            if mghorz != .none
            {
                sbvmghorz = mghorz
            }
            else
            {
                if sbv.tg_centerX.hasValue
                {
                    sbvmghorz = TGGravity.horz.center
                }
                else if sbv.tg_left.hasValue && sbv.tg_right.hasValue
                {
                    sbvmghorz = TGGravity.horz.fill;
                }
                else if sbv.tg_left.hasValue
                {
                    sbvmghorz = TGGravity.horz.left
                }
                else if sbv.tg_right.hasValue
                {
                    sbvmghorz = TGGravity.horz.right
                }
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            rect = self.tgCalcHorzGravity(sbvmghorz, selfSize:selfSize, sbv:sbv, rect:rect)
            
           
            if sbv.tg_height.dimeRelaVal === sbv.tg_width
            {
                rect.size.height = sbv.tg_height.measure(rect.size.width)
            }
            //如果子视图需要调整高度则调整高度
            if isFlexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                canAddToNoWrapSbs = false
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if sbv.tg_height.minVal.isWrap
            {
                canAddToNoWrapSbs = false
            }
            
            totalHeight += self.tgValidMargin(sbv.tg_top, sbv: sbv, calcPos: sbv.tg_top.realMarginInSize(floatingHeight), selfLayoutSize: selfSize)
            
            totalHeight += rect.size.height;
            totalHeight += self.tgValidMargin(sbv.tg_bottom, sbv: sbv, calcPos: sbv.tg_bottom.realMarginInSize(floatingHeight), selfLayoutSize: selfSize)
            
            
            sbv.tgFrame.frame = rect
            
            if mgvert == TGGravity.vert.fill && sbv.tg_height.isWrap
            {
                canAddToNoWrapSbs = false
            }
            
            if canAddToNoWrapSbs
            {
                noWrapsbsSet.insert(sbv)
            }
            
        }
        
        
        //根据对齐的方位来定位子视图的布局对齐
        var pos:CGFloat = 0
        var between:CGFloat = 0
        var fill:CGFloat = 0
        
        if mgvert == TGGravity.vert.top
        {
            pos = self.tg_topPadding;
        }
        else if mgvert == TGGravity.vert.center
        {
            pos = (selfSize.height - totalHeight - self.tg_bottomPadding - self.tg_topPadding)/2.0;
            pos += self.tg_topPadding;
        }
        else if mgvert == TGGravity.vert.windowCenter
        {
            if let win = self.window
            {
                pos = (win.bounds.size.height - totalHeight)/2.0;
                
                let pt = CGPoint(x: 0, y: pos);
                pos = win.convert(pt,to:self as UIView?).y;
                
                
            }
        }
        else if mgvert == TGGravity.vert.bottom
        {
            pos = selfSize.height - totalHeight - self.tg_bottomPadding
        }
        else if mgvert == TGGravity.vert.between
        {
            pos = self.tg_topPadding;
            
            if sbs.count > 1
            {
              between = (selfSize.height - totalHeight - self.tg_topPadding - self.tg_bottomPadding) / CGFloat(sbs.count - 1)
            }
        }
        else if mgvert == TGGravity.vert.fill
        {
            pos = self.tg_topPadding
            if noWrapsbsSet.count > 0
            {
                fill = (selfSize.height - totalHeight - self.tg_topPadding - self.tg_bottomPadding) / CGFloat(noWrapsbsSet.count)
            }
        }
        else
        {
            pos = self.tg_topPadding
        }
        
        
        for sbv in sbs
        {
            
            pos += self.tgValidMargin(sbv.tg_top, sbv: sbv, calcPos: sbv.tg_top.realMarginInSize(floatingHeight), selfLayoutSize: selfSize)
            
            sbv.tgFrame.top = pos;
            
            if fill != 0 && noWrapsbsSet.contains(sbv)
            {
                sbv.tgFrame.height += fill
            }
            
            pos +=  sbv.tgFrame.height;
            
            pos += self.tgValidMargin(sbv.tg_bottom, sbv: sbv, calcPos: sbv.tg_bottom.realMarginInSize(floatingHeight), selfLayoutSize: selfSize)
            
            if sbv != sbs.last
            {
                pos += self.tg_vspace;
            }
            
            pos += between
        }
        
        return selfSize;
        
    }
    
    fileprivate func tgLayoutSubviewsForHorzGravity(_ selfSize:CGSize, sbs:[UIView])->CGSize
    {
        let mgvert = self.tg_gravity & TGGravity.horz.mask
        let mghorz = self.tg_gravity & TGGravity.vert.mask
        
        var totalWidth:CGFloat = 0;
        if sbs.count > 1
        {
            totalWidth += CGFloat(sbs.count - 1) * self.tg_hspace
        }
        
        
        var floatingWidth:CGFloat = 0;
        
        var maxSubviewHeight:CGFloat = 0;
        
        var selfSize = selfSize
        floatingWidth = selfSize.width - self.tg_leftPadding - self.tg_rightPadding - totalWidth;
        if /*floatingWidth <= 0*/ _tgCGFloatLessOrEqual(floatingWidth, 0)
        {
            floatingWidth = 0
        }
        
        //计算出固定的高度
        var noWrapsbsSet = Set<UIView>()
        for sbv in sbs
        {
            var canAddToNoWrapSbs = true
            
            var rect = sbv.tgFrame.frame;
            let isFlexedHeight = sbv.tg_height.isFlexHeight //sbv.flexedHeight && !sbv.tg_height.isMatchParent;
            
            if sbv.tg_width.dimeNumVal != nil
            {
                rect.size.width = sbv.tg_width.measure;
            }
            
            if sbv.tg_height.dimeNumVal != nil
            {
                rect.size.height = sbv.tg_height.measure
            }
            
            if (sbv.tg_width.isMatchParent && !self.tg_width.isWrap)
            {
                rect.size.width = sbv.tg_width.measure(selfSize.width - self.tg_leftPadding - self.tg_rightPadding)
                canAddToNoWrapSbs = false
            }
            
            if (sbv.tg_height.isMatchParent)
            {
                rect.size.height = sbv.tg_height.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tg_width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            if sbv.tg_width.minVal.isWrap
            {
                canAddToNoWrapSbs = false
            }
            
            //如果高度是浮动的则需要调整高度。
            if (isFlexedHeight)
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算以子视图为大小的情况
            if self.tg_height.isWrap && !sbv.tg_height.isMatchParent && !(sbv.tg_top.hasValue && sbv.tg_bottom.hasValue) && !sbv.tg_height.isFill && sbv.tg_height.dimeWeightVal == nil
            {
                maxSubviewHeight = self.tgCalcSelfSize(maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbv.tg_top, centerPos:sbv.tg_centerY, tailPos:sbv.tg_bottom)
            }
            
            
            
            totalWidth += self.tgValidMargin(sbv.tg_left, sbv: sbv, calcPos: sbv.tg_left.realMarginInSize(floatingWidth), selfLayoutSize: selfSize)
            
            totalWidth += rect.size.width
            
            
            totalWidth += self.tgValidMargin(sbv.tg_right, sbv: sbv, calcPos: sbv.tg_right.realMarginInSize(floatingWidth), selfLayoutSize: selfSize)
            
            sbv.tgFrame.frame = rect
            
            if mghorz == TGGravity.horz.fill && sbv.tg_width.isWrap
            {
                canAddToNoWrapSbs = false
            }
            
            if canAddToNoWrapSbs
            {
                noWrapsbsSet.insert(sbv)
            }
            
        }
        
        
        //调整自己的高度。
        if self.tg_height.isWrap
        {
            selfSize.height = maxSubviewHeight + self.tg_topPadding + self.tg_bottomPadding;
        }
        
        //根据对齐的方位来定位子视图的布局对齐
        var pos:CGFloat = 0
        var between:CGFloat = 0
        var fill:CGFloat = 0
        
        if mghorz == TGGravity.horz.left
        {
            pos = self.tg_leftPadding
        }
        else if mghorz == TGGravity.horz.center
        {
            pos = (selfSize.width - totalWidth - self.tg_leftPadding - self.tg_rightPadding)/2.0;
            pos += self.tg_leftPadding;
        }
        else if mghorz == TGGravity.horz.windowCenter
        {
            if let win = self.window
            {
                pos = (win.bounds.size.width - totalWidth)/2.0;
                
                let  pt = CGPoint(x: pos, y: 0);
                pos = win.convert(pt,to:self as UIView?).x
            }
        }
        else if mghorz == TGGravity.horz.right
        {
            pos = selfSize.width - totalWidth - self.tg_rightPadding;
        }
        else if mghorz == TGGravity.horz.between
        {
            pos = self.tg_leftPadding
            
            if sbs.count > 1
            {
                between = (selfSize.width - totalWidth - self.tg_leftPadding - self.tg_rightPadding) / CGFloat(sbs.count - 1)
            }
        }
        else if mghorz == TGGravity.horz.fill
        {
            pos = self.tg_leftPadding
            
            if noWrapsbsSet.count > 0
            {
                fill = (selfSize.width - totalWidth - self.tg_leftPadding - self.tg_rightPadding) / CGFloat(noWrapsbsSet.count)
            }
        }
        else
        {
            pos = self.tg_leftPadding
        }
        
        
        let floatingHeight = selfSize.height - self.tg_topPadding - self.tg_bottomPadding
        for sbv in sbs
        {
            
            pos += self.tgValidMargin(sbv.tg_left, sbv: sbv, calcPos: sbv.tg_left.realMarginInSize(floatingWidth), selfLayoutSize: selfSize)
            
            
            var rect = sbv.tgFrame.frame;
            rect.origin.x = pos;
            
            //计算高度
            if (sbv.tg_height.isMatchParent)
            {
                rect.size.height = sbv.tg_height.measure(floatingHeight)
            }
            else if sbv.tg_height.dimeWeightVal != nil
            {
                rect.size.height = sbv.tg_height.measure(floatingHeight * sbv.tg_height.dimeWeightVal.rawValue/100)
            }
            else if sbv.tg_height.isFill
            {
                rect.size.height = sbv.tg_height.measure(floatingHeight - sbv.tg_top.realMarginInSize(floatingHeight) - sbv.tg_bottom.realMarginInSize(floatingHeight))
            }
            
            
            if (sbv.tg_top.hasValue && sbv.tg_bottom.hasValue)
            {
                rect.size.height = floatingHeight - sbv.tg_top.margin - sbv.tg_bottom.margin
            }
            
            
            
            var sbvmgvert:TGGravity = TGGravity.vert.top
            if mgvert != .none
            {
                sbvmgvert = mgvert
            }
            else
            {
                if sbv.tg_centerY.hasValue
                {
                    sbvmgvert = TGGravity.vert.center;
                }
                else if sbv.tg_top.hasValue && sbv.tg_bottom.hasValue
                {
                    sbvmgvert = TGGravity.vert.fill;
                }
                else if sbv.tg_top.hasValue
                {
                    sbvmgvert = TGGravity.vert.top;
                }
                else if sbv.tg_bottom.hasValue
                {
                    sbvmgvert = TGGravity.vert.bottom
                }
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tg_height,sbv:sbv,calcSize:rect.size.height,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            rect = self.tgCalcVertGravity(sbvmgvert, selfSize:selfSize,sbv:sbv,rect:rect)
            
            if fill != 0 && noWrapsbsSet.contains(sbv)
            {
                rect.size.width += fill
            }
            
            sbv.tgFrame.frame = rect
            
            pos += rect.size.width
            
            pos += self.tgValidMargin(sbv.tg_right, sbv: sbv, calcPos: sbv.tg_right.realMarginInSize(floatingWidth), selfLayoutSize: selfSize)
            
            if sbv != sbs.last
            {
                pos += self.tg_hspace;
            }
            
            pos += between;  //只有mghorz为between才加这个间距拉伸。
        }
        
        return selfSize;
    }

    

    
}
