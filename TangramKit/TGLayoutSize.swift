//
//  TGLayoutSize.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


protocol TGLayoutSizeValue
{    
    var hasValue:Bool {get}
    
    var isWrap:Bool {get}
    
    var isFill:Bool {get}
    
    var numberVal:CGFloat! {get}
    
    var sizeVal:TGLayoutSize! {get}
    
    var arrayVal:[TGLayoutSize]! {get}
    
    var weightVal:TGWeight! {get}
    
    var increment:CGFloat {get}
    
    var multiple:CGFloat {get}
    
    var minVal:TGLayoutSize? {get}
    
    var maxVal:TGLayoutSize? {get}
    
    var isFlexHeight:Bool {get}
    
    var measure:CGFloat {get}
    
    func measure(_ size:CGFloat) -> CGFloat
    
    func resetValue()
    
    func numberSize(_ size:CGFloat) ->CGFloat
    func fillSize(_ size:CGFloat, in containerSize:CGFloat) ->CGFloat
    func weightSize(_ size:CGFloat, in containerSize:CGFloat)->CGFloat

}


//定义TGLayoutSize对象可以设置的值类型。
public protocol TGLayoutSizeType
{
}

extension CGFloat:TGLayoutSizeType{}
extension Double:TGLayoutSizeType{}
extension Float:TGLayoutSizeType{}
extension Int:TGLayoutSizeType{}
extension Int8:TGLayoutSizeType{}
extension Int16:TGLayoutSizeType{}
extension Int32:TGLayoutSizeType{}
extension Int64:TGLayoutSizeType{}
extension UInt:TGLayoutSizeType{}
extension UInt8:TGLayoutSizeType{}
extension UInt16:TGLayoutSizeType{}
extension UInt32:TGLayoutSizeType{}
extension UInt64:TGLayoutSizeType{}
extension TGWeight:TGLayoutSizeType{}
extension Array:TGLayoutSizeType{}
extension TGLayoutSize:TGLayoutSizeType{}   //因为TGLayoutSize的equal方法本身就可以设置自身类型，所以这里也实现了这个协议
extension UIView:TGLayoutSizeType{}

/**
 *视图的布局尺寸类，用来设置视图在布局视图中宽度和高度的尺寸值。布局尺寸类是对尺寸的一个抽象，一个尺寸不一定描述为一个具体的数值，也有可能描述为和另外一个尺寸相等也就是依赖另外一个尺寸，同时一个尺寸可能也会有最大和最小值的限制等等。因此用TGLayoutSize类来描述这种尺寸的抽象概念。
 *一个尺寸对象的最终尺寸值 = min(max(sizeVal * multiple + increment, min.sizeVal * min.multiple + min.increment), max.sizeVal * max.multiple + max.increment)
 * 其中:
 sizeVal是通过equal方法设置的值。
 multiple是通过multiply方法或者equal方法中的multiple参数设置的值。
 increment是通过add方法或者equal方法中的increment参数设置的值。
 min.sizeVal,min.multiple,min.increment是通过min方法设置的值。他表示尺寸的最小边界值。
 max.sizeVal,max.multiple,max.increment是通过max方法设置的值。他表示尺寸的最大边界值。
 */
final public class TGLayoutSize:TGLayoutSizeValue
{
    
    //定义三个特殊类型的值。
    
    /// 视图的尺寸由内容或者子视图包裹。
    public static let wrap = TGLayoutSize(TGGravity.none, view: nil)
    /// 视图的尺寸填充父视图的剩余空间。
    public static let fill = TGLayoutSize(TGGravity.none, view: nil)
    /// 视图的尺寸会平分父视图的剩余空间。
    public static let average = TGLayoutSize(TGGravity.none, view:nil)
    
    //设置尺寸值为一个具体的数值。
    @discardableResult
    public func equal(_ size:Int, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return self.equal(CGFloat(size), increment: increment, multiple: multiple)
    }
    
    @discardableResult
    public func equal(_ size:CGFloat, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return equalHelper(val: size, increment: increment, multiple: multiple)
    }
    
    
    /**
     *设置尺寸值为比重值或者相对值。
      比如某个子视图的宽度是父视图宽度的50%则可以设置为：a.tg_width.equal(50%) 或者a.tg_width.equal(TGWeight(50))。
      具体这个相对或者比重值所表示的意义是根据视图在不同的父布局视图中的不同而不同的。
     */
    @discardableResult
    public func equal(_ weight:TGWeight, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return equalHelper(val: weight, increment: increment, multiple: multiple)
    }
    
    //设置尺寸值为数组类型，表示这个尺寸和数组中的尺寸对象按比例分配父布局的尺寸，这个设置只有当视图是TGRelativeLayout下的子视图才有意义。
    @discardableResult
    public func equal(_ array:[TGLayoutSize], increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return equalHelper(val: array, increment: increment, multiple: multiple)
    }
    
    //设置位置的值为视图的对应的尺寸，如果当前是tg_width则等价于 tg_width.equal(view.tg_width)
    @discardableResult
    public func equal(_ view:UIView,increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return equalHelper(val: view, increment: increment, multiple: multiple)
    }
    
    //设置尺寸值为TGLayoutSize，表示和另外一个对象的尺寸相等。如果设置为nil则表示清除尺寸值的设置。
    @discardableResult
    public func equal(_ dime:TGLayoutSize!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return equalHelper(val: dime, increment: increment, multiple: multiple)
    }
    
    //设置尺寸在equal设置的基础上添加的值，这个设置和equal方法中的increment的设定等价。
    @discardableResult
    public func add(_ val:CGFloat) ->TGLayoutSize
    {
        if _increment != val
        {
            _increment = val
            setNeedsLayout()
        }
        
        return self
    }
    
    //设置尺寸在equal设置的基础上的乘量值，这个设置和equal方法中的multiple的设定等价。
    @discardableResult
    public func multiply(_ val:CGFloat) ->TGLayoutSize
    {
        if _multiple != val
        {
            _multiple = val
            setNeedsLayout()
        }
        
        return self
    }
    
    /**
     * 设置尺寸的最小边界值，如果尺寸对象没有设置最小边界值，那么最小边界默认就是无穷小-CGFloat.greatestFiniteMagnitude。min方法除了能设置为数值外，还可以设置为TGLayoutSize值，并且还可以指定增量值和倍数值。
     @size:指定边界的值。可设置的类型有CGFloat和TGLayoutSize类型，前者表示最小限制不能小于某个常量值，而后者表示最小限制不能小于另外一个尺寸对象所表示的尺寸值。
     @increment: 指定边界值的增量值，如果没有增量请设置为0。
     @multiple: 指定边界值的倍数值，如果没有倍数请设置为1。
     
     *1.比如我们有一个UILabel的宽度是由内容决定的，但是最小的宽度大于等于父视图的宽度，则设置为：
     A.tg_width.equal(.wrap).min(superview.tg_width)
     *2.比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度大于等于父视图宽度的1/2，则设置为：
     A.tg_width.equal(.wrap).min(superview.tg_width, multiple:0.5)
     *3.比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度大于等于父视图的宽度-30，则设置为：
     A.tg_width.equal(.wrap).min(superview.tg_width, increment:-30)
     *4.比如我们有一个视图的宽度也是由内容决定的，但是最小的宽度不能低于100，则设置为：
     A.tg_width.equal(.wrap).min(100)
     */
    @discardableResult
    public func min(_ size:CGFloat, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        self.min.equal(size, increment:increment, multiple:multiple)
        setNeedsLayout()
        return self
    }
    
    //设置尺寸的最小边界值。
    @discardableResult
    public func min(_ dime:TGLayoutSize!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        var dime = dime
        if dime === self
        {
            dime = self.min
        }
        
        self.min.equal(dime,increment:increment, multiple:multiple)
        setNeedsLayout()
        
        return self
    }
    
    //设置尺寸的最小边界值为视图对应的尺寸
    @discardableResult
    public func min(_ view:UIView, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        self.min.equal(view,increment:increment, multiple:multiple)
        setNeedsLayout()
        
        return self
    }

    
    /**
     * 设置尺寸的最大边界值，如果尺寸对象没有设置最大边界值，那么最大边界默认就是无穷大CGFloat.greatestFiniteMagnitude。max方法除了能设置为数值外，还可以设置为TGLayoutSize值和nil值，并且还可以指定增量值和倍数值。
     @size:指定边界的值。可设置的类型有CGFloat和TGLayoutSize类型，前者表示最大限制不能超过某个常量值，而后者表示最大限制不能超过另外一个尺寸对象所表示的尺寸值。
     @increment: 指定边界值的增量值，如果没有增量请设置为0。
     @multiple: 指定边界值的倍数值，如果没有倍数请设置为1。
     
     *1.比如我们有一个UILabel的宽度是由内容决定的，但是最大的宽度小于等于父视图的宽度，则设置为：
     A.tg_width.equal(.wrap).max(superview.tg_width)
     *2.比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度小于等于父视图宽度的1/2，则设置为：
     A.tg_width.equal(.wrap).max(superview.tg_width, multiple:0.5)
     *3.比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度小于等于父视图的宽度-30，则设置为：
     A.tg_width.equal(.wrap).max(superview.tg_width, increment:-30)
     *4.比如我们有一个视图的宽度也是由内容决定的，但是最大的宽度小于等于100，则设置为：
     A.tg_width.equal(.wrap).max(100)
     */
    @discardableResult
    public func max(_ size:CGFloat, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        self.max.equal(size,increment:increment, multiple:multiple)
        setNeedsLayout()
        return self
    }
    
    //设置尺寸的最大边界值为视图对应的尺寸
    @discardableResult
    public func max(_ view:UIView, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        self.max.equal(view ,increment:increment, multiple:multiple)
        setNeedsLayout()
        
        return self
    }
    
    //设置尺寸的最大边界值。
    @discardableResult
    public func max(_ dime:TGLayoutSize!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        var dime = dime
        if dime === self
        {
            dime = self.max
        }

        self.max.equal(dime ,increment:increment, multiple:multiple)
        setNeedsLayout()
        
        return self
    }
    
    //返回视图，用于链式语法
    @discardableResult
    public func and() ->UIView
    {
        return _view
    }
    
    /**
     *清除所有设置的约束值，这样尺寸对象将不会再生效了。
     */
    public func clear()
    {
        _active = true
        _val = nil
        _increment = 0
        _multiple = 1
        _min = nil
        _max = nil
        setNeedsLayout()
        
    }
    
    
    /**
     *设置布局尺寸是否是活动的,默认是true表示活动的，如果设置为false则表示这个布局尺寸对象设置的约束值将不会起作用。
     *active设置为true和clear的相同点是尺寸对象设置的约束值都不会生效了，区别是前者不会清除所有设置的约束，而后者则会清除所有设置的约束。
     */
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
                if _min != nil
                {
                  _min._active = newValue
                }
                
                if _max != nil
                {
                  _max._active = newValue
                }
                setNeedsLayout()
            }
        }
        
    }
    
    //判断尺寸是否被设置。
    public var hasValue:Bool
    {
        return _active && _val != nil
    }
    
    //判断尺寸值是否被设置为包裹类型。
    public var isWrap:Bool
    {
        if (!_active || _val == nil)
        {
            return false
        }
        
        switch _val! {
        case ValueType.wrapV:
            return true
        default:
            return false
        }
    }
    
    //判断尺寸值是否被设置为填充类型。
    public var isFill:Bool
    {
        if (!_active || _val == nil)
        {
            return false
        }
        
        switch _val! {
        case ValueType.fillV:
            return true
        default:
            return false
        }
    }
    
    //获取数值类型的尺寸值。
    public var numberVal:CGFloat!
    {
        
        if (!_active || _val == nil)
        {
            return nil
        }
        
        
        switch _val! {
        case ValueType.floatV(let v):
            return v
        default:
            return nil
        }
    }
    
    //获取相对类型的尺寸值。
    public var sizeVal:TGLayoutSize!
    {
        if (!_active || _val == nil)
        {
            return nil
        }
        
        
        switch _val! {
        case ValueType.dimeV(let v):
            return v
        default:
            return nil
        }
        
        
        
    }
    
    //获取数组类型的尺寸值。
    public var arrayVal:[TGLayoutSize]!
    {
        if (!_active || _val == nil)
        {
            return nil
        }
        
        
        switch _val! {
        case ValueType.arrayV(let v):
            return v
        default:
            return nil
        }
    }
    
    //获取比重类型的尺寸值。
    public var weightVal:TGWeight!
    {
        if (!_active || _val == nil)
        {
            return nil
        }
        
        
        switch _val! {
        case ValueType.weightV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //获取尺寸的增量值。
    public var increment:CGFloat
    {
        if _active
        {
           return _increment
        }
        else
        {
            return 0
        }
    }
    
    //获取尺寸的乘量值。
    public var multiple:CGFloat
    {
        if _active
        {
           return _multiple
        }
        else
        {
            return 1
        }
    }
    
    //获取尺寸的下边界值。
    public var min:TGLayoutSize
    {
        if _min == nil
        {
            _min = TGLayoutSize(_type, view:nil).equal(-CGFloat.greatestFiniteMagnitude)
            _min._active = _active
        }
        return _min
    }
    
    //获取尺寸的上边界值。
    public var max:TGLayoutSize
    {
        if _max == nil
        {
            _max = TGLayoutSize(_type, view:nil).equal(CGFloat.greatestFiniteMagnitude)
            _max._active = _active
        }
        return _max
    }
    
    
    internal enum ValueType
    {
        case floatV(CGFloat)
        case dimeV(TGLayoutSize)
        case arrayV([TGLayoutSize])
        case weightV(TGWeight)
        case wrapV
        case fillV
    }
    
    fileprivate let _type:TGGravity
    fileprivate weak var _view:UIView!
    fileprivate var _active:Bool = true
    fileprivate var _val:ValueType! = nil
    fileprivate var _increment:CGFloat = 0
    fileprivate var _multiple:CGFloat = 1
    fileprivate var _min:TGLayoutSize! = nil
    fileprivate var _max:TGLayoutSize! = nil
    
    
    public init(_ type:TGGravity, view:UIView!)
    {
        _type = type
        _view = view
    }
    
}

extension TGLayoutSize
{
    @discardableResult
    internal func equalHelper(val:TGLayoutSizeType!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        _increment = increment
        _multiple = multiple
        
        if let v = val as? CGFloat
        {
            _val = ValueType.floatV(v)
        }
        else if let v = val as? Double
        {
            _val = ValueType.floatV(CGFloat(v))
        }
        else if let v = val as? Float
        {
            _val = ValueType.floatV(CGFloat(v))
        }
        else if let v = val as? Int
        {
            _val = ValueType.floatV(CGFloat(v))
        }
        else if let v = val as? TGWeight
        {
            _val = ValueType.weightV(v)
        }
        else if let v = val as? [TGLayoutSize]
        {
            _val = ValueType.arrayV(v)
        }
        else if let v = val as? UIView
        {
            if v === _view
            {
                assert(false, "oops! can't set self")
            }
            
            switch _type {
            case TGGravity.vert.fill:
                _val = ValueType.dimeV(v.tg_height)
                break
            case TGGravity.horz.fill:
                _val = ValueType.dimeV(v.tg_width)
                break
            default:
                assert(false, "oops!")
                break
            }
        }
        else if var v = val as? TGLayoutSize
        {
            if v === self
            {
                v = TGLayoutSize.wrap
            }
            
            if v === TGLayoutSize.wrap
            {
                _val = ValueType.wrapV
                
                if let labelView = _view as? UILabel, _type == TGGravity.vert.fill
                {
                    if labelView.numberOfLines == 1
                    {
                        labelView.numberOfLines = 0
                    }
                }
                
                if let layoutview = _view as? TGBaseLayout
                {
                    layoutview.setNeedsLayout()
                }
            }
            else if v === TGLayoutSize.fill
            {
                _val = ValueType.fillV
            }
            else if v === TGLayoutSize.average
            {
                _val = ValueType.weightV(TGWeight(100))
            }
            else
            {
                _val = ValueType.dimeV(v)
            }
        }
        else if val == nil
        {
            _val = nil
        }
        else
        {
            assert(false , "oops!")
        }
        
        setNeedsLayout()
        
        return self
    }
    
    internal var type:TGGravity
    {
        return _type
    }
    
    internal var view:UIView!
    {
        return _view
    }
    
    internal var isFlexHeight:Bool
    {
        if (_view as? TGBaseLayout) == nil && self.isWrap && _active
        {
            return true
        }
        else
        {
            return false
        }
    }

    internal var measure:CGFloat
    {
        if _active
        {
            var retVal = _increment
            if let t = self.numberVal
            {
                retVal += t * _multiple
            }
            return retVal
        }
        else
        {
           return 0
        }
    }
    
    internal func measure(_ size:CGFloat) -> CGFloat
    {
        if _active
        {
           return size * _multiple + _increment
        }
        else
        {
            return size
        }
    }
    
    
    func numberSize(_ size:CGFloat) ->CGFloat
    {
        guard let t = _val,_active else {
            return size
        }
        
        switch t {
        case ValueType.floatV(let v):
            return v * _multiple + _increment
        default:
            return size
        }
    }
    
    func fillSize(_ size:CGFloat, in containerSize:CGFloat) ->CGFloat
    {
        guard let t = _val,_active else {
            return size
        }
        
        switch t {
        case ValueType.fillV:
            return containerSize * _multiple + _increment
        default:
            return size
        }

    }
    
    func weightSize(_ size:CGFloat, in containerSize:CGFloat) ->CGFloat
    {
        guard let t = _val,_active else {
            return size
        }
        
        switch t {
        case ValueType.weightV(let v):
            return (containerSize * v.rawValue / 100) * _multiple + _increment
        default:
            return size
        }

    }
    
    
    internal func resetValue() {
        _val = nil
    }
    
    internal var minVal:TGLayoutSize?
    {
        return _min
    }
    
    internal var maxVal:TGLayoutSize?
    {
        return _max
    }
    
    
    fileprivate func setNeedsLayout()
    {
        if _view == nil
        {
            return
        }
        
        
        if let baseLayout:TGBaseLayout = _view.superview as? TGBaseLayout , !baseLayout.tg_isLayouting
        {
            baseLayout.setNeedsLayout()
        }
    }
}


extension TGLayoutSize:NSCopying
{
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let ls:TGLayoutSize = Swift.type(of: self).init(_type, view:_view)
        ls._active = self._active
        ls._val = self._val
        ls._increment = self._increment
        ls._multiple = self._multiple
        if _min != nil
        {
            ls._min = TGLayoutSize(_type, view:nil)
            ls._min._val = _min._val
            ls._min._increment = _min._increment
            ls._min._multiple = _min._multiple
            ls._min._active = _min._active
        }
        
        if _max != nil
        {
            ls._max = TGLayoutSize(_type, view:nil)
            ls._max._val = _max._val
            ls._max._increment = _max._increment
            ls._max._multiple = _max._multiple
            ls._max._active = _max._active
        }
                
        return ls
        
    }
    
}


//TGLayoutSize的equal的快捷方法。比如a.equal(10) <==>  a ~= 10
public func ~=(oprSize:TGLayoutSize, size:CGFloat)
{
    oprSize.equal(size)
}

public func ~=(oprSize:TGLayoutSize, weight:TGWeight)
{
    oprSize.equal(weight)
}

public func ~=(oprSize:TGLayoutSize, array:[TGLayoutSize])
{
    oprSize.equal(array)
}

public func ~=(oprSize:TGLayoutSize, size:TGLayoutSize!)
{
    oprSize.equal(size)
}


//TGLayoutSize的multiply的快捷方法。比如a.multiply(0.5) <=> a *= 0.5
public func *=(oprSize:TGLayoutSize, val:CGFloat)
{
    oprSize.multiply(val)
}

public func /=(oprSize:TGLayoutSize, val:CGFloat)
{
    oprSize.multiply(1/val)
}

//TGLayoutSize的add的快捷方法。比如a.add(10) <==>  a += 10
public func +=(oprSize:TGLayoutSize, val:CGFloat)
{
    oprSize.add(val)
}

public func -=(oprSize:TGLayoutSize, val:CGFloat)
{
    oprSize.add(-1 * val)
}

//TGLayoutSize的min的快捷方法。比如a.min(10)  <==> a >= 10
public func >=(oprSize:TGLayoutSize, size:CGFloat)
{
    oprSize.min(size)
}

public func >=(oprSize:TGLayoutSize, size:TGLayoutSize)
{
    oprSize.min(size)
}

//TGLayoutSize的max的快捷方法。比如 a.max(b)  <==> a <= b
public func <=(oprSize:TGLayoutSize, size:CGFloat)
{
    oprSize.max(size)
}

public func <=(oprSize:TGLayoutSize, size:TGLayoutSize)
{
    oprSize.max(size)
}

