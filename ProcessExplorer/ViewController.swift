//
//  ViewController.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchProcesses()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func fetchProcesses(){
        let workspace = NSWorkspace.shared
        let applications = workspace.runningApplications

        for app in applications {
            print("\(app.localizedName ?? "Unspecified") \npid:\(app.processIdentifier) \n\(app.bundleURL?.absoluteString ?? "")")
           
            print("========================================")
    
        }
    }


}

