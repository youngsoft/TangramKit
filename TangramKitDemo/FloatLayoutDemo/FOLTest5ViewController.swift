//
//  FOLTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *5.FloatLayout - Title & Description
 */
class FOLTest5ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
            这个DEMO用浮动布局来实现图文结合的一些场景，这也是浮动布局擅长做的事情。
        */
        
        let scrollView = UIScrollView(frame:self.view.bounds)
        scrollView.backgroundColor = .white
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(scrollView)
        
        
        let titles = [NSLocalizedString("TGLinearLayout:",comment:""),
                      NSLocalizedString("TGTableLayout:",comment:""),
                      NSLocalizedString("TGFrameLayout:",comment:""),
                      NSLocalizedString("TGRelativeLayout:",comment:""),
                      NSLocalizedString("TGFlowLayout:",comment:""),
                      NSLocalizedString("TGFloatLayout:",comment:""),
                      "SIZECLASS:"
        ]
        
        let descs = [NSLocalizedString("Linear layout is a single line layout view that the subviews are arranged in sequence according to the added order（from top to bottom or from left to right). So the subviews' origin&size constraints are established by the added order. Subviews arranged in top-to-bottom order is called vertical linear layout view, and the subviews arranged in left-to-right order is called horizontal linear layout.", comment:""),
                     NSLocalizedString("Table layout is a layout view that the subviews are multi-row&col arranged like a table. First you must create a rowview and add it to the table layout, then add the subview to the rowview. If the rowviews arranged in top-to-bottom order,the tableview is caled vertical table layout,in which the subviews are arranged from left to right; If the rowviews arranged in in left-to-right order,the tableview is caled horizontal table layout,in which the subviews are arranged from top to bottom.", comment:""),
                     
                     NSLocalizedString("Frame layout is a layout view that the subviews can be overlapped and gravity in a special location of the superview.The subviews' layout position&size is not depended to the adding order and establish dependency constraint with the superview. Frame layout devided the vertical orientation to top,vertical center and bottom, while horizontal orientation is devided to left,horizontal center and right. Any of the subviews is just gravity in either vertical orientation or horizontal orientation.", comment:""),
                     
                     NSLocalizedString("Relative layout is a layout view that the subviews layout and position through mutual constraints.The subviews in the relative layout are not depended to the adding order but layout and position by setting the subviews' constraints.", comment:""),
                     NSLocalizedString("Flow layout is a layout view presents in multi-line that the subviews are arranged in sequence according to the added order, and when meeting with a arranging constraint it will start a new line and rearrange. The constrains mentioned here includes count constraints and size constraints. The orientation of the new line would be vertical and horizontal, so the flow layout is divided into: count constraints vertical flow layout, size constraints vertical flow layout, count constraints horizontal flow layout,  size constraints horizontal flow layout. Flow layout often used in the scenes that the subviews is  arranged regularly, it can be substitutive of UICollectionView to some extent.", comment:""),
                     NSLocalizedString("Float layout is a layout view that the subviews are floating gravity in the given orientations, when the size is not enough to be hold, it will automatically find the best location to gravity. float layout's conception is reference from the HTML/CSS's floating positioning technology, so the float layout can be designed in implementing irregular layout. According to the different orientation of the floating, float layout can be divided into left-right float layout and up-down float layout.", comment:""),
                     NSLocalizedString("MyLayout provided support to SIZECLASS in order to fit the different screen sizes of devices. You can combinate the SIZECLASS with any of the 6 kinds of layout views mentioned above to perfect fit the UI of all equipments.", comment:"")
        ];
        
        

        let rootLayout = TGFloatLayout(.vert)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_vspace = 5
        scrollView.addSubview(rootLayout)
        
        
        let label = UILabel()
        label.text = "TangramKit Introduction："
        label.font = CFTool.font(17)
        label.textColor = CFTool.color(4)
        label.sizeToFit()
        rootLayout.addSubview(label)
        
        let label2 = UILabel()
        label2.text = NSLocalizedString("TangramKit is a powerful view layout library, it support 6 kinds of layout views and SIZECLASS.", comment: "")
        label2.textColor = CFTool.color(3)
        label2.font = CFTool.font(15)
        label2.tg_width.equal(.fill)
        label2.tg_height.equal(.wrap)
        label2.tg_clearFloat = true
        rootLayout.addSubview(label2)

        let images = ["image1", "image2", "image3", "image4"]
        for i in 0..<images.count {
            let imageView = UIImageView(image: UIImage(named: images[i]))
            imageView.tg_width.equal(rootLayout.tg_width, multiple: 1.0 / CGFloat(images.count))
            imageView.tg_height.equal(imageView.tg_width)
            rootLayout.addSubview(imageView)
        }

        for i in 0 ..< titles.count
        {
            let titleLabel = UILabel()
            titleLabel.text = titles[i];
            titleLabel.textColor = CFTool.color(i + 1)
            titleLabel.font = CFTool.font(15)
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.tg_clearFloat = true;     //换行重新布局。
            titleLabel.tg_width.equal(25%) //宽度是父视图宽度的1/4
            titleLabel.sizeToFit()
            rootLayout.addSubview(titleLabel)
            
            let descLabel = UILabel()
            descLabel.text = descs[i];
            descLabel.textColor = CFTool.color(4)
            descLabel.font = CFTool.font(13)
            descLabel.tg_width.equal(100%)      //占用剩余的宽度
            descLabel.tg_height.equal(.wrap)
            rootLayout.addSubview(descLabel)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

