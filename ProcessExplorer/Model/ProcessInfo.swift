//
//  ProcessInfo.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

import Foundation
import Cocoa

class ProcessInfo {
    private let process:NSRunningApplication
    var isSelected:Bool = false
    var name:String? {
        return process.localizedName
    }
    var pid:Int32 {
        return process.processIdentifier
    }
    var userid:UInt32 {
        let uid = uidFromPid(self.process.processIdentifier)
        return uid
    }
    
    var username:String {
        let uid = uidFromPid(self.process.processIdentifier)
        if let p = getpwuid(uid){
           return String(cString: p.pointee.pw_name)
        }
        return ""
    }
    
    var path:String {
        return "\(self.process.executableURL?.absoluteString ?? "")"
    }
    
    init(with process:NSRunningApplication) {
        self.process = process
    }
}
