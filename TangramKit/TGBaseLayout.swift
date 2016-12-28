//
//  TGBaseLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

/**
 * 定义SizeClass中普通视图的布局属性
 */
extension UIView:TGViewSizeClass
{
    
    /*
     视图的布局位置对象属性，用来指定视图水平布局位置和垂直布局位置。对于一个视图来说我们可以使用frame属性中的origin部分来确定一个视图的左上方位在父视图的位置。这种方法的缺点是需要明确的指定一个常数值，以及需要进行位置的计算，缺乏可扩展性以及可维护性。因此对于布局视图里面的子视图来说我们将不再通过设置frame属性中的origin部分来确定位置，而是通过视图扩展的布局位置对象属性来设置视图的布局位置。子视图的布局位置对象在不同类型的布局视图里和不同的场景下所表达的意义以及能设置的值类型将会有一定的差异性。下面的表格将列出这些差异性：
     
     +--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------+
     |                    |Scene1            | Scene2               |Scene3         |Scene4     |Scene5              |Scene6 |Scene7 |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Vert TGLinearLayout |   L,R,CX         | T,B                  | L,R,CX,T,B    |    -      |    -               | L,R   | -     |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Horz TGLinearLayout |   T,B,CY         | L,R                  | L,R,T,B,CY    |    -      |    -               |  -    |T,B    |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Vert TGTableLayout  |   T,B,CY         | L,R                  | L,R,T,B,CY    |    -      |    -               |  -    |T,B    |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Horz TGTableLayout  |   L,R,CX         | T,B                  | L,R,CX,T,B    |    -      |    -               | L,R   |	-    |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |TGFrameLayout       |   ALL            |  -                   | L,R,T,B,CX,CY |    -      |    -               |  -    | -     |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |TGRelativeLayout    |   ALL            |  -                   |  -            |   ALL     |   CX,CY            | L,R   |T,B    |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Vert TGFlowLayout   |   -              | T,B,R,L              |  -            |   -       |   -                | -     | -     |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Horz TGFlowLayout   |   -              | T,B,R,L              |  -            |   -       |    -               | -     | -     |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Vert TGFloatLayout  |   -              | T,B,R,L              |  -            |   -       |    -               | -     | -     |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |Horz TGFloatLayout  |   -              | T,B,R,L              |  -            |   -       |    -               | -	 | -     |
     |--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------|
     |TGPathLayout        |   -              | T,L                  |  -            |   -       |    -               | -	 | -     |
     +--------------------+------------------+----------------------+---------------+-----------+--------------------+-------+-------+
     
     *上面表格中L=tg_left, R=tg_right, T=tg_top, B=tg_bottom,CX=tg_centerX,CY=tg_centerY,ALL是所有布局位置对象,-表示不支持。
     *Scene表示在这种场景下支持的布局位置对象的种类，以及设置的值所表达的意义。
     比如上表中的行Vert TGLinearLayout,列Scene1中的值 L,R,CX 的意思是垂直线性布局下的子视图的tg_left,tg_right,tg_centerX的位置值设置为数值时表示的是子视图的左右边距以及水平中心点在父布局下的中心点边距。
     
     Scene1:布局位置对象的值设置为数值,且表示他离父视图的边距。所谓边距就是指子视图跟父视图之间的距离。
     比如A.tg_left.equal(10)表示A的左边距是10，也就是A视图的左边和父视图的左边距离10个点。
     
     Scene2:布局位置对象的值设置为数值,且表示的是视图之间的间距。所谓间距就是指视图和其他视图之间的距离。这里要注意边距和间距的区别，边距是子视图和父视图之间的距离，间距是子视图和兄弟视图之间的距离。
     比如垂直线性布局视图L分别添加了A,B两个子视图则设置A.tg_top.equal(10),A.tg_bottom.equal(10),B.tg_top.equal(10)的意思是A的顶部间距是10，底部间距也是10。视图B的顶部间距10。这样视图B和视图A之间的间距就是20
     Scene3:布局位置对象的值设置为TGWeight,表示的是相对比例值,表示视图之间的相对距离。
     相对距离的最终距离 = (布局视图尺寸 - 所有固定尺寸和间距的视图) * 当前视图的相对距离 /(所有子视图相对距离的总和)
     
     Scene4:布局位置对象的值设置为TGLayoutPos对象，表示某个位置依赖于另外一个位置。只有在相对布局中的子视图的布局位置对象的位置值才能设置为TGLayoutPos对象。
     比如： A.tg_left.equal(B.tg_right)表示视图A的左边等于视图B的右边。
     
     Scene5:布局位置对象的值设置为[TGLayoutPos]数组对象，表示一组视图整体居中。只有在相对布局中的子视图的tg_centerX或者tg_centerY中的位置值才可以被设置为这种值。
     比如：A.tg_centerX.equal([B.tg_centerX,C.tg_centerX])表示A,B,C三个子视图在相对布局中整体水平居中。
     
     Scene6:当同时设置了tg_left和tg_right左右边距后就能确定出视图的布局宽度了，这样就不需要为子视图指定布局宽度值了。需要注意的是只有同时设置了左右边距才能确定视图的宽度，而设置左右间距时则不能。
     比如：某个布局布局视图的宽度是100，而某个子视图的tg_left.equal(10),tg_right.equal(20).则这个子视图的宽度=70(100-10-20)
     
     Scene7:当同时设置了tg_top和tg_bottom上下边距后就能确定出视图的布局高度了，这样就不需要为子视图指定布局高度值了。需要注意的是只有同时设置了上下边距才能确定视图的高度，而设置上下间距是则不能。
     比如：某个布局布局视图高度是100，而某个子视图的tg_top.equal(10),tg_bottom.equal(20).则这个子视图的高度=70(100-10-20)
     
     */

    
    /**
     *视图的左边布局位置对象。(left layout position of the view.)
     */
    public var tg_left:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_left.belong(to:self)
    }
    
    /**
     *视图的上边布局位置对象。(top layout position of the view.)
     */
    public var tg_top:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_top.belong(to:self)
    }
    
    /**
     *视图的右边布局位置对象。(right layout position of the view.)
     */
    public var tg_right:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_right.belong(to:self)
    }
    
    /**
     *视图的下边布局位置对象。(bottom layout position of the view.)
     */
    public var tg_bottom:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_bottom.belong(to:self)
    }
    
    /**
     *视图的水平中心布局位置对象。(horizontal center layout position of the view.)
     */
    public var tg_centerX:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_centerX.belong(to:self)
    }
    
    /**
     *视图的垂直中心布局位置对象。(vertical center layout position of the view.)
     */
    public var tg_centerY:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_centerY.belong(to:self)
    }
    
    /*
     视图的布局尺寸对象TGLayoutSize,用于设置视图的宽度和高度尺寸。视图可以通过设置frame值来设置自身的尺寸，也可以通过设置tg_width和tg_height来
     设置布局尺寸，通过frame设置的结果会立即生效，而通过tg_width和tg_height设置则会在布局后才生效，如果同时设置了frame值和TGLayoutSize值则TGLayoutSize的设置值优先。
     
     其中的equal方法可用于设置布局尺寸的具体值：
     1.如果设置为CGFloat则表示布局尺寸是一个具体的数值。比如tg_width.equal(20)表示视图的宽度设置为20个点。
     2.如果设置为TGWeight则表示布局尺寸是一个相对的比例值。比如tg_width.equal(20%)则表示视图的宽度占用父视图剩余空间的20%
     3.如果设置为TGLayoutSize则表示布局尺寸依赖于另外一个视图的布局尺寸。比如A.tg_width.equal(B.tg_width)表示A的宽度和B的宽度相等
     4.如果设置为.wrap则表示视图的布局尺寸依赖于自身的内容来决定，也就是包裹属性。比如A.tg_width.equal(.wrap)表示宽度由自身的内容或者子视图的尺寸决定。
     5.如果设置为.fill则表示视图的布局尺寸占用父视图剩余空间，也就是填充属性。比如A.tg_width.equal(.fill)表示宽度等于父视图的剩余宽度。
     5.如果设置为[TGLayoutSize]则表示视图和数组里面的视图均分布局视图的宽度或者高度。比如A.tg_width.equal([B.tg_width,C.tg_width])表示视图A,B,C三个视图均分父视图的宽度。
     6.如果设置为nil则表示取消布局尺寸的值的设置。
     
     其中equal的increment参数以及add方法可以用于设置布局尺寸的增加值。比如A.tg_width.equal(B.tg_width,increment:20)表示视图A的宽度等于视图B的宽度再加上20个点。
     
     其中的equalmultiple参数以及multiply方法可用于设置布局尺寸放大的倍数值。比如A.tg_width.equal(B.tg_width,multiple:2)表示视图A的宽度是视图B的宽度的2倍。
     
     其中的min,max方法表示用来设置布局尺寸的最大最小值。比如A.tg_width.min(10) A.tg_width.max(40)表示宽度的最小是10最大是40。
     
     下面的表格描述了在各种布局下的子视图的布局尺寸对象的equal方法可以设置的值。
     为了表示方便我们把：
     线性布局简写为L、垂直线性布局简写为L-V、水平线性布局简写为L-H 相对布局简写为R、表格布局简写为T、框架布局简写为FR、
     流式布局简写为FL、垂直流式布局简写为FL-V，水平流式布局简写为FL-H、浮动布局简写为FO、左右浮动布局简写为FO-V、上下浮动布局简写为FO-H、
     路径布局简写为P、全部简写为ALL，不支持为-，
     
     定义A为操作的视图本身，B为A的兄弟视图，S为A的父视图。
+-----------+-------+--------+----+----+----------------+------------+----------+-----------+--------------+--------------+--------------+
| 对象 \ 值  |CGFloat|TGWeight|wrap|fill|A.tg_width      |A.tg_height |B.tg_width|B.tg_height|S.tg_width    |S.tg_heigh    |[TGLayoutSize]|
+-----------+-------+--------+----+----+----------------+------------+----------+-----------+-----------------------------+--------------+
|A.tg_width |ALL    |ALL     |ALL |ALL | -   	        |FR/R/FL-H/FO|FR/R/FO/P | R	        |ALL           | R	          |R             |
+-----------+-------+--------+----+----+----------------+------------+----------+--------------------------+--------------+--------------+
|A.tg_height|ALL    |ALL     |ALL |ALL |FR/R/FL-V/FO/L-V|-           |R	        |FR/R/FO/P  |R             |ALL           |R             |
+-----------+-------+--------+----+----+----------------+------------+----------+-----------+--------------+-----------------------------+
     
     这里面重点介绍TGWeight，wrap,fill三种类型的值设置。
     其中的TGWeight是指设置的值为相对值，表示占用父视图或者剩余尺寸的比例，具体是父视图空间比例还是剩余空间比例则需要根据布局视图的类型来决定，下面列出了各种布局视图下的TGWeight设置的意义：
         父视图宽度比例： FR, L-V,R
         父视图剩余宽度比例：L-H, FL, FO
         父视图高度比例： FR, L-H,R
         父视图剩余高度比例：L-V, FL, FO
     
     假如某个框架布局下面的子视图A，希望其宽度是父视图宽度的50%，那么就可以设置 A.tg_width.equal(50%)
     假如某个线性布局下面的子视图A,B， 其中父视图的高度为100， A子视图的高度为20， 而B视图想占用剩余的高度则可以设置B.tg_height.equal(100%)
     这里的%运算符，是对TGWeight类型对象简化操作，比如下面是等价的：
        a.tg_width.equal(TGWeight(100)) <==> a.tg_width.equal(100%) <==> a.tg_width ~= 100%
          
     
     .wrap属性值则表示视图的尺寸是有内容或者其子视图来决定的。比如UILabel的宽度希望由自身的内容决定，那么就可以设置tg_width.equal(.wrap),同样对于布局视图也是一样的，这里的wrap对于布局视图来说其实就是OC版本的wrapContentWidth和wrapContentHeight的概念。如果某个子视图的宽度是固定的，而高度则会动态伸缩则我们可以定义如下：
            let label = UILabel()
            label.tg_width ~= 100
            label.tg_height ~=.wrap
            label.numberOflines = 0
     
      同样如果一个线性布局里面的宽度和高度都希望由子视图决定则可以如下处理：
            let l = TGLinearLayout(.vert)
            l.tg_width.equal(.wrap)
            l.tg_height.equal(.wrap)
     
     
     .fill属性则表示视图的尺寸会填充父视图的剩余空间，这个和TGWeight(100)是等价的。比如某个子视图的宽度想填充父视图的宽度相等则：
             a.tg_width.equal(.fill)  <==>  a.tg_width.equal(100%)
     
*/

    
    
    /**
     *视图的宽度布局尺寸对象，可以通过其中的euqal方法来设置CGFloat,TGLayoutSize,[MyLayoutSize],TGWeight,TGLayoutSize.Special,nil这六种值
     */
    public var tg_width:TGLayoutSize
    {
        return self.tgCurrentSizeClass.tg_width.belong(to: self)
    }
    
    /**
     *视图的高度布局尺寸对象，可以通过其中的euqal方法来设置CGFloat,TGLayoutSize,[MyLayoutSize],TGWeight,TGLayoutSize.Special,nil这六种值
     */
    public var tg_height:TGLayoutSize
    {
        return self.tgCurrentSizeClass.tg_height.belong(to: self)
    }
    
    /**
     *设置视图不受布局视图的布局约束控制，所有的视图扩展属性失效而是用自身原始的frame的设置值来进行定位和布局，默认值是false。这个属性一般用来实现视图在特定场景下的动画效果，以及可以和布局视图的autoresizesSubviews方法配合使用来实现一些特殊功能。
     */
    public var tg_useFrame:Bool
        {
        get
        {
            return self.tgCurrentSizeClass.tg_useFrame
        }
        set
        {
            let sc = self.tgCurrentSizeClass
            if sc.tg_useFrame != newValue
            {
                sc.tg_useFrame = newValue
                if let sView = self.superview
                {
                    sView.setNeedsLayout()
                }
            }
            
        }
    }
    
    /**
     *设置视图在进行布局时只占位置而不真实的调整位置和尺寸。也就是视图的真实位置和尺寸不变，但在布局视图布局时会保留出子视图的布局位置和布局尺寸的空间，这个属性通常和tg_useFrame混合使用来实现一些动画特效。通常在处理时设置：tg_noLayout为true同时tg_useFrame为false时布局时视图的frame是不会改变的，而当tg_useFrame设置为true时则tg_noLayout属性无效。
     */
    public var tg_noLayout:Bool
        {
        get
        {
            return self.tgCurrentSizeClass.tg_noLayout
        }
        set
        {
            let sc = self.tgCurrentSizeClass
            if sc.tg_noLayout != newValue
            {
                
                sc.tg_noLayout = newValue
                if let sView = self.superview
                {
                    sView.setNeedsLayout()
                }
            }
            
        }
    }
}

//视图的布局扩展方法。
extension UIView
{
    //设置左上角位置tg_left,tg_top的快捷方法。
    public func tg_origin(_ point:CGPoint)
    {
        self.tg_left.equal(point.x)
        self.tg_top.equal(point.y)
    }
    
    public func tg_origin(x:TGLayoutPosType, y:TGLayoutPosType)
    {
        self.tg_left.tgEqual(val: x)
        self.tg_top.tgEqual(val: y)
    }
    
    //设置右下角位置tg_right,tg_bottom的快捷方式
    public func tg_end(_ point:CGPoint)
    {
        self.tg_right.equal(point.x)
        self.tg_bottom.equal(point.y)
    }
    
    public func tg_end(x:TGLayoutPosType, y:TGLayoutPosType)
    {
        self.tg_right.tgEqual(val:x)
        self.tg_bottom.tgEqual(val:y)
    }
    
    //同时设置tg_width和tg_height的简化方法。
    public func tg_size(_ size: CGSize)
    {
        self.tg_width.equal(size.width)
        self.tg_height.equal(size.height)
    }
    
    public func tg_size(width:TGLayoutSize, height:TGLayoutSize)
    {
        self.tg_width.equal(width)
        self.tg_height.equal(height)
    }
    
    public func tg_size(width:TGLayoutSizeType, height:TGLayoutSize)
    {
        self.tg_width.tgEqual(val: width)
        self.tg_height.equal(height)
    }
    
    public func tg_size(width:TGLayoutSize, height:TGLayoutSizeType)
    {
        self.tg_width.equal(width)
        self.tg_height.tgEqual(val: height)
    }
    
    public func tg_size(width:TGLayoutSizeType, height:TGLayoutSizeType)
    {
        self.tg_width.tgEqual(val: width)
        self.tg_height.tgEqual(val: height)
    }
    

    
    /**
     *视图的评估frame值。评估frame值是在布局前评估计算的值，而frame则是视图真正完成布局后的真实值。在调用这个方法前请先调用父布局视图的tg_sizeThatFits方法进行布局视图的尺寸评估，否则此方法返回的值未可知。这个方法主要用于在视图布局前而想得到其在父布局视图中的frame值的场景。
     */
    public var tg_estimatedFrame:CGRect
    {
        let rect = self.tgFrame.frame;
        if rect.origin.x == CGFloat.greatestFiniteMagnitude || rect.origin.y == CGFloat.greatestFiniteMagnitude
        {
            return self.frame
        }
        
        return rect;
    }
    
    /**
     *视图在布局视图中布局完成后执行的块，执行完动作后会被重置为nil。通过在tg_layoutCompletedDo的实现中我们可以得到这个视图真实的frame值。还可以设置一些属性，主要是用来实现一些动画特效。这里面layout就是父布局视图，而v就是视图本身，用这两个参数返回的目的是为了防止循环引用的问题.
     */
    public func tg_layoutCompletedDo(_ action:((_ layout:TGBaseLayout, _ view:UIView)->Void)?)
    {
        (self.tgCurrentSizeClass as! TGViewSizeClassImpl).tgLayoutCompletedAction = action
    }
    
    /**
     *清除所有为布局而设置的视图布局属性值。
     *@type: 清除某个MySizeClassType下设置的视图布局属性值。
     */
    public func tg_clearLayout(inSizeClass type:TGSizeClassType = .default)
    {
        if var dict:[Int:TGViewSizeClass] = objc_getAssociatedObject(self, &ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES) as? [Int:TGViewSizeClass]
        {
            dict.removeValue(forKey: self.tgIntFromSizeClassType(type))
            
        }
    }
    
    /**
     *获取视图在某个SizeClassType下的TGViewSizeClass对象。可以通过得到的TGViewSizeClass对象来设置视图在对应SizeClass下的各种布局约束属性。
     *@srcType:如果视图指定的type不存在则会拷贝srcType中定义的约束值，如果存在则不拷贝直接返回type中指定的SizeClass。
     */
    public func tg_fetchSizeClass(with type:TGSizeClassType, from srcType:TGSizeClassType! = nil) ->TGViewSizeClass
    {
        
        var dict:NSMutableDictionary! = objc_getAssociatedObject(self, &ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES) as? NSMutableDictionary
        
        if dict == nil
        {
            dict = NSMutableDictionary()
            objc_setAssociatedObject(self, &ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES, dict!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        let typeInt = self.tgIntFromSizeClassType(type)
        let srcTypeInt = self.tgIntFromSizeClassType(srcType)
        
        var sizeClass:TGViewSizeClass! = dict.object(forKey: typeInt) as? TGViewSizeClass
        if sizeClass == nil
        {
            let srcSizeClass:TGViewSizeClass? = dict.object(forKey: srcTypeInt) as? TGViewSizeClass
            if srcSizeClass == nil
            {
                sizeClass = self.tgCreateInstance() as! TGViewSizeClass
            }
            else
            {
                sizeClass = (srcSizeClass! as! NSObject).copy() as? TGViewSizeClass
            }
            
            dict.setObject(sizeClass!, forKey: typeInt as NSCopying)
        }
        
        return sizeClass!
    }
}

/**
 *布局视图边界线类，可用于布局视图的四周边界线的设置。
 */
public class TGLayoutBorderline:NSObject
{
    public init(color:UIColor, thick:CGFloat=1, dash:CGFloat = 0, headIndent:CGFloat = 0, tailIndent:CGFloat = 0)
    {
        self.color = color
        self.thick = thick
        self.dash = dash
        self.headIndent = headIndent
        self.tailIndent = tailIndent
        super.init()

    }

    //边界线颜色
    public var color:UIColor
    //边界线粗细
    public var thick:CGFloat = 1
    //边界线头部缩进单位
    public var headIndent:CGFloat = 0
    //边界线尾部缩进单位
    public var tailIndent:CGFloat = 0
    //设置边界线为点划线,如果是0则边界线是实线
    public var dash:CGFloat = 0
}



/*布局视图基类，基类不支持实例化对象*/
open class TGBaseLayout: UIView,TGLayoutViewSizeClass {
    
    /**
     * 设置布局视图四周的内边距值。所谓内边距是指布局视图内的所有子视图离布局视图四周的边距。通过为布局视图设置内边距可以减少为所有子视图设置外边距的工作，而外边距则是指视图离父视图四周的距离。
     */
    public var tg_padding:UIEdgeInsets
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_padding
        }
        set
        {
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_padding != newValue
            {
                sc.tg_padding = newValue
                setNeedsLayout()
            }
        }
        
    }
    
    //顶部内边距
    public var tg_topPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_topPadding
        }
        set
        {
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_topPadding != newValue
            {
                sc.tg_topPadding = newValue
                setNeedsLayout()
            }
        }
    }
    
    //左边内边距
    public var tg_leftPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_leftPadding
        }
        set
        {
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_leftPadding != newValue
            {
                sc.tg_leftPadding = newValue
                setNeedsLayout()
            }

        }
    }
    
    //底部内边距
    public var tg_bottomPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_bottomPadding
        }
        set
        {
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_bottomPadding != newValue
            {
                sc.tg_bottomPadding = newValue
                setNeedsLayout()
            }
        }
    }
    
    //右边内边距
    public var tg_rightPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_rightPadding
        }
        set
        {
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_rightPadding != newValue
            {
                sc.tg_rightPadding = newValue
                setNeedsLayout()
            }

        }
    }
    
    
    //定义布局视图内子视图之间的间距，所谓间距就是子视图之间的间隔距离。
    public var tg_space:CGFloat {
        get {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_space
        }
        set {
            
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_space != newValue
            {
                sc.tg_space = newValue
                self.tg_vspace = newValue
                self.tg_hspace = newValue
            }
        }
    }
    
    
    //定义布局视图内子视图之间的上下垂直间距。只有顺序布局这个属性才有意义。
    public var tg_vspace:CGFloat {
        get {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_vspace
        }
        set {
            
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_vspace != newValue
            {
                sc.tg_vspace = newValue
                setNeedsLayout()
            }

        }
    }
    
    //定义布局视图内子视图之间的左右水平间距。只有顺序布局这个属性才有意义。
    public var tg_hspace:CGFloat {
        get {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_hspace
        }
        set {
            
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_hspace != newValue
            {
                sc.tg_hspace = newValue
                setNeedsLayout()
            }
        }
    }

    /**
     *布局里面的所有子视图按添加的顺序逆序进行布局。默认是false。
     */
    public var tg_reverseLayout:Bool
    {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_reverseLayout
        }
        set
        {
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_reverseLayout != newValue
            {
                sc.tg_reverseLayout = newValue
                setNeedsLayout()
            }
        }
    }
    
    /**
     *把一个布局视图放入到UIScrollView内时是否自动调整UIScrollView的contentSize值。默认是.auto，你可以将这个属性设置no而不调整contentSize的值，设置为yes则一定会调整contentSize.
     */
    public var tg_adjustScrollViewContentSizeMode:TGAdjustScrollViewContentSizeMode = .auto
    
    /**
     *在布局视图进行布局时是否调用基类的layoutSubviews方法，默认设置为NO。
     */
    public var tg_priorAutoresizingMask:Bool = false
    
    /**
     *设置是否对布局视图里面的隐藏的子视图进行布局。默认值是false，表示当有子视图隐藏时，隐藏的子视图将不会占据任何位置和尺寸，而其他的未隐藏的子视图将会覆盖掉隐藏的子视图的位置和尺寸。如果布局视图的宽度或者高度在设置了包裹属性后也会重新调整。
     */
    public var tg_layoutHiddenSubviews:Bool
        {
        get
        {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_layoutHiddenSubviews
        }
        set
        {
            let sc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if sc.tg_layoutHiddenSubviews != newValue
            {
                sc.tg_layoutHiddenSubviews = newValue
                setNeedsLayout()
            }

        }
    }
    
    //返回当前布局视图是否正在执行布局。
    public private(set) var tg_isLayouting = false
    
    
    //执行布局动画。在布局视图的某个子视图设置完布局属性后，调用布局的这个方法可以让布局里面的子视图在布局时实现动画效果。
    public func tg_layoutAnimationWithDuration(_ duration:TimeInterval)
    {
        self.tg_beginLayoutDo{
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
        }
        
        self.tg_endLayoutDo{
            
            UIView.commitAnimations()
        }
        
    }
    
    /**
     *评估布局视图的尺寸,这个方法并不会进行真正的布局，只是对布局的尺寸进行评估，主要用于在布局前想预先知道布局尺寸的场景。通过对布局进行尺寸的评估，可以在不进行布局的情况下动态的计算出布局的位置和大小，但需要注意的是这个评估值有可能不是真实显示的实际位置和尺寸。
     *@size：指定期望的宽度或者高度，如果size中对应的值设置为0则根据布局自身的高度和宽度来进行评估，而设置为非0则固定指定的高度或者宽度来进行评估。比如下面的例子：
     * tg_sizeThatFits() 表示按布局的位置和尺寸根据布局的子视图来进行动态评估。
     * tg_sizeThatFits(CGSize(width:320,height:0)) 表示布局的宽度固定为320,而高度则根据布局的子视图来进行动态评估。这个情况非常适用于UITableViewCell的动态高度的计算评估。
     * tg_sizeThatFits(CGSize(width:0,height:100)) 表示布局的高度固定为100,而宽度则根据布局的子视图来进行动态评估。
     *@type:参数表示评估某个sizeClass下的尺寸值，如果没有找到指定的sizeClass则会根据继承规则得到最合适的sizeClass
     */
    public func tg_sizeThatFits(_ size:CGSize = .zero, inSizeClass type:TGSizeClassType = .default) -> CGSize
    {
        self.tgFrame.sizeClass = self.tgMatchBestSizeClass(type)
        
        for sbv:UIView in self.subviews
        {
            sbv.tgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)
        }
        
        var (selfSize, hasSubLayout) = self.tgCalcLayoutRect(size, isEstimate: false, type: type)
        if hasSubLayout
        {
            self.tgFrame.width = selfSize.width
            self.tgFrame.height = selfSize.height
            (selfSize,_) = self.tgCalcLayoutRect(.zero, isEstimate: true, type: type)
        }
        self.tgFrame.width = selfSize.width
        self.tgFrame.height = selfSize.height
        
        for sbv:UIView in self.subviews
        {
            sbv.tgFrame.sizeClass = self.tgDefaultSizeClass
        }
        
        self.tgFrame.sizeClass = self.tgDefaultSizeClass
        
        
        return selfSize
        
    }
    
    
    /**
     *设置布局视图在布局之前和布局完成之后的处理块。这两个处理块主要用来实现布局的动画功能。系统会在每次布局完成之后将处理块清空为nil。您也可以在tg_endLayoutDo块内取到所有子视图真实布局后的frame值。
     */
    public func tg_beginLayoutDo(_ action:(()->Void)?)
    {
        _beginLayoutAction = action
    }
    
    public func tg_endLayoutDo(_ action:(()->Void)?)
    {
        _endLayoutAction = action
    }

    /**
     *设置布局视图在第一次布局完成之后或者有横竖屏切换时进行处理的动作块。这个block不像tg_beginLayoutDo以及tg_endLayoutDo那样只会执行一次,而是会一直存在
     *因此需要注意代码块里面的循环引用的问题。这个block调用的时机是第一次布局完成或者每次横竖屏切换时布局完成被调用。
     *这个方法会在tg_endLayoutDo执行后调用。
     *layout参数就是布局视图本身
     *isFirst表明当前是否是第一次布局时调用。
     *isPortrait表明当前是横屏还是竖屏。
     */
    public func tg_rotationToDeviceOrientationDo(_ action:((_ layout:TGBaseLayout, _ isFirst:Bool, _ isPortrait:Bool)->Void)?)
    {
        _rotationToDeviceOrientationAction = action
    }
    
    
    //MARK: borderline
    //设置布局视图的顶部边界线对象
    public var tg_topBorderline:TGLayoutBorderline!
        {
        didSet
        {
            if self.tg_topBorderline != oldValue
            {
                _topBorderlineLayer = self.tgUpdateBorderLayer(_topBorderlineLayer, borderLineDraw: self.tg_topBorderline)
            }
            
        }
    }
    
    //设置布局视图的左边边界线对象
    public var tg_leftBorderline:TGLayoutBorderline!
        {
        didSet
        {
            if self.tg_leftBorderline != oldValue
            {
                _leftBorderlineLayer = self.tgUpdateBorderLayer(_leftBorderlineLayer, borderLineDraw: self.tg_leftBorderline)
            }
        }
    }
    
    //设置布局视图的底部边界线对象
    public var tg_bottomBorderline:TGLayoutBorderline!
        {
        didSet
        {
            if self.tg_bottomBorderline != oldValue
            {
                _bottomBorderlineLayer = self.tgUpdateBorderLayer(_bottomBorderlineLayer, borderLineDraw: self.tg_bottomBorderline)
            }
        }
    }
    
    //设置布局视图的右边边界线对象
    public var tg_rightBorderline:TGLayoutBorderline!
        {
        
        didSet
        {
            
            if self.tg_rightBorderline != oldValue
            {
                _rightBorderlineLayer = self.tgUpdateBorderLayer(_rightBorderlineLayer, borderLineDraw:self.tg_rightBorderline)
            }
            
        }
    }
    
    //设置布局视图的四周边界线对象
    public var tg_boundBorderline:TGLayoutBorderline!
        {
        get
        {
            return self.tg_leftBorderline
        }
        set
        {
            self.tg_leftBorderline = newValue
            self.tg_topBorderline = newValue
            self.tg_rightBorderline = newValue
            self.tg_bottomBorderline = newValue
        }
    }
    
    /**
     *智能边界线，智能边界线不是设置自身的边界线而是对添加到布局视图里面的子布局视图根据子视图之间的关系智能的生成边界线，对于布局视图里面的非布局子视图则不会生成边界线。目前的版本只支持线性布局，表格布局，流式布局和浮动布局这四种布局。
     */
    public var tg_intelligentBorderline:TGLayoutBorderline! = nil
    
    /**
     *不使用父布局视图提供的智能边界线功能。当布局视图的父布局视图设置了tg_intelligentBorderline时但是布局视图又想自己定义边界线时则将这个属性设置为true
     */
    public var tg_notUseIntelligentBorderline:Bool = false
    
    
    //MARK:action&effect
    
    /**
     *设置布局的按下抬起、按下、取消事件的处理动作,后两个事件的处理必须依赖于第一个事件的处理。请不要在这些处理动作中修改背景色，不透明度，以及背景图片。如果您只想要高亮效果但是不想处理事件则将action设置为nil即可了。
     * @target: 事件的处理对象，如果设置为nil则表示取消事件。
     * @action: 事件的处理动作，格式为：func handleAction(sender:TGBaseLayout)
     * @controlEvents:支持的事件类型，目前只支持：touchDown、touchUpInside、touchCancel这三个事件。
     */
    public func tg_setTarget(_ target: NSObjectProtocol?, action: Selector?, for controlEvents: UIControlEvents)
    {
        //just only support these events
        switch controlEvents {
        case UIControlEvents.touchDown:
            _touchDownTarget = target
            _touchDownAction = action
            break
        case UIControlEvents.touchUpInside:
            _touchUpTarget = target
            _touchUpAction = action
            break
        case UIControlEvents.touchCancel:
            _touchCancelTarget = target
            _touchCancelAction = action
            break
        default:
            return
        }
    }
    
    /**
     *设置布局按下时背景的高亮的颜色。只有设置了tg_setTarget方法后此属性才生效。
     */
    public var tg_highlightedBackgroundColor:UIColor! = nil
    
    /**
     *设置布局按下时的高亮不透明度。值的范围是[0,1]，默认是0表示完全不透明，为1表示完全透明。只有设置了tg_setTarget方法此属性才生效。
     */
    public var tg_highlightedOpacity:CGFloat = 0
    
    /**
     *设置布局的背景图片。这个属性的设置就是设置了布局的layer.contents的值，因此如果要实现背景图的局部拉伸请用layer.contentsXXX这些属性进行调整
     */
    public var tg_backgroundImage:UIImage! = nil
        {
        didSet
        {
            if self.tg_backgroundImage == nil
            {
                self.layer.contents = nil
            }
            else
            {
                self.layer.contents = self.tg_backgroundImage.cgImage
            }
        }
    }
    
    /**
     *设置布局按下时的高亮背景图片。只有设置了tg_setTarget方法此属性才生效。
     */
    public var tg_highlightedBackgroundImage:UIImage! = nil
    
    

    
//MARK: override Method
    
    deinit {
        
        _endLayoutAction = nil
        _beginLayoutAction = nil
        _rotationToDeviceOrientationAction = nil
    }
    
    override open func layoutSubviews() {
        
        if !self.autoresizesSubviews
        {
            return
        }
        
        _beginLayoutAction?()
        _beginLayoutAction = nil
        
        
        var currentScreenOrientation:Int! = nil
        
        if !self.tg_isLayouting
        {
            self.tg_isLayouting = true
            
            if self.tg_priorAutoresizingMask
            {
                super.layoutSubviews()
            }
            
            
            
            //得到最佳的sizeClass
            var sizeClassWidthType:TGSizeClassType.Width = .any
            var sizeClassHeightType:TGSizeClassType.Height = .any
            var sizeClassScreenType:TGSizeClassType.Screen? = nil
            if atof(UIDevice.current.systemVersion) >= 8
            {
                
                if #available(iOS 8.0, *) {
                    switch self.traitCollection.verticalSizeClass {
                    case .compact:
                        sizeClassHeightType = .compact
                        break
                    case .regular:
                        sizeClassHeightType = .regular
                        break
                    default:
                        sizeClassHeightType = .any
                    }
                } else {
                    // Fallback on earlier versions
                }
                
                if #available(iOS 8.0, *) {
                    switch self.traitCollection.horizontalSizeClass {
                    case .compact:
                        sizeClassWidthType = .compact
                        break
                    case .regular:
                        sizeClassWidthType = .regular
                        break
                    default:
                        sizeClassWidthType = .any
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            
            let devori = UIDevice.current.orientation
            if UIDeviceOrientationIsPortrait(devori)
            {
                sizeClassScreenType = .portrait
                currentScreenOrientation = 1
            }
            else if UIDeviceOrientationIsLandscape(devori)
            {
                sizeClassScreenType = .landscape
                currentScreenOrientation = 2
            }
            else
            {
                
            }
            
            
            let sizeClassType = TGSizeClassType.comb(sizeClassWidthType, sizeClassHeightType, sizeClassScreenType)
            self.tgFrame.sizeClass = self.tgMatchBestSizeClass(sizeClassType)
            for sbv:UIView in self.subviews
            {
                sbv.tgFrame.sizeClass = sbv.tgMatchBestSizeClass(sizeClassType)
            }
            
            let oldSelfSize = self.bounds.size
            let (newSelfSize,_) = self.tgCalcLayoutRect(CGSize.zero,isEstimate: false,type:sizeClassType)
            
            for sbv:UIView in self.subviews
            {
                let tgsbvFrame = sbv.tgFrame
                let ptOrigin = sbv.bounds.origin
                if tgsbvFrame.left != CGFloat.greatestFiniteMagnitude && tgsbvFrame.top != CGFloat.greatestFiniteMagnitude && !sbv.tg_noLayout
                {
                    sbv.center = CGPoint(x: tgsbvFrame.left + sbv.layer.anchorPoint.x * tgsbvFrame.width, y: tgsbvFrame.top + sbv.layer.anchorPoint.y * tgsbvFrame.height)
                    sbv.bounds = CGRect(origin: ptOrigin, size: tgsbvFrame.frame.size)
                    
                }
                
                if tgsbvFrame.sizeClass!.isHidden
                {
                    sbv.bounds = CGRect(origin: ptOrigin, size: .zero)
                }
                
                (tgsbvFrame.sizeClass as! TGViewSizeClassImpl).tgLayoutCompletedAction?(self,sbv)
                (tgsbvFrame.sizeClass as! TGViewSizeClassImpl).tgLayoutCompletedAction = nil
                
                tgsbvFrame.sizeClass = sbv.tgDefaultSizeClass
                tgsbvFrame.reset()
                
            }
            
            if !oldSelfSize.equalTo(newSelfSize) && newSelfSize.width != CGFloat.greatestFiniteMagnitude
            {
                //如果父视图也是布局视图，并且自己隐藏则不调整自身的尺寸和位置。
                var isAdjustSelf = true
                if let supl = self.superview as? TGBaseLayout
                {
                    if supl.tgIsNoLayoutSubview(self)
                    {
                        isAdjustSelf = false
                    }
                }
                if (isAdjustSelf)
                {
                    
                    self.bounds = CGRect(origin:self.bounds.origin, size:newSelfSize)
                    self.center = CGPoint(x:self.center.x + (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x, y:self.center.y + (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y)
                }
            }
            
            if _topBorderlineLayer != nil
            {
                _topBorderlineLayer.setNeedsLayout()
            }
            
            if _leftBorderlineLayer != nil
            {
                _leftBorderlineLayer.setNeedsLayout()
            }
            
            if _bottomBorderlineLayer != nil
            {
                _bottomBorderlineLayer.setNeedsLayout()
            }
            
            if _rightBorderlineLayer != nil
            {
                _rightBorderlineLayer.setNeedsLayout()
            }
            
            if newSelfSize.width != CGFloat.greatestFiniteMagnitude
            {
                self.tgAlterScrollViewContentSize(newSelfSize)
                
                if self.superview != nil && !self.superview!.isKind(of: TGBaseLayout.self) && !self.superview!.isKind(of: UIScrollView.self)
                {
                    
                    let rectSuper = self.superview!.bounds
                    let rectSelf = self.bounds
                    var centerPonintSelf = self.center
                    
                    if (self.tg_width.isWrap)
                    {
                        //如果只设置了右边，或者只设置了居中则更新位置。。
                        if (self.tg_centerX.hasValue)
                        {
                            centerPonintSelf.x = (rectSuper.width - rectSelf.width)/2 + self.tg_centerX.realMarginInSize(rectSuper.width) + self.layer.anchorPoint.x * rectSelf.width
                        }
                        else if (self.tg_right.hasValue && !self.tg_left.hasValue)
                        {
                            centerPonintSelf.x  = rectSuper.width - rectSelf.width - self.tg_right.realMarginInSize(rectSuper.width) + self.layer.anchorPoint.x * rectSelf.width
                        }
                        
                    }
                    
                    if (self.tg_height.isWrap)
                    {
                        if (self.tg_centerY.hasValue)
                        {
                            centerPonintSelf.y = (rectSuper.height - rectSelf.height)/2 + self.tg_centerY.realMarginInSize(rectSuper.height) + self.layer.anchorPoint.y * rectSelf.height
                        }
                        else if (self.tg_bottom.hasValue && !self.tg_top.hasValue)
                        {
                            centerPonintSelf.y  = rectSuper.height - rectSelf.height - self.tg_bottom.realMarginInSize(rectSuper.height) + self.layer.anchorPoint.y * rectSelf.height
                        }
                    }
                    
                    //如果有变化则只调整自己的center。而不变化
                    if (!self.center.equalTo(centerPonintSelf))
                    {
                        self.center = centerPonintSelf
                    }

                    
                }
                
            }
            
            self.tgFrame.sizeClass = self.tgDefaultSizeClass
            self.tg_isLayouting = false
        }
        
        _endLayoutAction?()
        _endLayoutAction = nil

        
        //执行屏幕旋转的处理逻辑。
        if (_rotationToDeviceOrientationAction != nil && currentScreenOrientation != nil)
        {
            if (_lastScreenOrientation == nil)
            {
                _lastScreenOrientation = currentScreenOrientation;
                _rotationToDeviceOrientationAction!(self,true, currentScreenOrientation == 1);
            }
            else
            {
                if (_lastScreenOrientation != currentScreenOrientation)
                {
                    _lastScreenOrientation = currentScreenOrientation;
                    _rotationToDeviceOrientationAction!(self, false, currentScreenOrientation == 1);
                }
            }
            
            _lastScreenOrientation = currentScreenOrientation;
        }

        
        
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return self.tg_sizeThatFits(size)
    }
    
    override open var isHidden:Bool
        {
        didSet
        {
            if !self.isHidden
            {
                if _topBorderlineLayer != nil
                {
                    _topBorderlineLayer.setNeedsLayout()
                    
                }
                
                if _leftBorderlineLayer != nil
                {
                    _leftBorderlineLayer.setNeedsLayout()
                }
                
                if _bottomBorderlineLayer != nil
                {
                    _bottomBorderlineLayer.setNeedsLayout()
                }
                
                if _rightBorderlineLayer != nil
                {
                    _rightBorderlineLayer.setNeedsLayout()
                }
                
                if let supl = self.superview as? TGBaseLayout
                {
                     if !supl.tg_layoutHiddenSubviews && !self.tg_useFrame
                     {
                        self.setNeedsLayout()
                    }
                }
            }
        }
    }
    
    
    override open func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        subview.addObserver(self, forKeyPath:"hidden", options: [.new, .old], context: nil)
        subview.addObserver(self, forKeyPath:"frame", options: [.new, .old], context: nil)
        subview.addObserver(self, forKeyPath:"center", options: [.new, .old], context: nil)

    }
    
    override open func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        subview.tg_layoutCompletedDo(nil)
        subview.removeObserver(self, forKeyPath: "hidden")
        subview.removeObserver(self, forKeyPath: "frame")
        subview.removeObserver(self, forKeyPath: "center")

    }
    

    
    override open func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        
        //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
        if newSuperview != nil && (newSuperview as? TGBaseLayout) == nil
        {
            let newSuperview:UIView = newSuperview!
            
            #if DEBUG
                
                if (self.tg_left.posRelaVal != nil)
                {
                    //约束冲突：左边距依赖的视图不是父视图
                    assert(self.tg_left.posRelaVal.view == newSuperview, "Constraint exception!! \(self)left margin dependent on:\(self.tg_left.posRelaVal.view)is not superview")
                }
                
                if (self.tg_right.posRelaVal != nil)
                {
                    //约束冲突：右边距依赖的视图不是父视图
                    assert(self.tg_right.posRelaVal.view == newSuperview, "Constraint exception!! \(self)right margin dependent on:\(self.tg_right.posRelaVal.view) is not superview");
                }
                
                if (self.tg_centerX.posRelaVal != nil)
                {
                    //约束冲突：水平中心点依赖的视图不是父视图
                    assert(self.tg_centerX.posRelaVal.view == newSuperview, "Constraint exception!! \(self)horizontal center margin dependent on:\(self.tg_centerX.posRelaVal.view) is not superview")
                }
                
                if (self.tg_top.posRelaVal != nil)
                {
                    //约束冲突：上边距依赖的视图不是父视图
                    assert(self.tg_top.posRelaVal.view == newSuperview, "Constraint exception!! \(self)top margin dependent on:\(self.tg_top.posRelaVal.view) is not superview")
                }
                
                if (self.tg_bottom.posRelaVal != nil)
                {
                    //约束冲突：下边距依赖的视图不是父视图
                    assert(self.tg_bottom.posRelaVal.view == newSuperview, "Constraint exception!! \(self)bottom margin dependent on:\(self.tg_bottom.posRelaVal.view) is not superview")
                    
                }
                
                if (self.tg_centerY.posRelaVal != nil)
                {
                    //约束冲突：垂直中心点依赖的视图不是父视图
                    assert(self.tg_centerY.posRelaVal.view == newSuperview, "Constraint exception!! \(self)vertical center margin dependent on:\(self.tg_centerY.posRelaVal.view) is not superview")
                }
                
                if (self.tg_width.dimeRelaVal != nil)
                {
                    //约束冲突：宽度依赖的视图不是父视图
                    assert(self.tg_width.dimeRelaVal.view == newSuperview, "Constraint exception!! \(self)width dependent on:\(self.tg_width.dimeRelaVal.view) is not superview")
                }
                
                if (self.tg_height.dimeRelaVal != nil)
                {
                    //约束冲突：高度依赖的视图不是父视图
                    assert(self.tg_height.dimeRelaVal.view == newSuperview, "Constraint exception!! \(self)height dependent on:\(self.tg_height.dimeRelaVal.view) is not superview")
                }
                
            #endif
            
            if (self.tgUpdateLayoutRectInNoLayoutSuperview(newSuperview))
            {
                //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃
                
                //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
                //然后在左边将异常断点清除即可
                
                if _isAddSuperviewKVO && self.superview != nil && (self.superview as? TGBaseLayout) == nil
                {
                    self.superview!.removeObserver(self, forKeyPath:"frame")
                    self.superview!.removeObserver(self, forKeyPath:"bounds")
                    
                }
                
                newSuperview.addObserver(self,forKeyPath:"frame",options:[.new,.old], context:nil)
                newSuperview.addObserver(self,forKeyPath:"bounds",options:[.new,.old], context:nil)
                _isAddSuperviewKVO = true
            }
            
        }
        
        if (_isAddSuperviewKVO && newSuperview == nil && self.superview != nil && (self.superview as? TGBaseLayout) == nil)
        {
            
            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可
            
            _isAddSuperviewKVO = false;
            
            self.superview!.removeObserver(self, forKeyPath:"frame")
            self.superview!.removeObserver(self,forKeyPath:"bounds")
            
            
        }
        
        
        if (newSuperview != nil)
        {
            //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
            if ((newSuperview as? UIScrollView) != nil && (newSuperview as? UITableView) == nil && (newSuperview as? UICollectionView) == nil)
            {
                if self.tg_adjustScrollViewContentSizeMode == .auto
                {
                  self.tg_adjustScrollViewContentSizeMode = .yes
                }
            }
        }
        else
        {
            _beginLayoutAction = nil
            _endLayoutAction = nil
        }
        
    }
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        
        if  (object as! UIView) === self.superview && (self.superview as? TGBaseLayout) == nil && !self.tg_useFrame
        {
            
            if keyPath == "frame" || keyPath == "bounds"
            {
                let rcOld = change![.oldKey] as! CGRect
                let rcNew = change![.newKey] as! CGRect
                
                if !rcOld.size.equalTo(rcNew.size)
                {
                    let _ = self.tgUpdateLayoutRectInNoLayoutSuperview(self.superview!)
                }
            }
            return
        }
        
        
        
        if (keyPath == "frame" || keyPath == "hidden" || keyPath == "center")
        {
            
            if !self.tg_isLayouting
            {
                if let sbv = object as? UIView, !sbv.tg_useFrame
                {
                    setNeedsLayout()
                    
                    if keyPath == "hidden" && !(change![.newKey] as! Bool)
                    {
                        sbv.setNeedsDisplay()
                    }
                    
                }
            }
        }
        
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch:UITouch = (touches as NSSet).anyObject() as! UITouch
        
        if _touchUpTarget != nil && !_forbidTouch && touch.tapCount == 1 && !TGBaseLayout._hasBegin
        {
            TGBaseLayout._hasBegin = true;
            _canCallAction = true;
            _beginPoint =  touch.location(in: self)
            
            if self.tg_highlightedOpacity != 0
            {
                _oldAlpha = self.alpha;
                self.alpha = 1 - self.tg_highlightedOpacity;
            }
            
            if self.tg_highlightedBackgroundColor != nil
            {
                _oldBackgroundColor = self.backgroundColor;
                self.backgroundColor = self.tg_highlightedBackgroundColor;
            }
            
            if self.tg_highlightedBackgroundImage != nil
            {
                _oldBackgroundImage = self.tg_backgroundImage;
                self.tg_backgroundImage = self.tg_highlightedBackgroundImage;
            }
            
            _hasDoCancel = false;
            _ = _touchDownTarget?.perform(_touchDownAction, with: self)
            
        }
        
        super.touchesBegan(touches,with:event)
        
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if _touchUpTarget != nil && TGBaseLayout._hasBegin
        {
            if _canCallAction
            {
                let touch:UITouch = (touches as NSSet).anyObject() as! UITouch
                
                let pt:CGPoint = touch.location(in: self)
                if fabs(pt.x - _beginPoint.x) > 2 || fabs(pt.y - _beginPoint.y) > 2
                {
                    _canCallAction = false;
                    
                    if !_hasDoCancel
                    {
                       _ = _touchCancelTarget?.perform(_touchCancelAction, with: self)
                        _hasDoCancel = true;
                        
                    }
                    
                }
            }
        }
        
        super.touchesMoved(touches,with:event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if _touchUpTarget != nil && TGBaseLayout._hasBegin
        {
            //设置一个延时.
            _forbidTouch = true
            
            let time: TimeInterval = 0.12
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                
                self.tgDoTargetAction((touches as NSSet).anyObject() as! UITouch)
            })
            
            TGBaseLayout._hasBegin = false
        }
        
        
        super.touchesEnded(touches, with:event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if _touchUpTarget != nil && TGBaseLayout._hasBegin
        {
            if self.tg_highlightedOpacity != 0
            {
                self.alpha = _oldAlpha;
                _oldAlpha = 1;
            }
            
            if self.tg_highlightedBackgroundColor != nil
            {
                self.backgroundColor = _oldBackgroundColor;
                _oldBackgroundColor = nil;
            }
            
            if  self.tg_highlightedBackgroundImage != nil
            {
                self.tg_backgroundImage = _oldBackgroundImage;
                _oldBackgroundImage = nil;
            }
            
            
            TGBaseLayout._hasBegin = false;
            
            if !_hasDoCancel
            {
                _ = _touchCancelTarget?.perform(_touchCancelAction, with: self)
                _hasDoCancel = true
                
            }
            
        }
        
        super.touchesCancelled(touches,with:event)
    }
    
    internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, type:TGSizeClassType) ->(selfSize:CGSize, hasSubLayout:Bool)
    {
        var selfSize:CGSize
        
        if isEstimate
        {
            selfSize = self.tgFrame.frame.size
        }
        else
        {
            selfSize = self.bounds.size
            if size.width != 0
            {
                selfSize.width = size.width
            }
            
            if size.height != 0
            {
                selfSize.height = size.height
            }
        }
        
        return (selfSize, false)
        
    }
    
    override func tgCreateInstance() -> AnyObject
    {
        return TGLayoutViewSizeClassImpl()
    }
    
    //MARK:private var

    //边界线私有属性
    fileprivate var _topBorderlineLayer:CAShapeLayer! = nil
    fileprivate var _leftBorderlineLayer:CAShapeLayer! = nil
    fileprivate var _bottomBorderlineLayer:CAShapeLayer! = nil
    fileprivate var _rightBorderlineLayer:CAShapeLayer! = nil
    fileprivate var _layerDelegate:TGBorderlineLayerDelegate! = nil
    
    
    //动作私有
    fileprivate weak var _touchDownTarget:NSObjectProtocol? = nil
    fileprivate weak var _touchUpTarget:NSObjectProtocol? = nil
    fileprivate weak var _touchCancelTarget:NSObjectProtocol? = nil
    fileprivate lazy var _touchDownAction:Selector? = nil
    fileprivate lazy var _touchUpAction:Selector? = nil
    fileprivate lazy var _touchCancelAction:Selector? = nil
    
    fileprivate lazy var _hasDoCancel:Bool = false
    fileprivate lazy var _oldBackgroundColor:UIColor?=nil
    fileprivate lazy var _oldBackgroundImage:UIImage?=nil
    fileprivate lazy var _oldAlpha:CGFloat = 0
    
    fileprivate lazy var _forbidTouch:Bool = false
    fileprivate lazy var _canCallAction:Bool = false
    fileprivate lazy var _beginPoint:CGPoint = CGPoint.zero
    static var _hasBegin:Bool = false

    

    //布局回调处理
    private lazy var _beginLayoutAction:(()->Void)? = nil
    private lazy var _endLayoutAction:(()->Void)? = nil
    
    
    //旋转处理。
    private var _lastScreenOrientation:Int! = nil //为nil为初始状态，为1为竖屏，为2为横屏。内部使用。
    private lazy var _rotationToDeviceOrientationAction:((_ layout:TGBaseLayout, _ isFirst:Bool, _ isPortrait:Bool)->Void)? = nil

    private var _isAddSuperviewKVO:Bool=false;

    
}


extension TGBaseLayout
{
    fileprivate func tgDoTargetAction(_ touch:UITouch)
    {
        
        if self.tg_highlightedOpacity != 0
        {
            self.alpha = _oldAlpha;
            _oldAlpha = 1;
        }
        
        if self.tg_highlightedBackgroundColor != nil
        {
            self.backgroundColor = _oldBackgroundColor;
            _oldBackgroundColor = nil;
        }
        
        
        if self.tg_highlightedBackgroundImage != nil
        {
            self.tg_backgroundImage = _oldBackgroundImage;
            _oldBackgroundImage = nil;
        }
        
        
        //距离太远则不会处理
        let pt:CGPoint = touch.location(in: self)
        if _touchUpTarget != nil && _canCallAction && self.bounds.contains(pt)
        {
            _ = _touchUpTarget?.perform(_touchUpAction, with: self)
        }
        else
        {
            if !_hasDoCancel
            {
                _ = _touchCancelTarget?.perform(_touchCancelAction, with: self)
                _hasDoCancel = true;
            }
            
        }
        
        _forbidTouch = false;
        
    }
    
    

    
    fileprivate func tgUpdateBorderLayer(_ layer:CAShapeLayer!, borderLineDraw:TGLayoutBorderline!) ->CAShapeLayer!
    {
        var retLayer:CAShapeLayer! = layer
        
        if borderLineDraw == nil
        {
            if retLayer != nil
            {
                retLayer.delegate = nil
                retLayer.removeFromSuperlayer()
            }
            
            retLayer = nil
            
        }
        else
        {
            if _layerDelegate == nil
            {
                _layerDelegate = TGBorderlineLayerDelegate(layout:self)
            }
            
            if retLayer == nil
            {
                retLayer = CAShapeLayer()
                self.layer.addSublayer(retLayer!)
                retLayer.delegate = _layerDelegate
                
            }
            
            if borderLineDraw.dash != 0
            {
                retLayer.lineDashPhase = borderLineDraw.dash / 2
                retLayer.lineDashPattern = [NSNumber(value:Double(borderLineDraw.dash)), NSNumber(value:Double(borderLineDraw.dash))]
                retLayer.strokeColor = borderLineDraw.color.cgColor
                retLayer.lineWidth = borderLineDraw.thick
                retLayer.backgroundColor = nil
            }
            else
            {
                retLayer.lineDashPhase = 0
                retLayer.lineDashPattern = nil
                retLayer.strokeColor = nil
                retLayer.lineWidth = 0
                retLayer.backgroundColor = borderLineDraw.color.cgColor
            }
            
            retLayer.setNeedsLayout()
        }
        
        
        return retLayer
        
        
    }
    
    

    
    internal func tgCalcHeightFromHeightWrapView(_ sbv:UIView, width:CGFloat) ->CGFloat
    {
        if let sbvimg = sbv as? UIImageView
        {
            //根据图片的尺寸进行等比缩放得到合适的高度。
            if let img = sbvimg.image , img.size.width != 0
            {
                return sbv.tg_height.measure(img.size.height * (width / img.size.width))
            }
            else
            {
                let sz = sbvimg.sizeThatFits(CGSize(width: width, height: 0))
                return sbv.tg_height.measure(sz.height)
            }
        }
        else
        {
            let sz = sbv.sizeThatFits(CGSize(width: width, height: 0));
            return sbv.tg_height.measure(sz.height)
        }
    }
    
    
    private func tgGetBoundLimitMeasure(_ boundDime:TGLayoutSize,sbv:UIView, dimeType:TGGravity, sbvSize:CGSize, selfLayoutSize:CGSize,isUBound:Bool) ->CGFloat
    {
        var value = isUBound ? CGFloat.greatestFiniteMagnitude : -CGFloat.greatestFiniteMagnitude;
        
        
        if (boundDime.dimeNumVal != nil)
        {
            value = boundDime.dimeNumVal;
        }
        else if (boundDime.dimeRelaVal != nil)
        {
            if boundDime.dimeRelaVal.view == self
            {
                if (boundDime.dimeRelaVal._type == TGGravity.horz.fill)
                {
                    value = selfLayoutSize.width - (boundDime.dimeRelaVal.view == self ? (self.tg_leftPadding + self.tg_rightPadding) : 0);
                }
                else
                {
                    value = selfLayoutSize.height - (boundDime.dimeRelaVal.view == self ? (self.tg_topPadding + self.tg_bottomPadding) :0);
                }
            }
            else if (boundDime.dimeRelaVal.view == sbv)
            {
                if (boundDime.dimeRelaVal._type == dimeType)
                {
                    //约束冲突：无效的边界设置方法
                    assert(false, "Constraint exception!! \(sbv) has invalid min or max setting");
                }
                else
                {
                    if (boundDime.dimeRelaVal._type ==  TGGravity.horz.fill)
                    {
                        value = sbvSize.width;
                    }
                    else
                    {
                        value = sbvSize.height;
                    }
                }
            }
            else
            {
                if (boundDime.dimeRelaVal._type == TGGravity.horz.fill)
                {
                    
                    value = boundDime.dimeRelaVal.view.tg_estimatedFrame.width
                }
                else
                {
                    
                    value = boundDime.dimeRelaVal.view.tg_estimatedFrame.height
                }
            }
            
        }
        else if (boundDime.isWrap)
        {
            if dimeType == TGGravity.horz.fill
            {
                value = sbvSize.width
            }
            else
            {
              value = sbvSize.height
            }
        }
        else
        {
            //约束冲突：无效的边界设置方法
            assert(false, "Constraint exception!! \(sbv) has invalid min or max setting");
        }
        
        if (value == CGFloat.greatestFiniteMagnitude || value == -CGFloat.greatestFiniteMagnitude)
        {
            return value;
        }
        
        return boundDime.measure(value)
    }
    
    
    
    internal func tgValidMeasure(_ dime:TGLayoutSize, sbv:UIView, calcSize:CGFloat, sbvSize:CGSize, selfLayoutSize:CGSize) ->CGFloat
    {
        //算出最大最小值。
        var minV = -CGFloat.greatestFiniteMagnitude
        if dime.isActive
        {
            minV = self.tgGetBoundLimitMeasure(dime.minVal, sbv:sbv, dimeType:dime._type, sbvSize:sbvSize, selfLayoutSize:selfLayoutSize, isUBound:false)
        }
        
        var  maxV = CGFloat.greatestFiniteMagnitude
        if dime.isActive
        {
            maxV = self.tgGetBoundLimitMeasure(dime.maxVal, sbv:sbv, dimeType:dime._type, sbvSize:sbvSize, selfLayoutSize:selfLayoutSize,isUBound:true)
        }
        
        var retCalcSize = calcSize
        retCalcSize = max(minV, retCalcSize);
        retCalcSize = min(maxV, retCalcSize);
        
        return retCalcSize;
    }
    
    
    private func tgGetBoundLimitMargin(_ boundPos:TGLayoutPos, sbv:UIView, selfLayoutSize:CGSize) ->CGFloat
    {
        var value:CGFloat = 0;
        
        if (boundPos.posNumVal != nil)
        {
            value = boundPos.posNumVal;
        }
        else if (boundPos.posRelaVal != nil)
        {
            let rect = boundPos.posRelaVal.view.tgFrame.frame;
            
            let pos = boundPos.posRelaVal._type;
            if (pos == TGGravity.horz.left)
            {
                if (rect.origin.x != CGFloat.greatestFiniteMagnitude)
                {
                    value = rect.minX;
                }
            }
            else if (pos == TGGravity.horz.center)
            {
                if (rect.origin.x != CGFloat.greatestFiniteMagnitude)
                {
                    value = rect.midX;
                }
            }
            else if (pos == TGGravity.horz.right)
            {
                if (rect.origin.x != CGFloat.greatestFiniteMagnitude)
                {
                    value = rect.maxX;
                }
            }
            else if (pos == TGGravity.vert.top)
            {
                if (rect.origin.y != CGFloat.greatestFiniteMagnitude)
                {
                    value = rect.minY;
                }
            }
            else if (pos == TGGravity.vert.center)
            {
                if (rect.origin.y != CGFloat.greatestFiniteMagnitude)
                {
                    value = rect.midY;
                }
            }
            else if (pos == TGGravity.vert.bottom)
            {
                if (rect.origin.y != CGFloat.greatestFiniteMagnitude)
                {
                    value = rect.maxY;
                }
            }
        }
        else
        {
            //约束冲突：无效的边界设置方法
            assert(false, "Constraint exception!! \(sbv) has invalid min or max setting");
        }
        
        return value + boundPos.offsetVal;
        
    }
    
    
    internal func tgValidMargin(_ pos:TGLayoutPos, sbv:UIView, calcPos:CGFloat, selfLayoutSize:CGSize) ->CGFloat
    {
        //算出最大最小值
        var minV = -CGFloat.greatestFiniteMagnitude
        if pos.isActive
        {
            minV = self.tgGetBoundLimitMargin(pos.minVal, sbv:sbv,selfLayoutSize:selfLayoutSize)
        }
        
        var  maxV = CGFloat.greatestFiniteMagnitude
        if pos.isActive
        {
            maxV = self.tgGetBoundLimitMargin(pos.maxVal,sbv:sbv,selfLayoutSize:selfLayoutSize)
        }
        
        var retCalcPos = calcPos
        retCalcPos = max(minV, retCalcPos);
        retCalcPos = min(maxV, retCalcPos);
        return retCalcPos;
    }
    
    
    fileprivate func tgUpdateLayoutRectInNoLayoutSuperview(_ newSuperview:UIView) -> Bool
    {
        var isAdjust = false;
        
        let rectSuper = newSuperview.bounds
        let leftMargin = self.tg_left.realMarginInSize(rectSuper.width)
        let rightMargin = self.tg_right.realMarginInSize(rectSuper.width)
        let topMargin = self.tg_top.realMarginInSize(rectSuper.height)
        let bottomMargin = self.tg_bottom.realMarginInSize(rectSuper.height)
        var rectSelf = self.bounds

        rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x
        rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y
        
        let oldSelfRect = rectSelf
        
        //确定左右边距和宽度。
        if (!self.tg_width.isWrap && self.tg_width.hasValue)
        {
            if self.tg_width.isFill
            {
                rectSelf.size.width = self.tg_width.measure(rectSuper.width - leftMargin - rightMargin)
                isAdjust = true
            }
            else if self.tg_width.dimeRelaVal != nil
            {
                if self.tg_width.dimeRelaVal.view === newSuperview
                {
                    rectSelf.size.width = self.tg_width.measure(rectSuper.width)
                }
                else
                {
                    rectSelf.size.width = self.tg_width.measure(self.tg_width.dimeRelaVal.view.tg_estimatedFrame.width)
                }
                
                isAdjust = true
                
            }
            else if self.tg_width.dimeWeightVal != nil
            {
                rectSelf.size.width = self.tg_width.measure(rectSuper.width * self.tg_width.dimeWeightVal.rawValue / 100)
                isAdjust = true
            }
            else
            {
                rectSelf.size.width = self.tg_width.measure;
            }
        }
        
        rectSelf.size.width = self.tgValidMeasure(self.tg_width,sbv:self,calcSize:rectSelf.width,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size);
        
        if (self.tg_left.hasValue && self.tg_right.hasValue)
        {
            
            isAdjust = true;
            self.tg_width.equal(nil)
            rectSelf.size.width = rectSuper.width - leftMargin - rightMargin
            rectSelf.size.width = self.tgValidMeasure(self.tg_width,sbv:self,calcSize:rectSelf.width,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size);
            
            rectSelf.origin.x = leftMargin
        }
        else if (self.tg_centerX.hasValue)
        {
            isAdjust = true;
            rectSelf.origin.x = (rectSuper.width - rectSelf.width)/2 + self.tg_centerX.realMarginInSize(rectSuper.width)
        }
        else if (self.tg_left.hasValue)
        {
            rectSelf.origin.x = leftMargin
        }
        else if (self.tg_right.hasValue)
        {
            isAdjust = true;
            rectSelf.origin.x  = rectSuper.width - rectSelf.width - rightMargin
        }
        else
        {
            
        }
        
        
        if (!self.tg_height.isWrap && self.tg_height.hasValue)
        {
            if  self.tg_height.isFill
            {
                rectSelf.size.height = self.tg_height.measure(rectSuper.height - topMargin - bottomMargin)
                isAdjust = true;
            }
            else if self.tg_height.dimeRelaVal != nil
            {
                if self.tg_height.dimeRelaVal.view === newSuperview
                {
                    rectSelf.size.height = self.tg_height.measure(rectSuper.height)
                }
                else
                {
                    rectSelf.size.height = self.tg_height.measure(self.tg_height.dimeRelaVal.view.tg_estimatedFrame.height)
                }
                
                isAdjust = true

            }
            else if self.tg_height.dimeWeightVal != nil
            {
                rectSelf.size.height = self.tg_height.measure(rectSuper.height * self.tg_height.dimeWeightVal.rawValue / 100)
                isAdjust = true;
            }
            else
            {
                rectSelf.size.height = self.tg_height.measure
            }
        }
        
        rectSelf.size.height = self.tgValidMeasure(self.tg_height,sbv:self,calcSize:rectSelf.height,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size);
        
        if (self.tg_top.hasValue && self.tg_bottom.hasValue)
        {
            isAdjust = true;
            self.tg_height.equal(nil)
            rectSelf.size.height = rectSuper.height - topMargin - topMargin
            rectSelf.size.height = self.tgValidMeasure(self.tg_height,sbv:self,calcSize:rectSelf.height,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size)
            
            rectSelf.origin.y = topMargin
        }
        else if (self.tg_centerY.hasValue)
        {
            isAdjust = true;
            rectSelf.origin.y = (rectSuper.height - rectSelf.height)/2 + self.tg_centerY.realMarginInSize(rectSuper.height)
        }
        else if (self.tg_top.hasValue)
        {
            rectSelf.origin.y = topMargin
        }
        else if (self.tg_bottom.hasValue)
        {
            isAdjust = true;
            rectSelf.origin.y  = rectSuper.height - rectSelf.height - bottomMargin
        }
        else
        {
            
        }
        
        
        
        if (!rectSelf.equalTo(oldSelfRect))
        {
            self.bounds = CGRect(x:self.bounds.origin.x, y:self.bounds.origin.y,width:rectSelf.width, height:rectSelf.height)
            self.center = CGPoint(x:rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.width, y:rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.height)
        }
        else if (self.tg_width.isWrap || self.tg_height.isWrap)
        {
            self.setNeedsLayout()
        }
        
        return isAdjust;
        
    }
    

    
    fileprivate func tgAlterScrollViewContentSize(_ newSize:CGSize)
    {
        if let scrolv = self.superview as? UIScrollView , self.tg_adjustScrollViewContentSizeMode == .yes
        {
            var contSize = scrolv.contentSize
            let rectSuper = scrolv.bounds
            
            //这里把自己在父视图中的上下左右边距也算在contentSize的包容范围内。
            let leftMargin = self.tg_left.realMarginInSize(rectSuper.width)
            let rightMargin = self.tg_right.realMarginInSize(rectSuper.width)
            let topMargin = self.tg_top.realMarginInSize(rectSuper.height)
            let bottomMargin = self.tg_bottom.realMarginInSize(rectSuper.height)
            
            if contSize.height != newSize.height + topMargin + bottomMargin
            {
                contSize.height = newSize.height + topMargin + bottomMargin
            }
            if contSize.width != newSize.width + leftMargin + rightMargin
            {
                contSize.width = newSize.width + leftMargin + rightMargin
            }
            
            scrolv.contentSize = contSize
            
        }
    }

    
    internal func tgCalcVertGravity(_ vert:TGGravity, selfSize:CGSize, sbv:UIView, rect:CGRect) ->CGRect
    {
        let fixedHeight = self.tg_padding.top + self.tg_padding.bottom;
        let topMargin =  self.tgValidMargin(sbv.tg_top, sbv: sbv, calcPos: sbv.tg_top.realMarginInSize(selfSize.height - fixedHeight), selfLayoutSize: selfSize)
        let centerMargin = self.tgValidMargin(sbv.tg_centerY, sbv: sbv, calcPos: sbv.tg_centerY.realMarginInSize(selfSize.height - fixedHeight), selfLayoutSize: selfSize)
        let bottomMargin = self.tgValidMargin(sbv.tg_bottom, sbv: sbv, calcPos: sbv.tg_bottom.realMarginInSize(selfSize.height - fixedHeight), selfLayoutSize: selfSize)
        
        var retRect = rect
        if vert == TGGravity.vert.fill
        {
            retRect.origin.y = self.tg_padding.top + topMargin;
            retRect.size.height = self.tgValidMeasure(sbv.tg_height, sbv: sbv, calcSize:selfSize.height - fixedHeight - topMargin - bottomMargin , sbvSize: rect.size, selfLayoutSize: selfSize)
        }
        else if vert == TGGravity.vert.center
        {
            retRect.origin.y = (selfSize.height - fixedHeight - topMargin - bottomMargin - retRect.size.height)/2 + self.tg_padding.top + topMargin + centerMargin;
        }
        else if vert == TGGravity.vert.windowCenter
        {
            if let twindow = self.window
            {
                retRect.origin.y = (twindow.frame.size.height - topMargin - bottomMargin - retRect.size.height)/2 + topMargin + centerMargin;
                retRect.origin.y =  twindow.convert(retRect.origin, to:self as UIView?).y;
            }
            
        }
        else if vert == TGGravity.vert.bottom
        {
            
            retRect.origin.y = selfSize.height - self.tg_padding.bottom - bottomMargin - retRect.size.height;
        }
        else
        {
            retRect.origin.y = self.tg_padding.top + topMargin;
        }
        
        return retRect
        
    }
    
    
    
    internal func tgCalcHorzGravity(_ horz:TGGravity, selfSize:CGSize, sbv:UIView, rect:CGRect) ->CGRect
    {
        let fixedWidth = self.tg_padding.left + self.tg_padding.right;
        let leftMargin =  self.tgValidMargin(sbv.tg_left, sbv: sbv, calcPos: sbv.tg_left.realMarginInSize(selfSize.width - fixedWidth), selfLayoutSize: selfSize)
        let centerMargin = self.tgValidMargin(sbv.tg_centerX, sbv: sbv, calcPos: sbv.tg_centerX.realMarginInSize(selfSize.width - fixedWidth), selfLayoutSize: selfSize)
        let rightMargin = self.tgValidMargin(sbv.tg_right, sbv: sbv, calcPos: sbv.tg_right.realMarginInSize(selfSize.width - fixedWidth), selfLayoutSize: selfSize)
        
        var retRect = rect
        if horz == TGGravity.horz.fill
        {
            
            retRect.origin.x = self.tg_padding.left + leftMargin;
            retRect.size.width =  self.tgValidMeasure(sbv.tg_width, sbv: sbv, calcSize:selfSize.width - fixedWidth - leftMargin - rightMargin , sbvSize: rect.size, selfLayoutSize: selfSize)
        }
        else if horz == TGGravity.horz.center
        {
            retRect.origin.x = (selfSize.width - fixedWidth - leftMargin - rightMargin - retRect.size.width)/2 + self.tg_padding.left + leftMargin + centerMargin;
        }
        else if horz == TGGravity.horz.windowCenter
        {
            if let twindow = self.window
            {
                retRect.origin.x = (twindow.frame.size.width - leftMargin - rightMargin - retRect.size.width)/2 + leftMargin + centerMargin;
                retRect.origin.x =  twindow.convert(retRect.origin, to:self as UIView?).x;
            }
            
        }
        else if horz == TGGravity.horz.right
        {
            
            retRect.origin.x = selfSize.width - self.tg_padding.right - rightMargin - retRect.size.width;
        }
        else
        {
            retRect.origin.x = self.tg_padding.left + leftMargin;
        }
        
        return retRect
        
    }
    
    
    internal func tgIsNoLayoutSubview(_ sbv:UIView) ->Bool
    {
        return ((sbv.isHidden || sbv.tgFrame.sizeClass.isHidden) && !self.tg_layoutHiddenSubviews) || sbv.tg_useFrame;
    }
    
    
    internal func tgGetLayoutSubviews() ->[UIView]
    {
        return self.tgGetLayoutSubviewsFrom(sbsFrom: self.subviews)
    }
    
    
    internal func  tgGetLayoutSubviewsFrom(sbsFrom:[UIView])->[UIView]
    {
        var sbs:[UIView] = [UIView]()
        let isReverseLayout = self.tg_reverseLayout;
        for sbv in sbsFrom
        {
            if self.tgIsNoLayoutSubview(sbv)
            {
                continue
            }
            
            if isReverseLayout
            {
                sbs.insert(sbv, at: 0)
            }
            else
            {
                sbs.append(sbv)
                
            }
        }
        
        return sbs
        
    }
    

    
    
    
    internal func tgCalcSizeFromSizeWrapSubview(_ sbv:UIView)
    {
        //只有非布局视图才这样处理。
        //如果宽度wrap并且高度wrap的话则直接调用sizeThatFits方法。
        //如果只是宽度wrap高度固定则依然可以调用sizeThatFits方法，不过这种场景基本不存在。
        //如果高度wrap但是宽度固定则适用flexHeight的规则，这里不适用。
        //最终的结果是非布局视图的宽度是wrap的情况下适用。
        if  (sbv as? TGBaseLayout) == nil , sbv.tg_width.isWrap
        {
            
            let fitSize = sbv.sizeThatFits(.zero)
            sbv.tgFrame.width = sbv.tg_width.measure(fitSize.width)
            sbv.tgFrame.height = sbv.tg_height.measure(fitSize.height)
            
        }
    }
        
}

private var ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES"
private var ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS = "ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS"


internal class TGFrame:NSObject {
    
    var top:CGFloat = CGFloat.greatestFiniteMagnitude
    var left:CGFloat = CGFloat.greatestFiniteMagnitude
    var bottom:CGFloat = CGFloat.greatestFiniteMagnitude
    var right:CGFloat = CGFloat.greatestFiniteMagnitude
    var width:CGFloat = CGFloat.greatestFiniteMagnitude
    var height:CGFloat = CGFloat.greatestFiniteMagnitude
    
    weak var sizeClass:TGViewSizeClass! = nil
    
    
    func reset()
    {
        self.top = CGFloat.greatestFiniteMagnitude
        self.left = CGFloat.greatestFiniteMagnitude
        self.bottom = CGFloat.greatestFiniteMagnitude
        self.right = CGFloat.greatestFiniteMagnitude
        self.width = CGFloat.greatestFiniteMagnitude
        self.height = CGFloat.greatestFiniteMagnitude
    }
    
    
    var frame:CGRect
        {
        get
        {
            return CGRect(x: left, y: top, width: width, height: height)
        }
        set
        {
            top = newValue.origin.y
            left = newValue.origin.x
            width = newValue.size.width
            height = newValue.size.height
            bottom = top + height
            right = left + width
        }
    }
    
}



extension UIView
{
    
    internal var tgFrame:TGFrame
    {
        var obj:AnyObject! = objc_getAssociatedObject(self, &ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS) as AnyObject!
        if obj == nil
        {
            obj = TGFrame()
            
            objc_setAssociatedObject(self,&ASSOCIATEDOBJECT_KEY_MYLAYOUT_ABSPOS, obj!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return obj as! TGFrame
    }
    
    
    fileprivate func tgIntFromSizeClassType(_ type:TGSizeClassType?) -> Int
    {
        if type == nil
        {
            return 0xFF
        }
        
        var retInt = 0
        
        switch type! {
        case .comb(let width, let height, let screen):
            switch width {
            case .compact:
                retInt |= 1
                break
            case .regular:
                retInt |= 2
                break
            default:
                retInt |= 0
                break
            }
            
            switch height {
            case .compact:
                retInt |= 4
                break
            case .regular:
                retInt |= 8
                break
            default:
                retInt |= 0
            }
            if screen != nil
            {
                switch screen! {
                case .portrait:
                    retInt |= 64
                    break
                case .landscape:
                    retInt |= 128
                    break
                }
            }
            break
        case .portrait:
            retInt = 64
            break
        case .landscape:
            retInt = 128
            break
        default:
            break
        }
        
        return retInt;
    }
    
    
    
    fileprivate var tgDefaultSizeClass:TGViewSizeClass
    {
        return tgMatchBestSizeClass(.default)
    }
    
    internal func tgMatchBestSizeClass(_ type:TGSizeClassType) ->TGViewSizeClass
    {
        var wsc = 0
        var hsc = 0
        var ori = 0
        let typeInt = self.tgIntFromSizeClassType(type)
        if atof(UIDevice.current.systemVersion) >= 8.0
        {
            switch type {
            case .comb(let width, let height, let screen):
                switch width {
                case .compact:
                    wsc  = 1
                    break
                case .regular:
                    wsc = 2
                    break
                default:
                    break
                }
                
                switch height {
                case .compact:
                    hsc = 4
                    break
                case .regular:
                    hsc = 8
                    break
                default:
                    break
                }
                if screen != nil
                {
                    switch screen! {
                    case .portrait:
                        ori = 64
                        break
                    case .landscape:
                        ori = 128
                        break
                    }
                }
                break
            case .portrait:
                ori = 64
                break
            case .landscape:
                ori = 128
                break
            default:
                break
            }
        }
        
        
        //分别取出
        
        var dict:NSMutableDictionary! = objc_getAssociatedObject(self, &ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES) as? NSMutableDictionary
        
        if dict == nil
        {
            dict = NSMutableDictionary()
            objc_setAssociatedObject(self, &ASSOCIATEDOBJECT_KEY_MYLAYOUT_SIZECLASSES, dict!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        
        var searchTypeInt:Int = wsc | hsc | ori
        var sizeClass:TGViewSizeClass! = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
        if sizeClass != nil
        {
            return sizeClass!
        }
        
        searchTypeInt = wsc | hsc
        if (searchTypeInt != typeInt)
        {
            sizeClass = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
            if sizeClass != nil
            {
                return sizeClass!
            }
        }
        
        
        searchTypeInt =  hsc | ori
        if ori != 0 && searchTypeInt != typeInt
        {
            sizeClass = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
            if sizeClass != nil
            {
                return sizeClass!
            }
        }
        
        searchTypeInt =  hsc;
        if searchTypeInt != typeInt
        {
            sizeClass = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
            if sizeClass != nil
            {
                return sizeClass!
            }
        }
        
        searchTypeInt = wsc | ori
        if ori != 0 && searchTypeInt != typeInt
        {
            sizeClass = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
            if sizeClass != nil
            {
                return sizeClass!
            }
        }
        
        searchTypeInt = wsc
        if searchTypeInt != typeInt
        {
            sizeClass = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
            if sizeClass != nil
            {
                return sizeClass!
            }
        }
        
        searchTypeInt = ori
        if ori != 0 && searchTypeInt != typeInt
        {
            sizeClass = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
            if sizeClass != nil
            {
                return sizeClass!
            }
        }
        
        searchTypeInt = 0
        sizeClass = dict.object(forKey: searchTypeInt) as? TGViewSizeClass
        if (sizeClass == nil)
        {
            sizeClass = self.tgCreateInstance() as! TGViewSizeClass
            dict.setObject(sizeClass!, forKey: searchTypeInt as NSCopying)
        }
        
        return sizeClass!
        
    }
    
    
    internal var tgCurrentSizeClass:TGViewSizeClass
    {
        if self.tgFrame.sizeClass == nil
        {
            self.tgFrame.sizeClass = self.tgDefaultSizeClass
        }
        
        return self.tgFrame.sizeClass
    }
    
    
    func tgCreateInstance() -> AnyObject
    {
        return TGViewSizeClassImpl()
    }
    
}

private class TGBorderlineLayerDelegate: NSObject,CALayerDelegate
{
    private weak var layout:TGBaseLayout!
    
    init(layout:TGBaseLayout) {
        
        self.layout = layout
        super.init()
    }
    
    func layoutSublayers(of layer: CALayer)
    {
        if self.layout == nil
        {
            return
        }
        
        let layoutSize:CGSize = self.layout.layer.bounds.size;
        
        var layerRect:CGRect;
        var fromPoint:CGPoint;
        var toPoint:CGPoint;
        
        if self.layout._leftBorderlineLayer != nil && layer === self.layout._leftBorderlineLayer!
        {
            layerRect = CGRect(x: 0, y: self.layout.tg_leftBorderline.headIndent, width: self.layout.tg_leftBorderline.thick/2, height: layoutSize.height - self.layout.tg_leftBorderline.headIndent - self.layout.tg_leftBorderline.tailIndent);
            fromPoint = CGPoint(x: 0, y: 0);
            toPoint = CGPoint(x: 0, y: layerRect.size.height);
            
        }
        else if self.layout._rightBorderlineLayer != nil && layer === self.layout._rightBorderlineLayer!
        {
            layerRect = CGRect(x: layoutSize.width - self.layout.tg_rightBorderline.thick / 2, y: self.layout.tg_rightBorderline.headIndent, width: self.layout.tg_rightBorderline.thick / 2, height: layoutSize.height - self.layout.tg_rightBorderline.headIndent - self.layout.tg_rightBorderline.tailIndent);
            fromPoint = CGPoint(x: 0, y: 0);
            toPoint = CGPoint(x: 0, y: layerRect.size.height);
            
        }
        else if self.layout._topBorderlineLayer != nil && layer === self.layout._topBorderlineLayer!
        {
            layerRect = CGRect(x: self.layout.tg_topBorderline.headIndent, y: 0, width: layoutSize.width - self.layout.tg_topBorderline.headIndent - self.layout.tg_topBorderline.tailIndent, height: self.layout.tg_topBorderline.thick/2);
            fromPoint = CGPoint(x: 0, y: 0);
            toPoint = CGPoint(x: layerRect.size.width, y: 0);
        }
        else if self.layout._bottomBorderlineLayer != nil && layer === self.layout._bottomBorderlineLayer!
        {
            layerRect = CGRect(x: self.layout.tg_bottomBorderline.headIndent, y: layoutSize.height - self.layout.tg_bottomBorderline.thick / 2, width: layoutSize.width - self.layout.tg_bottomBorderline.headIndent - self.layout.tg_bottomBorderline.tailIndent, height: self.layout.tg_bottomBorderline.thick/2);
            fromPoint = CGPoint(x: 0, y: 0);
            toPoint = CGPoint(x: layerRect.size.width, y: 0);
        }
        else
        {
            
            assert(false, "oops!")
            layerRect = CGRect.zero
            fromPoint = CGPoint.zero
            toPoint = CGPoint.zero
        }
        
        
        //把动画效果取消。
        if (!layer.frame.equalTo(layerRect))
        {
            
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions);
            
            let shapeLayer:CAShapeLayer = layer as! CAShapeLayer
            
            if shapeLayer.lineDashPhase == 0
            {
                shapeLayer.path = nil;
            }
            else
            {
                let path:CGMutablePath = CGMutablePath()
                path.move(to: fromPoint)
                path.addLine(to: toPoint)
                shapeLayer.path = path
                
            }
            
            layer.frame = layerRect
            
            CATransaction.commit()
        }
        
    }
    
    
}

internal func _tgCGFloatEqual(_ f1:CGFloat, _ f2:CGFloat) -> Bool
{
    //print("aa\(DBL_EPSILON)")
    
   if CGFloat.NativeType.self == Double.self
   {
    return abs(f1 - f2) < 1e-6

    }
    else
   {
    return abs(f1 - f2) < 1e-4

    }
    
    
}

internal func _tgCGFloatNotEqual(_ f1:CGFloat, _ f2:CGFloat) -> Bool
{
    if CGFloat.NativeType.self == Double.self
    {
        return abs(f1 - f2) > 1e-6
    }
    else
    {
        return abs(f1 - f2) > 1e-4
    }
}

internal func _tgCGFloatLessOrEqual(_ f1:CGFloat, _ f2:CGFloat) -> Bool
{
    if CGFloat.NativeType.self == Double.self
    {
        return f1 < f2 || abs(f1 - f2) < 1e-6
    }
    else
    {
        return f1 < f2 || abs(f1 - f2) < 1e-4
        
    }
}

internal func _tgCGFloatGreatOrEqual(_ f1:CGFloat, _ f2:CGFloat) -> Bool
{
    if CGFloat.NativeType.self == Double.self
    {
        return f1 > f2 || abs(f1 - f2) < 1e-6
    }
    else
    {
        return f1 > f2 || abs(f1 - f2) < 1e-4
        
    }
    
}



