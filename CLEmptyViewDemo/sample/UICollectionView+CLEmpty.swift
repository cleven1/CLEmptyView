//
//  UICollectionView+CLEmpty.swift
//  CLEmptyViewDemo
//
//  Created by cleven on 2018/1/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import MJRefresh

extension UICollectionView {
    
    /// 添加头部刷新 必须在数据请求之后,调用successReload or failedReload
    ///
    /// - Parameter callback: head回调
    func addHeaderCallback (callback : @escaping ()->(Void)) {
        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            callback()
        })
    }
    
    /// 添加尾部刷新 必须在数据请求之后,调用successReload or failedReload
    ///
    /// - Parameter callback: footer回调
    func addFooterCallback (callback : @escaping ()->(Void)) {
        self.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            callback()
        })
    }
    
    
    /// 添加空页面点击回调 必须在数据请求之后,调用successReload or failedReload
    ///
    /// - Parameter callback: view回调
    func addEmptyViewCallback (callback : (()->Void)?) {
        config.tapEmptyViewCallback = callback
    }
    
    
    /// 添加第一个按钮回调 必须在事件完成之后,调用successReload or failedReload
    ///
    /// - Parameter callback: 按钮回调
    func addFirstButtonCallback (callback : (()->Void)?) {
        
        config.tapFirstButtonCallback = callback
    }
    
    
    /// 添加第二个按钮回调 必须在事件完成之后,调用successReload or failedReload
    ///
    /// - Parameter callback: 按钮回调
    func addSecondButtonCallback (callback : (()->Void)?) {
        
        config.tapSecondButtonCallback = callback
    }
    
    
    /// 设置是否显示加载动画
    ///
    /// - Parameter isLoading: isLoading
    func setIsloading(isLoading:Bool) {
        config.clEmptyView.isLoading = isLoading
    }
    
    
    /// 头部刷新
    func headRefresh () {
        self.mj_header.beginRefreshing()
    };
    
    /// 请求成功后调用
    ///
    /// - Parameter noMoreData: YES 设置没有更多数据
    func successReload(noMoreData : Bool = false) {
        guard let footer = mj_footer else {
            self.endRefresh()
            return
        }
        if noMoreData {
            footer.endRefreshingWithNoMoreData()
        } else {
            footer.resetNoMoreData()
        }
        self.endRefresh()
    }
    
    /// 请求失败后调用
    func failedReload () {
        endRefresh()
    }
    
    private func endRefresh () {
        config.clEmptyView.isLoading = false
        reloadData()
        
        var rowCount:Int = 0
        for i in 0..<numberOfSections {
            rowCount = numberOfItems(inSection: i)
            if rowCount > 0 { break}
        }
        if rowCount > 0  && rowCount != INTMAX_MAX{
            config.clEmptyView.removeFromSuperview()
            isScrollEnabled = true
        }
        guard let header = mj_header else {
            reloadData()
            guard let footer = mj_footer else {return}
            if footer.isRefreshing {
                footer.endRefreshing()
            }
            return;
        }
        if header.isRefreshing {
            header.endRefreshing()
        }
        guard let footer = mj_footer else {return}
        if footer.isRefreshing {
            footer.endRefreshing()
        }
    }
    
}
//MARK: 界面信息配置
extension UICollectionView {

    /// 初始化emptyView
    public func normalEmptyView(){
        config.clEmptyView.addEmptyImage(imageNmae: "empty")
            .addEmptyTis(tips: NSAttributedString(string: "这是一个标题"))
            .addLoadingImage(imageNames: ["load-0"])
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
        config.clEmptyView.removeFromSuperview()
        config.clEmptyView.delegate = self
        addSubview(config.clEmptyView)
        isScrollEnabled = false
    }
}

//MARK:代理事件回调
extension UICollectionView:CLEmptyBaseViewDelegate{
    
    func clickEmptyView() {
        if config.clEmptyView.isLoading {return}
        config.clEmptyView.isLoading = true
        if let callback = config.tapEmptyViewCallback {
            callback()
        }
    }
    
    func clickFirstButton() {
        if config.clEmptyView.isLoading {return}
        if let callback = config.tapFirstButtonCallback {
            callback()
        }
    }
    func clickSecondButton() {
        if config.clEmptyView.isLoading {return}
        if let callback = config.tapSecondButtonCallback {
            callback()
        }
    }
}
extension UICollectionView {
    var config : CLConfigEmptyView {
        set {
            objc_setAssociatedObject(self, runtimeKey.tableKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let config1 = objc_getAssociatedObject(self, runtimeKey.tableKey!) as? CLConfigEmptyView
            if let config1 = config1 {
                return config1
            }
            let tempList = CLConfigEmptyView()
            self.config = tempList
            return tempList
        }
    }
}
