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
    public var origin : CGPoint = .zero {
        
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
     * 开始位置和结束位置。如果不设置则根据坐标原点设置以及视图的尺寸自动确定.默认是nil
     */
    public var start:CGFloat! {
        didSet{
            if start != oldValue {
                pathLayout?.setNeedsLayout()
            }
        }
    }
    
    public var end:CGFloat! {
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
        start = nil
        end = nil
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
     * 极坐标方程，入参是极坐标的弧度，返回r半径。要求函数在定义域内是连续的，否则结果不确定。如果返回的点无效，则请返回nil
     */
    public var tg_polarEquation : ((TGRadian)->CGFloat?)?{
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
                if (newValue != nil){
                    super.addSubview(newValue!)
                    tgHasOriginView = true
                }
                return
            }
            
            guard let originView = newValue else {
                if subviews.count > 0{
                    subviews.last?.removeFromSuperview()
                    tgHasOriginView = false
                }
                return
            }
            
            if subviews.count > 0 {
                if subviews.last != originView{
                    subviews.last?.removeFromSuperview()
                    super.addSubview(originView)
                }
            }else{
                addSubview(originView)
            }
        }
    }
    
    /**
     * 返回布局视图中所有在曲线路径中排列的子视图。如果设置了原点视图则返回subviews里面除最后一个子视图外的所有子视图，如果没有原点子视图则返回subviews
     */
    public var tg_pathSubviews : [UIView]{
        get{
            guard tgHasOriginView && subviews.count > 0 else {
                return subviews
            }
            
            var pathsbs = [UIView]()
            for i in 0..<subviews.count-1{
                pathsbs.append(subviews[i])
            }
            
            return pathsbs
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
            if (self.tg_polarEquation != nil)
            {
                return CGFloat(TGRadian(angle:tgArgumentArray[index]))
            }
            else
            {
              return tgArgumentArray[index]
            }
        }
        
        return nil
    }
    
    /**
     * 下面三个函数用来获取两个子视图之间的曲线路径数据，在调用getSubviewPathPoint方法之前请先调用beginSubviewPathPoint方法，而调用完毕后请调用endSubviewPathPoint方法，否则getSubviewPathPoint返回的结果未可知。
     */
    
    //开始和结束获取子视图路径数据的方法,full表示getSubviewPathPoint获取的是否是全部路径点。如果为NO则只会获取子视图的位置的点。
    public func tg_beginSubviewPathPoint(full:Bool){
        var pointIndexs:[Int]? = full ? [Int]() : nil
        tgSubviewPoints = tgCalcPoints(sbs: tg_pathSubviews, path: nil, pointIndexArray: &pointIndexs)
        tgPointIndexs = full ? pointIndexs : nil
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
        var pTotalLen : CGFloat? = nil
        var pointIndexArray : [Int]? = []
        switch tg_spaceType {
        case let .fixed(value):
            var subviewCount = subviewCount
            if subviewCount == -1{
                subviewCount = tg_pathSubviews.count
            }
            _ = tgCalcPathPoints(showPath: retPath, pTotalLen: &pTotalLen, subviewCount: subviewCount, pointIndexArray: &pointIndexArray, viewSpacing: value)
        default:
            _ = tgCalcPathPoints(showPath: retPath, pTotalLen: &pTotalLen, subviewCount: -1, pointIndexArray: &pointIndexArray, viewSpacing: 0)
        }
        return retPath
    }
    
    
    //MARK: -- Private Method
    fileprivate func tgCalcPoints(sbs:[UIView],path:CGMutablePath?,pointIndexArray:inout [Int]?) -> [CGPoint]?{
        if sbs.count > 0{
            var totalLen : CGFloat? = nil
            var sbvcount = sbs.count
            switch tg_spaceType {
            case let .fixed(value):
                return tgCalcPathPoints(showPath: path, pTotalLen: &totalLen, subviewCount: sbs.count, pointIndexArray: &pointIndexArray, viewSpacing: value)
            case let .count(count):
                sbvcount = count
            default:
                break
            }
            
            totalLen = 0
            let tempArray = tgCalcPathPoints(showPath: path, pTotalLen: &totalLen, subviewCount: -1, pointIndexArray: &pointIndexArray, viewSpacing: 0)
            var bClose = false
            if tempArray.count > 1{
                let p1 = tempArray.first
                let p2 = tempArray.last
                bClose = tgCalcDistance(pt1: p1!, pt2: p2!) <= 1
            }
            
            var viewSpacing : CGFloat = 0
            if sbvcount > 1{
                let n  = bClose ? 0 : 1
                viewSpacing = totalLen! / CGFloat(sbvcount - n)
            }
            totalLen = nil
            return tgCalcPathPoints(showPath: nil, pTotalLen: &totalLen, subviewCount: sbs.count, pointIndexArray: &pointIndexArray, viewSpacing: viewSpacing)
        }
        
        return nil
    }
    
    fileprivate func tgCalcPathPoints(showPath:CGMutablePath?,
                                    pTotalLen:inout CGFloat?,
                                    subviewCount:Int,
                                    pointIndexArray:inout [Int]?,
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
            
            if tg_coordinateSetting.start != nil{
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
            
            if tg_coordinateSetting.end != nil {
                endArg = tg_coordinateSetting.end
            }
            
            tgCalcPathPointsHelper(pointArray: &pointArray, showPath: showPath, pTotalLen: &pTotalLen, subviewCount: subviewCount, pointIndexArray: &pointIndexArray, viewSpacing: viewSpacing, startArg: startArg, endArg: endArg){
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
        }
        else if let parametricEquation = tg_parametricEquation{
            startArg = 0 - selfWidth * tg_coordinateSetting.origin.x
            if tg_coordinateSetting.isReverse{
                if tg_coordinateSetting.isMath{
                    startArg = -1 * selfHeight * (1 - tg_coordinateSetting.origin.y)
                }else{
                    startArg = selfHeight * (0 - tg_coordinateSetting.origin.y)
                }
            }
            
            if tg_coordinateSetting.start != nil{
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
            if tg_coordinateSetting.end != nil{
                endArg = tg_coordinateSetting.end
            }
            
            tgCalcPathPointsHelper(pointArray: &pointArray, showPath: showPath, pTotalLen: &pTotalLen, subviewCount: subviewCount, pointIndexArray: &pointIndexArray, viewSpacing: viewSpacing, startArg: startArg, endArg: endArg){
                arg in
                if let val = parametricEquation(arg){
                    if tg_coordinateSetting.isReverse{
                        let x = val.y + selfWidth * tg_coordinateSetting.origin.x + tg_leftPadding
                        let y = (tg_coordinateSetting.isMath ? -val.x : val.x) + selfHeight * tg_coordinateSetting.origin.y + tg_topPadding
                        return CGPoint(x: x, y: y)
                    
                    }else{
                        let x = val.x + selfWidth * tg_coordinateSetting.origin.x + tg_leftPadding
                        let y = (tg_coordinateSetting.isMath ? -val.y : val.y) + selfHeight * tg_coordinateSetting.origin.y + tg_topPadding
                        return CGPoint(x: x, y: y)
                    }
                
                }else{
                    return nil
                }
            }
            
        }
        else if let polarEquation = tg_polarEquation{
            startArg = 0
            if tg_coordinateSetting.start != nil {
                
                startArg = TGRadian(value:tg_coordinateSetting.start).angle
            }
            endArg = 360
            if tg_coordinateSetting.end != nil {
                endArg = TGRadian(value:tg_coordinateSetting.end).angle
            }
            tgCalcPathPointsHelper(pointArray: &pointArray, showPath: showPath, pTotalLen: &pTotalLen, subviewCount: subviewCount, pointIndexArray: &pointIndexArray, viewSpacing: viewSpacing, startArg: startArg, endArg: endArg){
                arg in
                //计算用弧度
                let rad = TGRadian(angle:arg)
                if let r = polarEquation(rad){
                    if tg_coordinateSetting.isReverse{
                        let y = r * cos(rad.value)
                        let x = r * sin(rad.value) + selfWidth * tg_coordinateSetting.origin.x + tg_leftPadding
                        let y1 =  (tg_coordinateSetting.isMath ? -y : y) + selfHeight * tg_coordinateSetting.origin.y + tg_topPadding
                        return CGPoint(x: x, y: y1)
                    }else{
                        let y = r * sin(rad.value)
                        let x = r * cos(rad.value) + selfWidth * tg_coordinateSetting.origin.x + tg_leftPadding
                        let y1 =  (tg_coordinateSetting.isMath ? -y : y) + selfHeight * tg_coordinateSetting.origin.y + tg_topPadding
                        return CGPoint(x: x, y: y1)
                    }
                }else{
                    return nil
                }
            }
        }

        return pointArray
    }
    
    fileprivate func tgCalcPathPointsHelper(pointArray:inout [CGPoint],
                                          showPath:CGMutablePath?,
                                          pTotalLen:inout CGFloat?,
                                          subviewCount:Int,
                                          pointIndexArray:inout [Int]?,
                                          viewSpacing:CGFloat,
                                          startArg:CGFloat,
                                          endArg:CGFloat,
                                          function:(CGFloat)->CGPoint?)
    {
        if tg_distanceError <= 0{
            tg_distanceError = 0.5
        }
    
        tgArgumentArray.removeAll()
        
        var distance : CGFloat = 0
        var lastXY = CGPoint.zero
        
        var arg = startArg
        var lastValidArg = arg
        var isStart = true
        var startCount = 0
        var subviewCount = subviewCount
        while (true){
            if (subviewCount < 0){
                if (arg - endArg > 0.1){  //这里不能用arg > endArg 的原因是有精度问题。
                    break
                }
            }else if (subviewCount == 0){
                break
            }else{
                if (isStart && startCount >= 1){
                    if (pointIndexArray != nil){
                        pointIndexArray!.append(pointArray.count)
                    }
                    pointArray.append(lastXY)
                    tgArgumentArray.append(arg)
                    showPath?.addLine(to: lastXY)
                    break
                }
            }
            
            var realXY = function(arg)
            if realXY != nil{
                if (isStart){
                    isStart = false
                    startCount += 1
                    if (subviewCount > 0 && startCount == 1){
                        subviewCount-=1
                        lastValidArg = arg
                        pointIndexArray?.append(pointArray.count)
                        tgArgumentArray.append(arg)
                    }
                    pointArray.append(realXY!)
                    showPath?.move(to: realXY!)
                }else{
                    if (subviewCount >= 0){
                        let oldDistance = distance
                        distance += tgCalcDistance(pt1: realXY!, pt2: lastXY)
                        if (distance >= viewSpacing){
                            if (distance - viewSpacing >= tg_distanceError){
                                realXY = tgGetNearestDistancePoint(startArg: arg, lastXY: lastXY, distance: oldDistance, viewSpace: viewSpacing, pLastValidArg: &lastValidArg, function: function)
                            }else{
                                lastValidArg = arg
                            }
                            if (pointIndexArray == nil){
                                pointArray.append(realXY!)
                            }else{
                                pointIndexArray?.append(pointArray.count)
                            }
                            distance = 0
                            subviewCount -= 1
                            tgArgumentArray.append(lastValidArg)
                        }else if (distance - viewSpacing > -1 * tg_distanceError){
                            if (pointIndexArray == nil){
                                pointArray.append(realXY!)
                            }else{
                                pointIndexArray?.append(pointArray.count)
                            }
                            distance = 0
                            subviewCount -= 1
                            lastValidArg = arg
                            tgArgumentArray.append(arg)
                        }else{
                            lastValidArg = arg
                        }
                    }else{
                        if (pointIndexArray == nil){
                            pointArray.append(realXY!)
                        }
                    }
                    
                    if (pointIndexArray != nil){
                        pointArray.append(realXY!)
                    }
                    
                    showPath?.addLine(to: realXY!)
                    
                    if (pTotalLen != nil){
                        pTotalLen! += tgCalcDistance(pt1: realXY!, pt2: lastXY)
                    }
                }
                
                lastXY = realXY!
            }else{
                isStart = true
            }
            arg += 1
        }
    }
    
    fileprivate func tgCalcDistance(pt1:CGPoint,pt2:CGPoint) -> CGFloat{
        return sqrt(pow(pt1.x - pt2.x, 2) + pow(pt1.y - pt2.y, 2))
    }
    
    fileprivate func tgGetNearestDistancePoint(startArg:CGFloat,
                                               lastXY:CGPoint,
                                               distance:CGFloat,
                                               viewSpace:CGFloat,
                                               pLastValidArg:inout CGFloat,
                                               function:(CGFloat)->CGPoint?)
    -> CGPoint {
        //判断pLastValidArg和Arg的差距如果超过1则按pLastValidArg + 1作为开始计算的变量。
        var startArg = startArg
        var lastXY = lastXY
        if startArg - pLastValidArg > 1{
            startArg = pLastValidArg + 1
        }
        
        var step : CGFloat = 1
        var distance = distance
        while true {
            var arg = startArg - step + step/10
            while arg - startArg < 0.0001{
                if let realXY = function(arg){
                    let oldDistance = distance
                    distance += tgCalcDistance(pt1: realXY, pt2: lastXY)
                    if distance >= viewSpace{
                        if distance - viewSpace <= tg_distanceError{
                            pLastValidArg = arg
                            return realXY
                        }else{
                            distance = oldDistance
                            break
                        }
                    }
                    lastXY = realXY
                }
                
                arg += step / 10
            }
            
            if arg > startArg {
                startArg += 1
                step = 1
            }else{
                startArg = arg
                step /= 10
            }
            if step <= 0.0001 {
                break
            }
        }
        
        return lastXY
    }
    
    override func tgCalcLayoutRect(_ size: CGSize, isEstimate: Bool, type: TGSizeClassType) -> (selfSize: CGSize, hasSubLayout: Bool) {
        var (selfSize,hasSubLayout) = super.tgCalcLayoutRect(size, isEstimate: isEstimate, type: type)
        var sbs = tgGetLayoutSubviews()
        for sbv in sbs{
            if !isEstimate{
                sbv.tgFrame.frame = sbv.bounds
                tgCalcSizeFromSizeWrapSubview(sbv)
            }
            
            if sbv.isKind(of: TGBaseLayout.self){
                let sbv1 = sbv as! TGBaseLayout
                if hasSubLayout && (sbv1.tg_width.isWrap || sbv1.tg_height.isWrap){
                    hasSubLayout = true
                }
                
                if isEstimate && (sbv1.tg_width.isWrap || sbv1.tg_height.isWrap){
                    _ = sbv1.tg_sizeThatFits(sbv1.tgFrame.frame.size, inSizeClass: type)
                    sbv1.tgFrame.sizeClass = sbv1.tgMatchBestSizeClass(type)
                    //因为tg_sizeThatFits执行后会还原，所以这里要重新设置
                }
            }
        }
        
       // var maxSize = CGSize(width: tg_leftPadding, height: tg_topPadding)
        //记录最小的y值和最大的y值
        var minYPos = CGFloat.greatestFiniteMagnitude
        var maxYPos = -CGFloat.greatestFiniteMagnitude
        var minXPos = CGFloat.greatestFiniteMagnitude
        var maxXPos = -CGFloat.greatestFiniteMagnitude
        
        //算路径子视图的。
        sbs = tgGetLayoutSubviewsFrom(sbsFrom: tg_pathSubviews)
        
        var path:CGMutablePath? = nil
        if layer.isKind(of: CAShapeLayer.self) && !isEstimate{
            path = CGMutablePath()
        }
        
        var pointIndexArray : [Int]? = nil
        let pts = tgCalcPoints(sbs: sbs, path: path, pointIndexArray: &pointIndexArray)
        
        if (path != nil){
            let slayer = layer as! CAShapeLayer
            slayer.path = path
        }

        for i in 0..<sbs.count{
            let sbv = sbs[i]
            var pt = CGPoint.zero
            if pts != nil && pts!.count > i{
                pt = pts![i]
            }
            
            //计算得到最大的高度和最大的宽度。
            var rect = sbv.tgFrame.frame
            
            if sbv.tg_width.dimeNumVal != nil{
                rect.size.width = sbv.tg_width.measure
            }
            
            if sbv.tg_width.dimeRelaVal != nil{
                if sbv.tg_width.dimeRelaVal === tg_width{
                    rect.size.width =  sbv.tg_width.measure(selfSize.width - tg_leftPadding - tg_rightPadding)
                }else{
                    rect.size.width = sbv.tg_width.measure(sbv.tg_width.dimeRelaVal._view.tg_estimatedFrame.size.width)
                }
            }
            
            rect.size.width = tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if sbv.tg_height.dimeNumVal != nil{
                rect.size.height = sbv.tg_height.measure
            }
            
            if sbv.tg_height.dimeRelaVal != nil{
                if sbv.tg_height.dimeRelaVal === tg_height{
                    rect.size.height = sbv.tg_height.measure(selfSize.height - tg_topPadding - tg_bottomPadding)
                }else{
                    rect.size.height = sbv.tg_height.measure(sbv.tg_height.dimeRelaVal._view.tg_estimatedFrame.size.height)
                }
            }
            
            if (sbv.tg_height.isFlexHeight){
                rect.size.height = tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //中心点的位置。。
            rect.origin.x = pt.x - rect.size.width * sbv.layer.anchorPoint.x + sbv.tg_left.margin
            rect.origin.y = pt.y - rect.size.height * sbv.layer.anchorPoint.y + sbv.tg_top.margin
           
            if (rect.minY < minYPos)
            {
                minYPos = rect.minY
            }
            
            if (rect.maxY > maxYPos)
            {
                maxYPos = rect.maxY
            }
            
            if (rect.minX < minXPos)
            {
                minXPos = rect.minX
            }
            
            if (rect.maxX > maxXPos)
            {
                maxXPos = rect.maxX
            }
            
            sbv.tgFrame.frame = rect
        }
        
        //特殊填充中心视图。
        if let sbv = tg_originView{
            var rect = sbv.tgFrame.frame
            
            if sbv.tg_width.dimeNumVal != nil{
                rect.size.width = sbv.tg_width.measure
            }
            
            if sbv.tg_width.dimeRelaVal != nil{
                if sbv.tg_width.dimeRelaVal === tg_width{
                    rect.size.width = sbv.tg_width.measure(selfSize.width - tg_leftPadding - tg_rightPadding)
                }else{
                    rect.size.width = sbv.tg_width.measure(sbv.tg_width.dimeRelaVal._view.tg_estimatedFrame.size.width)
                }
            }
            
            rect.size.width = tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize: rect.size.width, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            if (sbv.tg_height.dimeNumVal != nil){
                rect.size.height = sbv.tg_height.measure
            }
            
            if (sbv.tg_height.dimeRelaVal != nil){
                if (sbv.tg_height.dimeRelaVal === tg_height){
                    rect.size.height = sbv.tg_height.measure(selfSize.height - tg_topPadding - tg_bottomPadding)
                }else{
                    rect.size.height = sbv.tg_height.measure(sbv.tg_height.dimeRelaVal._view.tg_estimatedFrame.size.height)
                }
            }
            
            if (sbv.tg_height.isFlexHeight){
                rect.size.height = tgCalcHeightFromHeightWrapView(sbv, width: rect.size.width)
            }
            
            rect.size.height = tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize: rect.size.height, sbvSize: rect.size, selfLayoutSize: selfSize)
            
            //位置在原点位置。。
            rect.origin.x = (selfSize.width - tg_leftPadding - tg_rightPadding)*tg_coordinateSetting.origin.x - rect.size.width / 2 + sbv.tg_left.margin + tg_leftPadding
            rect.origin.y = (selfSize.height - tg_topPadding - tg_bottomPadding)*tg_coordinateSetting.origin.y - rect.size.height / 2 + sbv.tg_top.margin + tg_topPadding
            
            if (rect.minY < minYPos)
            {
                minYPos = rect.minY
            }
            
            if (rect.maxY > maxYPos)
            {
                maxYPos = rect.maxY
            }
            
            if (rect.minX < minXPos)
            {
                minXPos = rect.minX
            }
            
            if (rect.maxX > maxXPos)
            {
                maxXPos = rect.maxX
            }
            
            sbv.tgFrame.frame = rect
        }
        
        if minYPos == .greatestFiniteMagnitude
        {
            minYPos = 0
        }
        
        if maxYPos == -.greatestFiniteMagnitude
        {
            maxYPos = tg_topPadding + tg_bottomPadding
        }
        
        if minXPos == .greatestFiniteMagnitude
        {
            minXPos = 0
        }
        
        if maxXPos == -.greatestFiniteMagnitude
        {
            maxXPos = tg_leftPadding + tg_rightPadding
        }
 
        
        if (tg_width.isWrap){
            selfSize.width = maxXPos - minXPos // + tg_leftPadding + tg_rightPadding
        }
        
        if (tg_height.isWrap){
            selfSize.height = maxYPos - minYPos // + tg_topPadding + tg_bottomPadding
        }
        
        selfSize.height = tgValidMeasure(tg_height, sbv: self, calcSize: selfSize.height, sbvSize: selfSize, selfLayoutSize: superview!.bounds.size)
        
        selfSize.width = tgValidMeasure(tg_width, sbv: self, calcSize: selfSize.width, sbvSize: selfSize, selfLayoutSize: superview!.bounds.size)
    
        return (selfSize,hasSubLayout)
    }
    
    override func tgCreateInstance() -> AnyObject {
        return TGPathLayoutViewSizeClassImpl()
    }
    
}

//MARK: -- Override Method
extension TGPathLayout{
    
    open override func insertSubview(_ view: UIView, at index: Int) {
        var index = index
        if tg_originView != nil {
            if index == subviews.count {
                index -= 1
            }
        }
        super.insertSubview(view, at: index)
    }
    
    open override func addSubview(_ view: UIView) {
        if tg_originView != nil {
            super.insertSubview(view, at: subviews.count - 1)
        }else{
            super.addSubview(view)
        }
    }
    
    open override func sendSubview(toBack view: UIView) {
        if tg_originView == view {
            return
        }
        super.sendSubview(toBack: view)
    }
    
    open override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        if tgHasOriginView {
            if subviews.count > 0 && subview == subviews.last{
                tgHasOriginView = false
            }
        }
    }
}

// MARK: - TGRadian 弧度类

/// 弧度类 TGRadian(angle:90).value
public struct TGRadian: Any
{
    public private(set) var value:CGFloat
    //用角度值构造出一个弧度对象。
    public init(angle:CGFloat)
    {
        value = angle / 180 * .pi
    }
    
    public  init(angle: Int)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: Int8)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: Int16)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: Int32)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: Int64)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: UInt)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: UInt8)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: UInt16)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: UInt32)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public  init(angle: UInt64)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public init(angle: Double)
    {
        self.init(angle:CGFloat(angle))
    }
    
    public init(angle: Float)
    {
        self.init(angle:CGFloat(angle))
    }
    
    //用弧度值构造出一个弧度对象。
    public init(value:CGFloat)
    {
        self.value = value
    }
    
    public  init(value: Int)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: Int8)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: Int16)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: Int32)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: Int64)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: UInt)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: UInt8)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: UInt16)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: UInt32)
    {
        self.init(value:CGFloat(value))
    }
    
    public  init(value: UInt64)
    {
        self.init(value:CGFloat(value))
    }
    
    public init(value: Double)
    {
        self.init(value:CGFloat(value))
    }
    
    public init(value: Float)
    {
        self.init(value:CGFloat(value))
    }

    public init(_ val: TGRadian)
    {
        self.value = val.value
    }
    

    
    //角度值
    public var angle:CGFloat
        {
            return self.value / .pi * 180
    }
}


extension TGRadian:Equatable{

    public static func ==(lhs: TGRadian, rhs: TGRadian) -> Bool {
        
        return lhs.value == rhs.value
        }
}


//弧度运算符重载。
public func +(lhs:TGRadian, rhs:CGFloat) ->CGFloat
{
    return lhs.value + rhs
}

public func +(lhs:CGFloat, rhs:TGRadian) ->CGFloat
{
    return lhs + rhs.value
}

public func *(lhs:TGRadian, rhs:CGFloat) ->CGFloat
{
    return lhs.value * rhs
}

public func *(lhs:CGFloat, rhs:TGRadian) ->CGFloat
{
    return lhs * rhs.value
}

public func /(lhs:TGRadian, rhs:CGFloat) ->CGFloat
{
    return lhs.value / rhs
}

public func /(lhs:CGFloat, rhs:TGRadian) ->CGFloat
{
    return lhs / rhs.value
}

public func -(lhs:TGRadian, rhs:CGFloat) ->CGFloat
{
    return lhs.value - rhs
}

public func -(lhs:CGFloat, rhs:TGRadian) ->CGFloat
{
    return lhs - rhs.value
}





//扩展CGFloat类型的初始化方法，用一个弧度对象来构造CGFloat值，得到的是一个弧度值。
extension CGFloat
{
    public init(_ value: TGRadian)
    {
        self.init(value.value)
    }
}


postfix operator °

/// 弧度对象的初始化简易方法：90°  <==>  TGRadian(angle:90)
public postfix func °(_ angle:CGFloat) -> TGRadian
{
    return TGRadian(angle:angle)
}

public postfix func °(_ angle:Int) -> TGRadian
{
    return TGRadian(angle:angle)
}

public postfix func °(_ angle:UInt) -> TGRadian
{
    return TGRadian(angle:angle)
}



