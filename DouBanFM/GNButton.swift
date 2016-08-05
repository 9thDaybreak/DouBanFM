//
//  GNButton.swift
//  DouBanFM
//
//  Created by 肖杰华 on 16/7/28.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

import UIKit

class GNButton: UIButton {

    var isPlay:Bool = true
    var imgPlay:UIImage = UIImage(named:"play")!
    var imgPause:UIImage = UIImage(named:"pause")!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func onClick() {
        isPlay = !isPlay
        if isPlay {
            self.setImage(imgPause, forState: UIControlState.Normal)
        } else {
            self.setImage(imgPlay, forState: UIControlState.Normal)
        }
    }
    
    func onPlay() {
        isPlay = true
        self.setImage(imgPause, forState: UIControlState.Normal)
    }
}
