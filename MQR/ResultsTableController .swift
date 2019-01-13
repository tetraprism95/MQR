//
//  ResultsTableController .swift
//  MQR
//
//  Created by Nuri Chun on 9/30/18.
//  Copyright © 2018 tetra. All rights reserved.
//

import  UIKit

class ResultsTableController: UITableViewController {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}


// MARK: - ResultsTableController

extension ResultsTableController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // Will return search results of MKLocalSearchRequest
    // May have to use MKMapItem
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .white
        return cell
    }
}
