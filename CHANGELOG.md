#Change Log
**TangramKit**中的所有历史版本变化将会在这个文件中列出。

--- 

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

