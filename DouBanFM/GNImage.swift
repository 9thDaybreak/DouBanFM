//
//  GNImage.swift
//  DouBanFM
//
//  Created by 肖杰华 on 16/7/26.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

import UIKit

class GNImage: UIImageView {
    
    //调用父类初始化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //设置圆角
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
        
        //设置边框
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0,green: 1.0,blue: 1.0,alpha: 0.7).CGColor

    }
    
    func onRotation() {
        //设置关键字
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //初始值
        animation.fromValue = 0.0
        //结束值
        animation.toValue = M_PI * 2
        //动画的执行时间
        animation.duration = 30
        //动画的循环次数
        animation.repeatCount = MAXFLOAT;
        //添加动画
        self.layer.addAnimation(animation, forKey: nil)
        
    }
}