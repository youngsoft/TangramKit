//
//  AllTest2TableViewCell.swift
//  TangramKit
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class AllTest2TableViewCell: UITableViewCell {

    weak var headImageView: UIImageView!
    weak var nameLabel: UILabel!
    weak var descLabel: UILabel!
    weak var priceLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        /**
         * 您可以尝试用不同的布局来实现相同的功能。
         */
        self.createLinearRootLayout()
        //self.createRelativeRootLayout()
        //  self.createFloatRootLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

     var model: AllTest2DataModel! {
        get {
            return nil
        }
         set {
            self.headImageView.image = UIImage(named: newValue.headImage)
            self.headImageView.sizeToFit()
            self.nameLabel.text = newValue.name
            self.descLabel.text = newValue.desc
            self.priceLabel.text = newValue.price
        }
    }

}

extension AllTest2TableViewCell {
    // The output below is limited by 4 KB.
    // Upgrade your plan to remove this limitation.

    //用线性布局来实现UI界面

    func createLinearRootLayout() {
        /*
         在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是静态的，请务必在将布局视图添加到contentView之前进行如下设置：
         rootLayout.tg.width.equal(.fill)
         rootLayout.tg.height.equal(.fill)
         */
        let rootLayout = TGLinearLayout(.horz)
        rootLayout.tg.width.equal(.fill)
        rootLayout.tg.height.equal(.fill)
        self.contentView.addSubview(rootLayout)
        rootLayout.tg.bottomBorderline(value: TGBorderline(color: UIColor.lightGray, headIndent: 10, tailIndent: 10))
        rootLayout.tg.leadingPadding(value: 10)
        rootLayout.tg.trailingPadding(value: 10)  //两边保留10的内边距。
        rootLayout.tg.gravity(value: TGGravity.Vertical.center) //整个布局内容垂直居中。

        /*
         如果用线性布局的话，分为左中右三段，因此用水平线性布局：左边头像，中间用户信息，右边价格。中间用户信息在用一个垂直线性布局分为上下两部分：上面是用户名称和几个图标，下面是个人介绍。而用户名称和图标部分右通过建立一个水平线性布局来实现。
         */
        //头像视图
        let headImageView = UIImageView()
        rootLayout.addSubview(headImageView)
        self.headImageView = headImageView

        //中间用户信息是一个垂直线性布局：上部分是姓名，以及一些小图标这部分组成一个水平线性布局。下面是一行长的描述文字。
        let userInfoLayout = TGLinearLayout(.vert)
        userInfoLayout.tg.height.equal(.wrap)
        userInfoLayout.tg.width.equal(.fill)
        userInfoLayout.tg.gravity(value: TGGravity.Horizontal.fill)
        userInfoLayout.tg.vspace(value: 5)
        rootLayout.addSubview(userInfoLayout)

        //姓名信息部分，一个水平线性布局：左边名称，后面两个操作按钮，整体底部对齐。
        let userNameLayout = TGLinearLayout(.horz)
        userNameLayout.tg.height.equal(.wrap)
        userNameLayout.tg.hspace(value: 5)
        userNameLayout.tg.gravity(value: TGGravity.Vertical.bottom) //整体垂直底部对齐。
        userInfoLayout.addSubview(userNameLayout)

        let nameLabel = UILabel()
        nameLabel.font = CFTool.font(17)
        nameLabel.textColor = CFTool.color(3)
        //_nameLabel的宽度根据内容自适应，但是最大的宽度是父视图的宽度的1倍，再减去5+14+5+14。这里的5是视图之间的间距，14是后面两个图片的宽度。
        //这个设置的意思是_nameLabel的宽可以动态增长，但是不能超过父视图的宽度，并且要保证后面的2个图片视图显示出来。
        //您可以通过max方法设置尺寸的最大上边界。具体参见对max的方法的详细介绍。
        nameLabel.tg.width.equal(.wrap).max(userNameLayout.tg.width, increment: -(5 + 14 + 5 + 14))
        nameLabel.tg.height.equal(25)
        userNameLayout.addSubview(nameLabel)
        self.nameLabel = nameLabel

        //后面跟两个图片。
        let editImageView = UIImageView(image: UIImage(named: "edit")!)
        userNameLayout.addSubview(editImageView)
        let delImageView = UIImageView(image: UIImage(named: "del")!)
        userNameLayout.addSubview(delImageView)

        //描述部分
        let descLabel = UILabel()
        descLabel.textColor = CFTool.color(4)
        descLabel.font = CFTool.font(15)
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.numberOfLines = 2
        descLabel.tg.height.equal(.wrap)  //2行高度，高度根据内容确定。
        userInfoLayout.addSubview(descLabel)
        self.descLabel = descLabel

        //右边的价格。
        let priceLabel = UILabel()
        priceLabel.textColor = CFTool.color(4)
        priceLabel.font = CFTool.font(14)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.textAlignment = .right
        priceLabel.tg.width.equal(.wrap).max(TGDimeAdapter.width(100)).min(TGDimeAdapter.width(50))
        //宽度最宽为100,注意到这里使用了TGDimeAdapter.width表示会根据屏幕的宽度来对100进行缩放。这个100是按iPhone6为标准设置的。具体请参考TGDimeAdapter类。
        priceLabel.tg.height.equal(25)
        priceLabel.tg.leading.equal(10)
        rootLayout.addSubview(priceLabel)
        self.priceLabel = priceLabel
    }

    //用相对布局来实现UI界面
    func createRelativeRootLayout() {
        /*
         在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是静态的，请务必在将布局视图添加到contentView之前进行如下设置：
         rootLayout.tg.width.equal(.fill)
         rootLayout.tg.height.equal(.fill)
         */
        let rootLayout = TGRelativeLayout()
        rootLayout.tg.width.equal(.fill)
        rootLayout.tg.height.equal(.fill)
        rootLayout.tg.bottomBorderline(value: TGBorderline(color: UIColor.lightGray, headIndent: 10, tailIndent: 10))
        rootLayout.tg.leadingPadding(value: 10)
        rootLayout.tg.trailingPadding(value: 10)
        self.contentView.addSubview(rootLayout)

        //两边保留10的内边距。
        let headImageView = UIImageView()
        headImageView.tg.centerY.equal(rootLayout.tg.centerY)
        headImageView.tg.leading.equal(rootLayout.tg.leading)
        rootLayout.addSubview(headImageView)
        self.headImageView = headImageView

        let priceLabel = UILabel()
        priceLabel.textColor = CFTool.color(4)
        priceLabel.font = CFTool.font(14)
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.tg.trailing.equal(rootLayout.tg.trailing)
        priceLabel.tg.centerY.equal(rootLayout.tg.centerY)
        //priceLabel的宽度根据内容自适应，但是最大的宽度是100，最小的宽度是50。注意到这里使用了类TGDimeAdapter表示会根据屏幕的宽度来对100进行缩放。这个100是在DEMO中是按iPhone6为标准设置的。具体请参考TGDimeAdapter类的介绍。
        priceLabel.tg.width.equal(.wrap).max(TGDimeAdapter.width(100)).min(TGDimeAdapter.width(50))
        priceLabel.tg.height.equal(25)
        rootLayout.addSubview(priceLabel)
        self.priceLabel = priceLabel

        let nameLabel = UILabel()
        nameLabel.font = CFTool.font(17)
        nameLabel.textColor = CFTool.color(3)
        //相对布局在后续的版本中会增加对边界的限制方法来实现更加灵活的尺寸限制，这里暂时先设置为140经过测试效果最好。
        nameLabel.tg.width.equal(.wrap)
        nameLabel.tg.height.equal(25)
        nameLabel.tg.leading.equal(headImageView.tg.trailing)
        //设置nameLabel的右边距最大是priceLabel的左边距，再偏移两个小图标和间距的距离。这样当nameLabel的尺寸超过这个最大的右边距时就会自动的缩小视图的宽度。
        nameLabel.tg.trailing.max(priceLabel.tg.leading, offset: (5 + 14 + 5 + 14))

        rootLayout.addSubview(nameLabel)
        self.nameLabel = nameLabel

        let editImageView = UIImageView(image: UIImage(named: "edit"))
        editImageView.tg.leading.equal(nameLabel.tg.trailing, offset: 5)
        editImageView.tg.bottom.equal(nameLabel.tg.bottom)
        rootLayout.addSubview(editImageView)

        let delImageView = UIImageView(image: UIImage(named: "del"))
        delImageView.tg.leading.equal(editImageView.tg.trailing, offset: 5)
        delImageView.tg.bottom.equal(editImageView.tg.bottom)
        rootLayout.addSubview(delImageView)

        let descLabel = UILabel()
        descLabel.textColor = CFTool.color(4)
        descLabel.font = CFTool.font(15)
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.numberOfLines = 2
        descLabel.tg.height.equal(.wrap)

        //2行高度，高度根据内容确定。
        descLabel.tg.leading.equal(nameLabel.tg.leading)
        descLabel.tg.trailing.equal(priceLabel.tg.leading, offset: 10)
        rootLayout.addSubview(descLabel)
        self.descLabel = descLabel

        descLabel.tg.centerY.offset(5)
        nameLabel.tg.centerY.equal([descLabel.tg.centerY])
        //_nameLabel,_descLabel整体垂直居中。这里通过将tg.centerY设置为一个数组的值来表示。具体参考关于相对布局的介绍和DEMO。
    }

    func createFloatRootLayout() {
        /*
         在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是静态的，请务必在将布局视图添加到contentView之前进行如下设置：
         rootLayout.tg.width.equal(.fill)
         rootLayout.tg.height.equal(.fill)
         */
        let rootLayout = TGFloatLayout()
        rootLayout.tg.width.equal(.fill)
        rootLayout.tg.height.equal(.fill)
        rootLayout.tg.bottomBorderline(value: TGBorderline(color: UIColor.lightGray, headIndent: 10, tailIndent: 10))
        rootLayout.tg.leadingPadding(value: 10)
        rootLayout.tg.trailingPadding(value: 10) //两边保留10的内边距。
        self.contentView.addSubview(rootLayout)

        let headImageView = UIImageView()
        headImageView.contentMode = .scaleAspectFit
        headImageView.tg.height.equal(.fill)
        rootLayout.addSubview(headImageView)
        self.headImageView = headImageView

        let priceLabel = UILabel()
        priceLabel.textColor = CFTool.color(4)
        priceLabel.font = CFTool.font(14)
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.tg.reverseFloat(value: true)
        priceLabel.tg.leading.equal(10)

        //priceLabel的宽度根据内容自适应，但是最大的宽度是100，最小的宽度是50。注意到这里使用了类TGDimeAdapter表示会根据屏幕的宽度来对100进行缩放。这个100是在DEMO中是按iPhone6为标准设置的。具体请参考TGDimeAdapter类的介绍。
        priceLabel.tg.width.equal(.wrap).max(TGDimeAdapter.width(100)).min(TGDimeAdapter.width(50))
        priceLabel.tg.height.equal(.fill)
        rootLayout.addSubview(priceLabel)
        self.priceLabel = priceLabel

        let userInfoLayout = TGFloatLayout()
        userInfoLayout.tg.height.equal(.fill)
        userInfoLayout.tg.width.equal(.fill)
        userInfoLayout.tg.gravity(value: TGGravity.Vertical.center)
        userInfoLayout.tg.space(value: 5)
        rootLayout.addSubview(userInfoLayout)

        let nameLabel = UILabel()
        nameLabel.font = CFTool.font(17)
        nameLabel.textColor = CFTool.color(3)
        //_nameLabel的宽度根据内容自适应，但是最大的宽度是父视图的宽度的1倍，再减去5+14+5+14。这里的5是视图之间的间距，14是后面两个图片的宽度。
        //这个设置的意思是_nameLabel的宽可以动态增长，但是不能超过父视图的宽度，并且要保证后面的2个图片视图显示出来。
        //您可以通过max方法设置尺寸的最大上边界。具体参见对max的方法的详细介绍。
        nameLabel.tg.width.equal(.wrap).max(userInfoLayout.tg.width, increment: -(5 + 14 + 5 + 14))
        nameLabel.tg.height.equal(25)
        userInfoLayout.addSubview(nameLabel)
        self.nameLabel = nameLabel

        let editImageView = UIImageView(image: UIImage(named: "edit"))
        userInfoLayout.addSubview(editImageView)
        let delImageView = UIImageView(image: UIImage(named: "del"))
        userInfoLayout.addSubview(delImageView)

        let descLabel = UILabel()
        descLabel.textColor = CFTool.color(4)
        descLabel.font = CFTool.font(15)
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.numberOfLines = 2
        descLabel.tg.height.equal(.wrap)
        descLabel.tg.width.equal(.fill) //2行高度，高度根据内容确定。
        descLabel.tg.clearFloat(value: true)
        userInfoLayout.addSubview(descLabel)
        self.descLabel = descLabel
    }

}
