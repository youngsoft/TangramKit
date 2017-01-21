#Change Log
**TangramKit**中的所有历史版本变化将会在这个文件中列出。

--- 

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

