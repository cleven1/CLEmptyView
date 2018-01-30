//
//  UITableView+CLBase.swift
//  CLEmptyViewDemo
//
//  Created by tusm on 2018/1/21.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

//MARK:代理事件回调
extension UITableView:CLEmptyBaseViewDelegate{
    
    /// 点击占位图回调
    public func clickEmptyView() {
        if config.clEmptyView.isLoading {return}
        config.clEmptyView.isLoading = true
        if let callback = config.tapEmptyViewCallback {
            callback()
        }
    }
    
    ///  点击第一个按钮回调
    public func clickFirstButton() {
        if config.clEmptyView.isLoading {return}
        if let callback = config.tapFirstButtonCallback {
            callback()
        }
    }
    
    /// 点击第二个按钮回调
    public func clickSecondButton() {
        if config.clEmptyView.isLoading {return}
        if let callback = config.tapSecondButtonCallback {
            callback()
        }
    }
}

public extension UITableView {
    
    public var config : CLConfigEmptyView {
        set {
            objc_setAssociatedObject(self, runtimeKey.tableKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let config1 = objc_getAssociatedObject(self, runtimeKey.tableKey!) as? CLConfigEmptyView
            if let config1 = config1 {
                return config1
            }
            layoutIfNeeded()
            var tempList = CLConfigEmptyView()
            tempList.frame = self.frame
            self.config = tempList
            return tempList
        }
    }
}
/// 记录配置信息
public struct CLConfigEmptyView {
    
    var tapEmptyViewCallback : (()->Void)?
    var tapFirstButtonCallback : (()->Void)?
    var tapSecondButtonCallback : (()->Void)?
    public var clEmptyView:CLEmptyBaseView = CLEmptyBaseView(frame: .zero)
    var frame:CGRect = .zero {
        didSet{
            if frame == .zero {
                clEmptyView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }else{
                clEmptyView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
}

struct runtimeKey {
    static let tableKey = UnsafeRawPointer.init(bitPattern: "CLConfigEmptyView".hashValue)
}

