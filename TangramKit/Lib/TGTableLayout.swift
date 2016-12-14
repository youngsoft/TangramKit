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
 *表格布局是一种里面的子视图可以像表格一样多行多列排列的布局视图。子视图添加到表格布局视图前必须先要建立并添加行视图，然后再将子视图添加到行视图里面。
 *如果行视图在表格布局里面是从上到下排列的则表格布局为垂直表格布局，垂直表格布局里面的子视图在行视图里面是从左到右排列的；
 *如果行视图在表格布局里面是从左到右排列的则表格布局为水平表格布局，水平表格布局里面的子视图在行视图里面是从上到下排列的。
 */
open class TGTableLayout: TGLinearLayout {
    
    /**
     *  添加一个新行。对于垂直表格来说每一行是从上往下排列的，而水平表格则每一行是从左往右排列的。
     *
     *  @param rowSize 为TGLayoutSize.wrap表示由子视图决定本行尺寸，子视图需要自己设置尺寸；为TGLayoutSize.average表示均分尺寸，子视图不需要设置尺寸；为数值时表示固定尺寸，子视图不需要设置尺寸;不能设置为TGLayoutSize.fill。
     *  @param colSize  为TGLayoutSize.fill表示子视图需要自己指定尺寸，整体行尺寸和父视图一样的尺寸；为TGLayoutSize.wrap表示由子视图需要自己设置尺寸，行尺寸包裹所有子视图；为TGLayoutSize.average表示均分尺寸，这时候子视图不必设置尺寸；为数值表示子视图固定尺寸，这时候子视图可以不必设置尺寸。
     */
    @discardableResult
    public func tg_addRow(size rowSize:TGTableRowColSizeType, colSize:TGTableRowColSizeType) ->TGLinearLayout
    {
        return tg_insertRow(size: rowSize, colSize:colSize, rowIndex: self.tg_rowCount)
    }
    
    /**
     * 在指定的位置插入一个新行
     */
    @discardableResult
    public func tg_insertRow(size rowSize: TGTableRowColSizeType, colSize : TGTableRowColSizeType, rowIndex : Int) ->TGLinearLayout
    {
        var ori:TGOrientation = .vert;
        if (self.tg_orientation == .vert)
        {
            ori = .horz;
        }
        else
        {
            ori = .vert;
        }
        
        let rowView = TGTableRowLayout(orientation: ori, rowSize: rowSize, colSize: colSize)
        if ori == .horz
        {
            rowView.tg_hspace = self.tg_hspace
        }
        else
        {
            rowView.tg_vspace = self.tg_vspace
        }
        
        rowView.tg_intelligentBorderline = self.tg_intelligentBorderline
        super.insertSubview(rowView,at:rowIndex)
        return rowView
        
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
        
        //colSize为0表示均分尺寸，为-1表示由子视图决定尺寸，大于0表示固定尺寸。
        if let v = rowView.colSize as? TGLayoutSize
        {
            if v === TGLayoutSize.average
            {
                if (rowView.tg_orientation == .horz)
                {
                    colView.tg_width.equal(v)
                }
                else
                {
                    colView.tg_height.equal(v)
                }
            }
        }
        else
        {
            if (rowView.tg_orientation == .horz)
            {
                colView.tg_width.tgEqual(val:rowView.colSize)
            }
            else
            {
                colView.tg_height.tgEqual(val:rowView.colSize)
            }
        }
        
        if (rowView.tg_orientation == .horz)
        {
            if (colView.bounds.size.height == 0 && !colView.tg_height.hasValue)
            {
                if let colViewl = colView as? TGBaseLayout
                {
                    if (!colViewl.tg_height.isWrap)
                    {
                        colView.tg_height.equal(rowView.tg_height);
                    }
                }
                else
                {
                    colView.tg_height.equal(rowView.tg_height);
                }
            }
        }
        else
        {
            if (colView.bounds.size.width == 0 && !colView.tg_width.hasValue)
            {
                
                if let colViewl = colView as? TGBaseLayout
                {
                    if (!colViewl.tg_width.isWrap)
                    {
                        colView.tg_width.equal(rowView.tg_width)
                    }
                }
                else
                {
                    colView.tg_width.equal(rowView.tg_width);
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
        
        let colView1 = self.tg_colView(at:indexPath1);
        let colView2 = self.tg_colView(at:indexPath2);
        
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
            if self.tg_orientation == .horz
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
            if self.tg_orientation == .vert
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
        return TGTableLayoutViewSizeClassImpl()
    }
    
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
    var colSize: TGTableRowColSizeType
    
    init(orientation:TGOrientation,rowSize:TGTableRowColSizeType, colSize:TGTableRowColSizeType)
    {
        self.rowSize = rowSize
        self.colSize = colSize
        super.init(orientation)
        
        if let v = rowSize as? TGLayoutSize
        {
            if v === TGLayoutSize.average || v === TGLayoutSize.wrap
            {
                if (orientation == .horz)
                {
                    self.tg_height.equal(v)
                }
                else
                {
                    self.tg_width.equal(v)
                }
            }
            else
            {
                assert(false, "Constraint exception !! rowSize can not set to fill or other TGLayoutSize")
            }
            
        }
        else
        {
            if (orientation == .horz)
            {
                self.tg_height.tgEqual(val:rowSize)
            }
            else
            {
                self.tg_width.tgEqual(val:rowSize)
            }
        }
        
        if let v = colSize as? TGLayoutSize, v === TGLayoutSize.average || v === TGLayoutSize.fill
        {
            if (orientation == .horz)
            {
                self.tg_width.equal(nil)
                self.tg_left.equal(0);
                self.tg_right.equal(0);
            }
            else
            {
                self.tg_height.equal(nil)
                self.tg_top.equal(0);
                self.tg_bottom.equal(0);
            }
            
        }
        else
        {
            if (orientation == .horz)
            {
                self.tg_width.equal(.wrap)
            }
            else
            {
                self.tg_height.equal(.wrap)
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.rowSize = 0
        self.colSize = 0
        super.init(coder:aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}


