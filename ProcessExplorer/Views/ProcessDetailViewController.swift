//
//  ProcessDetailViewController.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Cocoa

/// View controller to show the details of selected process.

class ProcessDetailViewController: NSViewController {
    
    @IBOutlet weak var pidValueLabel: NSTextField!
    @IBOutlet weak var parentValueLabel: NSTextField!
    @IBOutlet weak var bundleIdLabel: NSTextField!
    @IBOutlet weak var pathValueLabel: NSTextField!
    @IBOutlet weak var quitButton: NSButton!
    private weak var process:ProcessInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setActionDelegate()
    }
    
    private func setActionDelegate(){
        // Access process list panel from parent controller i.e; "ProcessExplorerController"
        if let explorerController = self.parent as? ProcessExplorerController, let list = explorerController.splitViewItems.first?.viewController as? ProcessListViewController {
            list.delegate = self
        }
        ProcessListManager.shared.delegates.add(self)
    }
    
    // Quit button action
    @IBAction func quitProcess(_ sender:Any){
        guard let pid = self.process?.pid else {return}
        ProcessListManager.shared.killProcess(pid: pid)
        self.resetData()
    }
    
    // Reset UI to initial/unselected state
    func resetData(){
        pidValueLabel.stringValue = ""
        parentValueLabel.stringValue = ""
        pathValueLabel.stringValue = ""
        bundleIdLabel.stringValue = ""
        quitButton.isEnabled = false
    }
    
    deinit {
        ProcessListManager.shared.delegates.remove(self)
    }
}

extension ProcessDetailViewController:ProcessActionDelegate{
   
    func processSelected(with info:ProcessInfo){
        self.process = info
        self.pidValueLabel.stringValue = "\(info.pid)"
        self.parentValueLabel.stringValue = "\(info.ppid)"
        self.pathValueLabel.stringValue = info.path
        self.bundleIdLabel.stringValue = info.bundleId
        self.quitButton.isEnabled = true
    }
}

extension ProcessDetailViewController: ProcessStatusDelegate{
    func processTerminated(_ pid: pid_t) {
        guard let selectedProcess = self.process else {
            self.resetData()
            return
        }
        if selectedProcess.pid == pid {
            self.resetData()
        }
    }
}
