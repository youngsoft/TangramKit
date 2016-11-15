[![Version](https://img.shields.io/cocoapods/v/TangramKit.svg?style=flat)](http://cocoapods.org/pods/TangramKit)
[![License](https://img.shields.io/cocoapods/l/TangramKit.svg?style=flat)](http://cocoapods.org/pods/TangramKit)
[![Platform](https://img.shields.io/cocoapods/p/TangramKit.svg?style=flat)](http://cocoapods.org/pods/TangramKit)
[![Support](https://img.shields.io/badge/support-iOS%205%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Weibo](https://img.shields.io/badge/Sina微博-@欧阳大哥2013-yellow.svg?style=flat)](http://weibo.com/1411091507)
[![QQ](https://img.shields.io/badge/QQ-156355113-yellow.svg?style=flat)]()
[![GitHub stars](https://img.shields.io/github/stars/youngsoft/TangramKit.svg)](https://github.com/youngsoft/TangramKit/stargazers)

![logo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKit/logo1.png)

##TangramKit ![logo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKit/logo2.png)

TangramKit is a simple and easy Swift framework for iOS view layout. The name comes from Tangram of China which provides some simple functions to build a variety of complex interface. It integrates the functions including: Autolayout and SizeClass of iOS, five layout classes of Android, float and flex-box and bootstrap of HTML/CSS. The TangramKit's objective-C version are named: **[MyLayout](https://github.com/youngsoft/MyLinearLayout)**

##### ![cn](https://raw.githubusercontent.com/gosquared/flags/master/flags/flags/shiny/24/China.png) Chinese (Simplified): [中文说明](README.zh.md)




## Usage

* There is a container view S which width is 100 and height is wrap to all subviews height. there are four subviews A,B,C,D arranged from top to bottom. 
*  Subview A's left margin is 20% width of S, right margin is 30% width of S, height is equal to width of A. 
*  Subview B's left margin is 40, width is filled in to residual width of S,height is 40.
*  Subview C's width is filled in to S, height is 40.
*  Subview D's right margin is 20, width is 50% width of S, height is 40 

![demo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKit/usagedemo.png)


```swift

    let S = TGLinearLayout(.vert)
    S.tg_vspace = 10
    S.tg_width.equal(100)
    S.tg_height.equal(.wrap)
    //you can use S.tg_size(width:100, height:.wrap) to instead
    
    let A = UIView()
    A.tg_left.equal(20%)
    A.tg_right.equal(30%)
    A.tg_height.equal(A.tg_width)
    S.addSubview(A)
    
    let B = UIView()
    B.tg_left.equal(40)
    B.tg_width.equal(.fill)
    B.tg_height.equal(40)
    S.addSubview(B)
    
    let C = UIView()
    C.tg_width.equal(.fill)
    C.tg_height.equal(40)
    S.addSubview(C)
    
    let D = UIView()
    D.tg_right.equal(20)
    D.tg_width.equal(50%)
    D.tg_height.equal(40)
    S.addSubview(D)
    

```
 
 
 TangramKit has override operators: ~=、>=、<=、+=、-=、*=、/= to implement equal、max、min、add、offset、multiply methods of `TGLayoutSize` and `TGLayoutPos` class, so you can instead to:
 
 
 ```swift
 
 let S = TGLinearLayout(.vert)
    S.tg_vspace = 10
    S.tg_width ~=100
    S.tg_height ~=.wrap
    
    let A = UIView()
    A.tg_left ~=20%
    A.tg_right ~=30%
    A.tg_height ~=A.tg_width
    S.addSubview(A)
    
    let B = UIView()
    B.tg_left ~=40
    B.tg_width ~=.fill
    B.tg_height ~=40
    S.addSubview(B)
    
    let C = UIView()
    C.tg_width ~=.fill
    C.tg_height ~=40
    S.addSubview(C)
    
    let D = UIView()
    D.tg_right ~=20
    D.tg_width ~=50%
    D.tg_height ~=40
    S.addSubview(D)

 ```


##Architecture

![demo](https://raw.githubusercontent.com/youngsoft/TangramKit/master/TangramKit/TangramClass.png)

* ###TGLayoutPos
`TGLayoutPos` is represent to the position of a view. UIView provides six extension variables:tg_left, tg_top, tg_bottom, tg_right, tg_centerX, tg_centerY to set view's margin or space distance between self and others.


* ###TGLayoutSize
`TGLayoutSize` is represent to the size of a view. UIView provides two extension variables:tg_width,tg_height to set view's width and height dimension.


* ###TGWeight
`TGWeight` is used to set relative position and dimension. TangramKit override operator % to easily construct a TGWeight object. e.g 20% is equal to TGWeight(20).

* ###TGLinearLayout
Linear layout is a single line layout view that the subviews are arranged in sequence according to the added order（from top to bottom or from left to right). So the subviews' origin&size constraints are established by the added order. Subviews arranged in top-to-bottom order is called vertical linear layout view, and 
the subviews arranged in left-to-right order is called horizontal linear layout.


![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/ll.png)

Sample code:

```swift

let rootLayout = TGLinearLayout(.vert)
rootLayout.tg_width.equal(.wrap)
rootLayout.tg_height.equal(.wrap)
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

* ###TGRelativeLayout
Relative layout is a layout view that the subviews layout and position through mutual constraints.The subviews in the relative layout are not depended to the adding order but layout and position by setting the subviews' constraints.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/rl.png)

Sample code:

```swift
let rootLayout = TGRelativeLayout()
rootLayout.tg_width.equal(.wrap)
rootLayout.tg_height.equal(.wrap)


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

* ###TGFrameLayout
Frame layout is a layout view that the subviews can be overlapped and gravity in a special location of the superview.The subviews' layout position&size is not depended to the adding order and establish dependency constraint with the superview. Frame layout devided the vertical orientation to top,vertical center and bottom, while horizontal orientation is devided to left,horizontal center and right. Any of the subviews is just gravity in either vertical orientation or horizontal orientation.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fl.png)

Sample code:

```swift
  let rootLayout = TGFrameLayout()
  rootLayout.tg_width.equal(500)
  rootLayout.tg_height.equal(500)  
  
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


* ###TGTableLayout
Table layout is a layout view that the subviews are multi-row&col arranged like a table. First you must create a rowview and add it to the table layout, then add the subview to the rowview. If the rowviews arranged in top-to-bottom order,the tableview is caled vertical table layout,in which the subviews are arranged from left to right; If the rowviews arranged in in left-to-right order,the tableview is caled horizontal table layout,in which the subviews are arranged from top to bottom.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/tl.png)

Sample code:

```swift
  let rootLayout = TGTableLayout(.vert)
  rootLayout.tg_height.equal(.wrap)
  rootLayout.tg_width.equal(500)
  
  rootLayout.tg_addRow(size:TGLayoutSize.wrap,colSize:TGLayoutSize.fill)
  
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
  
  rootLayout.tg_addRow(size:TGLayoutSize.wrap,colSize:TGLayoutSize.fill)
  
   let D = UIView()
   D.tg_width(180)
   D.tg_height(40)
   rootLayout.addSubview(D)
  
  //...E,F  
  
  
```


* ###TGFlowLayout
Flow layout is a layout view presents in multi-line that the subviews are arranged in sequence according to the added order, and when meeting with a arranging constraint it will start a new line and rearrange. The constrains mentioned here includes count constraints and size constraints. The orientation of the new line would be vertical and horizontal, so the flow layout is divided into: count constraints vertical flow layout, size constraints vertical flow layout, count constraints horizontal flow layout,  size constraints horizontal flow layout. Flow layout often used in the scenes that the subviews is  arranged regularly, it can be substitutive of UICollectionView to some extent. the TGFlowLayout is almost implement the flex-box function of the HTML/CSS.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/fll.png)

Sample code:

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


* ###TGFloatLayout
Float layout is a layout view that the subviews are floating gravity in the given orientations, when the size is not enough to be hold, it will automatically find the best location to gravity. float layout's conception is reference from the HTML/CSS's floating positioning technology, so the float layout can be designed in implementing irregular layout. According to the different orientation of the floating, float layout can be divided into left-right float layout and up-down float layout.

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/flo.png)

Sample code:

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


* ###TGViewSizeClass
TangramKit provided support to SizeClass in order to fit the different screen sizes of devices. You can combinate the SizeClass with any of the 6 kinds of layout views mentioned above to perfect fit the UI of all equipments.



## Demo sample

![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo1.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo2.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo3.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo4.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo5.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo6.gif)
![演示效果图](https://raw.githubusercontent.com/youngsoft/MyLinearLayout/master/MyLayout/layoutdemo7.gif)


##How To Get Started

 [Download TangramKit](https://github.com/youngsoft/TangramKit/archive/master.zip) 
 

##Communication


- If you need help, use Stack Overflow or Baidu. (Tag 'TangramKit')
- If you'd like to contact me, use *qq:156355113 or weibo:欧阳大哥 or email:obq0387_cn@sina.com*
- If you found a bug, and can provide steps to reliably reproduce it, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.

## Installation


TangramKit supports multiple methods for installing the library in a project.
### Copy to your project
1.  Copy `Lib` folder from the demo project to your project

### Installation with CocoaPods(does not support temporarily)

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like TangramKit in your projects. You can install it with the following command:

`$ gem install cocoapods`

To integrate TangramKit into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

pod 'TangramKit', '~> 1.0.0'
```
   
Then, run the following command:

`$ pod install`





##FAQ


* If you use TangramKit runtime cause 100% CPU usage said appeared constraint conflict, please check the subview's constraint set.


## License



TangramKit is released under the MIT license. See LICENSE for details.


##Thanks to the partners:


*闫涛:* [github](https://github.com/taoyan)
       [homepage](http://blog.csdn.net/u013928640)
*张光凯:* [github](https://github.com/loveNoodles)
        [homepage](http://blog.csdn.net/u011597585)
*周杰:*  [github](https://github.com/MineJ)
*阳光不锈:*[github](https://github.com/towik)



