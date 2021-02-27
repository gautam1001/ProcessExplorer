//
//  ProcessListViewController.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Cocoa

class ProcessListViewController: NSViewController {
    @IBOutlet weak var tableView:NSTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        ProcessListManager.shared.fetch()
    }
}

extension ProcessListViewController:NSTabViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return ProcessListManager.shared.count
    }
}

extension ProcessListViewController:NSTableViewDataSource {
    
}
