//
//  UITableView+MJRefResh.swift
//  CLEmptyViewDemo
//
//  Created by tusm on 2018/1/21.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    
    /// 添加头部刷新 必须在数据请求之后,调用successReload or failedReload
    ///
    /// - Parameter callback: head回调
   public func addHeaderCallback (callback : @escaping ()->(Void)) {
        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            callback()
        })
    }
    
    /// 添加尾部刷新 必须在数据请求之后,调用successReload or failedReload
    ///
    /// - Parameter callback: footer回调
   public func addFooterCallback (callback : @escaping ()->(Void)) {
        self.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            callback()
        })
    }
    
    
    /// 添加空页面点击回调 必须在数据请求之后,调用successReload or failedReload
    ///
    /// - Parameter callback: view回调
   public func addEmptyViewCallback (callback : (()->Void)?) {
        config.tapEmptyViewCallback = callback
    }
    
    
    /// 添加第一个按钮回调 必须在事件完成之后,调用successReload or failedReload
    ///
    /// - Parameter callback: 按钮回调
   public func addFirstButtonCallback (callback : (()->Void)?) {
        
        config.tapFirstButtonCallback = callback
    }
    
    
    /// 添加第二个按钮回调 必须在事件完成之后,调用successReload or failedReload
    ///
    /// - Parameter callback: 按钮回调
   public func addSecondButtonCallback (callback : (()->Void)?) {
        
        config.tapSecondButtonCallback = callback
    }
    
    
    /// 设置是否显示加载动画
    ///
    /// - Parameter isLoading: isLoading
   public func setIsloading(isLoading:Bool) {
        config.clEmptyView.isLoading = isLoading
    }
    
    
    /// 头部刷新
   public func headRefresh () {
        self.mj_header.beginRefreshing()
    };
    
    /// 请求成功后调用
    ///
    /// - Parameter noMoreData: YES 设置没有更多数据
   public func successReload(noMoreData : Bool = false) {
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
   public func failedReload () {
        endRefresh()
    }
    
    private func endRefresh () {
        config.clEmptyView.isLoading = false
        reloadData()
        var rowCount:Int = 0
        for i in 0..<numberOfSections {
            rowCount = numberOfRows(inSection: i)
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

