//
//  MulticastDelegate.swift
//  ProcessExplorer
//
//  Created by Prashant on 01/02/21.
//  Copyright © 2021 Prashant. All rights reserved.
//

import Foundation

/// Class to notify more than one object i.e; one to many broadcast
class MulticastDelegate<T> {
    private var delegates = [Weak]()
    
    func add(_ delegate: T) {
        delegates.append(Weak(value: delegate as AnyObject))
    }
    
    func remove(_ delegate: T) {
        let weak = Weak(value: delegate as AnyObject)
        if let index = delegates.firstIndex(of: weak) {
            delegates.remove(at: index)
        }
    }
    
    func invoke(_ invocation: @escaping (T) -> ()) {
        delegates = delegates.filter({$0.value != nil})
        delegates.forEach({
            if let delegate = $0.value as? T {
                invocation(delegate)
            }
        })
    }
}

class Weak: Equatable {
    weak var value: AnyObject?

    init(value: AnyObject) {
        self.value = value
    }
    
    static func ==(lhs: Weak, rhs: Weak) -> Bool {
        return lhs.value === rhs.value
    }
}
