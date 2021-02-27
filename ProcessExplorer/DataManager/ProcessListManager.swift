//
//  ProcessListManager.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Foundation
import Cocoa

class ProcessListManager {
    
    var processes:[ProcessInfo]?
    var count:Int {
        return self.processes?.count ?? 0
    }
    
    func fetch(){
        let apps = NSWorkspace.shared.runningApplications
        self.processes = apps.map{ runningApplication in
            return ProcessInfo(with: runningApplication)
        }
    }
    
}
