//
//  AllTest9ViewController.swift
//  TangramKitDemo
//
//  Created by fzy on 2018/8/4.
//  Copyright © 2018年 youngsoft. All rights reserved.
//

import UIKit

/**
 *❁4.TangramKit & AutoLayout
 */
class AllTest10ViewController: UIViewController {
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = UIRectEdge(rawValue:0) //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor  = .white
        
        // Do any additional setup after loading the view.
        /*
         这个DEMO演示TangramKit和AutoLayout的代码结合的例子。因为布局视图也是一个普通的视图，因此可以把一个布局视图添加到现有的其他非布局父视图中并且对布局视图设置
         约束。 因为布局视图具有wrap的特性，就如UILabel一样因为具有intrinsicContentSize的能力，因此不需要在约束中明确设置宽度或者高度约束。当一个布局视图
         的高度或者宽度都是由子视图决定的，也就是尺寸的值为.wrap，布局视图也不需要明确的设置宽度或者高度的约束。而且其他视图还可以依赖这种布局视图尺寸的自包含的能力。
         
         本例子由3个子示例组成。
         
         */
        
        //容器视图包含一个垂直线性布局视图，垂直线性布局视图的尺寸由2个子视图决定，容器视图的尺寸由线性布局视图决定
        self.demo1()
        //一个线性布局视图的宽度为某个具体的约束值，高度由子视图决定。另外一个兄弟视图在线性布局视图的下面，一个兄弟视图在线性布局的右边。
        self.demo2()
        //一个水平线性布局的高度固定，宽度自适应，另外一个兄弟视图在水平线性布局视图的右边。
        self.demo3()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MAKR: -Layout Construction
extension AllTest10ViewController
{
   
    func demo1() {
        
        //容器视图包含一个垂直线性布局视图，垂直线性布局视图的尺寸由2个子视图决定，容器视图的尺寸由线性布局视图决定
        
        let containerView = UIView()
        containerView.backgroundColor = .green
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        
        let linelayout = TGLinearLayout(.vert)
        linelayout.translatesAutoresizingMaskIntoConstraints = false
        linelayout.backgroundColor = .red
        containerView.addSubview(linelayout)
        
        
        let sbv1 = UIView()
        sbv1.backgroundColor = .blue
        linelayout.addSubview(sbv1)
        let sbv2 = UIView()
        sbv2.backgroundColor = .blue
        linelayout.addSubview(sbv2)
        
        
        
        //TangramKit中的约束设置方法
        linelayout.tg_size(width: .wrap, height: .wrap)
        linelayout.tg_padding = UIEdgeInsets(top:10, left:10, bottom:10, right:10)
        linelayout.tg_space = 10
        
        sbv1.tg_size(width: 100, height: 40)
        sbv2.tg_size(width: 150, height: 50)
        
        
        
        //AutoLayout中的约束设置方法，采用iOS9提供的约束设置方法。
        if #available(iOS 9.0, *) {
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            //父视图约束依赖子视图约束会产生父视图的尺寸由子视图进行自适应的效果。
            containerView.bottomAnchor.constraint(equalTo: linelayout.bottomAnchor, constant: 10).isActive = true
            containerView.rightAnchor.constraint(equalTo: linelayout.rightAnchor, constant: 10).isActive = true
            
            //线性布局视图的宽度和高度自适应，所以不需要设置任何高度和宽度的约束。
            linelayout.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
            linelayout.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true

        } else {
            // Fallback on earlier versions
        }
 
    }
    
    func demo2() {
        
        //一个线性布局视图的宽度为某个具体的约束值，高度由子视图决定。另外一个兄弟视图在线性布局视图的下面，一个兄弟视图在线性布局的右边。
        
        let linelayout = TGLinearLayout(.vert)
        linelayout.translatesAutoresizingMaskIntoConstraints = false
        linelayout.backgroundColor = .red
        self.view.addSubview(linelayout)
        
        
        let sbv1 = UIView()
        sbv1.backgroundColor = .blue
        linelayout.addSubview(sbv1)
        let sbv2 = UIView()
        sbv2.backgroundColor = .blue
        linelayout.addSubview(sbv2)
        
        
        let brotherView1 = UIView()
        brotherView1.translatesAutoresizingMaskIntoConstraints = false
        brotherView1.backgroundColor = .green
        self.view.addSubview(brotherView1)
        let brotherView2 = UIView()
        brotherView2.translatesAutoresizingMaskIntoConstraints = false
        brotherView2.backgroundColor = .green
        self.view.addSubview(brotherView2)
        
        
        
        //TangramKit中的约束设置方法
        linelayout.tg_height.equal(.wrap)
        linelayout.tg_padding = UIEdgeInsets(top:10, left:10, bottom:10, right:10)
        linelayout.tg_space = 10
        
        sbv1.tg_size(width: 100, height: 40)
        sbv2.tg_size(width: 150, height: 50)
        
        
        
        //AutoLayout中的约束设置方法，采用iOS9提供的约束设置方法。
        if #available(iOS 9.0, *) {
            
            //线性布局视图的宽度和高度自适应，所以不需要设置任何高度约束。
            linelayout.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            linelayout.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 180).isActive = true
            
            //当布局视图的高度由子视图自适应且宽度为autolayout约束时，目前只支持对布局视图设置明确宽度约束才有效。
            //同时设置左右边界约束来推导布局视图宽度，并且高度又自适应目前不支持。
            linelayout.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -150).isActive = true
            
            brotherView1.leftAnchor.constraint(equalTo: linelayout.leftAnchor).isActive = true
            brotherView1.topAnchor.constraint(equalTo: linelayout.bottomAnchor, constant:10).isActive = true
            brotherView1.widthAnchor.constraint(equalTo:linelayout.widthAnchor).isActive = true
            brotherView1.heightAnchor.constraint(equalTo: linelayout.heightAnchor).isActive = true
            
            
            brotherView2.leftAnchor.constraint(equalTo: linelayout.rightAnchor,constant:10).isActive = true
            brotherView2.topAnchor.constraint(equalTo: linelayout.topAnchor).isActive = true
            brotherView2.widthAnchor.constraint(equalToConstant: 50).isActive = true
            brotherView2.heightAnchor.constraint(equalTo: linelayout.heightAnchor).isActive = true
            
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func demo3() {
        
        let linelayout = TGLinearLayout(.horz)
        linelayout.translatesAutoresizingMaskIntoConstraints = false
        linelayout.backgroundColor = .red
        self.view.addSubview(linelayout)
        
        
        let sbv1 = UIView()
        sbv1.backgroundColor = .blue
        linelayout.addSubview(sbv1)
        let sbv2 = UIView()
        sbv2.backgroundColor = .blue
        linelayout.addSubview(sbv2)
        
        
        let brotherView1 = UIView()
        brotherView1.translatesAutoresizingMaskIntoConstraints = false
        brotherView1.backgroundColor = .green
        self.view.addSubview(brotherView1)
        
        
        //MyLayout中的约束设置
        linelayout.tg_width.equal(.wrap)
        linelayout.tg_padding = UIEdgeInsets(top:10, left:10, bottom:10, right:10)
        linelayout.tg_space = 10
        linelayout.tg_gravity = TGGravity.vert.fill
        
        sbv1.tg_width.equal(50)
        sbv2.tg_width.equal(60)
        
        //AutoLayout中的约束设置方法，采用iOS9提供的约束设置方法。
        if #available(iOS 9.0, *) {
            
            //AutoLayout中的约束设置
            linelayout.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            linelayout.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 500).isActive = true
            linelayout.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            
            brotherView1.leftAnchor.constraint(equalTo: linelayout.rightAnchor, constant: 10).isActive = true
            brotherView1.topAnchor.constraint(equalTo: linelayout.topAnchor).isActive = true
            brotherView1.widthAnchor.constraint(equalTo:linelayout.widthAnchor).isActive = true
            brotherView1.heightAnchor.constraint(equalTo: linelayout.heightAnchor).isActive = true
        }else {
            // Fallback on earlier versions
        }
        
    }
    
}

