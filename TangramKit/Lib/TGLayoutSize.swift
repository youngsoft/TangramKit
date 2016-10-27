//
//  TGLayoutSize.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 *视图的布局尺寸类，用来设置视图在布局视图中的宽度和高度的布局尺寸值。
 */
final public class TGLayoutSize
{
    
    /**
     *特定的尺寸枚举值。
     */
    public enum Special
    {
        case wrap   //视图的尺寸由内容或者子视图包裹。
        case fill   //视图的尺寸和父视图保持一致或者填充父视图的剩余空间
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
    internal var _dimeVal:ValueType! = nil
    internal var _addVal:CGFloat = 0
    internal var _mutilVal:CGFloat = 1
    internal var _lBoundVal:TGLayoutSize!
    internal var _uBoundVal:TGLayoutSize!
    
    
    private init(type:TGGravity, hasBound:Bool)
    {
        _type = type
        if hasBound
        {
            _lBoundVal = TGLayoutSize(type:type, hasBound:false)
            _uBoundVal = TGLayoutSize(type:type, hasBound:false)
            
            _lBoundVal.equal(-CGFloat.greatestFiniteMagnitude)
            _uBoundVal.equal(CGFloat.greatestFiniteMagnitude)
        }
    }
    
    
    public convenience init(_ type:TGGravity) {
        
        self.init(type:type, hasBound:true)
    }
    
    //设置尺寸值为一个具体的数值。
    public func equal(_ size:CGFloat)
    {
        _addVal = 0
        _mutilVal = 1
        _dimeVal = .floatV(size)
        setNeedLayout()
    }
    
    //设置尺寸值为包裹或者填充这两个特殊的值，increment表示设置为特殊值的基础上的增量值， multiple则为特殊值基础上的乘量值
    public func equal(_ size:TGLayoutSize.Special, increment:CGFloat = 0, multiple:CGFloat = 1)
    {
        _addVal = increment
        _mutilVal = multiple
        if size == .wrap
        {
            _dimeVal = .wrapV
        }
        else if (size == .fill)
        {
            _dimeVal = .fillV
        }
        
        if let layoutview =  _view as? TGBaseLayout,size == .wrap
        {
            layoutview.setNeedsLayout()
        }
        else
        {
            setNeedLayout()
        }
    }
    
    //设置尺寸值为比重值或者相对值。比如某个子视图的宽度是父视图宽度的50%则可以设置为：a.tg_width.equal(50%) 或者a.tg_width.equal(TGWeight(50))
    public func equal(_ weight:TGWeight, increment:CGFloat = 0, multiple:CGFloat = 1)
    {
        _addVal = increment
        _mutilVal = multiple
        _dimeVal = .weightV(weight)
        setNeedLayout()
        
    }
    
    //设置尺寸值为数组类型，表示这个尺寸和数组中的尺寸对象按比例分配父布局的尺寸，这个设置只有当视图是TGRelativeLayout下的子视图才有意义。
    public func equal(_ array:[TGLayoutSize], increment:CGFloat = 0, multiple:CGFloat = 1)
    {
        _addVal = increment
        _mutilVal = multiple
        _dimeVal = .arrayV(array)
        setNeedLayout()
        
    }
    
    //设置尺寸值为TGLayoutSize，表示和另外一个对象的尺寸相等。如果设置为nil则表示清除尺寸值的设置。
    public func equal(_ dime:TGLayoutSize!, increment:CGFloat = 0, multiple:CGFloat = 1)
    {
        _addVal = increment
        _mutilVal = multiple
        
        if dime == nil
        {
            _dimeVal = nil
        }
        else if dime === self
        {
            assert(false, "not set to self")
        }
        else
        {
            _dimeVal = .dimeV(dime)
        }
        setNeedLayout()
    }
    
    //设置尺寸在equal设置的基础上添加的值，这个设置和equal方法中的increment的设定等价。
    public func add(_ val:CGFloat)
    {
        if _addVal != val
        {
            _addVal = val
            setNeedLayout()
        }
        
    }
    
    //设置尺寸在equal设置的基础上的乘量值，这个设置和equal方法中的multiple的设定等价。
    public func multiply(_ val:CGFloat)
    {
        if _mutilVal != val
        {
            _mutilVal = val
            setNeedLayout()
        }
    }
    
    //设置尺寸的最小边界值。
    public func lBound(_ size:CGFloat)
    {
        _lBoundVal.equal(size)
        _lBoundVal.add(0)
        _lBoundVal.multiply(1)
        setNeedLayout()
    }
    
    //设置尺寸的最小边界值。
    public func lBound(_ dime:TGLayoutSize, increment:CGFloat = 0, multiple:CGFloat = 1)
    {
        _lBoundVal.equal(dime)
        _lBoundVal.add(increment)
        _lBoundVal.multiply(multiple)
        setNeedLayout()
    }
    
    //设置尺寸的最大边界值。
    public func uBound(_ size:CGFloat)
    {
        _uBoundVal.equal(size)
        _uBoundVal.add(0)
        _uBoundVal.multiply(1)
        setNeedLayout()
    }
    
    //设置尺寸的最大边界值。
    public func uBound(_ dime:TGLayoutSize, increment:CGFloat = 0, multiple:CGFloat = 1)
    {
        _uBoundVal.equal(dime)
        _uBoundVal.add(increment)
        _uBoundVal.multiply(multiple)
        setNeedLayout()
    }
    
    //清除所有设置。
    public func clear()
    {
        _addVal = 0;
        _mutilVal = 1;
        _lBoundVal.equal(-CGFloat.greatestFiniteMagnitude)
        _uBoundVal.equal(CGFloat.greatestFiniteMagnitude)
        _dimeVal = nil
        setNeedLayout()
        
    }
    
    
    //判断尺寸是否被设置。
    public var hasValue:Bool
    {
        return _dimeVal != nil
    }
    
    //判断尺寸值是否被设置为包裹类型。
    public var isWrap:Bool
    {
        if (_dimeVal == nil)
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
        if (_dimeVal == nil)
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
        
        if (_dimeVal == nil)
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
        if (_dimeVal == nil)
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
        if (_dimeVal == nil)
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
        if (_dimeVal == nil)
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
        return _addVal
    }
    
    //获取尺寸的乘量值。
    public var mutilVal:CGFloat
    {
        return _mutilVal
    }
    
    //获取尺寸的下边界值。
    public var lBoundVal:TGLayoutSize
    {
        return _lBoundVal
    }
    
    //获取尺寸的上边界值。
    public var uBoundVal:TGLayoutSize
    {
        return _uBoundVal
    }
    
}

extension TGLayoutSize:NSCopying
{
    
    
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
        if (_view as? TGBaseLayout) == nil && !_view.tg_width.isWrap && self.isWrap
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
        
        return (self.dimeNumVal ?? 0) * _mutilVal + _addVal
    }
    
    internal func measure(_ size:CGFloat) -> CGFloat
    {
        return size * _mutilVal + _addVal
        
    }
    
    
    
    internal var isMatchParent:Bool{
        return (self.dimeRelaVal != nil && self.dimeRelaVal.view == _view.superview)
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
    
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let ls:TGLayoutSize = type(of: self).init(self._type)
        ls._view = self._view
        ls._dimeVal = self._dimeVal
        ls._addVal = self._addVal
        ls._mutilVal = self._mutilVal
        ls._lBoundVal._dimeVal = self._lBoundVal._dimeVal
        ls._lBoundVal._addVal = self._lBoundVal._addVal
        ls._lBoundVal._mutilVal = self._lBoundVal.mutilVal
        ls._uBoundVal._dimeVal = self._uBoundVal._dimeVal
        ls._uBoundVal._addVal = self._uBoundVal._addVal
        ls._uBoundVal._mutilVal = self._uBoundVal.mutilVal
        
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

public func ~=(oprSize:TGLayoutSize, size:TGLayoutSize.Special)
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

//TGLayoutSize的lBound的快捷方法。比如a.lBound(10)  <==> a >= 10
public func >=(oprSize:TGLayoutSize, size:CGFloat)
{
    oprSize.lBound(size)
}

public func >=(oprSize:TGLayoutSize, size:TGLayoutSize)
{
    oprSize.lBound(size)
}

//TGLayoutSize的uBound的快捷方法。比如 a.uBound(b)  <==> a <= b
public func <=(oprSize:TGLayoutSize, size:CGFloat)
{
    oprSize.uBound(size)
}

public func <=(oprSize:TGLayoutSize, size:TGLayoutSize)
{
    oprSize.uBound(size)
}
