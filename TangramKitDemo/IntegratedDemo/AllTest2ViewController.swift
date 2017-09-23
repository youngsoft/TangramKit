//
//  AllTest2ViewController.swift
//  TangramKit
//
//  Created by yant on 25/7/16.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit


/**
 *2.UITableView - Static height
 */
class AllTest2ViewController: UITableViewController {

    static let tablecell = "alltest2cell"
    
    lazy var datas:[AllTest2DataModel] = {
       
        var _datas = [AllTest2DataModel]()
        
        
        let headImages = ["head1","head2","minions1","minions4"]
        let names = ["欧阳大哥","醉里挑灯看键","张三","尼古拉・阿列克赛耶维奇・奥斯特洛夫斯基"]
        let descs = ["只有一行文本",
        "这个例子是用于测试自动布局在UITableView中实现静态高度的解决方案。",
        "通过布局视图的tg_sizeThatFits函数能够评估出UITableViewCell的动态高度",
        "这是一段既有文本也有图片，文本在上面，图片在下面"
        ]
        
        let prices = ["1235.34","0","34246466.32","100"]
        
        
        
        for _ in 0 ..< 50
        {
            var model = AllTest2DataModel()
            model.headImage    =  headImages[Int(arc4random_uniform(UInt32(headImages.count)))]
            model.name     =  names[Int(arc4random_uniform(UInt32(names.count)))]
            model.desc  =  descs[Int(arc4random_uniform(UInt32(descs.count)))]
            model.price =  prices[Int(arc4random_uniform(UInt32(prices.count)))]
            
            _datas.append(model)
        }

        return _datas
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tableView.separatorStyle = .none
        self.tableView.register(AllTest2TableViewCell.self, forCellReuseIdentifier:AllTest2ViewController.tablecell)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:AllTest2TableViewCell = tableView.dequeueReusableCell(withIdentifier: AllTest2ViewController.tablecell, for: indexPath) as! AllTest2TableViewCell
        
        let model = self.datas[indexPath.row]
        cell.model = model
        
        return cell
        
    }


}
