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
            return ProcessInfo(with: runningApplication)
        }
        //if let processlist = self.processes {
            for p in self.processes {
                print("\(p.name ?? "Unspecified")\npid:\(p.pid)\n\(p.name ?? "")\n\(p.path)\n")
                print("*-----------------*-----------------*----------------------*\n")
            }
        //}
    }
    
    @objc private func appLaunched(_ notification: NSNotification){
     print("Launched: \(notification.userInfo?["NSApplicationName"] ?? "") pid: \(notification.userInfo?["NSApplicationProcessIdentifier"] ?? "")")
        self.fetch()
        self.processLaunched?()
     }
     
     @objc private func appTerminated(_ notification: NSNotification){
         print("Terminated: \(notification.userInfo?["NSApplicationName"] ?? "") pid: \(notification.userInfo?["NSApplicationProcessIdentifier"] ?? "")")
        self.fetch()
        self.processTerminated?()
     }
    
    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
}
