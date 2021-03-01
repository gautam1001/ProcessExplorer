//
//  Extensions.swift
//  ProcessExplorer
//
//  Created by Prashant Gautam on 02/03/21.
//

import Foundation
import AppKit

/// Creates Cell view for process data.
extension NSTableView {
    
    func makeCellView(type: String) -> NSTableCellView?{
       let viewIdentifier = NSUserInterfaceItemIdentifier(rawValue: type)
       return makeView(withIdentifier: viewIdentifier, owner: self) as? NSTableCellView
    }
}

/// Populate process data for a cellview.
class ProcessCellView:NSTableCellView {
    
    func populateUI(with info:String, isSelected:Bool = false){
        self.textField?.stringValue = info
        let rowView = self.superview as? NSTableRowView
        rowView?.isSelected = isSelected
    }
}
