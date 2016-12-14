//
//  TGViewSizeClass.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/*
 Tangram为了实现屏幕的适配，提供了对SizeClass的支持。Tangram的SizeClass功能除了兼容iOS系统的SizeClass外还扩展出单独的横竖屏适配机制。
 
 对于任意一种设备屏幕来说，某个纬度的尺寸都可以概括为：Any任意，Compact压缩，Regular常规三种类别，也就是说我们对屏幕的尺寸进行分类(Size Class)
 这样我们就能分出9种不同尺寸类型的屏幕。比如下面就列出了苹果各种设备的SizeClass的值：
 
 iPhone4S,iPhone5/5s,iPhone6,iPhone7
 竖屏：(w:Compact h:Regular)
 横屏：(w:Compact h:Compact)
 iPhone6 Plus,iPhone7Plus
 竖屏：(w:Compact h:Regular)
 横屏：(w:Regular h:Compact)
 iPad
 竖屏：(w:Regular h:Regular)
 横屏：(w:Regular h:Regular)
 Apple Watch
 竖屏：(w:Compact h:Compact)
 横屏：(w:Compact h:Compact)
 
 通过对SizeClass的定义，我们进行布局时就不需要针对某种具体的设备而只需要针对某类尺寸的设备进行就可以了。同时为了兼容多类尺寸，我们提出了SizeClass的继承关系,其中的继承关系如下：
 
 w:Compact h:Compact 继承 (w:Any h:Compact , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Compact 继承 (w:Any h:Compact , w:Regular h:Any , w:Any h:Any)
 w:Compact h:Regular 继承 (w:Any h:Regular , w:Compact h:Any , w:Any h:Any)
 w:Regular h:Regular 继承 (w:Any h:Regular , w:Regular h:Any , w:Any h:Any)
 
 
 举例来说，如果设备当前的SizeClass是：w:Compact h:Compact 则在系统布局时会找出每个视图是否定义了这个SizeClass的下面的布局属性，如果找到了则用视图在这个SizeClass下所定义的布局属性进行布局，如果没有则继续找w:Any h:Compact,如果找到了则使用这个SizeClass下的布局属性，否则继续往上找，直到w:Any h:Any这种尺寸，因为默认所有视图的布局属性设置都是基于w:Any h:Any的，所以总是会找到对应的视图定义的布局属性。
 
 在上述的定义中我们发现了2个问题，一个就是没有一个明确来指定横屏和竖屏这种屏幕的情况；另外一个是iPad设备的宽度和高度都是regular，而无法区分横屏和竖屏。因此这里对SizeClass新增加了两个定义：竖屏portrait和横屏landscape。这样我们就可以用这两个类型来定义横屏和竖屏的不同界面。
 
 在默认情况下所有视图的布局约束设置都是基于w:Any h:Any的,如果我们要为某种SizeClass设置约束则可以调用视图的扩展方法：
 
 
 public func tg_fetchSizeClass(with type:TGSizeClassType, from srcType:TGSizeClassType! = nil) ->TGViewSizeClass
 
 这个方法需要传递一个宽度的TGSizeClassType定义和高度的TGSizeClassType定义，并通过.comb枚举来进行组合。 比如：
 
 1.想设置所有iPhone设备的横屏的约束
 let tsc = 某视图.tg_fetchSizeClass(.comb(any,compact,nil))
 
 2.想设置所有iPad设备的横屏的约束
 let tsc = 某视图.tg_fetchSizeClass(.comb(regular,regular,landscape))
 3.想设置iphone6plus下的横屏的约束
 let tsc = 某视图.tg_fetchSizeClass(.comb(regular,compact,nil))
 
 4.想设置ipad下的约束
 let tsc = 某视图.tg_fetchSizeClass(.comb(regular,regular,nil))
 
 5.想设置所有设备下的约束，也是默认的视图的约束
 let tsc = 某视图.tg_fetchSizeClass(.default)
 
 6.所有设备的竖屏约束：
 let tsc = 某视图.tg_fetchSizeClass(.portrait)
 
 7.所有设备的横屏约束：
 let tsc = 某视图.tg_fetchSizeClass(.landscape)
 
 
 tg_fetchSizeClass返回的是一个TGViewSizeClass或者其派生协议。UIView及其派生类也实现了TGViewSizeClass协议以及派生类，这也就表明UIView以及派生类中的各种布局属性就是其中的一种SizeClassType(也就是为.default类型的SizeClass)。因此可以看出我们直接对视图以及其派生类设置的布局属性，其实是对SizeClassType为.default类型的SizeClass进行设置。也就是说设置某个视图: 
    
   A.tg_width.equal(100) <==> A.tg_fetchSizeClass(.default).tg_width.equal(100)
 
 */

//定义SizeClass的类型
public enum TGSizeClassType
{
    public enum Width
    {
       case any
       case compact
       case regular
    }
    
    public enum Height
    {
        case any
        case compact
        case regular
    }
    
    public enum Screen
    {
        case portrait
        case landscape
    }
    
    case `default`   //等价于 .comb(.any, .any, nil)
    case portrait    //等价于 .comb(.any,.any,.portrait)
    case landscape   //等价于 .comb(.any,.any,.landscape)
    case comb(Width,Height,Screen?)
}

/**
 * 定义SizeClass中普通视图的具有的布局属性接口
 */
public protocol TGViewSizeClass:NSObjectProtocol
{
    var tg_left:TGLayoutPos{get}
    var tg_top:TGLayoutPos{get}
    var tg_right:TGLayoutPos{get}
    var tg_bottom:TGLayoutPos{get}
    var tg_centerX:TGLayoutPos{get}
    var tg_centerY:TGLayoutPos{get}
    
    var tg_width:TGLayoutSize{get}
    var tg_height:TGLayoutSize{get}
    
    var tg_useFrame:Bool{get set}
    var tg_noLayout:Bool{get set}
    var isHidden:Bool{get set}
    
    var tg_reverseFloat:Bool{get set}
    var tg_clearFloat:Bool{get set}
}

/**
 * 定义SizeClass中布局视图的具有的布局属性接口
 */
public protocol TGLayoutViewSizeClass:TGViewSizeClass
{
    var tg_padding:UIEdgeInsets{get set}
    var tg_topPadding:CGFloat{get set}
    var tg_leftPadding:CGFloat{get set}
    var tg_bottomPadding:CGFloat{get set}
    var tg_rightPadding:CGFloat{get set}
    var tg_vspace:CGFloat{get set}
    var tg_hspace:CGFloat{get set}
    var tg_space:CGFloat{get set}
    var tg_reverseLayout: Bool{get set}
    var tg_layoutHiddenSubviews:Bool{get set}
}

/**
 * 定义SizeClass中顺序布局视图的具有的布局属性接口，所谓顺序布局视图就是表明布局中的子视图中的布局会受制于添加的顺序
 */
public protocol TGSequentLayoutViewSizeClass:TGLayoutViewSizeClass
{
    var tg_orientation:TGOrientation{get set}
    var tg_gravity:TGGravity{get set}
}

/**
 * 定义SizeClass中线性布局所具有的布局属性接口
 */
public protocol TGLinearLayoutViewSizeClass:TGSequentLayoutViewSizeClass
{
    var tg_shrinkType:TGSubviewsShrinkType{get set}
}

/**
 * 定义SizeClass中表格布局所具有的布局属性接口
 */
public protocol TGTableLayoutViewSizeClass:TGLinearLayoutViewSizeClass
{
    
}

/**
 * 定义SizeClass中流式布局所具有的布局属性接口
 */
public protocol TGFlowLayoutViewSizeClass:TGSequentLayoutViewSizeClass
{
    var tg_arrangedCount:Int {get set}
    var tg_arrangedGravity:TGGravity {get set}
    var tg_autoArrange:Bool {get set}
}


/**
 * 定义SizeClass中浮动布局所具有的布局属性接口
 */
public protocol TGFloatLayoutViewSizeClass:TGSequentLayoutViewSizeClass
{
    var tg_noBoundaryLimit:Bool{get set}
}

/**
 *定义SizeClass中相对布局所具有的布局属性接口
 */
public protocol TGRelativeLayoutViewSizeClass:TGLayoutViewSizeClass
{
    var tg_autoLayoutViewGroupWidth:Bool{get set}
    var tg_autoLayoutViewGroupHeight:Bool{get set}

}

/**
 *定义SizeClass中框架布局所具有的布局属性接口
 */
public protocol TGFrameLayoutViewSizeClass:TGLayoutViewSizeClass
{
    
}

/**
 * 定义SizeClass中PathLayout所具有的布局属性接口
 */
public protocol TGPathLayoutViewSizeClass : TGLayoutViewSizeClass{

}


//TGSizeClass Implemention
internal class TGViewSizeClassImpl:NSObject,NSCopying,TGViewSizeClass {
    
    required override init() {
        super.init()
    }
    
    var tg_left = TGLayoutPos(TGGravity.horz.left)
    var tg_top = TGLayoutPos(TGGravity.vert.top)
    var tg_right = TGLayoutPos(TGGravity.horz.right)
    var tg_bottom = TGLayoutPos(TGGravity.vert.bottom)
    var tg_centerX = TGLayoutPos(TGGravity.horz.center)
    var tg_centerY = TGLayoutPos(TGGravity.vert.center)
    
    var tg_width = TGLayoutSize(TGGravity.horz.fill)
    var tg_height = TGLayoutSize(TGGravity.vert.fill)
    
    var tg_useFrame:Bool = false
    var tg_noLayout:Bool = false
    var isHidden:Bool = false
    
    var tg_reverseFloat:Bool = false
    var tg_clearFloat:Bool = false
    
    var tgLayoutCompletedAction:((_ layout:TGBaseLayout,_ view:UIView)->Void)? = nil

    func copy(with zone: NSZone? = nil) -> Any
    {
        let tsc:TGViewSizeClassImpl = type(of: self).init()
        
        tsc.tg_left = self.tg_left.copy() as! TGLayoutPos
        tsc.tg_top = self.tg_top.copy() as! TGLayoutPos
        tsc.tg_right = self.tg_right.copy() as! TGLayoutPos
        tsc.tg_bottom = self.tg_bottom.copy() as! TGLayoutPos
        tsc.tg_centerX = self.tg_centerX.copy() as! TGLayoutPos
        tsc.tg_centerY = self.tg_centerY.copy() as! TGLayoutPos
        tsc.tg_width = self.tg_width.copy() as! TGLayoutSize
        tsc.tg_height = self.tg_height.copy() as! TGLayoutSize
        tsc.tg_useFrame = self.tg_useFrame
        tsc.tg_noLayout = self.tg_noLayout
        tsc.isHidden = self.isHidden
        tsc.tg_reverseFloat = self.tg_reverseFloat
        tsc.tg_clearFloat = self.tg_clearFloat

        return tsc
    }
}


internal class TGLayoutViewSizeClassImpl:TGViewSizeClassImpl,TGLayoutViewSizeClass
{
    var tg_padding:UIEdgeInsets = UIEdgeInsets.zero
    var tg_topPadding:CGFloat
        {
        get{
            
            return tg_padding.top
        }
        set
        {
            tg_padding.top = newValue
        }
    }
    
    var tg_leftPadding:CGFloat
        {
        get{
            return tg_padding.left
        }
        set
        {
            tg_padding.left = newValue
        }
    }
    
    var tg_bottomPadding:CGFloat
        {
        get{
            return tg_padding.bottom
        }
        set
        {
            tg_padding.bottom = newValue
        }
    }
    
    var tg_rightPadding:CGFloat
        {
        get{
            return tg_padding.right
        }
        set
        {
            tg_padding.right = newValue
        }
    }
    
    var tg_vspace:CGFloat = 0
    var tg_hspace:CGFloat = 0
    
    var tg_space:CGFloat
        {
        get
        {
            return self.tg_vspace
        }
        set
        {
            self.tg_vspace = newValue
            self.tg_hspace = newValue
        }
    }

    var tg_reverseLayout: Bool = false
    
    var tg_layoutHiddenSubviews:Bool = false
    
    
    override func copy(with zone: NSZone?) -> Any {
        
        let tsc = super.copy(with: zone) as! TGLayoutViewSizeClassImpl
        
        tsc.tg_padding = self.tg_padding
        tsc.tg_vspace = self.tg_vspace
        tsc.tg_hspace = self.tg_hspace
        tsc.tg_reverseLayout = self.tg_reverseLayout
        tsc.tg_layoutHiddenSubviews = self.tg_layoutHiddenSubviews
        
        return tsc
    }
    
}

internal class TGSequentLayoutViewSizeClassImpl:TGLayoutViewSizeClassImpl,TGSequentLayoutViewSizeClass
{
    var tg_orientation:TGOrientation = .vert
    var tg_gravity:TGGravity = .none
    
    override func copy(with zone: NSZone?) -> Any {
        
        let tsc = super.copy(with: zone) as! TGSequentLayoutViewSizeClassImpl
        
        tsc.tg_orientation = self.tg_orientation
        tsc.tg_gravity = self.tg_gravity
        
        return tsc
    }

}

internal class TGLinearLayoutViewSizeClassImpl:TGSequentLayoutViewSizeClassImpl,TGLinearLayoutViewSizeClass
{
    var tg_shrinkType: TGSubviewsShrinkType = .average
    
    override func copy(with zone: NSZone?) -> Any {
        
        let tsc = super.copy(with: zone) as! TGLinearLayoutViewSizeClassImpl
        
        tsc.tg_shrinkType = self.tg_shrinkType
        
        return tsc
    }

}


internal class TGTableLayoutViewSizeClassImpl:TGLinearLayoutViewSizeClassImpl,TGTableLayoutViewSizeClass
{
}


internal class TGFloatLayoutViewSizeClassImpl : TGSequentLayoutViewSizeClassImpl,TGFloatLayoutViewSizeClass
{
    var tg_noBoundaryLimit:Bool = false
    
    var tgSubviewSize:CGFloat = 0
    var tgMinSpace:CGFloat = 0
    var tgMaxSpace:CGFloat = .greatestFiniteMagnitude

    override func copy(with zone: NSZone?) -> Any {
        
        let tsc = super.copy(with: zone) as! TGFloatLayoutViewSizeClassImpl
        
        tsc.tg_noBoundaryLimit = self.tg_noBoundaryLimit
        tsc.tgSubviewSize = self.tgSubviewSize
        tsc.tgMinSpace = self.tgMinSpace
        tsc.tgMaxSpace = self.tgMaxSpace
        
        return tsc
    }

    
}


internal class TGFlowLayoutViewSizeClassImpl:TGSequentLayoutViewSizeClassImpl,TGFlowLayoutViewSizeClass
{
    var tg_arrangedCount:Int = 0
    var tg_arrangedGravity:TGGravity = .none
    var tg_autoArrange:Bool = false
    
    var tgSubviewSize:CGFloat = 0
    var tgMinSpace:CGFloat = 0
    var tgMaxSpace:CGFloat = .greatestFiniteMagnitude

    
    override func copy(with zone: NSZone?) -> Any {
        
        let tsc = super.copy(with: zone) as! TGFlowLayoutViewSizeClassImpl
        
        tsc.tg_arrangedCount = self.tg_arrangedCount
        tsc.tg_arrangedGravity = self.tg_arrangedGravity
        tsc.tg_autoArrange = self.tg_autoArrange
        tsc.tgSubviewSize = self.tgSubviewSize
        tsc.tgMinSpace = self.tgMinSpace
        tsc.tgMaxSpace = self.tgMaxSpace

        return tsc
    }

}

internal class TGFrameLayoutViewSizeClassImpl:TGLayoutViewSizeClassImpl,TGFrameLayoutViewSizeClass
{
    
}


internal class TGRelativeLayoutViewSizeClassImpl:TGLayoutViewSizeClassImpl,TGRelativeLayoutViewSizeClass
{
     var tg_autoLayoutViewGroupWidth:Bool = false
     var tg_autoLayoutViewGroupHeight:Bool = false
    
     override func copy(with zone: NSZone?) -> Any {
        
        let tsc = super.copy(with: zone) as! TGRelativeLayoutViewSizeClassImpl
        
        tsc.tg_autoLayoutViewGroupWidth = self.tg_autoLayoutViewGroupWidth
        tsc.tg_autoLayoutViewGroupHeight = self.tg_autoLayoutViewGroupHeight
        
        return tsc
    }
}

internal class TGPathLayoutViewSizeClassImpl: TGLayoutViewSizeClassImpl,TGPathLayoutViewSizeClass
{

}
