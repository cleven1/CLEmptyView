//
//  ViewController.swift
//  CLEmptyViewDemo
//
//  Created by cleven on 2018/1/8.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataArray:[String] = ["占位图 + title","占位图+title+一个按钮","占位图+title+detailTitle+两个按钮"]
    var tableView:UITableView!
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detalVC = detailViewController(index: indexPath.row)
        navigationController?.pushViewController(detalVC, animated: true)
    }
    
    
}
