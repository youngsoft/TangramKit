//
//  TGPathLayout.swift
//  TangramKit
//
//  Created by X on 2016/12/5.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 * 定义子视图在路径布局中的距离的类型。
 */
public enum TGPathSpaceType{
    case flexed             //浮动距离
    case fixed(CGFloat)     //固定距离
    case count(Int)         //固定数量距离
}

/**
 * 实现枚举类TGPathSpaceType的比较接口
 */
extension TGPathSpaceType : Equatable{
    public static func ==(lhs: TGPathSpaceType, rhs: TGPathSpaceType) -> Bool {
        switch (lhs,rhs) {
        case ( .flexed , .flexed):
            return true
        case (let .fixed(value1),let .fixed(value2)):
            return value1 == value2
        case (let .count(count1),let .count(count2)):
            return count1 == count2
        default:
            return false
        }
    }
}

/**
 * 坐标轴设置类，用来描述坐标轴的信息。
 */
open class TGCoordinateSetting : NSObject{
    
    /**
     * 坐标原点的位置,位置是相对位置，默认是(0,0), 假如设置为(0.5,0.5)则在视图的中间。
     */
    public var origin : CGPoint = CGPoint.zero {
        
        didSet{
            if !oldValue.equalTo(origin){
                pathLayout?.setNeedsLayout()
            }
        }
    }
    
    /**
     * 指定是否是数学坐标系，默认为NO，表示绘图坐标系。 数学坐标系y轴向上为正，向下为负；绘图坐标系则反之。
     */
    public var isMath : Bool = false{
        didSet{
            if isMath != oldValue{
                pathLayout?.setNeedsLayout()
            }
        }
    }
    
    /**
     * 指定是否是y轴和x轴互换，默认为NO，如果设置为YES则方程提供的变量是y轴的值，方程返回的是x轴的值。
     */
    public var isReverse : Bool = false{
        didSet{
            if isReverse != oldValue{
                pathLayout?.setNeedsLayout()
            }
        }
    }
    
    /**
     * 开始位置和结束位置。如果不设置则根据坐标原点设置以及视图的尺寸自动确定.默认是-CGFLOAT_MAX, CGFLOAT_MAX
     */
    public var start = -CGFloat.greatestFiniteMagnitude {
        didSet{
            if start != oldValue {
                pathLayout?.setNeedsLayout()
            }
        }
    }
    
    public var end = CGFloat.greatestFiniteMagnitude {
        didSet{
            if end != oldValue {
                pathLayout?.setNeedsLayout()
            }
        }
    }
    
    public weak var pathLayout : TGPathLayout?
    
    init(pathLayout:TGPathLayout) {
        self.pathLayout = pathLayout
    }
    
    /**
     * 恢复默认设置
     */
    public func reset(){
        start = -CGFloat.greatestFiniteMagnitude
        end = CGFloat.greatestFiniteMagnitude
        isMath = false
        isReverse = false
        origin = CGPoint.zero
        pathLayout?.setNeedsLayout()
    }
}

/**
 *路径布局类。路径布局通过坐标轴的设置，曲线路径函数方程，子视图中心点之间的距离三个要素来确定其中子视图的位置。因此通过路径布局可以实现一些非常酷炫的布局效果。
 */
open class TGPathLayout : TGBaseLayout,TGPathLayoutViewSizeClass {
    
    /**
     * 坐标系设置，您可以调整坐标系的各种参数来完成下列两个方法中的坐标到绘制的映射转换。
     */
    public private(set) lazy var tg_coordinateSetting : TGCoordinateSetting = {
        [unowned self] in
        return TGCoordinateSetting(pathLayout:self)
    }()
    
    /**
     * 直角坐标普通方程，x是坐标系里面x轴的位置，返回y = f(x)。要求函数在定义域内是连续的，否则结果不确定。如果返回的y无效则函数要返回nil
     */
    public var tg_rectangularEquation : ((CGFloat)->CGFloat?)?{
        didSet{
            if tg_rectangularEquation != nil{
                tg_parametricEquation = nil
                tg_polarEquation = nil
                setNeedsLayout()
            }
        }
    }
    
    /**
     * 直角坐标参数方程，t是参数， 返回CGPoint是x轴和y轴的值。要求函数在定义域内是连续的，否则结果不确定。如果返回的点无效，则请返回nil
     */
    public var tg_parametricEquation : ((CGFloat)->CGPoint?)?{
        didSet{
            if tg_parametricEquation != nil {
                tg_rectangularEquation = nil
                tg_polarEquation = nil
                setNeedsLayout()
            }
        }
    }
    
    /**
     * 极坐标方程，angle是极坐标的弧度，返回r半径。要求函数在定义域内是连续的，否则结果不确定。如果返回的点无效，则请返回nil
     */
    public var tg_polarEquation : ((CGFloat)->CGFloat?)?{
        didSet{
            if tg_polarEquation != nil {
                tg_rectangularEquation = nil
                tg_parametricEquation = nil
                setNeedsLayout()
            }
        }
    }
    
    /**
     * 设置子视图在路径曲线上的距离的类型,一共有flexed, fixed, count,默认是flexed,
     */
    public var tg_spaceType : TGPathSpaceType = .flexed {
        didSet{
            if tg_spaceType != oldValue {
                setNeedsLayout()
            }
        }
    }
    
    /**
     * 设置和获取布局视图中的原点视图，默认是nil。如果设置了原点视图则总会将原点视图作为布局视图中的最后一个子视图。原点视图将会显示在路径的坐标原点中心上，因此原点布局是不会参与在路径中的布局的。因为中心原点视图是布局视图中的最后一个子视图，而MyPathLayout重写了AddSubview方法，因此可以正常的使用这个方法来添加子视图。
     */
    public var tg_originView : UIView?{
        get{
            return tgHasOriginView && subviews.count > 0 ? subviews.last : nil
        }
        set{
            
            guard tgHasOriginView else {
                if newValue != nil {
                    super.addSubview(newValue!)
                    tgHasOriginView = true
                }
                return
            }
            
            guard newValue != nil else {
                if subviews.count > 0 {
                    subviews.last?.removeFromSuperview()
                }
                tgHasOriginView = false
                return
            }
            
            guard subviews.count > 0 else {
                addSubview(newValue!)
                return
            }
            
            if subviews.last != newValue {
                subviews.last?.removeFromSuperview()
                addSubview(newValue!)
            }
        }
    }
    
    /**
     * 返回布局视图中所有在曲线路径中排列的子视图。如果设置了原点视图则返回subviews里面除最后一个子视图外的所有子视图，如果没有原点子视图则返回subviews
     */
    public var tg_pathSubviews : [UIView]{
        get{
            guard tgHasOriginView || subviews.count == 0 else {
                return subviews
            }
            
            var pathSubviews = [UIView]()
            for i in 0..<subviews.count-1{
                pathSubviews.append(subviews[i])
            }
            return pathSubviews
        }
    }
    
    /**
     * 设置获取子视图距离的误差值。默认是0.5，误差越小则距离的精确值越大，误差最低值不能<=0。一般不需要调整这个值，只有那些要求精度非常高的场景才需要微调这个值,比如在一些曲线路径较短的情况下，通过调小这个值来子视图之间间距的精确计算。
     */
    public var tg_distanceError : CGFloat = 0.5
    
    fileprivate var tgHasOriginView = false
    fileprivate var tgSubviewPoints : [CGPoint]?
    fileprivate var tgPointIndexs : [Int]?
    fileprivate var tgArgumentArray = {
        return [CGFloat]()
    }()
    
    
    
    /**
     * 得到子视图在曲线路径中定位时的函数的自变量的值。也就是说在函数中当值等于下面的返回值时，这个视图的位置就被确定了。方法如果返回nil则表示这个子视图没有定位。
     */
    public func tg_argumentFrom(subview:UIView)->CGFloat?{
        
        guard let index = subviews.index(of: subview) else {
            return nil
        }
        
        if tg_originView == subview {
            return nil
        }
        
        if index < tgArgumentArray.count{
            guard tg_polarEquation != nil else {
                return tgArgumentArray[index]/180 * CGFloat(M_PI)
            }
            
            return tgArgumentArray[index]
        }
        
        return nil
    }
    
    /**
     * 下面三个函数用来获取两个子视图之间的曲线路径数据，在调用getSubviewPathPoint方法之前请先调用beginSubviewPathPoint方法，而调用完毕后请调用endSubviewPathPoint方法，否则getSubviewPathPoint返回的结果未可知。
     */
    
    //开始和结束获取子视图路径数据的方法,full表示getSubviewPathPoint获取的是否是全部路径点。如果为NO则只会获取子视图的位置的点。
    public func tg_beginSubviewPathPoint(full:Bool){
        if full {
        
        }else{
            
        }
    }
    
    public func tg_endSubviewPathPoint(){
        tgSubviewPoints = nil
        tgPointIndexs = nil
    }
    
    /**
     * 创建从某个子视图到另外一个子视图之间的路径点，返回NSValue数组，里面的值是CGPoint。
     * fromIndex指定开始的子视图的索引位置，toIndex指定结束的子视图的索引位置。如果有原点子视图时,这两个索引值不能算上原点子视图的索引值。
     */
    public func tg_getSubviewPathPoint(fromIndex:Int,toIndex:Int) -> [CGPoint]?{
        if tgSubviewPoints == nil {
            return nil
        }
        
        let realFromIndex = fromIndex
        let realToIndex = toIndex
        if realFromIndex == realToIndex {
            return [CGPoint]()
        }
        
        //要求外界传递进来的索引要考虑原点视图的索引。
        var retPoints = [CGPoint]()
        if realFromIndex < realToIndex {
            var start : Int
            var end : Int
            if tgPointIndexs == nil {
                start = realFromIndex
                end = realToIndex
            }else{
                start = tgPointIndexs![realFromIndex]
                end = tgPointIndexs![realToIndex]
            }
            
            for i in start...end {
                retPoints.append(tgSubviewPoints![i])
            }
        }else{
            var end = tgPointIndexs![realFromIndex]
            let start = tgPointIndexs![realToIndex]
            while end >= start {
                retPoints.append(tgSubviewPoints![end])
                end-=1
            }
        }
        
        return retPoints
    }
    
    /**
     * 创建布局的曲线的路径。用户需要负责销毁返回的值。调用者可以用这个方法来获得曲线的路径，进行一些绘制的工作。
     * subviewCount:指定这个路径上子视图的数量的个数，如果设置为-1则是按照布局视图的子视图的数量来创建。需要注意的是如果布局视图的spaceType为Flexed,Count的话则这个参数设置无效。
     */
    public func tg_createPath(subviewCount:Int) -> CGPath{
        let retPath = CGMutablePath()
        
        
        return retPath
    }
    
    fileprivate func tgCalcPathPoints(showPath:CGMutablePath,
                                    pTotalLen:CGFloat,
                                    subviewCount:Int,
                                    pointIndexArray:[Int],
                                    viewSpacing:CGFloat)
        ->[CGPoint]
    {
        var pointArray = [CGPoint]()
        let selfWidth = bounds.width - tg_leftPadding - tg_rightPadding
        let selfHeight = bounds.height - tg_topPadding - tg_bottomPadding
        var startArg : CGFloat
        var endArg : CGFloat
        if let rectangularEquation = tg_rectangularEquation{
            startArg = 0 - selfWidth*tg_coordinateSetting.origin.x
            if tg_coordinateSetting.isReverse{
                if tg_coordinateSetting.isMath{
                    startArg = -1 * selfHeight * (1 - tg_coordinateSetting.origin.y)
                }else{
                    startArg = selfHeight * (0 - tg_coordinateSetting.origin.y)
                }
            }
            
            if tg_coordinateSetting.start != -CGFloat.greatestFiniteMagnitude{
                startArg = tg_coordinateSetting.start
            }
            
            endArg = selfWidth - selfWidth * tg_coordinateSetting.origin.x
            if tg_coordinateSetting.isReverse{
                if tg_coordinateSetting.isMath{
                    endArg = -1 * selfHeight * (0 - tg_coordinateSetting.origin.y)
                }else{
                    endArg = selfHeight * (1 - tg_coordinateSetting.origin.y)
                }
            }
            
            if tg_coordinateSetting.end != CGFloat.greatestFiniteMagnitude{
                endArg = tg_coordinateSetting.end
            }
            
            tgCalcPathPointsHelper(pointArray: pointArray, showPath: showPath, pTotalLen: pTotalLen, subviewCount: subviewCount, pointIndexArray: pointIndexArray, viewSpacing: viewSpacing, startArg: startArg, endArg: endArg){
                arg in
                if let val = rectangularEquation(arg){
                    if tg_coordinateSetting.isReverse{
                        let x = val + selfWidth * tg_coordinateSetting.origin.x + tg_leftPadding
                        let y = (tg_coordinateSetting.isMath ? -arg : arg) + selfHeight * tg_coordinateSetting.origin.y + tg_topPadding
                        return CGPoint(x: x, y: y)
                    }else{
                        let x = arg + selfWidth * tg_coordinateSetting.origin.x + tg_leftPadding
                        let y = (tg_coordinateSetting.isMath ? -val : val) + selfHeight * tg_coordinateSetting.origin.y + tg_topPadding
                        return CGPoint(x: x, y: y)
                    }
                    
                }else{
                    return nil
                }
            }
        }else if let parametricEquation = tg_parametricEquation{
            startArg = 0 - selfWidth * tg_coordinateSetting.origin.x
            if tg_coordinateSetting.isReverse{
                if tg_coordinateSetting.isMath{
                    startArg = -1 * selfHeight * (1 - tg_coordinateSetting.origin.y)
                }else{
                    startArg = selfHeight * (0 - tg_coordinateSetting.origin.y)
                }
            }
            
            if tg_coordinateSetting.start != -CGFloat.greatestFiniteMagnitude{
                startArg = tg_coordinateSetting.start
            }
            endArg = selfWidth - selfWidth * tg_coordinateSetting.origin.x
            
            if tg_coordinateSetting.isReverse{
                if tg_coordinateSetting.isMath{
                    endArg = -1 * selfHeight * (0 - tg_coordinateSetting.origin.y)
                }else{
                    endArg = selfHeight * (1 - tg_coordinateSetting.origin.y)
                }
            }
            if tg_coordinateSetting.end != CGFloat.greatestFiniteMagnitude{
                endArg = tg_coordinateSetting.end
            }
            
            //TODO:
            
        }
        
        
        
        return pointArray
    }
    
    fileprivate func tgCalcPathPointsHelper(pointArray:[CGPoint],
                                          showPath:CGMutablePath,
                                          pTotalLen:CGFloat,
                                          subviewCount:Int,
                                          pointIndexArray:[Int],
                                          viewSpacing:CGFloat,
                                          startArg:CGFloat,
                                          endArg:CGFloat,
                                          func:(CGFloat)->CGPoint?){
    
    }
}























