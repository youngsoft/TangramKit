//
//  TangramKit.swift
//  TangramKit
//
//  Created by 欧阳大哥 on 16/10/28.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//  Email:    obq0387_cn@sina.com
//  QQ:       156355113
//  QQ群:     178573773
//  Github:   https://github.com/youngsoft/TangramKit      forSwift
//  Github:   https://github.com/youngsoft/MyLinearLayout  forObjective-C
//  HomePage: http://www.jianshu.com/users/3c9287519f58
//  HomePage: http://blog.csdn.net/yangtiang
//
/*
 The MIT License (MIT)
 
 Copyright (c) 2016 YoungSoft
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

/*
   感谢TangramKit的共同开发者，没有他们的帮忙我无法准时的完成这件事情，他们之中有我的同事，也有共同的兴趣爱好者。他们是：
 
 闫涛：
        github:    https://github.com/taoyan
        homepage:  http://blog.csdn.net/u013928640
 张光凯
        github:    https://github.com/loveNoodles
        homepage:  http://blog.csdn.net/u011597585
 周杰:
       github: https://github.com/MineJ
 
 阳光不锈：
      github: https://github.com/towik
 
 */


import Foundation
import UIKit

/**
 *布局视图中的所有子视图的停靠和填充属性。所谓停靠就是指子视图定位在布局视图中的水平左、中、右和垂直上、中、下的某个方位上的位置。而所谓填充则让布局视图里面的子视图的宽度和高度和自己相等。通过停靠的设置，可以为布局中的所有子视图都设置相同的对齐或者尺寸，而不需要单独为每个子视图进行重复设置。
 */
public struct TGGravity : OptionSet{
    public let rawValue :Int
    public init(rawValue: Int) {self.rawValue = rawValue}
    
    //不停靠
    public static let none = TGGravity(rawValue:0)
    
    //水平
    public struct horz
    {
        public static let left = TGGravity(rawValue:1)           //左
        public static let center = TGGravity(rawValue:2)         //水平居中
        public static let right = TGGravity(rawValue:4)          //右
        public static let windowCenter = TGGravity(rawValue: 8)  //在窗口水平中居中
        public static let between = TGGravity(rawValue: 16)      //水平间距拉伸，用于线性布局和流式布局
        public static let fill:TGGravity = [horz.left, horz.center, horz.right]  //水平填充
        public static let mask = TGGravity(rawValue:0xFF00)
    }
    
    //垂直
    public struct vert
    {
        public static let top = TGGravity(rawValue:1 << 8)           //上
        public static let center = TGGravity(rawValue:2 << 8)        //垂直居中
        public static let bottom = TGGravity(rawValue:4 << 8)        //下
        public static let windowCenter = TGGravity(rawValue:8 << 8)  //在窗口中垂直居中
        public static let between = TGGravity(rawValue: 16 << 8)      //垂直间距拉伸，用于线性布局和流式布局
        public static let fill:TGGravity = [vert.top, vert.center, vert.bottom] //垂直填充
        public static let mask = TGGravity(rawValue:0x00FF)
        
    }
    
    //整体居中
    public static let center:TGGravity = [horz.center, vert.center]
    
    //整体填充
    public static let fill:TGGravity = [horz.fill, vert.fill]
    
}

public func &(left: TGGravity, right: TGGravity) -> TGGravity {
    return TGGravity(rawValue: left.rawValue & right.rawValue)
}


/**
 *设置布局视图的布局方向，方向决定了布局视图里面的所有子视图的排列的方式。
 */
public enum TGOrientation {
    
    case vert        //垂直方向，所有子视图从上往下或者从下往上排列
    case horz        //水平方向，所有子视图从左往右或者从右往左排列
}



/**
 *位置和尺寸的比重对象，表示位置或尺寸的值是相对值。也就是尺寸或者位置的百分比值。
 *weight值在布局系统中可能表示占用父视图的位置或者尺寸的比例值或者是占用父视图剩余空间的比例值。
 *比如tg_width.equal(20%) 表示子视图的宽度是父视图的20%的比例。
 *请使用  数字% 方法来使用TGWeight类型的值。
 */
public struct TGWeight:Any
{
    //常用的比重值。
    public static let zeroWeight = TGWeight(0)        //0比重，表示不占用任何位置和尺寸。
    
    private var _value:CGFloat = 0
    
    
    public init(_ value:Int8)
    {
        _value = CGFloat(value)
    }
    
    public init(_ value:Int16)
    {
        _value = CGFloat(value)
    }
    
    public init(_ value:Int32)
    {
        _value = CGFloat(value)
    }

    public init(_ value:Int64)
    {
        _value = CGFloat(value)
    }

    
    public init(_ value:Int)
    {
        _value = CGFloat(value)
    }
    
    public init(_ value:UInt)
    {
        _value = CGFloat(value)
    }

    
    public init(_ value:Double)
    {
        _value = CGFloat(value)
    }
    
    public init (_ value:Float)
    {
        _value = CGFloat(value)
    }
    
    public init(_ value:CGFloat)
    {
        _value = value
    }
    
    public init(_ value:TGWeight)
    {
        _value = value._value
    }
    
    
    internal var rawValue:CGFloat{
        get
        {
            return _value;
        }
        
        set
        {
            _value = newValue
        }
    }
    
}


extension TGWeight:Equatable
{
    
}

public func !=(lhs: TGWeight, rhs: TGWeight) -> Bool
{
    return lhs.rawValue != rhs.rawValue
}

public func ==(lhs: TGWeight, rhs: TGWeight) -> Bool
{
    return lhs.rawValue == rhs.rawValue
}

public func +=( lhs:inout TGWeight, rhs:TGWeight)
{
    lhs.rawValue += rhs.rawValue
}

public func +(lhs:TGWeight, rhs:TGWeight) ->TGWeight
{
    return TGWeight(lhs.rawValue + rhs.rawValue)
}


//比重对象的快捷使用方式。
postfix operator %

// TGWeight(100) <==> 100%
public postfix func %(val:CGFloat) ->TGWeight
{
    return TGWeight(val)
}

public postfix func %(val:Int) ->TGWeight
{
    return TGWeight(val)
}


/**
 *设置当布局视图嵌入到UIScrollView以及其派生类时对UIScrollView的contentSize的调整模式
 */
public enum TGAdjustScrollViewContentSizeMode {
   
    //自动调整，在添加到UIScrollView之前(UITableView, UICollectionView除外)。如果值被设置auto则自动会变化yes。如果值被设置为no则不进行任何调整。
    case `auto`
    
    //不会调整contentSize
    case no
    
    //一定会调整contentSize
    case yes
}


/**
 * 这个枚举定义在线性布局里面当某个子视图的尺寸或者位置值为TGWeight类型时，而当剩余的有固定尺寸和间距的子视图的尺寸总和要大于
 * 视图本身的尺寸时，对那些具有固定尺寸或者固定间距的子视图的处理方式。需要注意的是只有当子视图的尺寸和间距总和大于布局视图的尺寸时才有意义，否则无意义。
 * 比如某个垂直线性布局的高度是100。 里面分别有A,B,C,D四个子视图。其中:
 A.topPos = 10
 A.height = 50
 B.topPos = 10%
 B.weight = 20%
 C.height = 60
 D.topPos = 20
 D.weight = 70%
 
 那么这时候总的固定高度 = A.tg_top + A.tg_height + C.tg_height +D.tg_top = 140 > 100。
 也就是多出了40的尺寸值，那么这时候我们可以用如下压缩类型的组合进行特殊的处理：
 
 1. average (布局的默认设置。)
 这种情况下，我们只会压缩那些具有固定尺寸的视图的高度A,C的尺寸，每个子视图的压缩的值是：剩余的尺寸40 / 固定尺寸的视图数量2 = 20。 这样:
 A的最终高度 = 50 - 20 = 30
 C的最终高度 = 60 - 20 = 40
 
 2.weight
 这种情况下，我们只会压缩那些具有固定尺寸的视图的高度A,C的尺寸，这些总的高度为50 + 60 = 110. 这样：
 A的最终高度 = 50 - 40 *(50/110) = 32
 C的最终高度 = 60 - 40 *（60/110) = 38
 

 3. none
 这种情况下即使是固定的视图的尺寸超出也不会进行任何压缩！！！！
 
 */
public enum TGSubviewsShrinkType:Int
{
    case average = 0  //平均压缩,默认是这个值。
    case weight = 1   //比例压缩。
    case none = 8     //不压缩。
}


