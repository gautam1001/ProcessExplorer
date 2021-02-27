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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let explorerController = self.parent as? ProcessExplorerController, let list = explorerController.splitViewItems.first?.viewController as? ProcessListViewController {
            list.delegate = self
        }
    }
}

extension ProcessDetailViewController:ProcessActionDelegate{
   
    func processSelected(with info:ProcessInfo){
        pidValueLabel.intValue = info.pid
        parentValueLabel.intValue = info.ppid
        pathValueLabel.stringValue = info.path
        bundleIdLabel.stringValue = info.bundleId
    }
}
