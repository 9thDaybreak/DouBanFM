//
//  GNOrderButton.swift
//  DouBanFM
//
//  Created by 肖杰华 on 16/7/29.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

import UIKit

class GNOrderButton: UIButton {
    
    var order:Int = 1
    
    let order1:UIImage = UIImage(named:"order1")!
    let order2:UIImage = UIImage(named:"order2")!
    let order3:UIImage = UIImage(named:"order3")!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onClick(sender:UIButton) {
        order += 1
        if order == 1 {
            self.setImage(order1, forState: UIControlState.Normal)
        } else if order == 2 {
            self.setImage(order2, forState: UIControlState.Normal)
        } else if order == 3 {
            self.setImage(order3, forState: UIControlState.Normal)
        } else if order > 3 {
            order = 1
            self.setImage(order1, forState: UIControlState.Normal)
        }
    }
    
}
