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

//Current version is 1.3.1, please open: https://github.com/youngsoft/TangramKit/blob/master/CHANGELOG.md to show the changes.



import Foundation
import UIKit


/// 布局视图方向的枚举类型定义。用来指定布局内子视图的整体排列布局方向。
///
/// - vert: 垂直方向，布局视图内所有子视图整体从上到下排列布局。
/// - horz: 水平方向，布局视图内所有子视图整体从左到右排列布局。
public enum TGOrientation {
    /// 垂直方向，布局视图内所有子视图整体从上到下排列布局。
    case vert
    /// 水平方向，布局视图内所有子视图整体从左到右排列布局。
    case horz
}


/// 视图的可见性枚举类型定义。用来指定视图是否在布局中可见，他是对hidden属性的扩展设置
///
/// - visible: 视图可见，等价于hidden = false
/// - invisible: 视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域
/// - gone: 视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域
public enum TGVisibility {
    /// 视图可见，等价于hidden = false
    case visible
    /// 视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域
    case invisible
    /// 视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域
    case gone
}



/// 布局视图内所有子视图的停靠方向和填充拉伸属性以及对齐方式的枚举类型定义。
///
/// - 所谓停靠方向就是指子视图停靠在布局视图中水平方向和垂直方向的位置。水平方向一共有左、水平中心、右、窗口水平中心四个位置，垂直方向一共有上、垂直中心、下、窗口垂直中心四个位置。
/// - 所谓填充拉伸属性就是指子视图的尺寸填充或者子视图的间距拉伸满整个布局视图。一共有水平宽度、垂直高度两种尺寸填充，水平间距、垂直间距两种间距拉伸。
/// - 所谓对齐方式就是指多个子视图之间的对齐位置。水平方向一共有左、水平居中、右、左右两端对齐四种对齐方式，垂直方向一共有上、垂直居中、下、向下两端对齐四种方式。
///
/// 在布局基类中有一个gravity属性用来表示布局内所有子视图的停靠方向和填充拉伸属性；在流式布局中有一个arrangedGravity属性用来表示布局内每排子视图的对齐方式。
public struct TGGravity : OptionSet{
    public let rawValue :Int
    public init(rawValue: Int) {self.rawValue = rawValue}
    
    /// 默认值，不停靠、不填充、不对齐。
    public static let none = TGGravity(rawValue:0)
    
    /// 水平方向
    public struct horz
    {
        
        /// 左边停靠或者左对齐
        public static let left = TGGravity(rawValue:1)
        /// 水平中心停靠或者水平居中对齐
        public static let center = TGGravity(rawValue:2)
        /// 右边停靠或者右对齐
        public static let right = TGGravity(rawValue:4)
        /// 窗口水平中心停靠，表示在屏幕窗口的水平中心停靠
        public static let windowCenter = TGGravity(rawValue: 8)
        /// 水平间距拉伸
        public static let between = TGGravity(rawValue: 16)
        /// 头部对齐,对于阿拉伯国家来说是和Right等价的,对于非阿拉伯国家则是和Left等价的
        public static let leading = TGGravity(rawValue: 32)
        /// 尾部对齐,对于阿拉伯国家来说是和Left等价的,对于非阿拉伯国家则是和Right等价的
        public static let trailing = TGGravity(rawValue:64)
        /// 水平宽度填充
        public static let fill:TGGravity = [horz.left, horz.center, horz.right]
        /// 水平掩码，用来获取水平方向的枚举值
        public static let mask = TGGravity(rawValue:0xFF00)
    }
    
    /// 垂直方向
    public struct vert
    {
        /// 上边停靠或者上对齐
        public static let top = TGGravity(rawValue:1 << 8)
        /// 垂直中心停靠或者垂直居中对齐
        public static let center = TGGravity(rawValue:2 << 8)
        /// 下边停靠或者下边对齐
        public static let bottom = TGGravity(rawValue:4 << 8)
        /// 窗口垂直中心停靠，表示在屏幕窗口的垂直中心停靠
        public static let windowCenter = TGGravity(rawValue:8 << 8)
        /// 垂直间距拉伸
        public static let between = TGGravity(rawValue: 16 << 8)
        /// 垂直高度填充
        public static let fill:TGGravity = [vert.top, vert.center, vert.bottom]
        /// 基线对齐,只支持水平线性布局，指定基线对齐必须要指定出一个基线标准的子视图
        public static let baseline = TGGravity(rawValue: 32 << 8)
        /// 垂直掩码，用来获取垂直方向的枚举值
        public static let mask = TGGravity(rawValue:0x00FF)
        
    }
    
    /// 整体居中
    public static let center:TGGravity = [horz.center, vert.center]
    /// 全部填充
    public static let fill:TGGravity = [horz.fill, vert.fill]
    /// 全部拉伸
    public static let between:TGGravity = [horz.between, vert.between]
}


public func &(left: TGGravity, right: TGGravity) -> TGGravity {
    return TGGravity(rawValue: left.rawValue & right.rawValue)
}

public func >(left: TGGravity, right: TGGravity) -> Bool {
    return left.rawValue > right.rawValue
}


/// 用来设置当线性布局中的子视图的尺寸大于线性布局的尺寸时的子视图的压缩策略枚举类型定义。请参考线性布局的tg_shrinkType属性的定义。
public struct TGSubviewsShrinkType : OptionSet{
    public let rawValue :Int
    public init(rawValue: Int) {self.rawValue = rawValue}
    
    //压缩策略
    
    /// 不压缩,默认是这个值
    public static let none = TGSubviewsShrinkType(rawValue:0)
    /// 平均压缩。
    public static let average = TGSubviewsShrinkType(rawValue:1)
    /// 比例压缩。
    public static let weight = TGSubviewsShrinkType(rawValue:2)
    /// 自动压缩。这个属性只有在水平线性布局里面并且只有2个子视图的宽度等于.wrap时才有用。这个属性主要用来实现左右两个子视图根据自身内容来进行缩放，以便实现最佳的宽度空间利用
    public static let auto = TGSubviewsShrinkType(rawValue:4)
    
    //压缩模式
    
    /// 尺寸压缩
    public static let size = TGSubviewsShrinkType(rawValue:0)
    /// 间距压缩
    public static let space = TGSubviewsShrinkType(rawValue:16)
}


/// 位置和尺寸的比重对象，表示位置或尺寸的值是相对值。也就是尺寸或者位置的百分比值。
///
/// 比如tg_width.equal(20%) 表示子视图的宽度是父视图的20%的比例。
/// 请使用  数字% 方法来使用TGWeight类型的值。
public struct TGWeight:Any
{
    //常用的比重值。
    
    /// 0比重，表示不占用任何位置和尺寸。
    public static let zeroWeight = TGWeight(0)
    
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

public func -=( lhs:inout TGWeight, rhs:TGWeight)
{
    lhs.rawValue -= rhs.rawValue
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


/// 设置当将布局视图嵌入到UIScrollView以及其派生类时对UIScrollView的contentSize的调整设置模式的枚举类型定义。
/// 当将一个布局视图作为子视图添加到UIScrollView或者其派生类时(UITableView,UICollectionView除外)系统会自动调整和计算并设置其中的contentSize值。您可以使用布局视图的属性tg_adjustScrollViewContentSizeMode来进行设置定义的枚举值。
///
/// - auto: 自动调整，在添加到UIScrollView之前(UITableView, UICollectionView除外)。如果值被设置auto则自动会变化yes。如果值被设置为no则不进行任何调整
/// - no: 不会调整contentSize
/// - yes: 一定会调整contentSize
public enum TGAdjustScrollViewContentSizeMode {
   
    /// 自动调整，在添加到UIScrollView之前(UITableView, UICollectionView除外)。如果值被设置auto则自动会变化yes。如果值被设置为no则不进行任何调整
    case auto
    /// 不会调整contentSize
    case no
    /// 一定会调整contentSize
    case yes
}


