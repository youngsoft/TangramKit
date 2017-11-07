//
//  DetailViewController.swift
//  TangramKit
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit



class DetailViewController: UITableViewController {

    var demoVCList:[[String:Any]]!
    var isPresentVC:Bool = false
    
   convenience init(demoVCList:[[String:Any]]) {
        self.init(style: .plain)
        self.demoVCList = demoVCList
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()

   
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Present", style: .plain, target: self, action: #selector(handlePushOrPresent))
        
    }

    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Handle Method
    
    @objc func handlePushOrPresent(_ sender:UIBarButtonItem)
    {
        self.isPresentVC = !self.isPresentVC
        sender.title = self.isPresentVC ? "Push" : "Present"
        
        if (self.isPresentVC)
        {
            UIAlertView(title: "", message: NSLocalizedString("If you select \"Present\", than you can touch topleft corner of Status bar to dissmis the view controller",comment:""), delegate: nil, cancelButtonTitle: "OK").show()
        }
    }

    // MARK: - Table view data source

    override  func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.demoVCList.count
    }

    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "test", for:indexPath)
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = CFTool.font(15)
        cell.textLabel?.textColor = CFTool.color(4)
        cell.textLabel?.text = self.demoVCList[indexPath.row]["title"] as? String
        cell.textLabel?.textAlignment = TGBaseLayout.tg_isRTL ? .right : .left
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let demoVC:UIViewController = (self.demoVCList[indexPath.row]["class"] as! UIViewController.Type).init()
        demoVC.title = self.demoVCList[indexPath.row]["title"] as? String
        
        if self.isPresentVC{
            self.navigationController?.present(demoVC, animated: true, completion: nil)
        }
        else{
            self.navigationController?.pushViewController(demoVC, animated: true)
        }
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
