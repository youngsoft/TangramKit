# Change Log
**TangramKit**中的所有历史版本变化将会在这个文件中列出。

---


## [V1.4.0](https://github.com/youngsoft/TangramKit/releases/tag/1.4.0)(2019/05/19)
#### Added
1. 添加了对TangramKit的尺寸自适应和AutoLayout结合的能力。AutoLayout能使用和UILabel一样的TangramKit布局视图中的高度和宽度自适应的设置。具体需求见[issue#79](https://github.com/youngsoft/MyLinearLayout/issues/79)。这个问题的解决得到简化处理。新版本的能力让UITableViewCell的高度自适应的能力得到简化。具体的代码演示见[AllTest1ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/IntegratedDemo/AllTest1ViewController.swift)，以及[AllTest10ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/IntegratedDemo/AllTest10ViewController.swift)中的详细介绍。

2.  添加了对RTL设置的即时生效的能力，您可通过方法`public static func tg_updateArabicUI(_ isArabic:Bool, inWindow window:UIWindow)`来设置，具体的功能实现要感谢[LAnqxpp](https://github.com/LAnqxpp)的贡献。
#### Fixed
1. 修复了相对布局可能会产生尺寸无限大的问题，尤其是当相对布局的高度为自适应，并且相对布局中同样存在着具有高度自适应的子布局视图的情况。


## [V1.3.2](https://github.com/youngsoft/TangramKit/releases/tag/1.3.2)(2019/04/25)
#### Fixed
1. 兼容swift5.0


## [V1.3.1](https://github.com/youngsoft/TangramKit/releases/tag/1.3.1)(2018/09/21)
#### Fixed
1. 为实现对Swift4.0/4.2的支持而修复了所有编译告警的问题。
2. 修复了浮动布局TGFloatLayout中的子视图在设置尺寸为TGWeight类型时的一个比例计算的错误问题。
3. 实现对iPhoneXR、iPhoneXS、iPhoneXSMAX的tg_padding的安全区缩进的改进支持。
4. 实现了在Application Extension中使用布局库时报UIApplication对象不支持或者不存在的问题。


## [V1.2.0](https://github.com/youngsoft/TangramKit/releases/tag/1.2.0)(2018/08/04)

#### Added
1. 添加布局属性`tg_layoutTransform`,用来实现对布局内子视图的整体位置变换，可以通过这个属性来实现一般常见的平移，缩放，水平翻转，垂直翻转等功能。具体的DEMO在新增加的[AllTest9ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/IntegratedDemo/AllTest9ViewController.swift)中可以查看。
2. 为流式布局`MyFlowLayout`支持子视图固定尺寸并且间距动态拉伸调整的能力，你可以通过设置流式布局的方法：`tg_setSubviews`来实现，这个方法原先只支持内容约束流式布局，现在新版本对数量约束流式布局也同样支持了。具体的DEMO在新增加的[FLLTest8ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/FlowLayoutDemo/FLLTest8ViewController.swift)中可以查看。

#### Fixed
1. 修复了UILabel等控件的尺寸设置了.wrap并且同时又设置了最大最小尺寸时，在相对布局内进行尺寸计算内可能会出现的问题。[#issue25](https://github.com/youngsoft/TangramKit/issues/25)


## [V1.1.6](https://github.com/youngsoft/TangramKit/releases/tag/1.1.6)(2018/05/10)

#### Added
1.添加了流式布局`TGFlowLayout`对瀑布流的支持，主要是数量约束流式布局来实现，通过设置`tg_autoArrange`为YES或者设置`tg_arrangedGravity`属性为`TGGravity.horz.between或者TGGravity.vert.between`来实现两种不同策略的瀑布流模式，瀑布流模式其实就是一种紧凑的流式布局排列方式。具体的DEMO在新增加的[FLLTest7ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/FlowLayoutDemo/FLLTest7ViewController.swift)中可以查看。

#### Fixed
1. 修复了流式布局`TGFlowLayout`中的tg_gravity属性设置后停靠有可能不正确的问题。
2. 优化和修复了对UIScrollView+布局视图时，设置UIScrollView的高度或者宽度由布局视图的尺寸进行自适应的问题。新版本中UIScrollView的尺寸可以依赖于布局视图的尺寸，同时布局视图的最大最小尺寸可以设置为UIScrollView的尺寸。具体例子参考：[FLLTest7ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/FlowLayoutDemo/FLLTest7ViewController.swift)
3. 添加了对布局视图的`tg_cacheEstimatedRect`属性的使用限制说明，这个属性只能用于那些需要高度自适应的UITableViewCell的根布局视图中使用，其他地方如果使用则有可能会出现计算不正确的问题。


## [V1.1.5](https://github.com/youngsoft/TangramKit/releases/tag/1.1.5)(2018/05/06)

1. 优化了编译时慢的一些代码。
2. 修复表格布局的行的尺寸设置为TGLayoutSize.wrap时并且同时使用了智能边界线时，其中的列子视图的边界线显示不完整的问题。



## [V1.1.4](https://github.com/youngsoft/TangramKit/releases/tag/1.1.4)(2018/04/23)

#### Added
1. 添加了对浮动布局TGFloatLayout中的子视图的行或者列内对齐方式的设置，您可以借助子视图的tg_alignment属性来设置行或者列内的对齐方式，具体的DEMO请参考：[FOLTest7ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/FloatLayoutDemo/FOLTest7ViewController.swift) 中的介绍。
2. 修复方向旋转时有可能不调用`rotationToDeviceOrientationBlock`的问题。
3. 修正一些注释上的不提示问题。
4. 修正TGLayoutPos无法使用~=，+=, >=, <= 运算符的问题。



## [V1.1.3](https://github.com/youngsoft/TangramKit/releases/tag/1.1.3)(2017/11/08)

#### Added
1. 添加了对**基线对齐baseline**的支持[issue:#43](https://github.com/youngsoft/MyLinearLayout/issues/43)，目前只有**水平线性布局(TGLinearLayout)**和**相对布局(TGRelativeLayout)**支持基线对齐。
    1. 在**TGGravity**中添加了`TGGravity.vert.baseline`的枚举定义来支持线性布局的基线对齐，并且在线性布局中添加了一个属性：`tg_baselineBaseView`来指定某个基线基准视图。同时在布局视图的tg_gravity属性中支持对`TGGravity.vert.baseline`的设置。具体例子参考：[LLTest1ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/linerLayoutDemo/LLTest1ViewController.swift)

    2. 在UIView的扩展属性中增加了一个扩展属性：`tg_baseline`。你可以在相对布局中的子视图使用这个属性来进行基线对齐的设置。具体例子请参考：[RLTest1ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/linerLayoutDemo/RLTest1ViewController.swift)

2. **TGLayoutPos**中增加了一个特殊的值`tg_safeAreaMargin`用来支持对iOS11应用的适配。
3. 添加对所有设备完美适配的例子，具体看各个DEMO。

#### Change
1. 优化DEMO的目录结构。以便展示更加合理和查找方便。
2. 支持在XCODE8下编译MyLayout的能力。[issue:#54](https://github.com/youngsoft/MyLinearLayout/issues/54)
3. 优化在iPhoneX的横屏下UITableViewCell的动态高度的计算的问题，请参考[AllTest1TableViewCell.swift](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/IntegratedDemo/AllTestModel&View/AllTest1TableViewCell.swift)

#### Fixed
1. 修复各种布局下均分尺寸时可能会中间留出一个像素空间的问题。
2. 修复相对布局下某个子视图固定，其他子视图均分剩余尺寸的问题[BUG#53](https://github.com/youngsoft/MyLinearLayout/issues/53)
3. 优化V1.4.3版本中insetsPaddingFromSafeArea的默认属性设置导致UITableView的中的cell往下偏移，以及iOS11下的多余偏移的问题。
4. 修复表格布局TGTableLayout中的添加行方法`tg_addRow`的列参数设置为整数时无法显示列宽或者列高的问题。
5. 修复了一个当子视图不设置任何约束时，在进行布局时可能出现错误的问题。
6. 修复了路径布局中的子视图在执行动画时可能会产生崩溃的问题。




## [V1.1.2](https://github.com/youngsoft/TangramKit/releases/tag/1.1.2)(2017/9/23)

#### Added
1. 添加对Swift4的兼容支持
2. 添加适配iOS11的能力以及**iPhoneX**的方法。基本不需要改动当前代码。如果需要改动只需要设置根布局视图的一些属性即可。
  	1. 新增布局视图属性：`tg_insetsPaddingFromSafeArea`用来设置在哪个方向缩进对应方向的安全区域。
  	2. 新增布局视图属性：`tg_insetLandscapeFringePadding`用来设置当支持横屏时，并且tg_insetsPaddingFromSafeArea设置为左右缩进时，是否只缩进有刘海的那一边。这个属性默认设置为NO，表示两边都缩进。您可以在特殊需要时将这个属性设置为YES表示只缩进刘海那一边，非刘海那一边则不缩进。具体参考使用DEMO：[LLTest1ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/linerLayoutDemo/LLTest1ViewController.swift)

3. 表格布局TGTableLayout添加了`tg_addRow:colCount:`方法，目的是为了支持那些列数固定并且宽度固定的需求，具体例子见DEMO：[TLTest1ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKitDemo/TableLayoutDemo/TLTest1ViewController.swift)中的第五行的代码。
4. 添加了布局视图的高度等于非布局父视图宽度以及布局视图宽度等于非布局父视图高度的支持，目的是为了支持对布局视图进行旋转`transform`的支持。
5. 添加了框架布局MyFrameLayout中子视图的高度等于另外视图宽度以及宽度等于另外视图高度的支持。
6. 下一个版本将会有重大功能的添加：栅格布局的支持、基线对齐的支持、均分的再次优化等等功能，敬请期待吧。。



#### Fixed
1. 修复了流式布局`MyFlowLayout`中当使用`pageCount`设置分页而里面的子视图是布局视图并设置了wrapContentHeight或wrapContentWidth方法时有可能会导致约束冲突而产生死循环的问题。

2. 修复了线性布局中的子视图设置为weight=1来均分布局视图的尺寸时，有可能导致产生中间缝隙的BUG。以及子视图的总尺寸和布局视图尺寸不相等的BUG。
3. 修复了当对布局视图进行多点触摸且设置了布局视图的触摸事件时，有可能会对对应的触摸动作不调用而产生触摸状态无法被恢复的问题。
4. 调整了将原始逻辑点转化为可显示逻辑点的算法，老算法计算可能不精确。



## [V1.1.1](https://github.com/youngsoft/TangramKit/releases/tag/1.1.1)(2017/6/22)
#### Fixed
1. 修复了布局视图套布局视图，并且尺寸是.wrap时界面有可能进入死循环的问题，尤其是iPhonePlus设备。


## [V1.1.0](https://github.com/youngsoft/TangramKit/releases/tag/1.1.0)(2017/6/16)

#### Added
1. 添加了布局视图的新属性：`selected`,这个属性用来记录布局视图的选中和未选中状态
2. 添加了布局视图删除所有子视图的快捷方法：`tg_removeAllSubviews`。


#### Fixed
1. 修复子视图宽高铺满布局视图并设置背景色时边界线不显示的问题。
2. 修复了浮动布局`TGFloatLayout`中当子视图同时设置了`tg_clearFloat`和尺寸为TGWeight的时候有可能尺寸显示不正确的问题。修复了[#BUG42](https://github.com/youngsoft/MyLinearLayout/issues/42)
3. 修复了线性布局`TGLinearLayout`和框架布局`TGFrameLayout`同时设置左右或者上下边距和居中时的尺寸不正确的问题。
4. 优化了位置和尺寸计算时的精度问题，老版本中有可能会出现比如12.99999999999998的场景，新版本将会减少这种情况的发生而直接设置为13. 同时对所有的布局中的大小比较进行了精度限制的优化。


## [V1.0.9](https://github.com/youngsoft/TangramKit/releases/tag/1.0.9)(2017/6/12)

#### Fixed
1. 修复了[#BUG41](https://github.com/youngsoft/MyLinearLayout/issues/41)。原因是当左右两边的子视图尺寸有重合并且高度或者宽度相等时没有将两边的占用区域进行合并，从而影响了新加入的子视图的尺寸设置。
2. 修复了[#BUG40](https://github.com/youngsoft/MyLinearLayout/issues/40)。原因是当UIScrollView的contentOffset值为负数时，如果修改视图的frame值将会把contentOffset的值重置为0.这个是一个系统的特性，因此解决的方案是不修改frame而是修改bounds和center两个属性。
3. 修复了[#BUG39](https://github.com/youngsoft/MyLinearLayout/issues/39)。原因是当设置视图的frame的pt值时如果pt值无法转化为有效的设备的物理像素时将会出现：**文字模糊发虚、线发虚、以及文字无法多行显示、以及当使用layer的cornerRadius时无法绘制出正确的圆形的问题**。因此解决的方案是在布局完成后设置frame时会将pt值四舍五入转化为最小的可显示的物理像素值。


## [V1.0.8](https://github.com/youngsoft/TangramKit/releases/tag/1.0.8)(2017/6/2)

#### Fixed
1. 修复了1.0.7中对UILabel的tg_width设置为`wrap`时又同时在相对布局中同时设置了`tg_top`和`tg_bottom`时高度不正确的问题。这个问题在1.3.7中的Fixed#3条目中没有修复正确。

## [V1.0.7](https://github.com/youngsoft/TangramKit/releases/tag/1.0.7)(2017/6/1)


#### Added
1. 对视图添加了属性`tg_visibility`，这个属性是对视图的hidden属性的扩展，除了可以控制视图的隐藏和显示外还可以控制视图隐藏时是否仍然占位布局。（具体参见RLTest2ViewController）
2. 对视图添加了属性`tg_alignment`，这个属性只在线性布局、框架布局、表格布局、流式布局中起作用，它用来设置某个视图的停靠和对齐属性。当对某个布局视图设置`gravity`属性实现整体的停靠和对齐时，如果某个子视图想单独处理停靠则可以用这个属性来单独设置。（具体参见LLTest3ViewController）
3. 添加了`TGDimeAdapter`的方法：`round`来分别实现入参为小数时的设备逻辑点值到最小可转化为物理像素的有效设备点值的转化。


#### Changed
1. 将布局视图的属性`tg_layoutHiddenSubviews`置为无效，布局视图不再提供对隐藏视图的是否占位的处理了，而是通过新增加的视图的扩展属性`tg_visibility`来实现。
2. 将相对布局视图的属性:`tg_autoLayoutViewGroupWidth`和`tg_autoLayoutViewGroupHeight`属性置为无效，布局视图不再提供对隐藏视图的是否占位的处理了，而是通过新增加的视图的扩展属性`tg_visibility`来实现。
3. 将原先线性布局、流式布局、浮动布局中的`gravity`属性提升到了布局基类中，目前线性布局、流式布局、浮动布局、和框架布局都支持`gravity`的设置。
4. 进一步优化了布局视图的性能，表现为对KVO监听的延迟处理和优化。经过试验发现当对UILabel调用sizeToFit时，并且使用的是系统字体时将非常消耗性能。因此新版本也对UILabel动态高度计算进行了优化:[#issue9](https://github.com/youngsoft/TangramKit/issues/9)
5. 进一步优化了布局视图的内存占用尺寸，将布局视图中对触摸事件处理时的变量变为按需要才创建，以及布局视图的边界线对象也改为了按需要才建立，这两部分按需的处理机制将有效的减少了布局视图的内存占用。
6. 为了更进一步的优化和简化MyLayout对UITableviewCell高度自适应的处理，新版本中对实现的解决方案进行优化处理，具体详情请参考：[AllTest1ViewController](https://github.com/youngsoft/TangramKit/blob/master/TangramKit/AllTest1ViewController.m)中的介绍


#### Fixed
1. 修复了[#BUG37](https://github.com/youngsoft/MyLinearLayout/issues/37)原因是对`UILabel`或者`UITextView`或者`UIButton`进行尺寸和位置计算时如果得到值并不是最小的有效的设备逻辑点，导致当逻辑点映射到像素显示时将无法清晰显示。对于2倍像素的设备来说要求逻辑点的值必须是1/2的倍数。而对于3倍像素的设备来说要求逻辑点的值必须是1/3的倍数。
2. 修复了路径布局`TGPathLayout`中的一个子视图位置可能显示不正确的BUG。原因就是在进行子视图之间的间距的长度逼近时有可能步长再小也无法满足条件时造成子视图显示重叠的问题。
3. 修复了UILabel设置宽度为wrap时而没有指定高度时有可能不显示的BUG。原因是使用者可能没有指定高度，这次系统默认为他指定高度来解决这个问题。
4. 修复了边界线`TGBorderline`的`thick`属性如果设置小于1而出现移动时不停闪烁的[#BUG38](https://github.com/youngsoft/MyLinearLayout/issues/38)。同时修复了边界线在不同分辨率设备下的显示的粗细不同问题。原因是如果thick过小则因为设备逻辑点映射到物理像素的问题导致刷新闪烁的问题。
6. 修复了路径布局`TGPathLayout`的中心点子视图`tg_originView`的`layer.anchorPoint`的设置不为默认值时的位置frame显示不正确的问题。
7. 修复了当使用1.0.6版本中的`tg_cacheEstimatedRect`属性来缓存UITableviewCell高度时的UITableviewCell的高度可能为0的BUG。
8. 修复了对carthage的支持。



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
3. 修复了路径布局`TGPathLayout`中曲线精度计算的一个BUG。这个BUG可能导致子视图之间的间距不正确。
4. 修复了1.0.5版本编译缓慢的问题，主要是优化了对??运算符的使用以及类型转换的问题导致编译缓慢。

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

