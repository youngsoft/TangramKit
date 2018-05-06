//
//  TGTableLayout.swift
//  TangramKit
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


//定义行尺寸和列尺寸可以设置的值，对于行列来说可以设置一个具体的值，也可以设置TGLayoutSize中的wrap, fill, average这三个值中的一个。
public protocol TGTableRowColSizeType:TGLayoutSizeType
{
    
}

extension CGFloat:TGTableRowColSizeType{}
extension Int:TGTableRowColSizeType{}
extension Double:TGTableRowColSizeType{}
extension Float:TGTableRowColSizeType{}
extension TGLayoutSize:TGTableRowColSizeType{}


/**
 *表格布局是一种里面的子视图可以像表格一样进行多行多列排列的布局视图。子视图添加到表格布局视图前必须先要建立并添加行子视图，然后再将列子视图添加到行子视图里面。
 *表格里面的行子视图和列子视图的排列方向的概念是相对的，他根据表格布局方向的不同而不同。表格布局根据方向可分为垂直表格布局和水平表格布局。
 *对于垂直表格布局来说，行子视图是从上到下依次排列的，而列子视图则是在行子视图里面从左到右依次排列。
 *对于水平表格布局来说，行子视图是从左到右依次排列的，而列子视图则是在行子视图里面从上到下依次排列。
 */
open class TGTableLayout: TGLinearLayout {
    
    /**
     *  添加一个新行。对于垂直表格来说每一行是从上往下排列的，而水平表格则每一行是从左往右排列的。
     *
     *  rowSize行的尺寸值，可以设置的值有特殊的TGLayoutSize或者CGFloat类型如下：
     1 .wrap表示由列子视图决定本行尺寸(垂直表格为行高，水平表格为行宽)，每个列子视图都需要自己设置尺寸(垂直表格为高度，水平表格为宽度)
     2 .average表示均分尺寸(垂直表格为行高 = 总行高/行数，水平表格为行宽 = 总行宽/行数)，列子视图不需要设置尺寸(垂直表格为高度，水平表格为宽度)
     3 大于0表示固定尺寸，表示这行的尺寸为这个固定的数值(垂直表格为行高，水平表格为行宽)，列子视图不需要设置尺寸(垂直表格为高度，水平表格为宽度)。
     4 不能设置为.fill。
     *  colSize列的尺寸值，可以设置的值有特殊的TGLayoutSize或者CGFloat类型如下：
     1 .fill表示整列尺寸和父视图一样的尺寸(垂直表格为列宽，水平表格为列高)，每个子视图需要设置自己的尺寸(垂直表格为宽度，水平表格为高度)
     2 .wrap表示整列的尺寸由列内所有子视图包裹(垂直表格为列宽，水平表格为列高).每个子视图需要设置自己的尺寸(垂直表格为宽度，水平表格为高度)
     3 .average表示整列的尺寸和父视图一样的尺寸(垂直表格为列宽，水平表格为列高)，每列内子视图的尺寸均分(垂直表格 = 列宽/行内子视图数，水平表格 = 行高/列内子视图数)
     4 大于0表示列内每个子视图都具有固定尺寸(垂直表格为宽度，水平表格为高度)，这时候子视图可以不必设置尺寸。
     */
    @discardableResult
    public func tg_addRow(size rowSize:TGTableRowColSizeType, colSize:TGTableRowColSizeType) ->TGLinearLayout
    {
        return tg_insertRow(size: rowSize, colSize:colSize, rowIndex: self.tg_rowCount)
    }
    
    public func tg_addRow(size rowSize:TGTableRowColSizeType, colCount:Int) ->TGLinearLayout
    {
        return tg_insertRow(size: rowSize, colSize:TGTableLayout._stgColCountTag - CGFloat(colCount), rowIndex: self.tg_rowCount)
    }
    
    /**
     * 在指定的位置插入一个新行
     */
    @discardableResult
    public func tg_insertRow(size rowSize: TGTableRowColSizeType, colSize : TGTableRowColSizeType, rowIndex : Int) ->TGLinearLayout
    {
        let lsc = self.tgCurrentSizeClass as! TGTableLayoutViewSizeClass
        var ori:TGOrientation = TGOrientation.vert
        if (lsc.tg_orientation == TGOrientation.vert)
        {
            ori = TGOrientation.horz
        }
        else
        {
            ori = TGOrientation.vert
        }
        
        let rowView = TGTableRowLayout(orientation: ori, rowSize: rowSize, colSize: colSize)
        if ori == TGOrientation.horz
        {
            rowView.tg_hspace = lsc.tg_hspace
        }
        else
        {
            rowView.tg_vspace = lsc.tg_vspace
        }
        
        rowView.tg_intelligentBorderline = self.tg_intelligentBorderline
        super.insertSubview(rowView,at:rowIndex)
        return rowView
        
    }
    
    public func tg_insertRow(size rowSize: TGTableRowColSizeType, colCount : UInt, rowIndex : Int) ->TGLinearLayout
    {
        //这里特殊处理用-100000 - colCount 来表示一个特殊的列尺寸。其实是数量。
        return tg_insertRow(size: rowSize, colSize: TGTableLayout._stgColCountTag - CGFloat(colCount), rowIndex: rowIndex)
    }

    
    /**
     * 删除一行
     */
    public func tg_removeRow(_ rowIndex: Int) {
        
        self.tg_rowView(at:rowIndex).removeFromSuperview()
    }
    
    /**
     * 交换两行的位置
     */
    public func tg_exchangeRow(_ rowIndex1: Int, with rowIndex2: Int) {
        
        super.exchangeSubview(at: rowIndex1, withSubviewAt:rowIndex2)
    }
    
    /**
     *返回行对象
     */
    public func tg_rowView(at rowIndex: Int) -> TGLinearLayout {
        
        return self.subviews[rowIndex] as! TGLinearLayout;
    }
    
    /**
     *返回行的数量
     */
    public var tg_rowCount:Int {
        return self.subviews.count
    }
    
    /**
     * 添加一个新的列。再添加一个新的列前必须要先添加行，对于垂直表格来说每一列是从左到右排列的，而对于水平表格来说每一列是从上到下排列的。
     * @colView:  列视图
     * @rowIndex: 指定要添加列的行的索引
     */
    public func tg_addCol(_ colView: UIView, inRow rowIndex : Int) {
        
        self.tg_insertCol(colView, inIndexPath: IndexPath(row: rowIndex, col: self.tg_colCount(inRow:rowIndex) ))
    }
    
    /**
     * 在指定的indexPath下插入一个新的列 IndexPath(row:1, col:1)
     */
    public func tg_insertCol(_ colView: UIView, inIndexPath indexPath: IndexPath) {
        
        let rowView:TGTableRowLayout = self.tg_rowView(at:indexPath.row) as! TGTableRowLayout
        
        let rowsc = rowView.tgCurrentSizeClass as! TGLinearLayoutViewSizeClassImpl
        let colsc = colView.tgCurrentSizeClass as! TGViewSizeClassImpl
        
        //colSize为0表示均分尺寸，为-1表示由子视图决定尺寸，大于0表示固定尺寸。
        if let v = rowView.colSize as? TGLayoutSize
        {
            if v === TGLayoutSize.average
            {
                if (rowsc.tg_orientation == TGOrientation.horz)
                {
                    colsc.tg_width.equal(v)
                }
                else
                {
                    colsc.tg_height.equal(v)
                }
            }
        }
        else
        {
            if let v = rowView.colSize as? CGFloat, v < TGTableLayout._stgColCountTag
            {
                
                let colCount = TGTableLayout._stgColCountTag - v
                if rowsc.tg_orientation == TGOrientation.horz
                {
                    colsc.tg_width.equalHelper(val:rowView.tg_width, increment:-1 * rowView.tg_hspace * (colCount - 1.0) / colCount, multiple:1.0 / colCount)
                }
                else
                {
                    colsc.tg_height.equalHelper(val:rowView.tg_height,increment:-1 * rowView.tg_vspace * (colCount - 1.0) / colCount, multiple:1.0 / colCount)
                }
            }
            else
            {
                if (rowsc.tg_orientation == TGOrientation.horz)
                {
                    colsc.tg_width.equalHelper(val:rowView.colSize)
                }
                else
                {
                    colsc.tg_height.equalHelper(val:rowView.colSize)
                }
            }
        }
        
        if (rowsc.tg_orientation == TGOrientation.horz)
        {
            if (colView.bounds.size.height == 0 && !colsc.height.hasValue)
            {
                if colView is TGBaseLayout
                {
                    if !colsc.height.isWrap
                    {
                        colsc.tg_height.equal(rowsc.tg_height);
                    }
                }
                else
                {
                    colsc.tg_height.equal(rowsc.tg_height);
                }
            }
        }
        else
        {
            if (colView.bounds.size.width == 0 && !colsc.width.hasValue)
            {
                
                if colView is TGBaseLayout
                {
                    if !colsc.width.isWrap
                    {
                        colsc.tg_width.equal(rowsc.tg_width)
                    }
                }
                else
                {
                    colsc.tg_width.equal(rowsc.tg_width);
                }
            }
            
        }
        
        
        rowView.insertSubview(colView, at:indexPath.col)
    }
    
    /**
     * 删除一列
     */
    public func tg_removeCol(_ indexPath: IndexPath) {
        
        self.tg_colView(at:indexPath).removeFromSuperview()
    }
    
    /**
     * 交换两个列视图，这两个列视图是可以跨行的
     */
    public func tg_exchangeCol(_ indexPath1: IndexPath, with indexPath2: IndexPath) {
        
        let colView1:UIView = self.tg_colView(at:indexPath1);
        let colView2:UIView = self.tg_colView(at:indexPath2);
        
        if (colView1 == colView2)
        {
            return;
        }
        
        
        self.tg_removeCol(indexPath1);
        self.tg_removeCol(indexPath2);
        
        self.tg_insertCol(colView1, inIndexPath:indexPath2)
        self.tg_insertCol(colView2, inIndexPath:indexPath1)
        
    }
    
    /**
     * 返回列视图
     */
    public func tg_colView(at indexPath: IndexPath) -> UIView {
        
        return self.tg_rowView(at:indexPath.row).subviews[indexPath.col];
    }
    
    /**
     * 返回某行的列的数量
     */
    public func tg_colCount(inRow rowIndex: Int) -> Int {
        
        return self.tg_rowView(at:rowIndex).subviews.count;
    }
    
    //MARK: override method
    
    public override var tg_vspace:CGFloat {
        get {
            return super.tg_vspace
        }
        set {
            super.tg_vspace = newValue
            if self.tg_orientation == TGOrientation.horz
            {
                for i in 0 ..< self.tg_rowCount
                {
                    self.tg_rowView(at: i).tg_vspace = newValue
                }
            }
        }
    }
    
    public override var tg_hspace:CGFloat {
        get {
            return super.tg_hspace
        }
        set {
            super.tg_hspace = newValue
            if self.tg_orientation == TGOrientation.vert
            {
                for i in 0 ..< self.tg_rowCount
                {
                    self.tg_rowView(at: i).tg_hspace = newValue
                }
            }
        }
    }
    
    /**
     *表格布局的addSubView被重新定义，是addCol:atRow的精简版本，表示插入当前行的最后一列
     */
    open override func addSubview(_ view: UIView) {
        
        self.tg_addCol(view, inRow: self.tg_rowCount - 1)
    }
    
    //不能直接调用如下的函数，否则会崩溃。
    open override func insertSubview(_ view: UIView, at index: Int) {
        
        assert(false, "Constraint exception!! Can't call insertSubview")
    }
    
    open override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        
        assert(false, "Constraint exception!! Can't call exchangeSubviewAtIndex")
    }
    
    
    open override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView)
    {
        assert(false, "Constraint exception!! Can't call insertSubview")
        
    }
    
    open override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView)
    {
        assert(false, "Constraint exception!! Can't call insertSubview")
        
    }
    
    internal override func tgCreateInstance() -> AnyObject
    {
        return TGTableLayoutViewSizeClassImpl(view:self)
    }
    
    static fileprivate let _stgColCountTag:CGFloat = -100000
}

/**
 *  行列描述扩展对象。
 */
extension IndexPath {
    
    public init(row:Int, col:Int)
    {
        self.init(row:row, section:col)
    }
    
    var col: Int {
        get{
            return self.section
        }
        set
        {
            self.section = newValue
        }
        
    }
}



private class TGTableRowLayout: TGLinearLayout,TGTableLayoutViewSizeClass {
    

    
    var rowSize: TGTableRowColSizeType
    var colSize:TGTableRowColSizeType
    
    init(orientation:TGOrientation,rowSize:TGTableRowColSizeType, colSize:TGTableRowColSizeType)
    {
        self.rowSize = rowSize
        self.colSize = colSize
        super.init(frame:CGRect.zero, orientation:orientation)
        
        let lsc = self.tgCurrentSizeClass as! TGLinearLayoutViewSizeClassImpl
        
        if let v = rowSize as? TGLayoutSize
        {
            if v === TGLayoutSize.average || v === TGLayoutSize.wrap
            {
                if (orientation == TGOrientation.horz)
                {
                    lsc.tg_height.equal(v)
                }
                else
                {
                    lsc.tg_width.equal(v)
                }
            }
            else
            {
                assert(false, "Constraint exception !! rowSize can not set to fill or other TGLayoutSize")
            }
            
        }
        else
        {
            if (orientation == TGOrientation.horz)
            {
                lsc.tg_height.equalHelper(val:rowSize)
            }
            else
            {
                lsc.tg_width.equalHelper(val:rowSize)
            }
        }
        
        
        var isNoWrap = false
        if let v = colSize as? TGLayoutSize, v === TGLayoutSize.average || v === TGLayoutSize.fill
        {
            isNoWrap = true
        }
        
        if let v = colSize as? CGFloat, v < TGTableLayout._stgColCountTag
        {
            isNoWrap = true
        }
        
        if isNoWrap
        {
            if (orientation == TGOrientation.horz)
            {
                lsc.width.realSize?.equal(nil)
                lsc.tg_leading.equal(0);
                lsc.tg_trailing.equal(0);
            }
            else
            {
                lsc.height.realSize?.equal(nil)
                lsc.tg_top.equal(0);
                lsc.tg_bottom.equal(0);
            }
            
        }
        else
        {
            if (orientation == TGOrientation.horz)
            {
                lsc.tg_width.equal(TGLayoutSize.wrap)
            }
            else
            {
                lsc.tg_height.equal(TGLayoutSize.wrap)
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.rowSize = 0
        self.colSize = 0
        super.init(coder:aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override internal func tgHook(sublayout:TGBaseLayout, borderlineRect: inout CGRect)
    {
        /*
         如果行布局是包裹的，那么意味着里面的列子视图都需要自己指定行的尺寸，这样列子视图就会有不同的尺寸，如果是有智能边界线时就会出现每个列子视图的边界线的长度不一致的情况。
         有时候我们希望列子视图的边界线能够布满整个行(比如垂直表格中，所有列子视图的的高度都和所在行的行高是一致的）因此我们需要将列子视图的边界线的可显示范围进行调整。
         因此我们重载这个方法来解决这个问题，这个方法可以将列子视图的边界线的区域进行扩充和调整，目的是为了让列子视图的边界线能够布满整个行布局上。
         */
        if let v = rowSize as? TGLayoutSize, v === TGLayoutSize.wrap
        {
            if self.tg_orientation == TGOrientation.horz
            {
                //垂直表格下，行是水平的，所以这里需要将列子视图的y轴的位置和行对齐。
                borderlineRect.origin.y = 0 - sublayout.frame.origin.y
                //垂直表格下，行是水平的，所以这里需要将子视图的边界线的高度和行的高度保持一致。
                borderlineRect.size.height = self.bounds.size.height
            }
            else
            {
                //水平表格下，行是垂直的，所以这里需要将列子视图的x轴的位置和行对齐。
                borderlineRect.origin.x = 0 - sublayout.frame.origin.x
                //水平表格下，行是垂直的，所以这里需要将子视图的边界线的宽度和行的宽度保持一致。
                borderlineRect.size.width = self.bounds.size.width
            }
        }
    }
}


