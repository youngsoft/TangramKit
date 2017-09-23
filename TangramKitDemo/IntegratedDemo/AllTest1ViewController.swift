//
//  AllTest1ViewController.swift
//  TangramKit
//
//  Created by zhangguangkai on 16/5/9.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


/**
 *1.UITableView - Dynamic height
 */
class AllTest1ViewController: UITableViewController {

    
    var imageHiddenFlags:[Bool] = [Bool]()  //动态数据记录图片是否被隐藏的标志数组。
    
    lazy var datas:[AllTest1DataModel] =
    {
        var _datas = [AllTest1DataModel]()
        
        let headImages = ["head1","head2","minions1","minions4"]
        let nickNames = ["欧阳大哥","醉里挑灯看键","张三","李四"]
        
        let textMessages = ["",
                            NSLocalizedString("a single line text", comment:""),
                            NSLocalizedString("This Demo is used to introduce the solution when use layout view to realize the UITableViewCell's dynamic height. We only need to use the layout view's tg_sizeThatFits method to evaluate the size of the layout view. and you can touch the Cell to shrink the height when the Cell has a picture.", comment:""),
                            NSLocalizedString("Through layout view's tg_sizeThatFits method can assess a UITableViewCell dynamic height.tg_sizeThatFits just to evaluate layout size but not set the size of the layout. here don't preach the width of 0 is the cause of the above UITableViewCell set the default width is 320 (regardless of any screen), so if we pass the width of 0 will be according to the width of 320 to evaluate UITableViewCell dynamic height, so when in 375 and 375 the width of the assessment of height will not be right, so here you need to specify the real width dimension;And the height is set to 0 mean height is not a fixed value need to evaluate. you can use all type layout view to realize UITableViewCell.", comment:""),
                            NSLocalizedString("This section not only has text but also hav picture. and picture below at text, text will wrap", comment:"")
        ]
        
        let imageMessages = ["", "image1", "image2","image3"]
        
        for _ in 0 ..< 30
        {
            
            var model = AllTest1DataModel()
            model.headImage = headImages[Int(arc4random_uniform(UInt32(headImages.count)))]
            model.nickName = nickNames[Int(arc4random_uniform(UInt32(nickNames.count)))]
            model.textMessage = textMessages[Int(arc4random_uniform(UInt32(textMessages.count)))]
            model.imageMessage = imageMessages[Int(arc4random_uniform(UInt32(imageMessages.count)))]
            
            _datas.append(model)
        }
        
        return _datas
    }()

    
    var titleLabel:UILabel! = nil
    var displayLink:CADisplayLink!=nil;
    var count:Int = 0
    var lastTime:TimeInterval = 0.0
    @objc func tick(sender:CADisplayLink)
    {
       
            if (self.lastTime == 0) {
                self.lastTime = sender.timestamp
                return
            }
            
            self.count += 1
            let  delta = sender.timestamp - self.lastTime
            if (delta < 1)
            {
                return
        }
            self.lastTime = sender.timestamp
            let fps = Double(self.count) / delta
            self.count = 0
        
            
        
        self.titleLabel.text = "\(round(fps)) FPS"
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(tick))
        self.displayLink.add(to:.main, forMode: .commonModes)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.displayLink.invalidate()
        self.displayLink = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.titleLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 80, height: 40))
        self.navigationItem.titleView = self.titleLabel
        
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // 注意这里。为了达到动态高度UITableviewCell的加载性能最高以及高性能，一定要设置estimatedRowHeight这个属性。这个属性用来评估
        //UITableViewCell的高度。如果实现了这个方法，系统会根据数量重复调用这个方法，得出评估的总体高度。然后再根据显示的需要调用tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)方法来确定真实的高度。如果您不设置estimatedRowHeight，加载性能将非常的低下！！！！
        //如果不同的cell有差异那么可以通过实现协议方法tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath)来定制化
        self.tableView.estimatedRowHeight = 60
        
        //设置所有cell的高度为高度自适应，如果cell高度是动态的请这么设置。 如果不同的cell有差异那么可以通过实现协议方法tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)来定制化处理。
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //不仅是UITableviewCell的高度可以自适应，sectionHeader以及sectionFooter也一样的可以实现自适应高度，您同样的可以用相似的方法来进行处理。
        
        self.tableView.separatorStyle = .none
        self.tableView.register(AllTest1TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerfooterview")
        self.tableView.register(AllTest1TableViewCell.self, forCellReuseIdentifier: "alltest1_cell")
        
        //初始化所有图片为未隐藏状态
        for _ in 0 ..< self.datas.count
        {
            self.imageHiddenFlags.append(false)
        }
        
        /**
         布局视图和UITableView的结合可以很简单的实现静态和动态高度的UITableViewCell。以及tableview的section,tableheaderfooter部分使用布局视图的方法
         */
        
        
        /*
         将一个布局视图作为UITableView的tableHeaderView或者tableFooterView时，因为其父视图是非布局视图，因此需要明确的指明宽度和高度，这个可以用frame来设置。比如：
         
         tableHeaderViewLayout.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 100)
         
         而如果某个布局视图的高度有可能是动态的高度，也就是用了tg_height为.wrap时，可以不用指定明确的指定高度，但要指定宽度。而且在布局视图添加到self.tableView.tableHeaderView 之前一定要记得调用：
         tableHeaderViewLayout.layoutIfNeeded()
         
         */

        self.createTableHeaderView()
        self.createTableFooterView()
        
        //经测试发现如果你没有指定footerview时，如果使用动态高度，而且又实现了estimatedHeightForRowAtIndexPath方法来评估高度，那么有可能在操作某些cell时
        //会出现cell高度变化时(本例子是隐藏显示图片)会闪动，解决问题的方法就是建立一个0高度的tableFooterView，也就是上下面的方法。
        //您可以把：    self.createTableFooterView() 注释掉，然后把下面这句解注释看看效果。
        // self.tableView.tableFooterView = UIView()

    }
    
    
    func createTableHeaderView() {
        //这个例子用来构建一个自适应高度的头部布局视图。
        let tableHeaderViewLayout = TGLinearLayout(.vert)
        tableHeaderViewLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        tableHeaderViewLayout.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 0) //这里没有设置高度，但设置了明确的宽度
        //高度不确定可以设置为0。尽量不要在代码中使用kScreenWidth,kScreenHeight，SCREEN_WIDTH。之类这样的宏来设定视图的宽度和高度。要充分利用Tangram的特性，减少常数的使用。
        tableHeaderViewLayout.tg_width.equal(.fill) //这里注意设置宽度和父布局保持一致。
        tableHeaderViewLayout.tg_height.equal(.wrap)
        tableHeaderViewLayout.tg_backgroundImage = UIImage(named: "bk1")
        //为布局添加触摸事件。
        tableHeaderViewLayout.tg_setTarget(self, action: #selector(handleTableHeaderViewLayoutClick), for:.touchUpInside)
        
        let label1 = UILabel()
        label1.text = NSLocalizedString("add tableHeaderView(please touch me)", comment: "")
        label1.textColor = CFTool.color(0)
        label1.font = CFTool.font(17)
        label1.tag = 1000
        label1.textColor = UIColor.white
        label1.font = UIFont.systemFont(ofSize: 17)
        label1.tg_centerX.equal(0)
        label1.sizeToFit()
        tableHeaderViewLayout.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = NSLocalizedString(" if you use layout view to realize the dynamic height tableHeaderView, please use frame to set view's width and use wrapContentHeight to set view's height. the layoutIfNeeded method is needed to call before the layout view assignment to the UITableview's tableHeaderView.", comment: "")
        label2.textColor = CFTool.color(4)
        label2.font = CFTool.font(15)
        label2.tg_leading.equal(5)
        label2.tg_trailing.equal(5)
        label2.tg_height.equal(.wrap)
        label2.tg_top.equal(10)
        
        tableHeaderViewLayout.addSubview(label2)
        tableHeaderViewLayout.layoutIfNeeded() //因为高度是.wrap的，所以这里必须要在加入前执行这句！！！ 原因是tableHeaderView必须要明确的指定frame。所以通过layoutIfNeeded来算出真实视图真实的frame值。因为tableHeaderViewLayout这时候并没有父视图，所以这里必须要明确的通过frame指定宽度，这样最终的计算结果才正确。
        
        self.tableView.tableHeaderView = tableHeaderViewLayout
        
        weak var weakTableview = self.tableView
        
        //因为tableHeaderViewLayout的高度是通过layoutIfNeed来确定的。因此在屏幕旋转时我们需要手动再次调整tableHeaderViewLayout的frame值。
        //因此您需要实现这个block来实现当布局视图在横竖屏切换时的frame的动态更新。。。
        //注意这个block不会只执行一次，而是长期存在，因此要注意block内对象的引用的问题。
        tableHeaderViewLayout.tg_rotationToDeviceOrientationDo { (_, isFirst:Bool, _ ) in
            if !isFirst
            {
                weakTableview?.tableHeaderView?.layoutIfNeeded()
                weakTableview?.tableHeaderView = weakTableview?.tableHeaderView
            }
        }
    }
    
    
    func createTableFooterView() {
        //这个例子用来构建一个固定高度的尾部布局视图。
        let tableFooterViewLayout = TGLinearLayout(.vert)
        tableFooterViewLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        tableFooterViewLayout.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 80) ////这里明确设定高度。
        tableFooterViewLayout.tg_width.equal(.fill) //这里注意设置宽度和父布局保持一致。
        tableFooterViewLayout.backgroundColor = CFTool.color(6)
        tableFooterViewLayout.tg_gravity = [TGGravity.vert.center, TGGravity.horz.fill]
        
        let label3 = UILabel()
        label3.text = NSLocalizedString("add tableFooterView", comment: "")
        label3.textColor = CFTool.color(4)
        label3.font = CFTool.font(16)
        label3.textAlignment = .center
        label3.sizeToFit()
        tableFooterViewLayout.addSubview(label3)
        
        let label4 = UILabel()
        label4.text = NSLocalizedString("the layoutIfNeeded is not need to call when you use frame to set layout view's size", comment: "")
        label4.textColor = CFTool.color(3)
        label4.font = CFTool.font(14)
        label4.textAlignment = .center
        label4.tg_top.equal(10)
        label4.adjustsFontSizeToFitWidth = true
        label4.sizeToFit()
        tableFooterViewLayout.addSubview(label4)
        
        self.tableView.tableFooterView = tableFooterViewLayout  //这里尺寸固定因此不需要调用layoutIfNeeded
       
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerFooterView:AllTest1TableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerfooterview") as! AllTest1TableViewHeaderFooterView
        
        headerFooterView.itemChangedAction = {(index:Int) in
            
            let message = "You have select index:\(index)"
            UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "OK").show()
            
        }
        
        return headerFooterView;
        
        
    }
 
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    /*
      //如果每个cell的评估尺寸都是一样的那么你可以直接设置tableview.estimatedRowHeight的值。如果不同的cell的评估高度不一致那么请实现这个委托方法。
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // 注意这里。为了达到动态高度TableViewCell的加载性能最高以及高性能，一定要实现estimatedHeightForRowAtIndexPath这个方法。这个方法用来评估
        //UITableViewCell的高度。如果实现了这个方法，系统会根据数量重复调用这个方法，得出评估的总体高度。然后再根据显示的需要调用heightForRowAtIndexPath方法来确定真实的高度。如果您不实现estimatedHeightForRowAtIndexPath这个方法，加载性能将非常的低下！！！！
        return 60;  //这个评估尺寸你可以根据你的cell的一般高度来设置一个最合适的值。
    }
    */
    
    /*
     //如果您的不同的cell里面有一些是高度自适应的，而有一些则是静态高度那么就需要实现这个函数即可，否则你可以直接设置tableview的rowHeight属性。
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
     return UITableViewAutomaticDimension
     
     }
     */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:AllTest1TableViewCell = tableView.dequeueReusableCell(withIdentifier: "alltest1_cell", for:indexPath) as! AllTest1TableViewCell
        
        let model = self.datas[indexPath.row]
        
        cell.setModel(model: model,isImageMessageHidden:self.imageHiddenFlags[indexPath.row])
        
        //这里设置其他位置有间隔线而最后一行没有下划线。我们可以借助布局视图本身所提供的边界线来代替掉系统默认的cell之间的间隔线，因为布局视图的边界线所提供的能力要大于默认的间隔线。
        if (indexPath.row  == self.datas.count - 1)
        {
            cell.rootLayout.tg_bottomBorderline = nil;
        }
        else
        {
            let bld = TGBorderline(color:UIColor.red)
            cell.rootLayout.tg_bottomBorderline = bld;
        }
        
        
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.imageHiddenFlags[indexPath.row] = !self.imageHiddenFlags[indexPath.row]
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
    @objc func handleTableHeaderViewLayoutClick(sender:TGBaseLayout!)
    {
        if  let label1 = sender.viewWithTag(1000)
        {
            if label1.tg_visibility == .visible
            {
                label1.tg_visibility = .gone
            }
            else
            {
                label1.tg_visibility = .visible
            }
            
            UIView.animate(withDuration: 0.3) {
                self.tableView.tableHeaderView?.layoutIfNeeded()
                self.tableView.tableHeaderView = self.tableView.tableHeaderView
            }
        }
    }

    
    
}
