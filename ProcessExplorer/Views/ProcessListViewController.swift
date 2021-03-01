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

/// View controller to show the  running process list
class ProcessListViewController: NSViewController {
    @IBOutlet weak var tableView:NSTableView?
    @IBOutlet weak var processesLabel:NSTextField?
    weak var delegate:ProcessActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.initialSetup()
    }
    
    private func initialSetup(){
        ProcessListManager.shared.fetch()
        updateProcessesLabel()
        ProcessListManager.shared.notifyAppState()
        ProcessListManager.shared.delegates.add(self)

        ProcessListManager.shared.processLaunched = {[weak self] in
            self?.tableView?.reloadData()
            self?.updateProcessesLabel()
        }
    }
    
    func updateProcessesLabel(){
        self.processesLabel?.stringValue = ProcessListManager.shared.count > 1 ? "Processes: \(ProcessListManager.shared.count) " : "Process: \(ProcessListManager.shared.count) "
    }
    
    deinit {
        ProcessListManager.shared.delegates.remove(self)
    }
}

//MARK: Tableview Delegate
extension ProcessListViewController:NSTableViewDelegate {
    // Method invoked for table data upload ...
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let process = ProcessListManager.shared.processes[row]
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "processname") {
            guard let cellView = tableView.makeCellView(type: "ProcessCell") as? ProcessCellView else { return nil }
            cellView.populateUI(with: process.name ?? "", isSelected: process.isSelected)
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "pid") {
            guard let cellView = tableView.makeCellView(type: "PidCell") as? ProcessCellView else { return nil }
            cellView.populateUI(with: "\(process.pid)", isSelected: process.isSelected)
            return cellView
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "path") {
            guard let cellView = tableView.makeCellView(type: "PathCell") as? ProcessCellView else { return nil }
            cellView.populateUI(with: process.path, isSelected: process.isSelected)
            return cellView
        }
        guard let cellView = tableView.makeCellView(type: "UserCell") as? ProcessCellView else { return nil }
        cellView.populateUI(with: process.username, isSelected: process.isSelected)
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        return true
    }
    
    // Method invoked when a process is selected ...
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedRow = self.tableView?.selectedRow, selectedRow >= 0 else {return}
        let process = ProcessListManager.shared.processes[selectedRow]
        ProcessListManager.shared.updateSelection(process.pid)
        self.delegate?.processSelected(with: process)
    }
}

//MARK: Tableview DataSource
extension ProcessListViewController:NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return ProcessListManager.shared.count
    }
    
    // Method invoked when the column is selected i.e; 'Process' or 'PID'
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else { return }
        ProcessListManager.shared.sortProcesses(sortDescriptor)
        tableView.reloadData()
    }
}

//MARK: ProcessStatusDelegate
extension ProcessListViewController: ProcessStatusDelegate{
    // Method invoked a process is terminated
    func processTerminated(_ pid: pid_t) {
        self.tableView?.reloadData()
        self.updateProcessesLabel()
    }
    
}
