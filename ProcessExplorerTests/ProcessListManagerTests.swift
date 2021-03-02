//
//  ProcessListManagerTests.swift
//  ProcessExplorerTests
//
//  Created by Prashant Gautam on 01/03/21.
//

import XCTest
@testable import ProcessExplorer
class ProcessListManagerTests: XCTestCase {
    var listManager:ProcessListManager?
    var processToBeKilled:pid_t = 0
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.listManager = ProcessListManager.shared
    }

    override func tearDown()  {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.listManager = nil
    }

    func testFetch(){
        self.listManager?.fetch()
        guard let count = self.listManager?.count else {
            XCTAssertNil(self.listManager, "List manager instance should be nil.")
            return
        }
        XCTAssertGreaterThan(count, 0, "Process list should be greater than 0.")
    }
    
    func testUpdateSelection(){
        self.testFetch()
        guard let list = self.listManager?.processes else { return }
        self.listManager?.updateSelection(list[1].pid)
        for i in 0..<list.count{
            if i == 1{
                XCTAssertTrue(list[i].isSelected, "Process should be selected")
            }else{
                XCTAssertFalse(list[i].isSelected, "Process should be deselected")
            }
        }
    }
    
    func testProcessKill(){
        self.testFetch()
        guard let processes = self.listManager?.processes else { return }
        self.listManager?.delegates.add(self)
        self.processToBeKilled = processes[0].pid
        self.listManager?.killProcess(pid: processToBeKilled)
    }
}

extension ProcessListManagerTests:ProcessStatusDelegate {
    func processTerminated(_ pid: pid_t) {
        XCTAssertEqual(self.processToBeKilled, pid, "Process should be terminated")
        self.processToBeKilled = 0
        self.listManager?.delegates.remove(self)
    }
    
    
}

