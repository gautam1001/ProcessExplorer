//
//  ProcessListViewController.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Cocoa
protocol ProcessActionDelegate:class{
    func processSelected(with info:ProcessInfo)
}
class ProcessListViewController: NSViewController {
    @IBOutlet weak var tableView:NSTableView?
    weak var delegate:ProcessActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        ProcessListManager.shared.fetch()
        self.tableView?.doubleAction = #selector(handleDoubleClick)
        
    }
    
    @objc func handleDoubleClick(){
        guard let clickedRow = self.tableView?.clickedRow else {return}
        let process = ProcessListManager.shared.processes[clickedRow]
        self.delegate?.processSelected(with: process)
    }
}

extension ProcessListViewController:NSTableViewDelegate {
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let process = ProcessListManager.shared.processes[row]
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "processname") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ProcessCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = process.name ?? ""
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "pid") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PidCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.integerValue = Int(process.pid)
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "path") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PathCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = process.path
            return cellView
        }
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "UserCell")
        guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
        cellView.textField?.stringValue = process.username
        return cellView
    }
}

extension ProcessListViewController:NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return ProcessListManager.shared.count
    }
}
