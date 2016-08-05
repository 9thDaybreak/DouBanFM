//
//  HttpController.swift
//  DouBanFM
//
//  Created by 肖杰华 on 16/7/27.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

import UIKit
import Alamofire

class HttpController: NSObject {
    
    //定义一个代理
    var delegate : httpProtocol?
    
    func onSearch(url:String) {
        Alamofire.request(Method.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers) {(data) -> Void in
            if let DATA = data.result.value {
                self.delegate?.didRecieveResults(DATA)
            } else {
                print("Data获取失败")
            }
        }
    }
}

//定义Http协议
protocol httpProtocol {
        func didRecieveResults(results:AnyObject)
}
