//
//  ViewController.swift
//  TreeNavigation
//
//  Created by csq on 19/10/16.
//  Copyright © 2019年 csq. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var dictData:[String:Any]!
    var listData:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let plistPath=Bundle.main.path(forResource: "myprovince", ofType: "plist")
        let dict=NSDictionary(contentsOfFile:plistPath!)
        self.dictData=(dict as! [String:Any])
        self.listData=(dict?.allKeys as! [String])
        self.title="省份信息"
    }

    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "provinceIdentifier", for: indexPath)
        let row=indexPath.row
        cell.textLabel?.text=self.listData[row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="ShowSelectedProvince")
        {
            let cities=segue.destination as! CitiesViewController
            let indexPath=self.tableView.indexPathForSelectedRow  as IndexPath?
            let selectedIndex=indexPath!.row
            let selectName=self.listData[selectedIndex]
            cities.listData=(self.dictData[selectName] as! [[String:String]])
            cities.title=selectName
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

