[![Version](https://img.shields.io/cocoapods/v/TangramKit.svg?style=flat)](http://cocoapods.org/pods/TangramKit)
[![License](https://img.shields.io/cocoapods/l/TangramKit.svg?style=flat)](http://cocoapods.org/pods/TangramKit)
[![Platform](https://img.shields.io/cocoapods/p/TangramKit.svg?style=flat)](http://cocoapods.org/pods/TangramKit)
[![Support](https://img.shields.io/badge/support-iOS%205%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Weibo](https://img.shields.io/badge/Sina微博-@欧阳大哥2013-yellow.svg?style=flat)](http://weibo.com/1411091507)
[![QQ](https://img.shields.io/badge/QQ-156355113-yellow.svg?style=flat)]()
[![GitHub stars](https://img.shields.io/github/stars/youngsoft/TangramKit.svg)](https://github.com/youngsoft/TangramKit/stargazers)

![logo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKit/logo1.png)

#TangramKit ![logo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKit/logo2.png)
**for Swift3.0**

#### TangramKit的Objective-C版本叫[MyLayout](https://github.com/youngsoft/MyLinearLayout)

#### English : [Introduction](README.md)

##功能介绍
---
   一套功能强大的iOS界面布局库，他不是在AutoLayout的基础上进行的封装，而是一套基于对frame属性的设置，并通过重载layoutSubview函数来实现对子视图进行布局的布局框架。因此可以无限制的运行在任何版本的iOS系统中。其设计思想以及原理则参考了Android的布局体系和iOS自动布局以及SizeClass的功能，通过提供的：**线性布局TGLinearLayout**、**相对布局TGRelativeLayout**、**框架布局TGFrameLayout**、**表格布局TGTableLayout**、**流式布局TGFlowLayout**、**浮动布局TGFloatLayout**、六个布局类，以及对**SizeClass**的支持，来完成对界面的布局。TangramKit具有功能强大、简单易用、几乎不用设置任何约束、可以完美适配各种尺寸的屏幕等优势。具体的使用方法请看Demo中的演示代码中了解.
   
   TangramKit 是[MyLayout](https://github.com/youngsoft/MyLinearLayout)的Swift版本，主要的布局体系以及思想二者保持一致，但是对于方法和属性的设置进行了优化，在TrangramKit中删除了子视图的weight属性，取而代之的是TGWeight类型的属性值设置、同时在swift中添加了.wrap, .fill这两个属性值的设置，而去掉了只有布局视图才有的wrapContentWidth和wrapContentHeight属性等等，总之使用的时候将更加的简单易用。
   

###你也可以加入到QQ群：*178573773* 或者添加个人QQ：*156355113* 或者邮件：*obq0387_cn@sina.com* 联系我。###



## 演示效果图
---

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo1.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo2.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo3.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo4.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo5.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo6.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo7.gif)



### 线性布局TGLinearLayout
---
线性布局是一种里面的子视图按添加的顺序从上到下或者从左到右依次排列的单列(单行)布局视图，因此里面的子视图是通过添加的顺序建立约束和依赖关系的。 子视图从上到下依次排列的线性布局视图称为垂直线性布局视图，而子视图从左到右依次排列的线性布局视图则称为水平线性布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/ll.png)

示例代码:

```swift
let rootLayout = TGLinearLayout(.vert)
rootLayout.tg_width(.wrap)
rootLayout.tg_height(.wrap)
rootLayout.tg_vspace = 10

let A = UIView()
A.tg_left.equal(5)
A.tg_right.equal(5)
A.tg_width.equal(100)
A.tg_height.equal(40)
rootLayout.addSubview(A)

let B = UIView()
B.tg_left.equal(20)
B.tg_width.equal(40)
B.tg_height.equal(40)
rootLayout.addSubview(B)

let C = UIView()
C.tg_right.equal(40)
C.tg_width.equal(50)
C.tg_height.equal(40)
rootLayout.addSubview(C)

let D = UIView()
D.tg_left.equal(10)
D.tg_right.equal(10)
D.tg_width.equal(100)
D.tg_height.equal(40)
rootLayout.addSubview(D)

```

**TGLinearLayout的功能等价于Android的LinearLayout和iOS的UIStackView**


### 相对布局TGRelativeLayout
---
相对布局是一种里面的子视图通过相互之间的约束和依赖来进行布局和定位的布局视图。相对布局里面的子视图的布局位置和添加的顺序无关，而是通过设置子视图的相对依赖关系来进行定位和布局的。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/rl.png)

示例代码:

```swift
let rootLayout = TGRelativeLayout()
rootLayout.tg_width(.wrap)
rootLayout.tg_height(.wrap)


let A = UIView()
A.tg_left.equal(20)
A.tg_top.equal(20)
A.tg_width.equal(40)
A.tg_height.equal(A.tg_width)
rootLayout.addSubview(A)

let B = UIView()
B.tg_left.equal(A.tg_centerX)
B.tg_top.equal(A.tg_bottom)
B.tg_width.equal(60)
B.tg_height.equal(A.tg_height)
rootLayout.addSubview(B)

let C = UIView()
C.tg_left.equal(B.tg_right)
C.tg_width.equal(40)
C.tg_height.equal(B.tg_height, multiple:0.5)
rootLayout.addSubview(C)

let D = UIView()
D.tg_bottom.equal(C.tg_top)
D.tg_right.equal(20)
D.tg_height.equal(A.tg_height)
D.tg_width.equal(D.tg_height)
rootLayout.addSubview(D)

let E = UIView()
E.centerYPos.equalTo(0)
E.tg_height.equal(40)
E.tg_width.equal(rootLayout.tg_width)
rootLayout.addSubview(E)
//...F,G

```
**TGRelativeLayout的功能等价于Android的RelativeLayout和iOS的AutoLayout**


### 框架布局TGFrameLayout
---
框架布局是一种里面的子视图停靠在父视图特定方位并且可以重叠的布局视图。框架布局里面的子视图的布局位置和添加的顺序无关，只跟父视图建立布局约束依赖关系。框架布局将垂直方向上分为上、中、下三个方位，而水平方向上则分为左、中、右三个方位，任何一个子视图都只能定位在垂直方向和水平方向上的一个方位上。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fl.png)

示例代码:

```swift
  let rootLayout = TGFrameLayout()
  rootLayout.tg_width(500)
  rootLayout.tg_height(500)  
  
  UIView *A = UIView()
  A.tg_width(40)
  A.tg_height(40)
  rootLayout.addSubview(A)
  
  let B = UIView()
  B.tg_width(40)
  B.tg_height(40)
  B.tg_right.equal(0)
  rootLayout.addSubview(B)
  
  let C = UIView()
  C.tg_width(40)
  C.tg_height(40)
  C.tg_centerY.equal(0)
  rootLayout.addSubview(C)

  let D = UIView()
  D.tg_width(40)
  D.tg_height(40)
  D.tg_centerY.equal(0)
  D.tg_centerX.equal(0)
  rootLayout.addSubview(D)
  
  //..E，F,G
  
```

**TGFrameLayout的功能等价于Android的FrameLayout**



### 表格布局TGTableLayout
---
表格布局是一种里面的子视图可以像表格一样多行多列排列的布局视图。子视图添加到表格布局视图前必须先要建立并添加行视图，然后再将子视图添加到行视图里面。如果行视图在表格布局里面是从上到下排列的则表格布局为垂直表格布局，垂直表格布局里面的子视图在行视图里面是从左到右排列的；如果行视图在表格布局里面是从左到右排列的则表格布局为水平表格布局，水平表格布局里面的子视图在行视图里面是从上到下排列的。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/tl.png)

示例代码:

```swift
  let rootLayout = TGTableLayout(.vert)
  rootLayout.tg_height.equal(.wrap)
  rootLayout.tg_width.equal(500)
  
  rootLayout.addRow(TGTableLayout.wrap,colSize:TGTableLayout.fill)
  
  let A = UIView()
  A.tg_width(50)
  A.tg_height(40)
  rootLayout.addSubview(A)
  
  let B = UIView()
  B.tg_width(100)
  B.tg_height(40)
  rootLayout.addSubview(B)
  
  let C = UIView()
  C.tg_width(30)
  C.tg_height(40)
  rootLayout.addSubview(C)
  
  rootLayout.addRow(TGTableLayout.wrap,colSize:TGTableLayout.fill)
  
   let D = UIView()
   D.tg_width(180)
   D.tg_height(40)
   rootLayout.addSubview(D)
  
  //...E,F  
  
  
```

**TGTableLayout的功能等价于Android的TableLayout和HTML中的table元素**


### 流式布局TGFlowLayout
---
流式布局是一种里面的子视图按照添加的顺序依次排列，当遇到某种约束限制后会另起一行再重新排列的多行展示的布局视图。这里的约束限制主要有数量约束限制和内容尺寸约束限制两种，而换行的方向又分为垂直和水平方向，因此流式布局一共有垂直数量约束流式布局、垂直内容约束流式布局、水平数量约束流式布局、水平内容约束流式布局。流式布局主要应用于那些子视图有规律排列的场景，在某种程度上可以作为UICollectionView的替代品。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fll.png)

示例代码:

```swift
   let rootLayout = TGFlowLayout(.vert,arrangedCount:3)
   rootLayout.tg_height.equal(.wrap)
   rootLayout.tg_width.equal(300)
   rootLayout.tg_averageArrange = true
   rootLayout.tg_space = 10
   
   for _ in 0 ..< 10
   {
       let A = UIView()
       A.tg_height.equal(A.tg_width)
       rootLayout.addSubview(A)
   }
   
   

```

**TGFlowLayout的功能等价于CSS3中的flexbox**

	
### 浮动布局TGFloatLayout
---
浮动布局是一种里面的子视图按照约定的方向浮动停靠，当尺寸不足以被容纳时会自动寻找最佳的位置进行浮动停靠的布局视图。浮动布局的理念源于HTML/CSS中的浮动定位技术,因此浮动布局可以专门用来实现那些不规则布局或者图文环绕的布局。根据浮动的方向不同，浮动布局可以分为左右浮动布局和上下浮动布局。

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/flo.png)

示例代码:

```swift
     let rootLayout = TGFloatLayout(.vert)
     rootLayout.tg_height.equal(.wrap)
     rootLayout.tg_width.equal(300)
     
     let A = UIView()
     A.tg_height.equal(80)
     A.tg_width.equal(70)
     rootLayout.addSubview(A)
     
     let B = UIView()
     B.tg_height.equal(150)
     B.tg_width.equal(40)
     rootLayout.addSubview(B)
     
     let C = UIView()
     C.tg_height.equal(70)
     C.tg_width.equal(40)
     rootLayout.addSubview(C)
     
     let D = UIView()
     D.tg_height.equal(140)
     D.tg_width.equal(140)
     rootLayout.addSubview(D)
     
     let E = UIView()
     E.tg_height.equal(150)
     E.tg_width.equal(40)
     E.tg_reverseFloat = true
     rootLayout.addSubview(E)

     let F = UIView()
     F.tg_height.equal(140)
     F.tg_width.equal(60)
     rootLayout.addSubview(F)
     

```

**TGFloatLayout的功能等价于CSS中的float浮动定位**



 
###  SizeClass的支持
---
TangramKit布局体系为了实现对不同屏幕尺寸的设备进行适配，提供了对SIZECLASS的支持。您可以将SIZECLASS和上述的6种布局搭配使用，以便实现各种设备界面的完美适配。
	


## 使用方法
---

### 直接拷贝
1.  将github工程中的Lib文件夹下的所有文件复制到您的工程中。

### CocoaPods安装

如果您还没有安装cocoapods则请先执行如下命令：
```
$ gem install cocoapods
```

为了用CocoaPods整合TangramKit到您的Xcode工程, 请建立如下的Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

pod 'TangramKit', '~> 1.0.0'
```
   
然后运行如下命令:

```
$ pod install
```

### MyLayout和TangramKit的差异

1.  库的名称由MyLayout变为TangramKit，Tangram的中文意思是七巧板，意思是可以支持千变万化的界面布局。
2.  所有的类名都以TG开头，所有的方法和属性都以tg_开头。
3.  增加了TGWeight类型，用来设置那些位置和尺寸是相对值的场景。比如宽度和父视图保持一致： tg_width.equal(100%)。
4.  删除了weight扩展属性，统一通过TGLayoutPos,TGLayoutSize的equal方法来设置，其值类型就是上面的TGWeight。比如原来的A.weight = 1 变为 A.tg_width.equal(100%)
5.  废除了线性布局和框架布局的位置设置为大于0小于1时所表示的相对值的概念，统一由新的类型TGWeight来表示相对值。
6.  废除了垂直线性布局默认wrapContentHeight，以及水平线性布局默认wrapContentWidth的特性。需要自己去设置包裹属性。
7.  增加了TGLayoutSize的方法equal能够设置的值的类型：.wrap 表示包裹值，表示视图的尺寸由内容或者子视图决定；.fill表示填充值，表示视图的尺寸填充父视图的剩余空间。
8.  删除了布局视图的wrapContentHeight,wrapContentWidth属性，统一由TGLayoutSize设置为.wrap类型的值。比如原来的A.wrapContentWidth = YES  变为 A.tg_width.equal(.wrap)
9.  删除了框架布局子视图的marginGravity属性扩展，直接通过TGLayoutPos设置来实现定位。
10. 删除了子视图的扩展属性flexedHeight，而是直接由TGLayoutSize设置为.wrap来表示。

