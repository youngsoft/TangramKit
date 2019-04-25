//
//  AllTest7ViewController.swift
//  TangramKit
//
//  Created by apple on 16/10/17.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



/**
 *❁1.Screen perfect fit - Demo1
 */
class AllTest7ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        /**
         * 这个例子主要是用线性布局来实现一些在各种屏幕尺寸下内容适配的场景，通过各种属性的设置，我们可以不需要写if，else等判断屏幕的条件，而是直接根据属性来设置就能达到我们想要的效果，并且能在各种屏幕尺寸以及横竖屏下的具有完美适配的能力。下面的8个例子是在实践中会遇到的一些需要适配的场景。
         */
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        self.view = scrollView
        
        let  rootLayout = TGLinearLayout(.vert)
        rootLayout.tg_width.equal(.fill)
        rootLayout.tg_height.equal(.wrap)
        rootLayout.tg_gravity = TGGravity.horz.fill
        scrollView.addSubview(rootLayout)
        
        let tipLabel = UILabel()
        tipLabel.text = "在编程中，我们经常会遇到一些需要在各种屏幕下完美适配的界面，一个解决的方法就是写if else语句在不同的屏幕尺寸下进行不同的设置。而TangramKit则提供了一套完美的解决方案，除了支持Size Classes外，布局本身也提供一些机制来支持多种屏幕适配处理，您不再需要编写各种条件语句来进行屏幕尺寸的适配了，下面的例子里面我列举出了我们在实践中会遇到的10种场景："
        tipLabel.font = CFTool.font(16)
        tipLabel.textColor = CFTool.color(3)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        self.createDemo1(rootLayout)
        self.createDemo2(rootLayout)
        self.createDemo3(rootLayout)
        self.createDemo4(rootLayout)
        self.createDemo5(rootLayout)
        self.createDemo6(rootLayout)
        self.createDemo7(rootLayout)
        self.createDemo8(rootLayout)
        self.createDemo9(rootLayout)
        self.createDemo10(rootLayout)
        self.createDemo11(rootLayout)
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

//MARK: Layout Construction
extension AllTest7ViewController
{
    func createDemo1(_ rootLayout: TGLinearLayout) {
        //一行内，多个子视图从左往右排列。如果在小屏幕下显示则会压缩所有子视图的空间，如果能够被容纳的话则正常显示。
        //具体的实现方法是用一个水平线性布局来做容器，然后子视图依次添加，然后最后一个子视图的右间距设置为浮动间距即可。因为线性布局内部对于那些有浮动间距的情况下，如果那些固定尺寸的子视图的总宽度超过布局视图的宽度时就会自动压缩这些固定尺寸的子视图。
        let tipLabel = UILabel()
        tipLabel.text = "1.下面的例子实现一行内多个子视图从左往右排列。如果在小屏幕下显示则会压缩所有子视图的空间，如果能够被容纳的话则正常显示。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_hspace = 5
        contentLayout.tg_shrinkType = .weight
        //这个属性用来设置当子视图的总尺寸大于布局视图的尺寸时如何压缩这些具有固定尺寸的方法为按比例缩小。您可以分别试试设置为：.weight,.average,.auto,.none四种值的效果。
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        
        //第一个子视图。
        let label1 = UILabel()
        label1.text = "不压缩子视图"
        label1.font = CFTool.font(16)
        label1.backgroundColor = CFTool.color(5)
        label1.adjustsFontSizeToFitWidth = true
        label1.tg_height.equal(.wrap)
        label1.tg_width.equal(.wrap).min(label1.tg_width) //并且最小宽度也等于自己，这样设置的话可以保证这个视图永远不会被压缩。您可以注释掉这句看看效果。
        contentLayout.addSubview(label1)
        
        //第二个子视图。
        let label2 = UILabel()
        label2.text = "被压缩子视图"
        label2.font = CFTool.font(16)
        label2.backgroundColor = CFTool.color(6)
        label2.adjustsFontSizeToFitWidth = true
        label2.tg_width.equal(.wrap)
        label2.sizeToFit()
        contentLayout.addSubview(label2)

        //第三个子视图。
        let label3 = UILabel()
        label3.text = "您可以分别在各种设备上测试"
        label3.font = CFTool.font(15)
        label3.backgroundColor = CFTool.color(7)
        label3.adjustsFontSizeToFitWidth = true
        label3.tg_height.equal(.wrap)
        label3.tg_width.equal(.wrap)
        contentLayout.addSubview(label3)
        
        //这句设置非常重要，设置为右间距为相对间距，从而达到如果屏幕小则会缩小固定尺寸，如果大则不会的效果。
        label3.tg_trailing.equal(100%)
    }
    
    func createDemo2(_ rootLayout: TGLinearLayout) {
        //一行内某一个子视图内容拉升其他内容固定。也就是某个子视图的内容将占用剩余的空间。
        let tipLabel = UILabel()
        tipLabel.text = "2.下面的例子里面最右边的两个子视图的宽度是固定的，而第一个子视图则占用剩余的空间。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_hspace = 5
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        
        //第一个子视图。
        let label1 = UILabel()
        label1.text = "第一个子视图的宽度是占用整个屏幕的剩余空间，您可以切换屏幕和设备查看效果"
        label1.font = CFTool.font(15)
        label1.backgroundColor = CFTool.color(5)
        label1.tg_height.equal(.wrap)
        label1.tg_width.equal(.fill)
        label1.adjustsFontSizeToFitWidth = true
        contentLayout.addSubview(label1)
        
        //第二个子视图。
        let label2 = UILabel()
        label2.text = "第二个子视图"
        label2.font = CFTool.font(15)
        label2.backgroundColor = CFTool.color(6)
        label2.sizeToFit()
        contentLayout.addSubview(label2)
        
        //第三个子视图。
        let label3 = UILabel()
        label3.text = "第三个子视图"
        label3.font = CFTool.font(15)
        label3.backgroundColor = CFTool.color(7)
        label3.sizeToFit()
        contentLayout.addSubview(label3)
    }
    
    
    @objc func handleAdd(_ sender: UIButton) {
        
        let label1 = sender.superview!.viewWithTag(1000) as! UILabel
        label1.text = label1.text!.appending("/您好！")
    }
    
    @objc func handleDel(_ sender: UIButton) {
        
        let label1 = sender.superview!.viewWithTag(1000) as! UILabel
        label1.text = "/您好！"
    }
    
    func createDemo3(_ rootLayout: TGLinearLayout) {
        //某一些子视图的宽度固定，而剩余的一个子视图的宽度最宽不能超过屏幕的宽度。
        let tipLabel = UILabel()
        tipLabel.text = "3.下面的例子里面最右边的两个子视图的宽度是固定的，而第一个子视图的尺寸动态变化，但是最宽不能超过布局剩余的宽度。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上分别测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        tipLabel.sizeToFit()
        rootLayout.addSubview(tipLabel)
        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_hspace = 5
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        
        //第一个子视图。
        let label1 = UILabel()
        label1.text = "点击右边的按钮："
        label1.font = CFTool.font(14)
        label1.backgroundColor = CFTool.color(5)
        label1.adjustsFontSizeToFitWidth = true
        label1.tag = 1000 //为了测试用。。
        label1.tg_height.equal(.wrap)
        label1.tg_width.equal(.wrap)
        label1.tg_trailing.equal(50%)
        contentLayout.addSubview(label1)
        
        //第二个子视图。
        let button2 = UIButton(type: .system)
        button2.setTitle("Add Click", for: .normal)
        button2.tintColor! = UIColor.blue
        button2.titleLabel!.font = CFTool.font(14)
        button2.sizeToFit()
        button2.tg_leading.equal(50%)//设置相对间距。
        contentLayout.addSubview(button2)
        button2.addTarget(self, action: #selector(self.handleAdd), for: .touchUpInside)
        
        //第三个子视图。
        let button3 = UIButton(type: .system)
        button3.setTitle("Del Click", for: .normal)
        button3.tintColor! = UIColor.red
        button3.titleLabel!.font = CFTool.font(14)
        button3.sizeToFit()
        contentLayout.addSubview(button3)
        button3.addTarget(self, action: #selector(self.handleDel), for: .touchUpInside)
        //因为button2,和button3的宽度是固定的，因此这里面label1的最大宽是父视图的宽度减去2个按钮的宽度之和，外加上所有子视图的间距的和。
        
        label1.tg_width.max(contentLayout.tg_width, increment: -1*(button2.bounds.width + button3.bounds.width + 2 * contentLayout.tg_hspace))
        
    }
    
    
    @objc func handleChangeText(_ sender: UIButton) {
    
         let texts = ["这是一段很长的文本，目的是为了实现最大限度的利用整个空间而不出现多余的缝隙","您好","北京市朝阳区三里屯SOHO城","我是醉里挑灯看键","欧阳大哥","Tangram是一套功能强大的综合界面布局库"]
        
        
        let  layout = sender.superview!.viewWithTag(4000)
        let leftLabel = layout!.viewWithTag(1000) as! UILabel
        let rightLabel = layout!.viewWithTag(2000) as! UILabel
        
        leftLabel.text = texts[Int(arc4random_uniform(UInt32(texts.count)))];
        rightLabel.text = texts[Int(arc4random_uniform(UInt32(texts.count)))];
        layout!.setNeedsLayout()  //设置文本后激活布局重新布局
        
        
    }
    
    func createDemo4(_ rootLayout: TGLinearLayout) {
        //左右两个子视图宽度不确定，但是不会覆盖和重叠。
        let tipLabel = UILabel()
        tipLabel.text = "4.下面的例子展示左右2个子视图的内容分别向两边延伸，但是不会重叠。这样做的好处就是不会产生空间的浪费。一个具体例子就是UITableviewCell中展示内容时，一部分在左边而一部分在右边，两边的内容长度都不确定，但是不能重叠以及浪费空间。 您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        let changeButton = UIButton(type:.system)
        changeButton.setTitle("Change Text",for:.normal)
        changeButton.sizeToFit()
        rootLayout.addSubview(changeButton)
        changeButton.addTarget(self,action:#selector(handleChangeText),for:.touchUpInside)

        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_hspace = 20
        contentLayout.tg_shrinkType = .auto
        //为了实现左右两边文本的自动缩放调整，必须要将线性布局的属性设置.auto。当设置为.auto属性时，必要要满足当前子视图中只有2个子视图的宽度设置为等于自身内容，否则无效。这个属性用来实现左右2个子视图根据内容来占用最佳的空间的例子。
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        contentLayout.tag = 4000
        
        //您可以解开如下注释再看看运行的效果。
        /*
         let fixedLabel = UILabel()
         fixedLabel.tg_width.equal(40)
         fixedLabel.tg_height.equal(30)
         fixedLabel.backgroundColor = .orange
         contentLayout.addSubview(fixedLabel)
         */
        
        //左边子视图。
        let leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        leftLabel.textColor = .red
        leftLabel.tg_width.equal(.wrap)//设置宽度等于自身内容的宽度
        leftLabel.tg_height.equal(.wrap)
        leftLabel.tg_trailing.equal(50%) //设置右边的相对间距.
        contentLayout.addSubview(leftLabel)
        leftLabel.tag = 1000;
        
        
        //右边子视图。
        let rightLabel = UILabel()
        rightLabel.font = UIFont.systemFont(ofSize: 14)
        rightLabel.textColor = .blue
        rightLabel.tg_width.equal(.wrap)  //设置宽度等于自身内容的宽度
        rightLabel.tg_height.equal(.wrap)
        rightLabel.tg_leading.equal(50%) //设置左边的相对间距.
        contentLayout.addSubview(rightLabel)
        rightLabel.tag = 2000
        
        
        self.handleChangeText(changeButton)

    }
    
    
    /*
     * 下面这个DEMO实现子视图之间的间距压缩，来达到最完美的适配。
     */
    
    @objc func handleAddButton(_ sender: UIButton) {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 0.5
        button.layer.borderColor = CFTool.color(5).cgColor
        button.setTitle("Del", for: .normal)
        button.tintColor! = CFTool.color(0)
        button.backgroundColor = CFTool.color(2)
        button.addTarget(self, action: #selector(self.handleDelButton), for: .touchDownRepeat)
        button.tg_height.equal(40)
        sender.superview!.addSubview(button)
    }
    
    @objc func handleDelButton(_ sender: UIButton) {
        sender.removeFromSuperview()
    }
    
    func createDemo5(_ rootLayout: TGLinearLayout) {
        //一行内添加多个视图，并在子视图具有固定宽度的情况下，将子视图之间的间距调整为最优，以便最完美的放置子视图。
        let tipLabel = UILabel()
        tipLabel.text = "5.下面的例子中(响应式布局！！)，您可以添加按钮来添加多个按钮形成多行多列的布局。在不同的屏幕尺寸下，子视图之间的间距会自动调整以便满足最佳的布局状态。比如多个子视图有规律排列，每个子视图的宽度是固定的，在iPhone4下以及iPhone6下都能放置4个子视图，但是iPhone4中子视图之间的间距要比iPhone6上的小，而在iPhone6+上则因为空间足够可以放置5个子视图。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        let  subviewWidth: CGFloat = 60 //您可以修改这个宽度值，可以看出不管宽度设置多大都能完美的填充整个屏幕，因为系统会自动调整子视图之间的间距。
        let contentLayout = TGFlowLayout(.vert, arrangedCount:0)
        contentLayout.backgroundColor = CFTool.color(0)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_vspace = 5 //设置流式布局里面子视图之间的垂直间距。
        contentLayout.tg_setSubviews(size: subviewWidth, minSpace: 5, maxSpace:10) //这里面水平间距用浮动间距，浮动间距设置为子视图固定宽度为60，最小的间距为5,最大间距为10。注意这里要求所有子视图的宽度都是60。
        rootLayout.addSubview(contentLayout)
        
        
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 0.5
        button.layer.borderColor = CFTool.color(6).cgColor
        button.setTitle("Add", for: .normal)
        button.backgroundColor = CFTool.color(1)
        button.tintColor! = CFTool.color(0)
        button.addTarget(self, action: #selector(self.handleAddButton), for: .touchUpInside)
        button.tg_height.equal(30)
        contentLayout.addSubview(button)
    }
    
    
    /*
     * 下面这个DEMO实现子视图之间的尺寸压缩，来达到最完美的适配。
     */
    
    @objc func handleAddCell(_ sender: UIButton) {
        //在创建时指定了6000.所以这里为了方便使用。
        let tableLayout = sender.superview!.viewWithTag(6000) as! TGTableLayout
        let cellLabel = UILabel()
        cellLabel.text = "测试文本"
        cellLabel.adjustsFontSizeToFitWidth = true
        cellLabel.font = CFTool.font(15)
        cellLabel.backgroundColor = CFTool.color(Int(arc4random()) % 14 + 1)
        cellLabel.tg_width.equal(80) //宽度是80
        cellLabel.tg_trailing.equal(100%) //右间距占用剩余的空间。
        cellLabel.sizeToFit()
        
        //如果还没有行则建立第一行，这里的行高是由子视图决定，而列宽则是和表格视图保持一致，但是子视图还需要设置单元格的宽度。
        if tableLayout.tg_rowCount == 0 {
            tableLayout.tg_addRow(size:TGLayoutSize.wrap, colSize: TGLayoutSize.fill).tg_shrinkType = .average
        }
        
        /*
         取到最后一行的最后一个单元格视图。
         */
        var lastView: UIView? = nil
        let lastRowIndex = tableLayout.tg_rowCount - 1
        if tableLayout.tg_colCount(inRow: lastRowIndex) > 0 {
            lastView = tableLayout.tg_colView(at: IndexPath(row:lastRowIndex, col:tableLayout.tg_colCount(inRow: lastRowIndex) - 1))
        }
        //如果有最后一个单元格视图。那么判断这个单元格视图的宽度是不是小于40，如果是则新建立一行。这样当一行内所有的单元格的宽度都小于40时就会自动换行。
        if lastView != nil {
            if lastView!.bounds.width <= 60 {
                tableLayout.tg_addRow(size:TGLayoutSize.wrap, colSize: TGLayoutSize.fill).tg_shrinkType = .average
            }
            else {
                lastView!.tg_trailing.equal(nil)
                //因为新添加的单元格视图的右边是相对间距，也就是占用剩余空间，因此这里要把最后一个单元的右间距清空，这样就不会造成有多个单元格的右间距占用剩余空间。注意理解一下这里的设置！！！。
            }
        }
        tableLayout.addSubview(cellLabel)
        //表格布局重载了addSubview，他总是在最后一行上添加新的单元格。
    }
    
    func createDemo6(_ rootLayout: TGLinearLayout) {
        //一行多列，然后压缩每个子视图的宽度，压缩到某个阈值后再换行。。
        let tipLabel = UILabel()
        tipLabel.text = "6.下面的例子用来实现子视图依次从左往右添加，并且当空间不够时会自动压缩前面的所有子视图的宽度。而当所有子视图的宽度都到达了最小的阈值时就会自动换行，并继续添加上去。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上分别测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Cell", for: .normal)
        addButton.sizeToFit()
        rootLayout.addSubview(addButton)
        addButton.addTarget(self, action: #selector(self.handleAddCell), for: .touchUpInside)
        
        let contentLayout = TGTableLayout(.vert)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_hspace = 5
        contentLayout.tg_vspace = 5
        //设置行间距和列间距都为5.
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        contentLayout.tag = 6000//为了方便查找。
    }
    
    
    func createDemo7(_ rootLayout: TGLinearLayout) {
        //多行多列，里面的子视图根据屏幕的尺寸智能的排列。
        let tipLabel = UILabel()
        tipLabel.text = "7.下面的例子里面有多个宽度不一致的子视图，但是布局会根据屏幕的大小而智能的排列这些子视图，从而充分的利用好布局视图的空间。您可以分别在横竖屏下测试以及在iPhone4/5/6/6+上分别测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        
        rootLayout.addSubview(tipLabel)
        let contentLayout = TGFlowLayout(.vert, arrangedCount: 0)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_space = 5
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        contentLayout.tg_autoArrange = true //自动排列，布局视图会根据里面子视图的尺寸进行智能的排列。
        contentLayout.tg_gravity = TGGravity.horz.fill //对于内容填充流式布局来说会拉升所有子视图的尺寸，以便铺满整个布局视图。
        //添加N个长短不一的子视图。
        for i in 0..<15 {
            let label = UILabel()
            label.text = String(format: "%02d", i)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.tg_width.equal(CGFloat(arc4random() % 150 + 20)) //最宽170，最小20.
            label.tg_height.equal(30)
            label.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: CGFloat(1))
            contentLayout.addSubview(label)
        }
    }
    
    
    func createDemo8(_ rootLayout: TGLinearLayout) {
        //一行内，如果屏幕尺寸足够宽则左边的视图居左，中间的视图居中，右边的视图居右，如果宽度不够宽则产生滚动效果。
        let tipLabel = UILabel()
        tipLabel.text = "8.下面的例子中如果屏幕足够宽则左边视图居左，中间视图居中，右边视图居右。这时候不会产生滚动，而当屏幕宽度不足时则会压缩中间视图和两边视图之间的间距并且产生滚动效果。这样的例子也可以同样应用在纵向屏幕中：通常在大屏幕设备上中间的部分要居中显示，而在小屏幕上则依次排列产生滚动效果。 您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        let scrollView = UIScrollView()
        scrollView.tg_height.equal(60)
        rootLayout.addSubview(scrollView)
        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_width.equal(.wrap).min(scrollView.tg_width) //默认水平线性布局的宽度是wrap的但是最小的宽度和父视图相等，这样对于一些大尺寸屏幕因为能够容纳内容而不会产生滚动。
        contentLayout.backgroundColor = CFTool.color(0)
        contentLayout.tg_height.equal(.fill)
        contentLayout.tg_gravity = TGGravity.vert.fill
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_space = 5
        scrollView.addSubview(contentLayout)
        
        //第一个子视图。
        let label1 = UILabel()
        label1.text = "左边的子视图"
        label1.font = CFTool.font(15)
        label1.backgroundColor = CFTool.color(5)
        label1.sizeToFit()
        contentLayout.addSubview(label1)
        
        //第二个子视图。
        let label2 = UILabel()
        label2.text = "中间稍微长一点的子视图"
        label2.font = CFTool.font(15)
        label2.backgroundColor = CFTool.color(6)
        label2.sizeToFit()
        //中间视图的左边间距是0.5,右边间距是0.5。表明中间视图的左右间距占用剩余的空间而达到居中的效果。这样在屏幕尺寸足够时则会产生居中效果，而屏幕尺寸不足时则会缩小间距，但是这里面最左边的最小间距是0而最右边的最小间距是30，这样布局视图因为具有wrapContentWidth属性所以会扩充宽度而达到滚动的效果。
        label2.tg_leading.equal(50%).min(0)
        label2.tg_trailing.equal(50%).min(30)
        contentLayout.addSubview(label2)
        
        //第三个子视图。
        let label3 = UILabel()
        label3.text = "右边的子视图"
        label3.font = CFTool.font(15)
        label3.backgroundColor = CFTool.color(7)
        label3.sizeToFit()
        contentLayout.addSubview(label3)
    }
    
    
    func createDemo9(_ rootLayout: TGLinearLayout) {
        //一行内，如果最后的子视图能够被容纳在屏幕中则放到最右边，如果不能容纳则会产生滚动。
        let tipLabel = UILabel()
        tipLabel.text = "9.下面的例子中最右边的视图如果能够被屏幕容纳则放在最右边，否则就会产生滚动效果。这个例子同样也可以应用在纵向屏幕中:很多页面里面最下边需要放一个按钮，如果屏幕尺寸够高则总是放在最底部，如果屏幕尺寸不够则会产生滚动效果。 您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        let scrollView = UIScrollView()
        scrollView.tg_height.equal(60)
        rootLayout.addSubview(scrollView)
        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.backgroundColor = CFTool.color(0)
        contentLayout.tg_height.equal(.fill)
        contentLayout.tg_width.equal(.wrap).min(scrollView.tg_width) //默认水平线性布局的宽度是wrap的但是最小的宽度和父视图相等，这样对于一些大尺寸屏幕因为能够容纳内容而不会产生滚动。
        contentLayout.tg_gravity = TGGravity.vert.fill
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_hspace = 5
        scrollView.addSubview(contentLayout)
      
        //第一个子视图。
        let  label1 = UILabel()
        label1.text = "第一个视图"
        label1.font = CFTool.font(15)
        label1.backgroundColor = CFTool.color(5)
        label1.sizeToFit()
        contentLayout.addSubview(label1)
        
        //第二个子视图。
        let label2 = UILabel()
        label2.text = "第二个子视图的内容稍微长一点"
        label2.font = CFTool.font(15)
        label2.backgroundColor = CFTool.color(6)
        label2.sizeToFit()
        contentLayout.addSubview(label2)
        
        //第三个子视图。
        let  label3 = UILabel()
        label3.text = "第三个"
        label3.font = CFTool.font(15)
        label3.backgroundColor = CFTool.color(7)
        label3.sizeToFit()
        //最后一个视图的左边距占用剩余的空间，但是最低不能小于30。这样设置的意义是如果布局视图够宽则第三个子视图的左边间距是剩余的空间，这样就保证了第三个子视图总是在最右边。而如果剩余空间不够时，则因为这里最小的宽度是30，而布局视图又是wrap,所以就会扩充布局视图的宽度，而产生滚动效果。这里的最小值30很重要，也就是第三个子视图和其他子视图的最小间距，具体设置多少就要看UI的界面效果图了。
        label3.tg_leading.equal(100%).min(30)
        contentLayout.addSubview(label3)
    }
    
    
    func createLabel(_ title:String, color idx:Int) -> UILabel
    {
        let label = UILabel()
        label.text = title
        label.font = CFTool.font(15)
        label.backgroundColor = CFTool.color(idx)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        
        return label
    }
    
    
    func createDemo10(_ rootLayout: TGLinearLayout) {
        
        //一行内所有的子视图的宽度都按屏幕的尺寸来进行按比例的拉伸和缩放。
        let tipLabel = UILabel()
        tipLabel.text = "10.下面的例子中展示了一行中各个子视图的宽度和间距都将根据屏幕的尺寸来进行拉伸和收缩，这样不管在任何尺寸的屏幕下都能达到完美的适配。在实践中UI人员往往会按某个设备的尺寸给出一张效果图，那么我们只需要按这个效果图中的子视图的宽度来计算好所占用的宽度和间距的比例，然后我们通过对视图的宽度和间距按比例值进行设置，这样就会使得子视图的真实宽度和间距将根据屏幕的尺寸进行拉升和收缩。您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_height.equal(60)
        contentLayout.tg_gravity = TGGravity.vert.center
        
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        
        
        //假设我们以iPhone6的尺寸作为UI的原型。并且假设:
        /*
         1.A的宽度不管任何设备下总是固定为30；
         2.B的宽度在iphone6下是60，与A的间距是10；
         3.C的宽度在iphone6下是80，与B的间距是16；
         4.D的宽度在iPhone6下是100，与C的间距在任何设备下总是16；
         5.E的宽度不管任何设备下总是固定为40，与D的间距就是iPhone6宽度的剩余空间13(375-左右padding只和10-30-60-10-80-16-100-16)了。
         
         这种动态比例的展示非常适合用线性布局来完成，iPhone6的总宽度为375。而上面列出的总的浮动宽度部分的和：
         
         总的浮动部分的和 = B的宽度60 + 与A的间距10 + C的宽度80 + 与B的间距16 + D的宽度100 + 与D的间距13 = 279.
         因此我们对B的宽度，与A的间距，C的宽度，与B的间距，D的宽度，与D的间距这部分的值设置为比例值。而不是绝对值！
         
         这样我们设置比例值时，只要将视图在iPhone6下的尺寸值除以这个总的浮动宽度就可以得到每个子视图的相对的比例值了。
         
         */
        
        let subvweights:[CGFloat] = [60.0,10.0,80.0,16.0,100.0,13.0]  //swift不支持连加。。。
        
        var totalFloatWidth:CGFloat = 0
        for v in subvweights
        {
            totalFloatWidth += v
        }
        
        let A = self.createLabel("A",color:5)
        A.tg_leading.equal(0)
        A.tg_width.equal(60.0)   //不管任何设备固定宽度为60,高度根据内容确定。
        contentLayout.addSubview(A)
        
        let B = self.createLabel("B",color:6)
        B.tg_leading.equal((10/totalFloatWidth)%) //B与A的间距，也就是左间距用浮动间距。
        B.tg_width.equal((60 / totalFloatWidth)%)
        contentLayout.addSubview(B)
        
        let C = self.createLabel("C",color:7)
        C.tg_leading.equal((16 / totalFloatWidth)%)
        C.tg_width.equal((80 / totalFloatWidth)%)
        contentLayout.addSubview(C)
        
        let D = self.createLabel("D",color:8)
        D.tg_leading.equal(16)  //D与C的间距是固定的16
        D.tg_width.equal((100 / totalFloatWidth)%)
        contentLayout.addSubview(D)
        
        let E = self.createLabel("E",color:9)
        E.tg_leading.equal((13 / totalFloatWidth)%)
        E.tg_width.equal(40) //固定的宽度。
        contentLayout.addSubview(E)
        
        
    }
    
    func createDemo11(_ rootLayout: TGLinearLayout) {
        
        //一行内的子视图的间距会根据屏幕尺寸自动缩小。
        let tipLabel = UILabel()
        tipLabel.text = "11.下面一个例子展示了当某个布局视图的尺寸能够容纳里面所有子视图的尺寸和间距时就按正常显示，而当尺寸不足以容纳所有子视图的尺寸和间距之和时我们就对子视图之间的间距进行压缩，以便能将所有子视图的内容都显示出来。您可以分别在iPhone4/5/6/6+上以及横竖屏测试效果:"
        tipLabel.font = CFTool.font(14)
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.tg_top.equal(10)
        tipLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(tipLabel)
        
        
        let contentLayout = TGLinearLayout(.horz)
        contentLayout.tg_padding = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        contentLayout.tg_height.equal(60)
        contentLayout.tg_gravity = TGGravity.vert.center
        
        contentLayout.backgroundColor = CFTool.color(0)
        rootLayout.addSubview(contentLayout)
        
        
        contentLayout.tg_hspace = 50;  //默认设定固定间距为50
        contentLayout.tg_shrinkType = [.space, .average]  //当整体内容的总宽度不超过布局视图的宽度时则正常布局，当布局视图的宽度不能容纳总体宽度时，则会平均缩小子视图之间的间距以保证一行内能容纳下所有的内容。shrinkType支持压缩尺寸和压缩间距两种压缩方法，默认是压缩尺寸。你可以选择.size或者.space来指定当布局尺寸不能容纳内容时是压缩所有子视图之间的间距还是尺寸来实现完美适配。
        
               
        let A = self.createLabel("Objective-C", color:5)
        A.sizeToFit()
        //A.tg_leading.equal(80)   //您可以解注释这条语句，并将上面的shrinkType设置为MySubviewsShrink_Average或者MySubviewsShrink_Weight查看效果
        contentLayout.addSubview(A)
        
        let B = self.createLabel("Swift",color:6)
        B.sizeToFit()
        contentLayout.addSubview(B)
        
        let C  = self.createLabel("C++",color:7)
        C.sizeToFit()
        contentLayout.addSubview(C)
        
        
        let D = self.createLabel("JAVA", color:8)
        D.sizeToFit()
        contentLayout.addSubview(D)
        
        
        
    }

    
}
