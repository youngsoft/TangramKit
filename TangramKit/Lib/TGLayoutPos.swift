//
//  TGLayoutPos.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


/**
 *视图的布局位置类，用于定位视图在布局视图中的位置。位置可分为水平方向的位置和垂直方向的位置，在视图定位时必要同时指定水平方向的位置和垂直方向的位置。水平方向的位置可以分为左，水平居中，右三种位置，垂直方向的位置可以分为上，垂直居中，下三种位置。
 
 下面的表格描述了各种布局下的子视图的布局位置对象的equal方法可以设置的值。
 为了表示方便我们把：线性布局简写为L、相对布局简写为R、表格布局简写为T、框架布局简写为FR、流式布局简写为FL、浮动布局简写为FO、全部简写为ALL，不支持为-
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |method\val|CGFloat |[TGLayoutPos]  |TGWeight |tg_left|tg_top|tg_right|tg_bottom|tg_centerX|tg_centerY|
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 | tg_left	| ALL    | -             | L/FR/T  | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 | tg_top   | ALL    | -             | L/FR/T  | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_right	| ALL    | -             | L/FR/T  | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_bottom	| ALL    | -             | L/FR/T  | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_centerX| ALL    | R             | L/FR/T  | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_centerY| ALL    | R             | L/FR/T  | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 
 上表中所有布局下的子视图的布局位置都支持设置为数值，而数值对于线性布局，表格布局，框架布局这三种布局来说当设置的值是TGWeight时表示的是相对的边界值
 比如一个框架布局的宽度是100，而其中的一个子视图的tg_left.equal(10%)则表示这个子视图左边距离框架布局的左边的宽度是100*0.1
 
 */



/*
 视图的布局位置类是用来描述视图与其他视图之间的位置关系的类。视图在进行定位时需要明确的指出其在父视图坐标轴上的水平位置(x轴上的位置）和垂直位置(y轴上的位置）。
 视图的水平位置可以用左、水平中、右三个方位的值来描述，垂直位置则可以用上、垂直中、下三个方位的值来描述。
 也就是说一个视图的位置需要用水平的某个方位的值以及垂直的某个方位的值来确定。一个位置的值可以是一个具体的数值，也可以依赖于另外一个视图的位置来确定。
 */
final public class TGLayoutPos {
    
    
    internal enum ValueType
    {
        case floatV(CGFloat)
        case posV(TGLayoutPos)
        case arrayV([TGLayoutPos])
        case weightV(TGWeight)
    }
    
    
    internal weak var _view:UIView! = nil
    internal let _type:TGGravity
    internal var _posVal:ValueType!
    internal var _offsetVal:CGFloat = 0
    internal var _lBoundVal:TGLayoutPos!
    internal var _uBoundVal:TGLayoutPos!
    
    private init(type:TGGravity, hasBound:Bool)
    {
        _type = type
        if (hasBound)
        {
            _lBoundVal = TGLayoutPos(type:type,hasBound:false)
            _uBoundVal = TGLayoutPos(type:type,hasBound:false)
            
            _lBoundVal.equal(-CGFloat.greatestFiniteMagnitude)
            _uBoundVal.equal(CGFloat.greatestFiniteMagnitude)
        }
    }
    
    public convenience init(_ type:TGGravity) {
        
        self.init(type:type, hasBound:true)
    }
    
    
    //设置位置的值为数值类型，offset是在设置值的基础上的偏移量。
    public func equal(_ origin:CGFloat, offset:CGFloat = 0)
    {
        _offsetVal = offset
        _posVal = .floatV(origin)
        setNeedLayout()
    }
    
    //设置位置的值为比重或者相对数值。
    public func equal(_ weight:TGWeight, offset:CGFloat = 0)
    {
        _offsetVal = offset
        _posVal = .weightV(weight)
        setNeedLayout()
    }
    
    //设置位置的值为数组对象。表示这个位置和数组中的位置整体居中，这个方法只有对视图的扩展属性tg_centerX,tg_centerY并且父布局是相对布局时才有意义。
    public func equal(_ array:[TGLayoutPos], offset:CGFloat = 0)
    {
        _offsetVal = offset
        _posVal = .arrayV(array)
        setNeedLayout()
    }
    
    //设置位置的值为位置对象，表示相对于其他位置。如果设置为nil则表示清除位置的值的设定。
    public func equal(_ pos:TGLayoutPos!, offset:CGFloat = 0)
    {
        _offsetVal = offset
        if pos == nil
        {
            _posVal = nil
        }
        else
        {
            _posVal = .posV(pos)
        }
        setNeedLayout()
    }
    
    //设置位置值的偏移量，和equal中的offset等价。
    public func offset(_ val:CGFloat)
    {
        if _offsetVal != val
        {
            _offsetVal = val
            setNeedLayout()
        }
    }
    
    //设置位置值的最小边界值。
    public func lBound(_ val:CGFloat)
    {
        _lBoundVal.equal(val)
        setNeedLayout()
    }
    
    //设置位置值的最大边界值。
    public func uBound(_ val:CGFloat)
    {
        _uBoundVal.equal(val)
        setNeedLayout()
    }
    
    //清除位置设置。
    public func clear()
    {
        _posVal = nil
        _offsetVal = 0
        _lBoundVal.equal(-CGFloat.greatestFiniteMagnitude)
        _uBoundVal.equal(CGFloat.greatestFiniteMagnitude)
        setNeedLayout()
    }
    
    //判断是否设置了位置值。
    public var hasValue:Bool
    {
        
        return _posVal != nil
    }
    
    //返回设置的数值类型的值。
    public var posNumVal:CGFloat!
    {
        
        if (_posVal == nil){
            return nil
        }
        
        switch _posVal! {
        case .floatV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //返回设定的比重类型的值。
    public var posWeightVal:TGWeight!
    {
        
        if (_posVal == nil){
            return nil
        }
        
        switch _posVal! {
        case .weightV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //返回设定的相对位置的值。
    public var posRelaVal:TGLayoutPos!
    {
        
        if (_posVal == nil){
            return nil
        }
        
        switch _posVal! {
        case .posV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //返回设定的数值类型的值。
    public var posArrVal:[TGLayoutPos]!
    {
        
        if (_posVal == nil){
            return nil
        }
        
        switch _posVal! {
        case .arrayV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //返回偏移量值。
    public var offsetVal:CGFloat
    {
        
        return _offsetVal
    }
    
    //返回设置的下边界值。
    public var lBoundVal:TGLayoutPos
    {
        return _lBoundVal
    }
    
    //返回设置的上边界值。
    public var uBoundVal:TGLayoutPos
    {
        return _uBoundVal
    }
}

extension TGLayoutPos:NSCopying
{
    
    internal func belong(to view:UIView) -> TGLayoutPos
    {
        _view = view
        
        return self
    }
    
    internal var view:UIView
    {
        return _view
    }
    


    internal var margin:CGFloat
    {
        
        var retVal = (self.posNumVal ?? 0) + _offsetVal
        retVal = min(_uBoundVal.posNumVal!, retVal)
        retVal = max(_lBoundVal.posNumVal!, retVal)
        
        return retVal
    }
    
    
    internal func realMarginInSize(_ contentSize:CGFloat) -> CGFloat
    {
        if self.posWeightVal != nil
        {
            return self.posWeightVal.rawValue/100 * contentSize + self.offsetVal
        }
        else if self.posNumVal != nil
        {
            return self.posNumVal + self.offsetVal
        }
        else
        {
            return self.offsetVal
        }
        
    }
    

 
    internal func setNeedLayout()
    {
        if (_view == nil)
        {
            return
        }
        
        
        if let baseLayout:TGBaseLayout = _view.superview as? TGBaseLayout , !baseLayout.tg_isLayouting
        {
            baseLayout.setNeedsLayout()
        }
    }
    
    
        public func copy(with zone: NSZone? = nil) -> Any
        {
            let ls:TGLayoutPos = type(of: self).init(self._type)
            ls._view = self._view
            ls._posVal = self._posVal
            ls._offsetVal = self._offsetVal
            ls._lBoundVal._posVal = self._lBoundVal._posVal
            ls._lBoundVal._offsetVal = self._lBoundVal._offsetVal
            ls._uBoundVal._posVal = self._uBoundVal._posVal
            ls._uBoundVal._offsetVal = self._uBoundVal._offsetVal
            
            return ls
            
        }
    

}

//TGLayoutPos的equal方法的快捷方法。比如a.tg_left.equal(10) <==> a.tg_left ~= 10
 func ~=(oprPos:TGLayoutPos, origin:CGFloat)
{
    oprPos.equal(origin)
}

func ~=(oprPos:TGLayoutPos, weight:TGWeight)
{
    oprPos.equal(weight)
}

func ~=(oprPos:TGLayoutPos, array:[TGLayoutPos])
{
    oprPos.equal(array)
}

func ~=(oprPos:TGLayoutPos, pos:TGLayoutPos!)
{
    oprPos.equal(pos)
}

//TGLayoutPos的offset方法的快捷方法。比如a.tg_left.offset(10) <==> a.tg_left += 10
func +=(oprPos:TGLayoutPos, val:CGFloat)
{
    oprPos.offset(val)
}

func -=(oprPos:TGLayoutPos, val:CGFloat)
{
    oprPos.offset(-1 * val)
}

//TGLayoutPos的lBound方法的快捷方法。比如a.tg_left.lBound(10) <==> a.tg_left >= 10
func >=(oprPos:TGLayoutPos, size:CGFloat)
{
    oprPos.lBound(size)
}

//TGLayoutPos的uBound方法的快捷方法。比如a.tg_left.uBound(10) <==> a.tg_left <= 10
func <=(oprPos:TGLayoutPos, size:CGFloat)
{
    oprPos.uBound(size)
}








