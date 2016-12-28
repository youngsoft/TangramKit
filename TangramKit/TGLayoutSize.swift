//
//  TGLayoutSize.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


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
 *视图的布局尺寸类，用来设置视图在布局视图中的宽度和高度的布局尺寸值。
 */
final public class TGLayoutSize
{
    
    //定义三个特殊类型的值。
    public static let wrap = TGLayoutSize(type: .none, hasBound: false)  //视图的尺寸由内容或者子视图包裹。
    public static let fill = TGLayoutSize(type: .none, hasBound: false)  //视图的尺寸填充父视图的剩余空间。
    public static let average = TGLayoutSize(type: .none, hasBound: false) //视图的尺寸会平分父视图的剩余空间。
    
    //设置尺寸值为一个具体的数值。
    @discardableResult
    public func equal(_ size:Int, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return self.equal(CGFloat(size), increment: increment, multiple: multiple)
    }
    
    @discardableResult
    public func equal(_ size:CGFloat, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return tgEqual(val: size, increment: increment, multiple: multiple)
    }
    
    
    //设置尺寸值为比重值或者相对值。比如某个子视图的宽度是父视图宽度的50%则可以设置为：a.tg_width.equal(50%) 或者a.tg_width.equal(TGWeight(50))
    @discardableResult
    public func equal(_ weight:TGWeight, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return tgEqual(val: weight, increment: increment, multiple: multiple)
    }
    
    //设置尺寸值为数组类型，表示这个尺寸和数组中的尺寸对象按比例分配父布局的尺寸，这个设置只有当视图是TGRelativeLayout下的子视图才有意义。
    @discardableResult
    public func equal(_ array:[TGLayoutSize], increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return tgEqual(val: array, increment: increment, multiple: multiple)
    }
    
    //设置位置的值为视图的对应的尺寸，如果当前是tg_width则等价于 tg_width.equal(view.tg_width)
    @discardableResult
    public func equal(_ view:UIView,increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return tgEqual(val: view, increment: increment, multiple: multiple)
    }
    
    //设置尺寸值为TGLayoutSize，表示和另外一个对象的尺寸相等。如果设置为nil则表示清除尺寸值的设置。
    @discardableResult
    public func equal(_ dime:TGLayoutSize!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        return tgEqual(val: dime, increment: increment, multiple: multiple)
    }
    
    //设置尺寸在equal设置的基础上添加的值，这个设置和equal方法中的increment的设定等价。
    @discardableResult
    public func add(_ val:CGFloat) ->TGLayoutSize
    {
        if _addVal != val
        {
            _addVal = val
            setNeedLayout()
        }
        
        return self
    }
    
    //设置尺寸在equal设置的基础上的乘量值，这个设置和equal方法中的multiple的设定等价。
    @discardableResult
    public func multiply(_ val:CGFloat) ->TGLayoutSize
    {
        if _multiVal != val
        {
            _multiVal = val
            setNeedLayout()
        }
        
        return self
    }
    
    //设置尺寸的最小边界值。
    @discardableResult
    public func min(_ size:CGFloat, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        _minVal.equal(size, increment:increment, multiple:multiple)
        setNeedLayout()
        return self
    }
    
    //设置尺寸的最小边界值。
    @discardableResult
    public func min(_ dime:TGLayoutSize!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        var dime = dime
        if dime === self
        {
            dime = _minVal
        }
        _minVal.equal(dime,increment:increment, multiple:multiple)
        setNeedLayout()
        
        return self
    }
    
    //设置尺寸的最小边界值为视图对应的尺寸
    @discardableResult
    public func min(_ view:UIView, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        _minVal.equal(view,increment:increment, multiple:multiple)
        setNeedLayout()
        
        return self
    }

    
    //设置尺寸的最大边界值。
    @discardableResult
    public func max(_ size:CGFloat, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        _maxVal.equal(size,increment:increment, multiple:multiple)
        setNeedLayout()
        return self
    }
    
    //设置尺寸的最大边界值为视图对应的尺寸
    @discardableResult
    public func max(_ view:UIView, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        _maxVal.equal(view ,increment:increment, multiple:multiple)
        setNeedLayout()
        
        return self
    }
    
    //设置尺寸的最大边界值。
    @discardableResult
    public func max(_ dime:TGLayoutSize!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        var dime = dime
        if dime === self
        {
            dime = _maxVal
        }

        _maxVal.equal(dime ,increment:increment, multiple:multiple)
        setNeedLayout()
        
        return self
    }
    
    //返回视图，用于链式语法
    @discardableResult
    public func and() ->UIView
    {
        return _view
    }
    
    //清除所有设置。
    public func clear()
    {
        _active = true
        _addVal = 0;
        _multiVal = 1;
        _minVal.equal(-CGFloat.greatestFiniteMagnitude)
        _maxVal.equal(CGFloat.greatestFiniteMagnitude)
        _minVal._active = true
        _maxVal._active = true
        _dimeVal = nil
        setNeedLayout()
        
    }
    
    
    //设置布局尺寸是否是活动的,默认是true表示活动的，如果设置为false则表示这个布局尺寸设置的约束将不会起作用。
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
    
    //判断尺寸是否被设置。
    public var hasValue:Bool
    {
        return _active && _dimeVal != nil
    }
    
    //判断尺寸值是否被设置为包裹类型。
    public var isWrap:Bool
    {
        if (!_active || _dimeVal == nil)
        {
            return false
        }
        
        switch _dimeVal! {
        case .wrapV:
            return true
        default:
            return false
        }
    }
    
    //判断尺寸值是否被设置为填充类型。
    public var isFill:Bool
    {
        if (!_active || _dimeVal == nil)
        {
            return false
        }
        
        switch _dimeVal! {
        case .fillV:
            return true
        default:
            return false
        }
    }
    
    //获取数值类型的尺寸值。
    public var dimeNumVal:CGFloat!
    {
        
        if (!_active || _dimeVal == nil)
        {
            return nil
        }
        
        
        switch _dimeVal! {
        case .floatV(let v):
            return v
        default:
            return nil
        }
    }
    
    //获取相对类型的尺寸值。
    public var dimeRelaVal:TGLayoutSize!
    {
        if (!_active || _dimeVal == nil)
        {
            return nil
        }
        
        
        switch _dimeVal! {
        case .dimeV(let v):
            return v
        default:
            return nil
        }
        
        
        
    }
    
    //获取数组类型的尺寸值。
    public var dimeArrVal:[TGLayoutSize]!
    {
        if (!_active || _dimeVal == nil)
        {
            return nil
        }
        
        
        switch _dimeVal! {
        case .arrayV(let v):
            return v
        default:
            return nil
        }
    }
    
    //获取比重类型的尺寸值。
    public var dimeWeightVal:TGWeight!
    {
        if (!_active || _dimeVal == nil)
        {
            return nil
        }
        
        
        switch _dimeVal! {
        case .weightV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //获取尺寸的增量值。
    public var addVal:CGFloat
    {
        if _active
        {
           return _addVal
        }
        else
        {
            return 0
        }
    }
    
    //获取尺寸的乘量值。
    public var multiVal:CGFloat
    {
        if _active
        {
           return _multiVal
        }
        else
        {
            return 1
        }
    }
    
    //获取尺寸的下边界值。
    public var minVal:TGLayoutSize
    {
        return _minVal
    }
    
    //获取尺寸的上边界值。
    public var maxVal:TGLayoutSize
    {
        return _maxVal
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
    
    internal let _type:TGGravity
    internal weak var _view:UIView!
    internal var _active:Bool = true
    internal var _dimeVal:ValueType! = nil
    internal var _addVal:CGFloat = 0
    internal var _multiVal:CGFloat = 1
    internal var _minVal:TGLayoutSize!
    internal var _maxVal:TGLayoutSize!
    
    
    private init(type:TGGravity, hasBound:Bool)
    {
        _type = type
        if hasBound
        {
            _minVal = TGLayoutSize(type:type, hasBound:false)
            _maxVal = TGLayoutSize(type:type, hasBound:false)
            
            _minVal.equal(-CGFloat.greatestFiniteMagnitude)
            _maxVal.equal(CGFloat.greatestFiniteMagnitude)
        }
    }
    
    
    public convenience init(_ type:TGGravity) {
        
        self.init(type:type, hasBound:true)
    }
    
}

extension TGLayoutSize
{
    @discardableResult
    internal func tgEqual(val:TGLayoutSizeType!, increment:CGFloat = 0, multiple:CGFloat = 1) ->TGLayoutSize
    {
        _addVal = increment
        _multiVal = multiple
        
        if let v = val as? CGFloat
        {
            _dimeVal = .floatV(v)
        }
        else if let v = val as? Double
        {
            _dimeVal = .floatV(CGFloat(v))
        }
        else if let v = val as? Float
        {
            _dimeVal = .floatV(CGFloat(v))
        }
        else if let v = val as? Int
        {
            _dimeVal = .floatV(CGFloat(v))
        }
        else if let v = val as? TGWeight
        {
            _dimeVal = .weightV(v)
        }
        else if let v = val as? [TGLayoutSize]
        {
            _dimeVal = .arrayV(v)
        }
        else if let v = val as? UIView
        {
            if v === _view
            {
                assert(false, "oops! can't set self")
            }
            
            switch _type {
            case TGGravity.vert.fill:
                _dimeVal = .dimeV(v.tg_height)
                break
            case TGGravity.horz.fill:
                _dimeVal = .dimeV(v.tg_width)
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
                _dimeVal = .wrapV
                
                if let layoutview = _view as? TGBaseLayout
                {
                    layoutview.setNeedsLayout()
                }
            }
            else if v === TGLayoutSize.fill
            {
                _dimeVal = .fillV
            }
            else if v === TGLayoutSize.average
            {
                _dimeVal = .weightV(TGWeight(100))
            }
            else
            {
                _dimeVal = .dimeV(v)
            }
        }
        else if val == nil
        {
            _dimeVal = nil
        }
        else
        {
            assert(false , "oops!")
        }
        
        setNeedLayout()
        
        return self
    }
    
    internal func belong(to view: UIView) ->TGLayoutSize
    {
        _view = view
        
        return self
    }
    
    internal var view:UIView!
    {
        return _view
    }
    
    internal var isFlexHeight:Bool
    {
        if (_view as? TGBaseLayout) == nil && /*!_view.tg_width.isWrap &&*/ self.isWrap && _active
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
           return (self.dimeNumVal ?? 0) * _multiVal + _addVal
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
           return size * _multiVal + _addVal
        }
        else
        {
            return size
        }
        
    }
    
    
    
    internal var isMatchParent:Bool{
        return _active && (self.dimeRelaVal != nil && self.dimeRelaVal.view == _view.superview)
    }
    
    fileprivate func setNeedLayout()
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
        let ls:TGLayoutSize = type(of: self).init(self._type)
        ls._view = self._view
        ls._active = self._active
        ls._dimeVal = self._dimeVal
        ls._addVal = self._addVal
        ls._multiVal = self._multiVal
        ls._minVal._dimeVal = self._minVal._dimeVal
        ls._minVal._addVal = self._minVal._addVal
        ls._minVal._multiVal = self._minVal.multiVal
        ls._minVal._active = self._active
        ls._maxVal._dimeVal = self._maxVal._dimeVal
        ls._maxVal._addVal = self._maxVal._addVal
        ls._maxVal._multiVal = self._maxVal.multiVal
        ls._maxVal._active = self._active
        
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

