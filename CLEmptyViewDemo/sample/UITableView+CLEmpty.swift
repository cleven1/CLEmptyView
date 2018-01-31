//
//  UITableView+CLEmpty.swift
//  CLEmptyViewDemo
//
//  Created by cleven on 2018/1/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

//MARK: 界面信息配置
extension UITableView {
    /// 初始化emptyView
   public func normalEmptyView(){
        config.clEmptyView.addEmptyImage(imageNmae: "empty")
            .addEmptyTis(tips: NSAttributedString(string: "这是一个标题"))
            .addLoadingImage(imageNames: ["loading"])
            .addLoadingTips(tips: NSAttributedString(string: "正在加载中..."))
            .addLoadingDuration(duration: 0.5) //默认1秒
            .endConfig()
        setUpEmptyView()
    }
    
    public func standardEmptyView(){
        config.clEmptyView
            .addEmptyImage(imageNmae: "empty")
            .addEmptyTis(tips: NSAttributedString(string: "这是一个标题"))
            .addLoadingImage(imageNames: (0..<3).map{"loading_\($0)"})
            .addLoadingTips(tips: NSAttributedString(string: "正在加载中..."))
            .addLoadingDuration(duration: 0.5) //默认1秒
            .addFirstBtnTitle(title: "这是一个按钮")
            .addFirstBtnBgColor(color: UIColor.red)
            .addFirstBtnCornerRadius(radius: 15)
            .endConfig()
        setUpEmptyView()
    }
    
    public func moreEmptyView(){
        config.clEmptyView
            .addEmptyImage(imageNmae: "empty")
            .addEmptyTis(tips: NSAttributedString(string: "这是一个标题"))
            .addLoadingImage(imageNames: (0..<3).map{"loading_\($0)"})
            .addLoadingTips(tips: NSAttributedString(string: "正在加载中..."))
            .addLoadingDuration(duration: 1) //默认1秒
            .addFirstBtnTitle(title: "第一个按钮")
            .addFirstBtnBgColor(color: UIColor.blue)
            .addFirstBtnCornerRadius(radius: 15)
            .addSecondBtnTitle(title: "第二个按钮")
            .addSecondBtnTitleColor(color: UIColor.black)
            .addSecondBtnBorderColor(color: UIColor.red)
            .addSecondBtnBorderWidth(w: 4)
            .addSecondBtnCornerRadius(radius: 15)
            .addEmptyDetailTips(tips: NSAttributedString(string: "这是一个副标题"))
            .endConfig()
        setUpEmptyView()
    }
    
    fileprivate func setUpEmptyView(){
        tableFooterView = UIView()
        //如果需要按照网络状态展示不同占位图,给这个属性赋值即可
//        let tips = "当前没有网络"
//        let tipsAtt = NSMutableAttributedString(string: tips)
//        tipsAtt.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: tips.count))
//        self.config.clEmptyView.setEmptyImage(imageName: "home_no_network", tips: tipsAtt) // 没有网络时显示的提示语)
//        
//        /// 隐藏加载动画
//        self.config.clEmptyView.setIsHiddenLoading = true
        
    }
    
}


