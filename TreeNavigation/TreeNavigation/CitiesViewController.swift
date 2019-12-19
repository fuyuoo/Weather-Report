//
//  CitiesViewController.swift
//  TreeNavigation
//
//  Created by csq on 19/10/16.
//  Copyright © 2019年 csq. All rights reserved.
//

import UIKit


class CitiesViewController: UITableViewController {

    var listData:[[String:String]]!
    var requestDic:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier="cityIdentifier"
        let cell:UITableViewCell!=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let row=indexPath.row
        let dict=self.listData[row]
        cell.textLabel?.text=dict["name"]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="ShowSelectedCityWeather")
        {
            let detail=segue.destination as! DetailViewController
            let indexPath=self.tableView.indexPathForSelectedRow  as IndexPath?
            let selectedIndex=indexPath!.row
            let dict=self.listData[selectedIndex]

            detail.cityNamebyPost=dict["name"]
            detail.title=dict["name"]
//            detail.dataDic = self.requestDic
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func startRequest(name:String) {

        
        var strURL = NSString(format: "http://v.juhe.cn/weather/index?format=%@&cityname=%@&key=%@",
                              "2", name, "65098b26478523e06c004ed787f7f037")
        strURL = strURL.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)! as NSString
        let url = URL(string: strURL as String)!
        let request = URLRequest(url: url)
        let defaultConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: defaultConfig,
                                 delegate: nil, delegateQueue: OperationQueue.main)

        let task: URLSessionDataTask = session.dataTask(with: request,completionHandler: { (data, response, error) in
            print("请求完成...")
            if error == nil {
                do {
                    self.requestDic = try (JSONSerialization.jsonObject(with: data!,
                                                                     options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary)
//                    let data = self.dataDic["result"] as! NSDictionary
//                    let tmp = data["sk"] as! NSDictionary
//                    self.temp.text = tmp["temp"]  as! String + "°C"
                    

                } catch {
                    print("返回数据解析失败")
                }
            } else {
                print("error : ", error!.localizedDescription)
            }
            


        })
        task.resume()

    }

}
