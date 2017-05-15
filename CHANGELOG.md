# Change Log
**TangramKit**中的所有历史版本变化将会在这个文件中列出。

--- 


## [V1.0.6](https://github.com/youngsoft/TangramKit/releases/tag/1.0.6)(2017/5/15)

#### Added
1. 添加了对阿拉伯国家的从右往左方向布局的功能[#issue33](https://github.com/youngsoft/MyLinearLayout/issues/33)。系统提供了一个类属性：`tg_isRTL`来实现对RTL布局的支持。同时为了支持RTL系统增加了UIView的扩展属性：`tg_leading, tg_trailing`用来实现头部和尾部的方向，TGBaseLayout则添加了`tg_leadingPadding,tg_trailingPadding`用来实现内边距的RTL支持。而边界线则增加了`tg_leadingBorderline, tg_trailingBorderline`属性来支持RTL。同时新增了`TGGravity.horz.leading,TGGravity.horz.trailing`两个停靠属性。下面的表格是介绍这些属性的意义。

所属类名|新属性|等价于LRT方向布局|等价于RTL布局方向
-------|---------------|---------------|------------
UIView(extension)|tg_leading|tg_left|tg_right
UIView(extension)|tg_trailing|tg_right|tg_left
TGBaseLayout|tg_leadingPadding|tg_leftPadding|tg_rightPadding
TGBaseLayout|tg_trailingPadding|tg_rightPadding|tg_leftPadding
TGBaseLayout|t_leadingBorderline|tg_leftBorderline|tg_rightBorderline
TGBaseLayout|tg_trailingBorderline|tg_rightBorderline|tg_leftBorderline
TGGravity|TGGravity.horz.leading|TGGravity.horz.left|TGGravity.horz.right
TGGravity|TGGravity.horz.trailing|TGGravity.horz.right|TGGravity.horz.left

如果您的界面布局不需要考虑RTL以及对阿拉伯国际的支持则不需要使用上述新添加的属性。


2. 实现了对UILabel的`text`和`attributedText`进行设置后自动布局的功能，老版本的代码中每次设置完毕text值后要调用一下sizeToFit来激发布局，新版本自动添加了这个功能，使得不需要明确调用sizeToFit了。但是这样的前提是您必须对UILabel设置了tg_width为.wrap或者tg_height为.wrap。
3. 对布局类添加新属性`cacheEstimatedRect`，这个属性用来和高度自实用的UITableViewCell结合使用能大幅度的提供布局计算的性能。这个属性提供了缓存一次尺寸评估的机制，使得当存在有复用的cell时减少布局的计算。 具体例子参考(DEMO:AllTest1TableViewCell)
4. TGLayoutPos对象的equalTo方法的val值新增加了对id<UILayoutSupport>对象的支持，比如tg_top可以等于视图控制器的topLayoutGuide属性，tg_bottom可以等于视图控制器的bottomLayoutGuide属性，这样就可以使得某个布局视图下的子视图的位置不会延生到导航条下面去。具体请参考DEMO:LLTest1ViewController。
5. 对边界线类`TGBorderline`增加属性`offset`可以实现边界线绘制的偏移位置，而不是默认的在视图的边界上。

#### Fixed
1. 修复了将一个布局视图加入到SB或者XIB上时同时设置了四周边距而不起作用的[#BUG36](https://github.com/youngsoft/MyLinearLayout/issues/36)。具体解决的方法是实现了TGBaseLayout的awakeFromNib方法，然后在里面更新了布局。
2. 修复了框架布局`TGFrameLayout`和相对布局`TGRelativeLayout`中尺寸为.wrap时可能计算错误的BUG。

#### Changed
1.  为了和[TangramKit](https://github.com/youngsoft/TangramKit)库保持一致，对一些名字进行了统一的定义。下面表格列出了新旧名称的定义变化。

所属类名|新定义|老定义|
------------|---------------|---------------
TGBorderline|TGBorderline|TGLayoutBorderline

如果您要替换掉所有老方法和属性(建议替换)，则您可以按照如下步骤来完成代码的替换工作：
 
 			1. 查找所有：TGLayoutBorderline  并替换为TGBorderline  (选择Containning, 查找后选择preview，然后把除TangramKit库之外的其他都替换掉）
 			

2. 新版本优化了布局库的子视图构建性能和布局性能。下面表格是新旧版本各布局视图内单个子视图在iPhone6真机设备下的构建和布局时长值(单位是毫秒ms)

create time|1.3.6|1.3.5|提升%|layout time|1.3.6|1.3.5|提升%
-------|---|---|----|----|----|-------|--------
TGLinearLayout|0.164|0.211|28%||0.049|0.160|226%
TGFrameLayout|0.149|0.212|42%||0.042|0.142|234%
TGRelativeLayout|0.182|0.215|18%||0.068|0.137|101%
TGFlowLayout|0.107|0.146|37%||0.036|0.111|210%
TGFloatLayout|0.148|0.147|-0.48%||0.055|0.117|113%
TGTableLayout\*|||
TGPathLayout\*|||

	这里没有提供表格布局和路径布局数据是因为表格布局就是一种线性套线性的线性布局，路径布局则没有进行多少优化。下面的一个表格则是单个视图分别在MyLayout,frame,AutoLayout,Masonry,UIStackView5种布局体系下的构建和布局时长对比值。
	
create time|Frame|TangramKit|AutoLayout|Masonry|UIStackView	
-------|-----|------|---------|----------|-----
TGLinearLayout|0.08|0.164|0.219|0.304|0.131
TGFrameLayout|0.05|0.149|0.209|0.273|0.131
TGRelativeLayout|0.079|0.182|0.116|0.359|0.131
TGFlowLayout|0.08|0.107|0.198|0.258|0.131
TGFloatLayout|0.044|0.148|0.203|0.250|0.131



layout time |Frame|TangramKit|AutoLayout|Masonry|UIStackView	
-------|-----|-------|--------|--------|-------
TGLinearLayout|0|0.049|0.269|0.269|0.272
TGFrameLayout|0|0.042|0.243|0.243|0.272
TGRelativeLayout|0|0.068|0.274|0.274|0.272
TGFlowLayout|0|0.036|0.279|0.279|0.272
TGFloatLayout|0|0.055|0.208|0.208|0.272

  从上面的表格中我们得出如下结论[issue#25](https://github.com/youngsoft/MyLinearLayout/issues/25)：
 
 1. 用frame构建视图用时最少，平均每个视图花费0.068ms。当视图的frame指定后就不再需要布局视图了，所以布局时间几乎是0。
  2. 当用AutoLayout进行布局时每个子视图的平均构建时长约为0.189ms，而Masonry因为是对AutoLayout的封装所以平均构建时长约为0.289ms。在布局时则因为都是使用了AutoLayout所以是相等的，大概花费0.255ms左右。
  3. TangramKit的实现因为是对frame的封装，所以无论是构建时长和布局时长都要优于AutoLayout，但低于原始的frame方法。TangramKit的平均构建时长约0.150ms，比frame构建要多花费2.2倍的时间；而AutoLayout的平均构建时长是TangramKit的1.26倍；Masonry的平均构建时长则是TangramKit的1.9倍。
  4. TangramKit的平均布局时长是0.05ms, 而AutoLayout的布局时长则是TangramKit的5倍。
  5. UIStackView的构建时长要稍微优于TangramKit的线性布局TGLinearLayout.但是布局时长则是TGLinearLayout的5.5倍。
  6. TangramKit中流式布局TGFlowLayout的构建时长和布局时长最小，而相对布局的构建和布局时长最长。



## [1.0.5](https://github.com/youngsoft/TangramKit/releases/tag/1.0.5)(2017/04/16)


#### Added
1. 线性布局`TGLinearLayout`中的`tg_shrinkType`属性增加了对`TGSubviewsShrink.space`枚举的支持，也就是可以支持当子视图的尺寸大于布局的尺寸时会自动压缩子视图之间的间距。具体例子参见（DEMO:AllTest7ViewController）中最后一个小例子。

#### Fixed
1. 修复了数量约束流式布局`TGFlowLayout`中当最后一行的数量等于每行的数量时无法拉伸间距的BUG。


#### Changed
1.  大大优化了布局库里面布局位置对象和布局尺寸的内存占用问题，将原来的每个视图都会建立18个布局位置对象和6个布局尺寸对象变化为了只按需要才建立，也就是只有用到了某个位置和某个尺寸才会建立的懒加载模式，这样减少了将近10倍的对象数量的创建，同时还优化了性能和布局的速度：比如屏幕旋转，sizeclass类型的获取，以及布局扩展属性的获取都进行优化处理。

## [1.0.4](https://github.com/youngsoft/TangramKit/releases/tag/1.0.4)(2017/03/05)

#### Added
1. 布局视图添加了新方法`func tg_estimatedFrame(of subview:UIView, inLayoutSize size:CGSize = .zero) -> CGRect`用来评估一个将要加入布局视图的子视图的frame值。这个方法通常用来实现一些子视图在布局视图之间移动的动画效果的能力。具体例子参（DEMO:AllTest4ViewController）
2. 线性布局`TGLinearLayout`中的`tg_shrinkType`中添加了一个可设置的值`.auto` 这个值的目的是为了解决水平线性布局里面当有左右2个子视图的宽度都不确定，但又不希望2个子视图不能重叠展示的问题。具体例子参见（DEMO:AllTest7ViewController 中的第4个例子）。
3. 布局视图添加了属性`tg_zeroPadding`用来描述当布局视图的尺寸由子视图决定，并且当布局视图中没有任何子视图时设置的padding值是否会参与布局视图尺寸的计算。默认是YES，当设置为NO时则当布局视图没有子视图时padding是不会参与布局视图尺寸的计算的。具体例子参见 （DEMO: LLTest4ViewController）
4. 添加了对非布局父视图的高度和宽度的.wrap设置支持，这样非布局父视图就可以实现高度和宽度由里面的子布局视图来决定。具体例子参见（DEMO: LLTest4ViewController）。 
5. 添加了对UIButton的宽度固定情况下高度自自适应的支持。

#### Changed
1. 优化了当将一个布局视图作为视图控制器的根视图时(self.view)的一些属性设置可能导致约束冲突，和可能导致将控制器中的视图加入到一个滚动视图时无法滚动的问题。
2. 将线性布局`TGLinearLayout`中的tg_shrinkType属性的默认值由原来的`.average`改为了`.none`，也就是默认是不压缩的。
3. 修正了相对布局中的子视图设置`tg_useFrame`为YES时，子视图无法自由控制自己的frame的问题。
4. 优化了所有类以及方法和属性以及各种类型的注释，注释更加清晰明了。同时优化了所有DEMO中的注释信息。
5. 修正了将一个布局视图添加到非布局视图里面后，如果后续调整了布局视图的边界设置后无法更新布局视图尺寸的问题。




## [1.0.3](https://github.com/youngsoft/TangramKit/releases/tag/1.0.3)(2017/1/21)

1. 流式布局`TGFlowLayout`添加了对分页滚动的支持，通过新增加的属性`tg_pagedCount`来实现，这个属性只支持数量约束流式布局。`tg_pagedCount`和`tg_width以及tg_height 设置为.wrap`配合使用能够实现各种方向上的分页滚动效果(具体见DEMO：FLLTest5ViewController)
2. 线性布局`TGLinearLayout`中完全支持了所有子视图的高度等于宽度的设置的功能，以及在水平线性布局中添加了子宽度等于高度的功能。
3. 流式布局`TGFlowLayout`中的子视图的tg_width,tg_height中可设置的相对类型尺寸的值的维多扩宽，不仅可以依赖兄弟视图，父视图，甚至还可以依赖别的任意的视图。
4. 修复将布局视图加入到非布局父视图时当计算出视图的尺寸为小于0时，而又将这个尺寸用来设置视图的bounds属性的尺寸时会调整bounds的origin部分而产生的BUG。具体展示是视图的位置产生了不正确的错误。
5. 修复了流式布局`TGFlowLayout`中的数量约束水平流式布局的高度`tg_height`设置为`.wrap`的错误计算的BUG。
6. 修复[BUG#7](https://github.com/youngsoft/TangramKit/issues/7)。这个BUG是因为以前认为宽度是wrap高度是特定值是不可能的情况！！其实是有可能的。






## [1.0.2](https://github.com/youngsoft/TangramKit/releases/tag/1.0.2)(2016/12/28)

1. 布局位置类`TGLayoutPos`和布局尺寸类`TGLayoutSize`类中添加了新属性：`isActive`.用来描述指定的位置或者尺寸所设置的约束是否有效。
2. 添加了Demo:ALLTest8ViewController这个例子专门用来演示把一个布局视图加入到非布局父视图时的使用方法。
3. 修正了将一个具有`wrap`尺寸的布局视图加入到非布局父视图时，且又设置tg_centerX，tg_centerY,tg_right,tg_bottom来定位布局视图时无法正确定位布局视图位置的BUG。
4. 修改了将布局视图加入`UIScrollView`时会自动调整`UIScrollView`的`contentSize`的机制，新的机制中布局视图设置的`TGLayoutPos`边距值也会算到contentSize里面去。比如某个布局的高度是100，其中的myTopMargin = 10, 那么当将布局视图加入到UIScrollView时他的contentSize的高度则是110.
5. 修复了布局尺寸高度评估方法`tg_sizeThatFits`计算有可能不正确的[BUG#6](https://github.com/youngsoft/TangramKit/issues/6)。
6. 修复了线性布局TGLinearLayout的均分视图方法`tg_equalizeSubviews`的[BUG#5](https://github.com/youngsoft/TangramKit/issues/5)。

## [1.0.1](https://github.com/youngsoft/TangramKit/releases/tag/1.0.1)
1. 实现对Pods的支持和对Carthage的支持。
2. 优化了目录结构

## 1.0.0

1. 实现7大布局库和对SizeClass的支持。  

