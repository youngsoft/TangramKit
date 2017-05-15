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
            let lsc = self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass
            if lsc.tg_orientation != newValue
            {
                lsc.tg_orientation = newValue
                setNeedsLayout()
            }
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
            let lsc = self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass
            if lsc.tg_gravity != newValue
            {
                lsc.tg_gravity = newValue
                setNeedsLayout()
            }
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
            let lsc = self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClass
            if lsc.tg_shrinkType != newValue
            {
                lsc.tg_shrinkType = newValue
                setNeedsLayout()
            }
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
        
        let lsc = self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClassImpl
        
        let vertGravity = lsc.tg_gravity & TGGravity.horz.mask
        let horzGravity = lsc.tg_gravity & TGGravity.vert.mask
        
    
            for sbv in sbs
            {
                let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
                let sbvtgFrame = sbv.tgFrame
                
                self.tgAdjustSubviewWrapContent(sbvsc: sbvsc, lsc: lsc)
                
                
                if !isEstimate
                {
                    sbvtgFrame.frame = sbv.bounds;
                    self.tgCalcSizeFromSizeWrapSubview(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame)
                }
                
                if let sbvl:TGBaseLayout = sbv as? TGBaseLayout
                {
                    let sbvtgWidthIsWrap = sbvsc.tgWidth?.isWrap ?? false
                    let sbvtgHeightIsWrap = sbvsc.tgHeight?.isWrap ?? false
                    
                    if sbvtgWidthIsWrap || sbvtgHeightIsWrap
                    {
                       hasSubLayout = true
                    }
                    
                    if isEstimate && (sbvtgWidthIsWrap || sbvtgHeightIsWrap)
                    {
                        _ = sbvl.tg_sizeThatFits(sbvtgFrame.frame.size,inSizeClass:type)
                        if sbvtgFrame.multiple
                        {
                            sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)  //因为estimateLayoutRect执行后会还原，所以这里要重新设置
                        }
                    }
                }
                
            }
        
        if lsc.tg_orientation == .vert
        {
            
            if  vertGravity != .none
            {
                selfSize = self.tgLayoutSubviewsForVertGravity(selfSize,sbs:sbs, lsc:lsc)
            }
            else
            {
                selfSize = self.tgLayoutSubviewsForVert(selfSize,sbs:sbs,lsc:lsc)
            }
        }
        else
        {
            if  horzGravity != .none
            {
                selfSize = self.tgLayoutSubviewsForHorzGravity(selfSize,sbs:sbs, lsc:lsc)
            }
            else
            {
                selfSize = self.tgLayoutSubviewsForHorz(selfSize,sbs:sbs, lsc:lsc)
            }
        }
        
        
        if !isEstimate
        {
            self.tgSetLayoutIntelligentBorderline(sbs, lsc: lsc)
        }
        
        
        tgAdjustLayoutSelfSize(selfSize: &selfSize, lsc: lsc)
        
        tgAdjustSubviewsRTLPos(sbs: sbs, selfWidth: selfSize.width)
        
        return (self.tgAdjustSizeWhenNoSubviews(size: selfSize, sbs: sbs, lsc:lsc),hasSubLayout)
        
    }
    
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGLinearLayoutViewSizeClassImpl(view:self)
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
            
            sbv.tg_trailing.equal(0)
            if space != nil
            {
                sbv.tg_leading.equal(space)
            }
            else
            {
                sbv.tg_leading.equal(scale)
            }
            
            sbv.tg_width.equal(scale)
            
            if sbv == sbs.first && !centered
            {
                sbv.tg_leading.equal(0);
            }
            
            if sbv == sbs.last && centered
            {
                if space != nil
                {
                    sbv.tg_trailing.equal(space)
                }
                else
                {
                    sbv.tg_trailing.equal(scale)
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
            
            sbv.tg_leading.equal(scale)
            
            if sbv === sbs.first && !centered
            {
                sbv.tg_leading.equal(0);
            }
            
            if sbv === sbs.last
            {
                if centered
                {
                    sbv.tg_trailing.equal(scale)
                }
                else
                {
                    sbv.tg_trailing.equal(0)
                }
            }
        }
        
    }
    
    
    private func tgAdjustSelfWidth(_ sbs:[UIView], selfSize:CGSize, lsc:TGLinearLayoutViewSizeClassImpl) ->CGFloat
    {
        
        var maxSubviewWidth:CGFloat = 0
        var retWidth = selfSize.width
        //计算出最宽的子视图所占用的宽度
        if let t = lsc.tgWidth, t.isWrap
        {
            for sbv in sbs
            {
                let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
                let sbvtgFrame = sbv.tgFrame
                
                let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
                let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
                let sbvtgWidthIsFill = sbvsc.tgWidth?.isFill ?? false
                
                if (sbvsc.tgWidth?.dimeRelaVal == nil || sbvsc.tgWidth!.dimeRelaVal !== lsc.tgWidth) && !(sbvtgLeadingHasValue && sbvtgTrailingHasValue) && !sbvtgWidthIsFill && sbvsc.tgWidth?.dimeWeightVal == nil
                {
                    
                    var vWidth = sbvtgFrame.width
                    if sbvsc.tgWidth?.dimeNumVal != nil
                    {
                        vWidth = sbvsc.tgWidth!.measure
                    }
                    
                    vWidth = self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: vWidth, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    //左边 + 中间偏移+ 宽度 + 右边
                    maxSubviewWidth = self.tgCalcSelfSize(maxSubviewWidth,
                                                           subviewMeasure:vWidth,
                                                           headPos:sbvsc.tgLeading,
                                                           centerPos:sbvsc.tgCenterX,
                                                           tailPos:sbvsc.tgTrailing)
                    
                    
                }
            }
            
            retWidth = maxSubviewWidth + lsc.tg_leadingPadding + lsc.tg_trailingPadding;
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
        let ho:CGFloat = headPos?.offsetVal ?? 0
        let co:CGFloat = centerPos?.offsetVal ?? 0
        let to:CGFloat = tailPos?.offsetVal ?? 0
        //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
        
        if headPos?.posWeightVal != nil
        {
            tempWeight += headPos.posWeightVal
        }
        else
        {
            temp += hm
        }
        
        temp += ho
        
        if centerPos?.posWeightVal != nil
        {
            tempWeight += centerPos!.posWeightVal
        }
        else
        {
            temp += cm
            
        }
        
        temp += co
        
        if tailPos?.posWeightVal != nil
        {
            tempWeight += tailPos!.posWeightVal
            
        }
        else
        {
            temp += tm
        }
        
        temp += to
        
        
        if _tgCGFloatLessOrEqual(1, tempWeight.rawValue/100)
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
    
    
    
    fileprivate func tgLayoutSubviewsForVert(_ selfSize:CGSize, sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl)->CGSize
    {
        var fixedHeight:CGFloat = 0   //计算固定部分的高度
        var floatingHeight:CGFloat = 0 //浮动的高度。
        var totalWeight:TGWeight = .zeroWeight    //剩余部分的总比重
        var selfSize = selfSize
        let selftgHeightIsWrap = lsc.tgHeight?.isWrap ?? false
        let horzGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        
        selfSize.width = self.tgAdjustSelfWidth(sbs, selfSize:selfSize, lsc:lsc)   //调整自身的宽度
        
        var addSpace:CGFloat = 0
        var fixedSizeSbs = [UIView]()
        var fixedSizeHeight:CGFloat = 0
        var fixedSpaceCount:Int = 0
        var fixedSpaceHeight:CGFloat = 0
        var pos:CGFloat = lsc.tg_topPadding
        for sbv in sbs
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            var rect = sbvtgFrame.frame;
            
            let sbvFlexedHeight:Bool =  (sbvsc.tgHeight?.isFlexHeight ?? false)
            
            self.tgCalcLeadingTrailingRect(horzGravity: horzGravity, selfSize: selfSize, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect:&rect)
            
            if sbvsc.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbvsc.tgHeight!.measure
            }
            
            if ((sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === lsc.tgHeight) && !selftgHeightIsWrap)
            {
                rect.size.height = sbvsc.tgHeight!.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
            }
            
            if sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === sbvsc.tgWidth
            {
                rect.size.height = sbvsc.tgHeight!.measure(rect.size.width)
            }
            
            //如果子视图需要调整高度则调整高度
            if sbvFlexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            let sbvtgTopSpace = sbvsc.tgTop?.margin ?? 0
            let sbvtgBottomSpace = sbvsc.tgBottom?.margin ?? 0
            
            //计算固定高度和浮动高度。
            if sbvsc.tgTop?.posWeightVal != nil
            {
                totalWeight += sbvsc.tgTop!.posWeightVal
                fixedHeight += sbvsc.tgTop!.offsetVal
            }
            else
            {
                fixedHeight += sbvtgTopSpace
                if sbvtgTopSpace != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += sbvtgTopSpace
                }
            }
            
            pos += sbvtgTopSpace
            rect.origin.y = pos
            
            if sbvsc.tgHeight?.dimeWeightVal != nil
            {
                totalWeight += sbvsc.tgHeight!.dimeWeightVal
            }
            else if let t = sbvsc.tgHeight, t.isFill
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                fixedHeight += rect.height
                
                //如果最小高度不为自身则可以进行缩小。
                if !(sbvsc.tgHeight?.tgMinVal?.isWrap ?? false)
                {
                   fixedSizeHeight += rect.height
                   fixedSizeSbs.append(sbv)
                }
            }
            
            pos += rect.size.height
            
            if sbvsc.tgBottom?.posWeightVal != nil
            {
                totalWeight += sbvsc.tgBottom!.posWeightVal
                fixedHeight += sbvsc.tgBottom!.offsetVal
            }
            else
            {
                fixedHeight += sbvtgBottomSpace
                if sbvtgBottomSpace != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += sbvtgBottomSpace
                }
            }
            
            pos += sbvtgBottomSpace

            
            if sbv != sbs.last
            {
                fixedHeight += lsc.tg_vspace
                
                pos += lsc.tg_vspace
                
                if lsc.tg_vspace != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += lsc.tg_vspace
                }
            }
            
            sbvtgFrame.frame = rect;
        }
        
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if selftgHeightIsWrap && totalWeight != .zeroWeight
        {
            var tempSelfHeight = lsc.tg_topPadding + lsc.tg_bottomPadding
            if sbs.count > 1
            {
              tempSelfHeight += CGFloat(sbs.count - 1) * lsc.tg_vspace
            }
            
            selfSize.height = self.tgValidMeasure(lsc.tgHeight,sbv:self,calcSize:tempSelfHeight,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
            
        }

        
        //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
        var isWeightShrinkSpace = false
        var weightShrinkSpaceTotalHeight:CGFloat = 0.0
        floatingHeight = selfSize.height - fixedHeight - lsc.tg_topPadding - lsc.tg_bottomPadding
        let sstMode:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0x0F)  //压缩策略
        let sstContent:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0xF0) //压缩内容
        if _tgCGFloatLessOrEqual(floatingHeight, 0)
        {
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
                        else if  _tgCGFloatNotEqual(fixedSizeHeight, 0)
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
        
        if totalWeight != .zeroWeight || (sstMode != .none && _tgCGFloatLessOrEqual(floatingHeight, 0))
        {
            pos = lsc.tg_topPadding
            for sbv in sbs
            {
                let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
                let sbvtgFrame = sbv.tgFrame
                
                var  topSpace:CGFloat = sbvsc.tgTop?.posNumVal ?? 0
                var  bottomSpace:CGFloat = sbvsc.tgBottom?.posNumVal ?? 0
                let  topOffset = sbvsc.tgTop?.offsetVal ?? 0
                let  bottomOffset = sbvsc.tgBottom?.offsetVal ?? 0
                
                var rect:CGRect =  sbvtgFrame.frame;
                
                //分别处理相对顶部边距和绝对顶部边距
                if sbvsc.tgTop?.posWeightVal != nil
                {
                    topSpace = (sbvsc.tgTop!.posWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                    if  _tgCGFloatLessOrEqual(topSpace, 0)
                    {
                        topSpace = 0
                    }
                    
                }
                else
                {
                    if (topSpace + topOffset != 0)
                    {
                        pos += addSpace
                        
                        if (isWeightShrinkSpace)
                        {
                            pos += weightShrinkSpaceTotalHeight * (topSpace + topOffset) / fixedSpaceHeight;
                        }
                    }
                    
                }
                
                pos +=   self.tgValidMargin(sbvsc.tgTop, sbv: sbv, calcPos: topSpace + topOffset, selfLayoutSize: selfSize)
                
                //分别处理相对高度和绝对高度
                rect.origin.y = pos;
                if sbvsc.tgHeight?.dimeWeightVal != nil
                {
                    var  h:CGFloat = (sbvsc.tgHeight!.dimeWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                    if  _tgCGFloatLessOrEqual(h, 0)
                    {
                        h = 0;
                    }
                    
                    rect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                }
                else if let t = sbvsc.tgHeight, t.isFill
                {
                    var  h:CGFloat = (100.0 / totalWeight.rawValue) * floatingHeight;
                    if  _tgCGFloatLessOrEqual(h, 0)
                    {
                        h = 0;
                    }
                    
                    rect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                }
                
                pos += rect.size.height;
                
                //分别处理相对底部边距和绝对底部边距
                if sbvsc.tgBottom?.posWeightVal != nil
                {
                    bottomSpace = (sbvsc.tgBottom!.posWeightVal.rawValue / totalWeight.rawValue) * floatingHeight;
                    if  _tgCGFloatLessOrEqual(bottomSpace, 0)
                    {
                        bottomSpace = 0;
                    }
                    
                }
                else
                {
                    if (bottomSpace + bottomOffset != 0)
                    {
                        pos += addSpace
                        
                        if (isWeightShrinkSpace)
                        {
                            pos += weightShrinkSpaceTotalHeight * (bottomSpace + bottomOffset) / fixedSpaceHeight;
                        }
                    }
                    
                }
                
                pos +=  self.tgValidMargin(sbvsc.tgBottom,sbv: sbv, calcPos: bottomSpace + bottomOffset, selfLayoutSize: selfSize)
                
                if sbv != sbs.last
                {
                    pos += lsc.tg_vspace
                    
                    if (lsc.tg_vspace != 0)
                    {
                        pos += addSpace;
                        
                        if (isWeightShrinkSpace)
                        {
                            pos += weightShrinkSpaceTotalHeight * lsc.tg_vspace / fixedSpaceHeight;
                        }
                    }
                    
                }
                
                sbvtgFrame.frame = rect
            }
        }
        
        pos += lsc.tg_bottomPadding;
        
        
        if selftgHeightIsWrap
        {
            selfSize.height = pos
        }
        
        return selfSize
        
        
    }
    
    fileprivate func tgLayoutSubviewsForHorz(_ selfSize:CGSize, sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl)->CGSize
    {
        
        let selftgWidthIsWrap = lsc.tgWidth?.isWrap ?? false
        let selftgHeightIsWrap = lsc.tgHeight?.isWrap ?? false
        let vertGravity = lsc.tg_gravity & TGGravity.horz.mask
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
            
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            let leadingSpace = sbvsc.tgLeading?.margin ?? 0
            let trailingSpace = sbvsc.tgTrailing?.margin ?? 0
            
            if sbvsc.tgLeading?.posWeightVal != nil
            {
                totalWeight += sbvsc.tgLeading!.posWeightVal
                fixedWidth += sbvsc.tgLeading!.offsetVal
            }
            else
            {
                fixedWidth += leadingSpace
                
                if (leadingSpace != 0)
                {
                    fixedSpaceCount += 1;
                    fixedSpaceWidth += leadingSpace
                }
            }
            
            if sbvsc.tgTrailing?.posWeightVal != nil
            {
                totalWeight += sbvsc.tgTrailing!.posWeightVal
                fixedWidth += sbvsc.tgTrailing!.offsetVal
            }
            else
            {
                fixedWidth += trailingSpace
                
                if (trailingSpace != 0)
                {
                    fixedSpaceCount += 1
                    fixedSpaceWidth += trailingSpace
                }

            }
            
            if (sbvsc.tgWidth?.dimeWeightVal != nil)
            {
                totalWeight += sbvsc.tgWidth!.dimeWeightVal
            }
            else if let t = sbvsc.tgWidth, t.isFill
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                var vWidth = sbvtgFrame.width;
                if (sbvsc.tgWidth?.dimeNumVal != nil)
                {
                    vWidth = sbvsc.tgWidth!.measure;
                }
                
                if ((sbvsc.tgWidth?.dimeRelaVal != nil && sbvsc.tgWidth!.dimeRelaVal === lsc.tgWidth) && !selftgWidthIsWrap)
                {
                    vWidth = sbvsc.tgWidth!.measure(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding)
                }
                
                vWidth = self.tgValidMeasure(sbvsc.tgWidth,sbv:sbv,calcSize:vWidth,sbvSize:sbvtgFrame.frame.size,selfLayoutSize:selfSize)
                
                sbvtgFrame.width = vWidth
                
                fixedWidth += vWidth
                
                if !(sbvsc.tgWidth?.tgMinVal?.isWrap ?? false)
                {
                   fixedSizeWidth += vWidth
                   fixedSizeSbs.append(sbv)
                }
                
                if let t = sbvsc.tgWidth, t.isWrap
                {
                    flexedSizeSbs.append(sbv)
                }
            }
            
            if sbv != sbs.last
            {
                fixedWidth += lsc.tg_hspace
                
                if (lsc.tg_hspace != 0)
                {
                    fixedSpaceCount += 1
                    fixedSpaceWidth += lsc.tg_hspace
                }
            }
        }
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if (selftgWidthIsWrap && totalWeight != .zeroWeight)
        {
            var tempSelfWidth = lsc.tg_leadingPadding + lsc.tg_trailingPadding
            if sbs.count > 1
            {
             tempSelfWidth += CGFloat(sbs.count - 1) * lsc.tg_hspace
            }
            
            selfSize.width = self.tgValidMeasure(lsc.tgWidth,sbv:self,calcSize:tempSelfWidth,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
        }
        
        //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
        var isWeightShrinkSpace = false   //是否按比重缩小间距。。。
        var weightShrinkSpaceTotalWidth:CGFloat = 0.0
        floatingWidth = selfSize.width - fixedWidth - lsc.tg_leadingPadding - lsc.tg_trailingPadding;
        if _tgCGFloatLessOrEqual(floatingWidth, 0)
        {
            var sstMode:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0x0F)  //压缩策略
            let sstContent:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0xF0) //压缩内容

            
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
                        else if  _tgCGFloatNotEqual(fixedSizeWidth, 0)
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
        var pos:CGFloat = lsc.tg_leadingPadding;
        for sbv in sbs
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            var leadingSpace = sbvsc.tgLeading?.posNumVal ?? 0
            var trailingSpace = sbvsc.tgTrailing?.posNumVal ?? 0
            let leadingOffset = sbvsc.tgLeading?.offsetVal ?? 0
            let trailingOffset = sbvsc.tgTrailing?.offsetVal ?? 0
            let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
            let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false
            let sbvtgHeightIsFill = sbvsc.tgHeight?.isFill ?? false
            
            var rect:CGRect =  sbvtgFrame.frame;
            
        
            if sbvsc.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbvsc.tgHeight!.measure;
            }
            
            
            if (sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === lsc.tgHeight)
            {
                rect.size.height = sbvsc.tgHeight!.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
            }
            
            
            
            //计算出先对左边边距和绝对左边边距
            if sbvsc.tgLeading?.posWeightVal != nil
            {
                leadingSpace = (sbvsc.tgLeading!.posWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if  _tgCGFloatLessOrEqual(leadingSpace, 0)
                {
                    leadingSpace = 0
                }
                
            }
            else
            {
                if (leadingSpace + leadingOffset != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * (leadingSpace + leadingOffset) / fixedSpaceWidth;
                    }
                }

            }
            
            pos += self.tgValidMargin(sbvsc.tgLeading, sbv: sbv, calcPos: leadingSpace + leadingOffset, selfLayoutSize: selfSize)
            
            
            //计算出相对宽度和绝对宽度
            rect.origin.x = pos;
            if sbvsc.tgWidth?.dimeWeightVal != nil
            {
                var w = (sbvsc.tgWidth!.dimeWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if  _tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w
            }
            else if let t = sbvsc.tgWidth, t.isFill
            {
                var w = (100.0 / totalWeight.rawValue) * floatingWidth;
                if  _tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w

            }
            
            rect.size.width =  self.tgValidMeasure(sbvsc.tgWidth, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            pos += rect.size.width
            
            //计算相对的右边边距和绝对的右边边距
            if sbvsc.tgTrailing?.posWeightVal != nil
            {
                trailingSpace = (sbvsc.tgTrailing!.posWeightVal.rawValue / totalWeight.rawValue) * floatingWidth;
                if  _tgCGFloatLessOrEqual(trailingSpace, 0)
                {
                    trailingSpace = 0;
                }
                
                
            }
            else
            {
                if (trailingSpace + trailingOffset != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * (trailingSpace + trailingOffset) / fixedSpaceWidth;
                    }
                }

            }
            
            pos +=  self.tgValidMargin(sbvsc.tgTrailing, sbv: sbv, calcPos: trailingSpace + trailingOffset, selfLayoutSize: selfSize)
            
            
            if sbv != sbs.last
            {
                pos += lsc.tg_hspace
                
                if (lsc.tg_hspace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * lsc.tg_hspace / fixedSpaceWidth
                    }
                }

            }
            
            if sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === sbvsc.tgWidth
            {
                rect.size.height = sbvsc.tgHeight!.measure(rect.size.width)
            }
            
            //如果高度是浮动的则需要调整高度。
            if let t = sbvsc.tgHeight, t.isFlexHeight //sbv.flexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize:rect.size, selfLayoutSize: selfSize)
            
            if selftgHeightIsWrap
            {
                //计算最高的高度。
                if  (sbvsc.tgHeight?.dimeRelaVal == nil || sbvsc.tgHeight!.dimeRelaVal !== lsc.tgHeight) && !(sbvtgTopHasValue && sbvtgBottomHasValue) && !sbvtgHeightIsFill && sbvsc.tgHeight?.dimeWeightVal == nil
                {
                    maxSubviewHeight = self.tgCalcSelfSize(maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbvsc.tgTop, centerPos:sbvsc.tgCenterY,tailPos:sbvsc.tgBottom)
                }
            }
            else
            {
                self.tgCalcTopBottomRect(vertGravity:vertGravity, selfSize: selfSize, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
            }
            
            sbvtgFrame.frame = rect;
        }
        
        pos += lsc.tg_trailingPadding;
        
        if selftgWidthIsWrap
        {
            selfSize.width = pos
        }
        
        if selftgHeightIsWrap
        {
            selfSize.height = maxSubviewHeight + lsc.tg_topPadding + lsc.tg_bottomPadding
            
            //调整所有子视图的高度
            for sbv in sbs
            {
                let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
                let sbvtgFrame = sbv.tgFrame
                var rect:CGRect = sbvtgFrame.frame;
                
                self.tgCalcTopBottomRect(vertGravity:vertGravity, selfSize: selfSize, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
                
                sbvtgFrame.frame = rect
            }
            
        }
        
        return selfSize
    }
    
    
    fileprivate func tgLayoutSubviewsForVertGravity(_ selfSize:CGSize, sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl) ->CGSize
    {
     
        let vertGravity = lsc.tg_gravity & TGGravity.horz.mask
        let horzGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let selftgHeightIsWrap = lsc.tgHeight?.isWrap ?? false
        
        var totalHeight:CGFloat = 0
        
        if sbs.count > 1
        {
            totalHeight += CGFloat(sbs.count - 1) * lsc.tg_vspace
        }
        
        var selfSize = selfSize
        selfSize.width = self.tgAdjustSelfWidth(sbs, selfSize:selfSize, lsc:lsc)
        
        var floatingHeight:CGFloat = selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding - totalHeight
        if  _tgCGFloatLessOrEqual(floatingHeight, 0)
        {
            floatingHeight = 0
        }
        
        //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
        var noWrapsbsSet = Set<UIView>()
        for sbv in sbs
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            let topSpace = sbvsc.tgTop?.realMarginInSize(floatingHeight) ?? 0
            let bottomSpace = sbvsc.tgBottom?.realMarginInSize(floatingHeight) ?? 0
            
            var canAddToNoWrapSbs = true
            
            var rect:CGRect =  sbvtgFrame.frame;
            let isFlexedHeight:Bool = (sbvsc.tgHeight?.isFlexHeight ?? false)
            
             self.tgCalcLeadingTrailingRect(horzGravity: horzGravity , selfSize: selfSize, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
            
            if sbvsc.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbvsc.tgHeight!.measure
            }
            
            
            if ((sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === lsc.tgHeight) && !selftgHeightIsWrap)
            {
                rect.size.height = sbvsc.tgHeight!.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
                canAddToNoWrapSbs = false
            }

           
            if sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === sbvsc.tgWidth
            {
                rect.size.height = sbvsc.tgHeight!.measure(rect.size.width)
            }
            //如果子视图需要调整高度则调整高度
            if isFlexedHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
                canAddToNoWrapSbs = false
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbvsc.tgHeight?.tgMinVal?.isWrap ?? false)
            {
                canAddToNoWrapSbs = false
            }
            
            
            totalHeight += topSpace
            totalHeight += rect.size.height;
            totalHeight += bottomSpace
            
            
            sbvtgFrame.frame = rect
            
            if  let t = sbvsc.tgHeight, t.isWrap && vertGravity == TGGravity.vert.fill
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
        
        if vertGravity == TGGravity.vert.top
        {
            pos = lsc.tg_topPadding;
        }
        else if vertGravity == TGGravity.vert.center
        {
            pos = (selfSize.height - totalHeight - lsc.tg_bottomPadding - lsc.tg_topPadding)/2.0;
            pos += lsc.tg_topPadding;
        }
        else if vertGravity == TGGravity.vert.windowCenter
        {
            if let win = self.window
            {
                pos = (win.bounds.size.height - totalHeight)/2.0;
                
                let pt = CGPoint(x: 0, y: pos);
                pos = win.convert(pt,to:self as UIView?).y;
                
                
            }
        }
        else if vertGravity == TGGravity.vert.bottom
        {
            pos = selfSize.height - totalHeight - lsc.tg_bottomPadding
        }
        else if vertGravity == TGGravity.vert.between
        {
            pos = lsc.tg_topPadding;
            
            if sbs.count > 1
            {
              between = (selfSize.height - totalHeight - lsc.tg_topPadding - lsc.tg_bottomPadding) / CGFloat(sbs.count - 1)
            }
        }
        else if vertGravity == TGGravity.vert.fill
        {
            pos = lsc.tg_topPadding
            if noWrapsbsSet.count > 0
            {
                fill = (selfSize.height - totalHeight - lsc.tg_topPadding - lsc.tg_bottomPadding) / CGFloat(noWrapsbsSet.count)
            }
        }
        else
        {
            pos = lsc.tg_topPadding
        }
        
        
        for sbv in sbs
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            let topSpace = sbvsc.tgTop?.realMarginInSize(floatingHeight) ?? 0
            let bottomSpace = sbvsc.tgBottom?.realMarginInSize(floatingHeight) ?? 0
        
            pos += topSpace
            
            sbvtgFrame.top = pos;
            
            if fill != 0 && noWrapsbsSet.contains(sbv)
            {
                sbvtgFrame.height += fill
            }
            
            pos +=  sbvtgFrame.height;
            
            pos += bottomSpace
            
            if sbv != sbs.last
            {
                pos += lsc.tg_vspace;
            }
            
            pos += between
        }
        
        return selfSize;
        
    }
    
    fileprivate func tgLayoutSubviewsForHorzGravity(_ selfSize:CGSize, sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl)->CGSize
    {
        let vertGravity = lsc.tg_gravity & TGGravity.horz.mask
        let horzGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let selftgWidthIsWrap = lsc.tgWidth?.isWrap ?? false
        let selftgHeightIsWrap = lsc.tgHeight?.isWrap ?? false
        var totalWidth:CGFloat = 0;
        if sbs.count > 1
        {
            totalWidth += CGFloat(sbs.count - 1) * lsc.tg_hspace
        }
        
        
        var floatingWidth:CGFloat = 0;
        
        var maxSubviewHeight:CGFloat = 0;
        
        var selfSize = selfSize
        floatingWidth = selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding - totalWidth;
        if  _tgCGFloatLessOrEqual(floatingWidth, 0)
        {
            floatingWidth = 0
        }
        
        //计算出固定的高度
        var noWrapsbsSet = Set<UIView>()
        for sbv in sbs
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
            let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false
            let sbvtgHeightIsFill = sbvsc.tgHeight?.isFill ?? false
            let sbvtgWidthIsWrap = sbvsc.tgWidth?.isWrap ?? false
            let leadingSpace = sbvsc.tgLeading?.realMarginInSize(floatingWidth) ?? 0
            let trailingSpace = sbvsc.tgTrailing?.realMarginInSize(floatingWidth) ?? 0
            
            
            
            var canAddToNoWrapSbs = true
            
            var rect = sbvtgFrame.frame;
            
            if sbvsc.tgWidth?.dimeNumVal != nil
            {
                rect.size.width = sbvsc.tgWidth!.measure;
            }
            
            if sbvsc.tgHeight?.dimeNumVal != nil
            {
                rect.size.height = sbvsc.tgHeight!.measure
            }
            
            if ((sbvsc.tgWidth?.dimeRelaVal != nil && sbvsc.tgWidth!.dimeRelaVal === lsc.tgWidth) && !selftgWidthIsWrap)
            {
                rect.size.width = sbvsc.tgWidth!.measure(selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding)
                canAddToNoWrapSbs = false
            }
            
            if (sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === lsc.tgHeight)
            {
                rect.size.height = sbvsc.tgHeight!.measure(selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding)
            }
            
            if (sbvsc.tgWidth?.dimeRelaVal != nil && sbvsc.tgWidth!.dimeRelaVal === sbvsc.tgHeight)
            {
                rect.size.width = sbvsc.tgWidth!.measure(rect.size.height)
            }
            
            rect.size.width = self.tgValidMeasure(sbvsc.tgWidth,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            if (sbvsc.tgWidth?.tgMinVal?.isWrap ?? false)
            {
                canAddToNoWrapSbs = false
            }
            
            if (sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === sbvsc.tgWidth)
            {
                rect.size.height = sbvsc.tgHeight!.measure(rect.size.width)
            }
            
            //如果高度是浮动的则需要调整高度。
            if let t = sbvsc.tgHeight, t.isFlexHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算以子视图为大小的情况
            if selftgHeightIsWrap &&
                (sbvsc.tgHeight?.dimeRelaVal == nil || sbvsc.tgHeight!.dimeRelaVal !== lsc.tgHeight) &&
                !(sbvtgTopHasValue && sbvtgBottomHasValue) &&
                !sbvtgHeightIsFill &&
                sbvsc.tgHeight?.dimeWeightVal == nil
            {
                maxSubviewHeight = self.tgCalcSelfSize(maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbvsc.tgTop, centerPos:sbvsc.tgCenterY, tailPos:sbvsc.tgBottom)
            }
            
            
            
            totalWidth += leadingSpace
            
            totalWidth += rect.size.width
            
            
            totalWidth += trailingSpace
            
            sbvtgFrame.frame = rect
            
            if horzGravity == TGGravity.horz.fill && sbvtgWidthIsWrap
            {
                canAddToNoWrapSbs = false
            }
            
            if canAddToNoWrapSbs
            {
                noWrapsbsSet.insert(sbv)
            }
            
        }
        
        
        //调整自己的高度。
        if selftgHeightIsWrap
        {
            selfSize.height = maxSubviewHeight + lsc.tg_topPadding + lsc.tg_bottomPadding;
        }
        
        //根据对齐的方位来定位子视图的布局对齐
        var pos:CGFloat = 0
        var between:CGFloat = 0
        var fill:CGFloat = 0
        
        if horzGravity == TGGravity.horz.leading
        {
            pos = lsc.tg_leadingPadding
        }
        else if horzGravity == TGGravity.horz.center
        {
            pos = (selfSize.width - totalWidth - lsc.tg_leadingPadding - lsc.tg_trailingPadding)/2.0;
            pos += lsc.tg_leadingPadding;
        }
        else if horzGravity == TGGravity.horz.windowCenter
        {
            if let win = self.window
            {
                pos = (win.bounds.size.width - totalWidth)/2.0;
                
                let  pt = CGPoint(x: pos, y: 0);
                pos = win.convert(pt,to:self as UIView?).x
                
                if TGBaseLayout.tg_isRTL
                {
                    pos += selfSize.width - win.bounds.width
                }
            }
        }
        else if horzGravity == TGGravity.horz.trailing
        {
            pos = selfSize.width - totalWidth - lsc.tg_trailingPadding;
        }
        else if horzGravity == TGGravity.horz.between
        {
            pos = lsc.tg_leadingPadding
            
            if sbs.count > 1
            {
                between = (selfSize.width - totalWidth - lsc.tg_leadingPadding - lsc.tg_trailingPadding) / CGFloat(sbs.count - 1)
            }
        }
        else if horzGravity == TGGravity.horz.fill
        {
            pos = lsc.tg_leadingPadding
            
            if noWrapsbsSet.count > 0
            {
                fill = (selfSize.width - totalWidth - lsc.tg_leadingPadding - lsc.tg_trailingPadding) / CGFloat(noWrapsbsSet.count)
            }
        }
        else
        {
            pos = lsc.tg_leadingPadding
        }
        
        
        for sbv in sbs
        {
            let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
            let sbvtgFrame = sbv.tgFrame
            
            let leadingSpace = sbvsc.tgLeading?.realMarginInSize(floatingWidth) ?? 0
            let trailingSpace = sbvsc.tgTrailing?.realMarginInSize(floatingWidth) ?? 0
            
            
            pos += leadingSpace
            
            
            var rect = sbvtgFrame.frame;
            rect.origin.x = pos;
            
            self.tgCalcTopBottomRect(vertGravity: vertGravity, selfSize: selfSize, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
            
            if fill != 0 && noWrapsbsSet.contains(sbv)
            {
                rect.size.width += fill
            }
            
            sbvtgFrame.frame = rect
            
            pos += rect.size.width
            
            pos += trailingSpace
            
            if sbv != sbs.last
            {
                pos += lsc.tg_hspace;
            }
            
            pos += between;  //只有mghorz为between才加这个间距拉伸。
        }
        
        return selfSize;
    }

    
    fileprivate func tgGetSubviewVertGravity(_ sbv:UIView, sbvsc:TGViewSizeClassImpl, vertGravity:TGGravity)->TGGravity
    {
        var sbvVertGravity:TGGravity = TGGravity.vert.top
        if vertGravity != .none
        {
            sbvVertGravity = vertGravity
        }
        else
        {
            let sbvtgCenterYHasValue = sbvsc.tgCenterY?.hasValue ?? false
            let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
            let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false


            if sbvtgCenterYHasValue
            {
                sbvVertGravity = TGGravity.vert.center;
            }
            else if sbvtgTopHasValue && sbvtgBottomHasValue
            {
                sbvVertGravity = TGGravity.vert.fill;
            }
            else if sbvtgTopHasValue
            {
                sbvVertGravity = TGGravity.vert.top;
            }
            else if sbvtgBottomHasValue
            {
                sbvVertGravity = TGGravity.vert.bottom
            }
        }
        
        return sbvVertGravity
    }
    
    fileprivate func tgGetSubviewHorzGravity(_ sbv:UIView, sbvsc:TGViewSizeClassImpl, horzGravity:TGGravity)->TGGravity
    {
        var sbvHorzGravity:TGGravity = TGGravity.horz.leading
        if horzGravity != .none
        {
            sbvHorzGravity = horzGravity
        }
        else
        {
            let sbvtgCenterXHasValue = sbvsc.tgCenterX?.hasValue ?? false
            let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
            let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
            
            
            if sbvtgCenterXHasValue
            {
                sbvHorzGravity = TGGravity.horz.center
            }
            else if sbvtgLeadingHasValue && sbvtgTrailingHasValue
            {
                sbvHorzGravity = TGGravity.horz.fill;
            }
            else if sbvtgLeadingHasValue
            {
                sbvHorzGravity = TGGravity.horz.leading
            }
            else if sbvtgTrailingHasValue
            {
                sbvHorzGravity = TGGravity.horz.trailing
            }
        }
        
        return sbvHorzGravity
    }
    
    fileprivate func tgAdjustSubviewWrapContent(sbvsc:TGViewSizeClassImpl, lsc:TGLinearLayoutViewSizeClassImpl)
    {
        if lsc.tg_orientation == .vert
        {
            let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
            let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false
            
            if (sbvtgLeadingHasValue && sbvtgTrailingHasValue) ||
                (lsc.tg_gravity & TGGravity.vert.mask) == TGGravity.horz.fill
            {
                sbvsc.tgWidth?._dimeVal = nil
            }
        }
        else
        {
            let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
            let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false
            
            if (sbvtgTopHasValue && sbvtgBottomHasValue) ||
                (lsc.tg_gravity & TGGravity.horz.mask) == TGGravity.vert.fill
            {
                sbvsc.tgHeight?._dimeVal = nil
            }
        }
    }
    
    fileprivate func tgCalcLeadingTrailingRect(horzGravity:TGGravity, selfSize:CGSize, sbv:UIView, sbvsc:TGViewSizeClassImpl, lsc:TGLinearLayoutViewSizeClassImpl, rect:inout CGRect)
    {
        
        let floatingWidth = selfSize.width - lsc.tg_leadingPadding - lsc.tg_trailingPadding
        let realLeadingMargin = sbvsc.tgLeading?.realMarginInSize(floatingWidth) ?? 0
        let realTrailingMargin = sbvsc.tgTrailing?.realMarginInSize(floatingWidth) ?? 0
        let sbvtgLeadingHasValue = sbvsc.tgLeading?.hasValue ?? false
        let sbvtgTrailingHasValue = sbvsc.tgTrailing?.hasValue ?? false

        
        if sbvsc.tgWidth?.dimeNumVal != nil
        {
            rect.size.width = sbvsc.tgWidth!.measure
        }
        
        //和父视图保持一致。
        if (sbvsc.tgWidth?.dimeRelaVal != nil && sbvsc.tgWidth!.dimeRelaVal === lsc.tgWidth)
        {
            rect.size.width = sbvsc.tgWidth!.measure(floatingWidth)
        }
        
        //占用父视图的宽度的比例。
        if sbvsc.tgWidth?.dimeWeightVal != nil
        {
            rect.size.width = sbvsc.tgWidth!.measure(floatingWidth*sbvsc.tgWidth!.dimeWeightVal.rawValue / 100)
        }
        
        //如果填充
        if let t = sbvsc.tgWidth, t.isFill
        {
            rect.size.width = sbvsc.tgWidth!.measure(floatingWidth - realLeadingMargin - realTrailingMargin)
        }
        
        
        if sbvtgLeadingHasValue && sbvtgTrailingHasValue
        {
            rect.size.width = floatingWidth - realLeadingMargin - realTrailingMargin
        }
        
        rect.size.width = self.tgValidMeasure(sbvsc.tgWidth,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
        self.tgCalcHorzGravity(self.tgGetSubviewHorzGravity(sbv, sbvsc:sbvsc, horzGravity: horzGravity), selfSize:selfSize, sbv:sbv,sbvsc:sbvsc, lsc:lsc, rect:&rect)
    }
    
    fileprivate func tgCalcTopBottomRect(vertGravity:TGGravity, selfSize:CGSize, sbv:UIView, sbvsc:TGViewSizeClassImpl, lsc:TGLinearLayoutViewSizeClassImpl, rect:inout CGRect)
    {
        
        let floatingHeight = selfSize.height - lsc.tg_topPadding - lsc.tg_bottomPadding
        let realTopMargin = sbvsc.tgTop?.realMarginInSize(floatingHeight) ?? 0
        let realBottomMargin = sbvsc.tgBottom?.realMarginInSize(floatingHeight) ?? 0
        let sbvtgTopHasValue = sbvsc.tgTop?.hasValue ?? false
        let sbvtgBottomHasValue = sbvsc.tgBottom?.hasValue ?? false
        
        if (sbvsc.tgHeight?.dimeRelaVal != nil && sbvsc.tgHeight!.dimeRelaVal === lsc.tgHeight)
        {
            rect.size.height = sbvsc.tgHeight!.measure(floatingHeight)
        }
        else if sbvsc.tgHeight?.dimeWeightVal != nil
        {
            rect.size.height = sbvsc.tgHeight!.measure(floatingHeight * sbvsc.tgHeight!.dimeWeightVal.rawValue/100)
        }
        else if let t = sbvsc.tgHeight, t.isFill
        {
            rect.size.height = sbvsc.tgHeight!.measure(floatingHeight - realTopMargin - realBottomMargin)
        }
        
        
        if sbvtgTopHasValue && sbvtgBottomHasValue
        {
            rect.size.height = floatingHeight - realTopMargin - realBottomMargin
        }
        
        
        
        //优先以容器中的指定为标准
        rect.size.height = self.tgValidMeasure(sbvsc.tgHeight, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
        self.tgCalcVertGravity(self.tgGetSubviewVertGravity(sbv, sbvsc:sbvsc, vertGravity: vertGravity), selfSize:selfSize, sbv:sbv, sbvsc:sbvsc, lsc:lsc, rect:&rect)

    }

    fileprivate func tgSetLayoutIntelligentBorderline(_ sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl)
    {
        if self.tg_intelligentBorderline == nil
        {
            return
        }
        
        var subviewSpace =  lsc.tg_vspace
        if lsc.tg_orientation == .horz
        {
            subviewSpace = lsc.tg_hspace
        }
        
        for i in 0 ..< sbs.count
        {
            let sbv = sbs[i]
            if let sbvl = sbv as? TGBaseLayout
            {
                if !sbvl.tg_notUseIntelligentBorderline
                {
                    if lsc.tg_orientation == .vert
                    {
                        sbvl.tg_topBorderline = nil;
                        sbvl.tg_bottomBorderline = nil;
                    }
                    else
                    {
                        sbvl.tg_leadingBorderline = nil;
                        sbvl.tg_trailingBorderline = nil;
                    }
                    
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
                        if let prevSiblingLayout = prevSiblingView as? TGBaseLayout, subviewSpace == 0
                        {
                            if (prevSiblingLayout.tg_notUseIntelligentBorderline)
                            {
                                ok = false
                            }
                        }
                        
                        if (ok)
                        {
                            if lsc.tg_orientation == .vert
                            {
                                sbvl.tg_topBorderline = self.tg_intelligentBorderline
                            }
                            else
                            {
                                sbvl.tg_leadingBorderline = self.tg_intelligentBorderline
                            }
                            
                        }
                    }
                    
                    if nextSiblingView != nil && ((nextSiblingView as? TGBaseLayout) == nil || subviewSpace != 0)
                    {
                        if lsc.tg_orientation == .vert
                        {
                            sbvl.tg_bottomBorderline = self.tg_intelligentBorderline;
                        }
                        else
                        {
                            sbvl.tg_trailingBorderline = self.tg_intelligentBorderline;
                        }
                    }
                }
            }
            
        }
        
    }
    
}


