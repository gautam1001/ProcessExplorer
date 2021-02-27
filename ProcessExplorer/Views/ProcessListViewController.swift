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
    @IBOutlet weak var processesLabel:NSTextField?
    weak var delegate:ProcessActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        ProcessListManager.shared.fetch()
        updateProcessesLabel()
        ProcessListManager.shared.notifyAppState()
        ProcessListManager.shared.processTerminated = {[weak self] in
            self?.tableView?.reloadData()
            self?.updateProcessesLabel()
        }
        ProcessListManager.shared.processLaunched = {[weak self] in
            self?.tableView?.reloadData()
            self?.updateProcessesLabel()
        }
        //self.tableView?.doubleAction = #selector(handleDoubleClick)
        //setSortDescriptor()
    }
    
    @objc func handleDoubleClick(){
        guard let clickedRow = self.tableView?.clickedRow else {return}
        let process = ProcessListManager.shared.processes[clickedRow]
        self.delegate?.processSelected(with: process)
    }
    
    func updateProcessesLabel(){
        self.processesLabel?.stringValue = ProcessListManager.shared.count > 1 ? "Processes: \(ProcessListManager.shared.count) " : "Process: \(ProcessListManager.shared.count) "
    }
    

    func setSortDescriptor() {
        let nameDesc = NSSortDescriptor(key: "process", ascending: true)
        
        self.tableView?.tableColumns[0].sortDescriptorPrototype = nameDesc
    }
    
    
}

extension ProcessListViewController:NSTableViewDelegate {
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let process = ProcessListManager.shared.processes[row]
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "processname") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ProcessCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = process.name ?? ""
            let rowView = cellView.superview as? NSTableRowView
            rowView?.isSelected = process.isSelected
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "pid") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PidCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.integerValue = Int(process.pid)
            let rowView = cellView.superview as? NSTableRowView
            rowView?.isSelected = process.isSelected
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "path") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PathCell")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = process.path
            let rowView = cellView.superview as? NSTableRowView
            rowView?.isSelected = process.isSelected
            return cellView
        }
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "UserCell")
        guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
        cellView.textField?.stringValue = process.username
        let rowView = cellView.superview as? NSTableRowView
        rowView?.isSelected = process.isSelected
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedRow = self.tableView?.selectedRow, selectedRow >= 0 else {return}
        let process = ProcessListManager.shared.processes[selectedRow]
        ProcessListManager.shared.updateSelection(process.pid)
        self.delegate?.processSelected(with: process)
    }
}

extension ProcessListViewController:NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return ProcessListManager.shared.count
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else { return }
        ProcessListManager.shared.sortProcesses(sortDescriptor)
        tableView.reloadData()
    }
}
