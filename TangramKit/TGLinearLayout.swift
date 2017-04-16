//
//  TGLinearLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit




/**
 *线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单行(单列)布局视图。线性布局里面的子视图是通过添加的顺序建立约束和依赖关系的。
 *根据排列的方向我们把子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而把子视图从左到右依次排列的线性布局视图则称为水平线性布局。
 垂直线性布局
 +-------+
 |   A   |
 +-------+
 |   B   |
 +-------+  ⥥
 |   C   |
 +-------+
 |  ...  |
 +-------+
 
 水平线性布局
 +-----+-----+-----+-----+
 |  A  |  B  |  C  | ... |
 +-----+-----+-----+-----+
             ⥤
 */
open class TGLinearLayout: TGBaseLayout,TGLinearLayoutViewSizeClass {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    public  convenience init(_ orientation:TGOrientation) {
        
        self.init(frame:.zero, orientation:orientation)
        
    }

    
    public init(frame:CGRect, orientation:TGOrientation) {
        
        super.init(frame:frame)
        
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
     *TGGravity.vert.top,TGGravity.vert.center,TGGravity.vert.bottom 表示整体垂直居上，居中，居下
     *TGGravity.horz.left,TGGravity.horz.center,TGGravity.horz.right 表示整体水平居左，居中，居右
     *TGGravity.vert.between 表示在垂直线性布局里面，每行之间的行间距都被拉伸，以便使里面的子视图垂直方向填充满整个布局视图。水平线性布局里面这个设置无效。
     *TGGravity.horz.between 表示在水平线性布局里面，每列之间的列间距都被拉伸，以便使里面的子视图水平方向填充满整个布局视图。垂直线性布局里面这个设置无效。
     *TGGravity.vert.fill 在垂直线性布局里面表示布局会拉伸每行子视图的高度，以便使里面的子视图垂直方向填充满整个布局视图的高度；在水平线性布局里面表示每个个子视图的高度都将和父视图保持一致，这样就不再需要设置子视图的高度了。
     *TGGravity.horz.fill 在水平线性布局里面表示布局会拉伸每行子视图的宽度，以便使里面的子视图水平方向填充满整个布局视图的宽度；在垂直线性布局里面表示每个子视图的宽度都将和父视图保持一致，这样就不再需要设置子视图的宽度了。
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
     * 用来设置当线性布局中的子视图的尺寸大于线性布局的尺寸时的子视图压缩策略。默认值是.none。
     * 这个枚举定义在线性布局里面当某个子视图的尺寸或者位置值为TGWeight类型时，而当剩余的有固定尺寸和间距的子视图的尺寸总和要大于
     * 视图本身的尺寸时，对那些具有固定尺寸或者固定间距的子视图的处理方式。需要注意的是只有当子视图的尺寸和间距总和大于布局视图的尺寸时才有意义，否则无意义。
     * 比如某个垂直线性布局的高度是100。 里面分别有A,B,C,D四个子视图。其中:
     A.tg_top ~= 10
     A.tg_height ~= 50
     B.tg_top ~= 10%
     B.tg_height ~= 20%
     C.tg_height ~= 60
     D.tg_top ~= 20
     D.tg_height ~= 70%
     
     那么这时候总的固定高度 = A.tg_top + A.tg_height + C.tg_height +D.tg_top = 140 > 100。
     也就是多出了40的尺寸值，那么这时候我们可以用如下压缩类型的组合进行特殊的处理：
     
     1. none(布局的默认设置)
     这种情况下即使是固定的视图的尺寸超出也不会进行任何压缩！！！！
     
     
     2. average
     这种情况下，我们只会压缩那些具有固定尺寸的视图的高度A,C的尺寸，每个子视图的压缩的值是：剩余的尺寸40 / 固定尺寸的视图数量2 = 20。 这样:
     A的最终高度 = 50 - 20 = 30
     C的最终高度 = 60 - 20 = 40
     
     3.weight
     这种情况下，我们只会压缩那些具有固定尺寸的视图的高度A,C的尺寸，这些总的高度为50 + 60 = 110. 这样：
     A的最终高度 = 50 - 40 *(50/110) = 32
     C的最终高度 = 60 - 40 *（60/110) = 38
     
     4.auto
     
     假如某个水平线性布局里面里面有左右2个UILabel A和B。A和B的宽度都不确定，但是二者不能覆盖重叠，而且当间距小于一个值后要求自动换行。因为宽度都不确定所以不能指定具体的宽度值，但是又要利用好剩余的空间，这时候就可以用这个属性。比如下面的例子：
     
     let horzLayout = TGLinearLayout(.horz)
     horzLayout.tg_width.equal(.fill)
     horzLayout.tg_height.equal(.wrap)
     horzLayout.tg_hspace = 10  //二者的最小间距不能小于20
     horzLayout.tg_shrinkType = .auto
     
     let A = UILabel()
     A.text = "xxxxxxx"
     A.tg_width.equal(.wrap) //宽度等于自身内容的宽度，必须要这么设置和 .auto 结合使用。
     A.tg_height.equal(.wrap)        //自动换行
     A.tg_right.equal(50%)         //右边间距是剩余的50%
     horzLayout.addSubview(A)
     
     
     let B = UILabel()
     B.text = "XXXXXXXX"
     B.tg_width.equal(.wrap) //宽度等于自身内容的宽度，必须要这么设置和 .auto 结合使用。
     B.tg_height.equal(.wrap)        //自动换行
     B.tg_left.equal(50%)         //左边间距是剩余的50%
     horzLayout.addSubview(B)
     
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
    override internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, sbs:[UIView]!, type:TGSizeClassType) ->(selfSize:CGSize, hasSubLayout:Bool)
    {
        var (selfSize, hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate:isEstimate, sbs:sbs, type:type)
        
        var sbs:[UIView]! = sbs
        if sbs == nil
        {
            sbs = self.tgGetLayoutSubviews()
        }
        if self.tg_orientation == .vert
        {
            
            //如果是垂直的布局，但是子视图设置了左右的边距或者设置了宽度则wrapContentWidth应该设置为NO
            for sbv in sbs
            {
                
                if ((sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false)) ||
                    (self.tg_gravity & TGGravity.vert.mask) == TGGravity.horz.fill
                {
                    sbv.tgWidth?._dimeVal = nil
                }
                
                
                if !isEstimate
                {
                    sbv.tgFrame.frame = sbv.bounds;
                    self.tgCalcSizeFromSizeWrapSubview(sbv)
                }
                
                if let sbvl:TGBaseLayout = sbv as? TGBaseLayout
                {
                    if ((sbvl.tgWidth?.isWrap ?? false) || (sbvl.tgHeight?.isWrap ?? false))
                    {
                       hasSubLayout = true
                    }
                    
                    if (isEstimate && ((sbvl.tgWidth?.isWrap ?? false) || (sbvl.tgHeight?.isWrap ?? false)))
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
                
                if ((sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)) ||
                    (self.tg_gravity & TGGravity.horz.mask) == TGGravity.vert.fill
                {
                    sbv.tgHeight?._dimeVal = nil
                }
                
                
                if !isEstimate
                {
                    sbv.tgFrame.frame = sbv.bounds;
                    self.tgCalcSizeFromSizeWrapSubview(sbv)
                }
                
                if let sbvl = sbv as? TGBaseLayout
                {
                    
                    if ((sbvl.tgWidth?.isWrap ?? false) || (sbvl.tgHeight?.isWrap ?? false))
                    {
                        hasSubLayout = true
                    }
                    
                    if (isEstimate && ((sbvl.tgWidth?.isWrap ?? false) || (sbvl.tgHeight?.isWrap ?? false)))
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
        
        
        selfSize.height = self.tgValidMeasure(self.tgHeight,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.tgValidMeasure(self.tgWidth,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        
        return (self.tgAdjustSizeWhenNoSubviews(size: selfSize, sbs: sbs),hasSubLayout)
        
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
        if (self.tgWidth?.isWrap ?? false)
        {
            for sbv in sbs
            {
                if !(sbv.tgWidth?.isMatchParent ?? false) && !((sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false)) && !(sbv.tgWidth?.isFill ?? false) && sbv.tgWidth?.dimeWeightVal == nil
                {
                    
                    var vWidth = sbv.tgFrame.width
                    if sbv.tgWidth?.dimeNumVal != nil
                    {
                        vWidth = sbv.tgWidth!.measure
                    }
                    
                    vWidth = self.tgValidMeasure(sbv.tgWidth, sbv: sbv, calcSize: vWidth, sbvSize: sbv.tgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    //左边 + 中间偏移+ 宽度 + 右边
                    maxSubviewWidth = self.tgCalcSelfSize(maxSubviewWidth,
                                                           subviewMeasure:vWidth,
                                                           headPos:sbv.tgLeft,
                                                           centerPos:sbv.tgCenterX,
                                                           tailPos:sbv.tgRight)
                    
                    
                }
            }
            
            retWidth = maxSubviewWidth + self.tg_leftPadding + self.tg_rightPadding;
        }
        
        return retWidth
        
    }
    
    private func tgCalcSelfSize(_ selfMeasure:CGFloat, subviewMeasure:CGFloat, headPos:TGLayoutPos!,centerPos:TGLayoutPos!,tailPos:TGLayoutPos!) ->CGFloat
    {
        
        var  temp:CGFloat = subviewMeasure;
        var tempWeight:TGWeight = .zeroWeight;
        
        let hm:CGFloat = headPos?.posNumVal ?? 0
        let cm:CGFloat = centerPos?.posNumVal ?? 0
        let tm:CGFloat = tailPos?.posNumVal ?? 0
        
        //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
        
        if headPos?.posWeightVal != nil
        {
            tempWeight += headPos.posWeightVal
        }
        else
        {
            temp += hm
        }
        
        temp += (headPos?.offsetVal ?? 0)
        
        if centerPos?.posWeightVal != nil
        {
            tempWeight += centerPos!.posWeightVal
        }
        else
        {
            temp += cm
            
        }
        
        temp += (centerPos?.offsetVal ?? 0)
        
        if tailPos?.posWeightVal != nil
        {
            tempWeight += tailPos!.posWeightVal
            
        }
        else
        {
            temp += tm
        }
        
        temp += (tailPos?.offsetVal ?? 0)
        
        
        if /*1  <= tempWeight.rawValue/100*/ _tgCGFloatLessOrEqual(1, tempWeight.rawValue/100)
        {
            temp = 0
        }
        else
        {
            temp = temp / (1 - tempWeight.rawValue/100)  //在有相对
        }
        
        
        //得到真实的边距
        var  headMargin:CGFloat = 0
        if headPos != nil
        {
            headMargin = self.tgValidMargin(headPos, sbv: headPos.view, calcPos:headPos.realMarginInSize(temp), selfLayoutSize: CGSize.zero)
        }
        
        
        var  centerMargin:CGFloat  = 0
        if centerPos != nil
        {
            centerMargin = self.tgValidMargin(centerPos, sbv: centerPos.view, calcPos: centerPos.realMarginInSize(temp), selfLayoutSize: CGSize.zero)
        }
        
        var tailMargin:CGFloat = 0
        if tailPos != nil
        {
            
            tailMargin =  self.tgValidMargin(tailPos, sbv: tailPos.view, calcPos: tailPos.realMarginInSize(temp), selfLayoutSize: CGSize.zero)
        }
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
        let padding = self.tg_padding
        selfSize.width = self.tgAdjustSelfWidth(sbs, selfSize:selfSize)   //调整自身的宽度
        let floatingWidth = selfSize.width - padding.left - padding.right
        
        var addSpace:CGFloat = 0
        var fixedSizeSbs = [UIView]()
        var fixedSizeHeight:CGFloat = 0
        var fixedSpaceCount:Int = 0
        var fixedSpaceHeight:CGFloat = 0
        for sbv in sbs
        {
            
            var rect = sbv.tgFrame.frame;
            
            
            let isFlexedHeight:Bool =  (sbv.tgHeight?.isFlexHeight ?? false)
            
            
            if sbv.tgWidth?.dimeNumVal != nil
            {
                rect.size.width = sbv.tgWidth!.measure
            }
            
            if sbv.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbv.tgHeight!.measure
            }
            
            if ((sbv.tgHeight?.isMatchParent ?? false) && !(self.tgHeight?.isWrap ?? false))
            {
                rect.size.height = sbv.tgHeight!.measure(selfSize.height - padding.top - padding.bottom)
            }
            
            //和父视图保持一致。
            if (sbv.tgWidth?.isMatchParent ?? false)
            {
                rect.size.width = sbv.tgWidth!.measure(floatingWidth)
            }
            
            //占用父视图的宽度的比例。
            if sbv.tgWidth?.dimeWeightVal != nil
            {
                rect.size.width = sbv.tgWidth!.measure(floatingWidth*sbv.tgWidth!.dimeWeightVal.rawValue / 100)
            }
            
            //如果填充
            if (sbv.tgWidth?.isFill ?? false)
            {
                rect.size.width = sbv.tgWidth!.measure(floatingWidth - (sbv.tgLeft?.realMarginInSize(floatingWidth) ?? 0) - (sbv.tgRight?.realMarginInSize(floatingWidth) ?? 0))
            }
            
            
            if ((sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false))
            {
                rect.size.width = floatingWidth - sbv.tgLeft!.margin - sbv.tgRight!.margin
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tgWidth,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            rect = self.tgCalcHorzGravity(self.tgGetSubviewHorzGravity(sbv, horzGravity: self.tg_gravity & TGGravity.vert.mask), selfSize:selfSize, sbv:sbv, rect:rect)
            
            if sbv.tgHeight?.dimeRelaVal != nil && sbv.tgHeight!.dimeRelaVal === sbv.tgWidth
            {
                rect.size.height = sbv.tgHeight!.measure(rect.size.width)
            }
            
            //如果子视图需要调整高度则调整高度
            if isFlexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算固定高度和浮动高度。
            if sbv.tgTop?.posWeightVal != nil
            {
                totalWeight += sbv.tgTop!.posWeightVal
                fixedHeight += sbv.tgTop!.offsetVal
            }
            else
            {
                fixedHeight += (sbv.tgTop?.margin ?? 0)
                if (sbv.tgTop?.margin ?? 0) != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += (sbv.tgTop?.margin ?? 0)
                }
            }
            
            
            
            if sbv.tgBottom?.posWeightVal != nil
            {
                totalWeight += sbv.tgBottom!.posWeightVal
                fixedHeight += sbv.tgBottom!.offsetVal
            }
            else
            {
                fixedHeight += (sbv.tgBottom?.margin ?? 0)
                if (sbv.tgBottom?.margin ?? 0) != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += (sbv.tgBottom?.margin ?? 0)
                }
            }
            
            
            if sbv.tgHeight?.dimeWeightVal != nil
            {
                totalWeight += sbv.tgHeight!.dimeWeightVal
            }
            else if (sbv.tgHeight?.isFill ?? false)
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                fixedHeight += rect.height
                
                //如果最小高度不为自身则可以进行缩小。
                if !(sbv.tgHeight?.tgMinVal?.isWrap ?? false)
                {
                   fixedSizeHeight += rect.height
                   fixedSizeSbs.append(sbv)
                }
            }
            
            if sbv != sbs.last
            {
                fixedHeight += self.tg_vspace
                
                if self.tg_vspace != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += self.tg_vspace
                }
            }
            
            sbv.tgFrame.frame = rect;
        }
        
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if (self.tgHeight?.isWrap ?? false) && totalWeight != .zeroWeight
        {
            var tempSelfHeight = self.tg_topPadding + self.tg_bottomPadding
            if sbs.count > 1
            {
              tempSelfHeight += CGFloat(sbs.count - 1) * self.tg_vspace
            }
            
            selfSize.height = self.tgValidMeasure(self.tgHeight,sbv:self,calcSize:tempSelfHeight,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
            
        }

        
        //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
        var isWeightShrinkSpace = false
        var weightShrinkSpaceTotalHeight:CGFloat = 0.0
        floatingHeight = selfSize.height - fixedHeight - padding.top - padding.bottom;
        if /*floatingHeight <= 0 || floatingHeight == -0.0*/ _tgCGFloatLessOrEqual(floatingHeight, 0)
        {
            let sstMode:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: self.tg_shrinkType.rawValue & 0x0F)  //压缩策略
            let sstContent:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: self.tg_shrinkType.rawValue & 0xF0) //压缩内容
            
            if sstMode != .none
            {
                if sstContent != .space
                {
                    
                    if (fixedSizeSbs.count > 0 && totalWeight != .zeroWeight && floatingHeight < 0 && selfSize.height > 0)
                    {
                        if sstMode == .average
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
                else
                {
                    if (fixedSpaceCount > 0 && floatingHeight < 0 && selfSize.height > 0 && fixedSpaceHeight > 0)
                    {
                        if (sstMode == .average)
                        {
                            addSpace = floatingHeight / CGFloat(fixedSpaceCount)
                        }
                        else if (sstMode == .weight)
                        {
                            isWeightShrinkSpace = true
                            weightShrinkSpaceTotalHeight = floatingHeight;
                        }
                        else
                        {
                            
                        }
                    }

                }
            }
            
            floatingHeight = 0;
        }
        
        var pos:CGFloat = self.tg_topPadding
        for sbv in sbs
        {
            
            
            var  topMargin:CGFloat = sbv.tgTop?.posNumVal ?? 0
            var  bottomMargin:CGFloat = sbv.tgBottom?.posNumVal ?? 0
            var rect:CGRect =  sbv.tgFrame.frame;
            
            //分别处理相对顶部边距和绝对顶部边距
            if sbv.tgTop?.posWeightVal != nil
            {
                topMargin = (sbv.tgTop!.posWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                if /*topMargin <= 0 || topMargin == -0.0*/ _tgCGFloatLessOrEqual(topMargin, 0)
                {
                    topMargin = 0
                }
                
            }
            else
            {
                if (topMargin + (sbv.tgTop?.offsetVal ?? 0) != 0)
                {
                    pos += addSpace
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * (topMargin + (sbv.tgTop?.offsetVal ?? 0)) / fixedSpaceHeight;
                    }
                }

            }
            
            pos +=   self.tgValidMargin(sbv.tgTop, sbv: sbv, calcPos: topMargin + (sbv.tgTop?.offsetVal ?? 0), selfLayoutSize: selfSize)
            
            //分别处理相对高度和绝对高度
            rect.origin.y = pos;
            if sbv.tgHeight?.dimeWeightVal != nil
            {
                var  h:CGFloat = (sbv.tgHeight!.dimeWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                if /*h <= 0 || h == -0.0*/ _tgCGFloatLessOrEqual(h, 0)
                {
                    h = 0;
                }
                
                rect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)
                
            }
            else if (sbv.tgHeight?.isFill ?? false)
            {
                var  h:CGFloat = (100.0 / totalWeight.rawValue) * floatingHeight;
                if /*h <= 0 || h == -0.0*/ _tgCGFloatLessOrEqual(h, 0)
                {
                    h = 0;
                }
                
                rect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)

            }
            
            pos += rect.size.height;
            
            //分别处理相对底部边距和绝对底部边距
            if sbv.tgBottom?.posWeightVal != nil
            {
                bottomMargin = (sbv.tgBottom!.posWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                if /*bottomMargin <= 0 || bottomMargin == -0.0*/ _tgCGFloatLessOrEqual(bottomMargin, 0)
                {
                    bottomMargin = 0;
                }
                
            }
            else
            {
                if (bottomMargin + (sbv.tgBottom?.offsetVal ?? 0) != 0)
                {
                    pos += addSpace
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * (bottomMargin + (sbv.tgBottom?.offsetVal ?? 0)) / fixedSpaceHeight;
                    }
                }

            }
            
            pos +=  self.tgValidMargin(sbv.tgBottom,sbv: sbv, calcPos: bottomMargin + (sbv.tgBottom?.offsetVal ?? 0), selfLayoutSize: selfSize)
            
            if sbv != sbs.last
            {
                pos += self.tg_vspace
                
                if (self.tg_vspace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalHeight * self.tg_vspace / fixedSpaceHeight;
                    }
                }

            }
            
            sbv.tgFrame.frame = rect
        }
        
        pos += self.tg_bottomPadding;
        
        
        if (self.tgHeight?.isWrap ?? false)
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
        var addSpace:CGFloat = 0.0   //用于压缩时的间距压缩增量。
        var fixedSizeSbs = [UIView]()
        var fixedSizeWidth:CGFloat = 0
        var flexedSizeSbs = [UIView]()
        var fixedSpaceCount = 0  //固定间距的子视图数量。
        var fixedSpaceWidth:CGFloat = 0.0  //固定间距的子视图的宽度。
        for sbv in sbs
        {
            
            if sbv.tgLeft?.posWeightVal != nil
            {
                totalWeight += sbv.tgLeft!.posWeightVal
                fixedWidth += sbv.tgLeft!.offsetVal
            }
            else
            {
                fixedWidth += (sbv.tgLeft?.margin ?? 0)
                
                if ((sbv.tgLeft?.margin ?? 0) != 0)
                {
                    fixedSpaceCount += 1;
                    fixedSpaceWidth += (sbv.tgLeft?.margin ?? 0)
                }
            }
            
            if sbv.tgRight?.posWeightVal != nil
            {
                totalWeight += sbv.tgRight!.posWeightVal
                fixedWidth += sbv.tgRight!.offsetVal
            }
            else
            {
                fixedWidth += (sbv.tgRight?.margin ?? 0)
                
                if ((sbv.tgRight?.margin ?? 0) != 0)
                {
                    fixedSpaceCount += 1
                    fixedSpaceWidth += (sbv.tgRight?.margin ?? 0)
                }

            }
            
            if (sbv.tgWidth?.dimeWeightVal != nil)
            {
                totalWeight += sbv.tgWidth!.dimeWeightVal
            }
            else if (sbv.tgWidth?.isFill ?? false)
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                var vWidth = sbv.tgFrame.width;
                if (sbv.tgWidth?.dimeNumVal != nil)
                {
                    vWidth = sbv.tgWidth!.measure;
                }
                
                if ((sbv.tgWidth?.isMatchParent ?? false) && !(self.tgWidth?.isWrap ?? false))
                {
                    vWidth = sbv.tgWidth!.measure(selfSize.width - self.tg_leftPadding - self.tg_rightPadding)
                }
                
                vWidth = self.tgValidMeasure(sbv.tgWidth,sbv:sbv,calcSize:vWidth,sbvSize:sbv.tgFrame.frame.size,selfLayoutSize:selfSize)
                
                sbv.tgFrame.width = vWidth
                
                fixedWidth += vWidth
                
                if !(sbv.tgWidth?.tgMinVal?.isWrap ?? false)
                {
                   fixedSizeWidth += vWidth
                   fixedSizeSbs.append(sbv)
                }
                
                if (sbv.tgWidth?.isWrap ?? false)
                {
                    flexedSizeSbs.append(sbv)
                }
            }
            
            if sbv != sbs.last
            {
                fixedWidth += self.tg_hspace
                
                if (self.tg_hspace != 0)
                {
                    fixedSpaceCount += 1
                    fixedSpaceWidth += self.tg_hspace
                }
            }
        }
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if ((self.tgWidth?.isWrap ?? false) && totalWeight != .zeroWeight)
        {
            var tempSelfWidth = self.tg_leftPadding + self.tg_rightPadding
            if sbs.count > 1
            {
             tempSelfWidth += CGFloat(sbs.count - 1) * self.tg_hspace
            }
            
            selfSize.width = self.tgValidMeasure(self.tgWidth,sbv:self,calcSize:tempSelfWidth,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
        }
        
        //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
        var isWeightShrinkSpace = false   //是否按比重缩小间距。。。
        var weightShrinkSpaceTotalWidth:CGFloat = 0.0
        floatingWidth = selfSize.width - fixedWidth - self.tg_leftPadding - self.tg_rightPadding;
        if /*floatingWidth <= 0 || floatingWidth == -0.0*/ _tgCGFloatLessOrEqual(floatingWidth, 0)
        {
            var sstMode:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: self.tg_shrinkType.rawValue & 0x0F)  //压缩策略
            let sstContent:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: self.tg_shrinkType.rawValue & 0xF0) //压缩内容

            
            if sstMode == .auto && flexedSizeSbs.count != 2
            {
                sstMode = .none
            }
            
            if sstMode != .none
            {
                if sstContent != .space
                {
                    
                    if (fixedSizeSbs.count > 0 && totalWeight != .zeroWeight && floatingWidth < 0 && selfSize.width > 0)
                    {
                        if sstMode == .average
                        {
                            let averageWidth = floatingWidth / CGFloat(fixedSizeSbs.count)
                            for fsbv in fixedSizeSbs
                            {
                                fsbv.tgFrame.width += averageWidth;
                            }
                        }
                        else if sstMode == .auto
                        {
                            let leftView = flexedSizeSbs[0]
                            let rightView = flexedSizeSbs[1]
                            
                            let leftWidth = leftView.tgFrame.width
                            let righWidth = rightView.tgFrame.width
                            
                            //如果2个都超过一半则总是一半显示。
                            //如果1个超过了一半则 如果两个没有超过总宽度则正常显示，如果超过了总宽度则超过一半的视图的宽度等于总宽度减去未超过一半的视图的宽度。
                            //如果没有一个超过一半。则正常显示
                            let  layoutWidth = floatingWidth + leftWidth + righWidth
                            let halfLayoutWidth = layoutWidth / 2
                            
                            if leftWidth > halfLayoutWidth && righWidth > halfLayoutWidth
                            {
                                leftView.tgFrame.width = halfLayoutWidth
                                rightView.tgFrame.width = halfLayoutWidth
                            }
                            else if ((leftWidth > halfLayoutWidth || righWidth > halfLayoutWidth) && (leftWidth + righWidth > layoutWidth))
                            {
                                
                                if (leftWidth > halfLayoutWidth)
                                {
                                    rightView.tgFrame.width = righWidth
                                    leftView.tgFrame.width = layoutWidth - righWidth
                                }
                                else
                                {
                                    leftView.tgFrame.width = leftWidth;
                                    rightView.tgFrame.width = layoutWidth - leftWidth
                                }
                                
                            }
                            else
                            {
                                
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
                else
                {
                    if (fixedSpaceCount > 0 && floatingWidth < 0 && selfSize.height > 0 && fixedSpaceWidth > 0)
                    {
                        if (sstMode == .average)
                        {
                            addSpace = floatingWidth / CGFloat(fixedSpaceCount)
                        }
                        else if (sstMode == .weight)
                        {
                            isWeightShrinkSpace = true
                            weightShrinkSpaceTotalWidth = floatingWidth
                        }
                    }

                    
                }
            }
            
            
            floatingWidth = 0;
        }
        
        //调整所有子视图的宽度
        var pos:CGFloat = self.tg_leftPadding;
        for sbv in sbs
        {
            
            var leftMargin = sbv.tgLeft?.posNumVal ?? 0
            var rightMargin = sbv.tgRight?.posNumVal ?? 0
            var rect:CGRect =  sbv.tgFrame.frame;
            
        
            if sbv.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbv.tgHeight!.measure;
            }
            
            
            if (sbv.tgHeight?.isMatchParent ?? false)
            {
                rect.size.height = sbv.tgHeight!.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
            }
            
            
            
            //计算出先对左边边距和绝对左边边距
            if sbv.tgLeft?.posWeightVal != nil
            {
                leftMargin = (sbv.tgLeft!.posWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if /*leftMargin <= 0 || leftMargin == -0.0*/ _tgCGFloatLessOrEqual(leftMargin, 0)
                {
                    leftMargin = 0
                }
                
            }
            else
            {
                if (leftMargin + (sbv.tgLeft?.offsetVal ?? 0) != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * (leftMargin + (sbv.tgLeft?.offsetVal ?? 0)) / fixedSpaceWidth;
                    }
                }

            }
            
            pos += self.tgValidMargin(sbv.tgLeft, sbv: sbv, calcPos: leftMargin + (sbv.tgLeft?.offsetVal ?? 0), selfLayoutSize: selfSize)
            
            
            //计算出相对宽度和绝对宽度
            rect.origin.x = pos;
            if sbv.tgWidth?.dimeWeightVal != nil
            {
                var w = (sbv.tgWidth!.dimeWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if  /*w <= 0 || w == -0.0*/ _tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w
            }
            else if (sbv.tgWidth?.isFill ?? false)
            {
                var w = (100.0 / totalWeight.rawValue) * floatingWidth;
                if  /*w <= 0 || w == -0.0*/_tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w

            }
            
            rect.size.width =  self.tgValidMeasure(sbv.tgWidth, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            pos += rect.size.width
            
            //计算相对的右边边距和绝对的右边边距
            if sbv.tgRight?.posWeightVal != nil
            {
                rightMargin = (sbv.tgRight!.posWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if /*rightMargin <= 0 || rightMargin == -0.0*/ _tgCGFloatLessOrEqual(rightMargin, 0)
                {
                    rightMargin = 0;
                }
                
                
            }
            else
            {
                if (rightMargin + (sbv.tgRight?.offsetVal ?? 0) != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * (rightMargin + (sbv.tgRight?.offsetVal ?? 0)) / fixedSpaceWidth;
                    }
                }

            }
            
            pos +=  self.tgValidMargin(sbv.tgRight, sbv: sbv, calcPos: rightMargin + (sbv.tgRight?.offsetVal ?? 0), selfLayoutSize: selfSize)
            
            
            if sbv != sbs.last
            {
                pos += self.tg_hspace
                
                if (self.tg_hspace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * self.tg_hspace / fixedSpaceWidth
                    }
                }

            }
            
            if sbv.tgHeight?.dimeRelaVal != nil && sbv.tgHeight!.dimeRelaVal === sbv.tgWidth
            {
                rect.size.height = sbv.tgHeight!.measure(rect.size.width)
            }
            
            //如果高度是浮动的则需要调整高度。
            if (sbv.tgHeight?.isFlexHeight ?? false) //sbv.flexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize:rect.size, selfLayoutSize: selfSize)
            
            //计算最高的高度。
            if (self.tgHeight?.isWrap ?? false) && !(sbv.tgHeight?.isMatchParent ?? false) && !((sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)) && !(sbv.tgHeight?.isFill ?? false) && sbv.tgHeight?.dimeWeightVal == nil
            {
                maxSubviewHeight = self.tgCalcSelfSize(maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbv.tgTop, centerPos:sbv.tgCenterY,tailPos:sbv.tgBottom)
                
            }
            
            sbv.tgFrame.frame = rect;
        }
        
        if (self.tgHeight?.isWrap ?? false)
        {
            selfSize.height = maxSubviewHeight + self.tg_topPadding + self.tg_bottomPadding;
        }
        
        
        //调整所有子视图的高度
        let floatingHeight = selfSize.height - self.tg_topPadding - self.tg_bottomPadding
        for sbv in sbs
        {
            
            var rect:CGRect = sbv.tgFrame.frame;
            
            if (sbv.tgHeight?.isMatchParent ?? false)
            {
                rect.size.height = sbv.tgHeight!.measure(floatingHeight)
            }
            else if sbv.tgHeight?.dimeWeightVal != nil
            {
                rect.size.height = sbv.tgHeight!.measure(floatingHeight * sbv.tgHeight!.dimeWeightVal.rawValue/100)
            }
            else if (sbv.tgHeight?.isFill ?? false)
            {
                rect.size.height = sbv.tgHeight!.measure(floatingHeight - (sbv.tgTop?.realMarginInSize(floatingHeight) ?? 0) - (sbv.tgBottom?.realMarginInSize(floatingHeight) ?? 0))
            }
            
            
            if ((sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false))
            {
                rect.size.height = floatingHeight - sbv.tgTop!.margin - sbv.tgBottom!.margin
            }
            
            
            
            //优先以容器中的指定为标准
            rect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            rect = self.tgCalcVertGravity(self.tgGetSubviewVertGravity(sbv, vertGravity: self.tg_gravity & TGGravity.horz.mask), selfSize:selfSize, sbv:sbv, rect:rect)
            
            sbv.tgFrame.frame = rect
        }
        
        pos += self.tg_rightPadding;
        
        if (self.tgWidth?.isWrap ?? false)
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
            let isFlexedHeight:Bool = (sbv.tgHeight?.isFlexHeight ?? false)
            
            
            if sbv.tgWidth?.dimeNumVal != nil
            {
                rect.size.width = sbv.tgWidth!.measure
            }
            
            if sbv.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbv.tgHeight!.measure
            }
            
            
            if ((sbv.tgHeight?.isMatchParent ?? false) && !(self.tgHeight?.isWrap ?? false))
            {
                rect.size.height = sbv.tgHeight!.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
                canAddToNoWrapSbs = false
            }
            
            //调整子视图的宽度，如果子视图为matchParent的话
            if (sbv.tgWidth?.isMatchParent ?? false)
            {
                rect.size.width = sbv.tgWidth!.measure(floatingWidth)
            }
            //占用父视图的宽度的比例。
            if sbv.tgWidth?.dimeWeightVal != nil
            {
                rect.size.width = sbv.tgWidth!.measure(floatingWidth*sbv.tgWidth!.dimeWeightVal.rawValue / 100)
            }
            
            //如果填充
            if (sbv.tgWidth?.isFill ?? false)
            {
                rect.size.width = sbv.tgWidth!.measure(floatingWidth - (sbv.tgLeft?.realMarginInSize(floatingWidth) ?? 0) - (sbv.tgRight?.realMarginInSize(floatingWidth) ?? 0))
            }

            
            if ((sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false))
            {
                rect.size.width = floatingWidth - sbv.tgLeft!.margin - sbv.tgRight!.margin;
            }
            
            
            //优先以容器中的对齐方式为标准，否则以自己的停靠方式为标准
            rect.size.width = self.tgValidMeasure(sbv.tgWidth, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            rect = self.tgCalcHorzGravity(self.tgGetSubviewHorzGravity(sbv, horzGravity: mghorz), selfSize:selfSize, sbv:sbv, rect:rect)
            
           
            if sbv.tgHeight?.dimeRelaVal != nil && sbv.tgHeight!.dimeRelaVal === sbv.tgWidth
            {
                rect.size.height = sbv.tgHeight!.measure(rect.size.width)
            }
            //如果子视图需要调整高度则调整高度
            if isFlexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
                canAddToNoWrapSbs = false
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tgHeight?.tgMinVal?.isWrap ?? false)
            {
                canAddToNoWrapSbs = false
            }
            
            totalHeight += self.tgValidMargin(sbv.tgTop, sbv: sbv, calcPos: (sbv.tgTop?.realMarginInSize(floatingHeight) ?? 0), selfLayoutSize: selfSize)
            
            totalHeight += rect.size.height;
            totalHeight += self.tgValidMargin(sbv.tgBottom, sbv: sbv, calcPos: (sbv.tgBottom?.realMarginInSize(floatingHeight) ?? 0), selfLayoutSize: selfSize)
            
            
            sbv.tgFrame.frame = rect
            
            if mgvert == TGGravity.vert.fill && (sbv.tgHeight?.isWrap ?? false)
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
            
            pos += self.tgValidMargin(sbv.tgTop, sbv: sbv, calcPos: (sbv.tgTop?.realMarginInSize(floatingHeight) ?? 0), selfLayoutSize: selfSize)
            
            sbv.tgFrame.top = pos;
            
            if fill != 0 && noWrapsbsSet.contains(sbv)
            {
                sbv.tgFrame.height += fill
            }
            
            pos +=  sbv.tgFrame.height;
            
            pos += self.tgValidMargin(sbv.tgBottom, sbv: sbv, calcPos: (sbv.tgBottom?.realMarginInSize(floatingHeight) ?? 0), selfLayoutSize: selfSize)
            
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
            let isFlexedHeight = (sbv.tgHeight?.isFlexHeight ?? false) //sbv.flexedHeight && !sbv.tg_height.isMatchParent;
            
            if sbv.tgWidth?.dimeNumVal != nil
            {
                rect.size.width = sbv.tgWidth!.measure;
            }
            
            if sbv.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbv.tgHeight!.measure
            }
            
            if ((sbv.tgWidth?.isMatchParent ?? false) && !(self.tgWidth?.isWrap ?? false))
            {
                rect.size.width = sbv.tgWidth!.measure(selfSize.width - self.tg_leftPadding - self.tg_rightPadding)
                canAddToNoWrapSbs = false
            }
            
            if (sbv.tgHeight?.isMatchParent ?? false)
            {
                rect.size.height = sbv.tgHeight!.measure(selfSize.height - self.tg_topPadding - self.tg_bottomPadding)
            }
            
            if (sbv.tgWidth?.dimeRelaVal != nil && sbv.tgWidth!.dimeRelaVal === sbv.tgHeight)
            {
                rect.size.width = sbv.tgWidth!.measure(rect.size.height)
            }
            
            rect.size.width = self.tgValidMeasure(sbv.tgWidth,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            if (sbv.tgWidth?.tgMinVal?.isWrap ?? false)
            {
                canAddToNoWrapSbs = false
            }
            
            if (sbv.tgHeight?.dimeRelaVal != nil && sbv.tgHeight!.dimeRelaVal === sbv.tgWidth)
            {
                rect.size.height = sbv.tgHeight!.measure(rect.size.width)
            }
            
            //如果高度是浮动的则需要调整高度。
            if (isFlexedHeight)
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbv.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算以子视图为大小的情况
            if (self.tgHeight?.isWrap ?? false) &&
                !(sbv.tgHeight?.isMatchParent ?? false) &&
                !((sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)) &&
                !(sbv.tgHeight?.isFill ?? false) &&
                sbv.tgHeight?.dimeWeightVal == nil
            {
                maxSubviewHeight = self.tgCalcSelfSize(maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbv.tgTop, centerPos:sbv.tgCenterY, tailPos:sbv.tgBottom)
            }
            
            
            
            totalWidth += self.tgValidMargin(sbv.tgLeft, sbv: sbv, calcPos: (sbv.tgLeft?.realMarginInSize(floatingWidth) ?? 0), selfLayoutSize: selfSize)
            
            totalWidth += rect.size.width
            
            
            totalWidth += self.tgValidMargin(sbv.tgRight, sbv: sbv, calcPos: (sbv.tgRight?.realMarginInSize(floatingWidth) ?? 0), selfLayoutSize: selfSize)
            
            sbv.tgFrame.frame = rect
            
            if mghorz == TGGravity.horz.fill && (sbv.tgWidth?.isWrap ?? false)
            {
                canAddToNoWrapSbs = false
            }
            
            if canAddToNoWrapSbs
            {
                noWrapsbsSet.insert(sbv)
            }
            
        }
        
        
        //调整自己的高度。
        if (self.tgHeight?.isWrap ?? false)
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
            
            pos += self.tgValidMargin(sbv.tgLeft, sbv: sbv, calcPos: (sbv.tgLeft?.realMarginInSize(floatingWidth) ?? 0), selfLayoutSize: selfSize)
            
            
            var rect = sbv.tgFrame.frame;
            rect.origin.x = pos;
            
            //计算高度
            if (sbv.tgHeight?.isMatchParent ?? false)
            {
                rect.size.height = sbv.tgHeight!.measure(floatingHeight)
            }
            else if sbv.tgHeight?.dimeWeightVal != nil
            {
                rect.size.height = sbv.tgHeight!.measure(floatingHeight * sbv.tgHeight!.dimeWeightVal.rawValue/100)
            }
            else if (sbv.tgHeight?.isFill ?? false)
            {
                rect.size.height = sbv.tgHeight!.measure(floatingHeight - (sbv.tgTop?.realMarginInSize(floatingHeight) ?? 0) - (sbv.tgBottom?.realMarginInSize(floatingHeight) ?? 0))
            }
            
            
            if (sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)
            {
                rect.size.height = floatingHeight - sbv.tgTop!.margin - sbv.tgBottom!.margin
            }
            
            
            rect.size.height = self.tgValidMeasure(sbv.tgHeight,sbv:sbv,calcSize:rect.size.height,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            rect = self.tgCalcVertGravity(self.tgGetSubviewVertGravity(sbv, vertGravity: mgvert), selfSize:selfSize,sbv:sbv,rect:rect)
            
            if fill != 0 && noWrapsbsSet.contains(sbv)
            {
                rect.size.width += fill
            }
            
            sbv.tgFrame.frame = rect
            
            pos += rect.size.width
            
            pos += self.tgValidMargin(sbv.tgRight, sbv: sbv, calcPos: (sbv.tgRight?.realMarginInSize(floatingWidth) ?? 0), selfLayoutSize: selfSize)
            
            if sbv != sbs.last
            {
                pos += self.tg_hspace;
            }
            
            pos += between;  //只有mghorz为between才加这个间距拉伸。
        }
        
        return selfSize;
    }

    
   fileprivate func tgGetSubviewVertGravity(_ sbv:UIView, vertGravity:TGGravity)->TGGravity
    {
        var sbvVertGravity:TGGravity = TGGravity.vert.top
        if vertGravity != .none
        {
            sbvVertGravity = vertGravity
        }
        else
        {
            if sbv.tgCenterY?.hasValue ?? false
            {
                sbvVertGravity = TGGravity.vert.center;
            }
            else if (sbv.tgTop?.hasValue ?? false) && (sbv.tgBottom?.hasValue ?? false)
            {
                sbvVertGravity = TGGravity.vert.fill;
            }
            else if (sbv.tgTop?.hasValue ?? false)
            {
                sbvVertGravity = TGGravity.vert.top;
            }
            else if (sbv.tgBottom?.hasValue ?? false)
            {
                sbvVertGravity = TGGravity.vert.bottom
            }
        }
        
        return sbvVertGravity
    }
    
    fileprivate func tgGetSubviewHorzGravity(_ sbv:UIView, horzGravity:TGGravity)->TGGravity
    {
        var sbvHorzGravity:TGGravity = TGGravity.horz.left
        if horzGravity != .none
        {
            sbvHorzGravity = horzGravity
        }
        else
        {
            if sbv.tgCenterX?.hasValue ?? false
            {
                sbvHorzGravity = TGGravity.horz.center
            }
            else if (sbv.tgLeft?.hasValue ?? false) && (sbv.tgRight?.hasValue ?? false)
            {
                sbvHorzGravity = TGGravity.horz.fill;
            }
            else if (sbv.tgLeft?.hasValue ?? false)
            {
                sbvHorzGravity = TGGravity.horz.left
            }
            else if (sbv.tgRight?.hasValue ?? false)
            {
                sbvHorzGravity = TGGravity.horz.right
            }
        }
        
        return sbvHorzGravity
    }
    
}


