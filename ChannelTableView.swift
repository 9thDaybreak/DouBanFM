//
//  ChannelTableView.swift
//  DouBanFM
//
//  Created by 肖杰华 on 16/7/26.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ChamnelProtocol {
    func onChangeChannel_id(Channel_id:String)
}

class ChannelTableView: UIViewController,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var delegate:ChamnelProtocol?
    
    var channelDataFirst:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置透明度
        view.alpha = 0.7
    }
    
    //点击返回按钮
    @IBAction func ClickCloseBtn() {
        dismissViewControllerAnimated(true) {
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return channelDataFirst.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Channel")
        
        let rowData:JSON = self.channelDataFirst[indexPath.row]
        cell?.textLabel?.text = rowData["name"].string
        
        return cell!
    }
    
    //点击某行返回到主界面
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowData:JSON = self.channelDataFirst[indexPath.row] as JSON
        //选取选中的ID
        let channel_id:String = rowData["channel_id"].stringValue
        //将ID传回主界面
        delegate?.onChangeChannel_id(channel_id)
        self.dismissViewControllerAnimated(true,completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
