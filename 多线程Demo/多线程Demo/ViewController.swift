//
//  ViewController.swift
//  多线程Demo
//
//  Created by bob on 2020/10/21.
//  Copyright © 2020 bob. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let ds = ["GCDDemo",
              "NSOperation",
              "Lock"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            tableView.frame = view.bounds
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return .init()
        }
        
        cell.textLabel?.text = ds[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = GCDDemoViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = NSOperationDemoViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = NSOperationDemoViewController()
            navigationController?.pushViewController(vc, animated: true)
        default: break
            
        }
        
    }

}

