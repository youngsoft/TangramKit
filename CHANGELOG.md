#Change Log
**TangramKit**中的所有历史版本变化将会在这个文件中列出。

--- 

##[1.0.4](https://github.com/youngsoft/TangramKit/releases/tag/1.0.4)(2017/03/05)

#### Added
1. 布局视图添加了新方法`func tg_estimatedFrame(of subview:UIView, inLayoutSize size:CGSize = .zero) -> CGRect`用来评估一个将要加入布局视图的子视图的frame值。这个方法通常用来实现一些子视图在布局视图之间移动的动画效果的能力。具体例子参（DEMO:AllTest4ViewController）
2. 线性布局`TGLinearLayout`中的`tg_shrinkType`中添加了一个可设置的值`.auto` 这个值的目的是为了解决水平线性布局里面当有左右2个子视图的宽度都不确定，但又不希望2个子视图不能重叠展示的问题。具体例子参见（DEMO:AllTest7ViewController 中的第4个例子）。
3. 布局视图添加了属性`tg_zeroPadding`用来描述当布局视图的尺寸由子视图决定，并且当布局视图中没有任何子视图时设置的padding值是否会参与布局视图尺寸的计算。默认是YES，当设置为NO时则当布局视图没有子视图时padding是不会参与布局视图尺寸的计算的。具体例子参见 （DEMO: LLTest4ViewController）
4. 添加了对非布局父视图的高度和宽度的.wrap设置支持，这样非布局父视图就可以实现高度和宽度由里面的子布局视图来决定。具体例子参见（DEMO: LLTest4ViewController）。 
5. 添加了对UIButton的宽度固定情况下高度自自适应的支持。

####Changed
1. 优化了当将一个布局视图作为视图控制器的根视图时(self.view)的一些属性设置可能导致约束冲突，和可能导致将控制器中的视图加入到一个滚动视图时无法滚动的问题。
2. 将线性布局`TGLinearLayout`中的tg_shrinkType属性的默认值由原来的`.average`改为了`.none`，也就是默认是不压缩的。
3. 修正了相对布局中的子视图设置`tg_useFrame`为YES时，子视图无法自由控制自己的frame的问题。
4. 优化了所有类以及方法和属性以及各种类型的注释，注释更加清晰明了。同时优化了所有DEMO中的注释信息。
5. 修正了将一个布局视图添加到非布局视图里面后，如果后续调整了布局视图的边界设置后无法更新布局视图尺寸的问题。




##[1.0.3](https://github.com/youngsoft/TangramKit/releases/tag/1.0.3)(2017/1/21)

1. 流式布局`TGFlowLayout`添加了对分页滚动的支持，通过新增加的属性`tg_pagedCount`来实现，这个属性只支持数量约束流式布局。`tg_pagedCount`和`tg_width以及tg_height 设置为.wrap`配合使用能够实现各种方向上的分页滚动效果(具体见DEMO：FLLTest5ViewController)
2. 线性布局`TGLinearLayout`中完全支持了所有子视图的高度等于宽度的设置的功能，以及在水平线性布局中添加了子宽度等于高度的功能。
3. 流式布局`TGFlowLayout`中的子视图的tg_width,tg_height中可设置的相对类型尺寸的值的维多扩宽，不仅可以依赖兄弟视图，父视图，甚至还可以依赖别的任意的视图。
4. 修复将布局视图加入到非布局父视图时当计算出视图的尺寸为小于0时，而又将这个尺寸用来设置视图的bounds属性的尺寸时会调整bounds的origin部分而产生的BUG。具体展示是视图的位置产生了不正确的错误。
5. 修复了流式布局`TGFlowLayout`中的数量约束水平流式布局的高度`tg_height`设置为`.wrap`的错误计算的BUG。
6. 修复[BUG#7](https://github.com/youngsoft/TangramKit/issues/7)。这个BUG是因为以前认为宽度是wrap高度是特定值是不可能的情况！！其实是有可能的。






##[1.0.2](https://github.com/youngsoft/TangramKit/releases/tag/1.0.2)(2016/12/28)

1. 布局位置类`TGLayoutPos`和布局尺寸类`TGLayoutSize`类中添加了新属性：`isActive`.用来描述指定的位置或者尺寸所设置的约束是否有效。
2. 添加了Demo:ALLTest8ViewController这个例子专门用来演示把一个布局视图加入到非布局父视图时的使用方法。
3. 修正了将一个具有`wrap`尺寸的布局视图加入到非布局父视图时，且又设置tg_centerX，tg_centerY,tg_right,tg_bottom来定位布局视图时无法正确定位布局视图位置的BUG。
4. 修改了将布局视图加入`UIScrollView`时会自动调整`UIScrollView`的`contentSize`的机制，新的机制中布局视图设置的`TGLayoutPos`边距值也会算到contentSize里面去。比如某个布局的高度是100，其中的myTopMargin = 10, 那么当将布局视图加入到UIScrollView时他的contentSize的高度则是110.
5. 修复了布局尺寸高度评估方法`tg_sizeThatFits`计算有可能不正确的[BUG#6](https://github.com/youngsoft/TangramKit/issues/6)。
6. 修复了线性布局TGLinearLayout的均分视图方法`tg_equalizeSubviews`的[BUG#5](https://github.com/youngsoft/TangramKit/issues/5)。

##[1.0.1](https://github.com/youngsoft/TangramKit/releases/tag/1.0.1)
1. 实现对Pods的支持和对Carthage的支持。
2. 优化了目录结构

## 1.0.0

1. 实现7大布局库和对SizeClass的支持。  

