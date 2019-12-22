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
        
        self.init(frame:CGRect.zero, orientation:orientation)
        
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
     *用来设置当线性布局中的子视图的尺寸大于线性布局的尺寸时的子视图压缩策略。默认值是.none。
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
     设置水平线性布局里面的基线对齐基准视图，所有其他子视图的基线都以这个为准。
     这个属性要和tg_gravity属性设置为TGGravity.vert.baseline配合使用。并且要求这个属性所指定的视图，必须具有font属性。
     目前支持具有font属性的有UILabel，UITextField,UITextView, UIButton几个系统控件。
     */
    public var tg_baselineBaseView:UIView!
    
    
    /**
     *均分子视图和间距,布局会根据里面的子视图的数量来平均分配子视图的高度或者宽度以及间距。
     *这个函数只对已经加入布局的视图有效，函数调用后新加入的子视图无效。
     *@centered参数描述是否所有子视图居中，当居中时对于垂直线性布局来说顶部和底部会保留出间距，而不居中时则顶部和底部不保持间距
     *@space参数指定子视图之间的固定间距。
     *@type参数表示设置在指定sizeClass下进行子视图和间距的均分
     */
    public func tg_equalizeSubviews(centered:Bool, withSpace space:CGFloat! = nil, inSizeClass type:TGSizeClassType = TGSizeClassType.default)
    {
        switch type {
        case TGSizeClassType.default:
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:type)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:type)
            }
        }
        
        if self.tg_orientation == TGOrientation.vert
        {
            tgEqualizeSubviewsForVert(centered, withSpace: space)
        }
        else
        {
            tgEqualizeSubviewsForHorz(centered, withSpace: space)
            
        }
        
        switch type {
        case TGSizeClassType.default:
            self.setNeedsLayout()
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:TGSizeClassType.default)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:TGSizeClassType.default)
            }
        }

    }
    
    /**
     *均分子视图的间距，上面函数会调整子视图的尺寸以及间距，而这个函数则是子视图的尺寸保持不变而间距自动平均分配，也就是用布局视图的剩余空间来均分间距
     *@centered参数意义同上。
     *@type参数的意义同上。
     */
    public func tg_equalizeSubviewsSpace(centered:Bool, inSizeClass type:TGSizeClassType = TGSizeClassType.default)
    {
        
        switch type {
        case TGSizeClassType.default:
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:type)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:type)
            }
        }
        
        if self.tg_orientation == TGOrientation.vert
        {
            tgEqualizeSubviewsSpaceForVert(centered)
        }
        else
        {
            tgEqualizeSubviewsSpaceForHorz(centered)
        }
        
        
        switch type {
        case TGSizeClassType.default:
            self.setNeedsLayout()
            break
        default:
            self.tgFrame.sizeClass = self.tg_fetchSizeClass(with:TGSizeClassType.default)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tg_fetchSizeClass(with:TGSizeClassType.default)
            }
        }
    }
    
    /**
     *在一些应用场景中我们有时候希望某些子视图的宽度或者高度是固定的情况下，子视图的间距是浮动的而不是固定的。比如每个子视图的宽度是固定80，那么在小屏幕下每行只能放3个，而我们希望大屏幕每行能放4个或者5个子视图。 因此您可以通过如下方法来设置浮动间距，这个方法会根据您当前布局的orientation方向不同而意义不同：
     1.如果您的布局方向是.vert表示设置的是子视图的水平间距，其中的size指定的是子视图的宽度，minSpace指定的是最小的水平间距,maxSpace指定的是最大的水平间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的宽度。
     2.如果您的布局方向是.horz表示设置的是子视图的垂直间距，其中的size指定的是子视图的高度，minSpace指定的是最小的垂直间距,maxSpace指定的是最大的垂直间距，如果指定的subviewSize计算出的间距大于这个值则会调整subviewSize的高度。
     3.如果您不想使用浮动间距则请将subviewSize设置为0就可以了。
     4. centered属性指定这个浮动间距是否包括最左边和最右边两个区域，也就是说当设置为true时视图之间以及视图与父视图之间的间距都是相等的，而设置为false时则只有视图之间的间距相等而视图与父视图之间的间距则为0。
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
    
  
    
    
    //MARK: override method
    override internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, hasSubLayout:inout Bool!, sbs:[UIView]!, type :TGSizeClassType) -> CGSize
    {
        var selfSize = super.tgCalcLayoutRect(size, isEstimate:isEstimate, hasSubLayout:&hasSubLayout, sbs:sbs, type:type)
        
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
                let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
                
                self.tgAdjustSubviewWrapContent(sbvsc: sbvsc, lsc: lsc)
                
                
                if !isEstimate
                {
                    sbvtgFrame.frame = sbv.bounds;
                    self.tgCalcSizeFromSizeWrapSubview(sbv, sbvsc:sbvsc, sbvtgFrame: sbvtgFrame)
                }
                
                if let sbvl:TGBaseLayout = sbv as? TGBaseLayout
                {
                    if hasSubLayout != nil && sbvsc.isSomeSizeWrap
                    {
                        hasSubLayout = true
                    }
                    
                    if isEstimate && (sbvsc.isSomeSizeWrap)
                    {
                        _ = sbvl.tg_sizeThatFits(sbvtgFrame.frame.size,inSizeClass:type)
                        if sbvtgFrame.multiple
                        {
                            sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)  //因为tg_sizeThatFits执行后会还原，所以这里要重新设置
                        }
                    }
                }
                
            }
        
        if lsc.tg_orientation == TGOrientation.vert
        {
            
            if  vertGravity != TGGravity.none
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
            if  horzGravity != TGGravity.none
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
        tgAdjustSubviewsLayoutTransform(sbs: sbs, lsc: lsc, selfSize: selfSize)
        tgAdjustSubviewsRTLPos(sbs: sbs, selfWidth: selfSize.width)
        
        return self.tgAdjustSizeWhenNoSubviews(size: selfSize, sbs: sbs, lsc:lsc)
        
    }
    
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGLinearLayoutViewSizeClassImpl(view:self)
    }
    
    override open func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        if subview === self.tg_baselineBaseView
        {
            self.tg_baselineBaseView = nil
        }
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
    
    
    private func tgCalcMaxWrapWidth(_ sbs:[UIView], selfSize:CGSize, horzPadding:CGFloat, lsc:TGLinearLayoutViewSizeClassImpl) ->CGFloat
    {
        
        var maxSubviewWidth:CGFloat = 0
        var retWidth = selfSize.width
        //计算出最宽的子视图所占用的宽度
        if lsc.width.isWrap
        {
            for sbv in sbs
            {
                let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
                
                
                if (sbvsc.width.sizeVal == nil || sbvsc.width.sizeVal !== lsc.width.realSize) && !(sbvsc.isHorzMarginHasValue) && !sbvsc.width.isFill && sbvsc.width.weightVal == nil
                {
                    
                    var vWidth = sbvsc.width.numberSize(sbvtgFrame.width)
                    
                    vWidth = self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: vWidth, sbvSize: sbvtgFrame.frame.size, selfLayoutSize: selfSize)
                    
                    //左边 + 中间偏移+ 宽度 + 右边
                    maxSubviewWidth = self.tgCalcSelfSize(sbv,
                                                          selfMeasure:maxSubviewWidth,
                                                           subviewMeasure:vWidth,
                                                           headPos:sbvsc.leading,
                                                           centerPos:sbvsc.centerX,
                                                           tailPos:sbvsc.trailing)
                    
                    
                }
            }
            
            retWidth = maxSubviewWidth + horzPadding
        }
        
        return retWidth
        
    }
    
    private func tgCalcSelfSize(_ sbv:UIView, selfMeasure:CGFloat, subviewMeasure:CGFloat, headPos:TGLayoutPosValue2,centerPos:TGLayoutPosValue2,tailPos:TGLayoutPosValue2) ->CGFloat
    {
        
        var  temp:CGFloat = subviewMeasure;
        var tempWeight:TGWeight = TGWeight.zeroWeight;
        
        let hm:CGFloat = headPos.floatNumber
        let cm:CGFloat = centerPos.floatNumber
        let tm:CGFloat = tailPos.floatNumber
        let ho:CGFloat = headPos.offset
        let co:CGFloat = centerPos.offset
        let to:CGFloat = tailPos.offset
        //这里是求父视图的最大尺寸,因此如果使用了相对边距的话，最大最小要参与计算。
        
        if let t = headPos.weightVal
        {
            tempWeight += t
        }
        else
        {
            temp += hm
        }
        
        temp += ho
        
        if let t = centerPos.weightVal
        {
            tempWeight += t
        }
        else
        {
            temp += cm
            
        }
        
        temp += co
        
        if let t = tailPos.weightVal
        {
            tempWeight += t
            
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
        let  headMargin = self.tgValidMargin(headPos, sbv: sbv, calcPos:headPos.weightPosIn(temp), selfLayoutSize: CGSize.zero)
    
        let centerMargin = self.tgValidMargin(centerPos, sbv: sbv, calcPos: centerPos.weightPosIn(temp), selfLayoutSize: CGSize.zero)
        let tailMargin = self.tgValidMargin(tailPos, sbv: sbv, calcPos: tailPos.weightPosIn(temp), selfLayoutSize: CGSize.zero)
        
        temp = subviewMeasure + headMargin + centerMargin + tailMargin
        
        var retMeasure = selfMeasure
        
        if _tgCGFloatGreat(temp , retMeasure)
        {
            retMeasure = temp
        }
        
        return retMeasure
        
        
    }
    
    
    
    fileprivate func tgLayoutSubviewsForVert(_ selfSize:CGSize, sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl)->CGSize
    {
        var fixedHeight:CGFloat = 0   //计算固定部分的高度
        var floatingHeight:CGFloat = 0 //浮动的高度。
        var totalWeight:TGWeight = TGWeight.zeroWeight    //剩余部分的总比重
        var selfSize = selfSize
        let horzGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        var topPadding = lsc.tgTopPadding
        var bottomPadding = lsc.tgBottomPadding
        let leadingPadding = lsc.tgLeadingPadding
        let trailingPadding = lsc.tgTrailingPadding
        
        var vertSpace = lsc.tg_vspace
        var subviewSize:CGFloat = 0.0
        if let t = lsc.tgFlexSpace, sbs.count > 0{
           (subviewSize,topPadding,bottomPadding,vertSpace) = t.calcMaxMinSubviewSize(selfSize.height, arrangedCount: sbs.count, startPadding: topPadding, endPadding: bottomPadding, space: vertSpace)
        }
        
        selfSize.width = self.tgCalcMaxWrapWidth(sbs, selfSize:selfSize, horzPadding: leadingPadding + trailingPadding, lsc:lsc)   //调整自身的宽度
        
        var addSpace:CGFloat = 0
        var fixedSizeSbs = [UIView]()
        var fixedSizeHeight:CGFloat = 0
        var fixedSpaceCount:Int = 0
        var fixedSpaceHeight:CGFloat = 0
        var pos:CGFloat = topPadding
        for sbv in sbs
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            var rect = sbvtgFrame.frame;
            
            self.tgCalcLeadingTrailingRect(horzGravity: horzGravity, selfSize: selfSize, leadingPadding:leadingPadding, trailingPadding:trailingPadding, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect:&rect)
            
            if subviewSize != 0.0 {
                rect.size.height = subviewSize
            }
            else {
                rect.size.height = sbvsc.height.numberSize(rect.size.height)
                if (sbvsc.height.isRelaSizeEqualTo(lsc.height) && !lsc.height.isWrap)
                {
                    rect.size.height = sbvsc.height.measure(selfSize.height - topPadding - bottomPadding)
                }
                
                if sbvsc.height.isRelaSizeEqualTo(sbvsc.width)
                {
                    rect.size.height = sbvsc.height.measure(rect.size.width)
                }
                
                //如果子视图需要调整高度则调整高度
                if sbvsc.height.isFlexHeight
                {
                    rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
                }
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            let topSpace = sbvsc.top.absPos
            let bottomSpace = sbvsc.bottom.absPos
            
            //计算固定高度和浮动高度。
            if let t = sbvsc.top.weightVal
            {
                totalWeight += t
                fixedHeight += sbvsc.top.offset
            }
            else
            {
                fixedHeight += topSpace
                if topSpace != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += topSpace
                }
            }
            
            pos += topSpace
            rect.origin.y = pos
            
            if let t = sbvsc.height.weightVal
            {
                totalWeight += t
            }
            else if sbvsc.height.isFill
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                fixedHeight += rect.height
                
                //如果最小高度不为自身则可以进行缩小。
                if sbvsc.height.minVal == nil || !sbvsc.height.minVal!.isWrap {
                    fixedSizeHeight += rect.height
                    fixedSizeSbs.append(sbv)
                }
                
            }
            
            pos += rect.size.height
            
            if let t = sbvsc.bottom.weightVal
            {
                totalWeight += t
                fixedHeight += sbvsc.bottom.offset
            }
            else
            {
                fixedHeight += bottomSpace
                if bottomSpace != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += bottomSpace
                }
            }
            
            pos += bottomSpace

            
            if sbv != sbs.last
            {
                fixedHeight += vertSpace
                
                pos += vertSpace
                
                if vertSpace != 0
                {
                    fixedSpaceCount += 1
                    fixedSpaceHeight += vertSpace
                }
            }
            
            sbvtgFrame.frame = rect;
        }
        
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if lsc.height.isWrap && totalWeight != TGWeight.zeroWeight
        {
            var tempSelfHeight = topPadding + bottomPadding
            if sbs.count > 1
            {
              tempSelfHeight += CGFloat(sbs.count - 1) * vertSpace
            }
            
            selfSize.height = self.tgValidMeasure(lsc.height,sbv:self,calcSize:tempSelfHeight,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
            
        }

        
        //剩余的可浮动的高度，那些weight不为0的从这个高度来进行分发
        var isWeightShrinkSpace = false
        var weightShrinkSpaceTotalHeight:CGFloat = 0.0
        floatingHeight = selfSize.height - fixedHeight - topPadding - bottomPadding
        let sstMode:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0x0F)  //压缩策略
        let sstContent:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0xF0) //压缩内容
        if _tgCGFloatLessOrEqual(floatingHeight, 0)
        {
            if sstMode != TGSubviewsShrinkType.none
            {
                if sstContent != TGSubviewsShrinkType.space
                {
                    
                    if (fixedSizeSbs.count > 0 && totalWeight != TGWeight.zeroWeight && floatingHeight < 0 && selfSize.height > 0)
                    {
                        if sstMode == TGSubviewsShrinkType.average
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
                        if (sstMode == TGSubviewsShrinkType.average)
                        {
                            addSpace = floatingHeight / CGFloat(fixedSpaceCount)
                        }
                        else if (sstMode == TGSubviewsShrinkType.weight)
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
        
        if totalWeight != TGWeight.zeroWeight || (sstMode != TGSubviewsShrinkType.none && _tgCGFloatLessOrEqual(floatingHeight, 0))
        {
            pos = topPadding
            for sbv in sbs
            {
                let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
                
                var  topSpace:CGFloat = sbvsc.top.floatNumber
                var  bottomSpace:CGFloat = sbvsc.bottom.floatNumber
                let  topOffset = sbvsc.top.offset
                let  bottomOffset = sbvsc.bottom.offset
                
                var rect:CGRect =  sbvtgFrame.frame;
                
                //分别处理相对顶部边距和绝对顶部边距
                if let t = sbvsc.top.weightVal
                {
                    topSpace = _tgRoundNumber((t.rawValue / totalWeight.rawValue) * floatingHeight)
                    floatingHeight -= topSpace
                    totalWeight -= t
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
                
                pos +=   self.tgValidMargin(sbvsc.top, sbv: sbv, calcPos: topSpace + topOffset, selfLayoutSize: selfSize)
                
                //分别处理相对高度和绝对高度
                rect.origin.y = pos;
                if let t = sbvsc.height.weightVal
                {
                    var  h:CGFloat = _tgRoundNumber((t.rawValue / totalWeight.rawValue) * floatingHeight)
                    floatingHeight -= h
                    totalWeight -= t
                    if  _tgCGFloatLessOrEqual(h, 0)
                    {
                        h = 0;
                    }
                    
                    rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                }
                else if sbvsc.height.isFill
                {
                    var  h:CGFloat = _tgRoundNumber((100.0 / totalWeight.rawValue) * floatingHeight)
                    floatingHeight -= h
                    totalWeight -= TGWeight(100)
                    if  _tgCGFloatLessOrEqual(h, 0)
                    {
                        h = 0;
                    }
                    
                    rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: h, sbvSize: rect.size, selfLayoutSize: selfSize)
                    
                }
                
                pos += rect.size.height;
                
                //分别处理相对底部边距和绝对底部边距
                if let t = sbvsc.bottom.weightVal
                {
                    bottomSpace = _tgRoundNumber((t.rawValue / totalWeight.rawValue) * floatingHeight)
                    floatingHeight -= bottomSpace
                    totalWeight -= t
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
                
                pos +=  self.tgValidMargin(sbvsc.bottom,sbv: sbv, calcPos: bottomSpace + bottomOffset, selfLayoutSize: selfSize)
                
                if sbv != sbs.last
                {
                    pos += vertSpace
                    
                    if (vertSpace != 0)
                    {
                        pos += addSpace;
                        
                        if (isWeightShrinkSpace)
                        {
                            pos += weightShrinkSpaceTotalHeight * vertSpace / fixedSpaceHeight;
                        }
                    }
                    
                }
                
                sbvtgFrame.frame = rect
            }
        }
        
        pos += bottomPadding;
        
        
        if lsc.height.isWrap
        {
            selfSize.height = pos
        }
        
        return selfSize
        
        
    }
    
    fileprivate func tgLayoutSubviewsForHorz(_ selfSize:CGSize, sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl)->CGSize
    {
        
        let vertGravity = lsc.tg_gravity & TGGravity.horz.mask
        var fixedWidth:CGFloat = 0;   //计算固定部分的高度
        var floatingWidth:CGFloat = 0; //浮动的高度。
        var totalWeight:TGWeight = TGWeight.zeroWeight
        let topPadding = lsc.tgTopPadding
        let bottomPadding = lsc.tgBottomPadding
        var leadingPadding = lsc.tgLeadingPadding
        var trailingPadding = lsc.tgTrailingPadding
        
        
        var maxSubviewHeight:CGFloat = 0;
        var selfSize = selfSize
        
        var horzSpace = lsc.tg_hspace
        var subviewSize:CGFloat = 0.0
        if let t = lsc.tgFlexSpace, sbs.count > 0 {
            (subviewSize,leadingPadding,trailingPadding,horzSpace) = t.calcMaxMinSubviewSize(selfSize.width, arrangedCount: sbs.count, startPadding: leadingPadding, endPadding: trailingPadding, space: horzSpace)
        }
        
        //计算出固定的子视图宽度的总和以及宽度比例总和
        var addSpace:CGFloat = 0.0   //用于压缩时的间距压缩增量。
        var fixedSizeSbs = [UIView]()
        var fixedSizeWidth:CGFloat = 0
        var flexedSizeSbs = [UIView]()
        var fixedSpaceCount = 0  //固定间距的子视图数量。
        var fixedSpaceWidth:CGFloat = 0.0  //固定间距的子视图的宽度。
        for sbv in sbs
        {
            
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            
            let leadingSpace = sbvsc.leading.absPos
            let trailingSpace = sbvsc.trailing.absPos
            
            if let t = sbvsc.leading.weightVal
            {
                totalWeight += t
                fixedWidth += sbvsc.leading.offset
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
            
            if let t = sbvsc.trailing.weightVal
            {
                totalWeight += t
                fixedWidth += sbvsc.trailing.offset
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
            
            if let t = sbvsc.width.weightVal
            {
                totalWeight += t
            }
            else if sbvsc.width.isFill
            {
                totalWeight += TGWeight(100)
            }
            else
            {
                
                var vWidth = subviewSize
                if vWidth == 0 {
                    vWidth  = sbvsc.width.numberSize(sbvtgFrame.width)
                    if (sbvsc.width.isRelaSizeEqualTo(lsc.width) && !lsc.width.isWrap)
                    {
                        vWidth = sbvsc.width.measure(selfSize.width - leadingPadding - trailingPadding)
                    }
                }
                
                vWidth = self.tgValidMeasure(sbvsc.width,sbv:sbv,calcSize:vWidth,sbvSize:sbvtgFrame.frame.size,selfLayoutSize:selfSize)
                
                sbvtgFrame.width = vWidth
                
                fixedWidth += vWidth
                
                if sbvsc.width.minVal == nil || !sbvsc.width.minVal!.isWrap
                {
                   fixedSizeWidth += vWidth
                   fixedSizeSbs.append(sbv)
                }
                
                if sbvsc.width.isWrap
                {
                    flexedSizeSbs.append(sbv)
                }
            }
            
            if sbv != sbs.last
            {
                fixedWidth += horzSpace
                
                if (horzSpace != 0)
                {
                    fixedSpaceCount += 1
                    fixedSpaceWidth += horzSpace
                }
            }
        }
        
        //在包裹宽度且总体比重不为0时则，则需要还原最小的宽度，这样就不会使得宽度在横竖屏或者多次计算后越来越宽。
        if (lsc.width.isWrap && totalWeight != .zeroWeight)
        {
            var tempSelfWidth = leadingPadding + trailingPadding
            if sbs.count > 1
            {
             tempSelfWidth += CGFloat(sbs.count - 1) * horzSpace
            }
            
            selfSize.width = self.tgValidMeasure(lsc.width,sbv:self,calcSize:tempSelfWidth,sbvSize:selfSize,selfLayoutSize:self.superview!.bounds.size)
        }
        
        //剩余的可浮动的宽度，那些weight不为0的从这个高度来进行分发
        var isWeightShrinkSpace = false   //是否按比重缩小间距。。。
        var weightShrinkSpaceTotalWidth:CGFloat = 0.0
        floatingWidth = selfSize.width - fixedWidth - leadingPadding - trailingPadding;
        if _tgCGFloatLessOrEqual(floatingWidth, 0)
        {
            var sstMode:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0x0F)  //压缩策略
            let sstContent:TGSubviewsShrinkType = TGSubviewsShrinkType(rawValue: lsc.tg_shrinkType.rawValue & 0xF0) //压缩内容

            
            if sstMode == TGSubviewsShrinkType.auto && flexedSizeSbs.count != 2
            {
                sstMode = TGSubviewsShrinkType.none
            }
            
            if sstMode != TGSubviewsShrinkType.none
            {
                if sstContent != TGSubviewsShrinkType.space
                {
                    
                    if (fixedSizeSbs.count > 0 && totalWeight != TGWeight.zeroWeight && floatingWidth < 0 && selfSize.width > 0)
                    {
                        if sstMode == TGSubviewsShrinkType.average
                        {
                            let averageWidth = floatingWidth / CGFloat(fixedSizeSbs.count)
                            for fsbv in fixedSizeSbs
                            {
                                fsbv.tgFrame.width += averageWidth;
                            }
                        }
                        else if sstMode == TGSubviewsShrinkType.auto
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
                            
                            if _tgCGFloatGreat(leftWidth, halfLayoutWidth) && _tgCGFloatGreat(righWidth , halfLayoutWidth)
                            {
                                leftView.tgFrame.width = halfLayoutWidth
                                rightView.tgFrame.width = halfLayoutWidth
                            }
                            else if ((_tgCGFloatGreat(leftWidth , halfLayoutWidth) || _tgCGFloatGreat(righWidth , halfLayoutWidth)) && _tgCGFloatGreat(leftWidth + righWidth , layoutWidth))
                            {
                                
                                if _tgCGFloatGreat(leftWidth , halfLayoutWidth)
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
                        if (sstMode == TGSubviewsShrinkType.average)
                        {
                            addSpace = floatingWidth / CGFloat(fixedSpaceCount)
                        }
                        else if (sstMode == TGSubviewsShrinkType.weight)
                        {
                            isWeightShrinkSpace = true
                            weightShrinkSpaceTotalWidth = floatingWidth
                        }
                    }

                    
                }
            }
            
            
            floatingWidth = 0;
        }
        
        var baselinePos:CGFloat! = nil  //保存基线的值
        //调整所有子视图的宽度
        var pos:CGFloat = leadingPadding;
        for sbv in sbs
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            var leadingSpace = sbvsc.leading.floatNumber
            var trailingSpace = sbvsc.trailing.floatNumber
            let leadingOffset = sbvsc.leading.offset
            let trailingOffset = sbvsc.trailing.offset
            
            var rect:CGRect =  sbvtgFrame.frame;
            
        
            rect.size.height = sbvsc.height.numberSize(rect.size.height)

            
            
            if sbvsc.height.isRelaSizeEqualTo(lsc.height)
            {
                rect.size.height = sbvsc.height.measure(selfSize.height - topPadding - bottomPadding)
            }
            
            
            
            //计算出先对左边边距和绝对左边边距
            if let t = sbvsc.leading.weightVal
            {
                leadingSpace = _tgRoundNumber((t.rawValue / totalWeight.rawValue) * floatingWidth)
                floatingWidth -= leadingSpace
                totalWeight -= t
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
            
            pos += self.tgValidMargin(sbvsc.leading, sbv: sbv, calcPos: leadingSpace + leadingOffset, selfLayoutSize: selfSize)
            
            
            //计算出相对宽度和绝对宽度
            rect.origin.x = pos;
            if let t = sbvsc.width.weightVal
            {
                var w = _tgRoundNumber((t.rawValue / totalWeight.rawValue) * floatingWidth)
                floatingWidth -= w
                totalWeight -= t
                if  _tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w
            }
            else if sbvsc.width.isFill
            {
                var w = _tgRoundNumber((100.0 / totalWeight.rawValue) * floatingWidth)
                floatingWidth -= w
                totalWeight -= TGWeight(100)
                if  _tgCGFloatLessOrEqual(w,0)
                {
                    w = 0
                }
                
                rect.size.width = w

            }
            
            rect.size.width =  self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            pos += rect.size.width
            
            //计算相对的右边边距和绝对的右边边距
            if let t = sbvsc.trailing.weightVal
            {
                trailingSpace = _tgRoundNumber((t.rawValue / totalWeight.rawValue) * floatingWidth)
                floatingWidth -= trailingSpace
                totalWeight -= t
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
            
            pos +=  self.tgValidMargin(sbvsc.trailing, sbv: sbv, calcPos: trailingSpace + trailingOffset, selfLayoutSize: selfSize)
            
            
            if sbv != sbs.last
            {
                pos += horzSpace
                
                if (horzSpace != 0)
                {
                    pos += addSpace;
                    
                    if (isWeightShrinkSpace)
                    {
                        pos += weightShrinkSpaceTotalWidth * horzSpace / fixedSpaceWidth
                    }
                }

            }
            
            if sbvsc.height.isRelaSizeEqualTo(sbvsc.width)
            {
                rect.size.height = sbvsc.height.measure(rect.size.width)
            }
            
            //如果高度是浮动的则需要调整高度。
            if sbvsc.height.isFlexHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize:rect.size, selfLayoutSize: selfSize)
            
            if lsc.height.isWrap
            {
                //计算最高的高度。
                if  (sbvsc.height.sizeVal == nil || sbvsc.height.sizeVal !== lsc.height.realSize) && !(sbvsc.isVertMarginHasValue) && !sbvsc.height.isFill && sbvsc.height.weightVal == nil
                {
                    maxSubviewHeight = self.tgCalcSelfSize(sbv, selfMeasure: maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbvsc.top, centerPos:sbvsc.centerY,tailPos:sbvsc.bottom)
                }
            }
            else
            {
                self.tgCalcTopBottomRect(vertGravity:vertGravity, selfSize: selfSize, topPadding:topPadding, bottomPadding:bottomPadding,baselinePos:baselinePos, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
                
                //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
                if vertGravity == TGGravity.vert.baseline && baselinePos == nil && self.tg_baselineBaseView === sbv
                {
                    let sbvFont = sbv.value(forKey: "font") as! UIFont
                    //这里要求baselineBaseView必须要具有font属性。
                    //得到基线位置。
                    baselinePos = rect.origin.y + (rect.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender
                }
                
            }
            
            sbvtgFrame.frame = rect;
        }
        
        pos += trailingPadding;
        
        if lsc.width.isWrap
        {
            selfSize.width = pos
        }
        
        if lsc.height.isWrap
        {
            selfSize.height = maxSubviewHeight + topPadding + bottomPadding
            
            //调整所有子视图的高度
            for sbv in sbs
            {
                let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
                var rect:CGRect = sbvtgFrame.frame;
                
                self.tgCalcTopBottomRect(vertGravity:vertGravity, selfSize: selfSize, topPadding:topPadding, bottomPadding:bottomPadding,baselinePos:baselinePos, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
                
                sbvtgFrame.frame = rect
                
                //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
                if vertGravity == TGGravity.vert.baseline && baselinePos == nil && self.tg_baselineBaseView == sbv
                {
                    let sbvFont = sbv.value(forKey: "font") as! UIFont
                    //这里要求baselineBaseView必须要具有font属性。
                    //得到基线位置。
                    baselinePos = rect.origin.y + (rect.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender
                }
                
            }
            
        }
        
        return selfSize
    }
    
    
    fileprivate func tgLayoutSubviewsForVertGravity(_ selfSize:CGSize, sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl) ->CGSize
    {
     
        let vertGravity = lsc.tg_gravity & TGGravity.horz.mask
        let horzGravity = self.tgConvertLeftRightGravityToLeadingTrailing(lsc.tg_gravity & TGGravity.vert.mask)
        let topPadding = lsc.tgTopPadding
        let bottomPadding = lsc.tgBottomPadding
        let leadingPadding = lsc.tgLeadingPadding
        let trailingPadding = lsc.tgTrailingPadding
        
        
        var totalHeight:CGFloat = 0
        
        if sbs.count > 1
        {
            totalHeight += CGFloat(sbs.count - 1) * lsc.tg_vspace
        }
        
        var selfSize = selfSize
        selfSize.width =  self.tgCalcMaxWrapWidth(sbs, selfSize:selfSize, horzPadding: leadingPadding + trailingPadding, lsc:lsc)
        
        var floatingHeight:CGFloat = selfSize.height - topPadding - bottomPadding - totalHeight
        if  _tgCGFloatLessOrEqual(floatingHeight, 0)
        {
            floatingHeight = 0
        }
        
        //调整子视图的宽度。并根据情况调整子视图的高度。并计算出固定高度和浮动高度。
        var noWrapsbsSet = Set<UIView>()
        for sbv in sbs
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)

            let topSpace = sbvsc.top.weightPosIn(floatingHeight)
            let bottomSpace = sbvsc.bottom.weightPosIn(floatingHeight)
            
            var canAddToNoWrapSbs = true
            
            var rect:CGRect =  sbvtgFrame.frame;
            
             self.tgCalcLeadingTrailingRect(horzGravity: horzGravity , selfSize: selfSize, leadingPadding:leadingPadding,trailingPadding:trailingPadding, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
            
            rect.size.height = sbvsc.height.numberSize(rect.size.height)

            
            
            if (sbvsc.height.isRelaSizeEqualTo(lsc.height) && !lsc.height.isWrap)
            {
                rect.size.height = sbvsc.height.measure(selfSize.height - topPadding - bottomPadding)
                canAddToNoWrapSbs = false
            }

           
            if sbvsc.height.isRelaSizeEqualTo(sbvsc.width)
            {
                rect.size.height = sbvsc.height.measure(rect.size.width)
            }
            //如果子视图需要调整高度则调整高度
            if sbvsc.height.isFlexHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
                canAddToNoWrapSbs = false
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if let t = sbvsc.height.minVal, t.isWrap
            {
                canAddToNoWrapSbs = false
            }
            
            
            totalHeight += topSpace
            totalHeight += rect.size.height;
            totalHeight += bottomSpace
            
            
            sbvtgFrame.frame = rect
            
            if  sbvsc.height.isWrap && vertGravity == TGGravity.vert.fill
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
            pos  = topPadding;
        }
        else if vertGravity == TGGravity.vert.center
        {
            pos = (selfSize.height - totalHeight - bottomPadding - topPadding)/2.0;
            pos += topPadding;
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
            pos = selfSize.height - totalHeight - bottomPadding
        }
        else if vertGravity == TGGravity.vert.between
        {
            pos = topPadding;
            
            if sbs.count > 1
            {
              between = (selfSize.height - totalHeight - topPadding - bottomPadding) / CGFloat(sbs.count - 1)
            }
        }
        else if vertGravity == TGGravity.vert.around
        {
            //around停靠中如果子视图数量大于1则间距均分，并且首尾子视图和父视图的间距为均分的一半，如果子视图数量为1则一个子视图垂直居中。
            if (sbs.count > 1)
            {
                between = (selfSize.height - totalHeight - topPadding - bottomPadding) / CGFloat(sbs.count)
                pos = topPadding + between / 2;
            }
            else
            {
                pos = (selfSize.height - totalHeight - topPadding - bottomPadding)/2.0 + topPadding;
            }
        }
        else if vertGravity == TGGravity.vert.among
        {
            between = (selfSize.height - totalHeight - topPadding - bottomPadding) / CGFloat(sbs.count + 1)
            pos = topPadding + between;
        }
        else if vertGravity == TGGravity.vert.fill
        {
            pos = topPadding
            if noWrapsbsSet.count > 0
            {
                fill = (selfSize.height - totalHeight - topPadding - bottomPadding) / CGFloat(noWrapsbsSet.count)
            }
        }
        else
        {
            pos = topPadding
        }
        
        
        for sbv in sbs
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            let topSpace = sbvsc.top.weightPosIn(floatingHeight)
            let bottomSpace = sbvsc.bottom.weightPosIn(floatingHeight)
        
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
        let topPadding = lsc.tgTopPadding
        let bottomPadding = lsc.tgBottomPadding
        let leadingPadding = lsc.tgLeadingPadding
        let trailingPadding = lsc.tgTrailingPadding
        var totalWidth:CGFloat = 0;
        if sbs.count > 1
        {
            totalWidth += CGFloat(sbs.count - 1) * lsc.tg_hspace
        }
        
        
        var floatingWidth:CGFloat = 0;
        
        var maxSubviewHeight:CGFloat = 0;
        
        var selfSize = selfSize
        floatingWidth = selfSize.width - leadingPadding - trailingPadding - totalWidth
        if  _tgCGFloatLessOrEqual(floatingWidth, 0)
        {
            floatingWidth = 0
        }
        
        //计算出固定的高度
        var noWrapsbsSet = Set<UIView>()
        for sbv in sbs
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            let leadingSpace = sbvsc.leading.weightPosIn(floatingWidth)
            let trailingSpace = sbvsc.trailing.weightPosIn(floatingWidth)
            
            
            
            var canAddToNoWrapSbs = true
            
            var rect = sbvtgFrame.frame;
            
            rect.size.width = sbvsc.width.numberSize(rect.size.width)
            
            rect.size.height = sbvsc.height.numberSize(rect.size.height)

            
            if (sbvsc.width.isRelaSizeEqualTo(lsc.width) && !lsc.width.isWrap)
            {
                rect.size.width = sbvsc.width.measure(selfSize.width - leadingPadding - trailingPadding)
                canAddToNoWrapSbs = false
            }
            
            if sbvsc.height.isRelaSizeEqualTo(lsc.height)
            {
                rect.size.height = sbvsc.height.measure(selfSize.height - topPadding - bottomPadding)
            }
            
            if sbvsc.width.isRelaSizeEqualTo(sbvsc.height)
            {
                rect.size.width = sbvsc.width.measure(rect.size.height)
            }
            
            rect.size.width = self.tgValidMeasure(sbvsc.width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
            
            if let t = sbvsc.width.minVal ,t.isWrap
            {
                canAddToNoWrapSbs = false
            }
            
            if sbvsc.height.isRelaSizeEqualTo(sbvsc.width)
            {
                rect.size.height = sbvsc.height.measure(rect.size.width)
            }
            
            //如果高度是浮动的则需要调整高度。
            if sbvsc.height.isFlexHeight
            {
                rect.size.height = self.tgCalcHeightFromHeightWrapView(sbv, sbvsc:sbvsc, width: rect.size.width)
            }
            
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //计算以子视图为大小的情况
            if lsc.height.isWrap &&
                (sbvsc.height.sizeVal == nil || sbvsc.height.sizeVal !== lsc.height.realSize) &&
                !(sbvsc.isVertMarginHasValue) &&
                !sbvsc.height.isFill &&
                sbvsc.height.weightVal == nil
            {
                maxSubviewHeight = self.tgCalcSelfSize(sbv, selfMeasure:maxSubviewHeight, subviewMeasure:rect.size.height, headPos:sbvsc.top, centerPos:sbvsc.centerY, tailPos:sbvsc.bottom)
            }
            
            
            
            totalWidth += leadingSpace
            
            totalWidth += rect.size.width
            
            
            totalWidth += trailingSpace
            
            sbvtgFrame.frame = rect
            
            if horzGravity == TGGravity.horz.fill && sbvsc.width.isWrap
            {
                canAddToNoWrapSbs = false
            }
            
            if canAddToNoWrapSbs
            {
                noWrapsbsSet.insert(sbv)
            }
            
        }
        
        
        //调整自己的高度。
        if lsc.height.isWrap
        {
            selfSize.height = maxSubviewHeight + topPadding + bottomPadding;
        }
        
        //根据对齐的方位来定位子视图的布局对齐
        var pos:CGFloat = 0
        var between:CGFloat = 0
        var fill:CGFloat = 0
        
        if horzGravity == TGGravity.horz.leading
        {
            pos = leadingPadding
        }
        else if horzGravity == TGGravity.horz.center
        {
            pos = (selfSize.width - totalWidth - leadingPadding - trailingPadding)/2.0;
            pos += leadingPadding;
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
            pos = selfSize.width - totalWidth - trailingPadding;
        }
        else if horzGravity == TGGravity.horz.between
        {
            pos = leadingPadding
            
            if sbs.count > 1
            {
                between = (selfSize.width - totalWidth - leadingPadding - trailingPadding) / CGFloat(sbs.count - 1)
            }
        }
        else if horzGravity == TGGravity.horz.around
        {
            //around停靠中如果子视图数量大于1则间距均分，并且首尾子视图和父视图的间距为均分的一半，如果子视图数量为1则一个子视图垂直居中。
            if (sbs.count > 1)
            {
                between = (selfSize.width - totalWidth - leadingPadding - trailingPadding) / CGFloat(sbs.count)
                pos = leadingPadding + between / 2;
            }
            else
            {
                pos = (selfSize.width - totalWidth - leadingPadding - trailingPadding)/2.0 + leadingPadding;
            }
        }
        else if horzGravity == TGGravity.horz.among
        {
            //每个子
            between = (selfSize.width - totalWidth - leadingPadding - trailingPadding) / CGFloat(sbs.count + 1)
            pos = leadingPadding + between;
        }
        else if horzGravity == TGGravity.horz.fill
        {
            pos = leadingPadding
            
            if noWrapsbsSet.count > 0
            {
                fill = (selfSize.width - totalWidth - leadingPadding - trailingPadding) / CGFloat(noWrapsbsSet.count)
            }
        }
        else
        {
            pos = leadingPadding
        }
        
        var baselinePos:CGFloat! = nil;  //保存基线的值。
        for sbv in sbs
        {
            let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
            
            let leadingSpace = sbvsc.leading.weightPosIn(floatingWidth)
            let trailingSpace = sbvsc.trailing.weightPosIn(floatingWidth)
            
            
            pos += leadingSpace
            
            
            var rect = sbvtgFrame.frame;
            rect.origin.x = pos;
            
            self.tgCalcTopBottomRect(vertGravity: vertGravity, selfSize: selfSize, topPadding:topPadding, bottomPadding:bottomPadding, baselinePos:baselinePos, sbv: sbv, sbvsc: sbvsc, lsc: lsc, rect: &rect)
            
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
            
            pos += between  //只有mghorz为between才加这个间距拉伸。
            
            //如果垂直方向的对齐方式是基线对齐，那么就以第一个具有基线的视图作为标准位置。
            if vertGravity == TGGravity.vert.baseline && baselinePos == nil && self.tg_baselineBaseView == sbv
            {
                let sbvFont = sbv.value(forKey: "font") as! UIFont
                //这里要求baselineBaseView必须要具有font属性。
                //得到基线位置。
                baselinePos = rect.origin.y + (rect.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender
            }
        }
        
        return selfSize;
    }

       
    fileprivate func tgAdjustSubviewWrapContent(sbvsc:TGViewSizeClassImpl, lsc:TGLinearLayoutViewSizeClassImpl)
    {
        if lsc.tg_orientation == TGOrientation.vert
        {
            
            if (sbvsc.isHorzMarginHasValue) ||
                (lsc.tg_gravity & TGGravity.vert.mask) == TGGravity.horz.fill
            {
                sbvsc.width.resetValue()
            }
        }
        else
        {
            
            if (sbvsc.isVertMarginHasValue) ||
                (lsc.tg_gravity & TGGravity.horz.mask) == TGGravity.vert.fill
            {
                sbvsc.height.resetValue()
            }
        }
    }
    
    fileprivate func tgCalcLeadingTrailingRect(horzGravity:TGGravity, selfSize:CGSize,leadingPadding:CGFloat,trailingPadding:CGFloat, sbv:UIView, sbvsc:TGViewSizeClassImpl, lsc:TGLinearLayoutViewSizeClassImpl, rect:inout CGRect)
    {
        
        let floatingWidth = selfSize.width - leadingPadding - trailingPadding
        let realLeadingMargin = sbvsc.leading.weightPosIn(floatingWidth)
        let realTrailingMargin = sbvsc.trailing.weightPosIn(floatingWidth)
        
        rect.size.width = sbvsc.width.numberSize(rect.size.width)
        
        //和父视图保持一致。
        if sbvsc.width.isRelaSizeEqualTo(lsc.width)
        {
            rect.size.width = sbvsc.width.measure(floatingWidth)
        }
        
        //占用父视图的宽度的比例。
        rect.size.width = sbvsc.width.weightSize(rect.size.width, in: floatingWidth)
        //如果填充
        rect.size.width = sbvsc.width.fillSize(rect.size.width, in: floatingWidth - realLeadingMargin - realTrailingMargin)
        
        if sbvsc.isHorzMarginHasValue
        {
            rect.size.width = floatingWidth - realLeadingMargin - realTrailingMargin
        }
        
        rect.size.width = self.tgValidMeasure(sbvsc.width,sbv:sbv,calcSize:rect.size.width,sbvSize:rect.size,selfLayoutSize:selfSize)
        self.tgCalcHorzGravity(self.tgGetSubviewHorzGravity(sbv, sbvsc:sbvsc, horzGravity: horzGravity), selfSize:selfSize,leadingPadding:leadingPadding, trailingPadding:trailingPadding, sbv:sbv,sbvsc:sbvsc, lsc:lsc, rect:&rect)
    }
    
    fileprivate func tgCalcTopBottomRect(vertGravity:TGGravity, selfSize:CGSize, topPadding:CGFloat, bottomPadding:CGFloat, baselinePos:CGFloat!, sbv:UIView, sbvsc:TGViewSizeClassImpl, lsc:TGLinearLayoutViewSizeClassImpl, rect:inout CGRect)
    {
        
        let floatingHeight = selfSize.height - topPadding - bottomPadding
        let realTopMargin = sbvsc.top.weightPosIn(floatingHeight)
        let realBottomMargin = sbvsc.bottom.weightPosIn(floatingHeight)
        
        rect.size.height = sbvsc.height.numberSize(rect.size.height)

        if sbvsc.height.isRelaSizeEqualTo(lsc.height)
        {
            rect.size.height = sbvsc.height.measure(floatingHeight)
        }
            
        //占用父视图的高度的比例。
        rect.size.height = sbvsc.height.weightSize(rect.size.height, in: floatingHeight)
        //如果填充
        rect.size.height = sbvsc.height.fillSize(rect.size.height, in: floatingHeight - realTopMargin - realBottomMargin)
        
        if sbvsc.isVertMarginHasValue
        {
            rect.size.height = floatingHeight - realTopMargin - realBottomMargin
        }
        
        
        
        //优先以容器中的指定为标准
        rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
        self.tgCalcVertGravity(self.tgGetSubviewVertGravity(sbv, sbvsc:sbvsc, vertGravity: vertGravity), selfSize:selfSize, topPadding:topPadding, bottomPadding:bottomPadding,baselinePos:baselinePos, sbv:sbv, sbvsc:sbvsc, lsc:lsc, rect:&rect)

    }

    fileprivate func tgSetLayoutIntelligentBorderline(_ sbs:[UIView], lsc:TGLinearLayoutViewSizeClassImpl)
    {
        if self.tg_intelligentBorderline == nil
        {
            return
        }
        
        var subviewSpace =  lsc.tg_vspace
        if lsc.tg_orientation == TGOrientation.horz
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
                    if lsc.tg_orientation == TGOrientation.vert
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
                            if lsc.tg_orientation == TGOrientation.vert
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
                        if lsc.tg_orientation == TGOrientation.vert
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


