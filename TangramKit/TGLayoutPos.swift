//
//  TGLayoutPos.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


protocol TGLayoutPosValue
{    
    var hasValue:Bool {get}
    
    var numberVal:CGFloat! {get}
    
    var weightVal:TGWeight! {get}
    
    var posVal:TGLayoutPos! {get}
    
    var arrayVal:[TGLayoutPos]! {get}
    
    var offset:CGFloat {get}
    
    var minVal:TGLayoutPos? {get}
    
    var maxVal:TGLayoutPos? {get}
    
    var absPos:CGFloat {get}
    
    var isSafeAreaPos:Bool{get}
    
    func weightPosIn(_ contentSize:CGFloat) -> CGFloat
    
    

}


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



/**
 视图的布局位置类是用来描述视图与其他视图之间的位置关系的类。视图在进行定位时需要明确的指出其在父视图坐标轴上的水平位置(x轴上的位置）和垂直位置(y轴上的位置）。
 视图的水平位置可以用左、水平中、右三个方位的值来描述，垂直位置则可以用上、垂直中、下三个方位的值来描述。
 也就是说一个视图的位置需要用水平的某个方位的值以及垂直的某个方位的值来确定。一个位置的值可以是一个具体的数值，也可以依赖于另外一个视图的位置来确定。
 
 一个布局位置对象的最终位置值 = min(max(posVal + offsetVal, min.posVal+min.offset), max.posVal+max.offset)
 其中:
 posVal是通过equal方法设置。
 offsetVal是通过offset方法或者通过equal方法中的offset参数设置。
 min.posVal,min.offset是通过min方法设置。
 max.posVal,max.offset是通过max方法设置。
 */
final public class TGLayoutPos:TGLayoutPosValue
{
    
    /**
     特殊的位置。只用在布局视图和非布局父视图之间的位置约束和没有导航条时的布局视图内子视图的padding设置上。
     iOS11以后提出了安全区域的概念，因此对于iOS11以下的版本就需要兼容处理，尤其是在那些没有导航条的情况下。通过将布局视图的边距设置为这个特殊值就可以实现在任何版本中都能完美的实现位置的偏移而且各版本保持统一。比如下面的例子：
     
     @code
     
     //这里设置布局视图的左边和右边以及顶部的边距都是在父视图的安全区域外再缩进10个点的位置。你会注意到这里面定义了一个特殊的位置TGLayoutPos.tg_safeAreaMargin。
     //TGLayoutPos.tg_safeAreaMargin表示视图的边距不是一个固定的值而是所在的父视图的安全区域。这样布局视图就不会延伸到安全区域以外去了。
     //TGLayoutPos.tg_safeAreaMargin是同时支持iOS11和以下的版本的，对于iOS11以下的版本则顶部安全区域是状态栏以下的位置。
     //因此只要你设置边距为TGLayoutPos.tg_safeAreaMargin则可以同时兼容所有iOS的版本。。
     layoutView.tg_leading.equal(TGLayoutPos.tg_safeAreaMargin, offset:10)
     layoutView.tg_trailing.equal(TGLayoutPos.tg_safeAreaMargin,offset:10)
     layoutView.tg_top.equal(TGLayoutPos.tg_safeAreaMargin,offset:10)
     
     //如果你的左右边距都是安全区域，那么可以用下面的方法来简化设置。您可以注释掉这下面两句看看效果。
     //layoutView.tg_leading.equal(TGLayoutPos.tg_safeAreaMargin)
     //layoutView.tg_trailing.equal(TGLayoutPos.tg_safeAreaMargin)
     @endcode
     
     @code
     
     //在一个没有导航条的界面中，因为iPhoneX和其他设备的状态栏的高度不一致。所以你可以让布局视图的topPadding设置如下：
     layoutView.tg_topPadding = TGLayoutPos.tg_safeAreaMargin + 10  //顶部内边距是安全区域外加10。那么这个和设置如下的：
     layoutView.tg_topPadding = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 10;
     
     //这两者之间的区别后者是一个设置好的常数，一旦你的设备要支持横竖屏则不管横屏下是否有状态栏都会缩进固定的内边距，而前者则会根据当前是否状态栏而进行动态调整。
     //当然如果你的顶部就是要固定缩进状态栏的高度的话那么你可以直接直接用后者。
     
     
     @endcode
     
     @note
     需要注意的是这个值并不是一个真值，只是一个特殊值，不能用于读取。而且只能用于在TGLayoutPos的equal方法和布局视图上的tg_padding属性上使用，其他地方使用后果未可知。
     
     */
    public static var tg_safeAreaMargin:CGFloat
    {
        //在2017年10月3号定义的一个数字，没有其他特殊意义。
        return -20171003.0;
    }

    //设置位置的值为数值类型，offset是在设置值的基础上的偏移量。
    @discardableResult
    public func equal(_ origin:Int, offset:CGFloat = 0) ->TGLayoutPos
    {        
        
        return self.equal(CGFloat(origin), offset:offset)
    }
    
    @discardableResult
    public func equal(_ origin:CGFloat, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.equalHelper(val: origin, offset: offset)
    }
    
    //设置位置的值为比重或者相对数值，具体这个相对或者比重值所表示的意义是根据视图在不同的父布局视图中的不同而不同的。
    @discardableResult
    public func equal(_ weight:TGWeight, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.equalHelper(val: weight, offset: offset)
    }
    
    //设置位置的值为数组对象。表示这个位置和数组中的位置整体居中，这个方法只有对视图的扩展属性tg_centerX,tg_centerY并且父布局是相对布局时才有意义。
    @discardableResult
    public func equal(_ array:[TGLayoutPos], offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.equalHelper(val: array, offset: offset)
    }
    
    //设置位置的值为视图的对应的位置，如果当前是tg_left则等价于 tg_left.equal(view.tg_left)
    @discardableResult
    public func equal(_ view: UIView, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.equalHelper(val: view, offset: offset)
    }
    
    //设置位置的值为位置对象，表示相对于其他位置。如果设置为nil则表示清除位置的值的设定。
    @discardableResult
    public func equal(_ pos:TGLayoutPos!, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.equalHelper(val: pos, offset: offset)
    }
    
    @discardableResult
    public func equal(_ pos:UILayoutSupport, offset:CGFloat = 0) ->TGLayoutPos
    {
        return self.equalHelper(val: pos, offset: offset)
    }
    
    /**
     *设置布局位置值的偏移量，和equal中的offset等价。 所谓偏移量是指布局位置在设置了某种值后增加或减少的偏移值。
     *这里偏移值的正负值所表示的意义是根据位置的不同而不同的：
     1.如果是tg_left和tg_centerX那么正数表示往右偏移，负数表示往左偏移。
     2.如果是tg_top和tg_centerY那么正数表示往下偏移，负数表示往上偏移。
     3.如果是tg_right那么正数表示往左偏移，负数表示往右偏移。
     4.如果是tg_bottom那么正数表示往上偏移，负数表示往下偏移。
     
     示例代码：
     1.比如：A.tg_left.equal(10).offset(5)表示A视图的左边边距等于10再往右偏移5,也就是最终的左边边距是15。
     2.比如：A.tg_right.equal(B.rightPos).offset(5)表示A视图的右边位置等于B视图的右边位置再往左偏移5。
     */
    @discardableResult
    public func offset(_ val:CGFloat) ->TGLayoutPos
    {
        if _offset != val
        {
            _offset = val
            setNeedsLayout()
        }
        
        return self
    }
    
    /**
     *设置布局位置的最小边界值。 如果位置对象没有设置最小边界值，那么最小边界默认就是无穷小-CGFloat.greatestFiniteMagnitude。min方法除了能设置为CGFloat外，还可以设置为TGLayoutPos值，并且还可以指定最小位置的偏移量值。只有在相对布局中的子视图的位置对象才能设置最小边界值为TGLayoutPos类型的值，其他类型布局中的子视图只支持CGFloat类型的最小边界值。
     @val指定位置边界值。可设置的类型有CGFloat和TGLayoutPos类型，前者表示最小位置不能小于某个常量值，而后者表示最小位置不能小于另外一个位置对象所表示的位置值。
     @offset指定位置边界值的偏移量。
     
     1.比如某个视图A的左边位置最小不能小于30则设置为：
     A.tg_left.min(30); 或者A.tg_left.min(20, offset:10)
     2.对于相对布局中的子视图来说可以通过min值来实现那些尺寸不确定但是最小边界不能低于某个关联的视图的位置的场景，比如说视图B的位置和宽度固定，而A视图的右边位置固定，但是A视图的宽度不确定，且A的最左边不能小于B视图的右边边界加20，那么A就可以设置为：
     A.tg_left.min(B.tg_right, offset:20) //这时A是不必要指定明确的宽度的。
     
     */
    @discardableResult
    public func min(_ val:CGFloat, offset:CGFloat = 0) ->TGLayoutPos
    {
        self.min.equal(val, offset:offset)
        setNeedsLayout()
        return self
    }
    
    @discardableResult
    public func min(_ val:TGLayoutPos!, offset:CGFloat = 0) ->TGLayoutPos
    {
        self.min.equal(val, offset:offset)
        setNeedsLayout()
        return self
    }
    
    /**
     *设置布局位置的最大边界值。 如果位置对象没有设置最大边界值，那么最大边界默认就是无穷大CGFloat.greatestFiniteMagnitude。max方法除了能设置为CGFloat外，还可以设置为TGLayoutPos值，并且还可以指定最大位置的偏移量值。只有在相对布局中的子视图的位置对象才能设置最大边界值为TGLayoutPos类型的值，其他类型布局中的子视图只支持CGFloat类型的最大边界值。
     @val指定位置边界值。可设置的类型有CGFloat和TGLayoutPos类型，前者表示最大位置不能大于某个常量值，而后者表示最大位置不能大于另外一个位置对象所表示的位置值。
     @offset指定位置边界值的偏移量。
     
     1.比如某个视图A的左边位置最大不能超过30则设置为：
     A.tg_left.max(30); 或者A.tg_left.max(30,offset:10)
     2.对于相对布局中的子视图来说可以通过max值来实现那些尺寸不确定但是最大边界不能超过某个关联的视图的位置的场景，比如说视图B的位置和宽度固定，而A视图的左边位置固定，但是A视图的宽度不确定，且A的最右边不能超过B视图的左边边界减20，那么A就可以设置为：
     A.tg_left.max(B.tg_left,offset: -20) //这时A是不必要指定明确的宽度的。
     3.对于相对布局中的子视图来说可以同时通过min,max方法的设置来实现某个子视图总是在对应的两个其他的子视图中央显示且尺寸不能超过其他两个子视图边界的场景。比如说视图B要放置在A和C之间水平居中显示且不能超过A和C的边界。那么就可以设置为：
     B.tg_left.min(A.tg_right); B.tg_right.max(C.tg_left) //这时B不用指定宽度，而且总是在A和C的水平中间显示。
     
     */
    @discardableResult
    public func max(_ val:CGFloat, offset:CGFloat = 0) ->TGLayoutPos
    {
        self.max.equal(val, offset:offset)
        setNeedsLayout()
        
        return self
    }
    
    @discardableResult
    public func max(_ val:TGLayoutPos!, offset:CGFloat = 0) ->TGLayoutPos
    {
        self.max.equal(val, offset:offset)
        setNeedsLayout()
        
        return self
    }

    
    //返回视图，用于链式语法
    @discardableResult
    public func and() -> UIView
    {
        return _view
    }
    
    /**
     *清除所有设置的约束值，这样位置对象将不会再生效了。
     */
    public func clear()
    {
        _active = true
        _val = nil
        _offset = 0
        _min = nil
        _max = nil
        setNeedsLayout()
    }
    
    /**
     *设置布局位置是否是活动的,默认是true表示活动的，如果设置为false则表示这个布局位置对象设置的约束值将不会起作用。
     *active设置为true和clear的相同点是位置对象设置的约束值都不会生效了，区别是前者不会清除所有设置的约束，而后者则会清除所有设置的约束。
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
    
    //判断是否设置了位置值。
    public var hasValue:Bool
    {
        
        return _active &&  _val != nil
    }
    
    //返回设置的数值类型的值。
    public var numberVal:CGFloat!
    {
        
        if (!_active || _val == nil)
        {
            return nil
        }
        
        switch _val! {
        case ValueType.floatV(let v):
            return v
        case ValueType.layoutSupport(let v):
            //只有在11以后并且是设置了safearea缩进才忽略UILayoutSupport。
            if let superlayout = self.view.superview as? TGBaseLayout, #available(iOS 11.0, *)
            {
                let edge = superlayout.tg_insetsPaddingFromSafeArea.rawValue
                if ((_type == TGGravity.vert.top && (edge & UIRectEdge.top.rawValue) == UIRectEdge.top.rawValue) ||
                    (_type == TGGravity.vert.bottom && (edge & UIRectEdge.bottom.rawValue) == UIRectEdge.bottom.rawValue))
                {
                    return 0
                }
            }
            return v.length
        case ValueType.safePosV(_):
            if #available(iOS 11.0, *)
            {
                if let superView = _view.superview
                {
                    switch (_type) {
                    case TGGravity.horz.leading:
                        return  TGBaseLayout.tg_isRTL ? superView.safeAreaInsets.right : superView.safeAreaInsets.left
                    case TGGravity.horz.trailing:
                        return  TGBaseLayout.tg_isRTL ? superView.safeAreaInsets.left : superView.safeAreaInsets.right
                    case TGGravity.vert.top:
                        return superView.safeAreaInsets.top
                    case TGGravity.vert.bottom:
                        return superView.safeAreaInsets.bottom
                    default:
                        return 0.0
                    }
                }
            }
            else
            {
                if let vc = self.findContainerVC()
                {
                    if _type == TGGravity.vert.top
                    {
                        return vc.topLayoutGuide.length
                    }
                    else if _type == TGGravity.vert.bottom
                    {
                        return vc.bottomLayoutGuide.length
                    }
                }
            }
            
            return 0
            
        default:
            return nil
        }
        
    }
    
    //返回设定的比重类型的值。
    public var weightVal:TGWeight!
    {
        
        if (!_active || _val == nil){
            return nil
        }
        
        switch _val! {
        case ValueType.weightV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //返回设定的相对位置的值。
    public var posVal:TGLayoutPos!
    {
        
        if (!_active || _val == nil){
            return nil
        }
        
        switch _val! {
        case ValueType.posV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //返回设定的数值类型的值。
    public var arrayVal:[TGLayoutPos]!
    {
        
        if (!_active ||  _val == nil){
            return nil
        }
        
        switch _val! {
        case ValueType.arrayV(let v):
            return v
        default:
            return nil
        }
        
    }
    
    //返回偏移量值。
    public var offset:CGFloat
    {
        if _active
        {
            return _offset
        }
        else
        {
            return 0
        }
    }
    
    //返回设置的下边界值。
    public var min:TGLayoutPos
    {
        if _min == nil
        {
            _min = TGLayoutPos(_type, view: nil).equal(-CGFloat.greatestFiniteMagnitude)
            _min._active = _active
        }
        return _min
    }
    
    //返回设置的上边界值。
    public var max:TGLayoutPos
    {
        if _max === nil
        {
            _max = TGLayoutPos(_type, view:nil).equal(CGFloat.greatestFiniteMagnitude)
            _max._active = _active
        }
        
        return _max
    }
    
    
    internal enum ValueType
    {
        case floatV(CGFloat)
        case posV(TGLayoutPos)
        case arrayV([TGLayoutPos])
        case weightV(TGWeight)
        case safePosV(CGFloat)
        case layoutSupport(UILayoutSupport)
    }
    
    fileprivate weak var _view:UIView! = nil
    fileprivate let _type:TGGravity
    fileprivate var _active:Bool = true
    fileprivate var _val:ValueType!
    fileprivate var _offset:CGFloat = 0
    fileprivate var _min:TGLayoutPos! = nil
    fileprivate var _max:TGLayoutPos! = nil
    
    public init(_ type:TGGravity, view: UIView!)
    {
        _type = type
        _view = view
    }

}

extension TGLayoutPos
{
    @discardableResult
    internal func equalHelper(val:TGLayoutPosType!, offset:CGFloat = 0)  ->TGLayoutPos
    {
        _offset = offset
        
        if let v = val as? CGFloat
        {
            if v == TGLayoutPos.tg_safeAreaMargin
            {
                _val = ValueType.safePosV(v)
            }
            else
            {
                _val = ValueType.floatV(v)
            }
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
        else if let v = val as? [TGLayoutPos]
        {
            if _type != TGGravity.vert.center && _type != TGGravity.horz.center
            {
                assert(false, "oops! ");
            }
            
            _val = ValueType.arrayV(v)
        }
        else if let v = val as? UIView
        {
            if v === _view
            {
                assert(false , "oops!");
            }
            
            switch _type {
            case TGGravity.vert.top:
                _val = ValueType.posV(v.tg_top)
                break
            case TGGravity.vert.center:
                _val = ValueType.posV(v.tg_centerY)
                break
            case TGGravity.vert.bottom:
                _val = ValueType.posV(v.tg_bottom)
                break
            case TGGravity.horz.leading:
                _val = ValueType.posV(v.tg_leading)
                break
            case TGGravity.horz.center:
                _val = ValueType.posV(v.tg_centerX)
                break
            case TGGravity.horz.trailing:
                _val = ValueType.posV(v.tg_trailing)
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
            
            _val = ValueType.posV(v)
            
        }
        else if val == nil
        {
             _val = nil
        }
        else
        {
            assert(false , "oops");
        }
        
        
        setNeedsLayout()
        
        return self
    }
    
    @discardableResult
    internal func equalHelper(val:UILayoutSupport, offset:CGFloat = 0)  ->TGLayoutPos
    {
        
        if (_type != TGGravity.vert.top && _type != TGGravity.vert.bottom)
        {
            assert(false, "oops! only topPos or bottomPos can set to UILayoutSupport")
        }

        _offset = offset
        _val = ValueType.layoutSupport(val)
        
        setNeedsLayout()

        return self
    }

    internal var type:TGGravity
    {
        return _type
    }

    internal var view:UIView
    {
        return _view
    }

    
    internal var minVal:TGLayoutPos?
    {
        return _min
    }

    internal var maxVal:TGLayoutPos?
    {
        return _max
    }


    internal var absPos:CGFloat
    {
        if _active
        {
            var retVal = _offset
            if self.numberVal != nil
            {
                retVal += self.numberVal
            }
            
            if _max != nil && _max.numberVal != nil
            {
                retVal = Swift.min(_max.numberVal!, retVal)
            }
            if _min != nil && _min.numberVal != nil
            {
                retVal = Swift.max(_min.numberVal!, retVal)
            }
            return retVal
        }
        else
        {
            return 0
        }
    }
    
    internal var isSafeAreaPos:Bool
    {
        
        guard _active && _val != nil else {
            
            return false
        }
        
        switch _val! {
        case ValueType.safePosV(_):
            return true
        case ValueType.layoutSupport(_):
            return true
        default:
            return false
        }
    }
    
        
    internal func weightPosIn(_ contentSize:CGFloat) -> CGFloat
    {
    
        var retVal:CGFloat = 0
        if _active
        {
            if let t = self.weightVal
            {
                retVal = t.rawValue/100 * contentSize + self.offset
            }
            else if let t = self.numberVal
            {
                retVal = t + self.offset
            }
            else
            {
                retVal = self.offset
            }
            
            if let t = _max?.numberVal
            {
                retVal = Swift.min(t, retVal)
            }
            
            if let t = _min?.numberVal
            {
                retVal = Swift.max(t, retVal)
            }
        }
        return retVal
        
    }
    

 
    internal func setNeedsLayout()
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
    
    internal func findContainerVC() -> UIViewController!
    {
        var vc:UIViewController! = nil;
        var v:UIView! = self.view;
        while v != nil
        {
            vc = v.value(forKey: "viewDelegate") as? UIViewController
            if (vc != nil)
            {
                break
            }
            
            v = v.superview
        }
        return vc
    }

}

extension TGLayoutPos:NSCopying
{
    public func copy(with zone: NSZone? = nil) -> Any
    {
        let ls:TGLayoutPos = Swift.type(of: self).init(_type, view:_view)
        ls._active = self._active
        ls._val = self._val
        ls._offset = self._offset
        if _min != nil
        {
            ls._min = TGLayoutPos(_type, view:nil)
            ls._min._val = _min._val
            ls._min._offset = _min._offset
            ls._min._active = _min._active
        }
        
        if _max != nil
        {
            ls._max = TGLayoutPos(_type, view:nil)
            ls._max._val = _max._val
            ls._max._offset = _max._offset
            ls._max._active = _max._active
        }

        return ls
        
    }
}


//TGLayoutPos的equal方法的快捷方法。比如a.tg_left.equal(10) <==> a.tg_left ~= 10
public func ~=(oprPos:TGLayoutPos, origin:CGFloat)
{
    oprPos.equal(origin)
}

public func ~=(oprPos:TGLayoutPos, weight:TGWeight)
{
    oprPos.equal(weight)
}

public func ~=(oprPos:TGLayoutPos, array:[TGLayoutPos])
{
    oprPos.equal(array)
}

public func ~=(oprPos:TGLayoutPos, pos:TGLayoutPos!)
{
    oprPos.equal(pos)
}

//TGLayoutPos的offset方法的快捷方法。比如a.tg_left.offset(10) <==> a.tg_left += 10
public func +=(oprPos:TGLayoutPos, val:CGFloat)
{
    oprPos.offset(val)
}

public func -=(oprPos:TGLayoutPos, val:CGFloat)
{
    oprPos.offset(-1 * val)
}

//TGLayoutPos的min方法的快捷方法。比如a.tg_left.min(10) <==> a.tg_left >= 10
public func >=(oprPos:TGLayoutPos, size:CGFloat)
{
    oprPos.min(size)
}

//TGLayoutPos的max方法的快捷方法。比如a.tg_left.max(10) <==> a.tg_left <= 10
public func <=(oprPos:TGLayoutPos, size:CGFloat)
{
    oprPos.max(size)
}









