//
//  AllTest1TableViewCell.swift
//  TangramKit
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class AllTest1TableViewCell: UITableViewCell {
    
    weak var headImageView:UIImageView!
    weak var nickNameLabel:UILabel!
    weak var textMessageLabel:UILabel!
    weak var imageMessageImageView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        /**
         * 您可以尝试用不同的布局来实现相同的功能。
         */
        self.createLinearRootLayout()
      //  self.createRelativeRootLayout()
      //  self.createFloatRootLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
    fileprivate(set) var rootLayout:TGBaseLayout!

    
    func setModel(model: AllTest1DataModel, isImageMessageHidden: Bool)
    {
        self.headImageView.image = UIImage(named: model.headImage)
        self.headImageView.sizeToFit()
        self.nickNameLabel.text = model.nickName
        self.nickNameLabel.sizeToFit()
        self.textMessageLabel.text = model.textMessage
        self.imageMessageImageView.isHidden = model.imageMessage.isEmpty
        
        if !model.imageMessage.isEmpty
        {
            self.imageMessageImageView.image = UIImage(named: model.imageMessage)
            self.imageMessageImageView.sizeToFit()
            self.imageMessageImageView.isHidden = isImageMessageHidden
        }
    }
    
}

//MARK: Layout Construction
extension AllTest1TableViewCell
{
    
    //用线性布局来实现UI界面
    func createLinearRootLayout()
    {
        /*
         在UITableViewCell中使用TGLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
         self.rootLayout.tg_width.equal(.fill)
         self.rootLayout.tg_height.equal(.wrap)
         */
        self.rootLayout = TGLinearLayout(.horz)
        self.rootLayout.tg_topPadding = 5
        self.rootLayout.tg_bottomPadding = 5
        self.rootLayout.tg_width.equal(.fill)
        self.rootLayout.tg_height.equal(.wrap)
        self.contentView.addSubview(self.rootLayout)
        //如果您将布局视图作为子视图添加到UITableViewCell本身，并且同时设置了布局视图的宽度等于父布局的情况下，那么有可能最终展示的宽度会不正确。经过试验是因为对UITableViewCell本身的KVO监控所得到的新老尺寸的问题导致的这应该是iOS的一个BUG。所以这里建议最好是把布局视图添加到UITableViewCell的子视图contentView里面去。
        

        
        
        /*
         用线性布局实现时，整体用一个水平线性布局：左边是头像，右边是一个垂直的线性布局。垂直线性布局依次加入昵称、文本消息、图片消息。
         */
        
        
        let headImageView = UIImageView()
        self.rootLayout.addSubview(headImageView)
        self.headImageView = headImageView
        
        let messageLayout = TGLinearLayout(.vert)
        messageLayout.tg_width.equal(.fill)  //等价于tg_width.equal(100%)
        messageLayout.tg_height.equal(.wrap)
        messageLayout.tg_left.equal(5)
        messageLayout.tg_vspace = 5 //前面4行代码描述的是垂直布局占用除头像外的所有宽度，并和头像保持5个点的间距。
        self.rootLayout.addSubview(messageLayout)
        
        
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = .blue
        nickNameLabel.font = .systemFont(ofSize: 15)
        messageLayout.addSubview(nickNameLabel)
        self.nickNameLabel = nickNameLabel
        
        
        let textMessageLabel = UILabel()
        textMessageLabel.font = .systemFont(ofSize: 13)
        textMessageLabel.numberOfLines = 0;
        textMessageLabel.tg_width.equal(.fill)
        textMessageLabel.tg_height.equal(.wrap)  //高度为包裹，也就是动态高度。
        messageLayout.addSubview(textMessageLabel)
        self.textMessageLabel = textMessageLabel
        
        let imageMessageImageView = UIImageView()
        imageMessageImageView.tg_centerX.equal(0)  //图片视图在父布局视图中水平居中。
        messageLayout.addSubview(imageMessageImageView)
        self.imageMessageImageView = imageMessageImageView
    }
    
    //用相对布局来实现UI界面
    func createRelativeRootLayout() {
        
        /*
         在UITableViewCell中使用TGLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
         self.rootLayout.tg_width.equal(.fill)
         self.rootLayout.tg_height.equal(.wrap)
         */
        self.rootLayout = TGRelativeLayout()
        self.rootLayout.tg_topPadding = 5
        self.rootLayout.tg_bottomPadding = 5
        self.rootLayout.tg_width.equal(.fill)
        self.rootLayout.tg_height.equal(.wrap)
        self.contentView.addSubview(self.rootLayout)
        
        /*
         用相对布局实现时，左边是头像视图，昵称文本在头像视图的右边，文本消息在昵称文本的下面，图片消息在文本消息的下面。
         */
        let headImageView = UIImageView()
        rootLayout.addSubview(headImageView)
        self.headImageView = headImageView
        
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = .blue
        nickNameLabel.font = .systemFont(ofSize: 15)
        nickNameLabel.tg_left.equal(self.headImageView.tg_right, offset:5) //昵称文本的左边在头像视图的右边并偏移5个点。
        rootLayout.addSubview(nickNameLabel)
        self.nickNameLabel = nickNameLabel
        
        //昵称文本的左边在头像视图的右边并偏移5个点。
        let textMessageLabel = UILabel()
        textMessageLabel.font = .systemFont(ofSize: 13)
        textMessageLabel.numberOfLines = 0
        textMessageLabel.tg_left.equal(self.headImageView.tg_right, offset:5) //文本消息的左边在头像视图的右边并偏移5个点。
        textMessageLabel.tg_right.equal(rootLayout.tg_right) //文本消息的右边和父布局的右边对齐。上面2行代码也同时确定了文本消息的宽度。
        textMessageLabel.tg_top.equal(self.nickNameLabel.tg_bottom,offset:5) //文本消息的顶部在昵称文本的底部并偏移5个点
        textMessageLabel.tg_height.equal(.wrap)
        rootLayout.addSubview(textMessageLabel)
        self.textMessageLabel = textMessageLabel

        
        let imageMessageImageView = UIImageView()
        imageMessageImageView.tg_centerX.equal(5) //图片消息的水平中心点等于父布局的水平中心点并偏移5个点的位置,这里要偏移5的原因是头像和消息之间需要5个点的间距。
        imageMessageImageView.tg_top.equal(self.textMessageLabel.tg_bottom, offset:5) //图片消息的顶部在文本消息的底部并偏移5个点。
        rootLayout.addSubview(imageMessageImageView)
        self.imageMessageImageView = imageMessageImageView
    }
    
    //用浮动布局来实现UI界面
    func createFloatRootLayout()
    {
        /*
         在UITableViewCell中使用TGLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
         self.rootLayout.tg_width.equal(.fill)
         self.rootLayout.tg_height.equal(.wrap)
         */
        self.rootLayout = TGFloatLayout(.vert)
        self.rootLayout.tg_topPadding = 5
        self.rootLayout.tg_bottomPadding = 5
        self.rootLayout.tg_width.equal(.fill)
        self.rootLayout.tg_height.equal(.wrap)
        self.contentView.addSubview(self.rootLayout)
 
        /*
         用浮动布局实现时，头像视图浮动到最左边，昵称文本跟在头像视图后面并占用剩余宽度，文本消息也跟在头像视图后面并占用剩余宽度，图片消息不浮动占据所有宽度。
         要想了解浮动布局的原理，请参考文章：http://www.jianshu.com/p/0c075f2fdab2 中的介绍。
         */
        let headImageView = UIImageView()
        headImageView.tg_right.equal(5) //右边保留出5个点的视图间距。
        rootLayout.addSubview(headImageView)
        self.headImageView = headImageView
        
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.lightGray
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        nickNameLabel.tg_bottom.equal(5)  //下边保留出5个点的视图间距。
        nickNameLabel.tg_width.equal(.fill) //占用剩余宽度。
        rootLayout.addSubview(nickNameLabel)
        self.nickNameLabel = nickNameLabel
        
        let textMessageLabel = UILabel()
        textMessageLabel.font = UIFont.systemFont(ofSize: 14)
        textMessageLabel.numberOfLines = 0
        textMessageLabel.tg_width.equal(.fill)  //占用剩余宽度。
        textMessageLabel.tg_height.equal(.wrap) //高度包裹
        rootLayout.addSubview(textMessageLabel)
        self.textMessageLabel = textMessageLabel
        
        let imageMessageImageView = UIImageView()
        imageMessageImageView.tg_top.equal(5)
        imageMessageImageView.tg_reverseFloat = true  //反向浮动
        imageMessageImageView.tg_width.equal(.fill)    //占用剩余空间
        imageMessageImageView.contentMode = .center
        rootLayout.addSubview(imageMessageImageView)
        self.imageMessageImageView = imageMessageImageView
        
    }
}
