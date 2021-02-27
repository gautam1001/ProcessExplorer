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
    
    var processes:[ProcessInfo] = []
    var count:Int {
        return self.processes.count
    }
    var processTerminated:(()->())? //= nil
    var processLaunched:(()->())? //= nil
    
    private init(){ }
    
    func notifyAppState(){
        let notificationCenter: NotificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(self, selector: #selector(appLaunched(_:)), name: NSWorkspace.didLaunchApplicationNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appTerminated(_:)), name: NSWorkspace.didTerminateApplicationNotification, object: nil)
    }
    
    func fetch(){
        let apps = NSWorkspace.shared.runningApplications
        self.processes = apps.map{ runningApplication in
            ProcessInfo(with: runningApplication)
        }.filter({ process in
            process.pid != -1
        })
        //if let processlist = self.processes {
            for p in self.processes {
                print("\(p.name ?? "Unspecified")\npid:\(p.pid)\n\(p.name ?? "")\n\(p.path)\n")
                print("*-----------------*-----------------*----------------------*\n")
            }
        //}
    }
    
    @objc private func appLaunched(_ notification: NSNotification){
     print("Launched: \(notification.userInfo?["NSApplicationName"] ?? "") pid: \(notification.userInfo?["NSApplicationProcessIdentifier"] ?? "")")
        if let runningProcess = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication, !self.processes.contains(where: { p in
            p.pid == runningProcess.processIdentifier
        }){
            self.processes.append(ProcessInfo(with: runningProcess))
            self.processLaunched?()
        }
        
     }
     
     @objc private func appTerminated(_ notification: NSNotification){
         print("Terminated: \(notification.userInfo?["NSApplicationName"] ?? "") pid: \(notification.userInfo?["NSApplicationProcessIdentifier"] ?? "")")
        if let pid = notification.userInfo?["NSApplicationProcessIdentifier"] as? Int{
             self.processes.removeAll { p in
                    p.pid == pid
            }
            self.processTerminated?()
        }
     }
    
    func updateSelection(_ pid:pid_t){
        for p in processes {
            if p.pid == pid {
                p.isSelected = true
            }else{
                p.isSelected = false
            }
        }
        
    }
    
    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
}
