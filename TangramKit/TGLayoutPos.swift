//
//  TGLayoutPos.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


//定义TGLayoutPosType对象可以设置的值类型。
public protocol TGLayoutPosType
{
}

extension CGFloat:TGLayoutPosType{}
extension Double:TGLayoutPosType{}
extension Float:TGLayoutPosType{}
extension Int:TGLayoutPosType{}
extension Int8:TGLayoutPosType{}
extension Int16:TGLayoutPosType{}
extension Int32:TGLayoutPosType{}
extension Int64:TGLayoutPosType{}
extension UInt:TGLayoutPosType{}
extension UInt8:TGLayoutPosType{}
extension UInt16:TGLayoutPosType{}
extension UInt32:TGLayoutPosType{}
extension UInt64:TGLayoutPosType{}
extension TGWeight:TGLayoutPosType{}
extension Array:TGLayoutPosType{}
extension TGLayoutPos:TGLayoutPosType{}   //因为TGLayoutPos的equal方法本身就可以设置自身类型，所以这里也实现了这个协议
extension UIView:TGLayoutPosType{}



/**
 *视图的布局位置类，用于定位视图在布局视图中的位置。位置可分为水平方向的位置和垂直方向的位置，在视图定位时必要同时指定水平方向的位置和垂直方向的位置。水平方向的位置可以分为左，水平居中，右三种位置，垂直方向的位置可以分为上，垂直居中，下三种位置。
 
 下面的表格描述了各种布局下的子视图的布局位置对象的equal方法可以设置的值。
 为了表示方便我们把：线性布局简写为L、相对布局简写为R、表格布局简写为T、框架布局简写为FR、流式布局简写为FL、浮动布局简写为FO、全部简写为ALL，不支持为-
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |method\val|CGFloat |[TGLayoutPos]  |TGWeight |tg_left|tg_top|tg_right|tg_bottom|tg_centerX|tg_centerY|
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 | tg_left	| ALL    | -             |L/FR/T/R | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 | tg_top   | ALL    | -             |L/FR/T/R | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_right	| ALL    | -             |L/FR/T/R | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_bottom	| ALL    | -             |L/FR/T/R | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_centerX| ALL    | R             |L/FR/T/R | R     | -    |  R     | -       | R        | -        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 |tg_centerY| ALL    | R             |L/FR/T/R | -     | R    |  -     | R       | -        | R        |
 +----------+--------+---------------+---------+-------+------+--------+---------+----------+----------+
 
 上表中所有布局下的子视图的布局位置都支持设置为数值，而数值对于线性布局，表格布局，框架布局这三种布局来说当设置的值是TGWeight时表示的是相对的边界值
 比如一个框架布局的宽度是100，而其中的一个子视图的tg_left.equal(10%)则表示这个子视图左边距离框架布局的左边的宽度是100*0.1
 
 */



/*
 视图的布局位置类是用来描述视图与其他视图之间的位置关系的类。视图在进行定位时需要明确的指出其在父视图坐标轴上的水平位置(x轴上的位置）和垂直位置(y轴上的位置）。
 视图的水平位置可以用左、水平中、右三个方位的值来描述，垂直位置则可以用上、垂直中、下三个方位的值来描述。
 也就是说一个视图的位置需要用水平的某个方位的值以及垂直的某个方位的值来确定。一个位置的值可以是一个具体的数值，也可以依赖于另外一个视图的位置来确定。
 */
final public class TGLayoutPos
{
    

    //设置位置的值为数值类型，offset是在设置值的基础上的偏移量。
    @discardableResult
    public func equal(_ origin:Int, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.equal(CGFloat(origin), offset:offset)
    }
    
    @discardableResult
    public func equal(_ origin:CGFloat, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.tgEqual(val: origin, offset: offset)
    }
    
    //设置位置的值为比重或者相对数值。
    @discardableResult
    public func equal(_ weight:TGWeight, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.tgEqual(val: weight, offset: offset)
    }
    
    //设置位置的值为数组对象。表示这个位置和数组中的位置整体居中，这个方法只有对视图的扩展属性tg_centerX,tg_centerY并且父布局是相对布局时才有意义。
    @discardableResult
    public func equal(_ array:[TGLayoutPos], offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.tgEqual(val: array, offset: offset)
    }
    
    //设置位置的值为视图的对应的位置，如果当前是tg_left则等价于 tg_left.equal(view.tg_left)
    @discardableResult
    public func equal(_ view: UIView, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.tgEqual(val: view, offset: offset)
    }
    
    //设置位置的值为位置对象，表示相对于其他位置。如果设置为nil则表示清除位置的值的设定。
    @discardableResult
    public func equal(_ pos:TGLayoutPos!, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.tgEqual(val: pos, offset: offset)
    }
    
    //设置位置值的偏移量，和equal中的offset等价。
    @discardableResult
    public func offset(_ val:CGFloat) ->TGLayoutPos
    {
        if _offsetVal != val
        {
            _offsetVal = val
            setNeedLayout()
        }
        
        return self
    }
    
    //设置位置值的最小边界值。
    @discardableResult
    public func min(_ val:CGFloat, offset:CGFloat = 0) ->TGLayoutPos
    {
        _minVal.equal(val, offset:offset)
        setNeedLayout()
        return self
    }
    
    @discardableResult
    public func min(_ val:TGLayoutPos!, offset:CGFloat = 0) ->TGLayoutPos
    {
        _minVal.equal(val, offset:offset)
        setNeedLayout()
        return self
    }
    
    //设置位置值的最大边界值。
    @discardableResult
    public func max(_ val:CGFloat, offset:CGFloat = 0) ->TGLayoutPos
    {
        _maxVal.equal(val, offset:offset)
        setNeedLayout()
        
        return self
    }
    
    @discardableResult
    public func max(_ val:TGLayoutPos!, offset:CGFloat = 0) ->TGLayoutPos
    {
        _maxVal.equal(val, offset:offset)
        setNeedLayout()
        
        return self
    }

    
    //返回视图，用于链式语法
    @discardableResult
    public func and() -> UIView
    {
        return _view
    }
    
    //清除位置设置。
    public func clear()
    {
        _active = true
        _posVal = nil
        _offsetVal = 0
        _minVal.equal(-CGFloat.greatestFiniteMagnitude)
        _maxVal.equal(CGFloat.greatestFiniteMagnitude)
        _minVal._active = true
        _maxVal._active = true
        setNeedLayout()
    }
    
    //设置布局位置是否是活动的,默认是true表示活动的，如果设置为false则表示这个布局位置设置的约束将不会起作用。
    public var isActive:Bool
    {
        get
        {
            return _active
        }
        set
        {
            if _active != newValue
            {
                _active = newValue
                _minVal._active = newValue
                _maxVal._active = newValue
                setNeedLayout()
            }
        }
    }
    
    //判断是否设置了位置值。
    public var hasValue:Bool
    {
        
        return _active &&  _posVal != nil
    }
    
    //返回设置的数值类型的值。
    public var posNumVal:CGFloat!
    {
        
        if (!_active || _posVal == nil)
        {
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
        
        if (!_active || _posVal == nil){
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
        
        if (!_active || _posVal == nil){
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
        
        if (!_active ||  _posVal == nil){
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
        if _active
        {
            return _offsetVal
        }
        else
        {
            return 0
        }
    }
    
    //返回设置的下边界值。
    public var minVal:TGLayoutPos
    {
        return _minVal
    }
    
    //返回设置的上边界值。
    public var maxVal:TGLayoutPos
    {
        return _maxVal
    }
    
    
    internal enum ValueType
    {
        case floatV(CGFloat)
        case posV(TGLayoutPos)
        case arrayV([TGLayoutPos])
        case weightV(TGWeight)
    }
    
    internal weak var _view:UIView! = nil
    internal let _type:TGGravity
    internal var _active:Bool = true
    internal var _posVal:ValueType!
    internal var _offsetVal:CGFloat = 0
    internal var _minVal:TGLayoutPos!
    internal var _maxVal:TGLayoutPos!
    
    private init(type:TGGravity, hasBound:Bool)
    {
        _type = type
        if (hasBound)
        {
            _minVal = TGLayoutPos(type:type,hasBound:false)
            _maxVal = TGLayoutPos(type:type,hasBound:false)
            
            _minVal.equal(-CGFloat.greatestFiniteMagnitude)
            _maxVal.equal(CGFloat.greatestFiniteMagnitude)
        }
    }
    
    public convenience init(_ type:TGGravity) {
        
        self.init(type:type, hasBound:true)
    }
    

}

extension TGLayoutPos
{
    @discardableResult
    internal func tgEqual(val:TGLayoutPosType!, offset:CGFloat = 0)  ->TGLayoutPos
    {
        _offsetVal = offset
        
        if let v = val as? CGFloat
        {
           _posVal = .floatV(v)
        }
        else if let v = val as? Double
        {
            _posVal = .floatV(CGFloat(v))
        }
        else if let v = val as? Float
        {
            _posVal = .floatV(CGFloat(v))
        }
        else if let v = val as? Int
        {
            _posVal = .floatV(CGFloat(v))
        }
        else if let v = val as? TGWeight
        {
            _posVal = .weightV(v)
        }
        else if let v = val as? [TGLayoutPos]
        {
            if _type != TGGravity.vert.center && _type != TGGravity.horz.center
            {
                assert(false, "oops! ");
            }
            
            _posVal = .arrayV(v)
        }
        else if let v = val as? UIView
        {
            if v === _view
            {
                assert(false , "oops!");
            }
            
            switch _type {
            case TGGravity.vert.top:
                _posVal = .posV(v.tg_top)
                break
            case TGGravity.vert.center:
                _posVal = .posV(v.tg_centerY)
                break
            case TGGravity.vert.bottom:
                _posVal = .posV(v.tg_bottom)
                break
            case TGGravity.horz.left:
                _posVal = .posV(v.tg_left)
                break
            case TGGravity.horz.center:
                _posVal = .posV(v.tg_centerX)
                break
            case TGGravity.horz.right:
                _posVal = .posV(v.tg_right)
                break
            default:
                assert(false, "oops!");
            }
        }
        else if let v = val as? TGLayoutPos
        {
            if v === self
            {
                assert(false, "oops!")
            }
            
            _posVal = .posV(v)
            
        }
        else if val == nil
        {
             _posVal = nil
        }
        else
        {
            assert(false , "oops");
        }
        
        
        setNeedLayout()
        
        return self
    }
    
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
        if _active
        {
            var retVal = (self.posNumVal ?? 0) + _offsetVal
            if _maxVal != nil && _maxVal.posNumVal != nil
            {
                retVal = Swift.min(_maxVal.posNumVal!, retVal)
            }
            if _minVal != nil && _minVal.posNumVal != nil
            {
                retVal = Swift.max(_minVal.posNumVal!, retVal)
            }
            return retVal
        }
        else
        {
            return 0
        }
    }
    
        
    internal func realMarginInSize(_ contentSize:CGFloat) -> CGFloat
    {
    
        var retVal:CGFloat = 0
        if _active
        {
            if self.posWeightVal != nil
            {
                retVal = self.posWeightVal.rawValue/100 * contentSize + self.offsetVal
            }
            else if self.posNumVal != nil
            {
                retVal = self.posNumVal + self.offsetVal
            }
            else
            {
                retVal = self.offsetVal
            }
            
            if _maxVal != nil && _maxVal.posNumVal != nil
            {
                retVal = Swift.min(_maxVal.posNumVal!, retVal)
            }
            
            if _minVal != nil && _minVal.posNumVal != nil
            {
                retVal = Swift.max(_minVal.posNumVal!, retVal)
            }
        }
        return retVal
        
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

}

extension TGLayoutPos:NSCopying
{
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let ls:TGLayoutPos = type(of: self).init(self._type)
        ls._view = self._view
        ls._active = self._active
        ls._posVal = self._posVal
        ls._offsetVal = self._offsetVal
        ls._minVal._posVal = self._minVal._posVal
        ls._minVal._offsetVal = self._minVal._offsetVal
        ls._minVal._active = self._active
        ls._maxVal._posVal = self._maxVal._posVal
        ls._maxVal._offsetVal = self._maxVal._offsetVal
        ls._maxVal._active = self._active
        
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

//TGLayoutPos的min方法的快捷方法。比如a.tg_left.min(10) <==> a.tg_left >= 10
func >=(oprPos:TGLayoutPos, size:CGFloat)
{
    oprPos.min(size)
}

//TGLayoutPos的max方法的快捷方法。比如a.tg_left.max(10) <==> a.tg_left <= 10
func <=(oprPos:TGLayoutPos, size:CGFloat)
{
    oprPos.max(size)
}









