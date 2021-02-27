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
    
    private let cred:process_cred
    
    var isSelected:Bool = false
    
    var name:String? {
        return process.localizedName
    }
    var pid:Int32 {
        return process.processIdentifier
    }

    var userid:UInt32 {
        return cred.uid
    }
    
    var username:String {
        if let p = getpwuid(cred.uid){
           return String(cString: p.pointee.pw_name)
        }
        return ""
    }
    
    var path:String {
        return "\(self.process.executableURL?.absoluteString ?? "")"
    }
    
    var ppid:Int32 {
        return cred.ppid
    }
    
    init(with process:NSRunningApplication) {
        self.process = process
        self.cred = processCred(self.process.processIdentifier)
    }
}
