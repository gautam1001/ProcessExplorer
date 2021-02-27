//
//  ProcessDetailViewController.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Cocoa



class ProcessDetailViewController: NSViewController {
    
    @IBOutlet weak var pidValueLabel: NSTextField!
    @IBOutlet weak var parentValueLabel: NSTextField!
    @IBOutlet weak var bundleIdLabel: NSTextField!
    @IBOutlet weak var pathValueLabel: NSTextField!
    private weak var process:ProcessInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let explorerController = self.parent as? ProcessExplorerController, let list = explorerController.splitViewItems.first?.viewController as? ProcessListViewController {
            list.delegate = self
        }
    }
    
    @IBAction func quitProcess(_ sender:Any){
        guard let pid = self.process?.pid else {return}
        ProcessListManager.shared.killProcess(pid: pid)
        pidValueLabel.intValue = 0
        parentValueLabel.intValue = 0
        pathValueLabel.stringValue = ""
        bundleIdLabel.stringValue = ""
    }
}

extension ProcessDetailViewController:ProcessActionDelegate{
   
    func processSelected(with info:ProcessInfo){
        process = info
        pidValueLabel.intValue = info.pid
        parentValueLabel.intValue = info.ppid
        pathValueLabel.stringValue = info.path
        bundleIdLabel.stringValue = info.bundleId
    }
}
