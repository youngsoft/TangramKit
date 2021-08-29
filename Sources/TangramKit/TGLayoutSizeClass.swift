//
//  TGViewSizeClass.swift
//  TangramKit
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

#if os(watchOS) || os(iOS) || os(tvOS)
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
public enum TGSizeClassType {
    public enum Width {
        case any
        case compact
        case regular
    }

    public enum Height {
        case any
        case compact
        case regular
    }

    public enum Screen {
        case portrait
        case landscape
    }

    case `default`   //等价于 .comb(.any, .any, nil)
    case portrait    //等价于 .comb(.any,.any,.portrait)
    case landscape   //等价于 .comb(.any,.any,.landscape)
    case comb(Width, Height, Screen?)
}

/**
 * 定义SizeClass中普通视图的具有的布局属性接口
 */
public protocol TGViewSizeClass: class {
    var tg_top: TGLayoutPos { get }
    var tg_leading: TGLayoutPos { get }
    var tg_bottom: TGLayoutPos { get }
    var tg_trailing: TGLayoutPos { get }
    var tg_centerX: TGLayoutPos { get }
    var tg_centerY: TGLayoutPos { get }

    var tg_left: TGLayoutPos { get }
    var tg_right: TGLayoutPos { get }
    var tg_baseline: TGLayoutPos { get }

    var tg_width: TGLayoutSize { get }
    var tg_height: TGLayoutSize { get }

    var tg_useFrame: Bool { get set }
    var tg_noLayout: Bool { get set }
    var tg_reverseFloat: Bool { get set }
    var tg_clearFloat: Bool { get set }

    var tg_visibility: TGVisibility { get set }
    var tg_alignment: TGGravity { get set }
}

/**
 * 定义SizeClass中布局视图的具有的布局属性接口
 */
public protocol TGLayoutViewSizeClass: TGViewSizeClass {
    var tg_padding: UIEdgeInsets { get set }
    var tg_topPadding: CGFloat { get set }
    var tg_leadingPadding: CGFloat { get set }
    var tg_bottomPadding: CGFloat { get set }
    var tg_trailingPadding: CGFloat { get set }
    var tg_zeroPadding: Bool { get set }
    var tg_insetsPaddingFromSafeArea: UIRectEdge { get set }
    var tg_insetLandscapeFringePadding: Bool { get set }

    var tg_leftPadding: CGFloat { get set }
    var tg_rightPadding: CGFloat { get set }

    var tg_vspace: CGFloat { get set }
    var tg_hspace: CGFloat { get set }
    var tg_space: CGFloat { get set }
    var tg_reverseLayout: Bool { get set }

    var tg_gravity: TGGravity { get set }
    var tg_layoutTransform: CGAffineTransform { get set }
}

extension TGLayoutViewSizeClass {
    var tg_padding: UIEdgeInsets { get { return UIEdgeInsets.zero } set {} }
    var tg_topPadding: CGFloat { get { return 0 } set {} }
    var tg_leadingPadding: CGFloat { get { return 0 } set {} }
    var tg_bottomPadding: CGFloat { get { return 0 } set {} }
    var tg_trailingPadding: CGFloat {get { return 0 } set {} }
    var tg_zeroPadding: Bool { get { return true } set {} }
    var tg_insetsPaddingFromSafeArea: UIRectEdge { get { return UIRectEdge.all } set {} }
    var tg_insetLandscapeFringePadding: Bool { get { return true } set {} }

    var tg_leftPadding: CGFloat { get { return 0 } set {} }
    var tg_rightPadding: CGFloat { get { return 0 } set {} }

    var tg_vspace: CGFloat { get { return 0 } set {} }
    var tg_hspace: CGFloat { get { return 0 } set {} }
    var tg_space: CGFloat { get { return 0 } set {} }
    var tg_reverseLayout: Bool { get { return false }  set {} }

    var tg_gravity: TGGravity { get { return TGGravity() } set {} }

    var tg_layoutTransform: CGAffineTransform { get { return CGAffineTransform() } set {} }
}

/**
 * 定义SizeClass中顺序布局视图的具有的布局属性接口，所谓顺序布局视图就是表明布局中的子视图中的布局会受制于添加的顺序
 */
public protocol TGSequentLayoutViewSizeClass: TGLayoutViewSizeClass {
    var tg_orientation: TGOrientation { get set }
}

extension TGSequentLayoutViewSizeClass {
    var tg_orientation: TGOrientation { get { return TGOrientation.vert } set {} }
}

/**
 * 定义SizeClass中线性布局所具有的布局属性接口
 */
public protocol TGLinearLayoutViewSizeClass: TGSequentLayoutViewSizeClass {
    var tg_shrinkType: TGSubviewsShrinkType { get set }
}

extension TGLinearLayoutViewSizeClass {
    var tg_shrinkType: TGSubviewsShrinkType { get { return TGSubviewsShrinkType() } set {} }
}

/**
 * 定义SizeClass中表格布局所具有的布局属性接口
 */
public protocol TGTableLayoutViewSizeClass: TGLinearLayoutViewSizeClass {}

extension TGTableLayoutViewSizeClass {}

/**
 * 定义SizeClass中流式布局所具有的布局属性接口
 */
public protocol TGFlowLayoutViewSizeClass: TGSequentLayoutViewSizeClass {
    var tg_arrangedCount: Int { get set }
    var tg_pagedCount: Int { get set }
    var tg_arrangedGravity: TGGravity { get set }
    var tg_lastlineGravityPolicy: TGGravityPolicy { get set }
    var tg_autoArrange: Bool { get set }
}

extension TGFlowLayoutViewSizeClass {
    var tg_arrangedCount: Int { get { return 0 } set {} }
    var tg_pagedCount: Int { get { return 0 } set {} }
    var tg_arrangedGravity: TGGravity { get { return TGGravity() } set {} }
    var tg_lastlineGravityPolicy: TGGravityPolicy { get { return TGGravityPolicy.no } set {} }
    var tg_autoArrange: Bool { get { return false } set {} }
}

/**
 * 定义SizeClass中浮动布局所具有的布局属性接口
 */
public protocol TGFloatLayoutViewSizeClass: TGSequentLayoutViewSizeClass {
    var tg_noBoundaryLimit: Bool {get set}
}

extension TGFloatLayoutViewSizeClass {
    var tg_noBoundaryLimit: Bool { get { return false } set {} }
}

/**
 *定义SizeClass中相对布局所具有的布局属性接口
 */
public protocol TGRelativeLayoutViewSizeClass: TGLayoutViewSizeClass {}

extension TGRelativeLayoutViewSizeClass {}

/**
 *定义SizeClass中框架布局所具有的布局属性接口
 */
public protocol TGFrameLayoutViewSizeClass: TGLayoutViewSizeClass {}

extension TGFrameLayoutViewSizeClass {}

/**
 * 定义SizeClass中PathLayout所具有的布局属性接口
 */
public protocol TGPathLayoutViewSizeClass: TGLayoutViewSizeClass {}

extension TGPathLayoutViewSizeClass {}

extension TGViewSizeClassImpl: TGNameSpaceWrappable {}

public extension TGTypeWrapperProtocol where TGWrappedType: TGViewSizeClassImpl {
    var top: TGLayoutPos {
        return self.wrappedValue.tg_top
    }

    var leading: TGLayoutPos {
        return self.wrappedValue.tg_leading
    }

    var bottom: TGLayoutPos {
        return self.wrappedValue.tg_bottom
    }

    var trailing: TGLayoutPos {
        return self.wrappedValue.tg_trailing
    }

    var centerX: TGLayoutPos {
        return self.wrappedValue.tg_centerX
    }

    var centerY: TGLayoutPos {
        return self.wrappedValue.tg_centerY
    }

    var left: TGLayoutPos {
        return self.wrappedValue.tg_left
    }

    var right: TGLayoutPos {
        return self.wrappedValue.tg_right
    }

    var baseline: TGLayoutPos {
        return self.wrappedValue.tg_baseline
    }

    var width: TGLayoutSize {
        return self.wrappedValue.tg_width
    }

    var height: TGLayoutSize {
        return self.wrappedValue.tg_height
    }

    func useFrame(value: Bool) {
        self.wrappedValue.tg_useFrame = value
    }

    func useFrame() -> Bool {
        return self.wrappedValue.tg_useFrame
    }

    func noLayout(value: Bool) {
        self.wrappedValue.tg_noLayout = value
    }

    func noLayout() -> Bool {
        return self.wrappedValue.tg_noLayout
    }

    func visibility(value: TGVisibility) {
        self.wrappedValue.tg_visibility = value
    }

    func visibility() -> TGVisibility {
        return self.wrappedValue.tg_visibility
    }

    func alignment(value: TGGravity) {
        self.wrappedValue.tg_alignment = value
    }

    func alignment() -> TGGravity {
        return self.wrappedValue.tg_alignment
    }
}

// MARK: - TGSizeClass Implemention
public class TGViewSizeClassImpl: NSCopying, TGViewSizeClass {
    required init(view: UIView) {
        //   super.init()
        self.view = view
    }

    public var tg_top: TGLayoutPos {
        if top.realPos == nil {
            top.realPos = TGLayoutPos(TGGravity.Vertical.top, view: self.view)
        }
        return top.realPos
    }

    public var tg_leading: TGLayoutPos {
        if leading.realPos == nil {
            leading.realPos = TGLayoutPos(TGGravity.Horizontal.leading, view: self.view)
        }
        return leading.realPos
    }

    public var tg_bottom: TGLayoutPos {
        if bottom.realPos == nil {
            bottom.realPos = TGLayoutPos(TGGravity.Vertical.bottom, view: self.view)
        }
        return bottom.realPos
    }

    public var tg_trailing: TGLayoutPos {
        if trailing.realPos == nil {
            trailing.realPos = TGLayoutPos(TGGravity.Horizontal.trailing, view: self.view)
        }
        return trailing.realPos
    }

    public var tg_centerX: TGLayoutPos {
        if centerX.realPos == nil {
            centerX.realPos = TGLayoutPos(TGGravity.Horizontal.center, view: self.view)
        }
        return centerX.realPos
    }

    public var tg_centerY: TGLayoutPos {
        if centerY.realPos == nil {
            centerY.realPos = TGLayoutPos(TGGravity.Vertical.center, view: self.view)
        }
        return centerY.realPos
    }

    public var tg_left: TGLayoutPos {
        if TGViewSizeClassImpl.IsRTL {
            return self.tg_trailing
        } else {
            return self.tg_leading
        }

    }

    public var tg_right: TGLayoutPos {
        if TGViewSizeClassImpl.IsRTL {
            return self.tg_leading
        } else {
            return self.tg_trailing
        }
    }

    public var tg_baseline: TGLayoutPos {
        if baseline.realPos == nil {
            baseline.realPos = TGLayoutPos(TGGravity.Vertical.baseline, view: self.view)
        }
        return baseline.realPos
    }

    public var tg_width: TGLayoutSize {
        if width.realSize == nil {
            width.realSize = TGLayoutSize(TGGravity.Horizontal.fill, view: self.view)
        }
        return width.realSize
    }

    public var tg_height: TGLayoutSize {
        if height.realSize == nil {
            height.realSize = TGLayoutSize(TGGravity.Vertical.fill, view: self.view)
        }
        return height.realSize
    }

    public var tg_useFrame: Bool = false
    public var tg_noLayout: Bool = false

    public var tg_reverseFloat: Bool = false
    public var tg_clearFloat: Bool = false

    public var tg_visibility: TGVisibility = TGVisibility.visible
    public var tg_alignment: TGGravity = TGGravity.none

    static var IsRTL: Bool = false

    weak var view: UIView!

    var layoutCompletedAction: ((_ layout: TGBaseLayout, _ view: UIView) -> Void)?

    internal lazy var top: TGLayoutPosValue2 = TGLayoutPosWrapper()
    internal lazy var leading: TGLayoutPosValue2 = TGLayoutPosWrapper()
    internal lazy var bottom: TGLayoutPosValue2 = TGLayoutPosWrapper()
    internal lazy var trailing: TGLayoutPosValue2 = TGLayoutPosWrapper()
    internal lazy var centerX: TGLayoutPosValue2 = TGLayoutPosWrapper()
    internal lazy var centerY: TGLayoutPosValue2 = TGLayoutPosWrapper()
    internal lazy var baseline: TGLayoutPosValue2 = TGLayoutPosWrapper()
    internal lazy var width: TGLayoutSizeValue2 = TGLayoutSizeWrapper()
    internal lazy var height: TGLayoutSizeValue2 = TGLayoutSizeWrapper()

    internal var left: TGLayoutPosValue2 {
        get {
            if TGViewSizeClassImpl.IsRTL {
                return trailing
            } else {
                return leading
            }
        }
        set {
            if TGViewSizeClassImpl.IsRTL {
                trailing = newValue
            } else {
                leading = newValue
            }
        }
    }

    internal var right: TGLayoutPosValue2 {
        get {
            if TGViewSizeClassImpl.IsRTL {
                return leading
            } else {
                return trailing
            }
        }
        set {
            if TGViewSizeClassImpl.IsRTL {
                leading = newValue
            } else {
                trailing = newValue
            }
        }
    }

    internal var isVertMarginHasValue: Bool {
        return top.hasValue && bottom.hasValue
    }

    internal var isHorzMarginHasValue: Bool {
        return leading.hasValue && trailing.hasValue
    }

    internal var isSomeSizeWrap: Bool {
        return width.isWrap || height.isWrap
    }

    internal var isAllSizeWrap: Bool {
        return width.isWrap && height.isWrap
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let tsc: TGViewSizeClassImpl = type(of: self).init(view: self.view)

        if self.top.realPos != nil {
            tsc.top.realPos = self.top.realPos.copy() as? TGLayoutPos
        }
        if self.leading.realPos != nil {
            tsc.leading.realPos = self.leading.realPos.copy() as? TGLayoutPos
        }
        if self.bottom.realPos != nil {
            tsc.bottom.realPos = self.bottom.realPos.copy() as? TGLayoutPos
        }
        if self.trailing.realPos != nil {
            tsc.trailing.realPos = self.trailing.realPos.copy() as? TGLayoutPos
        }
        if self.centerX.realPos != nil {
            tsc.centerX.realPos = self.centerX.realPos.copy() as? TGLayoutPos
        }
        if self.centerY.realPos != nil {
            tsc.centerY.realPos = self.centerY.realPos.copy() as? TGLayoutPos
        }
        if self.baseline.realPos != nil {
            tsc.baseline.realPos = self.baseline.realPos.copy() as? TGLayoutPos
        }
        if self.width.realSize != nil {
            tsc.width.realSize = self.width.realSize.copy() as? TGLayoutSize
        }
        if self.height.realSize != nil {
            tsc.height.realSize = self.height.realSize.copy() as? TGLayoutSize
        }

        tsc.tg_useFrame = self.tg_useFrame
        tsc.tg_noLayout = self.tg_noLayout
        tsc.tg_visibility = self.tg_visibility
        tsc.tg_alignment = self.tg_alignment
        tsc.tg_reverseFloat = self.tg_reverseFloat
        tsc.tg_clearFloat = self.tg_clearFloat

        return tsc
    }
}

public extension TGTypeWrapperProtocol where TGWrappedType: TGLayoutViewSizeClassImpl {
    func padding(value: UIEdgeInsets) {
        self.wrappedValue.tg_padding = value
    }

    func padding() -> UIEdgeInsets {
        return self.wrappedValue.tg_padding
    }

    func topPadding(value: CGFloat) {
        self.wrappedValue.tg_topPadding = value
    }

    func topPadding() -> CGFloat {
        return self.wrappedValue.tg_topPadding
    }

    func leadingPadding(value: CGFloat) {
        self.wrappedValue.tg_leadingPadding = value
    }

    func leadingPadding() -> CGFloat {
        return self.wrappedValue.tg_leadingPadding
    }

    func bottomPadding(value: CGFloat) {
        self.wrappedValue.tg_bottomPadding = value
    }

    func bottomPadding() -> CGFloat {
        return self.wrappedValue.tg_bottomPadding
    }

    func trailingPadding(value: CGFloat) {
        self.wrappedValue.tg_trailingPadding = value
    }

    func trailingPadding() -> CGFloat {
        return self.wrappedValue.tg_trailingPadding
    }

    func leftPadding(value: CGFloat) {
        self.wrappedValue.tg_leftPadding = value
    }

    func leftPadding() -> CGFloat {
        return self.wrappedValue.tg_leftPadding
    }

    func rightPadding(value: CGFloat) {
        self.wrappedValue.tg_rightPadding = value
    }

    func rightPadding() -> CGFloat {
        return self.wrappedValue.tg_rightPadding
    }

    func zeroPadding(value: Bool) {
        self.wrappedValue.tg_zeroPadding = value
    }

    func zeroPadding() -> Bool {
        return self.wrappedValue.tg_zeroPadding
    }

    func insetsPaddingFromSafeArea(value: UIRectEdge) {
        self.wrappedValue.tg_insetsPaddingFromSafeArea = value
    }

    func insetsPaddingFromSafeArea() -> UIRectEdge {
        return self.wrappedValue.tg_insetsPaddingFromSafeArea
    }

    func insetLandscapeFringePadding(value: Bool) {
        self.wrappedValue.tg_insetLandscapeFringePadding = value
    }

    func insetLandscapeFringePadding() -> Bool {
        return self.wrappedValue.tg_insetLandscapeFringePadding
    }

    func space(value: CGFloat) {
        self.wrappedValue.tg_space = value
    }

    func space() -> CGFloat {
        return self.wrappedValue.tg_space
    }

    func vspace(value: CGFloat) {
        self.wrappedValue.tg_vspace = value
    }

    func vspace() -> CGFloat {
        return self.wrappedValue.tg_vspace
    }

    func hspace(value: CGFloat) {
        self.wrappedValue.tg_hspace = value
    }

    func hspace() -> CGFloat {
        return self.wrappedValue.tg_hspace
    }

    func reverseLayout(value: Bool) {
        self.wrappedValue.tg_reverseLayout = value
    }

    func reverseLayout() -> Bool {
        return self.wrappedValue.tg_reverseLayout
    }

    func gravity(value: TGGravity) {
        self.wrappedValue.tg_gravity = value
    }

    func gravity() -> TGGravity {
        return self.wrappedValue.tg_gravity
    }

    func layoutTransform(value: CGAffineTransform) {
        self.wrappedValue.tg_layoutTransform = value
    }

    func layoutTransform() -> CGAffineTransform {
        return  self.wrappedValue.tg_layoutTransform
    }
}

public class TGLayoutViewSizeClassImpl: TGViewSizeClassImpl, TGLayoutViewSizeClass {
    public var tg_padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: tg_topPadding, left: tg_leftPadding, bottom: tg_bottomPadding, right: tg_rightPadding)
        }
        set {
            tg_topPadding = newValue.top
            tg_leftPadding = newValue.left
            tg_bottomPadding = newValue.bottom
            tg_rightPadding = newValue.right
        }
    }
    public var tg_topPadding: CGFloat = 0
    public var tg_leadingPadding: CGFloat = 0
    public var tg_bottomPadding: CGFloat = 0
    public var tg_trailingPadding: CGFloat = 0

    public var tg_leftPadding: CGFloat {
        get {
            if TGViewSizeClassImpl.IsRTL {
                return self.tg_trailingPadding
            } else {
                return self.tg_leadingPadding
            }
        }
        set {
            if TGViewSizeClassImpl.IsRTL {
                self.tg_trailingPadding = newValue
            } else {
                self.tg_leadingPadding = newValue
            }
        }
    }

    public var tg_rightPadding: CGFloat {
        get {
            if TGViewSizeClassImpl.IsRTL {
                return self.tg_leadingPadding
            } else {
                return self.tg_trailingPadding
            }
        }
        set {
            if TGViewSizeClassImpl.IsRTL {
                self.tg_leadingPadding = newValue
            } else {
                self.tg_trailingPadding = newValue
            }
        }
    }

    public var tg_zeroPadding: Bool = true

    public var tg_insetsPaddingFromSafeArea: UIRectEdge = [UIRectEdge.left, UIRectEdge.right]
    public var tg_insetLandscapeFringePadding: Bool = false

    public var tg_vspace: CGFloat = 0
    public var tg_hspace: CGFloat = 0

    public var tg_space: CGFloat {
        get {
            return self.tg_vspace
        } set {
            self.tg_vspace = newValue
            self.tg_hspace = newValue
        }
    }

    public var tg_reverseLayout: Bool = false
    public var tg_gravity: TGGravity = TGGravity.none

    public var tg_layoutTransform: CGAffineTransform = CGAffineTransform.identity

    internal var tgTopPadding: CGFloat {
        if self.tg_topPadding >= TGLayoutPos.tg_safeAreaMargin - 2000 && self.tg_topPadding <= TGLayoutPos.tg_safeAreaMargin + 2000 {
            var topPaddingAdd: CGFloat = 20.0  //默认状态栏的高度
            if #available(iOS 11.0, *) {

                topPaddingAdd = self.view.safeAreaInsets.top
            }

            return self.tg_topPadding - TGLayoutPos.tg_safeAreaMargin + topPaddingAdd
        }

        if (self.tg_insetsPaddingFromSafeArea.rawValue & UIRectEdge.top.rawValue) == UIRectEdge.top.rawValue {
            if #available(iOS 11.0, *) {
                return self.tg_topPadding + self.view.safeAreaInsets.top
            }
        }
        return self.tg_topPadding
    }

    internal var tgLeadingPadding: CGFloat {
        if self.tg_leadingPadding >= TGLayoutPos.tg_safeAreaMargin - 2000 && self.tg_leadingPadding <= TGLayoutPos.tg_safeAreaMargin + 2000 {
            var leadingPaddingAdd: CGFloat = 0.0

            if #available(iOS 11.0, *) {
                leadingPaddingAdd = self.view.safeAreaInsets.left  //因为不管是否是rtl左右的安全区都是一致的所以这里不需要进行区分。
            }
            return self.tg_leadingPadding - TGLayoutPos.tg_safeAreaMargin + leadingPaddingAdd
        }

        var inset: CGFloat = 0

        if #available(iOS 11.0, *) {

            var edge: UIRectEdge
            var devori: UIDeviceOrientation
            if TGViewSizeClassImpl.IsRTL {
                edge = UIRectEdge.right
                devori = UIDeviceOrientation.landscapeLeft
            } else {
                edge = UIRectEdge.left
                devori = UIDeviceOrientation.landscapeRight
            }

            if (self.tg_insetsPaddingFromSafeArea.rawValue & edge.rawValue) == edge.rawValue {
                //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是右边那么就不缩进了。
                if self.tg_insetLandscapeFringePadding &&
                    (self.tg_insetsPaddingFromSafeArea.rawValue & (UIRectEdge.left.rawValue | UIRectEdge.right.rawValue)) == (UIRectEdge.left.rawValue | UIRectEdge.right.rawValue) &&
                    UIDevice.current.orientation == devori {
                    inset = 0
                } else {
                    if TGViewSizeClassImpl.IsRTL {
                        inset = self.view.safeAreaInsets.right
                    } else {
                        inset = self.view.safeAreaInsets.left
                    }
                }
            }
        }

        if TGViewSizeClassImpl.IsRTL {
            return self.tg_rightPadding + inset
        } else {
            return self.tg_leftPadding + inset
        }
    }

    internal var tgBottomPadding: CGFloat {
        if self.tg_bottomPadding >= TGLayoutPos.tg_safeAreaMargin - 2000 && self.tg_bottomPadding <= TGLayoutPos.tg_safeAreaMargin + 2000 {
            var bottomPaddingAdd: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                bottomPaddingAdd = self.view.safeAreaInsets.bottom
            }
            return self.tg_bottomPadding - TGLayoutPos.tg_safeAreaMargin + bottomPaddingAdd
        }

        if (self.tg_insetsPaddingFromSafeArea.rawValue & UIRectEdge.bottom.rawValue) == UIRectEdge.bottom.rawValue {
            if #available(iOS 11.0, *) {
                return self.tg_bottomPadding + self.view.safeAreaInsets.bottom
            }
        }
        return self.tg_bottomPadding
    }

    internal var tgTrailingPadding: CGFloat {
        if self.tg_trailingPadding >= TGLayoutPos.tg_safeAreaMargin - 2000 && self.tg_trailingPadding <= TGLayoutPos.tg_safeAreaMargin + 2000 {
            var trailingPaddingAdd: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                trailingPaddingAdd = self.view.safeAreaInsets.right
            }

            return self.tg_trailingPadding - TGLayoutPos.tg_safeAreaMargin + trailingPaddingAdd
        }

        var inset: CGFloat = 0

        if #available(iOS 11.0, *) {

            var edge: UIRectEdge
            var devori: UIDeviceOrientation
            if TGViewSizeClassImpl.IsRTL {
                edge = UIRectEdge.left
                devori = UIDeviceOrientation.landscapeRight
            } else {
                edge = UIRectEdge.right
                devori = UIDeviceOrientation.landscapeLeft
            }

            if (self.tg_insetsPaddingFromSafeArea.rawValue & edge.rawValue) == edge.rawValue {
                //如果只缩进刘海那一边。并且同时设置了左右缩进，并且当前刘海方向是右边那么就不缩进了。
                if self.tg_insetLandscapeFringePadding &&
                    (self.tg_insetsPaddingFromSafeArea.rawValue & (UIRectEdge.left.rawValue | UIRectEdge.right.rawValue)) == (UIRectEdge.left.rawValue | UIRectEdge.right.rawValue) &&
                    UIDevice.current.orientation == devori {
                    inset = 0
                } else {
                    if TGViewSizeClassImpl.IsRTL {
                        inset = self.view.safeAreaInsets.left
                    } else {
                        inset = self.view.safeAreaInsets.right
                    }
                }
            }
        }

        if TGViewSizeClassImpl.IsRTL {
            return self.tg_leftPadding + inset
        } else {
            return self.tg_rightPadding + inset
        }
    }

    internal var tgLeftPadding: CGFloat {
        return TGLayoutViewSizeClassImpl.IsRTL ? self.tgTrailingPadding : self.tgLeadingPadding
    }

    internal var tgRightPadding: CGFloat {
        return TGLayoutViewSizeClassImpl.IsRTL ? self.tgLeadingPadding : self.tgTrailingPadding
    }

    public override func copy(with zone: NSZone?) -> Any {
        let tsc = super.copy(with: zone) as! TGLayoutViewSizeClassImpl

        tsc.tg_topPadding = self.tgTopPadding
        tsc.tg_leadingPadding = self.tg_leadingPadding
        tsc.tg_bottomPadding = self.tg_bottomPadding
        tsc.tg_trailingPadding = self.tg_trailingPadding
        tsc.tg_zeroPadding = self.tg_zeroPadding
        tsc.tg_insetsPaddingFromSafeArea = self.tg_insetsPaddingFromSafeArea
        tsc.tg_insetLandscapeFringePadding = self.tg_insetLandscapeFringePadding
        tsc.tg_vspace = self.tg_vspace
        tsc.tg_hspace = self.tg_hspace
        tsc.tg_reverseLayout = self.tg_reverseLayout
        tsc.tg_gravity = self.tg_gravity
        tsc.tg_layoutTransform = self.tg_layoutTransform
        return tsc
    }

}

internal struct TGSequentLayoutFlexSpace {
    var subviewSize: CGFloat = 0
    var minSpace: CGFloat = 0
    var maxSpace: CGFloat = CGFloat.greatestFiniteMagnitude
    var centered: Bool = false

    func calcMaxMinSubviewSizeForContent(_ containerSize: CGFloat, startPadding: CGFloat, endPadding: CGFloat, space: CGFloat) -> (CGFloat, CGFloat, CGFloat, CGFloat) {

        var subviewSize: CGFloat = self.subviewSize
        var startPadding: CGFloat = startPadding
        var endPadding: CGFloat = endPadding
        var space: CGFloat = space

        var extralSpace = self.minSpace
        if self.centered {
            extralSpace *= -1
        }

        let rowCount =  max(floor((containerSize - startPadding - endPadding + extralSpace) / (subviewSize + self.minSpace)), 1)
        var spaceCount = rowCount - 1
        if self.centered {
            spaceCount += 2
        }

        if spaceCount > 0 {
            space = (containerSize - startPadding - endPadding - subviewSize * rowCount) / spaceCount

            if _tgCGFloatGreat(space, self.maxSpace) {
                space = self.maxSpace
                subviewSize =  (containerSize - startPadding - endPadding - space * spaceCount) / rowCount
            }

            if self.centered {
                startPadding += space
                endPadding += space
            }
        }

        return (subviewSize, startPadding, endPadding, space)
    }

    func calcMaxMinSubviewSize(_ containerSize: CGFloat, arrangedCount: Int, startPadding: CGFloat, endPadding: CGFloat, space: CGFloat) -> (CGFloat, CGFloat, CGFloat, CGFloat) {

        var subviewSize: CGFloat = self.subviewSize
        var startPadding: CGFloat = startPadding
        var endPadding: CGFloat = endPadding
        var space: CGFloat = space

        var spaceCount: Int = arrangedCount - 1
        if self.centered {
            spaceCount += 2
        }

        if spaceCount > 0 {
            space = (containerSize - startPadding - endPadding - subviewSize * CGFloat(arrangedCount))/CGFloat(spaceCount)

            if _tgCGFloatGreat(space, self.maxSpace) || _tgCGFloatLess(space, self.minSpace) {
                if _tgCGFloatGreat(space, self.maxSpace) {
                    space = self.maxSpace
                }

                if _tgCGFloatLess(space, self.minSpace) {
                    space = self.minSpace
                }

                subviewSize =  (containerSize - startPadding - endPadding - space * CGFloat(spaceCount)) / CGFloat(arrangedCount)
            }

            if self.centered {
                startPadding += space
                endPadding += space
            }
        }

        return (subviewSize, startPadding, endPadding, space)
    }
}

public extension TGTypeWrapperProtocol where TGWrappedType: TGSequentLayoutViewSizeClassImpl {
    func orientation(value: TGOrientation) {
        self.wrappedValue.tg_orientation = value
    }

    func orientation() -> TGOrientation {
        return self.wrappedValue.tg_orientation
    }
}

public class TGSequentLayoutViewSizeClassImpl: TGLayoutViewSizeClassImpl, TGSequentLayoutViewSizeClass {
    public var tg_orientation: TGOrientation = TGOrientation.vert
    var tgFlexSpace: TGSequentLayoutFlexSpace! = nil

    public override func copy(with zone: NSZone?) -> Any {
        let tsc = super.copy(with: zone) as! TGSequentLayoutViewSizeClassImpl
        tsc.tg_orientation = self.tg_orientation
        if let t = self.tgFlexSpace {
            tsc.tgFlexSpace = TGSequentLayoutFlexSpace()
            tsc.tgFlexSpace.subviewSize = t.subviewSize
            tsc.tgFlexSpace.minSpace = t.minSpace
            tsc.tgFlexSpace.maxSpace = t.maxSpace
            tsc.tgFlexSpace.centered = t.centered
        }
        return tsc
    }
}

public extension TGTypeWrapperProtocol where TGWrappedType: TGLinearLayoutViewSizeClassImpl {
    func shrinkType(value: TGSubviewsShrinkType) {
        self.wrappedValue.tg_shrinkType = value
    }

    func shrinkType() -> TGSubviewsShrinkType {
        return self.wrappedValue.tg_shrinkType
    }
}

public class TGLinearLayoutViewSizeClassImpl: TGSequentLayoutViewSizeClassImpl, TGLinearLayoutViewSizeClass {
    public var tg_shrinkType: TGSubviewsShrinkType = TGSubviewsShrinkType.none
    public override func copy(with zone: NSZone?) -> Any {
        let tsc = super.copy(with: zone) as! TGLinearLayoutViewSizeClassImpl
        tsc.tg_shrinkType = self.tg_shrinkType
        return tsc
    }
}

public class TGTableLayoutViewSizeClassImpl: TGLinearLayoutViewSizeClassImpl, TGTableLayoutViewSizeClass {}

public extension TGTypeWrapperProtocol where TGWrappedType: TGFloatLayoutViewSizeClassImpl {
    func noBoundaryLimit(value: Bool) {
        self.wrappedValue.tg_noBoundaryLimit = value
    }

    func noBoundaryLimit() -> Bool {
        return self.wrappedValue.tg_noBoundaryLimit
    }
}

public class TGFloatLayoutViewSizeClassImpl: TGSequentLayoutViewSizeClassImpl, TGFloatLayoutViewSizeClass {
    public var tg_noBoundaryLimit: Bool = false

    public override func copy(with zone: NSZone?) -> Any {
        let tsc = super.copy(with: zone) as! TGFloatLayoutViewSizeClassImpl
        tsc.tg_noBoundaryLimit = self.tg_noBoundaryLimit
        return tsc
    }
}

public extension TGTypeWrapperProtocol where TGWrappedType: TGFlowLayoutViewSizeClassImpl {
    func arrangedCount(value: Int) {
        self.wrappedValue.tg_arrangedCount = value
    }

    func arrangedCount() -> Int {
        return self.wrappedValue.tg_arrangedCount
    }

    func pagedCount(value: Int) {
        self.wrappedValue.tg_pagedCount = value
    }

    func pagedCount() -> Int {
        return self.wrappedValue.tg_pagedCount
    }

    func autoArrange(value: Bool) {
        self.wrappedValue.tg_autoArrange = value
    }

    func autoArrange() -> Bool {
        return self.wrappedValue.tg_autoArrange
    }

    func arrangedGravity(value: TGGravity) {
        self.wrappedValue.tg_arrangedGravity = value
    }

    func arrangedGravity() -> TGGravity {
        return self.wrappedValue.tg_arrangedGravity
    }

    func lastlineGravityPolicy(value: TGGravityPolicy) {
        self.wrappedValue.tg_lastlineGravityPolicy = value
    }

    func lastlineGravityPolicy() -> TGGravityPolicy {
        return self.wrappedValue.tg_lastlineGravityPolicy
    }
}

public class TGFlowLayoutViewSizeClassImpl: TGSequentLayoutViewSizeClassImpl, TGFlowLayoutViewSizeClass {
    public var tg_arrangedCount: Int = 0
    public var tg_pagedCount: Int = 0
    public var tg_arrangedGravity: TGGravity = TGGravity.none
    public var tg_lastlineGravityPolicy: TGGravityPolicy = TGGravityPolicy.no
    public var tg_autoArrange: Bool = false

    public override func copy(with zone: NSZone?) -> Any {
        let tsc = super.copy(with: zone) as! TGFlowLayoutViewSizeClassImpl
        tsc.tg_arrangedCount = self.tg_arrangedCount
        tsc.tg_pagedCount = self.tg_pagedCount
        tsc.tg_arrangedGravity = self.tg_arrangedGravity
        tsc.tg_lastlineGravityPolicy = self.tg_lastlineGravityPolicy
        tsc.tg_autoArrange = self.tg_autoArrange
        return tsc
    }
}

public extension TGTypeWrapperProtocol where TGWrappedType: TGFrameLayoutViewSizeClassImpl {

}

public class TGFrameLayoutViewSizeClassImpl: TGLayoutViewSizeClassImpl, TGFrameLayoutViewSizeClass {}

public extension TGTypeWrapperProtocol where TGWrappedType: TGFrameLayoutViewSizeClassImpl {

}

public class TGRelativeLayoutViewSizeClassImpl: TGLayoutViewSizeClassImpl, TGRelativeLayoutViewSizeClass {}

public extension TGTypeWrapperProtocol where TGWrappedType: TGFrameLayoutViewSizeClassImpl {

}

public class TGPathLayoutViewSizeClassImpl: TGLayoutViewSizeClassImpl, TGPathLayoutViewSizeClass {}

protocol TGLayoutPosValue2: TGLayoutPosValue {

    var realPos: TGLayoutPos! {get set}

    var floatNumber: CGFloat {get}
}

protocol TGLayoutSizeValue2: TGLayoutSizeValue {

    var realSize: TGLayoutSize! {get set}

    func isRelaSizeEqualTo(_ size: TGLayoutSizeValue2) -> Bool

    func isDependOther(_ size: TGLayoutSizeValue2) -> Bool

}

internal class TGLayoutPosWrapper: TGLayoutPosValue2 {
    var realPos: TGLayoutPos! = nil

    var hasValue: Bool {
        guard let p = self.realPos else {
            return false
        }

        return p.hasValue
    }

    var numberVal: CGFloat! {
        guard let p = self.realPos else {
            return nil
        }

        return p.numberVal
    }

    var floatNumber: CGFloat {
        guard let p = self.realPos else {
            return 0
        }

        if let t = p.numberVal {
            return t
        } else {
            return 0
        }

    }

    var weightVal: TGWeight! {
        guard let p = self.realPos else {
            return nil
        }

        return p.weightVal

    }

    var posVal: TGLayoutPos! {
        guard let p = self.realPos else {
            return nil
        }

        return p.posVal
    }

    var arrayVal: [TGLayoutPos]! {
        guard let p = self.realPos else {
            return nil
        }

        return p.arrayVal
    }

    var offset: CGFloat {
        guard let p = self.realPos else {
            return 0
        }

        return p.offset
    }

    var minVal: TGLayoutPos? {
        guard let p = self.realPos else {
            return nil
        }

        return p.min
    }

    var maxVal: TGLayoutPos? {
        guard let p = self.realPos else {
            return nil
        }

        return p.maxVal

    }

    var absPos: CGFloat {
        guard let p = self.realPos else {
            return 0
        }

        return p.absPos
    }

    var isSafeAreaPos: Bool {
        guard let p = self.realPos else {
            return false
        }

        return p.isSafeAreaPos
    }

    func weightPosIn(_ contentSize: CGFloat) -> CGFloat {
        guard let p = self.realPos else {
            return 0
        }

        return p.weightPosIn(contentSize)
    }
}

internal class TGLayoutSizeWrapper: TGLayoutSizeValue2 {
    var realSize: TGLayoutSize! = nil

    var hasValue: Bool {
        guard let p = self.realSize else {
            return false
        }

        return p.hasValue
    }

    var isWrap: Bool {
        guard let p = self.realSize else {
            return false
        }

        return p.isWrap
    }

    var isFill: Bool {
        guard let p = self.realSize else {
            return false
        }

        return p.isFill
    }

    var numberVal: CGFloat! {

        guard let p = self.realSize else {
            return nil
        }

        return p.numberVal

    }

    var sizeVal: TGLayoutSize! {

        guard let p = self.realSize else {
            return nil
        }

        return p.sizeVal
    }

    var arrayVal: [TGLayoutSize]! {

        guard let p = self.realSize else {
            return nil
        }

        return p.arrayVal

    }

    var weightVal: TGWeight! {

        guard let p = self.realSize else {
            return nil
        }

        return p.weightVal
    }

    var increment: CGFloat {

        guard let p = self.realSize else {
            return 0
        }

        return p.increment
    }

    var multiple: CGFloat {

        guard let p = self.realSize else {
            return 1
        }

        return p.multiple
    }

    var minVal: TGLayoutSize? {

        guard let p = self.realSize else {
            return nil
        }

        return p.minVal
    }

    var maxVal: TGLayoutSize? {

        guard let p = self.realSize else {
            return nil
        }

        return p.maxVal

    }

    var isFlexHeight: Bool {
        guard let p = self.realSize else {
            return false
        }

        return p.isFlexHeight
    }

    var measure: CGFloat {
        guard let p = self.realSize else {
            return 0
        }

        return p.measure
    }

    func measure(_ size: CGFloat) -> CGFloat {
        guard let p = self.realSize else {
            return size
        }

        return p.measure(size)
    }

    func isRelaSizeEqualTo(_ size: TGLayoutSizeValue2) -> Bool {
        guard let p = self.realSize else {
            return false
        }

        guard let rela = p.sizeVal else {
            return false
        }

        return rela === size.realSize
    }

    func isDependOther(_ size: TGLayoutSizeValue2) -> Bool {

        guard let p = self.realSize else {
            return false
        }

        return p.isFill || p.weightVal != nil || (p.sizeVal != nil && p.sizeVal === size.realSize)

    }

    func numberSize(_ size: CGFloat) -> CGFloat {
        guard let p = self.realSize else {
            return size
        }

        return p.numberSize(size)
    }

    func fillSize(_ size: CGFloat, in containerSize: CGFloat) -> CGFloat {
        guard let p = self.realSize else {
            return size
        }

        return p.fillSize(size, in: containerSize)
    }

    func weightSize(_ size: CGFloat, in containerSize: CGFloat) -> CGFloat {
        guard let p = self.realSize else {
            return size
        }

        return p.weightSize(size, in: containerSize)
    }

    func resetValue() {

        if let p = self.realSize {
            p.resetValue()
        }
    }

}

#endif
