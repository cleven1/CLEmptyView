//
//  detailViewController.swift
//  CLEmptyViewDemo
//
//  Created by cleven on 2018/1/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    var tableView:UITableView!
    var dataArray:[String] = []
    
    var index:Int = 0
    
    init(index:Int){
        super.init(nibName: nil, bundle: nil)
        self.index = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }

    func setUpTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        switch index {
        case 0:
            tableView.normalEmptyView()
            break
        case 1:
            tableView.standardEmptyView()
            break
        case 2:
            tableView.moreEmptyView()
            break
        default:
            break
        }
        
        tableView.addEmptyViewCallback {[weak self] in
            self?.getData()
        }
        
        tableView.addHeaderCallback { [weak self] in
            self?.getData()
        }
        tableView.addFooterCallback { [weak self] in
            self?.getData()
        }
        tableView.addFirstButtonCallback { [weak self] in
            // 如果此处需要处理加载请求,需要设置isLoading为true
            self?.tableView.setIsloading(isLoading: true)
            self?.getData()
            print("第一个按钮被点击")
        }
        
        tableView.addSecondButtonCallback {
            print("第二个按钮被点击")
        }
        
        getData()
    }
    
    func getData(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            for i in 0...20 {
//                self.dataArray.append("\(i)")
//            }
            self.tableView.successReload()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension detailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
    
    
    
}
