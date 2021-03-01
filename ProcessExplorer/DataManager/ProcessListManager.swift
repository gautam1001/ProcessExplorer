//
//  ProcessListManager.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Foundation
import Cocoa

protocol ProcessStatusDelegate:class{
    func processTerminated(_ pid:pid_t)
}
class ProcessListManager {
    
    static let shared = ProcessListManager()
    
    var processes:[ProcessInfo] = []
    var count:Int {
        return self.processes.count
    }
    //var processTerminated:((pid_t)->())? //= nil
    var processLaunched:(()->())? //= nil
    var delegates = MulticastDelegate<ProcessStatusDelegate>()
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
    }
    
    @objc private func appLaunched(_ notification: NSNotification){
        if let runningProcess = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication, !self.processes.contains(where: { p in
            p.pid == runningProcess.processIdentifier
        }){
            self.processes.append(ProcessInfo(with: runningProcess))
            self.processLaunched?()
        }
        
    }
    
    @objc private func appTerminated(_ notification: NSNotification){
        if let pid = notification.userInfo?["NSApplicationProcessIdentifier"] as? pid_t{
            self.processes.removeAll { p in
                p.pid == pid
            }
            delegates.invoke { obj in
                obj.processTerminated(pid)
            }
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
    
    func sortProcesses(_ descriptor:NSSortDescriptor){
        if descriptor.key == "process"{
            self.processes.sort { (p1, p2)  in
                (p1.name ?? "").caseInsensitiveCompare(p2.name ?? "") == (descriptor.ascending ? .orderedAscending : .orderedDescending)
            }
        }else{
            self.processes.sort { (p1, p2)  in
                descriptor.ascending ? p2.pid > p1.pid : p1.pid > p2.pid
            }
        }
    }
    
    func killProcess(pid:pid_t){
        if let index = processes.firstIndex (where: { $0.pid == pid }){
            if processes[index].runningProcess.terminate(){
                self.processes.removeAll { p in
                    p.pid == pid
                }
                //self.processTerminated?(pid)
                delegates.invoke { obj in
                    obj.processTerminated(pid)
                }
            }
        }
        
    }
    
    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
}
