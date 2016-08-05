//
//  ViewController.swift
//  DouBanFM
//
//  Created by 肖杰华 on 16/7/26.
//  Copyright © 2016年 ZhuSunGongZuoShi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer
import AVKit
import Toast_Swift


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,httpProtocol,ChamnelProtocol {

    @IBOutlet weak var CD: GNImage!
    
    @IBOutlet weak var CDCenter: GNImage!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var musicTimer: UILabel!
    
    @IBOutlet weak var musicProgress: UIImageView!
  
    //按钮
    @IBOutlet weak var btnNext: UIButton!

    @IBOutlet weak var btnPlay: GNButton!
    
    @IBOutlet weak var btnLast: UIButton!
    
    @IBOutlet weak var btnOrder: GNOrderButton!
    
    var currentIndex:Int = 0
    
    var MainTimer:NSTimer?
    
    //网络操作类的实例
    var eHttp :HttpController = HttpController()
    
    var audioPlayer:AVPlayer = AVPlayer()
    
    //接收频道的歌曲数据
    var tableData:[JSON] = []
    
    var channelData:[JSON] = []
    
    var imageCache = Dictionary<String,UIImage?>()
    
    override func viewDidLayoutSubviews() {
        //调用类方法裁剪图片，设置图片旋转
        //调用该方法后会重新刷新view导致光盘重转
        //CD.onRotation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置View旋转
        CD.onRotation()
        
        //设置背景模糊
        let blurEffect = UIBlurEffect(style:UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect:blurEffect)
        blurView.frame.size = CGSizeMake(view.frame.size.width, view.frame.size.height)
        background.addSubview(blurView)
        
        //删除tableView背景颜色
        self.tableView.backgroundColor = UIColor.clearColor()
     
        //设置代理
        eHttp.delegate = self
        
        //调用onSearch方法获取频道数据
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        //获取频道为0歌曲数据
        eHttp.onSearch("http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")

        //添加按钮触摸方法
        btnPlay.addTarget(self, action: #selector(onPlay), forControlEvents: UIControlEvents.TouchUpInside)
        btnLast.addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
        btnNext.addTarget(self, action: #selector(onClick), forControlEvents: UIControlEvents.TouchUpInside)
        btnOrder.addTarget(self, action: #selector(onOrder), forControlEvents: UIControlEvents.TouchUpInside)
        
        //当歌曲播放完毕后，执行方法判断播放下一首曲目
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playFinish), name: AVPlayerItemDidPlayToEndTimeNotification, object: audioPlayer)
    }
    
    var isAutoFinish:Bool = true
    
    func playFinish() {
        if isAutoFinish {
            switch btnOrder.order {
            case 1:
                currentIndex += 1
                if currentIndex > tableData.count - 1 {
                    currentIndex = 0
                }
                onSelectRow(currentIndex)
            case 2:
                currentIndex = random() % tableData.count
                onSelectRow(currentIndex)
            case 3:
                onSelectRow(currentIndex)
            default:
                ""
            }
        } else {
            isAutoFinish = true
        }
    }
    
    //三种按钮触摸方法
    
    //判断开始和暂停
    func onPlay(btn:GNButton) {
        if btn.isPlay {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
    
    //判断上一首还是下一首
    func onClick(btn:UIButton) {
        isAutoFinish = false
        if btn == btnNext {
            currentIndex += 1
            if currentIndex > self.tableData.count - 1{
                currentIndex = 0
            }
        } else {
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex = self.tableData.count - 1
            }
        }
        onSelectRow(currentIndex)
    }

    //判断是哪种播放方式，用Toast进行输出
    func onOrder(btn:GNOrderButton) {
        var message:String = ""
        switch btn.order {
        case 1:
            message = "顺序播放"
        case 2:
            message = "随机播放"
        default:
            message = "单曲循环"
        }
        
        self.view.makeToast(message, duration: 1, position: CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2))
     }
    
    //代理处理返回数据
    func didRecieveResults(results: AnyObject) {
        //print("获取到的数据：\(results)")
        let json = JSON(results)
        
        if let channels = json["channels"].array{
            self.channelData = channels
            
        } else if let song = json["song"].array{
            isAutoFinish = false
            self.tableData = song
            self.tableView.reloadData()
            onSelectRow(0)
        }
    }
    
    //配置tableView的方法
    
    //组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    //cell显示的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DouBanFM") as? DouBanFM
        
        cell?.backgroundColor = UIColor.clearColor()
        
        let rowData:JSON = tableData[indexPath.row]
        cell?.titleText?.text = rowData["title"].string
        cell?.subTitleText?.text = rowData["artist"].string
        cell?.CenterImage?.image = UIImage(named: "thumb")
        
        let url = rowData["picture"].string
        onGetCacheImage(url!, imageView: (cell?.CenterImage)!)
        
        return cell!
    }
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 79
    }
    
    //即将显示单元格（cell）时加入的动画
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: { 
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
    }
    
    //点击某一行后执行的方法
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        isAutoFinish = false
        onSelectRow(indexPath.row)
    }
    
    //选中某一行执行的方法
    func onSelectRow(index:Int) {
        let indexPath = NSIndexPath(forRow: index,inSection: 0)
        //选中的效果
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Middle)
        //获取行数据
        let rowData:JSON = self.tableData[index] as JSON
        let imageUrl = rowData["picture"].string
        onSetImage(imageUrl!)
        
        let url:NSURL = rowData["url"].URL!
        onSetAudio(url)
    }
    
    //配置音乐播放器
    func onSetAudio(url:NSURL) {
        self.audioPlayer.pause()
        self.audioPlayer = AVPlayer(URL: url)
        //print("我的数据:\(url)")
        self.audioPlayer.play()
        
        btnPlay.onPlay()
        //停用定时器（无效化）
        MainTimer?.invalidate()
        //Label归零
        musicTimer.text = "00:00"
        //第一个参数：更新时间，第二个参数：目标，第三个参数：当计时器更新时会执行什么方法
        MainTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(onUpdate), userInfo: nil, repeats: true)
        
        isAutoFinish = true
    }
    
    //进度条计数器更新方法
    func onUpdate() {
        
        //获取当前播放时间
        let totalTimeObj = self.audioPlayer.currentItem!.asset.duration
        let totalTime = CGFloat(totalTimeObj.value) / CGFloat(totalTimeObj.timescale)
        
        //获取歌曲的总时间
        let nowTimeObj = self.audioPlayer.currentTime()
        let nowTime = CGFloat(nowTimeObj.value) / CGFloat(nowTimeObj.timescale)
        
        //歌曲播放进度的百分比
        let percent:CGFloat = nowTime / totalTime
        //print("当前百分比\(percent)")
        
        //配置进度条
        self.musicProgress.frame.size.width = self.view.frame.size.width * percent
        
        //配置时间的label
        if nowTime > 0 {
            let all:Int = Int(nowTime)
            let minute:Int = Int(all / 60)
            let second:Int = Int(all % 60)
            
            var time:String = ""
            
            if minute < 10 {
                time += "0\(minute):"
            } else {
                time += "\(minute):"
            }
            
            if second < 10 {
                time += "0\(second)"
            } else {
                time += "\(second)"
            }
            
            musicTimer.text = time
        }
    }
    
    //选中某行单元格后更改歌曲封面和背景
    func onSetImage(url:String) {
        Alamofire.request(Method.GET, url).response { (_, _, data, error) in
            let img = UIImage(data: data! as NSData)
            self.background.image = img
            self.CD.image = img
        }
        onGetCacheImage(url, imageView: self.background)
        onGetCacheImage(url, imageView: self.CD)
    }
    
    //从网络上获取图片
    func onGetCacheImage(url:String,imageView:UIImageView) {
        let img = self.imageCache[url]
        if img == nil {
            Alamofire.request(Method.GET, url).response(completionHandler: { (_, _, data, error) in
                let image = UIImage(data: data! as NSData)
                imageView.image = image
                self.imageCache[url] = image
            })
        } else {
            imageView.image = img!
        }
    }
    
    //协议方法
    func onChangeChannel_id(Channel_id:String) {
        //"http://douban.fm/j/mine/playlist?type=n&channel= 0 &from=mainsite"
        let url:String = "http://douban.fm/j/mine/playlist?type=n&channel=\(Channel_id)&from=mainsite"
        eHttp.onSearch(url)
    }
    
    //将数据传给第二个控制器的tableView
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let channelC:ChannelTableView = segue.destinationViewController as! ChannelTableView
        //设置代理
        channelC.delegate = self
        //传输频道列表数据
        channelC.channelDataFirst = self.channelData
    }
}