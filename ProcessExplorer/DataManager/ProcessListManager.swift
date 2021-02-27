//
//  ProcessListManager.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Foundation
import Cocoa

class ProcessListManager {
    
    static let shared = ProcessListManager()
    
    var processes:[ProcessInfo]?
    var count:Int {
        return self.processes?.count ?? 0
    }
    
    private init(){}
    
    func fetch(){
        let apps = NSWorkspace.shared.runningApplications
        self.processes = apps.map{ runningApplication in
            return ProcessInfo(with: runningApplication)
        }
        if let processlist = self.processes {
            for p in processlist {
                print("\(p.name ?? "Unspecified")\npid:\(p.pid)\n\(p.name ?? "")\n\(p.path)\n")
                print("*-----------------*-----------------*----------------------*\n")
            }
        }
        
    }
    
}
