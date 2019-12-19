//
//  DetailViewController.swift
//  TreeNavigation
//
//  Created by csq on 19/10/16.
//  Copyright © 2019年 csq. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    


    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var tempRange: UILabel!
    @IBOutlet weak var weatherTxt: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
  
    
    var cityNamebyPost:String!
    var dataDic:NSDictionary!
    var testString:String!
    var future:NSArray!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self

        self.startRequest(cityname: cityNamebyPost)
        self.loadData()

        cityName.text = cityNamebyPost
        self.tableview.backgroundColor = UIColor.clear




    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        let dic = self.future[indexPath.row] as! NSDictionary
        

        cell.backgroundColor = UIColor.clear

        cell.dateLabel.text = dic["week"] as? String
        cell.tempLabel.text = dic["temperature"] as? String
        cell.weatherLabel.text = dic["weather"] as? String
        return cell
    }
    func startRequest(cityname:String) -> Void {

        
        var strURL = NSString(format: "http://v.juhe.cn/weather/index?format=%@&cityname=%@&key=%@",
                              "2", cityname, "65098b26478523e06c004ed787f7f037")
        strURL = strURL.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)! as NSString
        let url = URL(string: strURL as String)!
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error!)
                                            }else{
                                                do {
                                                    let resDict = try (JSONSerialization.jsonObject(with: data!,
                                                                                                    options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary)
                                                
                                                        self.dataDic = resDict

                                                    
                                                } catch {
                                                    print("返回数据解析失败")
                                                }

                                            }
                                            
                                            semaphore.signal()
        }) as URLSessionTask
        
        dataTask.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        print("数据加载完毕！")

    }
    
    
    
    func loadData(){
        

        
        let tmp = self.dataDic["result"] as! NSDictionary
        self.future = tmp["future"] as?NSArray


        let sk = tmp["sk"] as! NSDictionary
        let today = tmp["today"] as! NSDictionary
        self.temp.text = sk["temp"]  as! String + "°C"
        self.tempRange.text = (today["temperature"] as! String)
        self.weatherTxt.text = (today["weather"] as! String)
        
    }


}
