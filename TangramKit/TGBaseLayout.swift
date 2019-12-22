//
//  TGBaseLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


extension UIView:TGViewSizeClass
{
    
    /*
     1.布局视图：    就是从TGBaseLayout派生而出的视图，目前TangramKit中一共有：线性布局、框架布局、相对布局、表格布局、流式布局、浮动布局、路径布局7种布局。 布局视图也是一个视图。
     2.非布局视图：  除上面说的7种布局视图外的所有视图和控件。
     3.布局父视图：  如果某个视图的父视图是一个布局视图，那么这个父视图就是布局父视图。
     4.非布局父视图：如果某个视图的父视图不是一个布局视图，那么这个父视图就是非布局父视图。
     5.布局子视图：  如果某个视图的子视图是一个布局视图，那么这个子视图就是布局子视图。
     6.非布局子视图：如果某个视图的子视图不是一个布局视图，那么这个子视图就是非布局子视图。
     
     */
    
    
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
     比如垂直线性布局视图L分别添加了A,B两个子视图且设置A.tg_top.equal(10),A.tg_bottom.equal(10),B.tg_top.equal(10)的意思是A的顶部间距是10，底部间距也是10。视图B的顶部间距10。这样视图B和视图A之间的间距就是20
     Scene3:布局位置对象的值设置为TGWeight,表示的是相对比重值,表示视图之间的相对间距值或者边距值。
     视图的相对间距的最终距离 = (布局视图尺寸 - 所有具有固定尺寸和固定间距之和) * 当前视图的相对间距值 /(所有子视图相对间距的总和)
     视图的相对边距的最终距离 = 布局视图尺寸 * 当前视图的相对边距值
     
     Scene4:布局位置对象的值设置为TGLayoutPos对象，表示某个位置依赖于另外一个位置。只有在相对布局中的子视图的布局位置对象的位置值才能设置为TGLayoutPos对象。
     比如： A.tg_left.equal(B.tg_right)表示视图A的左边等于视图B的右边。
     
     Scene5:布局位置对象的值设置为[TGLayoutPos]数组对象，表示一组视图整体居中。只有在相对布局中的子视图的tg_centerX或者tg_centerY中的位置值才可以被设置为这种值。
     比如：A.tg_centerX.equal([B.tg_centerX,C.tg_centerX])表示A,B,C三个子视图在相对布局中整体水平居中。
     
     Scene6:当同时设置了tg_left和tg_right左右边距后就能确定出视图的布局宽度了，这样就不需要为子视图指定布局宽度值了。需要注意的是只有同时设置了左右边距才能确定视图的宽度，而设置左右间距时则不能。
     比如：某个布局布局视图的宽度是100，而某个子视图的tg_left.equal(10),tg_right.equal(20).则这个子视图的宽度=70(100-10-20)
     
     Scene7:当同时设置了tg_top和tg_bottom上下边距后就能确定出视图的布局高度了，这样就不需要为子视图指定布局高度值了。需要注意的是只有同时设置了上下边距才能确定视图的高度，而设置上下间距是则不能。
     比如：某个布局布局视图高度是100，而某个子视图的tg_top.equal(10),tg_bottom.equal(20).则这个子视图的高度=70(100-10-20)
     
     
     
     
     这要区分一下边距和间距和概念，所谓边距是指子视图距离父视图的距离；而间距则是指子视图距离兄弟视图的距离。
     当tg_left,tg_right,tg_top,tg_bottom这四个属性的equal方法设置的值为CGFloat类型或者TGWeight类型时即可用来表示边距也可以用来表示间距，这个要根据子视图所归属的父布局视图的类型而确定：
     
     1.垂直线性布局TGLinearLayout中的子视图： tg_left,tg_right表示边距，而tg_top,tg_bottom则表示间距。
     2.水平线性布局TGLinearLayout中的子视图： tg_left,tg_right表示间距，而tg_top,tg_bottom则表示边距。
     3.表格布局中的子视图：                  tg_left,tg_right,tg_top,tg_bottom的定义和线性布局是一致的。
     4.框架布局TGFrameLayout中的子视图：     tg_left,tg_right,tg_top,tg_bottom都表示边距。
     5.相对布局TGRelativeLayout中的子视图：  tg_left,tg_right,tg_top,tg_bottom都表示边距。
     6.流式布局TGFlowLayout中的子视图：      tg_left,tg_right,tg_top,tg_bottom都表示间距。
     7.浮动布局TGFloatLayout中的子视图：     tg_left,tg_right,tg_top,tg_bottom都表示间距。
     8.路径布局TGPathLayout中的子视图：      tg_left,tg_right,tg_top,tg_bottom即不表示间距也不表示边距，它表示自己中心位置的偏移量。
     9.非布局父视图中的布局子视图：            tg_left,tg_right,tg_top,tg_bottom都表示边距。
     10.非布局父视图中的非布局子视图：         tg_left,tg_right,tg_top,tg_bottom的设置不会起任何作用，因为TangramKit已经无法控制了。
     
     再次强调的是：
     1. 如果同时设置了左右边距就能决定自己的宽度，同时设置左右间距不能决定自己的宽度！
     2. 如果同时设置了上下边距就能决定自己的高度，同时设置上下间距不能决定自己的高度！
     
     
     */
    
    
    /// 视图的上边布局位置对象。(top layout position of the view.)
    public var tg_top:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_top
    }
    
    
    /// 视图的头部布局位置对象,对于非阿拉伯国家就是左边，对于阿拉伯国家就是右边(leading layout position of the view.)
    public var tg_leading:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_leading
    }
    
    
    /// 视图的下边布局位置对象。(bottom layout position of the view.)
    public var tg_bottom:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_bottom
    }
    
    
    /// 视图的尾部布局位置对象,对于非阿拉伯国家就是右边，对于阿拉伯国家就是左边。(trailing layout position of the view.)
    public var tg_trailing:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_trailing
    }
    
    
    /// 视图的水平中心布局位置对象。(horizontal center layout position of the view.)
    public var tg_centerX:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_centerX
    }
    
    
    /// 视图的垂直中心布局位置对象。(vertical center layout position of the view.)
    public var tg_centerY:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_centerY
    }
    
    
    /// 视图的左边布局位置对象。(left layout position of the view.)
    public var tg_left:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_left
    }
    

    /// 视图的右边布局位置对象。(right layout position of the view.)
    public var tg_right:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_right
    }
    
    /// 视图的基线位置对象。目前只支持相对布局里面的视图的设置并且调用视图或者被调用视图都只能是UILabel和UITextField和UITextView三个只支持单行文本的视图。
    public var tg_baseline:TGLayoutPos
    {
        return self.tgCurrentSizeClass.tg_baseline
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
     +-----------+-------+--------+----+----+----------------+---------------+----------+-----------+--------------+--------------+--------------+
     | 对象 \ 值  |CGFloat|TGWeight|wrap|fill|A.tg_width      |A.tg_height    |B.tg_width|B.tg_height|S.tg_width    |S.tg_heigh    |[TGLayoutSize]|
     +-----------+-------+--------+----+----+----------------+---------------+----------+-----------+--------------+--------------+--------------+
     |A.tg_width |ALL    |ALL     |ALL |ALL | -   	        |FR/R/FL-H/FO/LH|FR/R/FO/P | R	       |ALL           | R	         |R             |
     +-----------+-------+--------+----+----+----------------+---------------+----------+-----------+--------------+--------------+--------------+
     |A.tg_height|ALL    |ALL     |ALL |ALL |FR/R/FL-V/FO/L  |-              |R	       |FR/R/FO/P  |R             |ALL           |R             |
     +-----------+-------+--------+----+----+----------------+---------------+----------+-----------+--------------+--------------+--------------+
     
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
     
     
     .wrap属性值则表示视图的尺寸是有内容或者其子视图来决定的。比如UILabel的宽度希望由自身的内容决定，那么就可以设置tg_width.equal(.wrap),同样对于布局视图也是一样的，这里的wrap对于布局视图来说其实就是OC版本的wrapContentWidth和wrapContentHeight的概念。如果某个子视图的宽度是固定的，而高度则自适应则我们可以定义如下：
     let label = UILabel()
     label.tg_width ~= 100
     label.tg_height ~=.wrap
     
     同样如果一个线性布局里面的宽度和高度都希望由子视图决定则可以如下处理：
     let l = TGLinearLayout(.vert)
     l.tg_width.equal(.wrap)
     l.tg_height.equal(.wrap)
     
     
     .fill属性则表示视图的尺寸会填充父视图的剩余空间，这个和TGWeight(100)是等价的。比如某个子视图的宽度想填充父视图的宽度相等则：
     a.tg_width.equal(.fill)  <==>  a.tg_width.equal(100%)
     
     */
    
    
    
    
    /// 视图的宽度布局尺寸对象，可以通过其中的euqal方法来设置CGFloat,TGLayoutSize,[MyLayoutSize],TGWeight,TGLayoutSize.Special,nil这六种值
    public var tg_width:TGLayoutSize
    {
        return self.tgCurrentSizeClass.tg_width
    }
    
    
    /// 视图的高度布局尺寸对象，可以通过其中的euqal方法来设置CGFloat,TGLayoutSize,[MyLayoutSize],TGWeight,TGLayoutSize.Special,nil这六种值
    public var tg_height:TGLayoutSize
    {
        return self.tgCurrentSizeClass.tg_height
    }
    
    
    /**
     设置视图不受布局父视图的布局约束控制和不再参与视图的布局，所有设置的其他扩展属性都将失效而必须用frame来设置视图的位置和尺寸，默认值是false。这个属性主要用于某些视图希望在布局视图中进行特殊处理和进行自定义的设置的场景。比如一个垂直线性布局下有A,B,C三个子视图设置如下：
   
     A.tg_size(width:100,height:100)
     B.tg_size(width:100,height:50)
     C.tg_size(width:100,height:200)
     B.frame = CGRect(x:20,y:20,width:200,height:100)
     
     正常情况下当布局完成后:
     
     A.frame == {0,0,100,100}
     B.frame == {0,100,100,50}  //可以看出即使B设置了frame值，但是因为布局约束属性优先级高所以对B设置的frame值是无效的。
     C.frame == {0,150,100,200}
     
     而当我们设置如下时：
     
     A.tg_size(width:100,height:100)
     B.tg_size(width:100,height:50)
     C.tg_size(width:100,height:200)
     B.frame = CGRect(x:20,y:20,width:200,height:100)
     B.tg_useFrame = true
     
     那么在布局完成后：
     
     A.frame == {0, 0, 100, 100}
     B.frame == {20,20,200,100}   //可以看出B并没有受到约束的限制，结果就是B设置的frame值。
     C.frame == {0, 100,100,200}  //因为B不再参与布局了，所以C就往上移动了，由原来的150变为了100.

     tg_useFrame的应用场景是某个视图虽然是布局视图的子视图但不想受到父布局视图的约束，而是可以通过frame进行自由位置和尺寸调整的场景。
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
     设置视图在进行布局时只会参与布局但不会真实的调整位置和尺寸，默认值是false。当设置为YES时会在布局时保留出视图的布局位置和布局尺寸的空间，但不会更新视图的位置和尺寸，也就是说只会占位但不会更新。因此你可以通过frame值来进行位置和尺寸的任意设置，而不会受到你的布局视图的影响。这个属性主要用于某些视图希望在布局视图中进行特殊处理和进行自定义的设置的场景。比如一个垂直线性布局下有A,B,C三个子视图设置如下：
   
     A.tg_size(width:100,height:100)
     B.tg_size(width:100,height:50)
     C.tg_size(width:100,height:200)
     B.frame = CGRect(x:20,y:20,width:200,height:100)
     
     正常情况下当布局完成后:
     
     A.frame == {0,0,100,100}
     B.frame == {0,100,100,50}  //可以看出即使B设置了frame值，但是因为布局约束属性优先级高所以对B设置的frame值是无效的。
     C.frame == {0,150,100,200}
     
     而当我们设置如下时：
     
     A.tg_size(width:100,height:100)
     B.tg_size(width:100,height:50)
     C.tg_size(width:100,height:200)
     B.frame = CGRect(x:20,y:20,width:200,height:100)
     B.tg_noLayout = true
     
     那么在布局完成后：
    
     A.frame == {0,0,100,100}
     B.frame == {20,20,200,100}  //可以看出虽然B参与了布局，但是并没有更新B的frame值，而是保持为通过frame设置的原始值。
     C.frame == {0,150,100,200}  //因为B参与了布局，占用了50的高度，所以这里C的位置还是150，而不是100.
     
     
    tg_useFrame和tg_noLayout的区别是：
    
     1. 前者不会参与布局而必须要通过frame值进行设置，而后者则会参与布局但是不会将布局的结果更新到frame中。
     2. 当前者设置为true时后者的设置将无效，而后者的设置并不会影响前者的设置。
     
     tg_noLayout的应用场景是那些想在运行时动态调整某个视图的位置和尺寸，但是又不想破坏布局视图中其他子视图的布局结构的场景，也就是调整了视图的位置和尺寸，但是不会调整其他的兄弟子视图的位置和尺寸。
     
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
    
    /**
     指定视图的可见性，默认是visible。这个属性是对视图hidden属性的扩展，布局系统对视图的hidden属性设置后，视图将不再参与布局。但在实际中有些场景我们希望视图隐藏后
     仍然会占用空间仍然会参与布局。因此我们可以用这个属性来设置当视图隐藏后是否继续参与布局。
     如果您使用了这个属性来对视图进行隐藏和取消隐藏操作则请不要再去操作hidden属性，否则可能出现二者效果不一致的情况。因此建议视图的隐藏和显示用这个属性进行设置。
     在老版本中布局中的子视图隐藏时要么都参与布局，要么都不参与布局，这是通过布局属性tg_layoutHiddenSubviews来设置，新版本中这个属性将会设置为无效了！
     
     tg_visiblity可以设置的值如下：
       - visible:     视图可见，等价于hidden = false
       - invisible:   视图不可见，等价于hidden = true, 但是会在父布局视图中占位空白区域
       - gone:        视图不可见，等价于hidden = true, 但是不会在父视图中占位空白区域
     */
    public var tg_visibility:TGVisibility
        {
        get
        {
            return self.tgCurrentSizeClass.tg_visibility
        }
        set
        {
            let sc = self.tgCurrentSizeClass
            if sc.tg_visibility != newValue
            {
                sc.tg_visibility = newValue
                
                switch newValue {
                case TGVisibility.visible:
                    self.isHidden = false
                    break
                default:
                    self.isHidden = true
                }
                
                if let sView = self.superview
                {
                    sView.setNeedsLayout()
                }
            }
        }
    }
    
    
    ///指定子在布局视图上的对齐方式，默认是.none表示未指定，这个属性目前只支持框架布局，线性布局，流式布局下的属性设置.
    /// - 在框架布局中支持上、中、下、垂直拉伸和左、中、右、水平拉伸8个设置
    /// - 在垂直线性布局中只支持左、中、右、水平拉伸对齐。(如果父布局视图设置了gravity，子视图设置了这个属性则这个属性优先级最高)
    /// - 在水平线性布局中只支持上、中、下、垂直拉伸对齐。(如果父布局视图设置了gravity，子视图设置了这个属性则这个属性优先级最高)
    /// - 在垂直流式布局中用来设置一行内的上、中、下、垂直拉伸对齐。(如果父布局视图设置了arrangedGravity，子视图设置了这个属性则这个属性优先级最高)
    /// - 在水平流式布局中用来设置一列内的左、中、右、水平拉伸对齐。(如果父布局视图设置了arrangedGravity，子视图时设置了这个属性则这个属性优先级最高)
    public var tg_alignment:TGGravity
        {
        get
        {
            return self.tgCurrentSizeClass.tg_alignment
        }
        set
        {
            let sc = self.tgCurrentSizeClass
            if sc.tg_alignment != newValue
            {
                
                sc.tg_alignment = newValue
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
    
    /// 设置开始位置的快捷方法。
    ///
    /// - Parameter point: 左上角原点的位置
    public func tg_origin(_ point:CGPoint)
    {
        self.tg_leading.equal(point.x)
        self.tg_top.equal(point.y)
    }
    
    
    /// 设置开始位置的快捷方法。
    ///
    /// - Parameters:
    ///   - x: 水平方向的位置
    ///   - y: 垂直方向的位置
    public func tg_origin(x:TGLayoutPosType, y:TGLayoutPosType)
    {
        self.tg_leading.equalHelper(val: x)
        self.tg_top.equalHelper(val: y)
    }
    

    
    ///
    ///
    /// - Parameter point: 右下角的结束位置
    public func tg_end(_ point:CGPoint)
    {
        self.tg_trailing.equal(point.x)
        self.tg_bottom.equal(point.y)
    }
    
    
    /// 设置结束位置的快捷方式
    ///
    /// - Parameters:
    ///   - x: 水平方向的位置
    ///   - y: 垂直方向的位置
    public func tg_end(x:TGLayoutPosType, y:TGLayoutPosType)
    {
        self.tg_trailing.equalHelper(val:x)
        self.tg_bottom.equalHelper(val:y)
    }
    
    /// 同时设置tg_width和tg_height的简化方法。
    ///
    /// - Parameter size: 宽度和高度值
    public func tg_size(_ size: CGSize)
    {
        self.tg_width.equal(size.width)
        self.tg_height.equal(size.height)
    }
    
    
    /// 同时设置tg_width和tg_height的简化方法。
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    public func tg_size(width:TGLayoutSize, height:TGLayoutSize)
    {
        self.tg_width.equal(width)
        self.tg_height.equal(height)
    }
    
    
    /// 同时设置tg_width和tg_height的简化方法。
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    public func tg_size(width:TGLayoutSizeType, height:TGLayoutSize)
    {
        self.tg_width.equalHelper(val: width)
        self.tg_height.equal(height)
    }
    
    
    /// 同时设置tg_width和tg_height的简化方法。
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    public func tg_size(width:TGLayoutSize, height:TGLayoutSizeType)
    {
        self.tg_width.equal(width)
        self.tg_height.equalHelper(val: height)
    }
    
    
    /// 同时设置tg_width和tg_height的简化方法。
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    public func tg_size(width:TGLayoutSizeType, height:TGLayoutSizeType)
    {
        self.tg_width.equalHelper(val: width)
        self.tg_height.equalHelper(val: height)
    }
    
    /// 高宽相等时设置tg_width和tg_height的简化方法。
    ///
    /// - Parameters:
    ///   - sidelength: 边长
    public func tg_size(_ sideLength: TGLayoutSize)
    {
        self.tg_width.equal(sideLength)
        self.tg_height.equal(sideLength)
    }
    
    /// 高宽相等时设置tg_width和tg_height的简化方法。
    ///
    /// - Parameters:
    ///   - sidelength: 边长
    public func tg_size(_ sideLength: TGLayoutSizeType)
    {
        self.tg_width.equalHelper(val: sideLength)
        self.tg_height.equalHelper(val: sideLength)
    }
    
    /// 四周边距或者间距设置的简化方法
    ///
    /// - Parameter val: 距离父视图四周的边距或者兄弟视图四周间距的值
    public func tg_margin(_ val:CGFloat)
    {
        self.tg_leading.equal(val)
        self.tg_trailing.equal(val)
        self.tg_top.equal(val)
        self.tg_bottom.equal(val)
    }
    
    
    /// 水平边距或者间距设置的简化方法
    ///
    /// - Parameter val: 距离父视图左右水平边距或者兄弟视图左右间距的值
    public func tg_horzMargin(_ val:CGFloat)
    {
        self.tg_leading.equal(val)
        self.tg_trailing.equal(val)
    }
    
    
    /// 垂直边距或者间距设置的简化方法
    ///
    /// - Parameter val: 距离父视图上下垂直边距或者兄弟视图上下间距的值
    public func tg_vertMargin(_ val:CGFloat)
    {
        self.tg_top.equal(val)
        self.tg_bottom.equal(val)
    }
    
    
    /**
     视图的在父布局视图调用完评估尺寸的方法后，可以通过这个方法来获取评估的CGRect值。评估的CGRect值是在布局前评估计算的值，而frame则是视图真正完成布局后的真实的CGRect值。在调用这个方法前请先调用父布局视图的tg_sizeThatFits方法进行布局视图的尺寸评估，否则此方法返回的值未可知。这个方法主要用于在视图布局前而想得到其在父布局视图中的位置和尺寸的场景。
     */
    public var tg_estimatedFrame:CGRect
    {
        let rect = self.tgFrame.frame;
        if rect.width == CGFloat.greatestFiniteMagnitude || rect.height == CGFloat.greatestFiniteMagnitude
        {
            return self.frame
        }
        
        return rect;
    }
    
    
    /// 视图在父布局视图中布局完成后也就是视图的frame更新完成后执行的block，执行完block后会被重置为nil。通过在tg_layoutCompletedDo中我们可以得到这个视图真实的frame值,当然您也可以在里面进行其他业务逻辑的操作和属性的获取和更新。block方法中layout参数就是父布局视图，而v就是视图本身，block中这两个参数目的是为了防止循环引用的问题。
    ///
    /// - Parameter action: 布局完成执行的action
    public func tg_layoutCompletedDo(_ action:((_ layout:TGBaseLayout, _ view:UIView)->Void)?)
    {
        (self.tgCurrentSizeClass as! TGViewSizeClassImpl).layoutCompletedAction = action
    }
    
    
    /// 清除视图所有为布局而设置的扩展属性值。如果是布局视图调用这个方法则同时会清除布局视图中所有关于布局设置的属性值。
    ///
    /// - Parameter type: 清除某个TGSizeClassType下设置的视图布局属性值。
    public func tg_clearLayout(inSizeClass type:TGSizeClassType = .default)
    {
        if let dict = self.tgFrame.sizeClasses
        {
            dict.removeObject(forKey: self.tgIntFromSizeClassType(type))
        }
    }
    

    
    /// 获取视图在某个SizeClassType下的TGViewSizeClass对象。视图可以通过得到的TGViewSizeClass对象来设置视图在对应SizeClass下的各种布局约束属性。
    ///
    /// - Parameters:
    ///   - type: Size Class的类型
    ///   - srcType: 源Size Class的类型，如果视图指定的type不存在则会拷贝srcType中定义的约束值，如果存在则不拷贝直接返回type中指定的SizeClass
    /// - Returns: Size Class对象
    public func tg_fetchSizeClass(with type:TGSizeClassType, from srcType:TGSizeClassType! = nil) ->TGViewSizeClass
    {
        
        let tgFrame = self.tgFrame
        if tgFrame.sizeClasses == nil
        {
            tgFrame.sizeClasses = NSMutableDictionary()
        }
        
        let typeInt = self.tgIntFromSizeClassType(type)
        let srcTypeInt = self.tgIntFromSizeClassType(srcType)
        
        var sizeClass:TGViewSizeClass! = tgFrame.sizeClasses.object(forKey: typeInt) as? TGViewSizeClass
        if sizeClass == nil
        {
            let srcSizeClass = tgFrame.sizeClasses.object(forKey: srcTypeInt) as? TGViewSizeClassImpl
            if srcSizeClass == nil
            {
                sizeClass = (self.tgCreateInstance() as! TGViewSizeClass)
            }
            else
            {
                sizeClass = (srcSizeClass!.copy() as! TGViewSizeClass)
            }
            
            tgFrame.sizeClasses.setObject(sizeClass!, forKey: typeInt as NSCopying)
        }
        
        return sizeClass!
    }
}

/**
 布局的边界画线类，用于实现绘制布局的四周的边界线的功能。一个布局视图中提供了上下左右4个方向的边界画线类对象。
 */
public class TGBorderline
{
    public init(color:UIColor, thick:CGFloat=1, dash:CGFloat = 0, headIndent:CGFloat = 0, tailIndent:CGFloat = 0, offset:CGFloat = 0)
    {
        self.color = color
        var thick = thick
        if thick < 1
        {
            thick = 1
        }
        self.thick = thick
        self.dash = dash
        self.headIndent = headIndent
        self.tailIndent = tailIndent
        self.offset = offset
        
    }
    
    /// 边界线颜色
    public var color:UIColor
    /// 边界线粗细，最小单位为1，单位是像素。请不要设置小于1的值。
    public var thick:CGFloat = 1
    /// 边界线头部缩进单位
    public var headIndent:CGFloat = 0
    /// 边界线尾部缩进单位
    public var tailIndent:CGFloat = 0
    /// 设置边界线为点划线,如果是0则边界线是实线
    public var dash:CGFloat = 0
    /// 边界线的偏移量
    public var offset:CGFloat = 0
    
}

/**
 布局视图基类，基类不支持实例化对象。在编程时我们经常会用到一些视图，这种视图只是负责将里面的子视图按照某种规则进行排列和布局，而别无其他的作用。因此我们称这种视图为容器视图或者称为布局视图。

 布局视图通过重载layoutSubviews方法来完成子视图的布局和排列的工作。对于每个加入到布局视图中的子视图，都会在加入时通过KVO机制监控子视图的center和bounds以及frame值的变化，每当子视图的这些属性一变化时就又会重新引发布局视图的布局动作。同时对每个视图的布局扩展属性的设置以及对布局视图的布局属性的设置都会引发布局视图的布局动作。布局视图在添加到非布局父视图时也会通过KVO机制来监控非布局父视图的frame值和bounds值，这样每当非布局父视图的尺寸变更时也会引发布局视图的布局动作。前面说的引起变动的方法就是会在KVO处理逻辑以及布局扩展属性和布局属性设置完毕后通过调用setNeedLayout来实现的，当布局视图收到setNeedLayout的请求后，会在下一个runloop中对布局视图进行重新布局而这就是通过调用layoutSubviews方法来实现的。布局视图基类只提供了更新所有子视图的位置和尺寸以及一些基础的设置，而至于如何排列和布局这些子视图则要根据应用的场景和需求来确定，因此布局基类视图提供了一个：
 internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, hasSubLayout:inout Bool!, sbs:[UIView]!, type:TGSizeClassType) ->CGSize
 的方法，要求派生类去重载这个方法，这样不同的派生类就可以实现不同的应用场景，这就是布局视图的核心实现机制。
 
 TangramKit布局库根据实际中常见的场景实现了7种不同的布局视图派生类他们分别是：线性布局、表格布局、相对布局、框架布局、流式布局、浮动布局、路径布局。
 */
open class TGBaseLayout: UIView,TGLayoutViewSizeClass {
    
    /**
      用于实现对阿拉伯国家的布局适配。对于非阿拉伯国家来说，界面布局都是默认从左到右排列。而对于阿拉伯国家来说界面布局则默认是从右往左排列。默认这个属性是NO，您可以将这个属性设置为YES，这样布局里面的所有视图都将从右到左进行排列布局。如果您需要考虑国际化布局的问题，那么您应该用tg_leading来表示头部的位置，而用tg_trailing来表示尾部的位置，这样当布局方向是LTR时那么tg_leading就表示的是左边而tg_trailing则表示的是右边；而当布局方向是RTL时那么tg_leading表示的是右边而tg_trailing则表示的是左边。如果您的界面布局不会考虑到国际化以及不需要考虑RTL时那么您可以用tg_left和tg_right来表示左右而不需要用tg_leading和tg_trailing。
     */
    public static var tg_isRTL:Bool
    {
        get{
            return TGViewSizeClassImpl.IsRTL
        }
        set
        {
            TGViewSizeClassImpl.IsRTL = newValue
        }
    }
    
    public static func tg_updateRTL(_ isRTL:Bool, inWindow window:UIWindow)
    {
        window.tgUpdateRTL(isRTL)
    }
    
    
    /*
     布局视图里面的tg_padding属性用来设置布局视图的内边距。内边距是指布局视图里面的子视图离自己距离。外边距则是视图与父视图之间的距离。
     内边距是在自己的尺寸内离子视图的距离，而外边距则不是自己尺寸内离其他视图的距离。下面是内边距和外边距的效果图：
     
            ^
            | topMargin
            |           width
            +------------------------------+
            |                              |------------>
            |  l                       r   | rightMargin
            |  e       topPadding      i   |
            |  f                       g   |
            |  t   +---------------+   h   |
 <----------|  P   |               |   t   |
  leftMargin|  a   |               |   P   |
            |  d   |   subviews    |   a   |  height
            |  d   |    content    |   d   |
            |  i   |               |   d   |
            |  n   |               |   i   |
            |  g   +---------------+   n   |
            |                          g   |
            |        bottomPadding         |
            +------------------------------+
            |bottomMargin
            |
            V
     
     
     如果一个布局视图中的每个子视图都离自己有一定的距离就可以通过设置布局视图的内边距来实现，而不需要为每个子视图都设置外边距。
     
     */
    
    
    /**
      设置布局视图四周的内边距值。所谓内边距是指布局视图内的所有子视图离布局视图四周的边距。通过为布局视图设置内边距可以减少为所有子视图设置外边距的工作，而外边距则是指视图离父视图四周的距离。
     */
    public var tg_padding:UIEdgeInsets
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_padding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_padding != newValue
            {
                lsc.tg_padding = newValue
                setNeedsLayout()
            }
        }
        
    }
    
    /// 顶部内边距
    public var tg_topPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_topPadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_topPadding != newValue
            {
                lsc.tg_topPadding = newValue
                setNeedsLayout()
            }
        }
    }
    
    /// 头部内边距，用来设置子视图离自身头部的边距值。对于LTR方向的布局来说就是指的左边内边距，而对于RTL方向的布局来说就是指的右边内边距。
    public var tg_leadingPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_leadingPadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_leadingPadding != newValue
            {
                lsc.tg_leadingPadding = newValue
                setNeedsLayout()
            }
            
        }
    }

    
    /// 底部内边距
    public var tg_bottomPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_bottomPadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_bottomPadding != newValue
            {
                lsc.tg_bottomPadding = newValue
                setNeedsLayout()
            }
        }
    }
    
    /// 尾部内边距，用来设置子视图离自身尾部的边距值。对于LTR方向的布局来说就是指的右边内边距，而对于RTL方向的布局来说就是指的左边内边距。
    public var tg_trailingPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_trailingPadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_trailingPadding != newValue
            {
                lsc.tg_trailingPadding = newValue
                setNeedsLayout()
            }
            
        }
    }
    
    
    /// 左边内边距。
    public var tg_leftPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_leftPadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_leftPadding != newValue
            {
                lsc.tg_leftPadding = newValue
                setNeedsLayout()
            }
            
        }
    }
    
    /// 右边内边距
    public var tg_rightPadding:CGFloat
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_rightPadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_rightPadding != newValue
            {
                lsc.tg_rightPadding = newValue
                setNeedsLayout()
            }
            
        }
    }


    
    /**
      设置当布局的尺寸由子视图决定并且在没有子视图的情况下tg_padding的设置值是否会加入到布局的尺寸值里面。默认是true，表示当布局视图没有子视图时tg_padding值也会加入到尺寸里面。
     
     举例来说假设某个布局视图的高度是.wrap,并且设置了tg_topPadding为10，tg_bottomPadding为20。那么默认情况下当没有任何子视图时布局视图的高度是30；而当我们将这个属性设置为false时，那么在没有任何子视图时布局视图的高度就是0，也就是说tg_padding不会参与高度的计算了。
    */
    public var tg_zeroPadding:Bool
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_zeroPadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_zeroPadding != newValue
            {
                lsc.tg_zeroPadding = newValue
                setNeedsLayout()
            }
        }
    }
    
    /**
     指定padding内边距的缩进是在SafeArea基础之上进行的。默认是.all表示四周都会缩进SafeArea所指定的区域。你也可以设置只缩进某一个或则几个方向，或者不缩进任何一个方向。这个属性是为了支持iPoneX而设置的。为了支持iPhoneX的全屏幕适配。我们只需要对根布局视图设置这个扩展属性，默认情况下是不需要进行特殊设置的，TangramKit自动会对iPhoneX进行适配。我们知道iOS11中引入了安全区域的概念，TangramKit中的根布局视图会自动将安全区域叠加到设置的padding中去。默认情况下左右的安全区域都会叠加到padding中去，因此您可以根据特殊情况来设置只需要叠加哪一个方向的安全区域。
     */
    public var tg_insetsPaddingFromSafeArea:UIRectEdge
    {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_insetsPaddingFromSafeArea
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_insetsPaddingFromSafeArea != newValue
            {
                lsc.tg_insetsPaddingFromSafeArea = newValue
                setNeedsLayout()
            }
        }
    }
    
    /**
     *当tg_insetsPaddingFromSafeArea同时设置有左右方向同时缩进并且在横屏时是否只缩进有刘海方向的内边距。默认是false，表示两边都会缩进。如果你想让没有刘海的那一边延伸到屏幕的安全区外，请将这个属性设置为true。iPhoneX设备中具有一个尺寸为44的刘海区域。当您横屏时为了对齐，左右两边的安全缩进区域都是44。但是有些时候我们希望没有刘海的那一边不需要缩进对齐而是延伸到安全区域以外。这时候您可以通过给根布局视图设置这个属性来达到效果。注意这个属性只有tg_insetsPaddingFromSafeArea设置了左右都缩进时才有效。
     */
    public var tg_insetLandscapeFringePadding:Bool
    {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_insetLandscapeFringePadding
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_insetLandscapeFringePadding != newValue
            {
                lsc.tg_insetLandscapeFringePadding = newValue
                setNeedsLayout()
            }
        }
    }
    
    
    /**
     定义布局视图内子视图之间的间距，所谓间距就是子视图之间的间隔距离。
     */
    public var tg_space:CGFloat {
        get {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_space
        }
        set {
            
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_space != newValue
            {
                lsc.tg_space = newValue
                setNeedsLayout()
            }
        }
    }
    
    
    /**
     定义布局视图内子视图之间的上下垂直间距。只有顺序布局这个属性才有意义。
     */
    public var tg_vspace:CGFloat {
        get {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_vspace
        }
        set {
            
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_vspace != newValue
            {
                lsc.tg_vspace = newValue
                setNeedsLayout()
            }
            
        }
    }
    
    /**
     定义布局视图内子视图之间的左右水平间距。只有顺序布局这个属性才有意义。
     */
    public var tg_hspace:CGFloat {
        get {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_hspace
        }
        set {
            
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_hspace != newValue
            {
                lsc.tg_hspace = newValue
                setNeedsLayout()
            }
        }
    }
    
    /**
     布局里面的所有子视图按添加的顺序逆序进行布局。默认是false，表示按子视图添加的顺序排列。比如一个垂直线性布局依次添加A,B,C三个子视图，那么在布局时则A,B,C从上到下依次排列。当这个属性设置为YES时，则布局时C,B,A依次从上到下排列。
     */
    public var tg_reverseLayout:Bool
        {
        get{
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_reverseLayout
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_reverseLayout != newValue
            {
                lsc.tg_reverseLayout = newValue
                setNeedsLayout()
            }
        }
    }
    
    
    /**
     布局里面的所有子视图的整体停靠方向以及填充，所谓停靠是指布局视图里面的所有子视图整体在布局视图中的位置，系统默认的停靠是在布局视图的左上角。
     
     只有框架布局、线性布局、表格布局、流式布局、浮动布局支持tg_gravity属性，相对布局和路径布局不支持。
     * TGGravity.vert.top,TGGravity.vert.center,TGGravity.vert.bottom 表示整体垂直居上，居中，居下 (支持：框架布局,线性布局,表格布局,流式布局,垂直浮动布局)
     * TGGravity.horz.left,TGGravity.horz.center,TGGravity.horz.right 表示整体水平居左，居中，居右 (支持：框架布局,线性布局,表格布局,流式布局,水平浮动布局)
     * TGGravity.vert.between 表示每行之间的子视图行间距都被拉伸，以便使里面的子视图垂直方向填充满整个布局视图。 (支持：垂直线性布局,垂直表格布局，流式布局)
     * TGGravity.horz.between 表示每列之间的子视图列间距都被拉伸，以便使里面的子视图水平方向填充满整个布局视图。 (支持：水平线性布局,水平表格布局，流式布局)
     * TGGravity.vert.around 表示每行之间的视图行间距都被环绕拉伸，以便使里面的子视图垂直方向填充满整个布局视图。 (支持：垂直线性布局,垂直表格布局，流式布局)
     * TGGravity.horz.around 表示每列之间的视图列间距都被环绕拉伸，以便使里面的子视图水平方向填充满整个布局视图。 (支持：水平线性布局,水平表格布局，流式布局)
     * TGGravity.vert.among 表示每行之间的视图行间距都被等分拉伸，以便使里面的子视图垂直方向填充满整个布局视图。 (支持：垂直线性布局,垂直表格布局，流式布局)
     * TGGravity.horz.among 表示每列之间的视图列间距都被等分拉伸，以便使里面的子视图水平方向填充满整个布局视图。 (支持：水平线性布局,水平表格布局，流式布局)
     * TGGravity.vert.fill 表示布局会拉伸子视图的高度，以便使里面的子视图垂直方向填充满整个布局视图的高度或者子视图平分布局视图的高度。(支持：框架布局，水平线性布局，水平表格布局，流式布局)
     * TGGravity.horz.fill 表示布局会拉伸子视图的宽度，以便使里面的子视图水平方向填充满整个布局视图的宽度或者子视图平分布局视图的宽度。 (支持：框架布局，垂直线性布局，垂直表格布局，流式布局)
     */
    public var tg_gravity:TGGravity
        {
        get
        {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_gravity
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_gravity != newValue
            {
                lsc.tg_gravity = newValue
                setNeedsLayout()
            }
        }
    }

    
    public var tg_layoutTransform: CGAffineTransform
    {
        get
        {
            return (self.tgCurrentSizeClass as! TGLayoutViewSizeClass).tg_layoutTransform
        }
        set
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClass
            if lsc.tg_layoutTransform != newValue
            {
                lsc.tg_layoutTransform = newValue
                setNeedsLayout()
            }
            
        }
    }
    
    
    /**
     把一个布局视图放入到UIScrollView(UITableView和UICollectionView除外)内时是否自动调整UIScrollView的contentSize值。默认是.auto表示布局视图会自动接管UIScrollView的contentSize的值。 你可以将这个属性设置.no而不调整和控制contentSize的值，设置为.yes则一定会调整contentSize.
     */
    public var tg_adjustScrollViewContentSizeMode:TGAdjustScrollViewContentSizeMode = TGAdjustScrollViewContentSizeMode.auto
    
    /**
     在布局视图进行布局时是否调用基类的layoutSubviews方法，默认设置为false。
     */
    public var tg_priorAutoresizingMask:Bool = false
    
    /// 返回当前布局视图是否正在执行布局。
    public private(set) var tg_isLayouting = false
    
    
    ///设置是否选中状态。您可以用这个状态来记录布局的扩展属性。
    open var isSelected:Bool = false
    
    
    ///删除所有子视图
    public func tg_removeAllSubviews()
    {
        for sbv:UIView in self.subviews
        {
            sbv.removeFromSuperview()
        }
    }
    
    /// 执行布局动画。在布局视图的某个子视图设置完布局属性后，调用布局的这个方法可以让布局里面的子视图在布局时实现动画效果。
    ///
    /// - Parameter duration: 动画时长
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
    
    
    /// 评估布局视图的尺寸,这个方法并不会进行真正的布局，只是对布局的尺寸进行评估，主要用于在布局前想预先知道布局尺寸的场景。通过对布局进行尺寸的评估，可以在不进行布局的情况下动态的计算出布局的位置和大小，但需要注意的是这个评估值有可能不是真实显示的实际位置和尺寸。
    /// - tg_sizeThatFits() 表示按布局的位置和尺寸根据布局的子视图来进行动态评估。
    /// - tg_sizeThatFits(CGSize(width:320,height:0)) 表示布局的宽度固定为320,而高度则根据布局的子视图来进行动态评估。这个情况非常适用于UITableViewCell的动态高度的计算评估。
    /// - tg_sizeThatFits(CGSize(width:0,height:100)) 表示布局的高度固定为100,而宽度则根据布局的子视图来进行动态评估。
    ///
    /// - Parameters:
    ///   - size: 希望的尺寸
    ///   - type: size class的类型，他表示评估某个sizeClass下的尺寸值，如果没有找到指定的sizeClass则会根据继承规则得到最合适的sizeClass
    /// - Returns: 评估后的尺寸
    public func tg_sizeThatFits(_ size:CGSize = CGSize.zero, inSizeClass type:TGSizeClassType = TGSizeClassType.default) -> CGSize
    {
        return self.tgSizeThatFits(size:size,sbs:nil, inSizeClass: type)
    }
    
    
    /**
      是否缓存经过tg_sizeThatFits方法评估后的所有子视图的位置和尺寸一次!，默认设置为false不缓存。当我们用tg_sizeThatFits方法评估布局视图的尺寸后，所有子视图都会生成评估的位置和尺寸，因为此时并没有执行布局所以子视图并没有真实的更新frame值。而当布局视图要进行真实布局时又会重新计算所有子视图的位置和尺寸，因此为了优化性能当我们对布局进行评估后在下次真实布局时我们可以不再重新计算子视图的位置和尺寸而是用前面评估的值来设置位置和尺寸。这个属性设置为true时则每次评估后到下一次布局时不会再重新计算子视图的布局了，而是用评估值来布局子视图的位置和尺寸。而当这个属性设置为false时则每次布局都会重新计算子视图的位置和布局。
     这个属性一般用在那些动态高度UITableviewCell中进行配合使用，我们一般将布局视图作为UITableviewCell的contentView的子视图:
     
     let rootLayout= TGXXXLayout()
     rootLayout.tg_cacheEstimatedRect = true   //设置缓存评估的rect,如果您的cell是高度自适应的话，强烈建立打开这个属性，这会大大的增强您的tableview的性能！！
     rootLayout.tg_width.equal(.fill)           //宽度和父视图相等
     rootLayout.tg_height.equal(.wrap)    //高度动态包裹。
     self.contentView.addSubview(rootLayout)
     self.rootLayout = rootLayout;
     
     //在rootLayout添加子视图。。。
     
     *************************************
     
     然后我们在heightForRowAtIndexPath中按如下格式进行高度的评估的计算。
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     let cell = self.tableView(tableView,cellForRowAt:indexPath) as! UIXXXTableViewCell
     let size = cell.rootLayout.tg_sizeThatFits(CGSize(width:tableView.frame.width, height:0))
     return size.height;
     
     }
     
     这个属性有可能会造成动态高度计算不正确，请只在UITableviewCell的高度为自适应时使用，其他地方不建议设置这个属性！！
     */
    public var tg_cacheEstimatedRect:Bool = false
        {
            didSet
            {
                _tgUseCacheRects = false
        }
    }
    
    
    /**
     评估计算一个未加入到布局视图中的子视图subview在加入后的frame值。在实践中我们希望得到某个未加入的子视图在添加到布局视图后的应该具有的frame值，这时候就可以用这个方法来获取。比如我们希望把一个子视图从一个布局视图里面移到另外一个布局视图的末尾时希望能够提供动画效果,这时候就可以通过这个方法来得到加入后的子视图的位置和尺寸。
     
     这个方法只有针对那些通过添加顺序进行约束的布局视图才有意义，相对布局和框架布局则没有意义。
     
     使用示例：假设存在两个布局视图L1,L2他们的父视图是S，现在要实现将L1中的任意一个子视图A移动到L2的末尾中去，而且要带动画效果，那么代码如下：
     
     //得到A在S中的frame，这里需要进行坐标转换为S在中的frame
     let rectOld = L1.convert(A.frame, to: S)
     
     //得到将A加入到L2后的评估的frame值，注意这时候A还没有加入到L2。
     var rectNew = L2.tg_estimatedFrame(of: A)
     rectNew = L2.convert(rectNew, to: S) //将新位置的评估的frame值，这里需要进行坐标转换为S在中的frame。
     
     //动画的过程是先将A作为S的子视图进行位置的调整后再加入到L2中去
     A.removeFromSuperview()
     A.frame = rectOld
     A.tg_useFrame = true  //设置为true表示A不再受到布局视图的约束，而是可以自由设置frame值。
     S.addSubview(sender)
     
     UIView.animate(withDuration: 0.3, animations: {
     A.frame = rectNew
     }) { _ in
     
     //动画结束后再将A移植到L2中。
     A.removeFromSuperview()
     A.tg_useFrame = false  //还原tg_useFrame，因为加入到L2后将受到布局视图的约束。
     L2.addSubview(A)
     }
     
     - Parameters:
     - subview: 一个未加入布局视图的子视图，如果子视图已经加入则直接返回子视图的frame值。
     - size:指定布局视图期望的宽度或者高度，一般请将这个值设置为.zero。 具体请参考tg_sizeThatFits方法中的size的说明。
     - Returns: 子视图在布局视图最后一个位置(假如加入后)的frame值。
     */
    public func tg_estimatedFrame(of subview:UIView, inLayoutSize size:CGSize = CGSize.zero) -> CGRect
    {
        if subview.superview != nil && subview.superview! === self
        {
            return subview.frame
        }
        
        var sbs = self.tgGetLayoutSubviews()
        sbs.append(subview)
        
        let _ = self.tgSizeThatFits(size: size, sbs: sbs, inSizeClass: TGSizeClassType.default)
        
        return subview.tg_estimatedFrame
    }
    
    
    
    
    /**
     设置布局视图在布局开始之前和布局完成之后的处理块。系统会在每次布局完成前后分别执行对应的处理块后将处理块清空为nil。您也可以在tg_endLayoutDo块内取到所有子视图真实布局后的frame值。系统会在调用layoutSubviews方法前执行tg_beginLayoutDo，而在layoutSubviews方法执行后执行tg_endLayoutDo。
     */
    public func tg_beginLayoutDo(_ action:(()->Void)?)
    {
        _tgBeginLayoutAction = action
    }
    
    public func tg_endLayoutDo(_ action:(()->Void)?)
    {
        _tgEndLayoutAction = action
    }
    
    /**
      设置布局视图在第一次布局完成之后或者有横竖屏切换时进行处理的动作块。这个block不像tg_beginLayoutDo以及tg_endLayoutDo那样只会执行一次,而是会一直存在
      因此需要注意代码块里面的循环引用的问题。这个block调用的时机是第一次布局完成或者每次横竖屏切换时布局完成被调用。
      这个方法会在tg_endLayoutDo执行后调用。
      - layout: 参数就是布局视图本身
      - isFirst: 表明当前是否是第一次布局时调用。
      - isPortrait: 表明当前是横屏还是竖屏。
     */
    public func tg_rotationToDeviceOrientationDo(_ action:((_ layout:TGBaseLayout, _ isFirst:Bool, _ isPortrait:Bool)->Void)?)
    {
        _tgRotationToDeviceOrientationAction = action
    }
    
    
    /// 设置布局视图的顶部边界线对象,默认是nil。
    public var tg_topBorderline:TGBorderline!
    {
        get {
            return _tgBorderlineLayerDelegate?.topBorderline
        }
        set
        {
            if _tgBorderlineLayerDelegate == nil
            {
                _tgBorderlineLayerDelegate = TGBorderlineLayerDelegate(self.layer)
            }
            
            _tgBorderlineLayerDelegate.topBorderline = newValue
        }
    }
    
    /// 设置布局视图的头部边界线对象，默认是nil。
    public var tg_leadingBorderline:TGBorderline!
    {
        get {
            return _tgBorderlineLayerDelegate?.leadingBorderline
        }
        set
        {
            if _tgBorderlineLayerDelegate == nil
            {
                _tgBorderlineLayerDelegate = TGBorderlineLayerDelegate(self.layer)
            }
            
            _tgBorderlineLayerDelegate.leadingBorderline = newValue
        }
    }

    /// 设置布局视图的底部边界线对象，默认是nil。
    public var tg_bottomBorderline:TGBorderline!
    {
        get {
            return _tgBorderlineLayerDelegate?.bottomBorderline
        }
        set
        {
            if _tgBorderlineLayerDelegate == nil
            {
                _tgBorderlineLayerDelegate = TGBorderlineLayerDelegate(self.layer)
            }
            
            _tgBorderlineLayerDelegate.bottomBorderline = newValue
        }
    }

    /// 设置布局视图的尾部边界线对象，默认是nil。
    public var tg_trailingBorderline:TGBorderline!
    {
        get {
            return _tgBorderlineLayerDelegate?.trailingBorderline
        }
        set
        {
            if _tgBorderlineLayerDelegate == nil
            {
                _tgBorderlineLayerDelegate = TGBorderlineLayerDelegate(self.layer)
            }
            
            _tgBorderlineLayerDelegate.trailingBorderline = newValue
        }
    }

    
    
    /// 设置布局视图的左边边界线对象，默认是nil。
    public var tg_leftBorderline:TGBorderline!
    {
        get {
            return _tgBorderlineLayerDelegate?.leftBorderline
        }
        set
        {
            if _tgBorderlineLayerDelegate == nil
            {
                _tgBorderlineLayerDelegate = TGBorderlineLayerDelegate(self.layer)
            }
            
            _tgBorderlineLayerDelegate.leftBorderline = newValue
        }
    }


    /// 设置布局视图的右边边界线对象，默认是nil。
    public var tg_rightBorderline:TGBorderline!
    {
        get {
            return _tgBorderlineLayerDelegate?.rightBorderline
        }
        set
        {
            if _tgBorderlineLayerDelegate == nil
            {
                _tgBorderlineLayerDelegate = TGBorderlineLayerDelegate(self.layer)
            }
            
            _tgBorderlineLayerDelegate.rightBorderline = newValue
        }
    }

    
    /// 设置布局视图的四周边界线对象，默认是nil。
    public var tg_boundBorderline:TGBorderline!
        {
        get
        {
            return self.tg_bottomBorderline
        }
        set
        {
            self.tg_leadingBorderline = newValue
            self.tg_topBorderline = newValue
            self.tg_trailingBorderline = newValue
            self.tg_bottomBorderline = newValue
        }
    }
    
    /**
     智能边界线，智能边界线不是设置布局自身的边界线而是对添加到布局视图里面的子布局视图根据子视图之间的关系智能的生成边界线，对于布局视图里面的非布局子视图则不会生成边界线。目前的版本只支持线性布局，表格布局，流式布局和浮动布局这四种布局。
     
     举例来说如果为某个垂直线性布局设置了智能边界线，那么当这垂直线性布局里面添加了A和B两个子布局视图时，系统会智能的在A和B之间绘制一条边界线。
     */
    public var tg_intelligentBorderline:TGBorderline! = nil
    
    /**
     不使用父布局视图提供的智能边界线功能。当布局视图的父布局视图设置了tg_intelligentBorderline时但是布局视图又想自己定义边界线时则将这个属性设置为true
     */
    public var tg_notUseIntelligentBorderline:Bool = false
    
    
    
    /// 设置布局的按下抬起、按下、取消事件的处理动作,后两个事件的处理必须依赖于第一个事件的处理。请不要在这些处理动作中修改背景色，不透明度，以及背景图片。如果您只想要高亮效果但是不想处理事件则将action设置为nil即可了。
    ///
    /// - Parameters:
    ///   - target: 事件的处理对象，如果设置为nil则表示取消事件。
    ///   - action: 事件的处理动作，格式为：func handleAction(sender:TGBaseLayout)
    ///   - controlEvents: 支持的事件类型，目前只支持：touchDown、touchUpInside、touchCancel这三个事件。
    #if swift(>=4.2)
    public func tg_setTarget(_ target: NSObjectProtocol?, action: Selector?, for controlEvents: UIControl.Event)
    {
        if _tgTouchEventDelegate == nil
        {
            _tgTouchEventDelegate = TGTouchEventDelegate(self)
        }
        
        _tgTouchEventDelegate?.setTarget(target, action: action, for: controlEvents)
    }
    #else
    public func tg_setTarget(_ target: NSObjectProtocol?, action: Selector?, for controlEvents: UIControlEvents)
    {
    
    
        if _tgTouchEventDelegate == nil
        {
            _tgTouchEventDelegate = TGTouchEventDelegate(self)
        }
        
        _tgTouchEventDelegate?.setTarget(target, action: action, for: controlEvents)
    }
    #endif
    
    /**
     设置布局按下时背景的高亮的颜色。只有设置了tg_setTarget方法后此属性才生效。
     */
    public var tg_highlightedBackgroundColor:UIColor! = nil
    
    /**
     设置布局按下时的高亮不透明度。值的范围是[0,1]，默认是0表示完全不透明，为1表示完全透明。只有设置了tg_setTarget方法此属性才生效。
     */
    public var tg_highlightedOpacity:CGFloat = 0
    
    /**
     设置布局的背景图片。这个属性的设置就是设置了布局的layer.contents的值，因此如果要实现背景图的局部拉伸请用layer.contentsXXX这些属性进行调整
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
     设置布局按下时的高亮背景图片。只有设置了tg_setTarget方法此属性才生效。
     */
    public var tg_highlightedBackgroundImage:UIImage! = nil
    
    
    
    
    //MARK: override Method
    
    deinit {
        
        _tgEndLayoutAction = nil
        _tgBeginLayoutAction = nil
        _tgRotationToDeviceOrientationAction = nil
        _tgTouchEventDelegate = nil
    }
    
    open override func safeAreaInsetsDidChange() {
        
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
        } else {
            // Fallback on earlier versions
        }
        
        if self.superview != nil && !self.superview!.isKind(of: TGBaseLayout.self)
        {
            let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClassImpl
            if lsc.leading.isSafeAreaPos || lsc.trailing.isSafeAreaPos || lsc.top.isSafeAreaPos || lsc.bottom.isSafeAreaPos
            {
                 if !self.tg_isLayouting
                 {
                    self.tg_isLayouting = true
                   _ = self.tgUpdateLayoutRectInNoLayoutSuperview(self.superview!)
                    self.tg_isLayouting = false
                }
            }
        }
        
    }
    
    override open func setNeedsLayout() {
        super.setNeedsLayout()
        self.tgInvalidateIntrinsicContentSize()
    }
    
    
   override open var intrinsicContentSize: CGSize
        {
        get{
           
            var sz:CGSize = super.intrinsicContentSize
            let lsc = self.tgCurrentSizeClass as! TGViewSizeClassImpl
            if (!self.translatesAutoresizingMaskIntoConstraints && (lsc.width.isWrap || lsc.height.isWrap) && self.superview != nil)
            {
                if lsc.width.isWrap && lsc.height.isWrap
                {
                    sz = self.sizeThatFits(CGSize.zero)
                }
                else if lsc.width.isWrap
                {
                    var heightConstraint:NSLayoutConstraint! = nil
                    for constraint:NSLayoutConstraint in self.constraints
                    {
                        if (constraint.firstItem === self && constraint.firstAttribute == NSLayoutConstraint.Attribute.height)
                        {
                            heightConstraint = constraint
                            break
                        }
                    }
                    
                    if (heightConstraint == nil)
                    {
                        for constraint:NSLayoutConstraint in self.superview!.constraints
                        {
                            if (constraint.firstItem === self && constraint.firstAttribute == NSLayoutConstraint.Attribute.height)
                            {
                                heightConstraint = constraint
                                break
                            }
                        }
                    }
                    
                    if (heightConstraint != nil)
                    {
                        var dependHeight:CGFloat = -1
                        if let t = heightConstraint.secondItem as? UIView
                        {
                            let dependViewRect = t.bounds
                            if heightConstraint.secondAttribute == NSLayoutConstraint.Attribute.height
                            {
                                dependHeight = dependViewRect.height
                            }
                            else if heightConstraint.secondAttribute == NSLayoutConstraint.Attribute.width
                            {
                                dependHeight = dependViewRect.width
                            }
                            else
                            {
                                dependHeight = -1
                            }
                        }
                        else if heightConstraint.secondItem == nil
                        {
                            dependHeight = 0
                        }
                        else
                        {
                            
                        }
                        
                        if dependHeight != -1
                        {
                            dependHeight *= heightConstraint.multiplier
                            dependHeight += heightConstraint.constant
                            
                            sz.width = self.sizeThatFits(CGSize(width: 0, height: dependHeight)).width
                        }
                    }
                    
                }
                else
                {
                    var widthConstraint:NSLayoutConstraint! = nil
                    for constraint:NSLayoutConstraint in self.constraints
                    {
                        if (constraint.firstItem === self && constraint.firstAttribute == NSLayoutConstraint.Attribute.width)
                        {
                            widthConstraint = constraint
                            break
                        }
                    }
                    
                    if (widthConstraint == nil)
                    {
                        for constraint:NSLayoutConstraint in self.superview!.constraints
                        {
                            if (constraint.firstItem === self && constraint.firstAttribute == NSLayoutConstraint.Attribute.width)
                            {
                                widthConstraint = constraint
                                break
                            }
                        }
                    }
                    
                    if (widthConstraint != nil)
                    {
                        var dependWidth:CGFloat = -1
                        if let t = widthConstraint.secondItem as? UIView
                        {
                            let dependViewRect = t.bounds
                            if widthConstraint.secondAttribute == NSLayoutConstraint.Attribute.width
                            {
                                dependWidth = dependViewRect.width
                            }
                            else if widthConstraint.secondAttribute == NSLayoutConstraint.Attribute.height
                            {
                                dependWidth = dependViewRect.height
                            }
                            else
                            {
                                dependWidth = -1
                            }
                        }
                        else if widthConstraint.secondItem == nil
                        {
                            dependWidth = 0
                        }
                        else
                        {
                            
                        }
                        
                        if dependWidth != -1
                        {
                            dependWidth *= widthConstraint.multiplier
                            dependWidth += widthConstraint.constant
                            
                            sz.height = self.sizeThatFits(CGSize(width: dependWidth, height: 0)).height
                        }
                    }
                }
                
            }

            return sz
           
        }
    }

    
    
    
    override open func layoutSubviews() {
        
        if !self.autoresizesSubviews
        {
            return
        }
        
        _tgBeginLayoutAction?()
        _tgBeginLayoutAction = nil
        
        
        var currentScreenOrientation:Int! = nil
        
        if !self.tg_isLayouting
        {
            self.tg_isLayouting = true
            
            if self.tg_priorAutoresizingMask
            {
                super.layoutSubviews()
            }
            
        
            let sizeClassType = TGBaseLayout.tgGetGlobalSizeClassType(layoutv: self)
            switch sizeClassType {
            case TGSizeClassType.comb(_, _, let screen):
                if screen == TGSizeClassType.Screen.portrait
                {
                    currentScreenOrientation = 1
                }
                else
                {
                    currentScreenOrientation = 2
                }
                break
            default:
                break
            }
            
            let tgFrame = self.tgFrame
            
            if tgFrame.multiple
            {
               tgFrame.sizeClass = self.tgMatchBestSizeClass(sizeClassType)
            }
            for sbv:UIView in self.subviews
            {
                let sbvtgFrame = sbv.tgFrame
                if sbvtgFrame.multiple
                {
                   sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(sizeClassType)
                }
                
                if !sbvtgFrame.hasObserver && sbvtgFrame.sizeClass != nil && !sbvtgFrame.sizeClass!.tg_useFrame
                {
                    self .tgAddSubviewObserver(subview: sbv, sbvtgFrame: sbvtgFrame)
                }
                
            }
            
            let lsc = tgFrame.sizeClass as! TGLayoutViewSizeClassImpl
            
            let oldSelfSize = self.bounds.size
            var newSelfSize:CGSize
            if _tgUseCacheRects && tgFrame.width != CGFloat.greatestFiniteMagnitude && tgFrame.height != CGFloat.greatestFiniteMagnitude
            {
                newSelfSize = CGSize(width: tgFrame.width, height: tgFrame.height)
            }
            else
            {
               var hasSubLayout:Bool! = nil
               newSelfSize = self.tgCalcLayoutRect(self.tgCalcSizeInNoLayout(newSuperview: self.superview, currentSize: oldSelfSize),isEstimate: false, hasSubLayout:&hasSubLayout, sbs:nil, type:sizeClassType)
            }
            newSelfSize = _tgRoundSize(newSelfSize)
            _tgUseCacheRects = false
            
            for sbv:UIView in self.subviews
            {
                let (sbvtgFrame, sbvsc) = self.tgGetSubviewFrameAndSizeClass(sbv)
                
                let sbvOldBounds:CGRect = sbv.bounds
                let sbvOldCenter:CGPoint = sbv.center
                
                if sbvtgFrame.leading != CGFloat.greatestFiniteMagnitude && sbvtgFrame.top != CGFloat.greatestFiniteMagnitude && !sbvsc.tg_noLayout && !sbvsc.tg_useFrame
                {
                    if sbvtgFrame.width < 0
                    {
                        sbvtgFrame.width = 0
                    }
                    
                    if sbvtgFrame.height < 0
                    {
                        sbvtgFrame.height = 0
                    }
                    
                    //这里的位置需要进行有效像素的舍入处理，否则可能出现文本框模糊，以及视图显示可能多出一条黑线的问题。
                    //原因是当frame中的值不能有效的转化为最小可绘制的物理像素时就会出现模糊，虚化，多出黑线，以及layer处理圆角不圆的情况。
                    //所以这里要将frame中的点转化为有效的点。
                    //这里之所以讲布局子视图的转化方法和一般子视图的转化方法区分开来是因为。我们要保证布局子视图不能出现细微的重叠，因为布局子视图有边界线
                    //如果有边界线而又出现细微重叠的话，那么边界线将无法正常显示，因此这里做了一个特殊的处理。
                    var rc:CGRect
                    if sbv.isKind(of: TGBaseLayout.self)
                    {
                        rc = _tgRoundRectForLayout(sbvtgFrame.frame)
                        
                        var sbvTempBounds:CGRect = CGRect(origin:sbvOldBounds.origin, size:rc.size)
                        
                        if (_tgCGFloatErrorEqual(sbvTempBounds.size.width, sbvOldBounds.size.width, _tgrSizeError))
                        {
                          sbvTempBounds.size.width = sbvOldBounds.size.width
                        }
                        
                        if (_tgCGFloatErrorEqual(sbvTempBounds.size.height, sbvOldBounds.size.height, _tgrSizeError))
                        {
                            sbvTempBounds.size.height = sbvOldBounds.size.height
                        }
                        
                        
                        if (_tgCGFloatErrorNotEqual(sbvTempBounds.size.width, sbvOldBounds.size.width, _tgrSizeError) ||
                            _tgCGFloatErrorNotEqual(sbvTempBounds.size.height, sbvOldBounds.size.height, _tgrSizeError))
                        {
                            sbv.bounds = sbvTempBounds
                        }
                        
                        var sbvTempCenter = CGPoint(x:rc.origin.x + sbv.layer.anchorPoint.x * sbvTempBounds.size.width, y:rc.origin.y + sbv.layer.anchorPoint.y * sbvTempBounds.size.height);
                        
                        if (_tgCGFloatErrorEqual(sbvTempCenter.x, sbvOldCenter.x, _tgrSizeError))
                        {
                         sbvTempCenter.x = sbvOldCenter.x
                        }
                        
                        if (_tgCGFloatErrorEqual(sbvTempCenter.y, sbvOldCenter.y, _tgrSizeError))
                        {
                            sbvTempCenter.y = sbvOldCenter.y
                        }
                        
                        
                        if (_tgCGFloatErrorNotEqual(sbvTempCenter.x, sbvOldCenter.x, _tgrSizeError) ||
                            _tgCGFloatErrorNotEqual(sbvTempCenter.y, sbvOldCenter.y, _tgrSizeError))
                        {
                            sbv.center = sbvTempCenter
                        }
                        
                    }
                    else
                    {
                        rc = _tgRoundRect(sbvtgFrame.frame)
                        
                        sbv.center = CGPoint(x:rc.origin.x + sbv.layer.anchorPoint.x * rc.size.width, y:rc.origin.y + sbv.layer.anchorPoint.y * rc.size.height)
                        sbv.bounds = CGRect(origin: sbvOldBounds.origin, size: rc.size)

                    }
                    
                }
                
                if sbvsc.tg_visibility == TGVisibility.gone && !sbv.isHidden
                {
                    sbv.bounds = CGRect(origin: sbvOldBounds.origin, size: CGSize.zero)
                }
            
                
                sbvsc.layoutCompletedAction?(self, sbv)
                sbvsc.layoutCompletedAction = nil
                
                if sbvtgFrame.multiple
                {
                    sbvtgFrame.sizeClass = sbv.tgDefaultSizeClass
                }
                sbvtgFrame.reset()
                
            }
            
            if newSelfSize.width != CGFloat.greatestFiniteMagnitude && lsc.isSomeSizeWrap
            {
                
                //因为布局子视图的新老尺寸计算在上面有两种不同的方法，因此这里需要考虑两种计算的误差值，而这两种计算的误差值是不超过1/屏幕精度的。
                //因此我们认为当二者的值超过误差时我们才认为有尺寸变化。
                let isWidthAlter = _tgCGFloatErrorNotEqual(newSelfSize.width,  oldSelfSize.width, _tgrSizeError)
                let isHeightAlter = _tgCGFloatErrorNotEqual(newSelfSize.height, oldSelfSize.height, _tgrSizeError)

                
                //如果父视图也是布局视图，并且自己隐藏则不调整自身的尺寸和位置。
                var isAdjustSelf = true
                if let supl = self.superview as? TGBaseLayout
                {
                    if supl.tgIsNoLayoutSubview(self)
                    {
                        isAdjustSelf = false
                    }
                }
                
                if isAdjustSelf && (isWidthAlter || isHeightAlter)
                {
                    if (newSelfSize.width < 0)
                    {
                        newSelfSize.width = 0
                    }
                    
                    if (newSelfSize.height < 0)
                    {
                        newSelfSize.height = 0
                    }
                    
                    if self.transform.isIdentity
                    {
                        var currentFrame = self.frame
                        
                        if (isWidthAlter && lsc.tg_width.isWrap)
                        {
                          currentFrame.size.width = newSelfSize.width
                        }
                        
                        if (isHeightAlter && lsc.tg_height.isWrap)
                        {
                            currentFrame.size.height = newSelfSize.height
                        }
                        
                        self.frame = currentFrame
                    }
                    else
                    {
                        var currentBounds = self.bounds;
                        var currentCenter = self.center;
                        
                        var superViewZoomScale:CGFloat = 1.0
                        if let sscrolV = self.superview as? UIScrollView
                        {
                           superViewZoomScale = sscrolV.zoomScale
                        }
                        
                        if (isWidthAlter && lsc.tg_width.isWrap)
                        {
                            currentBounds.size.width = newSelfSize.width
                            currentCenter.x += (newSelfSize.width - oldSelfSize.width) * self.layer.anchorPoint.x * superViewZoomScale
                        }
                        
                        if (isHeightAlter && lsc.tg_height.isWrap)
                        {
                            currentBounds.size.height = newSelfSize.height
                            currentCenter.y += (newSelfSize.height - oldSelfSize.height) * self.layer.anchorPoint.y * superViewZoomScale
                        }
                        
                        self.bounds = currentBounds
                        self.center = currentCenter
                    }
                }
            }
            
            
            
            
            if newSelfSize.width != CGFloat.greatestFiniteMagnitude
            {
                let supv:UIView! = self.superview

                if _tgBorderlineLayerDelegate != nil
                {
                    var borderlineRect = CGRect(x: 0, y: 0, width: newSelfSize.width, height: newSelfSize.height)
                    if let supvlayout = supv as? TGBaseLayout
                    {
                        //这里给父布局视图一个机会来可以改变当前布局的borderlineRect的值，也就是显示的边界线有可能会超出当前布局视图本身的区域。
                        //比如一些表格或者其他的情况。默认情况下这个函数什么也不做。
                        supvlayout.tgHook(sublayout: self, borderlineRect: &borderlineRect)
                    }
                    
                    _tgBorderlineLayerDelegate.setNeedsLayout(borderlineRect)
                }
                
                //如果自己的父视图是非UIScrollView以及非布局视图。以及自己的宽度是.wrap或者高度是.wrap时，并且如果设置了在父视图居中或者居下或者居右时要在父视图中更新自己的位置。
                if supv != nil && !supv.isKind(of: TGBaseLayout.self)
                {
                    
                    let rectSuper = supv.bounds
                    let rectSelf = self.bounds
                    var centerPonintSelf = self.center
                    
                    //特殊处理低版本下的top和bottom的两种安全区域的场景。
                    if #available(iOS 11.0, *){}
                    else {
                        if lsc.top.isSafeAreaPos || lsc.bottom.isSafeAreaPos
                        {
                            if (lsc.top.isSafeAreaPos)
                            {
                                centerPonintSelf.y = lsc.top.weightPosIn(rectSuper.height) + self.layer.anchorPoint.y * rectSelf.height
                            }
                            else
                            {
                                centerPonintSelf.y  = rectSuper.height - rectSelf.height - lsc.bottom.weightPosIn(rectSuper.height) + self.layer.anchorPoint.y * rectSelf.height
                            }
                        }
                    }
                    
                    
                    if !supv.isKind(of: UIScrollView.self) && lsc.isSomeSizeWrap
                    {
                       
                        
                        if TGBaseLayout.tg_isRTL
                        {
                            centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x;
                        }
                        
                        if lsc.width.isWrap
                        {
                            //如果只设置了右边，或者只设置了居中则更新位置。。
                            if lsc.centerX.hasValue
                            {
                                centerPonintSelf.x = (rectSuper.width - rectSelf.width)/2 + lsc.centerX.weightPosIn(rectSuper.width) + self.layer.anchorPoint.x * rectSelf.width
                            }
                            else if lsc.trailing.hasValue && !lsc.leading.hasValue
                            {
                                centerPonintSelf.x  = rectSuper.width - rectSelf.width - lsc.trailing.weightPosIn(rectSuper.width) + self.layer.anchorPoint.x * rectSelf.width
                            }
                            
                        }
                        
                        if lsc.height.isWrap
                        {
                            if lsc.centerY.hasValue
                            {
                                centerPonintSelf.y = (rectSuper.height - rectSelf.height)/2 + lsc.centerY.weightPosIn(rectSuper.height) + self.layer.anchorPoint.y * rectSelf.height
                            }
                            else if lsc.bottom.hasValue && !lsc.top.hasValue
                            {
                                centerPonintSelf.y  = rectSuper.height - rectSelf.height - lsc.bottom.weightPosIn(rectSuper.height) + self.layer.anchorPoint.y * rectSelf.height
                            }
                        }
                        
                        if TGBaseLayout.tg_isRTL
                        {
                           centerPonintSelf.x = rectSuper.size.width - centerPonintSelf.x
                        }

                    }
                    
                    //如果有变化则只调整自己的center。而不变化
                    if  !_tgCGPointEqual(self.center, centerPonintSelf)
                    {
                        self.center = centerPonintSelf
                    }
                    
                }
                
                
                //这里处理当布局视图的父视图是非布局父视图，且父视图的尺寸是.wrap时需要调整父视图的尺寸。
                if (supv != nil && !supv.isKind(of: TGBaseLayout.self))
                {
                    let suplsc = supv.tgCurrentSizeClass as! TGViewSizeClassImpl
                    
                    
                    let selftgTopMargin:CGFloat = lsc.top.absPos
                    let selftgBottomMargin:CGFloat = lsc.bottom.absPos
                    let selftgLeadingMargin:CGFloat = lsc.leading.absPos
                    let selftgTrailingMargin:CGFloat = lsc.trailing.absPos
                    
                    if suplsc.isSomeSizeWrap
                    {
                        //调整父视图的高度和宽度。frame值。
                        var superBounds = supv.bounds
                        var superCenter = supv.center
                        
                        if suplsc.height.isWrap
                        {
                            superBounds.size.height = self.tgValidMeasure(suplsc.height, sbv: supv, calcSize: selftgTopMargin + newSelfSize.height + selftgBottomMargin, sbvSize: superBounds.size, selfLayoutSize: newSelfSize)
                            superCenter.y += (superBounds.height - supv.bounds.height) * supv.layer.anchorPoint.y
                        }
                        
                        if suplsc.width.isWrap
                        {
                            superBounds.size.width = self.tgValidMeasure(suplsc.width, sbv: supv, calcSize: selftgLeadingMargin + newSelfSize.width + selftgTrailingMargin, sbvSize: superBounds.size, selfLayoutSize: newSelfSize)
                            superCenter.x += (superBounds.width - supv.bounds.width) * supv.layer.anchorPoint.x
                        }
                        
                        if !_tgCGRectEqual(supv.bounds, superBounds)
                        {
                            supv.center = superCenter
                            supv.bounds = superBounds
                            
                        }
                        
                    }
                }
                
                //处理父视图是滚动视图时动态调整滚动视图的contentSize
                self.tgAlterScrollViewContentSize(newSelfSize, lsc:lsc)
                
                
            }
            
            if tgFrame.multiple
            {
                tgFrame.sizeClass = self.tgDefaultSizeClass
            }
            self.tg_isLayouting = false
        }
        
        _tgEndLayoutAction?()
        _tgEndLayoutAction = nil
        
        
        //执行屏幕旋转的处理逻辑。
        if (_tgRotationToDeviceOrientationAction != nil && currentScreenOrientation != nil)
        {
            if (_tgLastScreenOrientation == nil)
            {
                _tgLastScreenOrientation = currentScreenOrientation;
                _tgRotationToDeviceOrientationAction!(self,true, currentScreenOrientation == 1);
            }
            else
            {
                if (_tgLastScreenOrientation != currentScreenOrientation)
                {
                    _tgLastScreenOrientation = currentScreenOrientation;
                    _tgRotationToDeviceOrientationAction!(self, false, currentScreenOrientation == 1);
                }
            }
            
            _tgLastScreenOrientation = currentScreenOrientation;
        }
        
        
        
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *){
            if previousTraitCollection != nil && self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                _tgBorderlineLayerDelegate?.updateAllBorderlineColor()
            }
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
                _tgBorderlineLayerDelegate?.setNeedsLayout(CGRect(x:0, y:0, width:self.bounds.width, height:self.bounds.height))
                
                if (self.superview as? TGBaseLayout) != nil
                {
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        if self.superview != nil && (self.superview! as? TGBaseLayout) == nil
        {
           let _ = self.tgUpdateLayoutRectInNoLayoutSuperview(self.superview!)
        }
        
    }
    
    
    override open func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        if let lv = subview as? TGBaseLayout
        {
            lv.tg_cacheEstimatedRect = self.tg_cacheEstimatedRect
        }
        
        self.tgInvalidateIntrinsicContentSize()
    }
    
    override open func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        self.tgRemoveSubviewObserver(subview: subview)
        self.tgInvalidateIntrinsicContentSize()
    }
    
    
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClassImpl
        
        if (newSuperview != nil)
        {
            let defRectEdge:UIRectEdge = [UIRectEdge.left, UIRectEdge.right]
            if self.value(forKey: "viewDelegate") != nil
            {
                if lsc.width.isWrap
                {
                    lsc.tg_width.equal(nil)
                }
                
                if lsc.height.isWrap
                {
                    lsc.tg_height.equal(nil)
                }
                
                if lsc.tg_insetsPaddingFromSafeArea.rawValue == defRectEdge.rawValue
                {
                    lsc.tg_insetsPaddingFromSafeArea = [UIRectEdge.left, UIRectEdge.right, UIRectEdge.bottom]
                }
                
                self.tg_adjustScrollViewContentSizeMode = TGAdjustScrollViewContentSizeMode.no
            }
            
            if ((newSuperview as? UIScrollView) != nil && (newSuperview as? UITableView) == nil && (newSuperview as? UICollectionView) == nil)
            {
                if lsc.tg_insetsPaddingFromSafeArea.rawValue == defRectEdge.rawValue
                {
                    lsc.tg_insetsPaddingFromSafeArea = [UIRectEdge.left, UIRectEdge.right, UIRectEdge.bottom]
                }
            }
            
        }
        
        
        //将要添加到父视图时，如果不是MyLayout派生则则跟需要根据父视图的frame的变化而调整自身的位置和尺寸
        if newSuperview != nil && (newSuperview as? TGBaseLayout) == nil
        {
            let newSuperview:UIView = newSuperview!
            
            #if DEBUG
                
                if let t = lsc.leading.posVal
                {
                    //约束冲突：左边距依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)leading margin dependent on:\(t.view)is not superview")
                }
                
                if let t = lsc.trailing.posVal
                {
                    //约束冲突：右边距依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)trailing margin dependent on:\(t.view) is not superview");
                }
                
                if let t = lsc.centerX.posVal
                {
                    //约束冲突：水平中心点依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)horizontal center margin dependent on:\(t.view) is not superview")
                }
                
                if let t = lsc.top.posVal
                {
                    //约束冲突：上边距依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)top margin dependent on:\(t.view) is not superview")
                }
                
                if let t = lsc.bottom.posVal
                {
                    //约束冲突：下边距依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)bottom margin dependent on:\(t.view) is not superview")
                    
                }
                
                if let t = lsc.centerY.posVal
                {
                    //约束冲突：垂直中心点依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)vertical center margin dependent on:\(t.view) is not superview")
                }
                
                if let t = lsc.width.sizeVal
                {
                    //约束冲突：宽度依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)width dependent on:\(t.view!) is not superview")
                }
                
                if let t = lsc.height.sizeVal
                {
                    //约束冲突：高度依赖的视图不是父视图
                    assert(t.view == newSuperview, "Constraint exception!! \(self)height dependent on:\(t.view!) is not superview")
                }
                
            #endif
            
            if (self.tgUpdateLayoutRectInNoLayoutSuperview(newSuperview))
            {
                //有可能父视图不为空，所以这里先把以前父视图的KVO删除。否则会导致程序崩溃
                
                //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
                //然后在左边将异常断点清除即可
                
                if _tgIsAddSuperviewKVO && self.superview != nil && (self.superview as? TGBaseLayout) == nil
                {
                    self.superview!.removeObserver(self, forKeyPath:"frame")
                    self.superview!.removeObserver(self, forKeyPath:"bounds")
                    
                }
                
                newSuperview.addObserver(self,forKeyPath:"frame",options:[.new,.old], context:&TGBaseLayout._stgObserverCtxC)
                newSuperview.addObserver(self,forKeyPath:"bounds",options:[.new,.old], context:&TGBaseLayout._stgObserverCtxC)
                _tgIsAddSuperviewKVO = true
            }
            
        }
        
        if (_tgIsAddSuperviewKVO && newSuperview == nil && self.superview != nil && (self.superview as? TGBaseLayout) == nil)
        {
            
            //如果您在这里出现了崩溃时，不要惊慌，是因为您开启了异常断点调试的原因。这个在release下是不会出现的，要想清除异常断点调试功能，请按下CMD+7键
            //然后在左边将异常断点清除即可
            
            _tgIsAddSuperviewKVO = false;
            
            self.superview!.removeObserver(self, forKeyPath:"frame")
            self.superview!.removeObserver(self,forKeyPath:"bounds")
            
            
        }
        
        
        if (newSuperview != nil)
        {
            //不支持放在UITableView和UICollectionView下,因为有肯能是tableheaderView或者section下。
            if ((newSuperview as? UIScrollView) != nil && (newSuperview as? UITableView) == nil && (newSuperview as? UICollectionView) == nil)
            {
                if self.tg_adjustScrollViewContentSizeMode == TGAdjustScrollViewContentSizeMode.auto
                {
                    //这里预先设置一下contentSize主要是为了解决contentOffset在后续计算contentSize的偏移错误的问题。
                    UIView.performWithoutAnimation {
                        
                       // UIScrollView *scrollSuperView = (UIScrollView*)newSuperview;
                        if let scrollSuperView = newSuperview as? UIScrollView, scrollSuperView.contentSize.equalTo(CGSize.zero)
                        {
                            let screenSize = UIScreen.main.bounds.size
                            scrollSuperView.contentSize =  CGSize(width:0, height:screenSize.height + 0.1)
                        }
                    }
                    
                    self.tg_adjustScrollViewContentSizeMode = TGAdjustScrollViewContentSizeMode.yes
                }
            }
        }
        else
        {
            _tgBeginLayoutAction = nil
            _tgEndLayoutAction = nil
        }
        
    }
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if context == &TGBaseLayout._stgObserverCtxC
        {
            var rcOld = change![.oldKey] as? CGRect
            var rcNew = change![.newKey] as? CGRect
            
            if (rcOld == nil && rcNew == nil)
            {
                rcOld = (change![.oldKey] as! NSValue).cgRectValue
                rcNew = (change![.newKey] as! NSValue).cgRectValue
            }
            
            if  !_tgCGSizeEqual(rcOld!.size, rcNew!.size)
            {
                let _ = self.tgUpdateLayoutRectInNoLayoutSuperview(self.superview!)
            }
            
            return
        }
        
        
        if !self.tg_isLayouting
        {
            if context == &TGBaseLayout._stgObserverCtxA
            {
                
                setNeedsLayout()
                
                if keyPath == "hidden" && !(change![.newKey] as! Bool)
                {
                    (object as! UIView).setNeedsDisplay()
                }
            }
            else if context == &TGBaseLayout._stgObserverCtxB
            {
                if let sbv = object as? UIView
                {
                    let sbvsc = sbv.tgCurrentSizeClass as! TGViewSizeClassImpl
                    if sbvsc.isSomeSizeWrap
                    {
                        self.setNeedsLayout()
                    }
                }
            }
            
            
            
        }
        
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        _tgTouchEventDelegate?.touchesBegan(touches, with: event)
        
        super.touchesBegan(touches,with:event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        _tgTouchEventDelegate?.touchesMoved(touches, with: event)
        
        super.touchesMoved(touches,with:event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        _tgTouchEventDelegate?.touchesEnded(touches, with: event)
        
        super.touchesEnded(touches, with:event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        _tgTouchEventDelegate?.touchesCancelled(touches, with: event)
        
        super.touchesCancelled(touches,with:event)
    }
    
    internal func tgCalcLayoutRect(_ size:CGSize, isEstimate:Bool, hasSubLayout:inout Bool!, sbs:[UIView]!, type:TGSizeClassType) ->CGSize
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
        
        if hasSubLayout != nil
        {
            hasSubLayout = false
        }
        
        return selfSize
        
    }
    
    override func tgCreateInstance() -> AnyObject
    {
        return TGLayoutViewSizeClassImpl(view:self)
    }
    
    internal func tgHook(sublayout:TGBaseLayout, borderlineRect: inout CGRect)
    {
        //do nothing...
    }
    
    //MARK:private var
    
    //边界线处理的代理对象。
    private var _tgBorderlineLayerDelegate:TGBorderlineLayerDelegate!
    //触摸事件处理代理对象。
    private var _tgTouchEventDelegate:TGTouchEventDelegate!
    //布局回调处理
    private lazy var _tgBeginLayoutAction:(()->Void)? = nil
    private lazy var _tgEndLayoutAction:(()->Void)? = nil
    
    
    //旋转处理。
    fileprivate  var _tgLastScreenOrientation:Int! = nil //为nil为初始状态，为1为竖屏，为2为横屏。内部使用。
    fileprivate  var _tgRotationToDeviceOrientationAction:((_ layout:TGBaseLayout, _ isFirst:Bool, _ isPortrait:Bool)->Void)? = nil
    
    fileprivate var _tgIsAddSuperviewKVO:Bool=false
    
    fileprivate var _tgUseCacheRects = false
    
    static fileprivate var _stgSizeClassType:TGSizeClassType! = nil

    //用于加快KVO性能
    static fileprivate var _stgObserverCtxA:Int = 2017520
    static fileprivate var _stgObserverCtxB:Int = 2017521
    static fileprivate var _stgObserverCtxC:Int = 2017522

    
}


extension TGBaseLayout
{

    internal func tgCalcHeightFromHeightWrapView(_ sbv:UIView, sbvsc:TGViewSizeClassImpl, width:CGFloat) ->CGFloat
    {
        var h:CGFloat = sbv.sizeThatFits(CGSize(width: width, height: 0)).height
        if let sbvimg = sbv as? UIImageView, !sbvsc.width.isWrap
        {
            //根据图片的尺寸进行等比缩放得到合适的高度。
            if let img = sbvimg.image , img.size.width != 0
            {
                h = img.size.height * (width / img.size.width)
            }
        }
        else if let sbvButton = sbv as? UIButton
        {//按钮特殊处理多行的。。
            
            if sbvButton.titleLabel != nil
            {
                //得到按钮本身的高度，以及单行文本的高度，这样就能算出按钮和文本的间距
                let buttonSize = sbvButton.sizeThatFits(CGSize.zero)
                let buttonTitleSize = sbvButton.titleLabel!.sizeThatFits(CGSize.zero)
                let sz = sbvButton.titleLabel!.sizeThatFits(CGSize(width: width, height: 0))
                
                h = sz.height + buttonSize.height - buttonTitleSize.height //这个sz只是纯文本的高度，所以要加上原先按钮和文本的高度差。。
            }
        }
        
        
        return sbvsc.height.measure(h)
        
    }
    
    
    private func tgGetBoundLimitMeasure(_ boundDime:TGLayoutSize!,sbv:UIView, dimeType:TGGravity, sbvSize:CGSize, selfLayoutSize:CGSize,isUBound:Bool) ->CGFloat
    {
        var value = isUBound ? CGFloat.greatestFiniteMagnitude : -CGFloat.greatestFiniteMagnitude
        if boundDime === nil
        {
            return value
        }
        
        if let t = boundDime.numberVal
        {
            value = t
        }
        else if let t = boundDime.sizeVal
        {
            if t.view == self
            {
                if (t.type == TGGravity.horz.fill)
                {
                    let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClassImpl
                    value = selfLayoutSize.width - (t.view == self ? (lsc.tgLeadingPadding + lsc.tgTrailingPadding) : 0);
                }
                else
                {
                    let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClassImpl
                    value = selfLayoutSize.height - (t.view == self ? (lsc.tgTopPadding + lsc.tgBottomPadding) :0);
                }
            }
            else if (t.view == sbv)
            {
                if (t.type == dimeType)
                {
                    //约束冲突：无效的边界设置方法
                    assert(false, "Constraint exception!! \(sbv) has invalid min or max setting");
                }
                else
                {
                    if (t.type ==  TGGravity.horz.fill)
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
                if (t.type == TGGravity.horz.fill)
                {
                    
                    value = t.view.tg_estimatedFrame.width
                }
                else
                {
                    
                    value = t.view.tg_estimatedFrame.height
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
    
    
    
    internal func tgValidMeasure(_ dime:TGLayoutSizeValue2, sbv:UIView, calcSize:CGFloat, sbvSize:CGSize, selfLayoutSize:CGSize) ->CGFloat
    {
        if dime.realSize == nil
        {
            return calcSize
        }
        
        //算出最大最小值。
        var minV = -CGFloat.greatestFiniteMagnitude
        if dime.realSize!.isActive
        {
            minV = self.tgGetBoundLimitMeasure(dime.minVal, sbv:sbv, dimeType:dime.realSize!.type, sbvSize:sbvSize, selfLayoutSize:selfLayoutSize, isUBound:false)
        }
        
        var  maxV = CGFloat.greatestFiniteMagnitude
        if dime.realSize!.isActive
        {
            maxV = self.tgGetBoundLimitMeasure(dime.maxVal, sbv:sbv, dimeType:dime.realSize!.type, sbvSize:sbvSize, selfLayoutSize:selfLayoutSize,isUBound:true)
        }
        
        var retCalcSize = calcSize
        retCalcSize = max(minV, retCalcSize);
        retCalcSize = min(maxV, retCalcSize);
        
        return retCalcSize;
    }
    
    
    private func tgGetBoundLimitMargin(_ boundPos:TGLayoutPos!, sbv:UIView, selfLayoutSize:CGSize) ->CGFloat
    {
        var value:CGFloat = 0;
        if boundPos == nil
        {
            return value
        }
        
        if let t = boundPos.numberVal
        {
            value = t
        }
        else if let t = boundPos.posVal
        {
            let rect = t.view.tgFrame.frame;
            
            let pos = t.type;
            if (pos == TGGravity.horz.leading)
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
            else if (pos == TGGravity.horz.trailing)
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
        
        return value + boundPos.offset;
        
    }
    
    
    internal func tgValidMargin(_ pos:TGLayoutPosValue2, sbv:UIView, calcPos:CGFloat, selfLayoutSize:CGSize) ->CGFloat
    {
        if pos.realPos == nil
        {
            return calcPos
        }
        
        //算出最大最小值
        var minV = -CGFloat.greatestFiniteMagnitude
        if pos.realPos!.isActive && pos.minVal != nil
        {
            minV = self.tgGetBoundLimitMargin(pos.minVal, sbv:sbv,selfLayoutSize:selfLayoutSize)
        }
        
        var  maxV = CGFloat.greatestFiniteMagnitude
        if pos.realPos!.isActive && pos.maxVal != nil
        {
            maxV = self.tgGetBoundLimitMargin(pos.maxVal,sbv:sbv,selfLayoutSize:selfLayoutSize)
        }
        
        var retCalcPos = calcPos
        retCalcPos = max(minV, retCalcPos);
        retCalcPos = min(maxV, retCalcPos);
        return retCalcPos;
    }
    
    
    fileprivate func tgCalcSizeInNoLayout(newSuperview:UIView!, currentSize size:CGSize) -> CGSize
    {
        if newSuperview == nil || newSuperview.isKind(of: TGBaseLayout.self)
        {
            return size
        }
        
        
        let rectSuper = newSuperview.bounds
        let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClassImpl
        let ssc =  newSuperview.tgCurrentSizeClass as! TGViewSizeClassImpl
        var size = size
        
        if !ssc.width.isWrap
        {
            
            if (lsc.width.sizeVal != nil && lsc.width.sizeVal.view  === newSuperview) || lsc.width.isFill
            {
                
                if  lsc.width.isFill || lsc.width.sizeVal.type == TGGravity.horz.fill
                {
                    size.width = lsc.width.measure(rectSuper.width)
                }
                else
                {
                    size.width = lsc.width.measure(rectSuper.height)
                }
                size.width = self.tgValidMeasure(lsc.width, sbv: self, calcSize: size.width, sbvSize: size, selfLayoutSize: rectSuper.size)
            }
            
            if lsc.isHorzMarginHasValue
            {
                let  leadingMargin =  lsc.leading.weightPosIn(rectSuper.width)
                let trailingMargin = lsc.trailing.weightPosIn(rectSuper.width)
                size.width = rectSuper.width - leadingMargin - trailingMargin
                size.width = self.tgValidMeasure(lsc.width, sbv: self, calcSize: size.width, sbvSize: size, selfLayoutSize: rectSuper.size)
            }
            
            if size.width < 0
            {
                size.width = 0
            }
        }
        
        if !ssc.height.isWrap
        {
           
            if  (lsc.height.sizeVal != nil && lsc.height.sizeVal.view  === newSuperview) || lsc.height.isFill
            {
                if  lsc.height.isFill || lsc.height.sizeVal.type == TGGravity.vert.fill
                {
                    size.height = lsc.height.measure(rectSuper.height)
                }
                else
                {
                    size.height = lsc.height.measure(rectSuper.width)
                }
                
                size.height = self.tgValidMeasure(lsc.height, sbv: self, calcSize: size.height, sbvSize: size, selfLayoutSize: rectSuper.size)
            }
            
            if lsc.isVertMarginHasValue
            {
                let  topMargin =  lsc.top.weightPosIn(rectSuper.height)
                let bottomMargin = lsc.bottom.weightPosIn(rectSuper.height)
                size.height = rectSuper.height - topMargin - bottomMargin
                size.height = self.tgValidMeasure(lsc.height, sbv: self, calcSize: size.height, sbvSize: size, selfLayoutSize: rectSuper.size)
            }
            
            if size.height < 0
            {
                size.height = 0
            }
        }
        
        
        
        return size
    }
    
    
    
    fileprivate func tgUpdateLayoutRectInNoLayoutSuperview(_ newSuperview:UIView) -> Bool
    {
        var isAdjust = false;
        
        let lsc = self.tgCurrentSizeClass as! TGLayoutViewSizeClassImpl
        
        let rectSuper = newSuperview.bounds
        var leadingMargin = lsc.leading.weightPosIn(rectSuper.width)
        let trailingMargin = lsc.trailing.weightPosIn(rectSuper.width)
        var topMargin = lsc.top.weightPosIn(rectSuper.height)
        let bottomMargin = lsc.bottom.weightPosIn(rectSuper.height)
    
        var rectSelf = self.bounds
        
        //针对滚动父视图做特殊处理，如果父视图是滚动视图，而且当前的缩放比例不为1时系统会调整中心点的位置，因此这里需要特殊处理。
        var superViewZoomScale:CGFloat = 1.0
        if let sscrolV = self.superview as? UIScrollView
        {
            superViewZoomScale = sscrolV.zoomScale
        }
        
        rectSelf.origin.x = self.center.x - rectSelf.size.width * self.layer.anchorPoint.x * superViewZoomScale
        rectSelf.origin.y = self.center.y - rectSelf.size.height * self.layer.anchorPoint.y * superViewZoomScale
        
        let oldSelfRect = rectSelf
        
        //确定左右边距和宽度。
        if !lsc.width.isWrap && lsc.width.hasValue
        {
            if lsc.width.isFill
            {
                rectSelf.size.width = lsc.width.measure(rectSuper.width - leadingMargin - trailingMargin)
                isAdjust = true
            }
            else if let t = lsc.width.sizeVal
            {
                if t.view === newSuperview
                {
                    if t.type == TGGravity.horz.fill
                    {
                        rectSelf.size.width = lsc.width.measure(rectSuper.width)
                    }
                    else
                    {
                        rectSelf.size.width = lsc.width.measure(rectSuper.height)
                    }
                    
                }
                else
                {
                    rectSelf.size.width = lsc.width.measure(t.view.tg_estimatedFrame.width)
                }
                
                isAdjust = true
                
            }
            else if let t = lsc.width.weightVal
            {
                rectSelf.size.width = lsc.width.measure(rectSuper.width * t.rawValue / 100)
                isAdjust = true
            }
            else
            {
                rectSelf.size.width = lsc.width.measure
            }
        }
        
        //这里要判断自己的宽度设置了最小和最大宽度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
        if let t = lsc.width.maxVal?.sizeVal, t.view === newSuperview
        {
            isAdjust = true
        }
        if let t = lsc.width.minVal?.sizeVal, t.view === newSuperview
        {
            isAdjust = true
        }
        
        rectSelf.size.width = self.tgValidMeasure(lsc.width,sbv:self,calcSize:rectSelf.width,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size);
        
        if TGBaseLayout.tg_isRTL
        {
            rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width
        }
        
        if lsc.isHorzMarginHasValue
        {
            
            isAdjust = true;
            lsc.width.realSize?.equal(nil)
            rectSelf.size.width = rectSuper.width - leadingMargin - trailingMargin
            rectSelf.size.width = self.tgValidMeasure(lsc.width,sbv:self,calcSize:rectSelf.width,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size);
            
            if let scrollSuperView = newSuperview as? UIScrollView, #available(iOS 11.0, *) {

                if lsc.leading.isSafeAreaPos
                {
                    leadingMargin = lsc.leading.offset + (TGBaseLayout.tg_isRTL ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - (TGBaseLayout.tg_isRTL ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left)
                }
            }
            
            rectSelf.origin.x = leadingMargin
        }
        else if lsc.centerX.hasValue
        {
            isAdjust = true;
            rectSelf.origin.x = (rectSuper.width - rectSelf.width)/2 + lsc.centerX.weightPosIn(rectSuper.width)
        }
        else if lsc.leading.hasValue
        {
            if let scrollSuperView = newSuperview as? UIScrollView, #available(iOS 11.0, *) {
                
                if lsc.leading.isSafeAreaPos
                {
                    leadingMargin = lsc.leading.offset + (TGBaseLayout.tg_isRTL ? scrollSuperView.safeAreaInsets.right : scrollSuperView.safeAreaInsets.left) - (TGBaseLayout.tg_isRTL ? scrollSuperView.adjustedContentInset.right : scrollSuperView.adjustedContentInset.left)
                }
            }
            
            rectSelf.origin.x = leadingMargin
        }
        else if lsc.trailing.hasValue
        {
            isAdjust = true;
            rectSelf.origin.x  = rectSuper.width - rectSelf.width - trailingMargin
        }
        else
        {
            
        }
        
        
        if !lsc.height.isWrap && lsc.height.hasValue
        {
            if  lsc.height.isFill
            {
                rectSelf.size.height = lsc.height.measure(rectSuper.height - topMargin - bottomMargin)
                isAdjust = true;
            }
            else if let t = lsc.height.sizeVal
            {
                if t.view === newSuperview
                {
                    if t.type == TGGravity.vert.fill
                    {
                        rectSelf.size.height = lsc.height.measure(rectSuper.height)
                    }
                    else
                    {
                        rectSelf.size.height = lsc.height.measure(rectSuper.width)
                    }
                }
                else
                {
                    rectSelf.size.height = lsc.height.measure(t.view.tg_estimatedFrame.height)
                }
                
                isAdjust = true
                
            }
            else if let t = lsc.height.weightVal
            {
                rectSelf.size.height = lsc.height.measure(rectSuper.height * t.rawValue / 100)
                isAdjust = true;
            }
            else
            {
                rectSelf.size.height = lsc.height.measure
            }
        }
        
        //这里要判断自己的高度设置了最小和最大高度依赖于父视图的情况。如果有这种情况，则父视图在变化时也需要调整自身。
        if let t = lsc.height.maxVal?.sizeVal, t.view === newSuperview
        {
            isAdjust = true
        }
        if let t = lsc.height.minVal?.sizeVal, t.view === newSuperview
        {
            isAdjust = true
        }
        
        rectSelf.size.height = self.tgValidMeasure(lsc.height,sbv:self,calcSize:rectSelf.height,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size);
        
        if lsc.isVertMarginHasValue
        {
            isAdjust = true;
            lsc.height.realSize?.equal(nil)
            rectSelf.size.height = rectSuper.height - topMargin - topMargin
            rectSelf.size.height = self.tgValidMeasure(lsc.height,sbv:self,calcSize:rectSelf.height,sbvSize:rectSelf.size,selfLayoutSize:rectSuper.size)
            
            if let scrollSuperView = newSuperview as? UIScrollView, #available(iOS 11.0, *) {
                
                if lsc.top.isSafeAreaPos
                {
                    topMargin = lsc.top.offset + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top
                }
            }
            
            rectSelf.origin.y = topMargin
        }
        else if lsc.centerY.hasValue
        {
            isAdjust = true;
            rectSelf.origin.y = (rectSuper.height - rectSelf.height)/2 + lsc.centerY.weightPosIn(rectSuper.height)
        }
        else if lsc.top.hasValue
        {
            if let scrollSuperView = newSuperview as? UIScrollView, #available(iOS 11.0, *) {
                
                if lsc.top.isSafeAreaPos
                {
                    topMargin = lsc.top.offset + scrollSuperView.safeAreaInsets.top - scrollSuperView.adjustedContentInset.top
                }
            }
            
            rectSelf.origin.y = topMargin
        }
        else if lsc.bottom.hasValue
        {
            isAdjust = true;
            rectSelf.origin.y  = rectSuper.height - rectSelf.height - bottomMargin
        }
        else
        {
            
        }
        
        if TGBaseLayout.tg_isRTL
        {
            rectSelf.origin.x = rectSuper.size.width - rectSelf.origin.x - rectSelf.size.width
        }
        
        rectSelf = _tgRoundRect(rectSelf)
        if !_tgCGRectEqual(rectSelf, oldSelfRect)
        {
            if (rectSelf.size.width < 0)
            {
                rectSelf.size.width = 0
            }
            if (rectSelf.size.height < 0)
            {
                rectSelf.size.height = 0
            }
            
            
            if self.transform.isIdentity
            {
                self.frame = rectSelf
            }
            else
            {
                self.bounds = CGRect(x:self.bounds.origin.x, y:self.bounds.origin.y, width:rectSelf.width, height:rectSelf.height)
                self.center = CGPoint(x:rectSelf.origin.x + self.layer.anchorPoint.x * rectSelf.width * superViewZoomScale, y:rectSelf.origin.y + self.layer.anchorPoint.y * rectSelf.height * superViewZoomScale)
            }
        }
        else if lsc.isSomeSizeWrap
        {
            self.setNeedsLayout()
        }
        
        return isAdjust;
        
    }
    
    
    internal func tgAdjustSizeWhenNoSubviews(size:CGSize, sbs:[UIView], lsc:TGLayoutViewSizeClassImpl) -> CGSize
    {
        //如果没有子视图，并且padding不参与空子视图尺寸计算则尺寸应该扣除padding的值。
        var size = size
        if sbs.count == 0 && !lsc.tg_zeroPadding
        {
            if lsc.width.isWrap
            {
                size.width -= (lsc.tgLeadingPadding + lsc.tgTrailingPadding)
            }
            if lsc.height.isWrap
            {
                size.height -= (lsc.tgTopPadding + lsc.tgBottomPadding)
            }
        }
        
        return size;
    }
    
    
    
    fileprivate func tgAlterScrollViewContentSize(_ newSize:CGSize, lsc:TGViewSizeClassImpl)
    {
        if let scrolv = self.superview as? UIScrollView , self.tg_adjustScrollViewContentSizeMode == TGAdjustScrollViewContentSizeMode.yes
        {
            var contSize = scrolv.contentSize
            let rectSuper = scrolv.bounds
            
            //这里把自己在父视图中的上下左右边距也算在contentSize的包容范围内。
            var leadingMargin = lsc.leading.weightPosIn(rectSuper.width)
            var trailingMargin = lsc.trailing.weightPosIn(rectSuper.width)
            var topMargin = lsc.top.weightPosIn(rectSuper.height)
            var bottomMargin = lsc.bottom.weightPosIn(rectSuper.height)
            
            
            if #available(iOS 11.0, *){
                
                if lsc.leading.isSafeAreaPos
                {
                    leadingMargin = lsc.leading.offset
                }
                
                if lsc.trailing.isSafeAreaPos
                {
                    trailingMargin = lsc.trailing.offset
                }
                
                if lsc.top.isSafeAreaPos
                {
                    topMargin = lsc.top.offset
                }
                
                if lsc.bottom.isSafeAreaPos
                {
                    bottomMargin = lsc.bottom.offset
                }
            }
            
            if contSize.height != newSize.height + topMargin + bottomMargin
            {
                contSize.height = newSize.height + topMargin + bottomMargin
            }
            if contSize.width != newSize.width + leadingMargin + trailingMargin
            {
                contSize.width = newSize.width + leadingMargin + trailingMargin
            }
            
            contSize.width *= scrolv.zoomScale
            contSize.height *= scrolv.zoomScale
            if !scrolv.contentSize.equalTo(contSize)
            {
               scrolv.contentSize =  contSize
            }
        }
    }
    
    fileprivate func tgSizeThatFits(size:CGSize, sbs:[UIView]!, inSizeClass type:TGSizeClassType) -> CGSize
    {
        let tgFrame = self.tgFrame
        
        if tgFrame.multiple
        {
            tgFrame.sizeClass = self.tgMatchBestSizeClass(type)
        }
        
        for sbv:UIView in self.subviews
        {
         
            let sbvtgFrame = sbv.tgFrame
            if sbvtgFrame.multiple
            {
                sbvtgFrame.sizeClass = sbv.tgMatchBestSizeClass(type)
            }
        }
        
        var hasSubLayout:Bool! = false
        var selfSize = self.tgCalcLayoutRect(size, isEstimate: false, hasSubLayout:&hasSubLayout, sbs:sbs, type: type)
        if hasSubLayout
        {
            tgFrame.width = selfSize.width
            tgFrame.height = selfSize.height
            selfSize = self.tgCalcLayoutRect(.zero, isEstimate: true, hasSubLayout:&hasSubLayout, sbs:sbs, type: type)
        }
        tgFrame.width = selfSize.width
        tgFrame.height = selfSize.height
        
        for sbv:UIView in self.subviews
        {
            let sbvtgFrame = sbv.tgFrame
            if sbvtgFrame.multiple
            {
              sbvtgFrame.sizeClass = self.tgDefaultSizeClass
            }
        }
        
        if tgFrame.multiple
        {
            tgFrame.sizeClass = self.tgDefaultSizeClass
        }
        
        if self.tg_cacheEstimatedRect
        {
            _tgUseCacheRects = true
        }
        
        return _tgRoundSize(selfSize)
        
    }
    
    
    internal func tgGetSubviewFont(_ sbv:UIView) ->UIFont!
    {
        var sbvFont:UIFont! = nil;
        
        if sbv.isKind(of: UILabel.self) ||
            sbv.isKind(of: UITextField.self) ||
            sbv.isKind(of: UITextView.self) ||
            sbv.isKind(of: UIButton.self)
        {
            sbvFont = (sbv.value(forKey: "font") as! UIFont)
        }
        
        return sbvFont;
    }
    
    internal func tgGetSubviewVertGravity(_ sbv:UIView, sbvsc:TGViewSizeClassImpl, vertGravity:TGGravity)->TGGravity
    {
        let sbvVertAlignment = sbvsc.tg_alignment & TGGravity.horz.mask
        var sbvVertGravity:TGGravity = TGGravity.vert.top
        if vertGravity != TGGravity.none
        {
            sbvVertGravity = vertGravity
            if sbvVertAlignment != TGGravity.none
            {
                sbvVertGravity = sbvVertAlignment
            }
        }
        else
        {
            
            if sbvVertAlignment != TGGravity.none
            {
                sbvVertGravity = sbvVertAlignment
            }
            
            
            if sbvsc.isVertMarginHasValue
            {
                sbvVertGravity = TGGravity.vert.fill;
            }
            else if sbvsc.centerY.hasValue
            {
                sbvVertGravity = TGGravity.vert.center;
            }
            else if sbvsc.top.hasValue
            {
                sbvVertGravity = TGGravity.vert.top;
            }
            else if sbvsc.bottom.hasValue
            {
                sbvVertGravity = TGGravity.vert.bottom
            }
        }
        
        return sbvVertGravity
    }

    
    
    internal func tgCalcVertGravity(_ vert:TGGravity, selfSize:CGSize, topPadding:CGFloat, bottomPadding:CGFloat, baselinePos:CGFloat!, sbv:UIView, sbvsc:TGViewSizeClassImpl, lsc:TGLayoutViewSizeClassImpl, rect:inout CGRect)
    {
        let fixedHeight = topPadding + bottomPadding
        let topMargin =  sbvsc.top.weightPosIn(selfSize.height - fixedHeight)
        let centerMargin = sbvsc.centerY.weightPosIn(selfSize.height - fixedHeight)
        let bottomMargin = sbvsc.bottom.weightPosIn(selfSize.height - fixedHeight)
        
        var vert = vert
        
        //确保设置基线对齐的视图都是UILabel,UITextField,UITextView
        if baselinePos == nil && vert == TGGravity.vert.baseline
        {
            vert = TGGravity.vert.top
        }
        
        var sbvFont:UIFont! = nil
        if vert == TGGravity.vert.baseline
        {
            sbvFont = self.tgGetSubviewFont(sbv)
        }
        
        if sbvFont == nil && vert == TGGravity.vert.baseline
        {
            vert = TGGravity.vert.top
        }
        
        if vert == TGGravity.vert.fill
        {
            rect.origin.y = topPadding + topMargin;
            rect.size.height = self.tgValidMeasure(sbvsc.height, sbv: sbv, calcSize:selfSize.height - fixedHeight - topMargin - bottomMargin , sbvSize: rect.size, selfLayoutSize: selfSize)
        }
        else if vert == TGGravity.vert.center
        {
            rect.origin.y = (selfSize.height - fixedHeight - topMargin - bottomMargin - rect.size.height)/2 + topPadding + topMargin + centerMargin;
        }
        else if vert == TGGravity.vert.windowCenter
        {
            if let twindow = self.window
            {
                rect.origin.y = (twindow.frame.size.height - topMargin - bottomMargin - rect.size.height)/2 + topMargin + centerMargin;
                rect.origin.y =  twindow.convert(rect.origin, to:self as UIView?).y;
            }
            
        }
        else if vert == TGGravity.vert.bottom
        {
            
            rect.origin.y = selfSize.height - bottomPadding - bottomMargin - rect.size.height;
        }
        else if vert == TGGravity.vert.baseline
        {
            //得到基线位置。
            rect.origin.y = baselinePos - sbvFont.ascender - (rect.height - sbvFont.lineHeight) / 2.0
        }
        else
        {
            rect.origin.y = topPadding + topMargin;
        }
    }
    
    
    internal func tgGetSubviewHorzGravity(_ sbv:UIView, sbvsc:TGViewSizeClassImpl, horzGravity:TGGravity)->TGGravity
    {
        let sbvHorzAligement = self.tgConvertLeftRightGravityToLeadingTrailing(sbvsc.tg_alignment & TGGravity.vert.mask)
        var sbvHorzGravity:TGGravity = TGGravity.horz.leading
        if horzGravity != TGGravity.none
        {
            sbvHorzGravity = horzGravity
            if sbvHorzAligement != TGGravity.none
            {
                sbvHorzGravity = sbvHorzAligement
            }
        }
        else
        {
            
            if sbvHorzAligement != TGGravity.none
            {
                sbvHorzGravity = sbvHorzAligement
            }
            
            if sbvsc.isHorzMarginHasValue
            {
                sbvHorzGravity = TGGravity.horz.fill;
            }
            else if sbvsc.centerX.hasValue
            {
                sbvHorzGravity = TGGravity.horz.center
            }
            else if sbvsc.leading.hasValue
            {
                sbvHorzGravity = TGGravity.horz.leading
            }
            else if sbvsc.trailing.hasValue
            {
                sbvHorzGravity = TGGravity.horz.trailing
            }
        }
        
        return sbvHorzGravity
    }

    
    internal func tgCalcHorzGravity(_ horz:TGGravity, selfSize:CGSize, leadingPadding:CGFloat, trailingPadding:CGFloat, sbv:UIView, sbvsc:TGViewSizeClassImpl, lsc:TGLayoutViewSizeClassImpl, rect:inout CGRect)
    {
        let fixedWidth = leadingPadding + trailingPadding
        let leadingMargin = sbvsc.leading.weightPosIn(selfSize.width - fixedWidth)
        let centerMargin = sbvsc.centerX.weightPosIn(selfSize.width - fixedWidth)
        let trailingMargin = sbvsc.trailing.weightPosIn(selfSize.width - fixedWidth)
        
        if horz == TGGravity.horz.fill
        {
            
            rect.origin.x = leadingPadding + leadingMargin;
            rect.size.width =  self.tgValidMeasure(sbvsc.width, sbv: sbv, calcSize:selfSize.width - fixedWidth - leadingMargin - trailingMargin , sbvSize: rect.size, selfLayoutSize: selfSize)
        }
        else if horz == TGGravity.horz.center
        {
            rect.origin.x = (selfSize.width - fixedWidth - leadingMargin - trailingMargin - rect.size.width)/2 + leadingPadding + leadingMargin + centerMargin;
        }
        else if horz == TGGravity.horz.windowCenter
        {
            if let twindow = self.window
            {
                rect.origin.x = (twindow.frame.size.width - leadingMargin - trailingMargin - rect.size.width)/2 + leadingMargin + centerMargin;
                rect.origin.x =  twindow.convert(rect.origin, to:self as UIView?).x;
                
                if (TGBaseLayout.tg_isRTL)
                {
                    rect.origin.x = selfSize.width - rect.origin.x - rect.size.width
                }
            }
            
        }
        else if horz == TGGravity.horz.trailing
        {
            rect.origin.x = selfSize.width - trailingPadding - trailingMargin - rect.size.width;
        }
        else
        {
            rect.origin.x = leadingPadding  + leadingMargin;
        }
    }
    
    //是否是不参加布局的子视图。
    internal func tgIsNoLayoutSubview(_ sbv:UIView) ->Bool
    {
        let sbvsc = sbv.tgCurrentSizeClass
        
        
        if sbvsc.tg_useFrame
        {
            return true
        }
        
        //如果当前是隐藏的
        if sbv.isHidden
        {
           return sbvsc.tg_visibility != TGVisibility.invisible
        }
        else
        {
            //如果是未隐藏则如何是设置是.gone则不参与布局,否则就参与布局
            return sbvsc.tg_visibility == TGVisibility.gone
        }
        
    }
    
    
    internal func tgGetLayoutSubviews() ->[UIView]
    {
        return self.tgGetLayoutSubviewsFrom(sbsFrom: self.subviews)
    }
    
    
    internal func  tgGetLayoutSubviewsFrom(sbsFrom:[UIView])->[UIView]
    {
        var sbs:[UIView] = [UIView]()
        
        sbs.append(contentsOf:sbsFrom)
        if self.tg_reverseLayout
        {
            sbs.reverse()
        }
        
        for (index,sbv) in sbs.enumerated().reversed()
        {
            if tgIsNoLayoutSubview(sbv)
            {
                sbs.remove(at: index)
            }
        }
        
        return sbs
        
    }
    
    
    internal func tgSetSubviewRelativeSize(_ dime:TGLayoutSizeValue2, selfSize:CGSize, sbvsc:TGViewSizeClassImpl, lsc:TGLayoutViewSizeClassImpl, rect:CGRect) ->CGRect
    {
        guard let t = dime.sizeVal else
        {
            return rect
        }
        
        var rect = rect
        
        if dime.realSize!.type == TGGravity.horz.fill
        {
            
            if t === lsc.width.realSize && !lsc.width.isWrap
            {
                rect.size.width = dime.measure(selfSize.width - lsc.tgLeadingPadding - lsc.tgTrailingPadding)
            }
            else if t === lsc.height.realSize
            {
                rect.size.width = dime.measure(selfSize.height - lsc.tgTopPadding - lsc.tgBottomPadding)
            }
            else if t === sbvsc.height.realSize
            {
                rect.size.width = dime.measure(rect.height)
            }
            else if t.type == TGGravity.horz.fill
            {
                rect.size.width = dime.measure(t.view.tg_estimatedFrame.width)
            }
            else
            {
                rect.size.width = dime.measure(t.view.tg_estimatedFrame.height)
            }
        }
        else
        {
            if t === lsc.height.realSize && !lsc.height.isWrap
            {
                rect.size.height = dime.measure(selfSize.height - lsc.tgTopPadding - lsc.tgBottomPadding)
            }
            else if t === lsc.width.realSize
            {
                rect.size.height = dime.measure(selfSize.width - lsc.tgLeadingPadding - lsc.tgTrailingPadding)
            }
            else if t ===  sbvsc.width.realSize
            {
                rect.size.height = dime.measure(rect.width)
            }
            else if (t.type == TGGravity.horz.fill)
            {
                rect.size.height = dime.measure(t.view.tg_estimatedFrame.width)
            }
            else
            {
                rect.size.height = dime.measure(t.view.tg_estimatedFrame.height)
            }
        }
        
        return rect
        
    }
    
    
    
    internal func tgCalcSizeFromSizeWrapSubview(_ sbv:UIView,sbvsc:TGViewSizeClassImpl, sbvtgFrame:TGFrame)
    {
        
        if sbvsc.tg_visibility == TGVisibility.gone
        {
            sbvtgFrame.width = 0
            sbvtgFrame.height = 0
            return
        }
        
        //只有非布局视图才这样处理。
        //如果宽度wrap并且高度wrap的话则直接调用sizeThatFits方法。
        //如果只是宽度wrap高度固定则依然可以调用sizeThatFits方法，不过这种场景基本不存在。
        //如果高度wrap但是宽度固定则适用flexHeight的规则，这里不适用。
        //最终的结果是非布局视图的宽度是wrap的情况下适用。
        if  (sbv as? TGBaseLayout) == nil && sbvsc.width.isWrap
        {
            var fits = CGSize.zero
            
            if let t = sbvsc.width.maxVal?.numberVal
            {
                fits.width = t
            }
            
            if let t = sbvsc.height.maxVal?.numberVal
            {
                fits.height = t
            }
            
            let fitSize = sbv.sizeThatFits(fits)
            sbvtgFrame.width = sbvsc.width.measure(fitSize.width)
            if sbvsc.height.isWrap
            {
                sbvtgFrame.height = sbvsc.height.measure(fitSize.height)
            }
        }
    }
    
    internal func tgConvertLeftRightGravityToLeadingTrailing(_ horzGravity:TGGravity) -> TGGravity
    {
        if horzGravity == TGGravity.horz.left
        {
            if TGBaseLayout.tg_isRTL
            {
                return TGGravity.horz.trailing
            }
            else
            {
                return TGGravity.horz.leading
            }
        }
        else if horzGravity == TGGravity.horz.right
        {
            if TGBaseLayout.tg_isRTL
            {
                return TGGravity.horz.leading
            }
            else
            {
                return TGGravity.horz.trailing
            }
        }
        else
        {
            return horzGravity
        }
        
    }
    
    internal func tgAdjustLayoutSelfSize(selfSize:inout CGSize, lsc:TGLayoutViewSizeClassImpl)
    {
        selfSize.height = self.tgValidMeasure(lsc.height,sbv:self,calcSize:selfSize.height,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
        selfSize.width = self.tgValidMeasure(lsc.width,sbv:self,calcSize:selfSize.width,sbvSize:selfSize,selfLayoutSize:(self.superview == nil ? CGSize.zero : self.superview!.bounds.size));
    }
    
    internal func tgAdjustSubviewsRTLPos(sbs:[UIView], selfWidth:CGFloat)
    {
        if TGBaseLayout.tg_isRTL
        {
            for sbv in sbs
            {
                let sbvtgFrame = sbv.tgFrame
    
                sbvtgFrame.leading = selfWidth - sbvtgFrame.leading - sbvtgFrame.width
                sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
            }
        }
    }
    
    internal func tgAdjustSubviewsLayoutTransform(sbs:[UIView], lsc:TGLayoutViewSizeClassImpl, selfSize:CGSize)
    {
        let layoutTransform = lsc.tg_layoutTransform
        if !layoutTransform.isIdentity
        {
            for sbv in sbs
            {
                let sbvtgFrame = sbv.tgFrame
                
                //取子视图中心点坐标。因为这个坐标系的原点是布局视图的左上角，所以要转化为数学坐标系的原点坐标, 才能应用坐标变换。
                var centerPoint = CGPoint(x:sbvtgFrame.leading + sbvtgFrame.width / 2.0 - selfSize.width / 2.0,
                                          y:sbvtgFrame.top + sbvtgFrame.height / 2.0 - selfSize.height / 2.0)
                
                //应用坐标变换
                centerPoint = centerPoint.applying(layoutTransform)
                
                //还原为左上角坐标系。
                centerPoint.x +=  selfSize.width / 2.0
                centerPoint.y += selfSize.height / 2.0
                
                //根据中心点的变化调整开始和结束位置。
                sbvtgFrame.leading = centerPoint.x - sbvtgFrame.width / 2.0
                sbvtgFrame.trailing = sbvtgFrame.leading + sbvtgFrame.width
                sbvtgFrame.top = centerPoint.y - sbvtgFrame.height / 2.0
                sbvtgFrame.bottom = sbvtgFrame.top + sbvtgFrame.height
            }
        }
    }

    internal func tgGetSubviewFrameAndSizeClass(_ subview:UIView) -> (TGFrame, TGViewSizeClassImpl)
    {
        let  sbvtgFrame = subview.tgFrame
        if sbvtgFrame.sizeClass == nil
        {
            sbvtgFrame.sizeClass = subview.tgDefaultSizeClass
        }
        
        return (sbvtgFrame, sbvtgFrame.sizeClass as! TGViewSizeClassImpl)
    }
    
   fileprivate class func tgGetGlobalSizeClassType(layoutv:TGBaseLayout) -> TGSizeClassType
    {
        if _stgSizeClassType == nil || (layoutv.superview as? TGBaseLayout) == nil
        {
            //得到最佳的sizeClass
            var sizeClassWidthType:TGSizeClassType.Width = TGSizeClassType.Width.any
            var sizeClassHeightType:TGSizeClassType.Height = TGSizeClassType.Height.any
            var sizeClassScreenType:TGSizeClassType.Screen? = nil
            if #available(iOS 8.0, *)
            {
                
                switch layoutv.traitCollection.verticalSizeClass {
                case UIUserInterfaceSizeClass.compact:
                    sizeClassHeightType = TGSizeClassType.Height.compact
                    break
                case UIUserInterfaceSizeClass.regular:
                    sizeClassHeightType = TGSizeClassType.Height.regular
                    break
                default:
                    sizeClassHeightType = TGSizeClassType.Height.any
                }
                
                
                
                switch layoutv.traitCollection.horizontalSizeClass {
                case UIUserInterfaceSizeClass.compact:
                    sizeClassWidthType = TGSizeClassType.Width.compact
                    break
                case UIUserInterfaceSizeClass.regular:
                    sizeClassWidthType = TGSizeClassType.Width.regular
                    break
                default:
                    sizeClassWidthType = TGSizeClassType.Width.any
                }
            }
            
            let devori = UIDevice.current.orientation
            if devori.isPortrait
            {
                sizeClassScreenType = TGSizeClassType.Screen.portrait
            }
            else if devori.isLandscape
            {
                sizeClassScreenType = TGSizeClassType.Screen.landscape
            }
            else
            {
                sizeClassScreenType = TGSizeClassType.Screen.portrait
            }
            
            
            _stgSizeClassType = TGSizeClassType.comb(sizeClassWidthType, sizeClassHeightType, sizeClassScreenType)
        }
        
        return _stgSizeClassType
    }
    
    
    fileprivate func tgRemoveSubviewObserver(subview:UIView)
    {
        if let sbvtgFrame = objc_getAssociatedObject(subview, &ASSOCIATEDOBJECT_KEY_TANGRAMKIT_FRAME) as? TGFrame
        {
            if let sbvsc = sbvtgFrame.sizeClass as? TGViewSizeClassImpl
            {
                sbvsc.layoutCompletedAction = nil
            }
            
            if sbvtgFrame.hasObserver
            {
                subview.removeObserver(self, forKeyPath: "hidden")
                subview.removeObserver(self, forKeyPath: "frame")
                
                if let lv = subview as? TGBaseLayout
                {
                    lv.removeObserver(self, forKeyPath: "center")
                }
                else if let sv = subview as? UIScrollView
                {
                    sv.removeObserver(self, forKeyPath: "center")
                }
                else if let lb = subview as? UILabel
                {
                    lb.removeObserver(self, forKeyPath: "text")
                    lb.removeObserver(self, forKeyPath: "attributedText")
                }
                else
                {
                    
                }
                
                sbvtgFrame.hasObserver = false
            }
            
        }
        
    }
    
    fileprivate func tgAddSubviewObserver(subview:UIView, sbvtgFrame:TGFrame)  {
        
        if !sbvtgFrame.hasObserver
        {
            subview.addObserver(self, forKeyPath:"hidden", options:.new, context: &TGBaseLayout._stgObserverCtxA)
            subview.addObserver(self, forKeyPath:"frame", options:.new, context: &TGBaseLayout._stgObserverCtxA)
            
            if let lv = subview as? TGBaseLayout
            {
                lv.addObserver(self, forKeyPath:"center", options:.new, context: &TGBaseLayout._stgObserverCtxA)
            }
            else if let sv = subview as? UIScrollView
            {
                sv.addObserver(self, forKeyPath:"center", options:.new, context: &TGBaseLayout._stgObserverCtxA)
            }
            else if let lb = subview as? UILabel
            {
                lb.addObserver(self, forKeyPath:"text", options:.new, context: &TGBaseLayout._stgObserverCtxB)
                lb.addObserver(self, forKeyPath:"attributedText", options:.new, context: &TGBaseLayout._stgObserverCtxB)
            }
            else
            {
                
            }
            
            sbvtgFrame.hasObserver = true

        }
        
    }
    
    
    
    fileprivate func tgInvalidateIntrinsicContentSize()
    {
        if !self.translatesAutoresizingMaskIntoConstraints
        {
            let lsc:TGViewSizeClassImpl = self.tgCurrentSizeClass as! TGViewSizeClassImpl
            if lsc.isSomeSizeWrap
            {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    
    
    fileprivate func tgGetSubviewWidthSizeValue(sbv:UIView,
                                                sbvsc:TGViewSizeClassImpl,
                                                lsc:TGLayoutViewSizeClassImpl,
                                                selfSize:CGSize,
                                                paddingTop:CGFloat,
                                                paddingLeading:CGFloat,
                                                paddingBottom:CGFloat,
                                                paddingTrailing:CGFloat,
                                                sbvSize:CGSize) -> CGFloat
    {
    
        let dime = sbvsc.width
        guard dime.hasValue else
        {
            return sbvSize.width
        }
        
        
    var retVal = sbvSize.width
    
    
  
        if let t = dime.numberVal
        {
            retVal = t
        }
        else if let t = dime.sizeVal, t.view !== sbv
        {
            if t === lsc.width.realSize
            {
                retVal = dime.measure(selfSize.width - paddingLeading - paddingTrailing)
            }
            else if t === lsc.height.realSize
            {
                retVal = dime.measure(selfSize.height - paddingTop - paddingBottom)
            }
            else
            {
                if (t.type == TGGravity.horz.fill)
                {
                    retVal = dime.measure(t.view.tgEstimatedWidth)
                }
                else
                {
                    retVal = dime.measure(t.view.tgEstimatedHeight)
                }
            }
        }
        
        return retVal
    }
    
    fileprivate func tgGetSubviewHeightSizeValue(sbv:UIView,
                                                sbvsc:TGViewSizeClassImpl,
                                                lsc:TGLayoutViewSizeClassImpl,
                                                selfSize:CGSize,
                                                paddingTop:CGFloat,
                                                paddingLeading:CGFloat,
                                                paddingBottom:CGFloat,
                                                paddingTrailing:CGFloat,
                                                sbvSize:CGSize) -> CGFloat
    {
        let dime = sbvsc.height
        guard dime.hasValue else
        {
            return sbvSize.height
        }
        
        var retVal = sbvSize.height
        
        if let t = dime.numberVal
        {
            retVal = t
        }
        else if let t = dime.sizeVal, t.view !== sbv
        {
            if t === lsc.width.realSize
            {
                retVal = dime.measure(selfSize.width - paddingLeading - paddingTrailing)
            }
            else if t === lsc.height.realSize
            {
                retVal = dime.measure(selfSize.height - paddingTop - paddingBottom)
            }
            else
            {
                if (t.type == TGGravity.horz.fill)
                {
                    retVal = dime.measure(t.view.tgEstimatedWidth)
                }
                else
                {
                    retVal = dime.measure(t.view.tgEstimatedHeight)
                }
            }
        }
        else if dime.isFlexHeight
        {
            retVal = tgCalcHeightFromHeightWrapView(sbv, sbvsc: sbvsc, width: sbvSize.width)
        }
        
        return retVal
    }
}

//管理触摸事件的代理类。
private class TGTouchEventDelegate
{

    private weak  var _layout:TGBaseLayout!
    
    private weak  var _touchDownTarget:NSObjectProtocol! = nil
    private weak  var _touchUpTarget:NSObjectProtocol! = nil
    private weak  var _touchCancelTarget:NSObjectProtocol! = nil
    private var _touchDownAction:Selector! = nil
    private var _touchUpAction:Selector! = nil
    private var _touchCancelAction:Selector! = nil
    
    private var _hasDoCancel:Bool = false
    private var _oldBackgroundColor:UIColor?=nil
    private var _oldBackgroundImage:UIImage?=nil
    private var _oldAlpha:CGFloat = 1
    
    private var _forbidTouch:Bool = false
    private var _canCallAction:Bool = false
    private var _beginPoint:CGPoint = CGPoint.zero
    
    static  var _HasBegin:Bool = false
    static weak var _CurrentLayout:TGBaseLayout! = nil
    
    init(_ layout: TGBaseLayout) {
        _layout = layout
        TGTouchEventDelegate._CurrentLayout = nil
    }
    
    #if swift(>=4.2)
    
    func setTarget(_ target: NSObjectProtocol?, action: Selector?, for controlEvents: UIControl.Event)
    {
        //just only support these events
        switch controlEvents {
        case UIControl.Event.touchDown:
            _touchDownTarget = target
            _touchDownAction = action
            break
        case UIControl.Event.touchUpInside:
            _touchUpTarget = target
            _touchUpAction = action
            break
        case UIControl.Event.touchCancel:
            _touchCancelTarget = target
            _touchCancelAction = action
            break
        default:
            return
        }

    }
    #else
    
    func setTarget(_ target: NSObjectProtocol?, action: Selector?, for controlEvents: UIControlEvents)
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
    
    #endif
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch:UITouch = (touches as NSSet).anyObject() as! UITouch
        
        if _layout != nil && _touchUpTarget != nil && !_forbidTouch && touch.tapCount == 1 && !TGTouchEventDelegate._HasBegin
        {
            TGTouchEventDelegate._HasBegin = true
            TGTouchEventDelegate._CurrentLayout = _layout
            _canCallAction = true
            _beginPoint =  touch.location(in: _layout)
            
            self.setTouchHighlighted()
            
            _hasDoCancel = false
            _ = _touchDownTarget?.perform(_touchDownAction, with: _layout)
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if _layout != nil && _touchUpTarget != nil && TGTouchEventDelegate._HasBegin && (_layout ===  TGTouchEventDelegate._CurrentLayout || TGTouchEventDelegate._CurrentLayout == nil)
        {
            if _canCallAction
            {
                let touch:UITouch = (touches as NSSet).anyObject() as! UITouch
                
                let pt:CGPoint = touch.location(in: _layout)
                if abs(pt.x - _beginPoint.x) > 2 || abs(pt.y - _beginPoint.y) > 2
                {
                    _canCallAction = false
                    
                    if !_hasDoCancel
                    {
                        _ = _touchCancelTarget?.perform(_touchCancelAction, with: _layout)
                        _hasDoCancel = true
                        
                    }
                    
                }
            }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if _layout != nil &&  _touchUpTarget != nil && TGTouchEventDelegate._HasBegin && (_layout ===  TGTouchEventDelegate._CurrentLayout || TGTouchEventDelegate._CurrentLayout == nil)
        {
            //设置一个延时.
            _forbidTouch = true
            
            let time: TimeInterval = 0.12
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                
                self.doTargetAction((touches as NSSet).anyObject() as! UITouch)
            })
            
            TGTouchEventDelegate._HasBegin = false
            TGTouchEventDelegate._CurrentLayout = nil
        }
        
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if _layout != nil && _touchUpTarget != nil && TGTouchEventDelegate._HasBegin && (_layout ===  TGTouchEventDelegate._CurrentLayout || TGTouchEventDelegate._CurrentLayout == nil)
        {
           
            self.resetTouchHighlighted()
            
            TGTouchEventDelegate._HasBegin = false
            TGTouchEventDelegate._CurrentLayout = nil

            if !_hasDoCancel
            {
                _ = _touchCancelTarget?.perform(_touchCancelAction, with: _layout)
                _hasDoCancel = true
                
            }
            
        }
        
    }

    func doTargetAction(_ touch:UITouch)
    {
        if _layout != nil
        {
            self.resetTouchHighlighted()
            
            //距离太远则不会处理
            let pt:CGPoint = touch.location(in: _layout)
            if _touchUpTarget != nil && _touchUpAction != nil && _canCallAction && _layout.bounds.contains(pt)
            {
                _ = _touchUpTarget?.perform(_touchUpAction, with: _layout)
            }
            else
            {
                if !_hasDoCancel
                {
                    _ = _touchCancelTarget?.perform(_touchCancelAction, with: _layout)
                    _hasDoCancel = true
                }
            }
            
            _forbidTouch = false
        }
        
    }

    

    //private method
    private func setTouchHighlighted()
    {
        if _layout.tg_highlightedOpacity != 0
        {
            _oldAlpha = _layout.alpha
            _layout.alpha = 1 - _layout.tg_highlightedOpacity
        }
        
        if _layout.tg_highlightedBackgroundColor != nil
        {
            _oldBackgroundColor = _layout.backgroundColor
            _layout.backgroundColor = _layout.tg_highlightedBackgroundColor
        }
        
        if _layout.tg_highlightedBackgroundImage != nil
        {
            _oldBackgroundImage = _layout.tg_backgroundImage;
            _layout.tg_backgroundImage = _layout.tg_highlightedBackgroundImage
        }

    }
    
    private func resetTouchHighlighted()
    {
        if _layout.tg_highlightedOpacity != 0
        {
            _layout.alpha = _oldAlpha
            _oldAlpha = 1
        }
        
        if _layout.tg_highlightedBackgroundColor != nil
        {
            _layout.backgroundColor = _oldBackgroundColor
            _oldBackgroundColor = nil
        }
        
        if  _layout.tg_highlightedBackgroundImage != nil
        {
            _layout.tg_backgroundImage = _oldBackgroundImage
            _oldBackgroundImage = nil
        }

    }
    
}


class TGBorderlineLayerDelegate:NSObject,CALayerDelegate
{
     private var _layoutRect:CGRect! = nil
     private weak var _layoutLayer:CALayer!
     private weak var _topBorderlineLayer:CAShapeLayer! = nil
     private weak var _leadingBorderlineLayer:CAShapeLayer! = nil
     private weak var _bottomBorderlineLayer:CAShapeLayer! = nil
     private weak var _trailingBorderlineLayer:CAShapeLayer! = nil
    
    
    convenience init(_ layoutLayer:CALayer) {
        self.init()

        _layoutLayer = layoutLayer
    }
    
    deinit {
        
    }
    
    var topBorderline:TGBorderline!
    {
        didSet
        {
            if self.topBorderline !== oldValue
            {
                _topBorderlineLayer = self.updateBorderLayer(_topBorderlineLayer, borderline: self.topBorderline)
            }
            
        }
    }
    
    /**设置布局视图的头部边界线对象，默认是nil。*/
    var leadingBorderline:TGBorderline!
    {
        didSet
        {
            if self.leadingBorderline !== oldValue
            {
                _leadingBorderlineLayer = self.updateBorderLayer(_leadingBorderlineLayer, borderline: self.leadingBorderline)
            }
        }
    }
    
    /**设置布局视图的底部边界线对象，默认是nil。*/
    var bottomBorderline:TGBorderline!
    {
        didSet
        {
            if self.bottomBorderline !== oldValue
            {
                _bottomBorderlineLayer = self.updateBorderLayer(_bottomBorderlineLayer, borderline: self.bottomBorderline)
            }
        }
    }
    
    /**设置布局视图的尾部边界线对象，默认是nil。*/
    var trailingBorderline:TGBorderline!
    {
        
        didSet
        {
            
            if self.trailingBorderline !== oldValue
            {
                _trailingBorderlineLayer = self.updateBorderLayer(_trailingBorderlineLayer, borderline:self.trailingBorderline)
            }
            
        }
    }
    
    
    
    /**设置布局视图的左边边界线对象，默认是nil。*/
    var leftBorderline:TGBorderline!
    {
        get
        {
            if TGBaseLayout.tg_isRTL
            {
                return self.trailingBorderline
            }
            else
            {
                return self.leadingBorderline
            }
        }
        set
        {
            if TGBaseLayout.tg_isRTL
            {
                self.trailingBorderline = newValue
            }
            else
            {
                self.leadingBorderline = newValue
            }
        }
        
    }
    
    /**设置布局视图的右边边界线对象，默认是nil。*/
    var rightBorderline:TGBorderline!
    {
        
        get
        {
            if TGBaseLayout.tg_isRTL
            {
                return self.leadingBorderline
            }
            else
            {
                return self.trailingBorderline
            }
        }
        set
        {
            if TGBaseLayout.tg_isRTL
            {
                self.leadingBorderline = newValue
            }
            else
            {
                self.trailingBorderline = newValue
            }
        }
        
    }
    
    func setNeedsLayout(_ layoutRect:CGRect!)
    {
        _layoutRect = layoutRect
        if _topBorderlineLayer != nil
        {
            _topBorderlineLayer.setNeedsLayout()
        }
        
        if _leadingBorderlineLayer != nil
        {
            _leadingBorderlineLayer.setNeedsLayout()

        }
        
        if _bottomBorderlineLayer != nil
        {
            _bottomBorderlineLayer.setNeedsLayout()
        }
        
        if _trailingBorderlineLayer != nil
        {
            _trailingBorderlineLayer.setNeedsLayout()
        }

    }
    
    func layoutSublayers(of layer: CALayer)
    {
        if _layoutLayer == nil || _layoutRect == nil
        {
            return
        }
        
        let layoutSize:CGSize = _layoutRect.size
        let layoutPoint:CGPoint = _layoutRect.origin
        if layoutSize.height == 0 || layoutSize.width == 0
        {
            return
        }
        
        var layerRect:CGRect
        var fromPoint:CGPoint
        var toPoint:CGPoint
        let scale = UIScreen.main.scale
        
        if _leadingBorderlineLayer != nil && layer === _leadingBorderlineLayer
        {
            layerRect = CGRect(x: leadingBorderline.offset + layoutPoint.x,
                               y: leadingBorderline.headIndent + layoutPoint.y,
                               width: leadingBorderline.thick/scale,
                               height: layoutSize.height - leadingBorderline.headIndent - leadingBorderline.tailIndent);
            fromPoint = CGPoint(x: 0, y: 0);
            toPoint = CGPoint(x: 0, y: layerRect.size.height);
            
        }
        else if _trailingBorderlineLayer != nil && layer === _trailingBorderlineLayer
        {
            layerRect = CGRect(x: layoutSize.width - trailingBorderline.thick / scale - trailingBorderline.offset + layoutPoint.x,
                               y: trailingBorderline.headIndent + layoutPoint.y,
                               width: trailingBorderline.thick / scale,
                               height: layoutSize.height - trailingBorderline.headIndent - trailingBorderline.tailIndent);
            fromPoint = CGPoint(x: 0, y: 0);
            toPoint = CGPoint(x: 0, y: layerRect.size.height);
            
        }
        else if _topBorderlineLayer != nil && layer === _topBorderlineLayer
        {
            layerRect = CGRect(x: topBorderline.headIndent + layoutPoint.x,
                               y: topBorderline.offset + layoutPoint.y,
                               width: layoutSize.width - topBorderline.headIndent - topBorderline.tailIndent,
                               height: topBorderline.thick/scale);
            fromPoint = CGPoint(x: 0, y: 0);
            toPoint = CGPoint(x: layerRect.size.width, y: 0);
        }
        else if _bottomBorderlineLayer != nil && layer === _bottomBorderlineLayer
        {
            layerRect = CGRect(x:bottomBorderline.headIndent + layoutPoint.x,
                               y: layoutSize.height - bottomBorderline.thick/scale - bottomBorderline.offset + layoutPoint.y,
                               width: layoutSize.width - bottomBorderline.headIndent - bottomBorderline.tailIndent,
                               height: bottomBorderline.thick / scale);
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
        
        if TGBaseLayout.tg_isRTL
        {
            layerRect.origin.x = layoutSize.width - layerRect.origin.x - layerRect.size.width;
        }
        
        
        //把动画效果取消。
        if !_tgCGRectEqual(layer.frame, layerRect)
        {
            
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
        }
        
    }
    
    
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
    
    
    fileprivate func updateBorderLayer(_ layer:CAShapeLayer!, borderline:TGBorderline!) ->CAShapeLayer!
    {
        var retLayer:CAShapeLayer! = layer
        
        if borderline == nil
        {
            if retLayer != nil
            {
                retLayer.removeFromSuperlayer()
                retLayer.delegate = nil
            }
            
            retLayer = nil
            
        }
        else
        {
            
            if retLayer == nil
            {
                retLayer = CAShapeLayer()
                retLayer.zPosition = 10000
                retLayer.delegate = self
                _layoutLayer.addSublayer(retLayer!)
            }
            
            if borderline.dash != 0
            {
                retLayer.lineDashPhase = borderline.dash / 2
                retLayer.lineDashPattern = [NSNumber(value:Double(borderline.dash)), NSNumber(value:Double(borderline.dash))]
                retLayer.strokeColor = borderline.color.cgColor
                retLayer.lineWidth = borderline.thick
                retLayer.backgroundColor = nil
            }
            else
            {
                retLayer.lineDashPhase = 0
                retLayer.lineDashPattern = nil
                retLayer.strokeColor = nil
                retLayer.lineWidth = 0
                retLayer.backgroundColor = borderline.color.cgColor
            }
            
            retLayer.setNeedsLayout()
        }
        
        return retLayer
    }
    
    fileprivate func updateAllBorderlineColor(){
        updateBorderlineColorHelper(_topBorderlineLayer, borderline:self.topBorderline)
        updateBorderlineColorHelper(_bottomBorderlineLayer, borderline:self.bottomBorderline)
        updateBorderlineColorHelper(_leadingBorderlineLayer, borderline:self.leadingBorderline)
        updateBorderlineColorHelper(_trailingBorderlineLayer, borderline:self.trailingBorderline)
    }
    
    private func updateBorderlineColorHelper(_ layer:CAShapeLayer!, borderline:TGBorderline!){
        
        guard layer != nil && borderline != nil else{return}
        
        if borderline.dash != 0.0 {
            layer.strokeColor = borderline.color.cgColor
        }else{
            layer.backgroundColor = borderline.color.cgColor
        }
    }
    
}


private var ASSOCIATEDOBJECT_KEY_TANGRAMKIT_FRAME = "ASSOCIATEDOBJECT_KEY_TANGRAMKIT_FRAME"


internal class TGFrame {
    
    var top:CGFloat = CGFloat.greatestFiniteMagnitude
    var leading:CGFloat = CGFloat.greatestFiniteMagnitude
    var bottom:CGFloat = CGFloat.greatestFiniteMagnitude
    var trailing:CGFloat = CGFloat.greatestFiniteMagnitude
    var width:CGFloat = CGFloat.greatestFiniteMagnitude
    var height:CGFloat = CGFloat.greatestFiniteMagnitude
    var hasObserver:Bool = false
    
    weak var sizeClass:TGViewSizeClass! = nil
    
    var multiple:Bool
        {
            if sizeClasses == nil
            {
                return false
        }
        else
            {
                return sizeClasses.count > 1
        }
    }
    
    var sizeClasses:NSMutableDictionary! = nil
    
    
    func reset()
    {
        self.top = CGFloat.greatestFiniteMagnitude
        self.leading = CGFloat.greatestFiniteMagnitude
        self.bottom = CGFloat.greatestFiniteMagnitude
        self.trailing = CGFloat.greatestFiniteMagnitude
        self.width = CGFloat.greatestFiniteMagnitude
        self.height = CGFloat.greatestFiniteMagnitude
    }
    
    
    var frame:CGRect
        {
        get
        {
            return CGRect(x: leading, y: top, width: width, height: height)
        }
        set
        {
            top = newValue.origin.y
            leading = newValue.origin.x
            width = newValue.size.width
            height = newValue.size.height
            bottom = top + height
            trailing = leading + width
        }
    }
    
}



extension UIView
{
    
    internal var tgFrame:TGFrame
    {
        var obj:Any? = objc_getAssociatedObject(self, &ASSOCIATEDOBJECT_KEY_TANGRAMKIT_FRAME)
        if obj == nil
        {
            obj = TGFrame()
            
            objc_setAssociatedObject(self,&ASSOCIATEDOBJECT_KEY_TANGRAMKIT_FRAME, obj!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
        case TGSizeClassType.comb(let width, let height, let screen):
            switch width {
            case TGSizeClassType.Width.compact:
                retInt |= 1
                break
            case TGSizeClassType.Width.regular:
                retInt |= 2
                break
            default:
                retInt |= 0
                break
            }
            
            switch height {
            case TGSizeClassType.Height.compact:
                retInt |= 4
                break
            case TGSizeClassType.Height.regular:
                retInt |= 8
                break
            default:
                retInt |= 0
            }
            if screen != nil
            {
                switch screen! {
                case TGSizeClassType.Screen.portrait:
                    retInt |= 64
                    break
                case TGSizeClassType.Screen.landscape:
                    retInt |= 128
                    break
                }
            }
            break
        case TGSizeClassType.portrait:
            retInt = 64
            break
        case TGSizeClassType.landscape:
            retInt = 128
            break
        default:
            break
        }
        
        return retInt;
    }
    
    
    
    fileprivate var tgDefaultSizeClass:TGViewSizeClass
    {
        return tgMatchBestSizeClass(TGSizeClassType.default)
    }
    
    internal func tgMatchBestSizeClass(_ type:TGSizeClassType) ->TGViewSizeClass
    {
        var wsc = 0
        var hsc = 0
        var ori = 0
        let typeInt = self.tgIntFromSizeClassType(type)
        
        let tgFrame = self.tgFrame
        if tgFrame.sizeClasses == nil
        {
            tgFrame.sizeClasses = NSMutableDictionary()
        }
        
        if #available(iOS 8.0, *)
        {
            switch type {
            case TGSizeClassType.comb(let width, let height, let screen):
                switch width {
                case TGSizeClassType.Width.compact:
                    wsc  = 1
                    break
                case TGSizeClassType.Width.regular:
                    wsc = 2
                    break
                default:
                    break
                }
                
                switch height {
                case TGSizeClassType.Height.compact:
                    hsc = 4
                    break
                case TGSizeClassType.Height.regular:
                    hsc = 8
                    break
                default:
                    break
                }
                if screen != nil
                {
                    switch screen! {
                    case TGSizeClassType.Screen.portrait:
                        ori = 64
                        break
                    case TGSizeClassType.Screen.landscape:
                        ori = 128
                        break
                    }
                }
                break
            case TGSizeClassType.portrait:
                ori = 64
                break
            case TGSizeClassType.landscape:
                ori = 128
                break
            default:
                break
            }
        }
        
        var searchTypeInt:Int = wsc | hsc | ori
        var sizeClass:TGViewSizeClass! = nil
        
        if tgFrame.multiple
        {
            sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
            if sizeClass != nil
            {
                return sizeClass!
            }
            
            searchTypeInt = wsc | hsc
            if (searchTypeInt != typeInt)
            {
                sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
                if sizeClass != nil
                {
                    return sizeClass!
                }
            }
            
            
            searchTypeInt =  hsc | ori
            if ori != 0 && searchTypeInt != typeInt
            {
                sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
                if sizeClass != nil
                {
                    return sizeClass!
                }
            }
            
            searchTypeInt =  hsc;
            if searchTypeInt != typeInt
            {
                sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
                if sizeClass != nil
                {
                    return sizeClass!
                }
            }
            
            searchTypeInt = wsc | ori
            if ori != 0 && searchTypeInt != typeInt
            {
                sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
                if sizeClass != nil
                {
                    return sizeClass!
                }
            }
            
            searchTypeInt = wsc
            if searchTypeInt != typeInt
            {
                sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
                if sizeClass != nil
                {
                    return sizeClass!
                }
            }
            
            searchTypeInt = ori
            if ori != 0 && searchTypeInt != typeInt
            {
                sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
                if sizeClass != nil
                {
                    return sizeClass!
                }
            }
            
        }
        
        searchTypeInt = 0
        sizeClass = tgFrame.sizeClasses.object(forKey: searchTypeInt) as? TGViewSizeClass
        if (sizeClass == nil)
        {
            sizeClass = (self.tgCreateInstance() as! TGViewSizeClass)
            tgFrame.sizeClasses.setObject(sizeClass!, forKey: searchTypeInt as NSCopying)
        }
        
        return sizeClass!
        
    }
    
    
    internal var tgCurrentSizeClass:TGViewSizeClass
    {
        let tgFrame = self.tgFrame
        if tgFrame.sizeClass == nil
        {
            tgFrame.sizeClass = self.tgDefaultSizeClass
        }
        
        return tgFrame.sizeClass
    }
    
    internal var tgEstimatedWidth:CGFloat
    {
        guard let _ = self.superview as? TGBaseLayout else {
            return self.bounds.width
        }
        
        let tgFrame = self.tgFrame
        if tgFrame.width == CGFloat.greatestFiniteMagnitude{
            return self.bounds.width
        }else{
            return tgFrame.width
        }
    }
    
    internal var tgEstimatedHeight:CGFloat
    {
        guard let _ = self.superview as? TGBaseLayout else {
            return self.bounds.height
        }
        
        let tgFrame = self.tgFrame
        if tgFrame.height == CGFloat.greatestFiniteMagnitude{
            return self.bounds.height
        }else{
            return tgFrame.height
        }
    }
    
    @objc func tgCreateInstance() -> AnyObject
    {
        return TGViewSizeClassImpl(view:self)
    }
    
}

extension UIWindow
{
    fileprivate func tgUpdateRTL(_ isRTL:Bool)
    {
        TGBaseLayout.tg_isRTL = isRTL
        self.tgSetNeedLayoutAllSubviews(self)
    }
    
    fileprivate func tgSetNeedLayoutAllSubviews(_ v:UIView)
    {
        for sv:UIView in v.subviews
        {
            if let t = sv as? TGBaseLayout
            {
                t.setNeedsLayout()
            }
            
            tgSetNeedLayoutAllSubviews(sv)
        }
    }
}


internal func _tgCGFloatErrorEqual(_ f1:CGFloat, _ f2:CGFloat, _ error:CGFloat) -> Bool
{
   return abs(f1 - f2) < error
}

internal func _tgCGFloatErrorNotEqual(_ f1:CGFloat, _ f2:CGFloat, _ error:CGFloat) -> Bool
{
    return abs(f1 - f2) > error
}


internal func _tgCGFloatEqual(_ f1:CGFloat, _ f2:CGFloat) -> Bool
{
    
    if CGFloat.NativeType.self == Double.self
    {
        return abs(f1 - f2) < 1e-7
        
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
        return abs(f1 - f2) > 1e-7
    }
    else
    {
        return abs(f1 - f2) > 1e-4
    }
}

internal func _tgCGFloatLess(_ f1:CGFloat, _ f2:CGFloat) ->Bool
{
    if CGFloat.NativeType.self == Double.self
    {
        return f2 - f1 > 1e-7
    }
    else
    {
        return f2 - f1 > 1e-4
    }

}

internal func _tgCGFloatGreat(_ f1:CGFloat, _ f2:CGFloat) ->Bool
{
    if CGFloat.NativeType.self == Double.self
    {
        return f1 - f2 > 1e-7
    }
    else
    {
        return f1 - f2 > 1e-4
    }
}

internal func _tgCGFloatLessOrEqual(_ f1:CGFloat, _ f2:CGFloat) -> Bool
{
    if CGFloat.NativeType.self == Double.self
    {
        return f1 < f2 || abs(f1 - f2) < 1e-7
    }
    else
    {
        return f1 < f2 || abs(f1 - f2) < 1e-7
        
    }
}

internal func _tgCGFloatGreatOrEqual(_ f1:CGFloat, _ f2:CGFloat) -> Bool
{
    if CGFloat.NativeType.self == Double.self
    {
        return f1 > f2 || abs(f1 - f2) < 1e-7
    }
    else
    {
        return f1 > f2 || abs(f1 - f2) < 1e-7
        
    }
    
}

internal func _tgCGSizeEqual(_ sz1:CGSize, _ sz2:CGSize) ->Bool
{
    return _tgCGFloatEqual(sz1.width, sz2.width) && _tgCGFloatEqual(sz1.height, sz2.height)
}

internal func _tgCGPointEqual(_ pt1:CGPoint, _ pt2:CGPoint) ->Bool
{
    return _tgCGFloatEqual(pt1.x, pt2.x) && _tgCGFloatEqual(pt1.y, pt2.y)
}

internal func _tgCGRectEqual(_ rect1:CGRect, _ rect2:CGRect) ->Bool
{
    return _tgCGSizeEqual(rect1.size, rect2.size) && _tgCGPointEqual(rect1.origin, rect2.origin)
}

let _tgrScale = UIScreen.main.scale
let _tgrSizeError = 1.0 / _tgrScale + 0.0001

internal func _tgRoundNumber(_ f :CGFloat) ->CGFloat
{
    guard f != 0 && f != CGFloat.greatestFiniteMagnitude && f != -CGFloat.greatestFiniteMagnitude  else
    {
        return f
    }
    
    
    //按精度四舍五入
    //正确的算法应该是。x = 0; y = 0;  0<x<0.5 y = 0;   x = 0.5 y = 0.5;  0.5<x<1 y = 0.5; x=1 y = 1;
    
    if (f < 0)
    {
        return ceil(fma(f, _tgrScale, -0.5)) / _tgrScale
    }
    else
    {
        return floor(fma(f, _tgrScale, 0.5)) / _tgrScale
    }
    
}

internal func _tgRoundRectForLayout(_ rect:CGRect) ->CGRect
{
    let  x1 = rect.origin.x
    let  y1 = rect.origin.y
    let  w1 = rect.size.width
    let  h1 = rect.size.height
    
    var rect = rect
    
    rect.origin.x =  _tgRoundNumber(x1)
    rect.origin.y = _tgRoundNumber(y1)
    
    let mx = _tgRoundNumber(x1 + w1)
    let my = _tgRoundNumber(y1 + h1)
    
    rect.size.width = mx - rect.origin.x
    rect.size.height = my - rect.origin.y
    
    return rect;

}

internal func _tgRoundRect(_ rect:CGRect) ->CGRect
{
    var rect = rect
    
    rect.origin.x = _tgRoundNumber(rect.origin.x)
    rect.origin.y = _tgRoundNumber(rect.origin.y)
    rect.size.width = _tgRoundNumber(rect.size.width)
    rect.size.height = _tgRoundNumber(rect.size.height)
    
    return rect
}

internal func _tgRoundSize(_ size:CGSize) ->CGSize
{
    var size = size
    size.width = _tgRoundNumber(size.width)
    size.height = _tgRoundNumber(size.height)
    return size
}

internal func _tgRoundPoint(_ point:CGPoint) ->CGPoint
{
    var point = point
    point.x = _tgRoundNumber(point.x)
    point.y = _tgRoundNumber(point.y)
    
    return point
}



