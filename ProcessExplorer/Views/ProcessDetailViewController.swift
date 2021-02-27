//
//  ProcessDetailViewController.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Cocoa

protocol ProcessDetailDelegate:class{
    func showDetail(with info:ProcessInfo)
}

class ProcessDetailViewController: NSViewController {
    
    weak var delegate:ProcessDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
